package modelo;

import java.util.List;

public record ResultadoReporte(List<String> columnas, List<List<Object>> filas) {
    public ResultadoReporte {
        columnas = List.copyOf(columnas);
        filas = filas.stream().map(List::copyOf).toList();
    }
}