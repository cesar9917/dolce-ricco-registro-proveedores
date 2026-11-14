USE registro_proveedores;

DROP PROCEDURE IF EXISTS sp_r01_proveedores_activos;
DROP PROCEDURE IF EXISTS sp_r02_productos_por_proveedor;
DROP PROCEDURE IF EXISTS sp_r03_compras_por_proveedor;
DROP PROCEDURE IF EXISTS sp_r04_compras_por_mes;
DROP PROCEDURE IF EXISTS sp_r05_facturas_por_proveedor;
DROP PROCEDURE IF EXISTS sp_r06_proveedores_sin_compras;
DROP PROCEDURE IF EXISTS sp_r07_alertas_haccp;
DROP PROCEDURE IF EXISTS sp_r08_alertas_sanitarias;
DROP PROCEDURE IF EXISTS sp_r09_documentacion_incompleta;
DROP PROCEDURE IF EXISTS sp_r10_productos_varios_proveedores;
DROP PROCEDURE IF EXISTS sp_r11_facturas_credito;
DROP PROCEDURE IF EXISTS sp_r12_evaluadores;

DELIMITER $$

CREATE PROCEDURE sp_r01_proveedores_activos()
    READS SQL DATA
BEGIN
    SELECT p.RUC_Prov AS RUC, p.RazonSocial AS `Razón social`,
           p.Evaluacion AS Evaluación, e.NomCompleto AS Evaluador
    FROM Proveedor p
    JOIN Evaluador e ON e.DNI = p.DNI
    WHERE p.Estado = 'Activo'
    ORDER BY p.RazonSocial, p.RUC_Prov;
END$$

CREATE PROCEDURE sp_r02_productos_por_proveedor()
    READS SQL DATA
BEGIN
    SELECT p.RUC_Prov AS RUC, p.RazonSocial AS Proveedor, pr.Cod_Produc AS Código,
           pr.Descripcion AS Producto, pr.Unidad_Venta AS Unidad
    FROM Proveedor p
    JOIN Suministra s ON s.Ruc_Prov = p.RUC_Prov
    JOIN Producto pr ON pr.Cod_Produc = s.Cod_Produ
    WHERE p.Estado = 'Activo' AND p.Evaluacion = 'Aprobado'
    ORDER BY p.RazonSocial, pr.Descripcion, pr.Cod_Produc;
END$$

CREATE PROCEDURE sp_r03_compras_por_proveedor()
    READS SQL DATA
BEGIN
    SELECT p.RUC_Prov AS RUC, p.RazonSocial AS Proveedor, f.Moneda,
           COUNT(*) AS Facturas, SUM(f.Impor_Total) AS `Total comprado`
    FROM Proveedor p
    JOIN Factura f ON f.Ruc_prov = p.RUC_Prov
    GROUP BY p.RUC_Prov, p.RazonSocial, f.Moneda
    ORDER BY f.Moneda, `Total comprado` DESC, p.RUC_Prov;
END$$

CREATE PROCEDURE sp_r04_compras_por_mes()
    READS SQL DATA
BEGIN
    SELECT DATE_FORMAT(Fec_Emision, '%Y-%m') AS Mes, Moneda,
           COUNT(*) AS Facturas, SUM(Impor_Total) AS `Total del mes`
    FROM Factura
    GROUP BY DATE_FORMAT(Fec_Emision, '%Y-%m'), Moneda
    ORDER BY Mes, Moneda;
END$$

CREATE PROCEDURE sp_r05_facturas_por_proveedor(IN p_ruc CHAR(11), IN p_desde DATE, IN p_hasta DATE)
    READS SQL DATA
BEGIN
    IF p_ruc IS NULL OR p_ruc NOT REGEXP '^[0-9]{11}$'
       OR p_desde IS NULL OR p_hasta IS NULL OR p_desde > p_hasta THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Indica un RUC y un rango de fechas válido.';
    END IF;

    SELECT f.Numfac AS Factura, f.Fec_Emision AS Emisión, f.Moneda,
           f.Condi_Pago AS Pago, f.Val_Total AS Subtotal, f.IGV, f.Impor_Total AS Total
    FROM Factura f
    WHERE f.Ruc_prov = p_ruc AND f.Fec_Emision BETWEEN p_desde AND p_hasta
    ORDER BY f.Fec_Emision, f.Numfac;
END$$

CREATE PROCEDURE sp_r06_proveedores_sin_compras()
    READS SQL DATA
BEGIN
    SELECT p.RUC_Prov AS RUC, p.RazonSocial AS Proveedor, p.Estado, p.Evaluacion AS Evaluación
    FROM Proveedor p
    LEFT JOIN Factura f ON f.Ruc_prov = p.RUC_Prov
    WHERE f.Numfac IS NULL
    ORDER BY p.RazonSocial, p.RUC_Prov;
END$$

CREATE PROCEDURE sp_r07_alertas_haccp()
    READS SQL DATA
BEGIN
    SELECT p.RUC_Prov AS RUC, p.RazonSocial AS Proveedor, h.CodHaccp AS Código,
           h.Linea_Produc AS `Línea de producto`, h.Vigencia,
           DATEDIFF(h.Vigencia, CURDATE()) AS `Días restantes`
    FROM Haccp h
    JOIN Proveedor p ON p.RUC_Prov = h.Ruc_Prov
    WHERE h.Vigencia <= DATE_ADD(CURDATE(), INTERVAL 90 DAY)
    ORDER BY h.Vigencia, h.CodHaccp;
END$$

CREATE PROCEDURE sp_r08_alertas_sanitarias()
    READS SQL DATA
BEGIN
    SELECT p.RUC_Prov AS RUC, p.RazonSocial AS Proveedor, r.Num_Reg_San AS Registro,
           r.Produc_Regis AS Producto, r.Vigencia,
           DATEDIFF(r.Vigencia, CURDATE()) AS `Días restantes`
    FROM RegistroSanitario r
    JOIN Proveedor p ON p.RUC_Prov = r.Ruc_Prov
    WHERE r.Vigencia <= DATE_ADD(CURDATE(), INTERVAL 90 DAY)
    ORDER BY r.Vigencia, r.Num_Reg_San;
END$$

CREATE PROCEDURE sp_r09_documentacion_incompleta()
    READS SQL DATA
BEGIN
    SELECT RUC, Proveedor, Estado,
           IF(tiene_ficha, 'Sí', 'Falta') AS `Ficha técnica`,
           IF(tiene_registro, 'Sí', 'Falta') AS `Registro sanitario`,
           IF(tiene_haccp, 'Sí', 'Falta') AS HACCP
    FROM (
        SELECT p.RUC_Prov AS RUC, p.RazonSocial AS Proveedor, p.Estado,
               EXISTS (SELECT 1 FROM FichaTecnica ft WHERE ft.Ruc_Prov = p.RUC_Prov) AS tiene_ficha,
               EXISTS (SELECT 1 FROM RegistroSanitario rs WHERE rs.Ruc_Prov = p.RUC_Prov) AS tiene_registro,
               EXISTS (SELECT 1 FROM Haccp h WHERE h.Ruc_Prov = p.RUC_Prov) AS tiene_haccp
        FROM Proveedor p
    ) AS documentos
    WHERE NOT tiene_ficha OR NOT tiene_registro OR NOT tiene_haccp
    ORDER BY Proveedor, RUC;
END$$

CREATE PROCEDURE sp_r10_productos_varios_proveedores()
    READS SQL DATA
BEGIN
    SELECT pr.Cod_Produc AS Código, pr.Descripcion AS Producto,
           COUNT(*) AS `Proveedores disponibles`
    FROM Producto pr
    JOIN Suministra s ON s.Cod_Produ = pr.Cod_Produc
    JOIN Proveedor p ON p.RUC_Prov = s.Ruc_Prov
    WHERE p.Estado = 'Activo' AND p.Evaluacion = 'Aprobado'
    GROUP BY pr.Cod_Produc, pr.Descripcion
    HAVING COUNT(*) > 1
    ORDER BY `Proveedores disponibles` DESC, pr.Descripcion, pr.Cod_Produc;
END$$

CREATE PROCEDURE sp_r11_facturas_credito()
    READS SQL DATA
BEGIN
    SELECT p.RUC_Prov AS RUC, p.RazonSocial AS Proveedor, f.Numfac AS Factura,
           f.Fec_Emision AS Emisión, f.Moneda, f.Impor_Total AS Total
    FROM Factura f
    JOIN Proveedor p ON p.RUC_Prov = f.Ruc_prov
    WHERE f.Condi_Pago = 'Credito'
    ORDER BY f.Fec_Emision, f.Numfac;
END$$

CREATE PROCEDURE sp_r12_evaluadores()
    READS SQL DATA
BEGIN
    SELECT e.DNI, e.NomCompleto AS Evaluador, COUNT(p.RUC_Prov) AS `Proveedores evaluados`
    FROM Evaluador e
    LEFT JOIN Proveedor p ON p.DNI = e.DNI
    GROUP BY e.DNI, e.NomCompleto
    ORDER BY `Proveedores evaluados` DESC, e.NomCompleto, e.DNI;
END$$

DELIMITER ;