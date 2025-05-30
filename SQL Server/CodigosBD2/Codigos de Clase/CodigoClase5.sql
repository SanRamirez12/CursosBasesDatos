--Laboratorio de Triggers. Santiago Ramirez Elizondo

--Ejercicio 1: CREACIÓN DE UNA BASE DE DATOS Y TABLAS
--Se crea la DB
CREATE DATABASE TIENDA
GO
--Se usa la DB
USE TIENDA
GO

--Crear tabla principal
CREATE TABLE Productos (
    ID INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(100),
    Precio DECIMAL(10,2),
    Stock INT
);

-- Crear tabla Auditoria_Productos
CREATE TABLE Auditoria_Productos (
    ID_Auditoria INT PRIMARY KEY IDENTITY(1,1),
    ID_Producto INT,
    Accion NVARCHAR(50),
    Fecha DATETIME DEFAULT GETDATE()
);
GO

--Se Crean los Triggers

--EJERCICIO 2: CREAR UN TRIGGER PARA INSERT
-- Crear trigger para registrar inserciones en Auditoria_Productos
CREATE TRIGGER tgr_AfterInsertProducto
ON Productos
AFTER INSERT
AS
BEGIN
    INSERT INTO Auditoria_Productos (ID_Producto, Accion)
    SELECT ID, 'INSERTADO' FROM inserted;
END;
GO

--Insert en la tabla productos
INSERT INTO Productos (Nombre, Precio, Stock) 
VALUES ('Producto A', 1000, 10),('Producto B', 2000, 20);
GO;

SELECT*FROM Productos
GO;
SELECT*FROM Auditoria_Productos
GO;
--EJERCICIO 3: TRIGGER PARA UPDATE
-- Crear trigger para registrar actualizaciones de precio o stock en Auditoria_Productos
CREATE TRIGGER tgr_Update_Productos
ON Productos
AFTER UPDATE
AS
BEGIN
     INSERT INTO Auditoria_Productos (ID_Producto, Accion)
     SELECT ID, 'ACTUALIZADO' FROM inserted;
END;
GO

-- Actualizar el precio de un producto
UPDATE Productos SET Precio = 1300 WHERE ID = 1;
GO;
SELECT*FROM Productos
GO;

--EJERCICIO 4: TRIGGER PARA DELETE
-- Crear trigger para registrar eliminaciones en Auditoria_Productos
CREATE TRIGGER trg_Delete_Productos
ON Productos
AFTER DELETE
AS
BEGIN
    INSERT INTO Auditoria_Productos (ID_Producto, Accion)
    SELECT ID, 'ELIMINADO' FROM deleted;
END;
GO

DELETE FROM Productos WHERE ID = 1;
GO;
SELECT * FROM Auditoria_Productos;
GO;

--EJERCICIO 5: TRIGGER EN LUGAR DE UNA ACCIÓN (INSTEAD OF DELETE)
-- Agregar la columna Deshabilitado a la tabla Productos
ALTER TABLE Productos ADD Activo BIT DEFAULT 1;
GO

-- Crear trigger INSTEAD OF DELETE para evitar la eliminación y marcar el producto como deshabilitado
CREATE TRIGGER trg_InsteadOfDeleteProducto
ON Productos
INSTEAD OF DELETE
AS
BEGIN
    UPDATE Productos 
	SET Activo = 0 
	WHERE ID IN (SELECT ID FROM deleted);
END;
GO

DELETE FROM Productos WHERE ID = 2;
GO;
SELECT * FROM Productos;
SELECT*FROM Auditoria_Productos
GO;

