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

IF SCHEMA_ID(N'Hospedaje') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA Hospedaje AUTHORIZATION dbo;');
    PRINT 'Se ha creado el esquema Hospedaje';
END
ELSE 
BEGIN 
    PRINT 'Esquema Hospedaje existe'
END;
GO

/*
Creación de Tablas
Validar Existencia -> Crear la tabla
*/

-- 1. Pais
IF OBJECT_ID('JDCC.Pais', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.Pais;
    PRINT 'La tabla JDCC.Pais eliminada';
END
GO

CREATE TABLE JDCC.Pais (
    ID_Pais INT IDENTITY(1,1) PRIMARY KEY,
    NombrePais VARCHAR(50) NOT NULL,
    CodigoIso CHAR(3) NOT NULL, -- PER, ARG, CHL, COL
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT UQ_NombrePais UNIQUE (NombrePais),
    CONSTRAINT UQ_CodigoIso UNIQUE (CodigoIso)
);
PRINT 'La tabla JDCC.Pais creada';
GO

-- 2. Nacionalidad
IF OBJECT_ID('JDCC.Nacionalidad', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.Nacionalidad;
    PRINT 'La tabla JDCC.Nacionalidad eliminada';
END
GO

CREATE TABLE JDCC.Nacionalidad (
    ID_Nacionalidad INT IDENTITY(1,1),
    ID_Pais INT NOT NULL,
    Nombre_Nacionalidad VARCHAR(80) NOT NULL,
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Nacionalidad PRIMARY KEY (ID_Nacionalidad),
    CONSTRAINT UQ_Nombre_Nacionalidad UNIQUE (Nombre_Nacionalidad),
    CONSTRAINT FK_Pais_Nacionalidad FOREIGN KEY (ID_Pais) REFERENCES JDCC.Pais(ID_Pais)
);
PRINT 'Tabla JDCC.Nacionalidad creada';
GO

-- 3. Region (Departamento)
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
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Region PRIMARY KEY (ID_Region),
    CONSTRAINT FK_Region_Pais FOREIGN KEY (ID_Pais) REFERENCES JDCC.Pais(ID_Pais),
    CONSTRAINT UQ_Nombre_Region UNIQUE (Nombre_Region)
);
PRINT 'Tabla JDCC.Region creada';
GO

-- 4. SubRegion (Provincia)
IF OBJECT_ID('JDCC.SubRegion', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.SubRegion;
    PRINT 'La tabla JDCC.SubRegion eliminada';
END
GO

CREATE TABLE JDCC.SubRegion (
    ID_Subregion INT IDENTITY(1,1),
    Nombre_SubRegion NVARCHAR(100) NOT NULL,
    Codigo_Ubigeo VARCHAR(4) NOT NULL,
    ID_Region INT NOT NULL,
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_SubRegion PRIMARY KEY (ID_Subregion),
    CONSTRAINT FK_Region_SubRegion FOREIGN KEY (ID_Region) REFERENCES JDCC.Region(ID_Region)
);
PRINT 'Tabla JDCC.SubRegion creada';
GO

-- 5. Ciudad (Distrito)
IF OBJECT_ID('JDCC.Ciudad', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.Ciudad;
    PRINT 'La tabla JDCC.Ciudad eliminada';
END
GO

CREATE TABLE JDCC.Ciudad (
    ID_Ciudad INT IDENTITY(1,1),
    Nombre_Ciudad VARCHAR(80) NOT NULL,
    Codigo_Ubigeo VARCHAR(6),
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    ID_SubRegion INT NOT NULL,
    CONSTRAINT PK_Ciudad PRIMARY KEY (ID_Ciudad),
    CONSTRAINT FK_Ciudad_Subregion FOREIGN KEY (ID_SubRegion) REFERENCES JDCC.SubRegion(ID_Subregion)
);
PRINT 'La tabla JDCC.Ciudad ha sido creada';
GO

-- 6. TipoDocumento
IF OBJECT_ID('RRHH.TipoDocumento', 'U') IS NOT NULL
BEGIN
    DROP TABLE RRHH.TipoDocumento;
    PRINT 'La tabla RRHH.TipoDocumento eliminada';
END
GO

CREATE TABLE RRHH.TipoDocumento (
    ID_TipoDocumento INT IDENTITY(1,1),
    Nombre_Doc VARCHAR(50) NOT NULL,
    Abreviatura VARCHAR(10) NOT NULL,
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_TipoDocumento PRIMARY KEY (ID_TipoDocumento),
    CONSTRAINT UQ_Nombre_Doc UNIQUE (Nombre_Doc),
    CONSTRAINT UQ_Abreviatura UNIQUE (Abreviatura)
);
PRINT 'La tabla RRHH.TipoDocumento creada';
GO

-- 7. Persona
IF OBJECT_ID('RRHH.Persona', 'U') IS NOT NULL
BEGIN
    DROP TABLE RRHH.Persona;
    PRINT 'La tabla RRHH.Persona eliminada';
END
GO

CREATE TABLE RRHH.Persona (
    ID_Persona INT IDENTITY(1,1),
    Tipo_Persona CHAR(1) NOT NULL, -- N: Persona Natural, J: Persona Jurídica
    CONSTRAINT CHK_Tipo_Persona CHECK (Tipo_Persona IN ('N', 'J')),
    Nombres VARCHAR(100),
    Apellido_Paterno VARCHAR(100),
    Apellido_Materno VARCHAR(100),
    Razon_Social VARCHAR(200) NOT NULL,
    Nombre_Comercial VARCHAR(200),
    ID_Tipo_Documento INT NOT NULL,
    Numero_Documento VARCHAR(20) NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(150),
    ID_Nacionalidad INT NOT NULL,
    Estado VARCHAR(20) DEFAULT 'Activo',
    CONSTRAINT CHK_Estado CHECK (Estado IN ('Activo', 'Inactivo')),
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Persona PRIMARY KEY (ID_Persona),
    CONSTRAINT UQ_Persona_Documento UNIQUE (ID_Tipo_Documento, Numero_Documento),
    CONSTRAINT FK_Persona_TipoDocumento FOREIGN KEY (ID_Tipo_Documento) REFERENCES RRHH.TipoDocumento(ID_TipoDocumento),
    CONSTRAINT FK_Persona_Nacionalidad FOREIGN KEY (ID_Nacionalidad) REFERENCES JDCC.Nacionalidad(ID_Nacionalidad),
    CONSTRAINT CHK_NumeroTelefono CHECK (
        Telefono IS NULL
        OR (
            LEN(LTRIM(RTRIM(Telefono))) BETWEEN 7 AND 20
            AND Telefono NOT LIKE '%[^0-9+() -]%'
        )
    )
);
PRINT 'Tabla RRHH.Persona creada';
GO

-- 8. Cargo
IF OBJECT_ID('RRHH.Cargo', 'U') IS NOT NULL
BEGIN
    DROP TABLE RRHH.Cargo;
    PRINT 'La tabla RRHH.Cargo eliminada';
END
GO

CREATE TABLE RRHH.Cargo (
    ID_Cargo INT IDENTITY(1,1),
    Nombre_Cargo VARCHAR(50) NOT NULL,
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    Descripcion VARCHAR(MAX),
    Salario_Base DECIMAL(10,2),
    CONSTRAINT PK_Cargo PRIMARY KEY (ID_Cargo)
);
PRINT 'Tabla RRHH.Cargo creada';
GO

-- 9. Direccion
IF OBJECT_ID('JDCC.Direccion', 'U') IS NOT NULL
BEGIN
    DROP TABLE JDCC.Direccion;
    PRINT 'La tabla JDCC.Direccion eliminada';
END
GO

CREATE TABLE JDCC.Direccion (
    ID_Direccion INT IDENTITY(1,1),
    ID_Ciudad INT NOT NULL,
    Tipo_Calle NVARCHAR(50) NOT NULL, -- Av., Jr., Psje.
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    Calle NVARCHAR(200) NOT NULL,
    Numero NVARCHAR(10) DEFAULT 'S/N',
    Referencia NVARCHAR(MAX),
    Codigo_Postal NVARCHAR(10) NOT NULL,
    CONSTRAINT CHK_Zip CHECK (LEN(Codigo_Postal) BETWEEN 5 AND 10),
    Latitud DECIMAL(10,8) NULL,
    Longitud DECIMAL(11,8) NULL,
    Altitud DECIMAL(10,2) NULL,
    CONSTRAINT PK_Direccion PRIMARY KEY (ID_Direccion),
    CONSTRAINT FK_Direccion_Ciudad FOREIGN KEY (ID_Ciudad) REFERENCES JDCC.Ciudad(ID_Ciudad)
);
PRINT 'Tabla JDCC.Direccion creada';
GO

-- 10. Cliente
IF OBJECT_ID('Ventas.Cliente', 'U') IS NOT NULL
BEGIN
    DROP TABLE Ventas.Cliente;
    PRINT 'La tabla Ventas.Cliente eliminada';
END
GO

CREATE TABLE Ventas.Cliente (
    ID_Persona INT NOT NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (ID_Persona),
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    Fecha_Nacimiento DATE NOT NULL,
    Genero VARCHAR(20), -- Masculino, Femenino, No Especifica, Prefiero no decirlo
    Preferencias_Viaje VARCHAR(150) NULL,
    Contacto_Emergencia VARCHAR(150) NULL,
    Telefono_Emergencia VARCHAR(20) NULL,
    Observaciones VARCHAR(MAX),
    Punto_Fidelidad INT DEFAULT 0,
    Nivel_Cliente VARCHAR(20) DEFAULT 'Basico' NOT NULL, -- Basico, Bronce, Plata, Oro
    CONSTRAINT FK_Cliente_Persona FOREIGN KEY (ID_Persona) REFERENCES RRHH.Persona(ID_Persona)
);
PRINT 'Tabla Ventas.Cliente creada';
GO

-- 11. Empleado
IF OBJECT_ID('RRHH.Empleado', 'U') IS NOT NULL
BEGIN
    DROP TABLE RRHH.Empleado;
    PRINT 'La tabla RRHH.Empleado eliminada';
END
GO

CREATE TABLE RRHH.Empleado (
    ID_Persona INT NOT NULL,
    CONSTRAINT PK_Empleado PRIMARY KEY (ID_Persona),
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    Cod_Empleado VARCHAR(15) NULL,
    Fecha_Ingreso DATE NOT NULL,
    Fecha_Cese DATE NULL,
    Tipo_Contrato VARCHAR(30) NULL,
    Estado_Laboral VARCHAR(20) NOT NULL DEFAULT 'Activo',
    CONSTRAINT CHK_Estado_Laboral CHECK (Estado_Laboral IN ('Activo', 'Inactivo', 'Suspendido')),
    CONSTRAINT FK_Empleado_Persona FOREIGN KEY (ID_Persona) REFERENCES RRHH.Persona(ID_Persona),
    Jornada_Laboral VARCHAR(30) NULL,
    Regimen_Laboral VARCHAR(30) NULL,
    ID_Supervisor INT NULL,
    Contacto_Emergencia VARCHAR(150) NULL,
    Telefono_Emergencia VARCHAR(20) NULL,
    Observaciones VARCHAR(MAX),
    CONSTRAINT UQ_Codigo_Empleado UNIQUE (Cod_Empleado),
    CONSTRAINT FK_Empleado_Supervisor FOREIGN KEY (ID_Supervisor) REFERENCES RRHH.Empleado(ID_Persona)
);
PRINT 'Tabla RRHH.Empleado creada';
GO

-- 12. Direccion_Cliente
IF OBJECT_ID('Ventas.Direccion_Cliente', 'U') IS NOT NULL
BEGIN
    DROP TABLE Ventas.Direccion_Cliente;
    PRINT 'La tabla Ventas.Direccion_Cliente eliminada';
END
GO

CREATE TABLE Ventas.Direccion_Cliente (
    ID_Persona INT NOT NULL,
    ID_Direccion INT NOT NULL,
    Tipo_Direccion VARCHAR(20) NOT NULL,
    Estado_Direccion VARCHAR(20) NOT NULL DEFAULT 'Activo',
    CONSTRAINT CHK_Estado_Direccion CHECK (Estado_Direccion IN ('Activo', 'Inactivo', 'Suspendido')),
    CONSTRAINT CHK_Tipo_Direccion CHECK (Tipo_Direccion IN ('Casa', 'Trabajo', 'Facturacion', 'Entrega')),
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    Es_Principal BIT DEFAULT 0 NOT NULL,
    CONSTRAINT PK_Persona_Direccion PRIMARY KEY (ID_Persona, ID_Direccion),
    CONSTRAINT FK_Direccion_Cliente_Cliente FOREIGN KEY (ID_Persona) REFERENCES Ventas.Cliente(ID_Persona),
    CONSTRAINT FK_Direccion_Cliente_Direccion FOREIGN KEY (ID_Direccion) REFERENCES JDCC.Direccion(ID_Direccion)
);
PRINT 'Tabla Ventas.Direccion_Cliente creada';
GO

-- 13. Direccion_Empleado
IF OBJECT_ID('RRHH.Direccion_Empleado', 'U') IS NOT NULL
BEGIN
    DROP TABLE RRHH.Direccion_Empleado;
    PRINT 'La tabla RRHH.Direccion_Empleado eliminada';
END
GO

CREATE TABLE RRHH.Direccion_Empleado (
    ID_Persona INT NOT NULL,
    ID_Direccion INT NOT NULL,
    Tipo_Direccion VARCHAR(20) NOT NULL,
    Estado_Direccion VARCHAR(20) NOT NULL DEFAULT 'Activo',
    CONSTRAINT CHK_Estado_Direccion_Emp CHECK (Estado_Direccion IN ('Activo', 'Inactivo', 'Suspendido')),
    CONSTRAINT CHK_Tipo_Direccion_Emp CHECK (Tipo_Direccion IN ('Casa', 'Trabajo')),
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    Es_Principal BIT DEFAULT 0 NOT NULL,
    CONSTRAINT PK_Emp_Direccion PRIMARY KEY (ID_Persona, ID_Direccion),
    CONSTRAINT FK_Direccion_Emp_Empleado FOREIGN KEY (ID_Persona) REFERENCES RRHH.Empleado(ID_Persona),
    CONSTRAINT FK_Direccion_Emp_Direccion FOREIGN KEY (ID_Direccion) REFERENCES JDCC.Direccion(ID_Direccion)
);
PRINT 'Tabla RRHH.Direccion_Empleado creada';
GO

-- 14. Tabla Categoria_Proveedor
IF OBJECT_ID('Compras.Categoria_Proveedor', 'U') IS NOT NULL
BEGIN
    DROP TABLE Compras.Categoria_Proveedor;
    PRINT 'La tabla Compras.Categoria_Proveedor eliminada';
END
GO

CREATE TABLE Compras.Categoria_Proveedor(
    ID_Categoria_Proveedor INT IDENTITY(1,1),
    Nombre_Categoria_Proveedor VARCHAR(60) NOT NULL,
    Descripcion VARCHAR(MAX),
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Categoria_Proveedor PRIMARY KEY (ID_Categoria_Proveedor),
    CONSTRAINT UQ_Nombre_Categoria_Proveedor UNIQUE (Nombre_Categoria_Proveedor)
);
PRINT 'Tabla Compras.Categoria_Proveedor creada'; 
GO

-- 15. Tabla Proveedor
IF OBJECT_ID('Compras.Proveedor', 'U') IS NOT NULL
BEGIN
    DROP TABLE Compras.Proveedor;
    PRINT 'La tabla Compras.Proveedor eliminada';
END
GO

CREATE TABLE Compras.Proveedor (
    ID_Persona INT NOT NULL,
    Codigo_Proveedor VARCHAR(15) NULL,
    Fecha_Inicio_Relacion DATE NOT NULL,
    Fecha_Fin_Relacion DATE NOT NULL, 
    Sitio_Web NVARCHAR(250) NULL,
    Requiere_Contrato BIT NOT NULL DEFAULT 0,
    Observaciones NVARCHAR(MAX) NULL,
    Estado_Proveedor VARCHAR(20) NOT NULL DEFAULT 'Activo',
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Proveedor PRIMARY KEY (ID_Persona),
    CONSTRAINT CHK_Estado_Proveedor CHECK (Estado_Proveedor IN ('Activo', 'Inactivo', 'Suspendido')),
    CONSTRAINT FK_Proveedor FOREIGN KEY (ID_Persona) REFERENCES RRHH.Persona(ID_Persona)
);
PRINT 'Tabla Compras.Proveedor creada';
GO

-- 16. Direccion_Proveedor
IF OBJECT_ID('RRHH.Direccion_Proveedor', 'U') IS NOT NULL
BEGIN
    DROP TABLE RRHH.Direccion_Proveedor;
    PRINT 'La tabla RRHH.Direccion_Proveedor eliminada';
END
GO

CREATE TABLE RRHH.Direccion_Proveedor (
    ID_Persona INT NOT NULL,
    ID_Direccion INT NOT NULL,
    Tipo_Direccion VARCHAR(20) NOT NULL,
    Estado_Direccion VARCHAR(20) NOT NULL DEFAULT 'Activo',
    CONSTRAINT CHK_Estado_Direccion_Proveedor CHECK (Estado_Direccion IN ('Activo', 'Inactivo', 'Suspendido')),
    CONSTRAINT CHK_Tipo_Direccion_Proveedor CHECK (Tipo_Direccion IN ('Casa', 'Envio','Física','Atención','Pago','Sucursal','Almacen','Operativa')),
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    Es_Principal BIT DEFAULT 0 NOT NULL,
    CONSTRAINT PK_Proveedor_Direccion PRIMARY KEY (ID_Persona, ID_Direccion),
    CONSTRAINT FK_Direccion_Proveeodr_Empleado FOREIGN KEY (ID_Persona) REFERENCES RRHH.Empleado(ID_Persona),
    CONSTRAINT FK_Direccion_Proveedor_Direccion FOREIGN KEY (ID_Direccion) REFERENCES JDCC.Direccion(ID_Direccion)
);
PRINT 'Tabla RRHH.Direccion_Proveedor creada';
GO

-- 17. Tipo_Alojamiento
IF OBJECT_ID('Hospedaje.Tipo_Alojamiento', 'U') IS NOT NULL
BEGIN
    DROP TABLE Hospedaje.Tipo_Alojamiento;
    PRINT 'La tabla Hospedaje.Tipo_Alojamiento eliminada';
END
GO

CREATE TABLE Hospedaje.Tipo_Alojamiento(
    ID_Tipo_Alojamiento INT IDENTITY(1,1), 
    Nombre_Tipo VARCHAR(50) NOT NULL, --Hotel, Casa de Campo, Hostal, 
    Descripcion NVARCHAR(MAX) NULL, 
    Icono_URL VARCHAR(255) NULL,
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Tipo_Alojamiento PRIMARY KEY (ID_Tipo_Alojamiento),
    CONSTRAINT UQ_Nombre_Tipo UNIQUE (Nombre_Tipo)
);
PRINT 'Tabla Hospedaje.Tipo_Alojamiento creada'
GO

-- 18. Alojamiento
IF OBJECT_ID('Hospedaje.Alojamiento', 'U') IS NOT NULL
BEGIN
    DROP TABLE Hospedaje.Alojamiento;
    PRINT 'La tabla Hospedaje.Alojamiento eliminada';
END
GO

CREATE TABLE Hospedaje.Alojamiento (
    ID_Alojamiento int identity(1,1), 
    CONSTRAINT PK_Alojamiento PRIMARY KEY (ID_Alojamiento), 
    ID_Tipo_Alojamiento INT NOT NULL,
    CONSTRAINT FK_Tipo_Alojamiento FOREIGN KEY (ID_Tipo_Alojamiento) REFERENCES Hospedaje.Tipo_Alojamiento(ID_Tipo_Alojamiento),
    NONBRE VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20),
    Correo VARCHAR(100), 
    Categoria_Estrellas TINYINT, 
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT CHK_Categoria_Estrellas CHECK (Categoria_Estrellas BETWEEN 1 AND 5) -- Aplica solo a hoteles
); 
PRINT 'Tabla Hospedaje.Alojamiento creada'
GO

-- 19. Direccion_Alojamiento
IF OBJECT_ID('Hospedaje.Direccion_Alojamiento', 'U') IS NOT NULL
BEGIN
    DROP TABLE Hospedaje.Direccion_Alojamiento;
    PRINT 'La tabla Hospedaje.Direccion_Alojamiento eliminada';
END
GO

CREATE TABLE Hospedaje.Direccion_Alojamiento (
    ID_Alojamiento INT NOT NULL, 
    ID_Direccion INT NOT NULL,
    Tipo_Direccion VARCHAR(20) NOT NULL DEFAULT 'Física',
    Referencia VARCHAR(MAX),
    Es_Principal BIT DEFAULT 0,
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Direccion_Alojamiento PRIMARY KEY (ID_Alojamiento, ID_Direccion),
    CONSTRAINT FK_ID_Alojamiento FOREIGN KEY (ID_Alojamiento) REFERENCES Hospedaje.Alojamiento(ID_Alojamiento), 
    CONSTRAINT FK_ID_Direccion FOREIGN KEY (ID_Direccion) REFERENCES JDCC.Direccion(ID_Direccion)
);
PRINT 'Tabla Hospedaje.Direccion_Alojamiento creada'
GO

-- 20. Proveedor_Alojamiento
IF OBJECT_ID('Hospedaje.Proveedor_Alojamiento', 'U') IS NOT NULL
BEGIN
    DROP TABLE Hospedaje.Proveedor_Alojamiento;
    PRINT 'La tabla Hospedaje.Proveedor_Alojamiento eliminada';
END
GO

CREATE TABLE Hospedaje.Proveedor_Alojamiento(
    ID_Proveedor_Alojamiento INT NOT NULL IDENTITY(1,1),
    ID_Persona INT NOT NULL,
    ID_Alojamiento INT NOT NULL,
    Fecha_Registro DATETIME DEFAULT GETDATE(),
    CONSTRAINT PK_Proveedor_Alojamiento PRIMARY KEY (ID_Proveedor_Alojamiento), 
    CONSTRAINT FK_Persona_Proveedor_Alojamiento FOREIGN KEY (ID_Persona) REFERENCES RRHH.Persona(ID_Persona),
    CONSTRAINT FK_Alojamiento_Proveedor_Alojamiento FOREIGN KEY (ID_Alojamiento) REFERENCES Hospedaje.Alojamiento(ID_Alojamiento)
);
PRINT 'Tabla Hospedaje.Proveedor_Alojamiento creada'
GO

-- 21. Tipo_Habitacion
IF OBJECT_ID('Hospedaje.Tipo_Habitacion', 'U') IS NOT NULL
BEGIN
    DROP TABLE Hospedaje.Tipo_Habitacion;
    PRINT 'La tabla Hospedaje.Tipo_Habitacion eliminada';
END
GO

CREATE TABLE Hospedaje.Tipo_Habitacion(
    ID_Tipo_Habitacion INT IDENTITY(1,1),
    CONSTRAINT PK_ID_Tipo_Habitacion PRIMARY KEY (ID_Tipo_Habitacion),
    Nombre_Habitacion VARCHAR(50) NOT NULL,
    CONSTRAINT UQ_Nombre_Habitacion UNIQUE (Nombre_Habitacion),
    Capacidad_Persona INT NOT NULL,
    Descripcion VARCHAR(MAX),
    Fecha_Registro DATETIME DEFAULT GETDATE(),
);
PRINT 'Tabla Hospedaje.Tipo_Habitacion creada';
GO

