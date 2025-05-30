--Laboratorio #4 Santiago Ramirez Elizondo 

--Parte 1: Creación de la Base de Datos y Tablas
CREATE DATABASE VentasOnline
GO

USE VentasOnline
GO

CREATE TABLE Clientes(
	ClienteID INT PRIMARY KEY IDENTITY(1,1),
	Nombre NVARCHAR(100),
	Email NVARCHAR(100),
	FechaRegistro DATETIME DEFAULT GETDATE()
);
GO

CREATE TABLE Productos(
	ProductoID INT PRIMARY KEY IDENTITY (1,1),
	Nombre NVARCHAR(100),
	Precio DECIMAL(10,2),
	Stock INT
);
GO

CREATE TABLE Pedidos(
	PedidoID INT PRIMARY KEY IDENTITY (1,1),
	ClienteID INT FOREIGN KEY REFERENCES Clientes(ClienteID),
	FechaPedido DATETIME DEFAULT GETDATE(),
	Estado NVARCHAR(50) DEFAULT 'Pendiente'
);
GO

CREATE TABLE DetallesPedido(
	DetalleID INT PRIMARY KEY IDENTITY (1,1),
	PedidoID INT FOREIGN KEY REFERENCES Pedidos(PedidoID),
	ProductoID INT FOREIGN KEY REFERENCES Productos(ProductoID),
	Cantidad INT,
	PrecioUnitario DECIMAL(10,2)
);
GO
--Parte 2: Inserción de Datos:
INSERT INTO Clientes (Nombre, Email) VALUES ('Juan Perez', 'juan@example.com');
INSERT INTO Productos (Nombre, Precio, Stock) VALUES ('Laptop', 1200.00, 10);
INSERT INTO Pedidos (ClienteID) VALUES (1);
INSERT INTO DetallesPedido (PedidoID, ProductoID, Cantidad, PrecioUnitario) VALUES (1, 1, 2, 1200.00);
GO

--Visualizamos las tablas:
SELECT*FROM dbo.Clientes
SELECT*FROM dbo.DetallesPedido
SELECT*FROM dbo.Pedidos
SELECT*FROM dbo.Productos

--Parte 3: Problemas de Concurrencia
--Transacción 1: Actualiza el stock de un producto.
BEGIN TRANSACTION;
UPDATE Productos SET Stock = Stock - 1 WHERE ProductoID = 1;
WAITFOR DELAY '00:00:10'; -- Simula una demora
COMMIT;
GO

--Transacción 2: Intenta leer el stock del mismo producto.
BEGIN TRANSACTION;
SELECT Stock FROM Productos WHERE ProductoID = 1;
COMMIT;
GO

--Aplicando deadlocks:
BEGIN TRANSACTION;
UPDATE Productos SET Stock = Stock - 1 WHERE ProductoID = 1;
WAITFOR DELAY '00:00:05';
UPDATE Clientes SET Email = 'nuevo@example.com' WHERE ClienteID = 1;
COMMIT;
GO

BEGIN TRANSACTION;
UPDATE Clientes SET Email = 'otro@example.com' WHERE ClienteID = 1;
WAITFOR DELAY '00:00:05';
UPDATE Productos SET Stock = Stock - 1 WHERE ProductoID = 1;
COMMIT;
GO
--Se visualizan 
SELECT*FROM dbo.Clientes

--Parte 4: Optimización de Consultas
--SELECT c.Nombre, p.Nombre, dp.Cantidad
--FROM Clientes c
--JOIN Pedidos pe ON c.ClienteID = pe.ClienteID
--JOIN DetallesPedido dp ON pe.PedidoID = dp.PedidoID
--JOIN Productos p ON dp.ProductoID = p.ProductoID
--WHERE p.Precio > 500;

--Para optimizar la consulta usamos la creacion de indices en las diferentes tablas:
-- Índice en Precio para acelerar la condición WHERE
CREATE INDEX idx_Productos_Precio ON Productos (Precio);

-- Índices en claves foráneas para mejorar los JOINs
CREATE INDEX idx_Pedidos_ClienteID ON Pedidos (ClienteID);
CREATE INDEX idx_DetallesPedido_PedidoID ON DetallesPedido (PedidoID);
CREATE INDEX idx_DetallesPedido_ProductoID ON DetallesPedido (ProductoID);

-- Índice compuesto en DetallesPedido para mejorar rendimiento
CREATE INDEX idx_DetallesPedido_PedidoID_ProductoID ON DetallesPedido (PedidoID, ProductoID) 
INCLUDE (Cantidad);
GO

--Se vuelve a ejecutar la consulta optimizada:
SELECT c.Nombre, p.Nombre, dp.Cantidad
FROM Clientes c
JOIN Pedidos pe ON c.ClienteID = pe.ClienteID
JOIN DetallesPedido dp ON pe.PedidoID = dp.PedidoID
JOIN Productos p ON dp.ProductoID = p.ProductoID
WHERE p.Precio > 500;
