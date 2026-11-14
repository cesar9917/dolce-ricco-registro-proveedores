package controlador;

import java.sql.SQLException;
import java.util.List;
import modelo.DatosProveedor;
import modelo.EstadoProveedor;
import modelo.Evaluador;
import modelo.Proveedor;
import modelo.ProveedorServicio;
import vista.ProveedorDialogo;
import vista.ProveedorPanel;

public final class ProveedorControlador {
    private final ProveedorPanel vista;
    private final ProveedorServicio servicio;

    public ProveedorControlador(ProveedorPanel vista, ProveedorServicio servicio) {
        this.vista = vista;
        this.servicio = servicio;
        vista.alBuscar(evento -> listar(""));
        vista.alRegistrar(evento -> abrirFormulario(null));
        vista.alEditar(evento -> vista.proveedorSeleccionado()
                .ifPresent(proveedor -> abrirFormulario(proveedor.datos())));
        vista.alCambiarEstado(evento -> vista.proveedorSeleccionado().ifPresent(this::cambiarEstado));
    }

    public void iniciar() {
        listar("");
    }

    private void listar(String mensaje) {
        String texto = vista.textoBusqueda();
        EstadoProveedor filtro = vista.estadoSeleccionado();
        vista.setOcupado(true);
        vista.mostrarEstado(mensaje + "Cargando proveedores…");
        TareaSwing.ejecutar(() -> servicio.buscar(texto, filtro), proveedores -> {
            vista.mostrarProveedores(proveedores);
            vista.mostrarEstado(mensaje + proveedores.size() + " proveedor(es).");
        }, error -> {
            vista.mostrarEstado(mensaje + "No se pudo actualizar la lista.");
            TareaSwing.mostrarError(vista, error);
        }, () -> vista.setOcupado(false));
    }

    private void abrirFormulario(DatosProveedor inicial) {
        vista.setOcupado(true);
        vista.mostrarEstado("Cargando evaluadores…");
        TareaSwing.ejecutar(servicio::listarEvaluadores, evaluadores -> {
            vista.mostrarEstado(" ");
            if (evaluadores.isEmpty()) {
                TareaSwing.mostrarError(vista, new IllegalArgumentException(
                        "Carga al menos un evaluador en MySQL antes de registrar proveedores."));
                return;
            }
            capturarDatos(evaluadores, inicial != null, inicial);
        }, error -> {
            vista.mostrarEstado("No se pudieron cargar los evaluadores.");
            TareaSwing.mostrarError(vista, error);
        }, () -> vista.setOcupado(false));
    }

    private void capturarDatos(List<Evaluador> evaluadores, boolean edicion, DatosProveedor inicial) {
        ProveedorDialogo.solicitar(vista, evaluadores, edicion, inicial).ifPresent(datos -> {
            String mensaje = edicion ? "Proveedor actualizado. " : "Proveedor registrado. ";
            guardar(() -> {
                if (edicion) {
                    servicio.editar(datos);
                } else {
                    servicio.registrar(datos);
                }
            }, mensaje, error -> {
                if (error instanceof IllegalArgumentException ||
                        (error instanceof SQLException sql && sql.getErrorCode() == 1062)) {
                    capturarDatos(evaluadores, edicion, datos);
                }
            });
        });
    }

    private void cambiarEstado(Proveedor proveedor) {
        EstadoProveedor destino = proveedor.estado() == EstadoProveedor.ACTIVO
                ? EstadoProveedor.INACTIVO : EstadoProveedor.ACTIVO;
        if (vista.confirmarCambio(proveedor, destino)) {
            String mensaje = destino == EstadoProveedor.INACTIVO
                    ? "Proveedor desactivado. " : "Proveedor reactivado. ";
            guardar(() -> servicio.cambiarEstado(proveedor.datos().ruc(), destino), mensaje, error -> {});
        }
    }

    private void guardar(Cambio cambio, String mensaje, java.util.function.Consumer<Throwable> despuesDelError) {
        vista.setOcupado(true);
        vista.mostrarEstado("Guardando cambios…");
        TareaSwing.ejecutar(() -> {
            cambio.aplicar();
            return null;
        }, ignorado -> listar(mensaje), error -> {
            vista.mostrarEstado("No se pudo confirmar el cambio. Puedes volver a buscar para verificar el estado.");
            TareaSwing.mostrarError(vista, error);
            despuesDelError.accept(error);
        }, () -> vista.setOcupado(false));
    }

    @FunctionalInterface
    private interface Cambio {
        void aplicar() throws SQLException;
    }
}