---Clase 3

---Usar BD MASTER
USE master
GO

--Creación de Base de Datos
CREATE DATABASE UlatinaLibreria
GO

--Cambio a base de datos UlatinaLibreria
USE UlatinaLibreria
GO

--Crear tabla Estudiante:
CREATE TABLE DBO.Estudiante
(
	EstudianteID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Nombre VARCHAR(30) NOT NULL,
	Apellido VARCHAR(60) NOT NULL,
	Carnet VARCHAR(30) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	Direccion VARCHAR(300) NOT NULL,
	Telefono VARCHAR(30) NOT NULL
)
GO
DROP TABLE DBO.Estudiante
--Crear tabla libro
CREATE TABLE DBO.Libro
(
	LibroID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Titulo VARCHAR(30) NOT NULL,
	AutorID INT NOT NULL,
	AnoPublicacion DATE,
	GeneroID INT NOT NULL,
	NumeroEjemplares INT NOT NULL
)
GO

--Crear tabla Autor
CREATE TABLE DBO.Autor
(
	AutorID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Nombre VARCHAR(30) NOT NULL,
	Apellido VARCHAR(60) NOT NULL,
	Nacionalidad VARCHAR(60),
	FechaNacimientoAutor DATE,
	FechaDefuncionAutor DATE
)
GO
--DROP TABLE para eliminar tabla
--Crear tabla Genero
CREATE TABLE DBO.Genero
(
	GeneroID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	DescripcionGenero VARCHAR(100) NOT NULL
)
GO

--Crear Tabla Prestamo
CREATE TABLE DBO.Prestamo
(
	PrestamoID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	EstudianteID INT NOT NULL,
	LibroID INT NOT NULL,
	FechaPrestamo DATE NOT NULL,
	FechaDevolucion DATE 
)
GO

--Insertar Datos en las tablas:

--Insertar datos en la tabla Genero
INSERT INTO DBO.Genero
VALUES
	('Novela'),
	('Ciencia Ficción'),
	('Misterio'),
	('Fantasía'),
	('Poesía'),
	('Terror')
GO

--Consulta de datos
SELECT * FROM DBO.Genero

--Insert Datos a la tabla Autor
INSERT INTO DBO.Autor
VALUES 
		('Isabel','Allende','Chilena','1942-08-02',NULL),
		('Gabriel','García','Colombia','1927-03-03','2014-04-14'),
		('J.K','Rowling','Británica','1965-07-31',NULL),
		('Haruki','Murakami','Japonesa','1949-01-12',NULL),
		('Agatha','Christie','Británica','1890-09-15','1976-01-12');
GO


--Insertar datos en tabla libro
INSERT INTO DBO.Libro (Titulo,AutorID,AnoPublicacion,GeneroID,NumeroEjemplares)
VALUES
		('El juego del laberinto',1,'2015-01-01',1,10),
		('Cazadores de sueños',2,'2018-01-01',3,5),
		('La llave del tiempo',3,'2016-01-01',2,9),
		('Las sombras del pasado',4,'2015-01-01',1,3),
		('El secreto del universo',5,'2016-01-01',4,11);
GO

--Insertar datos tabla estudiante
INSERT INTO DBO.Estudiante (Nombre,Apellido,Carnet,FechaNacimiento,Direccion,Telefono)
VALUES 
		('Juan','Perez','CUlat-1','2001-01-01','Tibas','2222-2222'),
		('Maria','Lopez','CUlat-2','2001-01-01','Tibas','2222-2222'),
		('Santiago','Ramirez','CUlat-3','2001-01-01','San Pedro','2222-2222'),
		('Alonso','Matarrita','CUlat-4','2001-01-01','Nosara','2222-2222'),
		('Alberto','Alvares','CUlat-5','2001-01-01','Cartaguito','2222-2222');
GO



--Mostrar datos de tablas
SELECT *FROM DBO.Genero
SELECT *FROM DBO.Estudiante
SELECT *FROM DBO.Autor
SELECT *FROM DBO.Libro
GO
--Insertar Datos de prestamos
INSERT INTO DBO.Prestamo(EstudianteID,LibroID,FechaPrestamo,FechaDevolucion)
VALUES 
		(1,2,'2024-07-08',NULL),
		(2,3,'2024-05-03',null);
GO

--Consultar tabla
SELECT *FROM DBO.Prestamo
GO

--Unir dos tablas relacionadas
SELECT * FROM DBO.Estudiante Es JOIN DBO.Prestamo Pr ON Es.EstudianteID = Pr.EstudianteID
Go
--Valores especificos 
SELECT Es.Nombre,Es.Apellido,Es.Carnet,
Pr.PrestamoID,Pr.LibroID,Pr.FechaPrestamo
FROM DBO.Estudiante Es JOIN DBO.Prestamo Pr ON Es.EstudianteID = Pr.EstudianteID
GO