USE master;
GO

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DEMO_UNC')
BEGIN
    DROP DATABASE DEMO_UNC;
    PRINT 'La base de datos DEMO_UNC eliminada';
END
GO

CREATE DATABASE DEMO_UNC;
PRINT 'La base de datos DEMO_UNC se creó';
GO

USE DEMO_UNC;
PRINT 'Está usando DEMO_UNC';
GO

ola fsdfa