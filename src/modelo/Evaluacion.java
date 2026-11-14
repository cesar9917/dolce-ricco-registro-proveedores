package modelo;

public enum Evaluacion {
    APROBADO("Aprobado"), OBSERVADO("Observado"), RECHAZADO("Rechazado");

    private final String etiqueta;

    Evaluacion(String etiqueta) {
        this.etiqueta = etiqueta;
    }

    public static Evaluacion desdeBD(String valor) {
        for (var evaluacion : values()) {
            if (evaluacion.etiqueta.equalsIgnoreCase(valor)) {
                return evaluacion;
            }
        }
        throw new IllegalArgumentException("Evaluación desconocida: " + valor);
    }

    @Override
    public String toString() {
        return etiqueta;
    }
}