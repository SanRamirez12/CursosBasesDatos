--CLASE 11 PROCEDIMIENTOS ALMACENADOS
--CAMBIO DE BASE DATOS
USE Northwind
GO

--CREAR UN PROCEDIMIENTO ALMACENADO USANDO CICLOS Y CONDICIONES
CREATE PROCEDURE SP_Numeros
AS
	DECLARE @Valor INT = 0;
	WHILE (@Valor <= 10)
	BEGIN
		IF (@Valor % 2 = 0 )
			BEGIN
				PRINT CAST (@Valor AS VARCHAR (10)) + ' el numero es par'
			END
		ELSE
			BEGIN
				PRINT CAST (@Valor AS VARCHAR (10)) + ' el numero es impar'
			END
		SET @Valor = @Valor + 1
	END;
GO
--ELIMINAR PROCEDIMIENTO
DROP PROCEDURE SP_Numeros;
GO
--EJECUTAR EL PROCEDIMIENTO
EXECUTE SP_Numeros;
GO
--
EXEC SP_Numeros;
GO
--CREAR PROCEDIMIENTO QUE INSERTA UN PROVEEDOR
CREATE PROCEDURE SP_INSERTAR_PROVEEDOR
(
	@CompanyName VARCHAR (50),
	@ContactName VARCHAR (50),
	@ContacTitle VARCHAR (50),
	@Country VARCHAR (50)
)
AS
INSERT INTO Suppliers (CompanyName,ContactName, ContactTitle, Country)
VALUES
	(@CompanyName,@ContactName,@ContacTitle,@Country);
GO

--MODIFICAR PROCEDIMIENTO QUE INSERTA UN PROVEEDOR
ALTER PROCEDURE SP_INSERTAR_PROVEEDOR
(
	@CompanyName VARCHAR (50),
	@ContactName VARCHAR (50),
	@ContacTitle VARCHAR (50),
	@Country VARCHAR (50),
	@Address VARCHAR (50)
)
AS
INSERT INTO Suppliers (CompanyName,ContactName, ContactTitle, 
Country, Address)
VALUES
	(@CompanyName,@ContactName,@ContacTitle,@Country, @Address);
GO

--EJECUTAR EL SP 
EXEC SP_INSERTAR_PROVEEDOR
'ICE', 'Ana Porras', 'Conta', 'Costa Rica', 'Colima, Tibas';
GO

--CONSULTAR TABLA
SELECT * FROM Suppliers
GO
--PROCEDIMIENTO CON PARAMETROS DE SALIDA
CREATE PROCEDURE SP_Eliminacion_Pais 
(@PAIS VARCHAR (50), @FILAS INT OUTPUT)
AS
	DELETE FROM Suppliers
		WHERE Country = @PAIS
		SET @FILAS = @@ROWCOUNT
GO
--USAR EL SP SP_Eliminacion_Pais
SELECT * FROM Suppliers

--
DECLARE @DATOS INT
EXEC SP_Eliminacion_Pais 'Costa Rica', @DATOS OUTPUT
SELECT @DATOS AS 'Registros eliminados'