package modelo;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public final class ReporteServicio {
    private final ReporteRepositorio repositorio;

    public ReporteServicio(ReporteRepositorio repositorio) {
        this.repositorio = repositorio;
    }

    public ResultadoReporte consultar(TipoReporte tipo, String ruc, String desde, String hasta)
            throws SQLException {
        FiltroReporte filtro = tipo.requiereRango() ? validarFiltro(ruc, desde, hasta) : null;
        return repositorio.consultar(tipo, filtro);
    }

    private FiltroReporte validarFiltro(String ruc, String textoDesde, String textoHasta) {
        String codigo = ruc.strip();
        if (!codigo.matches("[0-9]{11}")) {
            throw new IllegalArgumentException("Escribe un RUC de 11 dígitos.");
        }
        LocalDate desde = leerFecha(textoDesde);
        LocalDate hasta = leerFecha(textoHasta);
        if (desde.isAfter(hasta)) {
            throw new IllegalArgumentException("La fecha inicial debe ser igual o anterior a la final.");
        }
        return new FiltroReporte(codigo, desde, hasta);
    }

    private LocalDate leerFecha(String texto) {
        String fecha = texto.strip();
        if (!fecha.matches("[1-9][0-9]{3}-[0-9]{2}-[0-9]{2}")) {
            throw new IllegalArgumentException("Escribe las fechas en formato AAAA-MM-DD, por ejemplo 2026-08-01.");
        }
        try {
            return LocalDate.parse(fecha);
        } catch (DateTimeParseException ex) {
            throw new IllegalArgumentException("Revisa que ambas fechas existan en el calendario.", ex);
        }
    }
}