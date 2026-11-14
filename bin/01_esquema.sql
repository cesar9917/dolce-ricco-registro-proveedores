-- Dolce & Ricco | Esquema original de MySQL 8.0.16+ (InnoDB).
-- Si ya instalaste el mismo esquema, este archivo conserva tablas y datos.

CREATE DATABASE IF NOT EXISTS registro_proveedores
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE registro_proveedores;

-- ---------------------------------------------------------------------
-- 1. Telefono_Evaluador
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Telefono_Evaluador (
  Telefono CHAR(9) NOT NULL,
  PRIMARY KEY (Telefono),
  CONSTRAINT ck_tel_formato CHECK (Telefono REGEXP '^9[0-9]{8}$')
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. Evaluador
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Evaluador (
  DNI         CHAR(8)      NOT NULL,
  NomCompleto VARCHAR(100) NOT NULL,
  Telefono    CHAR(9)      NOT NULL,
  PRIMARY KEY (DNI),
  CONSTRAINT fk_eval_tel FOREIGN KEY (Telefono)
    REFERENCES Telefono_Evaluador (Telefono),
  CONSTRAINT ck_eval_dni CHECK (DNI REGEXP '^[0-9]{8}$')
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. Proveedor
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Proveedor (
  RUC_Prov    CHAR(11)     NOT NULL,
  RazonSocial VARCHAR(100) NOT NULL,
  Direcc      VARCHAR(150) NOT NULL,
  Estado      VARCHAR(10)  NOT NULL DEFAULT 'Activo',
  Evaluacion  VARCHAR(15)  NOT NULL,
  DNI         CHAR(8)      NOT NULL,
  PRIMARY KEY (RUC_Prov),
  CONSTRAINT fk_prov_eval FOREIGN KEY (DNI) REFERENCES Evaluador (DNI),
  CONSTRAINT ck_prov_ruc    CHECK (RUC_Prov REGEXP '^[0-9]{11}$'),
  CONSTRAINT ck_prov_estado CHECK (Estado IN ('Activo','Inactivo')),
  CONSTRAINT ck_prov_evalua CHECK (Evaluacion IN ('Aprobado','Observado','Rechazado')),
  INDEX idx_prov_razon (RazonSocial),   -- índice ordinal (ordinario)
  INDEX idx_prov_dni   (DNI)            -- ordinal, respalda la FK
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. Factura
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Factura (
  Numfac      CHAR(13)      NOT NULL,
  Fec_Emision DATE          NOT NULL,
  Moneda      CHAR(3)       NOT NULL DEFAULT 'PEN',
  RUC_Contac  CHAR(11)      NOT NULL,
  Lote        VARCHAR(20)   NULL,
  Ms          VARCHAR(10)   NULL,
  Condi_Pago  VARCHAR(10)   NOT NULL,
  Calle       VARCHAR(100)  NOT NULL,
  Ciudad      VARCHAR(50)   NOT NULL,
  Val_Total   DECIMAL(12,2) NOT NULL,
  IGV         DECIMAL(12,2) NOT NULL,
  Impor_Total DECIMAL(12,2) NOT NULL,
  Info_Adic   VARCHAR(200)  NULL,
  Ruc_prov    CHAR(11)      NOT NULL,
  PRIMARY KEY (Numfac),
  CONSTRAINT fk_fac_prov FOREIGN KEY (Ruc_prov) REFERENCES Proveedor (RUC_Prov),
  CONSTRAINT ck_fac_moneda CHECK (Moneda IN ('PEN','USD')),
  CONSTRAINT ck_fac_pago   CHECK (Condi_Pago IN ('Contado','Credito')),
  CONSTRAINT ck_fac_val    CHECK (Val_Total > 0),
  CONSTRAINT ck_fac_igv    CHECK (IGV >= 0),
  CONSTRAINT ck_fac_total  CHECK (Impor_Total = Val_Total + IGV),
  INDEX idx_fac_fecha      (Fec_Emision),             -- índice ordinal
  INDEX idx_fac_prov_fecha (Ruc_prov, Fec_Emision)    -- índice compuesto (respalda la FK)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. Cabecera_Haccp
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Cabecera_Haccp (
  NumReso VARCHAR(30) NOT NULL,
  NumExp  VARCHAR(20) NOT NULL,
  PRIMARY KEY (NumReso)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. Haccp
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Haccp (
  CodHaccp         VARCHAR(15)  NOT NULL,
  Linea_Produc     VARCHAR(80)  NOT NULL,
  VerHaccp         VARCHAR(10)  NOT NULL,
  Fec_Otorgamiento DATE         NOT NULL,
  Vigencia         DATE         NOT NULL,
  Enti_Cer         VARCHAR(100) NOT NULL,
  Resul_Evalu      VARCHAR(20)  NOT NULL,
  Ruc_Prov         CHAR(11)     NOT NULL,
  NumReso          VARCHAR(30)  NOT NULL,
  PRIMARY KEY (CodHaccp),
  CONSTRAINT fk_haccp_prov  FOREIGN KEY (Ruc_Prov) REFERENCES Proveedor (RUC_Prov),
  CONSTRAINT fk_haccp_reso  FOREIGN KEY (NumReso)  REFERENCES Cabecera_Haccp (NumReso),
  CONSTRAINT ck_haccp_res   CHECK (Resul_Evalu IN ('Conforme','No conforme')),
  CONSTRAINT ck_haccp_vig   CHECK (Vigencia > Fec_Otorgamiento),
  INDEX idx_haccp_prov (Ruc_Prov),
  INDEX idx_haccp_reso (NumReso)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 7. Producto
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Producto (
  Cod_Produc   VARCHAR(15)  NOT NULL,
  Descripcion  VARCHAR(150) NOT NULL,
  Unidad_Venta VARCHAR(20)  NOT NULL,
  PRIMARY KEY (Cod_Produc)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 8. Suministra (tabla intermedia de la relación muchos a muchos)
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Suministra (
  Ruc_Prov  CHAR(11)    NOT NULL,
  Cod_Produ VARCHAR(15) NOT NULL,
  PRIMARY KEY (Ruc_Prov, Cod_Produ),                  -- clave primaria compuesta
  CONSTRAINT fk_sum_prov FOREIGN KEY (Ruc_Prov)  REFERENCES Proveedor (RUC_Prov),
  CONSTRAINT fk_sum_prod FOREIGN KEY (Cod_Produ) REFERENCES Producto (Cod_Produc),
  INDEX idx_sum_prod (Cod_Produ)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 9. RegistroSanitario
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS RegistroSanitario (
  Num_Reg_San      VARCHAR(20)  NOT NULL,
  NumExp           VARCHAR(20)  NOT NULL,
  Repre_Legal      VARCHAR(100) NOT NULL,
  Vigencia         DATE         NOT NULL,
  Fec_Expedi       DATE         NOT NULL,
  Produc_Regis     VARCHAR(100) NOT NULL,
  Vida_Util_Produc VARCHAR(30)  NOT NULL,
  Direc_Esta       VARCHAR(150) NOT NULL,
  Cod_Produc       VARCHAR(15)  NOT NULL,
  Ruc_Prov         CHAR(11)     NOT NULL,
  PRIMARY KEY (Num_Reg_San),
  CONSTRAINT fk_reg_prod FOREIGN KEY (Cod_Produc) REFERENCES Producto (Cod_Produc),
  CONSTRAINT fk_reg_prov FOREIGN KEY (Ruc_Prov)   REFERENCES Proveedor (RUC_Prov),
  CONSTRAINT ck_reg_vig  CHECK (Vigencia > Fec_Expedi),
  UNIQUE INDEX uq_reg_numexp (NumExp),                -- índice único
  INDEX idx_reg_prov (Ruc_Prov),
  INDEX idx_reg_prod (Cod_Produc)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 10. FichaTecnica
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS FichaTecnica (
  Cod_Ficha    VARCHAR(15)  NOT NULL,
  Version      VARCHAR(20)  NOT NULL,
  Fec_Emision  DATE         NOT NULL,
  Deno_Produc  VARCHAR(100) NOT NULL,
  Deno_Tec     VARCHAR(100) NULL,
  Vida_Util    VARCHAR(30)  NOT NULL,
  Condi_Alma   VARCHAR(100) NOT NULL,
  Presentacion VARCHAR(100) NOT NULL,
  Respon_Aprob VARCHAR(100) NOT NULL,
  Cod_Produc   VARCHAR(15)  NOT NULL,
  Ruc_Prov     CHAR(11)     NOT NULL,
  Num_Reg_San  VARCHAR(20)  NOT NULL,
  PRIMARY KEY (Cod_Ficha),
  CONSTRAINT fk_ficha_sum FOREIGN KEY (Ruc_Prov, Cod_Produc)
    REFERENCES Suministra (Ruc_Prov, Cod_Produ),      -- FK compuesta
  CONSTRAINT fk_ficha_reg FOREIGN KEY (Num_Reg_San)
    REFERENCES RegistroSanitario (Num_Reg_San),
  INDEX idx_ficha_prov_prod (Ruc_Prov, Cod_Produc),   -- índice compuesto
  INDEX idx_ficha_reg (Num_Reg_San)
) ENGINE=InnoDB;