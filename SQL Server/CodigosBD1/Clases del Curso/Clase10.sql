--Clase 10 
USE Normalizar
go

--Crear tabla sin normalizar
CREATE TABLE dbo.Empleado
(
	NombreEmpleado NVARCHAR(50),
	Oficina NVARCHAR(50),
	Salario INT, --podria ser decimal o double
	SupervisorAsignado NVARCHAR(50),
	FechaIngreso DATE
);
go

--Insertar registros a la tabla empleado
INSERT INTO DBO.Empleado
VALUES 
	('Pedro Ramirez','Central',100000,'Marta Solis','2020-01-01'),
	('Carlos Tencio','Central',100000,'Marta Solis','2020-02-01'),
	('Maria Porras','Heredia',100000,'Gilberth Mora','2020-03-01'),
	('Keneth Marin','Heredia',100000,'Gilberth Mora','2020-04-01'),
	('Karla Fallas','Cartago',15000,'Francisco Tencio','2020-05-01'),
	('Ana Rojas','Cartago',25000,'Francisco Tencio','2020-06-01')
go

--Consulta de datos de la tabla 
SELECT * FROM DBO.Empleado


---Se realiza un modelado de datos para saber la cantidad de tablas que se ocupan
--- y asi poder encontrar las relaciones entre las mismas y un mejor orden de datos

-----------------------------------
--NORMALIZACION DE BASE DE DATOS
-----------------------------------

--Crear tabla de oficina
CREATE TABLE DBO.Sucursales
(
	IDSucursal INT IDENTITY (1,1) NOT NULL,
	NombreSucursal NVARCHAR(20) UNIQUE NOT NULL,
	CONSTRAINT PK_IDSucursal PRIMARY KEY (IDSucursal)
);
go

--Insertar registros a la talba sucursales leyendo la tabla
INSERT INTO DBO.Sucursales (NombreSucursal)
SELECT DISTINCT Oficina FROM DBO.Empleado
go

--Consultar datos de la tabla
SELECT*FROM DBO.Sucursales

--Crear tabla supervisores
CREATE TABLE DBO.Supervisores
(
	IDSupervisor INT IDENTITY (1,1) NOT NULL,
	NombreSupervisor NVARCHAR(100) NOT NULL,
	IDSucursal INT NOT NULL,
	CONSTRAINT PK_IDSupervisor PRIMARY KEY (IDSupervisor),
	CONSTRAINT FK_IDSucursal FOREIGN KEY (IDSucursal) REFERENCES DBO.sucursales(IDSucursal)
);
go

--Insertar Datos en tabla
INSERT INTO DBO.Supervisores (NombreSupervisor, IDSucursal)
SELECT DISTINCT EMP.SupervisorAsignado, SUC.IDSucursal
FROM DBO.Empleado AS EMP JOIN DBO.Sucursales AS SUC 
ON EMP.Oficina = SUC.NombreSucursal
go

--Consultar tabla supervisores 
SELECT* FROM DBO.Supervisores

--Crear la tabla empleado temporal
CREATE TABLE dbo.Empleado_temporal
(
	IDEmpleado INT IDENTITY (1,1) NOT NULL,
	NombreEmpleado NVARCHAR (30) NOT NULL,
	ApellidoEmpleado NVARCHAR (30) NOT NULL,
	Salario INT NOT NULL,
	IDSucursal INT NOT NULL,
	IDSupervisor INT NOT NULL,
	CONSTRAINT PK_IDEmpleado PRIMARY KEY (IDEmpleado),
	CONSTRAINT FK_IDSucursal_Empleado FOREIGN KEY (IDSucursal) REFERENCES DBO.SUCURSALES(IDSucursal),
	CONSTRAINT FK_IDSupervisor FOREIGN KEY (IDSupervisor) REFERENCES dbo.supervisores(IDSupervisor)
);
go

--Insertar datos a la tabla supervisor
INSERT INTO DBO.Empleado_temporal(NombreEmpleado, ApellidoEmpleado, Salario, IDSucursal, IDSupervisor)
SELECT
	SUBSTRING(NombreEmpleado, 1, CHARINDEX(' ',NombreEmpleado)-1) AS NombreEmpleado,
	SUBSTRING(NombreEmpleado, CHARINDEX(' ',NombreEmpleado), LEN(NombreEmpleado)+1) AS ApellidoEmpleado,
	EMP.Salario,
	SUC.IDSucursal,
	SUP.IDSupervisor
FROM dbo.Empleado AS EMP 
JOIN dbo.Sucursales AS SUC ON EMP.Oficina = SUC.NombreSucursal
JOIN dbo.Supervisores AS SUP ON EMP.SupervisorAsignado = SUP.NombreSupervisor


--Consulta en tabla
SELECT*FROM DBO.Empleado_temporal

--Borrar tabla sin normalizar
DROP TABLE DBO.Empleado

--Renombro tabla empleado_temporal a empleado
EXEC sp_rename 'Empleado_temporal', 'Empleado'
go

--Consulta de tablas normalizadas
SELECT*FROM DBO.EMPLEADO
SELECT*FROM DBO.Sucursales
SELECT*FROM DBO.Supervisores