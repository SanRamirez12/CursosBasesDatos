--Laboratorio #2 Bases de Datos 2 
--Estudiantes:  José Alberto Álvarez Navarro y Santiago Ramírez Elizondo 

--Creacion de base de datos de Sistemas de vuelo:
CREATE DATABASE SistemaVuelos;
GO
--Se utiliza dicha DB:
USE SistemaVuelos;
GO

--CREACION DE TABLAS
--Se crea la tabla Aeropuerto
CREATE TABLE Aeropuerto (
    Codigo CHAR(5) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Ciudad VARCHAR(50) NOT NULL,
    Pais VARCHAR(50) NOT NULL
);
GO

--Se crea la tabla ModeloAvion
CREATE TABLE ModeloAvion (
    CodigoModelo VARCHAR(10) PRIMARY KEY,
    Capacidad INT NOT NULL
);
GO

--Se crea la tabla intermedia entre Aeropuerto y ModeloAvion, por el tipo de relacion M:N
CREATE TABLE AeropuertoModelo (
    IDAeropuerto CHAR(5) NOT NULL,
    IDModelo VARCHAR(10) NOT NULL,
    CONSTRAINT PK_AeropuertoModelo PRIMARY KEY (IDAeropuerto, IDModelo),
    CONSTRAINT FK_AeropuertoModelo_Aeropuerto FOREIGN KEY (IDAeropuerto) REFERENCES Aeropuerto(Codigo),
    CONSTRAINT FK_AeropuertoModelo_Modelo FOREIGN KEY (IDModelo) REFERENCES ModeloAvion(CodigoModelo)
);
GO

--Se crea la tabla de programas de vuelo:
CREATE TABLE ProgramaVuelo (
    NumeroVuelo INT PRIMARY KEY,
    LineaAerea VARCHAR(50) NOT NULL,
    DiasSemana VARCHAR(50) NOT NULL,
    AeropuertoOrigen CHAR(5) NOT NULL,
    AeropuertoDestino CHAR(5) NOT NULL,
    CONSTRAINT FK_ProgramaVuelo_Origen FOREIGN KEY (AeropuertoOrigen) REFERENCES Aeropuerto(Codigo),
    CONSTRAINT FK_ProgramaVuelo_Destino FOREIGN KEY (AeropuertoDestino) REFERENCES Aeropuerto(Codigo)
);
GO

--Se crea la tabla de vuelos:
CREATE TABLE Vuelo (
    IDVuelo INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE NOT NULL,
    PlazasVacias INT NOT NULL,
    CodigoModelo VARCHAR(10) NOT NULL,
    NumeroVuelo INT NOT NULL,
    CONSTRAINT FK_Vuelo_Modelo FOREIGN KEY (CodigoModelo) REFERENCES ModeloAvion(CodigoModelo),
    CONSTRAINT FK_Vuelo_Programa FOREIGN KEY (NumeroVuelo) REFERENCES ProgramaVuelo(NumeroVuelo)
);
GO

--Se crea la tabla de escalas tecnicas:
CREATE TABLE EscalaTecnica (
    IDEscala INT IDENTITY(1,1) PRIMARY KEY,
    IDVuelo INT NOT NULL,
    IDAeropuerto CHAR(5) NOT NULL,
    NumeroOrden INT NOT NULL,
    CONSTRAINT FK_Escala_Vuelo FOREIGN KEY (IDVuelo) REFERENCES Vuelo(IDVuelo),
    CONSTRAINT FK_Escala_Aeropuerto FOREIGN KEY (IDAeropuerto) REFERENCES Aeropuerto(Codigo)
);
GO

--Se crea la tabla de aterrizajes y despegues:
CREATE TABLE AterrizajeDespegue (
    IDRegistro INT IDENTITY(1,1) PRIMARY KEY,
    IDVuelo INT NOT NULL,
    IDAeropuerto CHAR(5) NOT NULL,
    TipoEvento VARCHAR(10) CHECK (TipoEvento IN ('Despegue', 'Aterrizaje')),
    FechaHora DATETIME NOT NULL,
    CONSTRAINT FK_AterrizajeDespegue_Vuelo FOREIGN KEY (IDVuelo) REFERENCES Vuelo(IDVuelo),
    CONSTRAINT FK_AterrizajeDespegue_Aeropuerto FOREIGN KEY (IDAeropuerto) REFERENCES Aeropuerto(Codigo)
);
GO

--CREACION PROCEDIMIENTOS ALMACENADOS, TRIGGERS Y VISTAS
--Procedimiento para insertar vuelo
CREATE PROCEDURE InsertarVuelo 
	@Fecha DATE, 
	@PlazasVacias INT, 
	@CodigoModelo VARCHAR(10), 
	@NumeroVuelo INT
AS
BEGIN
    BEGIN TRY
        INSERT INTO Vuelo (Fecha, PlazasVacias, CodigoModelo, NumeroVuelo)
        VALUES (@Fecha, @PlazasVacias, @CodigoModelo, @NumeroVuelo);
    END TRY
    BEGIN CATCH
        PRINT 'Error al insertar el vuelo';
    END CATCH
END;
GO

--Procedimiento para actualizar vuelos:
CREATE PROCEDURE ActualizarVuelo @IDVuelo INT, @Fecha DATE, @PlazasVacias INT, @CodigoModelo VARCHAR(10), @NumeroVuelo INT
AS
BEGIN
    BEGIN TRY
        UPDATE Vuelo
        SET Fecha = @Fecha, PlazasVacias = @PlazasVacias, CodigoModelo = @CodigoModelo, NumeroVuelo = @NumeroVuelo
        WHERE IDVuelo = @IDVuelo;
    END TRY
    BEGIN CATCH
        PRINT 'Error al actualizar el vuelo';
    END CATCH
END;
GO

--Trigger para para evitar vuelos con capacidd mayor al modelo
CREATE TRIGGER trg_VerificarCapacidad
ON Vuelo
AFTER INSERT
AS
BEGIN
    IF EXISTS (
		SELECT 1 FROM inserted i
        JOIN ModeloAvion m ON i.CodigoModelo = m.CodigoModelo
        WHERE i.PlazasVacias > m.Capacidad
    )
    BEGIN
        RAISERROR ('El número de plazas vacías excede la capacidad del modelo.', 16, 1);
        ROLLBACK;
    END;
END;
GO

--Vista para ver todos los vuelos con su informacion 
CREATE VIEW Vista_Vuelos AS
SELECT v.IDVuelo, v.Fecha, v.PlazasVacias, m.CodigoModelo, p.LineaAerea, a1.Nombre AS Origen, a2.Nombre AS Destino
FROM Vuelo v
JOIN ModeloAvion m ON v.CodigoModelo = m.CodigoModelo
JOIN ProgramaVuelo p ON v.NumeroVuelo = p.NumeroVuelo
JOIN Aeropuerto a1 ON p.AeropuertoOrigen = a1.Codigo
JOIN Aeropuerto a2 ON p.AeropuertoDestino = a2.Codigo;
GO

--Creamos una vista para consultar los programas de vuelo:
CREATE VIEW Vista_ProgramasVuelo AS
SELECT p.NumeroVuelo, p.LineaAerea, p.DiasSemana, a1.Nombre AS Origen, a2.Nombre AS Destino
FROM ProgramaVuelo p
JOIN Aeropuerto a1 ON p.AeropuertoOrigen = a1.Codigo
JOIN Aeropuerto a2 ON p.AeropuertoDestino = a2.Codigo;
GO
--Consultamos la vista:
SELECT*FROM Vista_Vuelos
SELECT*FROM Vista_ProgramasVuelo
GO

--Procedimiento para eliminar vuelos
CREATE PROCEDURE EliminarVuelo @IDVuelo INT
AS
BEGIN
    BEGIN TRY
        DELETE FROM Vuelo WHERE IDVuelo = @IDVuelo;
    END TRY
    BEGIN CATCH
        PRINT 'Error al eliminar el vuelo, verifique dependencias.';
    END CATCH
END;
GO

--Trigger para registrar cambios en vuelos: 
CREATE TRIGGER trg_RegistroCambiosVuelo
ON Vuelo
AFTER UPDATE
AS
BEGIN
    PRINT 'Se ha actualizado un vuelo en la base de datos';
END;
GO

--Trigger para evitar la eliminacion de aeropuertos con vuelos asociados:
CREATE TRIGGER trg_ProtegerAeropuertos
ON Aeropuerto
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM ProgramaVuelo WHERE AeropuertoOrigen IN (SELECT Codigo FROM deleted)
        OR AeropuertoDestino IN (SELECT Codigo FROM deleted)
    )
    BEGIN
        RAISERROR ('No se puede eliminar el aeropuerto porque está asociado a un programa de vuelo.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM Aeropuerto WHERE Codigo IN (SELECT Codigo FROM deleted);
    END;
END;
GO

--INSERCION DE DATOS PARA VER PRUEBAS
----Insertamos Aeropuertos
--INSERT INTO Aeropuerto VALUES
--('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
--('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA'),
--('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
--('LHR', 'Heathrow Airport', 'London', 'UK'),
--('MAD', 'Adolfo Suárez Madrid-Barajas Airport', 'Madrid', 'Spain'),
--('HND', 'Tokyo Haneda Airport', 'Tokyo', 'Japan'),
--('SYD', 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia'),
--('GRU', 'São Paulo-Guarulhos International Airport', 'São Paulo', 'Brazil'),
--('FRA', 'Frankfurt Airport', 'Frankfurt', 'Germany'),
--('DXB', 'Dubai International Airport', 'Dubai', 'UAE');

----Insertamos Modelos de Avión
--INSERT INTO ModeloAvion VALUES
--('A320', 180),
--('B737', 189),
--('A380', 850),
--('B777', 396),
--('B787', 296);

--Insertamos Programas de Vuelo
--INSERT INTO ProgramaVuelo VALUES
--(1001, 'American Airlines', 'Lunes, Miércoles, Viernes', 'JFK', 'LAX'),
--(1002, 'British Airways', 'Martes, Jueves, Sábado', 'LHR', 'CDG'),
--(1003, 'Emirates', 'Diario', 'DXB', 'SYD'),
--(1004, 'Iberia', 'Lunes y Viernes', 'MAD', 'GRU'),
--(1005, 'Lufthansa', 'Martes y Sábado', 'FRA', 'HND');

---- Insertamos Vuelos
--INSERT INTO Vuelo (Fecha, PlazasVacias, CodigoModelo, NumeroVuelo) VALUES
--('2025-03-01', 20, 'A320', 1001),
--('2025-03-02', 10, 'B737', 1002),
--('2025-03-03', 50, 'A380', 1003),
--('2025-03-04', 30, 'B777', 1004),
--('2025-03-05', 15, 'B787', 1005);

---- Insertamos Escalas Técnicas
--INSERT INTO EscalaTecnica (IDVuelo, IDAeropuerto, NumeroOrden) VALUES
--(1, 'FRA', 1),
--(2, 'MAD', 1),
--(3, 'LAX', 1),
--(4, 'CDG', 1),
--(5, 'SYD', 1);

----Insertamos Aterrizajes y Despegues
--INSERT INTO AterrizajeDespegue (IDVuelo, IDAeropuerto, TipoEvento, FechaHora) VALUES
--(1, 'JFK', 'Despegue', '2025-03-01 08:00:00'),
--(1, 'LAX', 'Aterrizaje', '2025-03-01 12:00:00'),
--(2, 'LHR', 'Despegue', '2025-03-02 09:30:00'),
--(2, 'CDG', 'Aterrizaje', '2025-03-02 11:00:00'),
--(3, 'DXB', 'Despegue', '2025-03-03 15:00:00'),
--(3, 'SYD', 'Aterrizaje', '2025-03-03 23:30:00');
GO

--Ahora Visualizamos todo lo que tenemos:
SELECT*FROM Vista_Vuelos
SELECT*FROM Vista_ProgramasVuelo
SELECT*FROM Aeropuerto
SELECT*FROM ModeloAvion
GO

--Realizamos algunas pruebas para ver que los triggers funcionan:
--Si ejecutamos este delete se dispara el trigger para proteger aeropuertos:
DELETE FROM Aeropuerto WHERE Codigo = 'JFK';
--Insertar mas plazas vacias que la capacidad permitida en un vuelo:
EXEC InsertarVuelo '2025-03-06', 200, 'A320', 1001;
