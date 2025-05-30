--Ejemplo en clase
CREATE DATABASE Practica4
GO

USE Practica4
GO

CREATE TABLE Empleados(
	Id INT PRIMARY KEY IDENTITY(1,1),
	Nombre VARCHAR(100),
	Salario DECIMAL(10,2)
);
GO;

CREATE TABLE Empleados_Auditoria(
	Id INT PRIMARY KEY IDENTITY(1,1),
	IdEmpleado INT,
	SalarioAnterior DECIMAL(10,2),
	SalarioNuevo DECIMAL(10,2),
	FechaCambio DATETIME DEFAULT GETDATE()
);
GO;


CREATE TRIGGER trg_AuditoriaSalario
ON Empleados
AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;
	INSERT INTO Empleados_Auditoria(IdEmpleado, SalarioAnterior, SalarioNuevo, FechaCambio)
	SELECT 
		d.ID,
		i.Salario,
		d.Salario,
		GETDATE()
	FROM inserted AS d
	INNER JOIN deleted AS i ON d.Id = i.Id
	WHERE i.Salario <> d.Salario;
END;

--INSERT INTO Empleados (Nombre, Salario) VALUES ('Juan Pérez', 3000);
--UPDATE Empleados SET Salario = 3500 WHERE Id = 1;
SELECT * FROM Empleados_Auditoria;



