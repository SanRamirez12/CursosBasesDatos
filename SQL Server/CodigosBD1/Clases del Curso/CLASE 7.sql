--CLASE 7 

--CAMBIO DE BASE DE DATOS
USE RentaCarUlat 
GO

--INSERTAR DATOS EN TABLA CLIENTE
INSERT INTO CLIENTE (CedulaCliente, NombreCliente, Ape1Cliente, Ape2Cliente, TelefonoCliente,DireccionCliente)
VALUES
	('111113','Mar�a', 'P�rez', 'Castro', '2222-2225', 'Moravia'),
	('111114','Mar�a', 'Ortiz', 'Rojas', '2222-2226', 'San Carlos'),
	('111115','Carlos', 'P�rez', 'Jimenez', '2222-2227', 'Puntarenas'),
	('111116','Gilberto', 'P�rez', 'Castro', '2222-2225', 'Moravia'),
	('111117','Mar�a', 'P�rez', 'Quiros', '2222-2225', 'Turrialba'),
	('111118','Gerardo', 'L�pez', 'Castro', '2222-2228', 'San Isidro'),
	('111119','Luis', 'Lopez', 'Castro', '2222-2220', 'San Isidro')
GO

--MODIFICAR TABLA EMPLEADO
ALTER TABLE Empleado
ADD
	SALARIO INT NOT NULL DEFAULT 100000
GO

--INSERTAR REGISTROS NUEVOS 
INSERT INTO Empleado 
    (CedulaEmpleado, NombreEmpleado, Ape1Empleado, Ape2Empleado, TelefonoEmpleado, DireccionEmpleado, IDSucursal, FechaIngreso, Salario)
VALUES
    ('101110111', 'Carlos', 'Jim�nez', 'Rodr�guez', '8888-8888', 'San Jos�', 1, '2023-01-01', 70000),
    ('202220222', 'Ana', 'G�mez', 'Soto', '8777-8777', 'Alajuela', 2, '2023-02-01', 200000),
    ('303330333', 'Luis', 'Vargas', 'Mora', '8666-8666', 'Heredia', 3, '2023-03-01', 300000),
    ('404440444', 'Mar�a', 'Cordero', 'Alfaro', '8555-8555', 'Cartago', 4, '2023-04-01', 400000),
    ('505550555', 'Jorge', 'Pineda', 'Montero', '8444-8444', 'Puntarenas', 5, '2023-05-01', 500000);
go

--CONSULTAR DATOS
SELECT * FROM CLIENTE
GO
SELECT * FROM Empleado
GO
--CONSULTAS CON EL USO DEL WHERE
SELECT * FROM CLIENTE WHERE IDCliente = 3 
GO
SELECT * FROM CLIENTE WHERE CedulaCliente = '111114'
GO

--CONSULTAS CON EL USO DEL WHERE Y AND/OR
SELECT * FROM CLIENTE WHERE NombreCliente = 'Mar�a'
GO
SELECT * FROM CLIENTE WHERE Ape1Cliente = 'P�rez'
GO

SELECT * FROM CLIENTE WHERE NombreCliente = 'Mar�a' 
AND Ape1Cliente = 'P�rez'
GO

SELECT * FROM CLIENTE WHERE NombreCliente = 'Mar�a' 
OR Ape1Cliente = 'P�rez'
GO

SELECT * FROM CLIENTE WHERE NombreCliente = 'Mar�a' 
AND Ape1Cliente = 'P�rez' AND Ape2Cliente = 'Castro'
GO

SELECT * FROM CLIENTE WHERE NombreCliente = 'Mar�a' 
AND Ape1Cliente = 'P�rez' OR Ape2Cliente = 'Castro'
GO

--CONSULTA CON WHERE Y LIKE

--BUSCAR NOMBRES DE CLIENTES QUE EMPIEZAN CON A
SELECT * FROM CLIENTE WHERE NombreCliente LIKE 'M%' 
GO
--BUSCAR NOMBRES DE CLIENTES QUE TERMINAN CON A
SELECT * FROM CLIENTE WHERE NombreCliente LIKE '%A' 
GO
--BUSCAR NOMBRES DE CLIENTES QUE CONTIENEN LA A
SELECT * FROM CLIENTE WHERE NombreCliente LIKE '%O%' 
GO

--BUSCAR NOMBRES DE CLIENTES QUE EMPIEZAN CON A
SELECT * FROM CLIENTE WHERE Ape1Cliente = 'L�pez'
GO
SELECT * FROM CLIENTE WHERE Ape1Cliente = 'Lopez'
GO

SELECT * FROM CLIENTE WHERE Ape1Cliente LIKE  'L%pez'
GO

--CONSULTA CON WHERE Y BETWEEN
SELECT * FROM Empleado WHERE salario BETWEEN 70000 AND 200000
GO
SELECT * FROM Empleado WHERE salario BETWEEN 200000 AND 500000
GO

--CONSULTA CON WHERE Y <,>,<=,>=
SELECT * FROM Empleado WHERE salario < 200000
GO
SELECT * FROM Empleado WHERE salario <= 200000
GO
SELECT * FROM Empleado WHERE salario > 300000
GO
SELECT * FROM Empleado WHERE salario >= 300000
GO

