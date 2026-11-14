package modelo;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import conexion.ConexionMySql;

public final class ProveedorJdbcRepositorio implements ProveedorRepositorio {
    private final ConexionMySql conexion;

    public ProveedorJdbcRepositorio(ConexionMySql conexion) {
        this.conexion = conexion;
    }

    @Override
    public List<Proveedor> buscar(String texto, EstadoProveedor estado) throws SQLException {
        List<Proveedor> proveedores = new ArrayList<>();
        try (var db = conexion.abrir();
             var llamada = db.prepareCall("{call sp_buscar_proveedores(?, ?)}")) {
            llamada.setString(1, texto);
            llamada.setString(2, estado == null ? null : estado.toString());
            try (var filas = llamada.executeQuery()) {
                while (filas.next()) {
                    var datos = new DatosProveedor(filas.getString("RUC_Prov"), filas.getString("RazonSocial"),
                            filas.getString("Direcc"), Evaluacion.desdeBD(filas.getString("Evaluacion")),
                            filas.getString("DNI"));
                    proveedores.add(new Proveedor(datos, EstadoProveedor.desdeBD(filas.getString("Estado")),
                            filas.getString("Evaluador")));
                }
            }
        }
        return List.copyOf(proveedores);
    }

    @Override
    public List<Evaluador> listarEvaluadores() throws SQLException {
        List<Evaluador> evaluadores = new ArrayList<>();
        try (var db = conexion.abrir();
             var llamada = db.prepareCall("{call sp_listar_evaluadores()}");
             var filas = llamada.executeQuery()) {
            while (filas.next()) {
                evaluadores.add(new Evaluador(filas.getString("DNI"), filas.getString("NomCompleto")));
            }
        }
        return List.copyOf(evaluadores);
    }

    @Override
    public void registrar(DatosProveedor datos) throws SQLException {
        guardar("{call sp_registrar_proveedor(?, ?, ?, ?, ?)}", datos);
    }

    @Override
    public void editar(DatosProveedor datos) throws SQLException {
        guardar("{call sp_editar_proveedor(?, ?, ?, ?, ?)}", datos);
    }

    private void guardar(String procedimiento, DatosProveedor datos) throws SQLException {
        try (var db = conexion.abrir();
             var llamada = db.prepareCall(procedimiento)) {
            llamada.setString(1, datos.ruc());
            llamada.setString(2, datos.razonSocial());
            llamada.setString(3, datos.direccion());
            llamada.setString(4, datos.evaluacion().toString());
            llamada.setString(5, datos.dniEvaluador());
            llamada.execute();
        }
    }

    @Override
    public void cambiarEstado(String ruc, EstadoProveedor estado) throws SQLException {
        String procedimiento = switch (estado) {
            case ACTIVO -> "{call sp_reactivar_proveedor(?)}";
            case INACTIVO -> "{call sp_desactivar_proveedor(?)}";
        };
        try (var db = conexion.abrir();
             var llamada = db.prepareCall(procedimiento)) {
            llamada.setString(1, ruc);
            llamada.execute();
        }
    }
}