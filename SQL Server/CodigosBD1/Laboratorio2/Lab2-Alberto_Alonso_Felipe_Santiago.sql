--Laboratorio #2 Base de Datos 1
--Estudiantes: Felipe Méndez Navarro, Santiago Ramírez Elizondo, Alberto Álvarez Navarro, Alonso Matarrita Obregón 

--Se utiliza la DB principal
USE MASTER
go

-- Se crea la DB AccesoriosJM
CREATE DATABASE AccesoriosJM
go

--Se utiliza la DB creada
USE AccesoriosJM
GO

--Se crea la tabla de Ventas sin normalizar 
CREATE TABLE DBO.VENTAS
(
	Cliente NVARCHAR(100) NOT NULL,
    Provincia NVARCHAR(50) NOT NULL,
    Telefono NVARCHAR(20) NOT NULL,
    IDVendedor INT NOT NULL,
    Vendedor NVARCHAR(100) NOT NULL,
    Producto NVARCHAR(100) NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitario INT NOT NULL,
    Sucursal NVARCHAR(100) NOT NULL
);
go

--Se insertan los registros en la tabla creada
INSERT INTO DBO.VENTAS (Cliente, Provincia, Telefono, IDVendedor, Vendedor, Producto, Cantidad, PrecioUnitario, Sucursal)
VALUES 
    ('María Fernández', 'San José', '2222-2222', 1, 'Juan Pérez', 'Laptop HP', 2, 800, 'San Pedro'),
    ('Carlos Soto', 'Alajuela', '8888-8888', 1, 'Juan Pérez', 'Teléfono Samsung', 4, 400, 'Cartago'),
    ('Ana Gutiérrez', 'Puntarenas', '8888-9999', 2, 'Mónica López', 'Tableta Lenovo', 3, 300, 'Paseo de las Flores'),
    ('Roberto Castro', 'Puntarenas', '6060-6060', 2, 'Mónica López', 'Auriculares Sony', 5, 50, 'San Pedro'),
    ('Marcela Mora', 'Cartago', '7070-7070', 3, 'Erick Flores', 'iPad', 1, 1500, 'Cartago');
GO

--Se visualizan la tabla creada
SELECT * FROM DBO.VENTAS

----------------------------------
--NORMALIZACION DE BASE DE DATOS--
----------------------------------

--Una vez hecho el modelaje de datos, se procede a crear e insertar datos en cada tabla una por una.

--Se crea la tabla Provincias
CREATE TABLE DBO.PROVINCIAS
(
	IDProvincia		VARCHAR (3) NOT NULL,
	NombreProvincia NVARCHAR (20) NOT NULL
	CONSTRAINT PK_IDProvincia PRIMARY KEY (IDProvincia)
);
GO

--Se insertan todas las posibles provincias en la tabla Provincias 
INSERT INTO PROVINCIAS (IDProvincia, NombreProvincia)
VALUES
	('SJ','San José'),
	('A','Alajuela'),
	('C','Cartago'),
	('H','Heredia'),
	('G','Guanacaste'),
	('P','Puntarenas'),
	('L','Limón');
GO

--Se visualizan los datos de provincias
SELECT*FROM DBO.PROVINCIAS

--Se crea la tabla Vendedores
CREATE TABLE DBO.VENDEDORES 
(
    IDVendedor			INT IDENTITY (1,1) NOT NULL,
    NombreVendedor		NVARCHAR(30) NOT NULL,
	ApellidoVendedor	NVARCHAR(30) NOT NULL,
	CONSTRAINT PK_IDVendedor PRIMARY KEY (IDVendedor)
);
GO

--Se hace un insert de los datos de los vendedores a la tabla Vendedores
INSERT INTO DBO.VENDEDORES (NombreVendedor, ApellidoVendedor)
SELECT DISTINCT
		SUBSTRING(Vendedor, 1, CHARINDEX(' ', Vendedor)-1) AS NombreVendedor,
		SUBSTRING(Vendedor, CHARINDEX(' ', Vendedor)+1, LEN(Vendedor)) AS ApellidoVendedor
FROM DBO.VENTAS;
GO

--Se visualizan los datos insertados en la tabla Vendedores
SELECT*FROM DBO.VENDEDORES

--Se crea la tabla Sucursales
CREATE TABLE DBO.SUCURSALES 
(
    IDSucursal		INT IDENTITY(1,1)NOT NULL,
    NombreSucursal	NVARCHAR(100) NOT NULL
	CONSTRAINT PK_IDSucursal PRIMARY KEY (IDSucursal)
);
GO

--Se insertan los datos en la tabla sucursales
INSERT INTO DBO.SUCURSALES (NombreSucursal)
SELECT DISTINCT 
    Sucursal AS NombreSucursal
FROM DBO.VENTAS;
GO

--Se visualizan los datos de la tabla sucursales
SELECT*FROM DBO.SUCURSALES

--Se crea la tabla Productos
CREATE TABLE DBO.PRODUCTOS 
(
    IDProducto		INT IDENTITY (1,1) NOT NULL,
    NombreProducto	NVARCHAR(100) NOT NULL,
    PrecioUnitario	INT NOT NULL,
	IDSucursal		INT NOT NULL,
	CONSTRAINT PK_IDProducto PRIMARY KEY (IDProducto),
	CONSTRAINT FK_IDSucursal FOREIGN KEY (IDSucursal) References Sucursales(IDSucursal)
);
GO

--Se insertan los datos de los productos en la Tabla productos
INSERT INTO DBO.PRODUCTOS (NombreProducto, PrecioUnitario, IDSucursal)
SELECT DISTINCT 
    Producto AS NombreProducto,
    PrecioUnitario,
	IDSucursal
FROM DBO.VENTAS AS V
INNER JOIN DBO.SUCURSALES AS S ON V.Sucursal = S.NombreSucursal
;
GO

--Se visualizan los datos de los productos
SELECT*FROM DBO.PRODUCTOS


--Se crea la tabla Clientes
CREATE TABLE DBO.CLIENTES
(
    IDCliente		INT IDENTITY(1,1) NOT NULL,
    NombreCliente	NVARCHAR(30) NOT NULL,
	ApellidoCliente NVARCHAR(30) NOT NULL,
    Telefono		NVARCHAR(20) NOT NULL,
	IDProvincia		VARCHAR(3) NOT NULL,
	CONSTRAINT PK_IDCliente		PRIMARY KEY (IDCliente),
	CONSTRAINT FK_IDProvincia	FOREIGN KEY(IDProvincia) REFERENCES Provincias(IDProvincia)
);
GO

--Se hace un insert de datos de clintes en la tabla Clientes creada
INSERT INTO DBO.CLIENTES (NombreCliente, ApellidoCliente, IDProvincia, Telefono)
SELECT DISTINCT
		SUBSTRING (Cliente, 1, CHARINDEX (' ', Cliente)-1)AS NombreCliente,
		SUBSTRING (Cliente, CHARINDEX (' ', CLiente)+1, LEN(Cliente)) AS ApellidoCliente,
		PRV.IDProvincia,
		Telefono
FROM DBO.VENTAS AS VT
INNER JOIN PROVINCIAS AS PRV ON VT.Provincia = PRV.NombreProvincia
GO

--Se visualizan la tabla cliente con los datos
SELECT*FROM DBO.CLIENTES


--Se crea la tabla que relaciona las otras tablas, sin redundar información: Tabla Ventas_Temporal
CREATE TABLE DBO.VENTAS_TEMPORAL
(
    IDVenta		INT IDENTITY(1,1) NOT NULL,
    IDCliente	INT NOT NULL,
    IDVendedor	INT NOT NULL,
    IDProducto	INT NOT NULL,
    Cantidad	INT NOT NULL,
	CONSTRAINT PK_IDVenta PRIMARY KEY (IDVenta),
    CONSTRAINT FK_IDCliente	 FOREIGN KEY (IDCliente)  REFERENCES Clientes(IDCliente),
    CONSTRAINT FK_IDVendedor FOREIGN KEY (IDVendedor) REFERENCES Vendedores(IDVendedor),
    CONSTRAINT FK_IDProducto FOREIGN KEY (IDProducto) REFERENCES Productos(IDProducto)
);
GO

--Se insertan los datos en la tabla Ventas_temporal
INSERT INTO DBO.VENTAS_TEMPORAL (IDCliente, IDVendedor, IDProducto, Cantidad)
SELECT
    C.IDCliente,
    V.IDVendedor,
    P.IDProducto,
    VT.Cantidad
FROM DBO.VENTAS		AS VT
JOIN DBO.CLIENTES	AS C ON 
		C.NombreCliente = SUBSTRING(VT.Cliente, 1, CHARINDEX(' ', VT.Cliente)-1)
    AND C.ApellidoCliente = SUBSTRING(VT.Cliente, CHARINDEX(' ', VT.Cliente)+1, LEN(VT.Cliente))
    AND C.Telefono = VT.Telefono
JOIN DBO.VENDEDORES AS V ON 
		V.NombreVendedor = SUBSTRING(VT.Vendedor, 1, CHARINDEX(' ', VT.Vendedor)-1)
    AND V.ApellidoVendedor = SUBSTRING(VT.Vendedor, CHARINDEX(' ', VT.Vendedor)+1, LEN(VT.Vendedor))
JOIN DBO.PRODUCTOS	AS P ON VT.Producto = P.NombreProducto
GO

--Se dropea la tabla Ventas sin normalizar
DROP TABLE DBO.VENTAS

--Se renombra la tabla Ventas_Temporal por Ventas
EXEC sp_rename 'VENTAS_TEMPORAL', 'VENTAS'
GO

--Se visualizan las tablas creadas y normalizadas
SELECT * FROM DBO.PROVINCIAS; 
SELECT * FROM DBO.VENDEDORES;
SELECT * FROM DBO.PRODUCTOS;
SELECT * FROM DBO.SUCURSALES;
SELECT * FROM DBO.CLIENTES;
SELECT * FROM DBO.VENTAS;

