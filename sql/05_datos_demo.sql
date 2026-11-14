-- Datos íntegramente ficticios y opcionales para una instalación de pruebas.
-- Se pueden cargar de nuevo. Las claves existentes se conservan.
-- Ejecute después de los scripts 01 a 04.
USE registro_proveedores;
START TRANSACTION;

INSERT INTO Telefono_Evaluador
(Telefono) VALUES
    ('900990001'),
    ('900990002'),
    ('900990003'),
    ('900990004')
ON DUPLICATE KEY UPDATE Telefono = Telefono_Evaluador.Telefono;

INSERT INTO Evaluador
(DNI, NomCompleto, Telefono) VALUES
    ('91900001', 'Evaluador de prueba 01', '900990001'),
    ('91900002', 'Evaluador de prueba 02', '900990002'),
    ('91900003', 'Evaluador de prueba 03', '900990003'),
    ('91900004', 'Evaluador de prueba 04', '900990004')
ON DUPLICATE KEY UPDATE DNI = Evaluador.DNI;

INSERT INTO Proveedor
(RUC_Prov, RazonSocial, Direcc, Estado, Evaluacion, DNI) VALUES
    ('90000000001', 'Harinas de Demostración 01', 'Dirección de prueba 01, Ilo', 'Activo', 'Aprobado', '91900001'),
    ('90000000002', 'Lácteos de Demostración 02', 'Dirección de prueba 02, Ilo', 'Activo', 'Aprobado', '91900002'),
    ('90000000003', 'Azúcar de Demostración 03', 'Dirección de prueba 03, Ilo', 'Activo', 'Aprobado', '91900003'),
    ('90000000004', 'Aceites de Demostración 04', 'Dirección de prueba 04, Ilo', 'Activo', 'Aprobado', '91900004'),
    ('90000000005', 'Envases de Demostración 05', 'Dirección de prueba 05, Ilo', 'Activo', 'Observado', '91900001'),
    ('90000000006', 'Huevos de Demostración 06', 'Dirección de prueba 06, Ilo', 'Activo', 'Aprobado', '91900002'),
    ('90000000007', 'Cacao de Demostración 07', 'Dirección de prueba 07, Ilo', 'Inactivo', 'Aprobado', '91900003'),
    ('90000000008', 'Frutas de Demostración 08', 'Dirección de prueba 08, Ilo', 'Activo', 'Aprobado', '91900004'),
    ('90000000009', 'Levadura de Demostración 09', 'Dirección de prueba 09, Ilo', 'Activo', 'Aprobado', '91900001'),
    ('90000000010', 'Especias de Demostración 10', 'Dirección de prueba 10, Ilo', 'Activo', 'Observado', '91900002'),
    ('90000000011', 'Mantecas de Demostración 11', 'Dirección de prueba 11, Ilo', 'Activo', 'Aprobado', '91900003'),
    ('90000000012', 'Vainilla de Demostración 12', 'Dirección de prueba 12, Ilo', 'Activo', 'Aprobado', '91900004'),
    ('90000000013', 'Miel de Demostración 13', 'Dirección de prueba 13, Ilo', 'Activo', 'Aprobado', '91900001'),
    ('90000000014', 'Nueces de Demostración 14', 'Dirección de prueba 14, Ilo', 'Activo', 'Aprobado', '91900002'),
    ('90000000015', 'Conservas de Demostración 15', 'Dirección de prueba 15, Ilo', 'Inactivo', 'Observado', '91900003'),
    ('90000000016', 'Semillas de Demostración 16', 'Dirección de prueba 16, Ilo', 'Activo', 'Aprobado', '91900004'),
    ('90000000017', 'Jarabes de Demostración 17', 'Dirección de prueba 17, Ilo', 'Activo', 'Aprobado', '91900001'),
    ('90000000018', 'Sal de Demostración 18', 'Dirección de prueba 18, Ilo', 'Activo', 'Aprobado', '91900002'),
    ('90000000019', 'Café de Demostración 19', 'Dirección de prueba 19, Ilo', 'Activo', 'Aprobado', '91900003'),
    ('90000000020', 'Bolsas de Demostración 20', 'Dirección de prueba 20, Ilo', 'Activo', 'Observado', '91900004'),
    ('90000000021', 'Cajas de Demostración 21', 'Dirección de prueba 21, Ilo', 'Activo', 'Aprobado', '91900001'),
    ('90000000022', 'Cereales de Demostración 22', 'Dirección de prueba 22, Ilo', 'Activo', 'Aprobado', '91900002'),
    ('90000000023', 'Mermeladas de Demostración 23', 'Dirección de prueba 23, Ilo', 'Activo', 'Aprobado', '91900003'),
    ('90000000024', 'Coberturas de Demostración 24', 'Dirección de prueba 24, Ilo', 'Inactivo', 'Rechazado', '91900004')
ON DUPLICATE KEY UPDATE RUC_Prov = Proveedor.RUC_Prov;

INSERT INTO Producto
(Cod_Produc, Descripcion, Unidad_Venta) VALUES
    ('DEMO-P01', 'Harinas', 'kg'),
    ('DEMO-P02', 'Lácteos', 'kg'),
    ('DEMO-P03', 'Azúcar', 'kg'),
    ('DEMO-P04', 'Aceites', 'kg'),
    ('DEMO-P05', 'Envases', 'unidad'),
    ('DEMO-P06', 'Huevos', 'unidad'),
    ('DEMO-P07', 'Cacao', 'kg'),
    ('DEMO-P08', 'Frutas', 'kg'),
    ('DEMO-P09', 'Levadura', 'kg'),
    ('DEMO-P10', 'Especias', 'kg'),
    ('DEMO-P11', 'Mantecas', 'kg'),
    ('DEMO-P12', 'Vainilla', 'kg')
ON DUPLICATE KEY UPDATE Cod_Produc = Producto.Cod_Produc;

INSERT INTO Suministra
(Ruc_Prov, Cod_Produ) VALUES
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
    ('90000000009', 'DEMO-P10')
ON DUPLICATE KEY UPDATE Ruc_Prov = Suministra.Ruc_Prov;

INSERT INTO Factura
(Numfac, Fec_Emision, Moneda, RUC_Contac, Lote, Ms, Condi_Pago, Calle, Ciudad,
 Val_Total, IGV, Impor_Total, Info_Adic, Ruc_prov) VALUES
    ('F990-00000001', '2026-09-02', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 190, 34.20, 224.20, NULL, '90000000001'),
    ('F990-00000002', '2026-10-03', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 217, 39.06, 256.06, NULL, '90000000001'),
    ('F990-00000003', '2026-07-04', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 244, 43.92, 287.92, NULL, '90000000001'),
    ('F990-00000004', '2026-10-03', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 203, 36.54, 239.54, NULL, '90000000002'),
    ('F990-00000005', '2026-07-04', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 230, 41.40, 271.40, NULL, '90000000002'),
    ('F990-00000006', '2026-08-05', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 257, 46.26, 303.26, NULL, '90000000002'),
    ('F990-00000007', '2026-07-04', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 216, 38.88, 254.88, NULL, '90000000003'),
    ('F990-00000008', '2026-08-05', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 243, 43.74, 286.74, NULL, '90000000003'),
    ('F990-00000009', '2026-09-06', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 270, 48.60, 318.60, NULL, '90000000003'),
    ('F990-00000010', '2026-08-05', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 229, 41.22, 270.22, NULL, '90000000004'),
    ('F990-00000011', '2026-09-06', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 256, 46.08, 302.08, NULL, '90000000004'),
    ('F990-00000012', '2026-10-07', 'USD', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 283, 50.94, 333.94, NULL, '90000000004'),
    ('F990-00000013', '2026-09-06', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 242, 43.56, 285.56, NULL, '90000000005'),
    ('F990-00000014', '2026-10-07', 'USD', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 269, 48.42, 317.42, NULL, '90000000005'),
    ('F990-00000015', '2026-07-08', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 296, 53.28, 349.28, NULL, '90000000005'),
    ('F990-00000016', '2026-10-07', 'USD', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 255, 45.90, 300.90, NULL, '90000000006'),
    ('F990-00000017', '2026-07-08', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 282, 50.76, 332.76, NULL, '90000000006'),
    ('F990-00000018', '2026-08-09', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 309, 55.62, 364.62, NULL, '90000000006'),
    ('F990-00000019', '2026-07-08', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 268, 48.24, 316.24, NULL, '90000000007'),
    ('F990-00000020', '2026-08-09', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 295, 53.10, 348.10, NULL, '90000000007'),
    ('F990-00000021', '2026-09-10', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 322, 57.96, 379.96, NULL, '90000000007'),
    ('F990-00000022', '2026-08-09', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 281, 50.58, 331.58, NULL, '90000000008'),
    ('F990-00000023', '2026-09-10', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 308, 55.44, 363.44, NULL, '90000000008'),
    ('F990-00000024', '2026-10-11', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 335, 60.30, 395.30, NULL, '90000000008'),
    ('F990-00000025', '2026-09-10', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 294, 52.92, 346.92, NULL, '90000000009'),
    ('F990-00000026', '2026-10-11', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 321, 57.78, 378.78, NULL, '90000000009'),
    ('F990-00000027', '2026-07-12', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 348, 62.64, 410.64, NULL, '90000000009'),
    ('F990-00000028', '2026-10-11', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 307, 55.26, 362.26, NULL, '90000000010'),
    ('F990-00000029', '2026-07-12', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 334, 60.12, 394.12, NULL, '90000000010'),
    ('F990-00000030', '2026-08-13', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 361, 64.98, 425.98, NULL, '90000000010'),
    ('F990-00000031', '2026-07-12', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 320, 57.60, 377.60, NULL, '90000000011'),
    ('F990-00000032', '2026-08-13', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 347, 62.46, 409.46, NULL, '90000000011'),
    ('F990-00000033', '2026-09-14', 'USD', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 374, 67.32, 441.32, NULL, '90000000011'),
    ('F990-00000034', '2026-08-13', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 333, 59.94, 392.94, NULL, '90000000012'),
    ('F990-00000035', '2026-09-14', 'USD', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 360, 64.80, 424.80, NULL, '90000000012'),
    ('F990-00000036', '2026-10-15', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 387, 69.66, 456.66, NULL, '90000000012'),
    ('F990-00000037', '2026-09-14', 'USD', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 346, 62.28, 408.28, NULL, '90000000013'),
    ('F990-00000038', '2026-10-15', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 373, 67.14, 440.14, NULL, '90000000013'),
    ('F990-00000039', '2026-07-16', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 400, 72.00, 472.00, NULL, '90000000013'),
    ('F990-00000040', '2026-10-15', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 359, 64.62, 423.62, NULL, '90000000014'),
    ('F990-00000041', '2026-07-16', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 386, 69.48, 455.48, NULL, '90000000014'),
    ('F990-00000042', '2026-08-17', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 413, 74.34, 487.34, NULL, '90000000014'),
    ('F990-00000043', '2026-07-16', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 372, 66.96, 438.96, NULL, '90000000015'),
    ('F990-00000044', '2026-08-17', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 399, 71.82, 470.82, NULL, '90000000015'),
    ('F990-00000045', '2026-09-18', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 426, 76.68, 502.68, NULL, '90000000015'),
    ('F990-00000046', '2026-08-17', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 385, 69.30, 454.30, NULL, '90000000016'),
    ('F990-00000047', '2026-09-18', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 412, 74.16, 486.16, NULL, '90000000016'),
    ('F990-00000048', '2026-10-19', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 439, 79.02, 518.02, NULL, '90000000016'),
    ('F990-00000049', '2026-09-18', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 398, 71.64, 469.64, NULL, '90000000017'),
    ('F990-00000050', '2026-10-19', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 425, 76.50, 501.50, NULL, '90000000017'),
    ('F990-00000051', '2026-07-20', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 452, 81.36, 533.36, NULL, '90000000017'),
    ('F990-00000052', '2026-10-19', 'PEN', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 411, 73.98, 484.98, NULL, '90000000018'),
    ('F990-00000053', '2026-07-20', 'PEN', '90000000999', NULL, NULL, 'Credito', 'Calle de prueba', 'Ilo', 438, 78.84, 516.84, NULL, '90000000018'),
    ('F990-00000054', '2026-08-21', 'USD', '90000000999', NULL, NULL, 'Contado', 'Calle de prueba', 'Ilo', 465, 83.70, 548.70, NULL, '90000000018')
ON DUPLICATE KEY UPDATE Numfac = Factura.Numfac;

INSERT INTO Cabecera_Haccp
(NumReso, NumExp) VALUES
    ('DEMO-RES-01', 'DEMO-H-EXP-01'),
    ('DEMO-RES-02', 'DEMO-H-EXP-02'),
    ('DEMO-RES-03', 'DEMO-H-EXP-03'),
    ('DEMO-RES-04', 'DEMO-H-EXP-04'),
    ('DEMO-RES-05', 'DEMO-H-EXP-05'),
    ('DEMO-RES-06', 'DEMO-H-EXP-06'),
    ('DEMO-RES-07', 'DEMO-H-EXP-07'),
    ('DEMO-RES-08', 'DEMO-H-EXP-08'),
    ('DEMO-RES-09', 'DEMO-H-EXP-09'),
    ('DEMO-RES-10', 'DEMO-H-EXP-10'),
    ('DEMO-RES-11', 'DEMO-H-EXP-11'),
    ('DEMO-RES-12', 'DEMO-H-EXP-12')
ON DUPLICATE KEY UPDATE NumReso = Cabecera_Haccp.NumReso;

INSERT INTO Haccp
(CodHaccp, Linea_Produc, VerHaccp, Fec_Otorgamiento, Vigencia, Enti_Cer, Resul_Evalu, Ruc_Prov, NumReso) VALUES
    ('DEMO-H-01', 'Harinas', '01', '2024-01-01', '2026-12-05', 'Certificadora de prueba', 'Conforme', '90000000001', 'DEMO-RES-01'),
    ('DEMO-H-02', 'Lácteos', '01', '2024-01-01', '2029-12-05', 'Certificadora de prueba', 'Conforme', '90000000002', 'DEMO-RES-02'),
    ('DEMO-H-03', 'Azúcar', '01', '2024-01-01', '2025-01-01', 'Certificadora de prueba', 'Conforme', '90000000003', 'DEMO-RES-03'),
    ('DEMO-H-04', 'Aceites', '01', '2024-01-01', '2026-12-05', 'Certificadora de prueba', 'No conforme', '90000000004', 'DEMO-RES-04'),
    ('DEMO-H-05', 'Envases', '01', '2024-01-01', '2029-12-05', 'Certificadora de prueba', 'Conforme', '90000000005', 'DEMO-RES-05'),
    ('DEMO-H-06', 'Huevos', '01', '2024-01-01', '2025-01-01', 'Certificadora de prueba', 'Conforme', '90000000006', 'DEMO-RES-06'),
    ('DEMO-H-07', 'Cacao', '01', '2024-01-01', '2026-12-05', 'Certificadora de prueba', 'Conforme', '90000000007', 'DEMO-RES-07'),
    ('DEMO-H-08', 'Frutas', '01', '2024-01-01', '2029-12-05', 'Certificadora de prueba', 'No conforme', '90000000008', 'DEMO-RES-08'),
    ('DEMO-H-09', 'Levadura', '01', '2024-01-01', '2025-01-01', 'Certificadora de prueba', 'Conforme', '90000000009', 'DEMO-RES-09'),
    ('DEMO-H-10', 'Especias', '01', '2024-01-01', '2026-12-05', 'Certificadora de prueba', 'Conforme', '90000000010', 'DEMO-RES-10'),
    ('DEMO-H-11', 'Mantecas', '01', '2024-01-01', '2029-12-05', 'Certificadora de prueba', 'Conforme', '90000000011', 'DEMO-RES-11'),
    ('DEMO-H-12', 'Vainilla', '01', '2024-01-01', '2025-01-01', 'Certificadora de prueba', 'No conforme', '90000000012', 'DEMO-RES-12')
ON DUPLICATE KEY UPDATE CodHaccp = Haccp.CodHaccp;

INSERT INTO RegistroSanitario
(Num_Reg_San, NumExp, Repre_Legal, Vigencia, Fec_Expedi, Produc_Regis, Vida_Util_Produc, Direc_Esta, Cod_Produc, Ruc_Prov) VALUES
    ('DEMO-RS-01', 'DEMO-R-EXP-01', 'Representante de prueba 01', '2027-01-05', '2024-01-01', 'Harinas', '12 meses', 'Dirección de prueba', 'DEMO-P01', '90000000001'),
    ('DEMO-RS-02', 'DEMO-R-EXP-02', 'Representante de prueba 02', '2029-12-05', '2024-01-01', 'Lácteos', '12 meses', 'Dirección de prueba', 'DEMO-P02', '90000000002'),
    ('DEMO-RS-03', 'DEMO-R-EXP-03', 'Representante de prueba 03', '2025-10-01', '2024-01-01', 'Azúcar', '12 meses', 'Dirección de prueba', 'DEMO-P03', '90000000003'),
    ('DEMO-RS-04', 'DEMO-R-EXP-04', 'Representante de prueba 04', '2027-01-05', '2024-01-01', 'Aceites', '12 meses', 'Dirección de prueba', 'DEMO-P04', '90000000004'),
    ('DEMO-RS-05', 'DEMO-R-EXP-05', 'Representante de prueba 05', '2029-12-05', '2024-01-01', 'Envases', '12 meses', 'Dirección de prueba', 'DEMO-P05', '90000000005'),
    ('DEMO-RS-06', 'DEMO-R-EXP-06', 'Representante de prueba 06', '2025-10-01', '2024-01-01', 'Huevos', '12 meses', 'Dirección de prueba', 'DEMO-P06', '90000000006'),
    ('DEMO-RS-07', 'DEMO-R-EXP-07', 'Representante de prueba 07', '2027-01-05', '2024-01-01', 'Cacao', '12 meses', 'Dirección de prueba', 'DEMO-P07', '90000000007'),
    ('DEMO-RS-08', 'DEMO-R-EXP-08', 'Representante de prueba 08', '2029-12-05', '2024-01-01', 'Frutas', '12 meses', 'Dirección de prueba', 'DEMO-P08', '90000000008'),
    ('DEMO-RS-09', 'DEMO-R-EXP-09', 'Representante de prueba 09', '2025-10-01', '2024-01-01', 'Levadura', '12 meses', 'Dirección de prueba', 'DEMO-P09', '90000000009'),
    ('DEMO-RS-10', 'DEMO-R-EXP-10', 'Representante de prueba 10', '2027-01-05', '2024-01-01', 'Especias', '12 meses', 'Dirección de prueba', 'DEMO-P10', '90000000010'),
    ('DEMO-RS-11', 'DEMO-R-EXP-11', 'Representante de prueba 11', '2029-12-05', '2024-01-01', 'Mantecas', '12 meses', 'Dirección de prueba', 'DEMO-P11', '90000000011'),
    ('DEMO-RS-12', 'DEMO-R-EXP-12', 'Representante de prueba 12', '2025-10-01', '2024-01-01', 'Vainilla', '12 meses', 'Dirección de prueba', 'DEMO-P12', '90000000012'),
    ('DEMO-RS-13', 'DEMO-R-EXP-13', 'Representante de prueba 13', '2027-01-05', '2024-01-01', 'Harinas', '12 meses', 'Dirección de prueba', 'DEMO-P01', '90000000013'),
    ('DEMO-RS-14', 'DEMO-R-EXP-14', 'Representante de prueba 14', '2029-12-05', '2024-01-01', 'Lácteos', '12 meses', 'Dirección de prueba', 'DEMO-P02', '90000000014'),
    ('DEMO-RS-15', 'DEMO-R-EXP-15', 'Representante de prueba 15', '2025-10-01', '2024-01-01', 'Azúcar', '12 meses', 'Dirección de prueba', 'DEMO-P03', '90000000015'),
    ('DEMO-RS-16', 'DEMO-R-EXP-16', 'Representante de prueba 16', '2027-01-05', '2024-01-01', 'Aceites', '12 meses', 'Dirección de prueba', 'DEMO-P04', '90000000016')
ON DUPLICATE KEY UPDATE Num_Reg_San = RegistroSanitario.Num_Reg_San;

INSERT INTO FichaTecnica
(Cod_Ficha, Version, Fec_Emision, Deno_Produc, Deno_Tec, Vida_Util, Condi_Alma, Presentacion, Respon_Aprob, Cod_Produc, Ruc_Prov, Num_Reg_San) VALUES
    ('DEMO-FT-01', '01', '2024-02-01', 'Harinas', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P01', '90000000001', 'DEMO-RS-01'),
    ('DEMO-FT-02', '01', '2024-02-01', 'Lácteos', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P02', '90000000002', 'DEMO-RS-02'),
    ('DEMO-FT-03', '01', '2024-02-01', 'Azúcar', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P03', '90000000003', 'DEMO-RS-03'),
    ('DEMO-FT-04', '01', '2024-02-01', 'Aceites', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P04', '90000000004', 'DEMO-RS-04'),
    ('DEMO-FT-05', '01', '2024-02-01', 'Envases', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P05', '90000000005', 'DEMO-RS-05'),
    ('DEMO-FT-06', '01', '2024-02-01', 'Huevos', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P06', '90000000006', 'DEMO-RS-06'),
    ('DEMO-FT-07', '01', '2024-02-01', 'Cacao', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P07', '90000000007', 'DEMO-RS-07'),
    ('DEMO-FT-08', '01', '2024-02-01', 'Frutas', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P08', '90000000008', 'DEMO-RS-08'),
    ('DEMO-FT-09', '01', '2024-02-01', 'Levadura', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P09', '90000000009', 'DEMO-RS-09'),
    ('DEMO-FT-10', '01', '2024-02-01', 'Especias', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P10', '90000000010', 'DEMO-RS-10'),
    ('DEMO-FT-11', '01', '2024-02-01', 'Mantecas', NULL, '12 meses', 'Lugar fresco y seco', 'Caja', 'Responsable de prueba', 'DEMO-P11', '90000000011', 'DEMO-RS-11')
ON DUPLICATE KEY UPDATE Cod_Ficha = FichaTecnica.Cod_Ficha;

COMMIT;