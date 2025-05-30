-- Clase #2
-- Creación de Bases de Datos
CREATE DATABASE CLASE1;
GO
--Cambiarme a la base de datos CLASE1
USE CLASE1;
GO

--Creación de Tabla:
CREATE TABLE Persona(
	IDPersona	INT IDENTITY(1,1) PRIMARY KEY,
	Nombre      VARCHAR(50) NOT NULL, --NOT NULL establece que el campo en la tabla es obligatorio
	Apellido	VARCHAR(50), 
	Edad		INT
);
--Consulta de tabla
SELECT * FROM Persona
GO

--Consulta de campos específicos
SELECT IDPersona, Nombre FROM Persona;
GO

--Insertar datos en la tabla creada
INSERT INTO Persona(Nombre,Apellido,Edad)
VALUES ('Alejandro', 'Serrano'+'Perez',35);
GO
--Consulta de tabla
SELECT * FROM Persona
GO

--Agregar campos a la tabla
ALTER TABLE Persona
ADD EstadoCivil VARCHAR(20),
	Profesion	VARCHAR(50);
GO

--Consulta de tabla
SELECT * FROM Persona
GO

--Modificar un registro de la tabla
UPDATE Persona
SET Edad = 36,
	EstadoCivil = 'Divorciado',
	Profesion = 'Ingeniero'
	WHERE IDPersona = 1;
GO

--Eliminar registro
DELETE FROM Persona
WHERE IDPersona = 6;
GO

--Inserción de varios registros
INSERT INTO Persona(Nombre,Apellido,Edad,EstadoCivil,Profesion)
VALUES  
	('María','Guillén',28,'Soltera','Profesora'),
	('Ana','Porras',35,'Casada','Médico'),
	('Leonel','Messi',37,'Casado','Futbolista');
GO

--Consulta de tabla
SELECT Nombre,Profesion FROM Persona
GO
