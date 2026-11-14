USE registro_proveedores;

DROP PROCEDURE IF EXISTS sp_listar_evaluadores;
DROP PROCEDURE IF EXISTS sp_buscar_proveedores;
DROP PROCEDURE IF EXISTS sp_registrar_proveedor;
DROP PROCEDURE IF EXISTS sp_editar_proveedor;
DROP PROCEDURE IF EXISTS sp_desactivar_proveedor;
DROP PROCEDURE IF EXISTS sp_reactivar_proveedor;

DELIMITER $$

CREATE PROCEDURE sp_listar_evaluadores()
    READS SQL DATA
BEGIN
    SELECT DNI, NomCompleto FROM Evaluador ORDER BY NomCompleto, DNI;
END$$

-- Un texto vacío devuelve todos los registros del estado seleccionado.
CREATE PROCEDURE sp_buscar_proveedores(IN p_texto VARCHAR(100), IN p_estado VARCHAR(10))
    READS SQL DATA
BEGIN
    -- Escapa los comodines de LIKE para que el texto se busque literalmente.
    DECLARE patron VARCHAR(202);
    SET patron = CONCAT('%', REPLACE(REPLACE(REPLACE(TRIM(p_texto),
                         '!', '!!'), '%', '!%'), '_', '!_'), '%');

    SELECT p.RUC_Prov, p.RazonSocial, p.Direcc, p.Estado, p.Evaluacion,
           p.DNI, e.NomCompleto AS Evaluador
    FROM Proveedor p
    JOIN Evaluador e ON e.DNI = p.DNI
    WHERE (p_estado IS NULL OR p.Estado = p_estado)
      AND (COALESCE(TRIM(p_texto), '') = ''
           OR p.RUC_Prov LIKE patron ESCAPE '!'
           OR p.RazonSocial LIKE patron ESCAPE '!')
    ORDER BY p.RazonSocial, p.RUC_Prov;
END$$

CREATE PROCEDURE sp_registrar_proveedor(
    IN p_ruc CHAR(11), IN p_razon VARCHAR(100), IN p_direccion VARCHAR(150),
    IN p_evaluacion VARCHAR(15), IN p_dni CHAR(8))
    MODIFIES SQL DATA
BEGIN
    IF COALESCE(TRIM(p_razon), '') = '' OR COALESCE(TRIM(p_direccion), '') = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La razón social y la dirección son obligatorias.';
    END IF;

    INSERT INTO Proveedor (RUC_Prov, RazonSocial, Direcc, Estado, Evaluacion, DNI)
    VALUES (p_ruc, TRIM(p_razon), TRIM(p_direccion), 'Activo', p_evaluacion, p_dni);
END$$

CREATE PROCEDURE sp_editar_proveedor(
    IN p_ruc CHAR(11), IN p_razon VARCHAR(100), IN p_direccion VARCHAR(150),
    IN p_evaluacion VARCHAR(15), IN p_dni CHAR(8))
    MODIFIES SQL DATA
BEGIN
    IF COALESCE(TRIM(p_razon), '') = '' OR COALESCE(TRIM(p_direccion), '') = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La razón social y la dirección son obligatorias.';
    END IF;

    UPDATE Proveedor
    SET RazonSocial = TRIM(p_razon), Direcc = TRIM(p_direccion),
        Evaluacion = p_evaluacion, DNI = p_dni
    WHERE RUC_Prov = p_ruc;

    IF ROW_COUNT() = 0 AND NOT EXISTS (SELECT 1 FROM Proveedor WHERE RUC_Prov = p_ruc) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proveedor no existe.';
    END IF;
END$$

CREATE PROCEDURE sp_desactivar_proveedor(IN p_ruc CHAR(11))
    MODIFIES SQL DATA
BEGIN
    UPDATE Proveedor SET Estado = 'Inactivo' WHERE RUC_Prov = p_ruc AND Estado = 'Activo';
    IF ROW_COUNT() = 0 AND NOT EXISTS (SELECT 1 FROM Proveedor WHERE RUC_Prov = p_ruc) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proveedor no existe.';
    END IF;
END$$

CREATE PROCEDURE sp_reactivar_proveedor(IN p_ruc CHAR(11))
    MODIFIES SQL DATA
BEGIN
    UPDATE Proveedor SET Estado = 'Activo' WHERE RUC_Prov = p_ruc AND Estado = 'Inactivo';
    IF ROW_COUNT() = 0 AND NOT EXISTS (SELECT 1 FROM Proveedor WHERE RUC_Prov = p_ruc) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proveedor no existe.';
    END IF;
END$$

DELIMITER ;