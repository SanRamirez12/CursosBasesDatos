--Laboratorio#3: Santiago Ramirez Elizondo 

--Se crea la base de datos:
CREATE DATABASE LavacarBD 
GO

--Se utiliza la db creada:
USE LavacarBD
GO

--Se crea la tabla servicio Lavacar
CREATE TABLE dbo.ServicioLavacar
(
	ID_Cliente INT IDENTITY(1,1) PRIMARY KEY NOT  NULL,
	NombreCliente NVARCHAR(50) NOT NULL,
	ApellidoCliente NVARCHAR(50) NOT NULL,
	TelefonoCliente VARCHAR(15) NOT NULL,
	DireccionCliente NVARCHAR(200) NOT NULL,
	ID_Servicio INT NOT NULL,
	NombreEmpleado NVARCHAR(50) NOT NULL,
	FechaServicio DATE NOT NULL,
	MontoFactura MONEY NOT NULL
)
GO

--Se insertan registros en la tabla creada:
INSERT INTO dbo.ServicioLavacar(NombreCliente,ApellidoCliente,TelefonoCliente,DireccionCliente,ID_Servicio,
NombreEmpleado,FechaServicio,MontoFactura)
VALUES
	 ('María', 'González', '123456789', 'Calle 123', 1, 'Pedro', '2024-02-07', 50.00), 
    ('José', 'Martínez', '987654321', 'Avenida Principal', 2, 'Juan', '2024-02-07', 40.00), 
    ('Ana', 'Rodríguez', '5555555', 'Calle Central', 3, 'Pedro', '2024-02-07', 60.00), 
    ('Carlos', 'López', '7777777', 'Avenida 2', 4, 'Juan', '2024-02-07', 70.00), 
    ('Laura', 'Sánchez', '9999999', 'Calle 5', 5, 'Pedro', '2024-02-07', 45.00), 
    ('Javier', 'Pérez', '1111111', 'Calle 10', 6, 'Juan', '2024-02-07', 55.00), 
    ('Alejandra', 'Díaz', '2222222', 'Avenida 3', 7, 'Pedro', '2024-02-07', 65.00), 
    ('Sofía', 'Fernández', '3333333', 'Calle 7', 8, 'Juan', '2024-02-07', 75.00), 
    ('Roberto', 'García', '4444444', 'Avenida 4', 9, 'Pedro', '2024-02-07', 80.00), 
    ('Patricia', 'Hernández', '5555555', 'Calle 12', 10, 'Juan', '2024-02-07', 35.00); 
GO

--Visualizamos los datos insertados
SELECT*FROM dbo.ServicioLavacar
GO

--Select de Clientes Atendidos por Pedro:
SELECT*FROM dbo.ServicioLavacar
WHERE NombreEmpleado = 'Pedro'
GO

--Se actualiza el empleado Pedro por Jimena
UPDATE dbo.ServicioLavacar 
SET NombreEmpleado = 'Jimena'
WHERE NombreEmpleado = 'Pedro'
GO

--Select de Clientes Atendidos por Jimena:
SELECT*FROM dbo.ServicioLavacar
WHERE NombreEmpleado = 'Jimena'
GO

--Consulta de los empleados de Servicio Lavacar sin repetirlos
SELECT DISTINCT NombreEmpleado
FROM dbo.ServicioLavacar
GO

--Despues del modelado de datos, se normaliza la DB:
--Se crean las tablas

--Creacion de tabla Direcciones:
CREATE TABLE dbo.Direcciones
(
	ID_Direcciones INT IDENTITY (1,1) NOT NULL,
	DireccionesCompletas NVARCHAR(200)
	CONSTRAINT PK_ID_Direcciones PRIMARY KEY (ID_Direcciones)
)
GO

--Creacion de tabla Clientes:
CREATE TABLE dbo.Clientes
(
	ID_Cliente INT IDENTITY (1,1) NOT NULL,
	NombreCliente NVARCHAR(50) NOT NULL,
	ApellidoCliente NVARCHAR(50) NOT NULL,
	TelefonoCliente VARCHAR(15) NOT NULL,
	ID_Direccion INT NOT NULL,
	CONSTRAINT PK_ID_Cliente PRIMARY KEY (ID_Cliente),
	CONSTRAINT FK_ID_Direccion FOREIGN KEY (ID_Direccion) REFERENCES Direcciones (ID_Direcciones)
)
GO

--Se crea la tabla empleados:
CREATE TABLE dbo.Empleados
(
	ID_Empleados INT IDENTITY (1,1) NOT NULL,
	NombreEmpleado NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_ID_Empleados PRIMARY KEY (ID_Empleados)
)
GO

--Se crea la tabla Servicios
CREATE TABLE dbo.Servicios
(
	ID_Servicios INT IDENTITY (11,1) NOT NULL,
	FechaServicio DATE NOT NULL,
	MontoFactura MONEY NOT NULL,
	ID_Empleado INT NOT NULL,
	CONSTRAINT PK_ID_Servicios PRIMARY KEY (ID_Servicios),
	CONSTRAINT FK_ID_Empleado FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleados)
)
GO

--Se crea la tabla venta de servicios:
CREATE TABLE dbo.VentaServicios
(
	ID_Venta INT IDENTITY (1,1) NOT NULL,
	ID_Cliente INT NOT NULL,
	ID_Servicio INT NOT NULL,
	CONSTRAINT PK_ID_Venta PRIMARY KEY (ID_Venta),
	CONSTRAINT FK_ID_Cliente FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
	CONSTRAINT FK_ID_Servicio FOREIGN KEY (ID_Servicio) REFERENCES Servicios(ID_Servicios)
)
GO

--Se insertan los datos:

--Se insertan las direcciones
INSERT INTO dbo.Direcciones(DireccionesCompletas)
SELECT DISTINCT DireccionCliente
FROM dbo.ServicioLavacar
GO

--Se visualiza la insercion:
--SELECT*FROM dbo.Direcciones

--Se insertan los clientes:
INSERT INTO dbo.Clientes(NombreCliente,ApellidoCliente,TelefonoCliente,ID_Direccion)
SELECT SL.NombreCliente, SL.ApellidoCliente, SL.TelefonoCliente, D.ID_Direcciones
FROM dbo.ServicioLavacar AS SL
JOIN dbo.Direcciones AS D 
ON SL.DireccionCliente = D.DireccionesCompletas
GO

--Se visualiza la insercion:
--SELECT*FROM dbo.Clientes

--Se insertan los empleados:
INSERT INTO dbo.Empleados(NombreEmpleado)
SELECT DISTINCT NombreEmpleado
FROM dbo.ServicioLavacar

--Se visualiza la insercion:
--SELECT*FROM dbo.Empleados

--Se habilita la insercion de IDs 
SET IDENTITY_INSERT dbo.Servicios ON;
GO

--Se insertan datos en la tabla servicios:
INSERT INTO dbo.Servicios(ID_Servicios,FechaServicio, MontoFactura, ID_Empleado)
SELECT SL.ID_Servicio,SL.FechaServicio, SL.MontoFactura, E.ID_Empleados
FROM dbo.ServicioLavacar AS SL
JOIN dbo.Empleados AS E 
ON SL.NombreEmpleado = E.NombreEmpleado

--Se deshabilita la insercion de ids 
SET IDENTITY_INSERT dbo.Servicios  OFF
GO

--Se visualiza la insercion:
--SELECT*FROM dbo.Servicios

--Se insertan las  ventas de servicios:
INSERT INTO dbo.VentaServicios(ID_Cliente, ID_Servicio)
SELECT C.ID_Cliente, SL.ID_Servicio
FROM dbo.ServicioLavacar AS SL
JOIN dbo.Clientes AS C ON SL.NombreCliente = C.NombreCliente AND SL.ApellidoCliente = C.ApellidoCliente 
AND SL.TelefonoCliente = C.TelefonoCliente
JOIN dbo.Servicios AS S ON SL.ID_Servicio = S.ID_Servicios

--Se visualiza la insercion:
--SELECT*FROM dbo.VentaServicios

--Se elimina la tabla Servicio Lavacar
DROP TABLE dbo.ServicioLavacar
GO

--Select, a la tabla de clientes filtrado por el nombre Ana 
SELECT*FROM dbo.Clientes 
WHERE NombreCliente = 'Ana'
GO

--Select a la tabla que contenga los servicios realizados, ordene por fecha descendente
SELECT*FROM dbo.Servicios ORDER BY FechaServicio DESC
GO

--Select a la tabla clientes y direcciones haciendo el uso del Join, use alias para los campos 
SELECT C.NombreCliente AS 'Nombre', C.ApellidoCliente AS 'Apellido', C.TelefonoCliente AS 'Teléfono', 
D.DireccionesCompletas AS 'Dirección'
FROM dbo.Clientes AS C
JOIN dbo.Direcciones AS D ON C.ID_Direccion = D.ID_Direcciones
GO

--Select a la tabla que contenga los servicios realizados, filtre por el empleado  Juan 
--y muestre solo los servicios mayores a 50 
SELECT S.ID_Servicios AS 'Servicio Brindado', S.FechaServicio AS 'Fecha del Servicio', 
S.MontoFactura AS 'Monto del Servicio', E.NombreEmpleado AS 'Empleado'
FROM dbo.Servicios AS S
JOIN dbo.Empleados AS E 
ON S.ID_Empleado = E.ID_Empleados
WHERE E.NombreEmpleado = 'Juan' AND S.MontoFactura > 50.00
GO

--Creacion de Funcion que calcula el IVA
CREATE FUNCTION FN_CalcularIVA(@Monto MONEY) RETURNS MONEY
AS
	BEGIN
		DECLARE @IVA MONEY
		SET @IVA = @Monto *0.13
		RETURN (@IVA)
	END
GO

--Creacion del Procedimiento almacenado que inserte nuevos servicios
CREATE PROCEDURE SP_Insertar_Nuevos_Servicios
	@FechaServicio DATE,
	@MontoFactura MONEY,
	@ID_Empleado INT
AS 
	BEGIN
		IF EXISTS (SELECT 1 FROM dbo.Empleados AS E WHERE @ID_Empleado = E.ID_Empleados)
			INSERT INTO dbo.Servicios(FechaServicio,MontoFactura,ID_Empleado)
			VALUES (@FechaServicio,@MontoFactura,@ID_Empleado)
		ELSE
		BEGIN
			RAISERROR('Empleado Inexistente', 16 , 1)
		END
	END;
GO

--Se ejecuta el procedimiento almacenado para un nuevo servicio:
EXEC SP_Insertar_Nuevos_Servicios '2024-12-11',100.00,2
GO

--Select que muestre los servicios, agregue un campo adicional a la consulta, 
--el cual llame la función del IVA
SELECT ID_Servicios AS 'Servicio Brindado', S.FechaServicio AS 'Fecha del Servicio', 
S.ID_Empleado AS 'ID del Empleado', S.MontoFactura AS 'Monto del Servicio', 
dbo.FN_CalcularIVA(S.MontoFactura) AS 'IVA'
FROM dbo.Servicios AS S
GO
