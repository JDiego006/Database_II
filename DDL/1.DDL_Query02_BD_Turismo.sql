/* 
Base Datos para sector turismo
-------------------------------
Incluye Reservas, Clientes, Empleados,Transporte, Hospedaje
Lugares turísticos, Proveedores ect

*/

-- USAR LA BD MODEL 
use master;
go

-- Validar la existencia de la base de datos
if DB_ID('Turismo_JDCC') IS NULL 
BEGIN
	DROP DATABASE Turismo_JDCC;
	PRINT 'Base de datos Turismo_JDCC Eliminada'
END
GO

-- CREAR LA BASE DE DATOS
CREATE DATABASE Turismo_JDCC;
PRINT 'Se ha creado la base de datos Turismo_JDCC';
GO

-- CREAR UN ESQUEMA

IF SCHEMA_ID(N'RRHH') IS NULL
exec (N'Create schema RRHH Autorization dbo;');
go 
print 'Se ha creado el esquema RRHH';


IF SCHEMA_ID(N'Compras') IS NULL
exec (N'Create schema Compras Autorization dbo;');
go 
print 'Se ha creado el esquema Compras';

IF SCHEMA_ID(N'Ventas') IS NULL
exec (N'Create schema Ventas Autorization dbo;');
go 
print 'Se ha creado el esquema Ventas';

IF SCHEMA_ID(N'unc') IS NULL
exec (N'Create schema unc Autorizacion dbo;');
go 
print 'Se ha creado el esquema UNC';

IF SCHEMA_ID(N'JDCC') IS NULL
exec (N'Create schema JDCC Autorizacion dbo;');
go 
print 'Se ha creado el esquema JDCC';