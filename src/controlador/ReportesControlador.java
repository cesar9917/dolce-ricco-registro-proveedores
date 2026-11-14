package controlador;

import modelo.ReporteServicio;
import vista.ReportesPanel;

public final class ReportesControlador {
    private final ReportesPanel vista;
    private final ReporteServicio servicio;

    public ReportesControlador(ReportesPanel vista, ReporteServicio servicio) {
        this.vista = vista;
        this.servicio = servicio;
        vista.alConsultar(evento -> consultar());
    }

    private void consultar() {
        var tipo = vista.tipo();
        String ruc = vista.ruc();
        String desde = vista.desde();
        String hasta = vista.hasta();

        vista.setOcupado(true);
        vista.limpiarResultado();
        vista.mostrarEstado("Consultando reporte…");
        TareaSwing.ejecutar(() -> servicio.consultar(tipo, ruc, desde, hasta), resultado -> {
            vista.mostrarResultado(resultado);
            vista.mostrarEstado(resultado.filas().isEmpty() ? "Sin resultados para esta consulta."
                    : resultado.filas().size() + " fila(s).");
        }, error -> {
            vista.mostrarEstado("No se pudo cargar el reporte.");
            TareaSwing.mostrarError(vista, error);
        }, () -> vista.setOcupado(false));
    }
}