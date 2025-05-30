--Crear DB
CREATE DATABASE EmpresaDB;
GO

--Usar DB
USE EmpresaDB;
GO

--Crear tabla empleados
CREATE TABLE Empleados(
	ID INT PRIMARY KEY IDENTITY(1,1),
	Nombre NVARCHAR(50),
	Apellido NVARCHAR(50),
	Departamento NVARCHAR(50),
	Salario DECIMAL(10,2)
);
GO

--Insertar datos
--INSERT INTO Empleados(Nombre, Apellido, Departamento, Salario) 
--VALUES
--	('Juan','Perez','TI', 50000),
--	('Ana','Gomez','Ventas', 45000),
--	('Carlos','Ramirez','TI', 55000),
--	('Lucia','Fernandez','Recursos Humanos', 40000),
--	('Santiago','Ramirez','TI', 60000),
--	('Alberto','Alverez','TI', 70000),
--	('Felipe','Nipicha','Gerencia', 65000),
--	('Alonso','Perez','Marketing', 50000),
--	('Lee','Chuan','Msarketing', 55000);
--GO


--Crear vista para mostrar solo empleados del departamento TI
CREATE VIEW Vista_Empleados_TI 
AS SELECT ID,Nombre, Apellido, Salario
FROM Empleados
WHERE Departamento = 'TI';
GO

--Consultar Vista:
SELECT*FROM Vista_Empleados_TI;
GO

--Modificar la vista para incluir el departamento
ALTER VIEW Vista_Empleados_TI 
AS SELECT ID,Nombre, Apellido, Departamento, Salario
FROM Empleados 
WHERE Departamento = 'TI';
GO


--Eliminar la vista si ya no es necesaria
DROP VIEW Vista_Empleados_TI;
GO

--Manejo de Excepciones 
--Crear una base de datos
CREATE DATABASE EjemploExcepcionesDB;
GO

--Usar la base de datos recien creada
USE EjemploExcepcionesDB;
GO

--Crear tabla productos
CREATE TABLE Productos(
	ID INT PRIMARY KEY, -- CLAVE PRIMARIA PARA EVITAR DUPLICADOS
	Nombre NVARCHAR(100),
	Precio DECIMAL(10,2)
);
GO

--iNSERTAR PRODUCTOS
INSERT INTO Productos(ID, Nombre, Precio)
VALUES	
	(1, 'Laptop', 1200.00),
	(2, 'Smartphone', 800.00),
	(3, 'Tablet', 350.00),
	(4, 'Monitor', 250.00),
	(5, 'Teclado', 50.00),
	(6, 'Ratón', 30.00);
GO

--Insertar un duplicado 
BEGIN TRY
	INSERT INTO Productos(ID, Nombre, Precio)
VALUES (1, 'Tablet', 600.00);
	PRINT 'Producto Insertado Correctamente.';
END TRY
BEGIN CATCH 
	PRINT 'Error detectado: ' + ERROR_MESSAGE();
END CATCH;

--Insertar una division por cero y manerjar la excepcion
BEGIN TRY
	DECLARE @Resultado INT;
	SET @Resultado =10/0; --Esto gnerará un error
END TRY
BEGIN CATCH 
	PRINT 'Error detectado: ' + ERROR_MESSAGE();
END CATCH;
GO

SELECT*FROM Productos

--Manejo de errores con una transaccion 
BEGIN TRANSACTION;
BEGIN TRY
	INSERT INTO Productos(ID,Nombre, Precio) 
	VALUES (7, 'Mouse', 25.00);
	INSERT INTO Productos(ID,Nombre, Precio) 
	VALUES (7, 'Teclado', 50.00);
	
	COMMIT TRANSACTION; -- Solo se ejecutara si todo es exitoso
	PRINT 'Transacción completa exitosamente.';
END TRY
BEGIN CATCH 
	ROLLBACK TRANSACTION; --Revierte cambios si hay un error 
	PRINT 'Error en la transacción: ' + ERROR_MESSAGE();
END CATCH;
GO




