USE registro_proveedores;

-- El historial conserva los datos tal como estaban al momento de cada cambio.
CREATE TABLE IF NOT EXISTS Proveedor_Auditoria (
    Id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    RUC_Prov        CHAR(11) NOT NULL,
    Accion          ENUM('ALTA', 'EDICION', 'BAJA_LOGICA', 'REACTIVACION') NOT NULL,
    Fecha           TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    Usuario_BD      VARCHAR(288) NOT NULL,
    Datos_Anteriores JSON NULL,
    Datos_Nuevos     JSON NOT NULL,
    INDEX idx_auditoria_ruc_fecha (RUC_Prov, Fecha)
) ENGINE=InnoDB;

DROP TRIGGER IF EXISTS trg_proveedor_alta;
DROP TRIGGER IF EXISTS trg_proveedor_cambio;

DELIMITER $$

CREATE TRIGGER trg_proveedor_alta
AFTER INSERT ON Proveedor
FOR EACH ROW
BEGIN
    INSERT INTO Proveedor_Auditoria (RUC_Prov, Accion, Usuario_BD, Datos_Nuevos)
    VALUES (NEW.RUC_Prov, 'ALTA', USER(),
            JSON_OBJECT('razonSocial', NEW.RazonSocial, 'direccion', NEW.Direcc,
                        'estado', NEW.Estado, 'evaluacion', NEW.Evaluacion, 'dniEvaluador', NEW.DNI));
END$$

-- La baja lógica y la reactivación son UPDATE sobre Estado.
CREATE TRIGGER trg_proveedor_cambio
AFTER UPDATE ON Proveedor
FOR EACH ROW
BEGIN
    IF NOT (CAST(OLD.RazonSocial AS BINARY) <=> CAST(NEW.RazonSocial AS BINARY))
       OR NOT (CAST(OLD.Direcc AS BINARY) <=> CAST(NEW.Direcc AS BINARY))
       OR NOT (CAST(OLD.Evaluacion AS BINARY) <=> CAST(NEW.Evaluacion AS BINARY))
       OR NOT (OLD.DNI <=> NEW.DNI)
       OR NOT (CAST(OLD.Estado AS BINARY) <=> CAST(NEW.Estado AS BINARY)) THEN
        INSERT INTO Proveedor_Auditoria
            (RUC_Prov, Accion, Usuario_BD, Datos_Anteriores, Datos_Nuevos)
        VALUES (NEW.RUC_Prov,
                CASE
                    WHEN OLD.Estado <> NEW.Estado AND NEW.Estado = 'Inactivo' THEN 'BAJA_LOGICA'
                    WHEN OLD.Estado <> NEW.Estado AND NEW.Estado = 'Activo' THEN 'REACTIVACION'
                    ELSE 'EDICION'
                END,
                USER(),
                JSON_OBJECT('razonSocial', OLD.RazonSocial, 'direccion', OLD.Direcc,
                            'estado', OLD.Estado, 'evaluacion', OLD.Evaluacion, 'dniEvaluador', OLD.DNI),
                JSON_OBJECT('razonSocial', NEW.RazonSocial, 'direccion', NEW.Direcc,
                            'estado', NEW.Estado, 'evaluacion', NEW.Evaluacion, 'dniEvaluador', NEW.DNI));
    END IF;
END$$

DELIMITER ;