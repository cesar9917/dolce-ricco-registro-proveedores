package conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class ConexionMySql {
    private final ConfiguracionBD configuracion;

    public ConexionMySql(ConfiguracionBD configuracion) {
        this.configuracion = configuracion;
    }

    public Connection abrir() throws SQLException {
        return DriverManager.getConnection(configuracion.url(), configuracion.usuario(), configuracion.clave());
    }
}