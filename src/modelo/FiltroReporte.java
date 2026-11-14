package modelo;

import java.time.LocalDate;

public record FiltroReporte(String ruc, LocalDate desde, LocalDate hasta) {
}