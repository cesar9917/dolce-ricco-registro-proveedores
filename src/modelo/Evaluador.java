package modelo;

public record Evaluador(String dni, String nombre) {
    @Override
    public String toString() {
        return nombre + " (" + dni + ")";
    }
}