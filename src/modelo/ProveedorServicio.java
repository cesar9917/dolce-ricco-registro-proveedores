package modelo;

import java.sql.SQLException;
import java.util.List;

public final class ProveedorServicio {
    private final ProveedorRepositorio repositorio;

    public ProveedorServicio(ProveedorRepositorio repositorio) {
        this.repositorio = repositorio;
    }

    public List<Proveedor> buscar(String texto, EstadoProveedor estado) throws SQLException {
        String consulta = texto.strip();
        if (consulta.codePointCount(0, consulta.length()) > 100) {
            throw new IllegalArgumentException("La búsqueda admite hasta 100 caracteres.");
        }
        return repositorio.buscar(consulta, estado);
    }

    public List<Evaluador> listarEvaluadores() throws SQLException {
        return repositorio.listarEvaluadores();
    }

    public void registrar(DatosProveedor datos) throws SQLException {
        repositorio.registrar(validar(datos));
    }

    public void editar(DatosProveedor datos) throws SQLException {
        repositorio.editar(validar(datos));
    }

    public void cambiarEstado(String ruc, EstadoProveedor estado) throws SQLException {
        validarRuc(ruc);
        repositorio.cambiarEstado(ruc, estado);
    }

    private DatosProveedor validar(DatosProveedor datos) {
        String ruc = datos.ruc().strip();
        validarRuc(ruc);
        String razon = textoObligatorio(datos.razonSocial(), 100, "La razón social");
        String direccion = textoObligatorio(datos.direccion(), 150, "La dirección");
        if (datos.evaluacion() == null) {
            throw new IllegalArgumentException("Selecciona el resultado de la evaluación.");
        }
        String dni = datos.dniEvaluador();
        if (dni == null || !dni.matches("[0-9]{8}")) {
            throw new IllegalArgumentException("Selecciona un evaluador.");
        }
        return new DatosProveedor(ruc, razon, direccion, datos.evaluacion(), dni);
    }

    private static void validarRuc(String ruc) {
        if (!ruc.matches("[0-9]{11}")) {
            throw new IllegalArgumentException("El RUC debe contener 11 dígitos.");
        }
    }

    private static String textoObligatorio(String valor, int maximo, String etiqueta) {
        String texto = valor.strip();
        if (texto.isEmpty() || texto.codePointCount(0, texto.length()) > maximo) {
            throw new IllegalArgumentException(etiqueta + " debe tener entre 1 y " + maximo + " caracteres.");
        }
        return texto;
    }
}