USE master	
GO

Create DATABASE DBPractica01
GO

USE DBPractica01
GO

CREATE TABLE Clientes(
	 IdCliente INT IDENTITY(1,1) PRIMARY KEY,
	 Nombre NVARCHAR(100),
	Email NVARCHAR(100),
	FechaRegistro DATETIME DEFAULT GETDATE()
);
GO
--Procedimiento para insertar cliente
CREATE PROCEDURE InsertarCliente
	 @Nombre NVARCHAR(100),
	 @Email NVARCHAR(100)
AS
	BEGIN
	INSERT INTO Clientes (Nombre, Email)
	VALUES (@Nombre, @Email);

	PRINT 'Cliente insertado correctamente';
END;
GO

--Se ejecuta el inserto de cliente por procedimiento
EXEC InsertarCliente 'Felipe Mendez', 'felipe_1210@hotmail.es';
GO

SELECT * FROM Clientes
GO

--Crear procedimiento para consultar cliente

CREATE PROCEDURE ObtenerClientePorID
	 @IdCliente INT
AS
	BEGIN
	SELECT * FROM Clientes WHERE IdCliente = @IdCliente;
END;
GO

--Ejecutar la consulta
EXEC ObtenerClientePorID 2;
GO

--Procedimiento para actualizar
CREATE PROCEDURE ActualizarEmailCliente
	 @IdCliente INT,
	@NuevoEmail NVARCHAR(100)
AS
	BEGIN
	UPDATE Clientes
	SET Email = @NuevoEmail
	WHERE IdCliente = @IdCliente;
	PRINT 'Correo actualizado correctamente';
END;
GO
--Ejecutar la actualización

EXEC ActualizarEmailCliente 1, 'luis@hotmail.com';
GO

--Eliminar cliente
CREATE PROCEDURE EliminarCliente
 @IdCliente INT
AS
BEGIN
 DELETE FROM Clientes WHERE IdCliente = @IdCliente;
 PRINT 'Cliente eliminado correctamente';
END;
GO

--Ejecutar la eliminacióm
EXEC EliminarCliente 1;
GO

SELECT * FROM Clientes
GO