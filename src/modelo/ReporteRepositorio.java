package modelo;

import java.sql.SQLException;

public interface ReporteRepositorio {
    ResultadoReporte consultar(TipoReporte tipo, FiltroReporte filtro) throws SQLException;
}