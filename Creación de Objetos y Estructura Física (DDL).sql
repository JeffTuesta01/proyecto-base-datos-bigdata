USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DW_CrediAvanza_Final')
    DROP DATABASE DW_CrediAvanza_Final;
GO

CREATE DATABASE DW_CrediAvanza_Final;
GO

USE DW_CrediAvanza_Final;
GO

-- 1. TABLA DE PASO (STAGING)
CREATE TABLE STG_Clientes_Origen (
    id_cliente NCHAR(50), nombre_cliente NCHAR(100), sector_economico NCHAR(50), tipo_documento NCHAR(20), numero_documento NCHAR(11),
    id_agencia INT, nombre_agencia NCHAR(50), departamento NCHAR(50), ciudad NCHAR(50), fecha_corte DATE,
    monto_prestado DECIMAL(18,2), saldo_pendiente DECIMAL(18,2), monto_mora DECIMAL(18,2), dias_atraso INT
);
GO

-- 2. TABLAS DE DIMENSIONES (CUMPLIENDO TU DIAGRAMA EXACTO)
CREATE TABLE D_Cliente (
    id_cliente NCHAR(50) NOT NULL PRIMARY KEY,
    nombre_cliente NCHAR(100) NULL,
    sector_economico NCHAR(50) NULL,
    tipo_documento NCHAR(20) NULL
);

CREATE TABLE D_Agencia (
    id_agencia INT NOT NULL PRIMARY KEY,
    nombre_agencia NCHAR(50) NULL,
    departamento NCHAR(50) NULL,
    ciudad NCHAR(50) NULL
);

CREATE TABLE D_EstadoCredito (
    id_estado INT NOT NULL PRIMARY KEY,
    nivel_riesgo NCHAR(20) NULL,
    estado_morosidad NCHAR(20) NULL
);

CREATE TABLE D_Tiempo (
    id_tiempo NCHAR(50) NOT NULL PRIMARY KEY,
    mes INT NULL,
    [año] INT NULL
);
GO

-- 3. TABLA DE HECHOS (CON id_sucursal EXPLICITADO COMO TU FIGURA)
CREATE TABLE H_Prestamos (
    id_prestamo INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_cliente NCHAR(50) NOT NULL,
    id_sucursal INT NOT NULL, -- << Aquí se corrigió para que calce con tu gráfico
    id_estado INT NOT NULL,
    id_tiempo NCHAR(50) NOT NULL,
    monto_prestado DECIMAL(18,2) NULL,
    saldo_pendiente DECIMAL(18,2) NULL,
    monto_mora DECIMAL(18,2) NULL,
    dias_atraso_actual INT NULL,
    
    CONSTRAINT FK_H_Prestamos_D_Cliente FOREIGN KEY (id_cliente) REFERENCES D_Cliente(id_cliente),
    CONSTRAINT FK_H_Prestamos_D_Agencia FOREIGN KEY (id_sucursal) REFERENCES D_Agencia(id_agencia),
    CONSTRAINT FK_H_Prestamos_D_EstadoCredito FOREIGN KEY (id_estado) REFERENCES D_EstadoCredito(id_estado),
    CONSTRAINT FK_H_Prestamos_D_Tiempo FOREIGN KEY (id_tiempo) REFERENCES D_Tiempo(id_tiempo)
);
GO