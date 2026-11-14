-- Dolce & Ricco | Carga del script Insercion de Datos.sql con un evaluador.
-- Se conserva a la primera evaluadora del archivo adjunto como supuesto.
-- Ejecutar después de 01_esquema.sql a 04_procedimientos_reportes.sql.
-- Elimina las claves exactas de la carga demo anterior y conserva el historial.
-- Las filas existentes con las claves de la fuente conservan sus datos locales.
-- La reasignación de evaluadores abarca solo los DNI anteriores conocidos.

USE registro_proveedores;

DROP PROCEDURE IF EXISTS sp_cargar_datos_proyecto;
DELIMITER $$

CREATE PROCEDURE sp_cargar_datos_proyecto()
MODIFIES SQL DATA
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Telefono_Evaluador (Telefono) VALUES
    ('987654321')
    ON DUPLICATE KEY UPDATE Telefono = Telefono_Evaluador.Telefono;

    INSERT INTO Evaluador (DNI, NomCompleto, Telefono) VALUES
    ('45678912', 'Isabel María Manchego Rodríguez', '987654321')
    ON DUPLICATE KEY UPDATE DNI = Evaluador.DNI;

    DELETE FROM FichaTecnica WHERE Cod_Ficha IN (
        'DEMO-FT-01', 'DEMO-FT-02', 'DEMO-FT-03', 'DEMO-FT-04', 'DEMO-FT-05', 'DEMO-FT-06',
        'DEMO-FT-07', 'DEMO-FT-08', 'DEMO-FT-09', 'DEMO-FT-10', 'DEMO-FT-11');

    DELETE FROM RegistroSanitario WHERE Num_Reg_San IN (
        'DEMO-RS-01', 'DEMO-RS-02', 'DEMO-RS-03', 'DEMO-RS-04', 'DEMO-RS-05', 'DEMO-RS-06',
        'DEMO-RS-07', 'DEMO-RS-08', 'DEMO-RS-09', 'DEMO-RS-10', 'DEMO-RS-11', 'DEMO-RS-12',
        'DEMO-RS-13', 'DEMO-RS-14', 'DEMO-RS-15', 'DEMO-RS-16');

    DELETE FROM Haccp WHERE CodHaccp IN (
        'DEMO-H-01', 'DEMO-H-02', 'DEMO-H-03', 'DEMO-H-04', 'DEMO-H-05', 'DEMO-H-06',
        'DEMO-H-07', 'DEMO-H-08', 'DEMO-H-09', 'DEMO-H-10', 'DEMO-H-11', 'DEMO-H-12');

    DELETE FROM Cabecera_Haccp WHERE NumReso IN (
        'DEMO-RES-01', 'DEMO-RES-02', 'DEMO-RES-03', 'DEMO-RES-04', 'DEMO-RES-05', 'DEMO-RES-06',
        'DEMO-RES-07', 'DEMO-RES-08', 'DEMO-RES-09', 'DEMO-RES-10', 'DEMO-RES-11', 'DEMO-RES-12');

    DELETE FROM Factura WHERE Numfac IN (
        'F990-00000001', 'F990-00000002', 'F990-00000003', 'F990-00000004', 'F990-00000005', 'F990-00000006',
        'F990-00000007', 'F990-00000008', 'F990-00000009', 'F990-00000010', 'F990-00000011', 'F990-00000012',
        'F990-00000013', 'F990-00000014', 'F990-00000015', 'F990-00000016', 'F990-00000017', 'F990-00000018',
        'F990-00000019', 'F990-00000020', 'F990-00000021', 'F990-00000022', 'F990-00000023', 'F990-00000024',
        'F990-00000025', 'F990-00000026', 'F990-00000027', 'F990-00000028', 'F990-00000029', 'F990-00000030',
        'F990-00000031', 'F990-00000032', 'F990-00000033', 'F990-00000034', 'F990-00000035', 'F990-00000036',
        'F990-00000037', 'F990-00000038', 'F990-00000039', 'F990-00000040', 'F990-00000041', 'F990-00000042',
        'F990-00000043', 'F990-00000044', 'F990-00000045', 'F990-00000046', 'F990-00000047', 'F990-00000048',
        'F990-00000049', 'F990-00000050', 'F990-00000051', 'F990-00000052', 'F990-00000053', 'F990-00000054');

    DELETE FROM Suministra WHERE (Ruc_Prov, Cod_Produ) IN (
        ('90000000001', 'DEMO-P01'),
        ('90000000002', 'DEMO-P02'),
        ('90000000003', 'DEMO-P03'),
        ('90000000004', 'DEMO-P04'),
        ('90000000005', 'DEMO-P05'),
        ('90000000006', 'DEMO-P06'),
        ('90000000007', 'DEMO-P07'),
        ('90000000008', 'DEMO-P08'),
        ('90000000009', 'DEMO-P09'),
        ('90000000010', 'DEMO-P10'),
        ('90000000011', 'DEMO-P11'),
        ('90000000012', 'DEMO-P12'),
        ('90000000013', 'DEMO-P01'),
        ('90000000014', 'DEMO-P02'),
        ('90000000015', 'DEMO-P03'),
        ('90000000016', 'DEMO-P04'),
        ('90000000017', 'DEMO-P05'),
        ('90000000018', 'DEMO-P06'),
        ('90000000019', 'DEMO-P07'),
        ('90000000020', 'DEMO-P08'),
        ('90000000021', 'DEMO-P09'),
        ('90000000022', 'DEMO-P10'),
        ('90000000023', 'DEMO-P11'),
        ('90000000024', 'DEMO-P12'),
        ('90000000001', 'DEMO-P02'),
        ('90000000002', 'DEMO-P03'),
        ('90000000003', 'DEMO-P04'),
        ('90000000004', 'DEMO-P05'),
        ('90000000006', 'DEMO-P07'),
        ('90000000008', 'DEMO-P09'),
        ('90000000009', 'DEMO-P10'));

    DELETE FROM Producto WHERE Cod_Produc IN (
        'DEMO-P01', 'DEMO-P02', 'DEMO-P03', 'DEMO-P04', 'DEMO-P05', 'DEMO-P06',
        'DEMO-P07', 'DEMO-P08', 'DEMO-P09', 'DEMO-P10', 'DEMO-P11', 'DEMO-P12');

    DELETE FROM Proveedor WHERE RUC_Prov IN (
        '90000000001', '90000000002', '90000000003', '90000000004', '90000000005', '90000000006',
        '90000000007', '90000000008', '90000000009', '90000000010', '90000000011', '90000000012',
        '90000000013', '90000000014', '90000000015', '90000000016', '90000000017', '90000000018',
        '90000000019', '90000000020', '90000000021', '90000000022', '90000000023', '90000000024');

    UPDATE Proveedor
    SET DNI = '45678912'
    WHERE DNI IN ('91900001', '91900002', '91900003', '91900004', '41236587');

    DELETE FROM Evaluador WHERE DNI IN ('91900001', '91900002', '91900003', '91900004', '41236587');

    DELETE FROM Telefono_Evaluador
    WHERE Telefono IN ('900990001', '900990002', '900990003', '900990004', '956123478')
      AND NOT EXISTS (SELECT 1 FROM Evaluador e WHERE e.Telefono = Telefono_Evaluador.Telefono);

    INSERT INTO Proveedor (RUC_Prov, RazonSocial, Direcc, Estado, Evaluacion, DNI) VALUES
    ('20517842517', 'ALIMENTOS CIELO S.A.C.',
     'Mz. F Lote 5, Lot. Pre Urbana Nievería, Lurigancho, Lima',        'Activo',   'Aprobado',  '45678912'),
    ('20456789123', 'ADIPLUS S.A.C.',
     'Av. Industrial 456, Lima',                                          'Activo',   'Aprobado',  '45678912'),
    ('20601234567', 'DELICE S.A.C.',
     'Av. Los Quesos 88, Arequipa',                                       'Activo',   'Aprobado',  '45678912'),
    ('20498765432', 'MOLINERA DEL SUR S.A.C.',
     'Av. Industrial 120, Arequipa',                                      'Activo',   'Aprobado',  '45678912'),
    ('20601987654', 'EMPAQUES Y ENVASES ILO E.I.R.L.',
     'Calle Moquegua 245, Ilo',                                           'Activo',   'Aprobado',  '45678912'),
    ('20512345670', 'INSUMOS DULCES DEL PERÚ S.A.C.',
     'Parque Industrial Mz. B Lt. 7, Lima',                               'Activo',   'Observado', '45678912'),
    ('20532147896', 'DISTRIBUIDORA DE HUEVOS SAN MARTÍN S.R.L.',
     'Jr. Tacna 310, Moquegua',                                           'Inactivo', 'Aprobado',  '45678912'),
    ('20544332211', 'LÁCTEOS ANDINOS S.A.C.',
     'Av. Ganadera 15, Arequipa',                                         'Inactivo', 'Rechazado', '45678912')
    ON DUPLICATE KEY UPDATE RUC_Prov = Proveedor.RUC_Prov;

    INSERT INTO Producto (Cod_Produc, Descripcion, Unidad_Venta) VALUES
    ('MI000119', 'Manteca vegetal',                           'kg'),
    ('AC000231', 'Aceite vegetal de soya (balde 18 L)',       'balde'),
    ('QE000045', 'Queso Edam',                                'kg'),
    ('HA000310', 'Harina de trigo panadera (saco 50 kg)',     'saco'),
    ('AZ000120', 'Azúcar rubia (saco 50 kg)',                 'saco'),
    ('HU000088', 'Huevos de gallina (caja 360 unidades)',     'caja'),
    ('EM000015', 'Caja de cartón para pasteles 30x30',        'unidad'),
    ('LE000060', 'Leche evaporada entera (caja 48 latas)',    'caja'),
    ('ES000020', 'Esencia de vainilla (botella 1 L)',         'litro'),
    ('LV000012', 'Levadura fresca (bloque 500 g)',            'unidad')
    ON DUPLICATE KEY UPDATE Cod_Produc = Producto.Cod_Produc;

    INSERT INTO Suministra (Ruc_Prov, Cod_Produ) VALUES
    ('20517842517', 'AC000231'),
    ('20456789123', 'MI000119'),
    ('20601234567', 'QE000045'),
    ('20498765432', 'HA000310'),
    ('20498765432', 'LV000012'),
    ('20601987654', 'EM000015'),
    ('20512345670', 'AZ000120'),
    ('20512345670', 'ES000020'),
    ('20532147896', 'HU000088'),
    ('20544332211', 'LE000060'),
    ('20544332211', 'QE000045')
    ON DUPLICATE KEY UPDATE Ruc_Prov = Suministra.Ruc_Prov;

    INSERT INTO Factura
    (Numfac, Fec_Emision, Moneda, RUC_Contac, Lote, Ms, Condi_Pago, Calle, Ciudad,
     Val_Total, IGV, Impor_Total, Info_Adic, Ruc_prov) VALUES
    ('F007-00000890','2026-06-18','PEN','10046476578',NULL,     '35','Contado','A.H. 24 de Octubre','Ilo',  780.00,140.40, 920.40,NULL,'20532147896'),
    ('F006-00002105','2026-07-21','PEN','10046476578',NULL,     '35','Contado','A.H. 24 de Octubre','Ilo',  500.00, 90.00, 590.00,NULL,'20512345670'),
    ('F003-00009811','2026-08-05','PEN','10046476578','L260801','35','Credito','A.H. 24 de Octubre','Ilo', 2890.00,520.20,3410.20,'Entrega en taller','20498765432'),
    ('F005-00038690','2026-08-12','PEN','10046476578',NULL,     '35','Contado','A.H. 24 de Octubre','Ilo',  610.20,109.84, 720.04,NULL,'20456789123'),
    ('F001-00001523','2026-08-18','PEN','10046476578','L260812','35','Contado','A.H. 24 de Octubre','Ilo', 3200.00,576.00,3776.00,'Entrega en taller','20517842517'),
    ('F002-00004521','2026-08-25','PEN','10046476578','L261226',NULL,'Contado','Calle Bolognesi 215','Ilo', 780.00,140.40, 920.40,'Envío por encomienda. FV: 26/12/2026','20601234567'),
    ('F004-00000312','2026-09-03','PEN','10046476578',NULL,     NULL,'Contado','Calle Bolognesi 215','Ilo', 450.00, 81.00, 531.00,NULL,'20601987654'),
    ('F005-00038902','2026-09-09','PEN','10046476578','L260905','35','Credito','A.H. 24 de Octubre','Ilo', 1250.00,225.00,1475.00,'Pedido semanal de manteca','20456789123'),
    ('F003-00010024','2026-09-15','PEN','10046476578',NULL,     '35','Contado','A.H. 24 de Octubre','Ilo', 1320.00,237.60,1557.60,NULL,'20498765432'),
    ('F001-00001688','2026-09-22','PEN','10046476578','L260920','35','Credito','A.H. 24 de Octubre','Ilo',  842.50,151.65, 994.15,NULL,'20517842517'),
    ('F002-00004698','2026-09-29','PEN','10046476578','L261230',NULL,'Credito','Calle Bolognesi 215','Ilo',1575.50,283.59,1859.09,'Envío por encomienda','20601234567'),
    ('F006-00002210','2026-10-02','PEN','10046476578',NULL,     '35','Credito','A.H. 24 de Octubre','Ilo',  960.00,172.80,1132.80,NULL,'20512345670'),
    ('F005-00039215','2026-10-06','PEN','10046476578',NULL,     '35','Contado','A.H. 24 de Octubre','Ilo', 1980.00,356.40,2336.40,NULL,'20456789123'),
    ('F003-00010233','2026-10-10','PEN','10046476578',NULL,     '35','Contado','A.H. 24 de Octubre','Ilo',  640.00,115.20, 755.20,NULL,'20498765432'),
    ('F001-00001790','2026-10-14','PEN','10046476578','L261010','35','Contado','A.H. 24 de Octubre','Ilo', 2150.00,387.00,2537.00,'Entrega en taller','20517842517'),
    ('F004-00000367','2026-10-19','PEN','10046476578',NULL,     NULL,'Contado','Calle Bolognesi 215','Ilo', 715.00,128.70, 843.70,NULL,'20601987654')
    ON DUPLICATE KEY UPDATE Numfac = Factura.Numfac;

    INSERT INTO Cabecera_Haccp (NumReso, NumExp) VALUES
    ('1888-2025/DCEA/DIGESA/SA', '97150-2024-CH'),
    ('0954-2024/DCEA/DIGESA/SA', '88421-2023-CH'),
    ('2210-2024/DCEA/DIGESA/SA', '10233-2024-CH'),
    ('0377-2025/DCEA/DIGESA/SA', '55120-2025-CH'),
    ('0612-2025/DCEA/DIGESA/SA', '71309-2024-CH')
    ON DUPLICATE KEY UPDATE NumReso = Cabecera_Haccp.NumReso;

    INSERT INTO Haccp
    (CodHaccp, Linea_Produc, VerHaccp, Fec_Otorgamiento, Vigencia, Enti_Cer, Resul_Evalu, Ruc_Prov, NumReso) VALUES
    ('ALICI-GAC-MA-03','Refinado y envasado de aceite: aceite vegetal de soya','VII','2025-03-17','2027-03-17','DIGESA','Conforme',   '20517842517','1888-2025/DCEA/DIGESA/SA'),
    ('ADI-HACCP-01',   'Elaboración de manteca vegetal',                       'III','2024-06-10','2026-06-10','DIGESA','Conforme',   '20456789123','0954-2024/DCEA/DIGESA/SA'),
    ('DEL-HACCP-02',   'Elaboración de quesos madurados',                      'II', '2024-12-15','2026-12-15','DIGESA','Conforme',   '20601234567','2210-2024/DCEA/DIGESA/SA'),
    ('MOL-HACCP-01',   'Molienda y envasado de harina de trigo',               'IV', '2025-08-20','2027-08-20','DIGESA','Conforme',   '20498765432','0377-2025/DCEA/DIGESA/SA'),
    ('IDP-HACCP-01',   'Refinado y envasado de azúcar',                        'II', '2025-02-03','2027-02-03','DIGESA','No conforme','20512345670','0612-2025/DCEA/DIGESA/SA')
    ON DUPLICATE KEY UPDATE CodHaccp = Haccp.CodHaccp;

    INSERT INTO RegistroSanitario
    (Num_Reg_San, NumExp, Repre_Legal, Vigencia, Fec_Expedi, Produc_Regis, Vida_Util_Produc,
     Direc_Esta, Cod_Produc, Ruc_Prov) VALUES
    ('C1700314N NAPODE','99561-2023-R','Pinto Barrios Jenny Milagros','2028-12-18','2023-12-18',
     'Aceite vegetal de soya','12 meses','Mz. F Lote 5, Lot. Pre Urbana Nievería, Lurigancho, Lima','AC000231','20517842517'),
    ('E2103987N NAPODE','48213-2021-R','Rojas Vega Manuel Enrique','2026-11-05','2021-11-05',
     'Manteca vegetal','9 meses','Av. Industrial 456, Lima','MI000119','20456789123'),
    ('L2204451N NAPODE','63320-2022-R','Quispe Huanca Rosa María','2027-06-14','2022-06-14',
     'Queso Edam','6 meses','Av. Los Quesos 88, Arequipa','QE000045','20601234567'),
    ('H2401122N NAPODE','12874-2024-R','Torres Salas Jorge Luis','2029-03-02','2024-03-02',
     'Harina de trigo','12 meses','Av. Industrial 120, Arequipa','HA000310','20498765432'),
    ('A2308876N NAPODE','55690-2023-R','Paredes Linares Ana Cecilia','2028-08-21','2023-08-21',
     'Azúcar rubia','24 meses','Parque Industrial Mz. B Lt. 7, Lima','AZ000120','20512345670'),
    ('E2406634N NAPODE','33018-2024-R','Paredes Linares Ana Cecilia','2029-06-25','2024-06-25',
     'Esencia de vainilla','18 meses','Parque Industrial Mz. B Lt. 7, Lima','ES000020','20512345670'),
    ('G2005503N NAPODE','27741-2020-R','Mendoza Ccori Pedro','2025-05-18','2020-05-18',
     'Huevos de gallina','25 días','Jr. Tacna 310, Moquegua','HU000088','20532147896'),
    ('L2112090N NAPODE','90112-2021-R','Salazar Ponce Miguel','2026-12-09','2021-12-09',
     'Leche evaporada entera','12 meses','Av. Ganadera 15, Arequipa','LE000060','20544332211')
    ON DUPLICATE KEY UPDATE Num_Reg_San = RegistroSanitario.Num_Reg_San;

    INSERT INTO FichaTecnica
    (Cod_Ficha, Version, Fec_Emision, Deno_Produc, Deno_Tec, Vida_Util, Condi_Alma,
     Presentacion, Respon_Aprob, Cod_Produc, Ruc_Prov, Num_Reg_San) VALUES
    ('ALICI-GAC-FT-13','V','2023-09-01','ACEITE VEGETAL DE SOYA','Aceite vegetal','12 meses',
     'Conservar en lugar fresco y seco, protegido de la luz','Balde x 18 L',
     'Cristian Pinto (Gerente General)','AC000231','20517842517','C1700314N NAPODE'),
    ('ADI-FT-05','II','2024-02-12','MANTECA VEGETAL','Grasa vegetal','9 meses',
     'Lugar fresco, menos de 25 °C','Caja x 15 kg',
     'Ing. Patricia Vega (Aseguramiento de la Calidad)','MI000119','20456789123','E2103987N NAPODE'),
    ('DEL-FT-02','III','2023-11-20','QUESO EDAM','Queso madurado semiduro','6 meses',
     'Refrigerado entre 2 y 6 °C','Bloque x 2 kg',
     'Ing. Luis Fernández (Jefe de Calidad)','QE000045','20601234567','L2204451N NAPODE'),
    ('MOL-FT-01','IV','2024-03-15','HARINA DE TRIGO PANADERA','Harina de trigo','12 meses',
     'Lugar seco y ventilado','Saco x 50 kg',
     'Ing. Rocío Alarcón (Jefe de Planta)','HA000310','20498765432','H2401122N NAPODE'),
    ('IDP-FT-03','I','2023-09-10','AZÚCAR RUBIA','Sacarosa','24 meses',
     'Lugar seco, protegido de la humedad','Saco x 50 kg',
     'Ing. Mario Cáceres (Aseguramiento de la Calidad)','AZ000120','20512345670','A2308876N NAPODE'),
    ('IDP-FT-04','I','2024-07-01','ESENCIA DE VAINILLA','Extracto de vainilla','18 meses',
     'Lugar fresco, protegido de la luz','Botella x 1 L',
     'Ing. Mario Cáceres (Aseguramiento de la Calidad)','ES000020','20512345670','E2406634N NAPODE'),
    ('LAN-FT-01','II','2022-01-18','LECHE EVAPORADA ENTERA','Leche evaporada','12 meses',
     'Lugar fresco y seco','Caja x 48 latas de 400 g',
     'Ing. Sofía Benavides (Jefe de Calidad)','LE000060','20544332211','L2112090N NAPODE')
    ON DUPLICATE KEY UPDATE Cod_Ficha = FichaTecnica.Cod_Ficha;

    COMMIT;
END$$

DELIMITER ;

CALL sp_cargar_datos_proyecto();
DROP PROCEDURE IF EXISTS sp_cargar_datos_proyecto;

SELECT
    (SELECT COUNT(*) FROM Evaluador) AS evaluadores,
    (SELECT COUNT(*) FROM Proveedor) AS proveedores,
    (SELECT COUNT(*) FROM Producto) AS productos,
    (SELECT COUNT(*) FROM Factura) AS facturas;
