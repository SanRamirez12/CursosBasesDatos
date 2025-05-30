--Creacion de Base de datos
CREATE DATABASE ControlAccesoDB
GO

USE ControlAccesoDB
GO


--Creacion de la tabla de roles:
CREATE TABLE Roles(
	id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

--Creacion Tabla de Permisos
CREATE TABLE Permisos(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(50) UNIQUE NOT NULL
);
GO

--Creacion de tabla de usuarios
CREATE TABLE Usuarios(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nombre_usuario VARCHAR(50) UNIQUE NOT NULL,
	contrasena VARCHAR(255) NOT NULL,
	id_rol  INT NOT NULL,
	activo BIT DEFAULT 1,
	FOREIGN KEY (id_rol) REFERENCES Roles(id)
);
GO

--Creacion de la tabla de asignación de permisos a roles
CREATE TABLE RolesPermisos(
	id_rol INT NOT NULL,
	id_permiso INT NOT NULL,
	PRIMARY KEY(id_rol,id_permiso),
	FOREIGN KEY(id_rol) REFERENCES Roles(id),
	FOREIGN KEY(id_permiso) REFERENCES Permisos(id)
);
GO

--Creacion de tabla registro de acceso
CREATE TABLE RegistrosAcceso(
	id INT IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NOT NULL,
	fecha_acceso DATETIME DEFAULT GETDATE(),
	exito BIT NOT NULL,
	FOREIGN KEY(id_usuario) REFERENCES Usuarios(id)
)
GO


----INSERSIONES
----Inserciones de roles:
--INSERT INTO Roles(nombre) 
--VALUES
--	('Administrador'),('Usuario'),('Supervisor')
--GO

----Insercion de permisos basicos
--INSERT INTO Permisos(nombre) 
--VALUES 
--	('Ver Reportes'),('Administrar Usuarios'),('Gestionar Datos')
--GO

----Asignación de permisos a roles
--INSERT INTO RolesPermisos(id_rol,id_permiso)
--VALUES (1,1),(1,2),(1,3),(2,1),(3,1),(3,3)
--GO

--Creacion de un procedimiento almacenado para autenticacion de usuarios
CREATE PROCEDURE AutenticarUsuario
	@nombre_usuario VARCHAR(50),
	@contrasena VARCHAR(255)
AS
BEGIN
	DECLARE @id_usuario INT;
	DECLARE @contrasena_bd VARCHAR(255);
	DECLARE @id_rol INT;

	SELECT @id_usuario = id,@contrasena_bd = contrasena, @id_rol = id_rol
	FROM Usuarios
	WHERE nombre_usuario = @nombre_usuario AND activo = 1;

	IF(@contrasena_bd=@contrasena)
	BEGIN
		INSERT INTO RegistrosAcceso(id_usuario, exito)
		VALUES (@id_usuario,1);
		SELECT 'Acceso Concedido', @id_rol AS Rol;
	END
	ELSE
	BEGIN
		INSERT INTO RegistrosAcceso(id_usuario, exito)
		VALUES (@id_usuario, 0);
		SELECT 'Acceso Denegado';
	END
END