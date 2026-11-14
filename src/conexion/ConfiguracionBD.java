package conexion;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Properties;

public record ConfiguracionBD(String url, String usuario, String clave) {
    @Override
    public String toString() {
        return "Configuración de conexión a MySQL";
    }

    public static ConfiguracionBD cargar() throws IOException {
        Path archivo = Path.of(System.getProperty("dolcericco.config", "db.properties"));
        Properties valores = new Properties();
        try (var lector = Files.newBufferedReader(archivo)) {
            valores.load(lector);
        }
        String url = valores.getProperty("db.url", "").strip();
        String usuario = valores.getProperty("db.user", "").strip();
        if (!url.startsWith("jdbc:mysql://") || usuario.isEmpty()) {
            throw new IllegalArgumentException("Revisa db.url y db.user en " + archivo.toAbsolutePath());
        }
        return new ConfiguracionBD(url, usuario, valores.getProperty("db.password", ""));
    }
}