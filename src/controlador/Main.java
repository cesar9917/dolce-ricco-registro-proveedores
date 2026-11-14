package controlador;

import java.io.IOException;
import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import conexion.ConexionMySql;
import conexion.ConfiguracionBD;
import modelo.ProveedorJdbcRepositorio;
import modelo.ReporteJdbcRepositorio;
import modelo.ProveedorServicio;
import modelo.ReporteServicio;
import vista.ProveedorPanel;
import vista.ReportesPanel;
import vista.VentanaPrincipal;

public final class Main {
    private Main() {
    }

    public static void main(String[] args) {
        try {
            ConfiguracionBD configuracion = ConfiguracionBD.cargar();
            SwingUtilities.invokeLater(() -> iniciar(configuracion));
        } catch (IOException | IllegalArgumentException ex) {
            SwingUtilities.invokeLater(() -> JOptionPane.showMessageDialog(null,
                    "Revisa el archivo db.properties y vuelve a abrir el aplicativo.\n" + ex.getMessage(),
                    "Configuración de MySQL", JOptionPane.ERROR_MESSAGE));
        }
    }

    private static void iniciar(ConfiguracionBD configuracion) {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (ReflectiveOperationException | UnsupportedLookAndFeelException ex) {
            // Si el tema del sistema no está disponible, se conserva el de Swing.
        }

        var conexion = new ConexionMySql(configuracion);
        var proveedores = new ProveedorPanel();
        var reportes = new ReportesPanel();
        var proveedorServicio = new ProveedorServicio(new ProveedorJdbcRepositorio(conexion));
        var reporteServicio = new ReporteServicio(new ReporteJdbcRepositorio(conexion));
        var controlador = new ProveedorControlador(proveedores, proveedorServicio);
        new ReportesControlador(reportes, reporteServicio);

        new VentanaPrincipal(proveedores, reportes).setVisible(true);
        controlador.iniciar();
    }
}