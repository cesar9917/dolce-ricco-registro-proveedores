package modelo;

public enum EstadoProveedor {
    ACTIVO("Activo"), INACTIVO("Inactivo");

    private final String etiqueta;

    EstadoProveedor(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public static EstadoProveedor desdeBD(String valor) {
        for (var estado : values()) {
            if (estado.etiqueta.equalsIgnoreCase(valor)) {
                return estado;
            }
        }
        throw new IllegalArgumentException("Estado de proveedor desconocido: " + valor);
    }

    @Override
    public String toString() {
        return etiqueta;
    }
}