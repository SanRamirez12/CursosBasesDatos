--Proyecto 2 del Curso: Bases de Datos 1
--Estudiante: Felipe M�ndez Navarro, Santiago Ram�rez Elizondo, Alberto �lvarez Navarro, Alonso Matarrita Obreg�n 

--Creaci�n de DB; Tema: Equipos Deportivos de Costa Rica
CREATE DATABASE EquiposDeportivos
GO
--Usar la DB creada
USE EquiposDeportivos
GO

--En base a un modelado de datos inicial, se crean las tablas con sus respectivas relaciones

-------------------------
--CREACION DE TABLAS-----
-------------------------

--Creaci�n de tabla Nacionalidades
CREATE TABLE dbo.Nacionalidades
(
	ID_Nacionalidades	VARCHAR(3) UNIQUE NOT NULL,
	Pais				NVARCHAR(50) NOT NULL
	CONSTRAINT PK_ID_Nacionalidades PRIMARY KEY (ID_Nacionalidades)
)
GO

--Creaci�n de tabla de Provincias de Costa Rica
CREATE TABLE dbo.ProvinciasCR
(
	ID_Provincia		VARCHAR(3) UNIQUE NOT NULL,
	NombreProvincia		NVARCHAR(50) NOT NULL
	CONSTRAINT PK_ID_Provincia PRIMARY KEY (ID_Provincia)
)
GO

--Creaci�n de tabla Estadios de futbol costarricense
CREATE TABLE dbo.Estadios
(
	ID_Estadios			INT IDENTITY(1,1) NOT NULL,
	ID_Provincia		VARCHAR(3) NOT NULL,
	NombreEstadio		NVARCHAR(100) NOT NULL
	CONSTRAINT PK_ID_Estadios PRIMARY KEY (ID_Estadios),
	CONSTRAINT FK_ID_Provincias FOREIGN KEY (ID_Provincia) REFERENCES dbo.ProvinciasCR (ID_Provincia)
)
GO

--Creaci�n de tabla entrenadores 
CREATE TABLE dbo.Entrenadores
(
	ID_Entrenadores		INT IDENTITY(1,1) NOT NULL,
	NombreEntrenador	NVARCHAR(50) NOT NULL,
	ApellidoEntrenador	NVARCHAR(50) NOT NULL
	CONSTRAINT PK_ID_Entrenadores PRIMARY KEY (ID_Entrenadores)
)
GO

--Creaci�n de tabla Equipos de futbol costarricense de primera divisi�n
CREATE TABLE dbo.Equipos
(
	ID_Equipos			VARCHAR(4) UNIQUE NOT NULL,
	NombreEquipo		NVARCHAR(100) NOT NULL,
	AnnoFundacion		DATE,
	ID_Estadio			INT NOT NULL,
	ID_Entrenadores		INT NOT NULL
	CONSTRAINT PK_ID_Equipos PRIMARY KEY (ID_Equipos),
	CONSTRAINT FK_ID_Estadio FOREIGN KEY (ID_Estadio) REFERENCES dbo.Estadios(ID_Estadios),
	CONSTRAINT FK_ID_Entrenadores FOREIGN KEY (ID_Entrenadores) REFERENCES dbo.Entrenadores(ID_Entrenadores)
)
GO

--Creaci�n de tabla Jugadores 
CREATE TABLE dbo.Jugadores
(
	ID_Jugadores		INT IDENTITY(1,1) NOT NULL,
	NombreJugador		NVARCHAR(50) NOT NULL,
	ApellidoJugador		NVARCHAR(70) NOT NULL,
	FechaNacimiento		DATE NOT NULL,
	Altura				DECIMAL(3,2) NOT NULL, --Decimal(Cantidad de numeros , decimales)
	ID_Nacionalidades	VARCHAR(3) NOT NULL,
	ID_Equipo			VARCHAR(4) NOT NULL
	CONSTRAINT PK_ID_Jugadores PRIMARY KEY (ID_Jugadores),
	CONSTRAINT FK_ID_Nacionalidades FOREIGN KEY (ID_Nacionalidades) REFERENCES dbo.Nacionalidades(ID_Nacionalidades),
	CONSTRAINT FK_ID_Equipo FOREIGN KEY (ID_Equipo) REFERENCES dbo.Equipos (ID_Equipos)
)
GO

-------------------------
--INSERCI�N DE DATOS-----
-------------------------

--Se insertan las provincias de Costa Rica en la tabla respectiva:
INSERT INTO dbo.ProvinciasCR(ID_Provincia, NombreProvincia)
VALUES
	('SJ','San Jos�'),
	('A','Alajuela'),
	('C','Cartago'),
	('H','Heredia'),
	('G','Guanacaste'),
	('P','Puntarenas'),
	('L','Lim�n');
GO
--Se visualiza la Inserci�n:
--SELECT*FROM dbo.ProvinciasCR

--Como hay muchos pa�ses y nacionalidades limitaremos esos a nacionalidades de America
--Se insertan las nacionalidades
INSERT INTO dbo.Nacionalidades(ID_Nacionalidades, Pais)
VALUES
	('ARG', 'Argentina'),
	('BOL', 'Bolivia'),
	('BRA', 'Brasil'),
	('CHL', 'Chile'),
	('COL', 'Colombia'),
	('CRI', 'Costa Rica'),
	('CUB', 'Cuba'),
	('DOM', 'Rep�blica Dominicana'),
	('ECU', 'Ecuador'),
	('SLV', 'El Salvador'),
	('GTM', 'Guatemala'),
	('HND', 'Honduras'),
	('MEX', 'M�xico'),
	('NIC', 'Nicaragua'),
	('PAN', 'Panam�'),
	('PRY', 'Paraguay'),
	('PER', 'Per�'),
	('URY', 'Uruguay'),
	('VEN', 'Venezuela'),
	('USA', 'Estados Unidos'),
	('CAN', 'Canad�');
GO
--Se visualiza la Inserci�n:
--SELECT*FROM dbo.Nacionalidades

--Se insertan los entrenadores de la liga Prom�rica (f�tbol nacional Primera Divisi�n)
INSERT INTO dbo.Entrenadores(NombreEntrenador, ApellidoEntrenador)
VALUES
	('H�ctor','Altamirano'),
	('Alexandre','Guimar�es'),
	('Jos�','Giacone'),
	('Paulo C�sar','Wanchope'),
	('V�ctor','Abelenda'),
	('Horacio','Esquivel'),
	('Javier','San Rom�n'),
	('Luis Fernando','Fallas'),
	('Julio C�sar Dely','Vald�s'),
	('Hern�n','Medford'),
	('Carlos','Rodr�guez'),
	('Horacio','Esquivel')
GO

--Se visualiza la Inserci�n:
--SELECT*FROM dbo.Entrenadores

--Hubo un error con el t�cnico de Guanacasteca
UPDATE dbo.Entrenadores
SET NombreEntrenador = 'Alexander', ApellidoEntrenador = 'Vargas'
WHERE ID_Entrenadores = 6
GO
--Hubo un error con el t�cnico de Santa Ana
UPDATE dbo.Entrenadores
SET NombreEntrenador = 'Cristian', ApellidoEntrenador = 'Oviedo'
WHERE ID_Entrenadores = 12
GO

--Se insertan los datos de cada estadio:
INSERT INTO dbo.Estadios(NombreEstadio, ID_Provincia)
VALUES
	('Estadio Alejandro Morera Soto','A'),
	('Estadio Eladio Rosabal Cordero','H'),
	('Estadio Ricardo Saprissa Aym�','SJ'),
	('Estadio Fello Meza','C'),
	('Estadio Carlos Ugalde �lvarez','A'),
	('Estadio Chorotega','G'),
	('Estadio Allen Riggioni Su�rez','A'),
	('Estadio Municipal de P�rez Zeled�n','SJ'),
	('Estadio Ebal Rodr�guez','L'),
	('Estadio Ernesto Rohrmoser','SJ'),
	('Estadio Lito P�rez','P'),
	('Estadio Piedades de Santa Ana','SJ')
GO
--Se visualiza la Inserci�n:
--SELECT*FROM dbo.Estadios

--Se insertan los datos de los equipos
INSERT INTO dbo.Equipos(ID_Equipos,NombreEquipo, AnnoFundacion, ID_Estadio, ID_Entrenadores)
VALUES
	('LDA','Liga Deportiva Alajuelense','1919',1,2),
	('CSH','Club Sport Herediano','1921',2,1),
	('SAP','Deportivo Saprissa','1935',3,3),
	('CSC','Club Sport Cartagin�s','1906',4,4),
	('SC','Asociaci�n Deportiva San Carlos','1965',5,5),
	('ADG','Asociaci�n Deportiva Guanacasteca','1973',6,6),
	('MGR','Municipal Grecia','1998',7,7),
	('MPZ','Municipal P�rez Zeled�n','1962',8,8),
	('SGU','Santos de Gu�piles','1961',9,9),
	('SFC','Sporting F�tbol Club','2016',10,10),
	('ADP','Asociaci�n Deportiva Puntarenas','2004',11,11),
	('STA','Santa Ana F�tbol Club','1961',12,12)
GO

--Se visualiza la Inserci�n:
--SELECT*FROM dbo.Equipos

--Se insertan algunos jugadores de la primera divisi�n
INSERT INTO dbo.Jugadores(NombreJugador, ApellidoJugador, FechaNacimiento, Altura, ID_Nacionalidades, ID_Equipo)
VALUES
	('Jos�','Gonz�lez','1995-05-15',1.80,'CRI','SAP'),
	('Ronald','Matarrita','1994-11-14',1.70,'CRI','LDA'),
	('Joseph','Mora','1993-05-21',1.75,'CRI','SAP'),
	('Mart�n','Alan�z','1992-08-30',1.85,'URY','CSC'),
	('Joel','Campbell','1992-06-26',1.80,'CRI','LDA'),
	('Luis','Paradela','1997-03-10',1.78,'CUB','SAP'),
	('Yostin','Salinas','1998-09-14',1.84,'CRI','SFC'),
	('Patrick','Sequeira','1999-03-01',1.90,'CRI','CSC'),
	('Jos� Pablo','Molina','1996-07-12',1.82,'CRI','CSC'),
	('Alexander','Vargas','1995-02-20',1.80,'CRI','ADG'),
	('Javier','San Rom�n','1990-04-05',1.75,'CRI','MGR'),
	('Luis Fernando','Fallas','1992-11-22',1.78,'CRI','MPZ')
GO

--Se visualiza la Inserci�n:
--SELECT*FROM dbo.Jugadores

-------------------------
--CONSULTAS--------------
-------------------------

--Consultas usando el operador tipo LIKE %:
--Apellidos de jugadores que empiezan con S
SELECT*FROM Jugadores WHERE ApellidoJugador LIKE 'S%'
GO
--Nombres que terminan con O o R
SELECT*FROM Jugadores WHERE NombreJugador LIKE '%O' OR NombreJugador LIKE '%R'
GO

--Consultas usando el operador tipo AND:
--Cuando un jugador mida igual o m�s de 1.80 y sea costarricense
SELECT*FROM Jugadores WHERE Altura>=1.80 AND ID_Nacionalidades = 'CRI'
GO
--Cuando un jugador sea menor a 1.80 y sea extranjero
SELECT*FROM Jugadores WHERE Altura<1.80 AND ID_Nacionalidades <> 'CRI' --<>
GO
--<>: Operador de diferente o no igual

--Consultas usando el operador tipo OR:
--Cuando un equipo su nombre empieza con Club o con Asociaci�n:
SELECT*FROM Equipos WHERE NombreEquipo LIKE 'Club%' OR NombreEquipo LIKE 'Asociaci�n%'
GO
--Cuando un jugador tiene Jos� en su nombre o juega en la Liga Deportiva Alajuelense:
SELECT*FROM Jugadores WHERE NombreJugador LIKE 'Jos�%' OR ID_Equipo = 'LDA'
GO

--Consultas usando el operador tipo NOT:
--Cuando un jugador no es de Costa Rica:
SELECT*FROM Jugadores WHERE NOT ID_Nacionalidades = 'CRI'
GO
--Cuando un estadio no es ni de Alajuela ni de San Jos�:
SELECT*FROM Estadios WHERE NOT ID_Provincia = 'SJ' AND NOT ID_Provincia = 'A'
GO

--Consultas usando el operador tipo BETWEEN:
--Cuando la altura de un jugador se encuentra entre 1.70 y 1.80:
SELECT*FROM Jugadores WHERE Altura BETWEEN 1.70 AND 1.80
GO
--Cuando la altura no se encuentra de 1.70 a un 1.80:
SELECT*FROM Jugadores WHERE Altura NOT BETWEEN  1.70 AND 1.80
GO

--Consultas haciendo uso de Join:
--1)Uni�n de las tablas Jugadores y equipos, sin incluir jugadores de Cartago o la Liga:
SELECT J.NombreJugador AS 'Nombre del Jugador', J.ApellidoJugador AS 'Apellido del Jugador', 
Eq.NombreEquipo AS 'Nombre de Equipo'
FROM Jugadores AS J JOIN Equipos AS Eq ON J.ID_Equipo = Eq.ID_Equipos 
WHERE Eq.NombreEquipo <> 'Club Sport Cartagin�s' AND Eq.NombreEquipo <> 'Liga Deportiva Alajuelense'
GO
--2)Uni�n de las tablas Estadios y Equipos, para visualizar los nombres completos de ambos y 
--su fecha de fundaci�n usando la funci�n Year(), ordenado en de forma ascendente por a�o:
SELECT Eq.NombreEquipo AS 'Equipo', Es.NombreEstadio AS 'Estadio', 
YEAR(Eq.AnnoFundacion) AS 'A�o de Fundaci�n'
FROM Estadios AS Es JOIN Equipos AS Eq ON Es.ID_Estadios = Eq.ID_Estadio
ORDER BY 'A�o de Fundaci�n' ASC
GO
--3)Uni�n de los jugadores de Cartago, mostrando de forma expl�cita sus datos completos, ordenado de m�s alto a m�s bajo:
SELECT J.NombreJugador AS 'Nombre del Jugador', J.ApellidoJugador AS 'Apellido del Jugador', 
YEAR(J.FechaNacimiento) AS 'A�o de Nacimiento', J.Altura, N.Pais AS 'Pa�s de Origen'
FROM Jugadores AS J 
JOIN Equipos AS Eq ON J.ID_Equipo = Eq.ID_Equipos 
JOIN Nacionalidades AS N ON J.ID_Nacionalidades = N.ID_Nacionalidades
WHERE Eq.NombreEquipo = 'Club Sport Cartagin�s'
ORDER BY Altura DESC
GO
--4)Uni�n de los entrenadores y equipos de forma expl�cita,
--(Concatenando el nombre y el apellido del entrenador y orden�ndolo de forma ascendente):
SELECT Eq.NombreEquipo AS 'Equipo', En.NombreEntrenador+' '+En.ApellidoEntrenador AS 'Entrenador'
FROM Entrenadores AS En JOIN Equipos AS Eq ON Eq.ID_Entrenadores = En.ID_Entrenadores
ORDER BY 'Entrenador' ASC
GO

