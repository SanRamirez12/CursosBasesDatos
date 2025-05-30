--Laboratorio 1 de Bases de Datos 1; Estudiante: Santiago Ramírez Elizondo
--1) Creación de base de datos
CREATE DATABASE Banco
go

--Se procede a utilizar la DB creada
USE Banco
go

--2) Cree la tabla Departamento con los campos Id departamento, Nombre departamento
CREATE TABLE dbo.Departamento 
(	
	IDDepartamento		INT IDENTITY (1,1) NOT NULL,
	NombreDepartamento	NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_IDDepartamento PRIMARY KEY (IDDepartamento)
)
go

--3) Cree la tabla Cargo con los campos id cargo, descripcion cargo
CREATE TABLE dbo.Cargo
(
	IDCargo				INT IDENTITY (1,1) NOT NULL, 
	DeescripcionCargo	NVARCHAR(300) NOT NULL,
	CONSTRAINT PK_IDCargo PRIMARY KEY (IDCargo)
)
go

--4) Cree la tabla Funcionario con los campos id funcionario, puesto, id departamento, id cargo, salario
CREATE TABLE dbo.Funcionario 
(	
	IDFuncionario		INT IDENTITY (1,1) NOT NULL,
	Nombre				NVARCHAR(50) NOT NULL,
	Apellido1			NVARCHAR(50) NOT NULL,
	Apellido2			NVARCHAR(50) NOT NULL,
	Puesto				NVARCHAR(50) NOT NULL,
	IDDepartamento		INT NOT NULL,
	IDCargo				INT NOT NULL,
	--Los salarios en teoria podrian ser double o decimal
	Salario				INT NOT NULL,  
	CONSTRAINT PK_IDFuncionario PRIMARY KEY (IDFuncionario),
	CONSTRAINT FK_IDDepartamento FOREIGN KEY (IDDepartamento) REFERENCES dbo.Departamento(IDDepartamento),
	CONSTRAINT FK_IDCargo FOREIGN KEY (IDCargo) REFERENCES dbo.Cargo(IDCargo)
)
go

-- 5) cree las relaciones de PK y FK de las tres tablas: estas ya se realizaron en las tablas como restricciones
-- 6)  inserte 5 registros en la tabla Departamento
INSERT INTO dbo.Departamento (NombreDepartamento)
VALUES 
	('Finanzas'),('Recursos Humanos'),('Atención al Cliente'),('Cumplimiento y Riesgos'),('Inversiones')
go

--Los visualizamos
SELECT*FROM dbo.Departamento
go

-- 7)  inserte 5 registros en la tabla Cargo
INSERT INTO dbo.Cargo (DeescripcionCargo)
VALUES
	('Gerente'),('Administrador'),('Consultor'),('Analista'),('Inversionista')
go

--Los visualizamos
SELECT*FROM dbo.Cargo
go

-- 8) inserte 10 registros en la tabla Funcionario con salarios especificos
INSERT INTO dbo.Funcionario (Nombre, Apellido1, Apellido2, Puesto, IDCargo, IDDepartamento, Salario)
VALUES 
	('María','Pérez','López','Intern',3,1,200000),
	('Santiago','Ramírez','Elizondo','Intern',4,5,250000),
	('Jose María','Jiménez','López','Junior',2,4,300000),
	('Samuel','Piedra','Rodríguez','Junior',3,2,350000),
	('Alejandro','Guillén','Villalobos','Junior',4,5,400000),
	('Pedro','Morera','Matarrita','Senior',4,4,450000),
	('María','Vargas','Elizondo','Senior',2,3,500000),
	('Joshua','Ramírez','Alfaro','Senior',2,1,550000),
	('Sebastían','Torres','Vindas','Manager',1,1,600000),
	('Hernán','Barahona','Jiménez','Manager',1,5,650000)
go

--Los visualizamos
SELECT*FROM dbo.Funcionario
go

-- 9) Haga el uso de join para realizar una consulta de Nombre y apellidos del funcionario y 
-- la descripcion del cargo, muestre los datos con sus respectivos alias, adjunte captura del resultado

SELECT F.Nombre AS 'Nombre Empleado', F.Apellido1 AS '1er Apellido', F.Apellido2 AS '2do Apellido',
C.DeescripcionCargo AS 'Descripción del Cargo'
FROM Funcionario AS F JOIN CARGO AS C ON F.IDCargo = C.IDCargo
go

-- 10) Haga el uso de join para realizar una consulta de Nombre y apellidos del funcionario y el 
-- nombre del departamento, muestre los datos con sus respectivos alias adjunte captura del resultado

SELECT F.Nombre AS 'Nombre Empleado', F.Apellido1 AS '1er Apellido', F.Apellido2 AS '2do Apellido',
D.NombreDepartamento AS 'Nombre del departamento'
FROM Funcionario AS F JOIN Departamento AS D ON F.IDDepartamento = D.IDDepartamento
go

-- 11) Haga 1 consulta de Funcionario con donde Nombre = ' ' AND Apellido = ''
SELECT *FROM Funcionario WHERE Nombre = 'Joshua' AND Apellido1 = 'Ramírez'
go

-- 12) Haga 1 consulta de Funcionario con donde Nombre = ' ' OR Apellido = ''
SELECT *FROM Funcionario WHERE Nombre = 'María' OR Apellido1 = 'Ramírez'
go

-- 13) Haga 1 consulta de Funcionario con donde Salario sea entre 350,000 y 500,000
SELECT *FROM Funcionario WHERE Salario BETWEEN 350000 AND 500000
go

-- 14) Haga 1 consulta de Funcionario con donde Salario sea menor a 500,000
SELECT *FROM Funcionario WHERE Salario < 500000
go

--15)  Haga 1 consulta de Funcionario con donde Salario sea mayor o igual a 450,000
SELECT *FROM Funcionario WHERE Salario >= 450000
go

