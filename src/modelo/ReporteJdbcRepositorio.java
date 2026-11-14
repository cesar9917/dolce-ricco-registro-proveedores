package modelo;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import conexion.ConexionMySql;

public final class ReporteJdbcRepositorio implements ReporteRepositorio {
    private final ConexionMySql conexion;

    public ReporteJdbcRepositorio(ConexionMySql conexion) {
        this.conexion = conexion;
    }

    @Override
    public ResultadoReporte consultar(TipoReporte tipo, FiltroReporte filtro) throws SQLException {
        String procedimiento = switch (tipo) {
            case PROVEEDORES_ACTIVOS -> "{call sp_r01_proveedores_activos()}";
            case PRODUCTOS_POR_PROVEEDOR -> "{call sp_r02_productos_por_proveedor()}";
            case COMPRAS_POR_PROVEEDOR -> "{call sp_r03_compras_por_proveedor()}";
            case COMPRAS_POR_MES -> "{call sp_r04_compras_por_mes()}";
            case FACTURAS_POR_PROVEEDOR -> "{call sp_r05_facturas_por_proveedor(?, ?, ?)}";
            case PROVEEDORES_SIN_COMPRAS -> "{call sp_r06_proveedores_sin_compras()}";
            case ALERTAS_HACCP -> "{call sp_r07_alertas_haccp()}";
            case ALERTAS_SANITARIAS -> "{call sp_r08_alertas_sanitarias()}";
            case DOCUMENTACION_INCOMPLETA -> "{call sp_r09_documentacion_incompleta()}";
            case PRODUCTOS_VARIOS_PROVEEDORES -> "{call sp_r10_productos_varios_proveedores()}";
            case FACTURAS_CREDITO -> "{call sp_r11_facturas_credito()}";
            case EVALUADORES -> "{call sp_r12_evaluadores()}";
        };
        try (var db = conexion.abrir();
             var llamada = db.prepareCall(procedimiento)) {
            if (tipo.requiereRango()) {
                llamada.setString(1, filtro.ruc());
                llamada.setObject(2, filtro.desde());
                llamada.setObject(3, filtro.hasta());
            }
            try (var resultado = llamada.executeQuery()) {
                var metadatos = resultado.getMetaData();
                int totalColumnas = metadatos.getColumnCount();
                List<String> columnas = new ArrayList<>(totalColumnas);
                for (int i = 1; i <= totalColumnas; i++) {
                    columnas.add(metadatos.getColumnLabel(i));
                }

                List<List<Object>> filas = new ArrayList<>();
                while (resultado.next()) {
                    List<Object> fila = new ArrayList<>(totalColumnas);
                    for (int i = 1; i <= totalColumnas; i++) {
                        fila.add(Objects.requireNonNullElse(resultado.getObject(i), ""));
                    }
                    filas.add(fila);
                }
                return new ResultadoReporte(columnas, filas);
            }
        }
    }
}