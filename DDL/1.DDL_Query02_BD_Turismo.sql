/*
Base Datos para sector turismo
-------------------------------
Incluye Reservas, Clientes, Empleados, Transporte, Hospedaje
Lugares turísticos, Proveedores, etc.
*/

-- USAR LA BD MASTER
USE master;
GO

-- Validar la existencia de la base de datos
IF DB_ID('Turismo_JDCC') IS NOT NULL
BEGIN
    DROP DATABASE Turismo_JDCC;
    PRINT 'Base de datos Turismo_JDCC eliminada';
END
GO


-- CREAR LA BASE DE DATOS
CREATE DATABASE Turismo_JDCC;
PRINT 'Se ha creado la base de datos Turismo_JDCC';
GO

-- Usando la base de datos turismo_jdcc
use Turismo_JDCC;
go

-- CAMBIAR A LA NUEVA BASE DE DATOS
USE Turismo_JDCC;
GO

-- CREAR ESQUEMAS

IF SCHEMA_ID(N'RRHH') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA RRHH AUTHORIZATION dbo');
    PRINT 'Se ha creado el esquema RRHH';
END
GO

IF SCHEMA_ID(N'Compras') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA Compras AUTHORIZATION dbo');
    PRINT 'Se ha creado el esquema Compras';
END
GO

IF SCHEMA_ID(N'Ventas') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA Ventas AUTHORIZATION dbo');
    PRINT 'Se ha creado el esquema Ventas';
END
GO

IF SCHEMA_ID(N'UNC') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA UNC AUTHORIZATION dbo');
    PRINT 'Se ha creado el esquema UNC';
END
GO

IF SCHEMA_ID(N'JDCC') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA JDCC AUTHORIZATION dbo');
    PRINT 'Se ha creado el esquema JDCC';
END
GO

/*
Creación de Tablas
Validar Existencia
Crear la tabla
*/

IF OBJECT_ID('JDCC.Pais', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.Pais;
    PRINT 'La tabla JDCC.Pais eliminada';
END
GO

CREATE TABLE JDCC.Pais
(
    -- Primera forma de poner PK
    ID_Pais INT IDENTITY(1,1) PRIMARY KEY,

    NombrePais VARCHAR(50) NOT NULL,

    CodigoIso CHAR(3) NOT NULL, -- PER, ARG, CHL, COL

    CONSTRAINT UQ_NombrePais
        UNIQUE (NombrePais),

    CONSTRAINT UQ_CodigoIso
        UNIQUE (CodigoIso)
);
GO

PRINT 'La tabla JDCC.Pais creada';
GO