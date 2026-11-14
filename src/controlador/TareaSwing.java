package controlador;

import java.sql.SQLException;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.function.Consumer;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JComponent;
import javax.swing.JOptionPane;
import javax.swing.SwingWorker;

/** Ejecuta I/O en un trabajador y devuelve los resultados al hilo de Swing. */
final class TareaSwing {
    private static final Logger LOG = Logger.getLogger(TareaSwing.class.getName());

    private TareaSwing() {
    }

    static <T> void ejecutar(Callable<T> trabajo, Consumer<T> resultado, Consumer<Throwable> fallo,
                             Runnable liberar) {
        new SwingWorker<T, Void>() {
            @Override
            protected T doInBackground() throws Exception {
                return trabajo.call();
            }

            @Override
            protected void done() {
                try {
                    T valor = get();
                    liberar.run();
                    resultado.accept(valor);
                } catch (ExecutionException ex) {
                    liberar.run();
                    fallo.accept(ex.getCause());
                } catch (InterruptedException ex) {
                    Thread.currentThread().interrupt();
                    liberar.run();
                    fallo.accept(ex);
                }
            }
        }.execute();
    }

    static void mostrarError(JComponent vista, Throwable fallo) {
        String mensaje;
        if (fallo instanceof IllegalArgumentException) {
            mensaje = fallo.getMessage();
        } else if (fallo instanceof SQLException sql) {
            mensaje = switch (sql.getErrorCode()) {
                case 1062 -> "Ya existe un proveedor con ese RUC.";
                case 1452 -> "El evaluador seleccionado ya no está disponible.";
                case 1044, 1045, 1370 -> "Revisa el usuario, la contraseña y los permisos en MySQL.";
                case 1049, 1146, 1305 -> "Verifica que hayas ejecutado los scripts 01 a 04 en la base configurada.";
                case 1644 -> sql.getMessage();
                default -> mensajeConexion(sql);
            };
            if (sql.getErrorCode() != 1062 && sql.getErrorCode() != 1452 && sql.getErrorCode() != 1644) {
                LOG.log(Level.WARNING, "Error de MySQL. Código {0}; SQLSTATE {1}",
                        new Object[]{sql.getErrorCode(), sql.getSQLState()});
            }
        } else {
            LOG.log(Level.WARNING, "Error al realizar la operación", fallo);
            mensaje = "Ocurrió un error al realizar la operación. Revisa la consola de Eclipse.";
        }
        JOptionPane.showMessageDialog(vista, mensaje, "Dolce & Ricco", JOptionPane.ERROR_MESSAGE);
    }

    private static String mensajeConexion(SQLException error) {
        if (error.getMessage() != null && error.getMessage().contains("No suitable driver")) {
            return "Agrega mysql-connector-j-9.5.0.jar al Classpath del proyecto.";
        }
        if (error.getSQLState() != null && error.getSQLState().startsWith("08")) {
            return "No se pudo conectar a MySQL. Revisa que esté iniciado, además del host y el puerto.";
        }
        return "MySQL devolvió un error. Revisa la consola de Eclipse (SQLSTATE " + error.getSQLState() + ").";
    }
}