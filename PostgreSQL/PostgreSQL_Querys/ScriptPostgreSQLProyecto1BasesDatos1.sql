--CREATE para crear la tabla 
--SERIAL incrementa la variable en numero entero(partiendo de 1, y va de 1 en 1)
--UNIQUE el tipo de dato debe ser unico cada que se haga una insercion 
--Datatype TIMESTAMP fecha y hora, puede o no incluir localizacion 
CREATE TABLE usuarios(
	id_usuario SERIAL PRIMARY KEY,
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(60) NOT NULL,
	contrasena VARCHAR(100) NOT NULL, 
	email VARCHAR(200) UNIQUE NOT NULL,
	fecha_creacion TIMESTAMP
)
--Mostrar la tabla usuarios
SELECT*FROM "public"."usuarios";
--Creacion de tabla Ocupaciones 
CREATE TABLE ocupaciones(
	id_ocupacion SERIAL PRIMARY KEY,
	tipo_ocupacion VARCHAR(100) NOT NULL, 
	descripcion VARCHAR(300) NOT NULL
)

--Mostrar la tabla ocupaciones
SELECT*FROM "public"."ocupaciones";
--Creacion tabla usuarios-ocupaciones (ID's)
--REFERENCES hace referencia a ciertos atributos de otras tablas, en el caso de ID como llaves foraneas
CREATE TABLE usuarios_ocupaciones(
	id_usuario INTEGER REFERENCES usuarios(id_usuario),
	id_ocupacion INTEGER REFERENCES ocupaciones(id_ocupacion)
)
--Mostrar la tabla ocupaciones
SELECT*FROM "public"."usuarios_ocupaciones";
--Borrar tabla(s)
--DROP TABLE usuario, ocupaciones;

--Insertar datos en tabla Usuarios:
--CURRENT_TIMESTAMP utiliza la fecha y hora de cuando se agrega
INSERT INTO usuarios(nombre,apellido,contrasena,email,fecha_creacion)
VALUES 
	('Eugenio','Rodriguez','123rtg','eugenio@gmail.com',CURRENT_TIMESTAMP),
	('Juan','Gonzalez','Juancito345','juancito@gmail.com',CURRENT_TIMESTAMP),
	('Santiago','Ramirez','santi1234565','sanramel1205@gmail.com',CURRENT_TIMESTAMP)
	
--Insertar datos en tabla Ocupaciones:
INSERT INTO ocupaciones(tipo_ocupacion,descripcion)
VALUES 
	('Administrativo','Gestionan, 0rganizan, planifican, atienden y 
	efectúan tareas administrativas, de soporte y apoyo a la organización'),
	('Programador','Arquitecto digital, un maestro de los códigos y 
	algoritmos que da vida a nuestras aplicaciones y sistemas informáticos')
	
--Actualizar usuarios
--UPDATE para actualizar, SET para especificar el nuevo cambio, WHERE indicar el usuario a actualizar
--RETURNING para visualizar el cambio de una
UPDATE usuarios
SET 
	contrasena = '456Santi7',
	email = 'santiaguito12@gmail.com'
WHERE id_usuario = 5
RETURNING nombre, apellido, contrasena, email

--Borrar usuarios de tablas
--Primero creamos una ocupacion en tabla ocupacion y luego la borramos
INSERT INTO ocupaciones(tipo_ocupacion,descripcion)
VALUES
	('Limpieza','Barre, seca, limpia y ordena las oficinas')
--Mostrar la tabla ocupaciones
SELECT*FROM "public"."ocupaciones";
--Borrar datos en la tabla
-- DELETE para borrar y FROM para indicar de donde
DELETE FROM ocupaciones 
WHERE id_ocupacion = 3

DELETE FROM usuarios
WHERE id_usuario = 4
--Mostrar la tabla usuarios
SELECT*FROM "public"."usuarios";
--Si se deseara borrar varios usuarios, se utiliza un formato parecido, tal que se diga con el prefijo IN los id's a borrar
--RETURNING * para devoler una tabla con los ids borrados y su informacion 
DELETE FROM usuarios
WHERE id_usuario IN (1,3)
RETURNING *;


--Script de prueba para la presentacion del PROYECTO:
--Mostrar la tabla usuarios
-- SELECT*FROM "public"."usuarios";

--1)Insertar Usuarios
-- INSERT INTO usuarios(nombre,apellido,contrasena,email,fecha_creacion)
-- VALUES 
-- 	('Pedro','Villalobos','arg','pdr@gmail.com',CURRENT_TIMESTAMP),
-- 	('Roberto','Vargas','vargas67','rvargas@gmail.com',CURRENT_TIMESTAMP),
-- 	('Jony','Bravo','herescomesjony12','jony@gmail.com',CURRENT_TIMESTAMP)

--2)Actualizar Usuarios
-- UPDATE usuarios
-- SET 
-- 	contrasena = 'Pedri680',
-- 	email = 'pedrovilla@gmail.com'
-- WHERE id_usuario = 6
-- RETURNING nombre, apellido, contrasena, email

--3)Eliminar Usuarios
-- DELETE FROM usuarios
-- WHERE id_usuario = 7





