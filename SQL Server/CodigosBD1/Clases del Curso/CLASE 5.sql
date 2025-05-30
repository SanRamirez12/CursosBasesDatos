--CLASE 5

--CAMBIO A MASTER
USE MASTER
GO

--CREACIÓN DE BASE DE DATOS RentaCarUlat
CREATE DATABASE RentaCarUlat
GO

--CAMBIO A BD RentaCarUlat
USE RentaCarUlat
GO
---------------------------------
--CREAR TABLAS
---------------------------------

--CREACIÓN DE TABLA Sucursal
CREATE TABLE DBO.Sucursal
(
	IDSucursal		INT IDENTITY (1,1) NOT NULL,
	NombreSucursal	NVARCHAR (50) UNIQUE NOT NULL,
	CONSTRAINT PK_IDSucursal PRIMARY KEY (IDSucursal)
);
GO
--CREACIÓN DE TABLA EMPLEADO
CREATE TABLE DBO.Empleado
(
	IDEmpleado			INT IDENTITY (1,1) NOT NULL,
	CedulaEmpleado		VARCHAR (18) UNIQUE NOT NULL,
	NombreEmpleado		NVARCHAR (30) NOT NULL,
	Ape1Empleado		NVARCHAR (30) NOT NULL,
	Ape2Empleado		NVARCHAR (30) NOT NULL,
	TelefonoEmpleado	NVARCHAR (30) NOT NULL,
	DireccionEmpleado	NVARCHAR (150) NOT NULL,
	IDSucursal			INT NOT NULL,
	FechaIngreso		DATE NOT NULL
	CONSTRAINT PK_IDEmpleado PRIMARY KEY (IDEmpleado),
	CONSTRAINT FK_IDSucursal FOREIGN KEY (IDSucursal)
	REFERENCES Sucursal(IDSucursal)
);
GO
--CREAR TABLA Marca
CREATE TABLE DBO.Marca
(
	IDMarca		INT IDENTITY (1,1) NOT NULL,
	Marca		NVARCHAR (30) UNIQUE NOT NULL,
	PaisOrigen	NVARCHAR (30) NOT NULL
	Constraint PK_IDMarca PRIMARY KEY (IDMarca)
);
GO
--CREAR TABLA Vehiculo
CREATE TABLE DBO.Vehiculo
(
	IDVehiculo		INT IDENTITY (1,1) NOT NULL,
	IDMarca			INT NOT NULL,
	ModeloVehiculo	NVARCHAR (30) NOT NULL,
	PlacaVehiculo	VARCHAR (10) NOT NULL UNIQUE,
	AnioVehiculo	DATE NOT NULL,
	MontoAlqDia		INT NOT NULL
	CONSTRAINT PK_IDVehiculo PRIMARY KEY (IDVehiculo),
	CONSTRAINT FK_IDMarca FOREIGN KEY (IDMarca)
	REFERENCES Marca (IDMarca)
);
GO
--CREAR TABLA CLIENTE
CREATE TABLE DBO.Cliente
(
	IDCliente			INT IDENTITY (1,1) NOT NULL,
	CedulaCliente		VARCHAR (18) UNIQUE NOT NULL,
	NombreCliente		NVARCHAR (30) NOT NULL,
	Ape1Cliente			NVARCHAR (30) NOT NULL,
	Ape2Cliente			NVARCHAR (30) NOT NULL,
	TelefonoCliente		NVARCHAR (30) NOT NULL,
	DireccionCliente	NVARCHAR (150) NOT NULL
	CONSTRAINT PK_IDCliente PRIMARY KEY (IDCliente)
);
GO
--CREAR TABLA Alquiler
CREATE TABLE DBO.Alquiler
(
	IDAlquiler		INT IDENTITY (1,1) NOT NULL,
	IDSucursal		INT NOT NULL,
	IDCliente		INT NOT NULL,
	IDEmpleado		INT NOT NULL,
	IDVehiculo		INT NOT NULL,
	FechaInicio		DATE NOT NULL,
	FechaFinaliza	DATE NOT NULL,
	Total			INT NOT NULL
	CONSTRAINT PK_IDAlquiler PRIMARY KEY (IDAlquiler),
	CONSTRAINT FK_IDSucursalRenta FOREIGN KEY (IDSucursal)
	REFERENCES Sucursal(IDSucursal),
	CONSTRAINT FK_IDCliente FOREIGN KEY (IDCliente)
	REFERENCES Cliente(IDCliente),
	CONSTRAINT FK_IDEmpleado FOREIGN KEY (IDEmpleado)
	REFERENCES Empleado (IDEmpleado),
	CONSTRAINT FK_IDVehiculo FOREIGN KEY (IDVehiculo)
	REFERENCES Vehiculo (IDVehiculo)
);
GO

---------------------------------
--INSERTAR DATOS EN LAS TABLAS
---------------------------------

--INSERTAR DATOS EN TABLA SUCURSAL
INSERT INTO dbo.Sucursal (NombreSucursal)
VALUES 
	('San José'),
	('Heredia'),
	('Puntarenas'),
	('Liberia'),
	('Limón');
GO
--INSERTAR DATOS EN TABLA Empleado
INSERT INTO Empleado
(CedulaEmpleado,NombreEmpleado,Ape1Empleado,Ape2Empleado,TelefonoEmpleado,
DireccionEmpleado,IDSucursal,FechaIngreso)
VALUES
	('11111111','Juan','Pérez','Jimenez','22222-22222','San José',1,'2020-01-01'),
	('11111112','Ana','Sanchez','Rodriguez','22222-2223','Tibás',2,'2020-01-10'),
	('11111113','Luis','Martinez','García','22222-22224','Uruca',3,'2020-01-20'),
	('11111114','María','Fernandez','Gomez','22222-22225','Orotina',4,'2020-01-23'),
	('11111115','Carlos','Ramirez','Vargas','22222-22226','Matina',5,'2020-01-28');
GO
--INSERTAR DATOS EN LA TABLA Marca
INSERT INTO dbo.Marca (Marca, PaisOrigen)
VALUES
	('Toyota','Japón'),
	('Honda','Japón'),
	('Ford','Estados Unidos'),
	('Chevrolet','Estados Unidos'),
	('Hyundai','Corea'),
	('Audi','Aleman');
GO
--INSERTAR DATOS EN LA TABLA Vehiculo
INSERT INTO dbo.Vehiculo (IDMarca,ModeloVehiculo, PlacaVehiculo,AnioVehiculo,MontoAlqDia)
VALUES
	(1,'Corolla', 'ABC123', '2021-01-01',100000),
	(2,'Civic', 'ASD123', '2022-01-01',110000),
	(3,'Focus', 'RTG123', '2023-01-01',120000),
	(4,'Aveo', 'OPT555', '2024-01-01',130000),
	(5,'Elantra', 'FGT123', '2020-01-01',100000),
	(6,'RS6', 'SDF123', '2024-01-01',300000);
GO
--INSERTAR REGISTROS EN LA TABLA CLIENTES
INSERT INTO dbo.Cliente (CedulaCliente,NombreCliente,Ape1Cliente,Ape2Cliente,
TelefonoCliente, DireccionCliente)
VALUES
	('1-1111-1111','Pedro', 'Gomez','Lopez','2222-2222', 'Alajuela'),
	('1-1111-1112','Laura', 'Hernandez','Mora','2222-2223', 'Curridabat'),
	('1-1111-1113','Sofia', 'Vargas','Cruz','2222-2224', 'Cartago');
GO
--

--INSERTAR DATOS EN LA TABLA ALQUILERES
INSERT INTO Alquiler (IDSucursal, IDCliente, IDEmpleado, IDVehiculo, FechaInicio,
FechaFinaliza, Total)
VALUES	
	(1,1,1,2,'2024-10-09','2024-10-15',350000)
GO



