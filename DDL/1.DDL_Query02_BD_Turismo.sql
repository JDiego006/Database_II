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


-- Crear la tabla nacionalidad
IF OBJECT_ID('JDCC.Nacionalidad', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.Nacionalidad;
    PRINT 'La tabla JDCC.Nacionalidad eliminada';
END
GO

CREATE TABLE JDCC.Nacionalidad(
    ID_Nacionalidad INT IDENTITY(1,1),
    ID_Pais INT NOT NULL,
    Nombre_Nacionalidad VARCHAR(80) NOT NULL,
    CONSTRAINT pk_nacionalidad PRIMARY KEY (ID_Nacionalidad),
    CONSTRAINT UQ_Nombre_Nacionalidad UNIQUE (Nombre_Nacionalidad),
    CONSTRAINT FK_Pais_Nacionalidad FOREIGN KEY (ID_Pais) REFERENCES JDCC.Pais(ID_Pais)
);
GO
PRINT 'Tabla Nacionalidad Creada';


-- Crear tabla REGION (Departamento)
IF OBJECT_ID('JDCC.Region', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.Region;
    PRINT 'La tabla JDCC.Region eliminada';
END
GO

CREATE TABLE JDCC.Region (
    ID_Region INT IDENTITY(1,1),
    Nombre_Region VARCHAR(80) NOT NULL,
    Codigo_Ubigeo VARCHAR(3) NOT NULL, -- CAJ, LIM, CUS
    ID_Pais INT NOT NULL,
    CONSTRAINT PK_Region PRIMARY KEY (ID_Region),
    CONSTRAINT FK_Region_Pais FOREIGN KEY (ID_Pais) REFERENCES JDCC.Pais(ID_Pais),
    CONSTRAINT UQ_Nombre_Region UNIQUE (Nombre_Region)
);
print 'Tabla JDCC.Region creada';
GO

-- CREAR LA TABLA SUBREGION
IF OBJECT_ID('JDCC.SubRegion', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.SubRegion;
    PRINT 'La tabla JDCC.SubRegion eliminada';
END
GO

CREATE TABLE JDCC.SubRegion(
    ID_Subregion INT IDENTITY(1,1),
    Nombre_SubRegion NVARCHAR(100) NOT NULL,
    Codigo_Ubigeo VARCHAR(4) NOT NULL,
    ID_Region INT NOT NULL,
    CONSTRAINT PK_SubRegion PRIMARY KEY (ID_Subregion),
    CONSTRAINT FK_Region_SubRegion FOREIGN KEY (ID_Region) REFERENCES JDCC.Region(ID_Region)
);
PRINT 'Tabla JDCC.SubRegion creada';
GO

-- Crear la tabla ciudad (Distrito)
IF OBJECT_ID('JDCC.Ciudad', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.Ciudad;
    PRINT 'La tabla JDCC.Ciudad eliminada';
END
GO

CREATE TABLE JDCC.Ciudad(
    ID_Ciudad INT IDENTITY (1,1),
    Nombre_Ciudad VARCHAR (80) NOT NULL, 
    Codigo_Ubigeo VARCHAR(6),
    ID_SubRegion INT NOT NULL,
    CONSTRAINT PK_Ciudad PRIMARY KEY (ID_Ciudad), 
    CONSTRAINT FK_Ciudad_Subregion FOREIGN KEY (ID_SubRegion) REFERENCES JDCC.SubRegion(ID_Subregion)
);
PRINT 'La tabla JDCC.Ciudad a sido creada';
GO

-- Crear tabla tipo de documento
IF OBJECT_ID('RRH.TipoDocumento', 'U') IS NOT NULL
BEGIN
    DROP TABLE RRHH.TipoDocumento;
    PRINT 'La tabla RRHH.TipoDocumento eliminada';
END
GO

CREATE TABLE RRHH.TipoDocumento(
    ID_TipoDocumento INT IDENTITY(1,1),
    Nombre_Doc VARCHAR(50) NOT NULL,
    Abreviatura VARCHAR(10) NOT NULL,
    CONSTRAINT PK_TipoDocumento PRIMARY KEY (ID_TipoDocumento),
    CONSTRAINT UQ_Nombre_Doc UNIQUE (Nombre_Doc),
    CONSTRAINT UQ_Abreviatura UNIQUE (Abreviatura)
);
PRINT 'La tabla RRHH.TipoDocumento creada'
GO


-- Crear tabla Persona
IF OBJECT_ID('RRH.Persona', 'U') IS NOT NULL
BEGIN
    DROP TABLE RRHH.Persona;
    PRINT 'La tabla RRHH.Persona eliminada';
END
GO

CREATE TABLE RRHH.Persona (
    ID_Persona INT IDENTITY(1,1), 
    Tipo_Persona CHAR(2) NOT NULL --N: Persona Natural, J: Persona Jurìdica
    CONSTRAINT CHK_Tipo_Persona CHECK (Tipo_Persona in ('N', 'J')),
    Nombres VARCHAR(100),
    Apellido_Paterno VARCHAR(100),
    Apellido_Materno VARCHAR(100),
    Razon_Social VARCHAR (200) NOT NULL, -- Es equivalente al nombre de la persona
    Nombre_Comercial VARCHAR(200), 
    ID_Tipo_Documento INT NOT NULL, 
    Numero_Documento VARCHAR(20) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(150), 
    ID_Nacionalidad INT NOT NULL, 
    Estado VARCHAR(20) DEFAULT 'Activo', 
    CONSTRAINT CHK_Estado CHECK (estado in ('Activo', 'Inactivo')) ,

    CONSTRAINT PK_Persona PRIMARY KEY (ID_Persona), 
    CONSTRAINT UQ_Persona_Documento UNIQUE(ID_Tipo_Documento, Numero_Documento),
    CONSTRAINT FK_Persona_TipoDocumento FOREIGN KEY (ID_Tipo_Documento) REFERENCES RRHH.TipoDocumento(ID_TipoDocumento),
    CONSTRAINT FK_Persona_Nacionalidad FOREIGN KEY (ID_Nacionalidad) REFERENCES JDCC.Nacionalidad(ID_Nacionalidad),
    CONSTRAINT CHK_NumeroTelefono CHECK(
    LEN(LTRIM(RTRIM(Telefono))) BETWEEN 12 AND 20
    AND Telefono NOT LIKE '%[^0-9+()]%'
    )
 );
 PRINT 'Tabla RRHH.Persona creada';
 GO


-- Crear la tabla Cargo 
IF OBJECT_ID('RRH.Cargo', 'U') IS NOT NULL
BEGIN
    DROP TABLE RRHH.Cargo;
    PRINT 'La tabla Cargo.Persona eliminada';
END
GO

CREATE TABLE RRHH.Cargo (
    ID_Cargo INT IDENTITY (1,1),
    Nombre_Cargo VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(MAX),
    Salario_Base DECIMAL(10,2),
    CONSTRAINT PK_CARGO PRIMARY KEY (ID_Cargo)
);
PRINT ('Tabla RRHH.Cargo creada');
GO

