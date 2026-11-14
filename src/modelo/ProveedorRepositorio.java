package modelo;

import java.sql.SQLException;
import java.util.List;

public interface ProveedorRepositorio {
    List<Proveedor> buscar(String texto, EstadoProveedor estado) throws SQLException;
    List<Evaluador> listarEvaluadores() throws SQLException;
    void registrar(DatosProveedor datos) throws SQLException;
    void editar(DatosProveedor datos) throws SQLException;
    void cambiarEstado(String ruc, EstadoProveedor estado) throws SQLException;
}