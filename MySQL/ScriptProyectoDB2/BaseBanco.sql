CREATE DATABASE DBO_BANCO;

USE DBO_BANCO;

###########################################################################
#CREACIÓN DE TABLAS#
###########################################################################

CREATE TABLE USUARIOS(

	IdUsuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Apellido1 NVARCHAR(50) NOT NULL,
    Apellido2 NVARCHAR(50) NOT NULL,
	Direccion NVARCHAR(150) NOT NULL,
    Telefono VARCHAR(20) NOT NULL,
    FechaNacimiento DATE NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    TipoCliente NVARCHAR(50) NOT NULL
    
);


ALTER TABLE USUARIOS
ADD COLUMN CEDULA VARCHAR(20) NOT NULL;
SELECT * FROM usuarios;
SELECT * FROM cuentas;
SELECT * FROM tarjetas;
SELECT * FROM  HISTORIAL_TRANSACCIONES;
ALTER TABLE USUARIOS
modify column FechaNacimiento VARCHAR(20);
ALTER TABLE USUARIOS CHANGE COLUMN Direccion Direccion VARCHAR(150) NOT NULL;


DELETE FROM USUARIOS;
ALTER TABLE cuentas AUTO_INCREMENT = 1;
DELETE FROM usuarios where IdUsuario = 2;
Select*from  usuarios;
select*from cuentas;
select*from tarjetas;



CREATE TABLE MONEDA(

	IdMoneda INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Codigo VARCHAR(30) NOT NULL,
    Simbolo NVARCHAR(30) NOT NULL
    
);

CREATE TABLE CUENTAS(

	IdCuenta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    IdUsuario INT NOT NULL,
    IdMoneda INT NOT NULL,
    TipoCuenta VARCHAR(50),
    Saldo INT,
    FechaApertura Date,
    EstadoCuenta NVARCHAR(50),
    NumeroCuenta NVARCHAR(50),
    
    FOREIGN KEY (IdUsuario) REFERENCES USUARIOS(IdUsuario),
	FOREIGN KEY (IdMoneda) REFERENCES MONEDA(IdMoneda)
    
);
UPDATE CUENTAS
SET EstadoCuenta = 'Activa'
WHERE IdUsuario = 3;
ALTER TABLE CUENTAS 
ADD COLUMN NumeroCuenta VARCHAR(20) NOT NULL;
SELECT*FROM CUENTAS;
ALTER TABLE CUENTAS  
MODIFY COLUMN NumeroCuenta VARCHAR(30) NOT NULL;


CREATE TABLE TARJETAS(

	IdTarjeta INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    IdCuenta INT NOT NULL,
    EstadoTarjeta VARCHAR (30) NOT NULL,
    NumeroTarjeta VARCHAR (30) NOT NULL,
    Pin VARCHAR (4) NOT NULL,
    FechaVencimiento DATE NOT NULL

);


CREATE TABLE RETIROS (

	IdRetiro INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	IdCuentaEmisor INT NOT NULL,
    IdCuentaReceptor INT NOT NULL,
    Fecha DATE NOT NULL,
    Monto INT NOT NULL,
    
    
    FOREIGN KEY (IdCuentaEmisor) REFERENCES CUENTAS(IdCuenta),
	FOREIGN KEY (IdCuentaReceptor) REFERENCES CUENTAS(IdCuenta)

);

CREATE TABLE DEPOSITOS (

	IdDeposito INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	IdCuentaEmisor INT NOT NULL,
    IdCuentaReceptor INT NOT NULL,
    Fecha DATE NOT NULL,
    Monto INT NOT NULL,
    
    
    FOREIGN KEY (IdCuentaEmisor) REFERENCES CUENTAS(IdCuenta),
	FOREIGN KEY (IdCuentaReceptor) REFERENCES CUENTAS(IdCuenta)

);

CREATE TABLE TRANSFERENCIAS(

	IdTransferencia INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    IdCuentaEmisor INT NOT NULL,
    IdCuentaReceptor INT NOT NULL,
    Fecha DATE NOT NULL,
    MONTO DECIMAL(10,2) NOT NULL,
    Detalle TEXT NOT NULL,
    
    FOREIGN KEY (IdCuentaEmisor) REFERENCES CUENTAS(IdCuenta),
	FOREIGN KEY (IdCuentaReceptor) REFERENCES CUENTAS(IdCuenta)

);
ALTER TABLE Transferencias ADD COLUMN  Detalle TEXT NOT NULL;

CREATE TABLE HISTORIAL_TRANSACCIONES (
    IdHistorial INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    IdCuenta INT NOT NULL,
    Monto DECIMAL(10,2) NOT NULL,
    Fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Detalle TEXT,
    IdUsuario INT NOT NULL,
    
    -- Agregar nombres únicos a las claves foráneas
    CONSTRAINT fk_historial_cuenta FOREIGN KEY (IdCuenta) REFERENCES CUENTAS(IdCuenta)
 
);
DELETE FROM HISTORIAL_TRANSACCIONES WHERE  IdCuenta = 1;
ALTER TABLE HISTORIAL_TRANSACCIONES add COLUMN IdUsuario INT NOT NULL;
ALTER TABLE HISTORIAL_TRANSACCIONES DROP FOREIGN KEY fk2;
ALTER TABLE HISTORIAL_TRANSACCIONES
ADD CONSTRAINT fk2
FOREIGN KEY (IdCuentaReceptor) 
REFERENCES CUENTAS(IdCuenta);


INSERT INTO MONEDA(Nombre, Codigo, Simbolo)
VALUES ('COLÓN', 'ISO 4217', '¢'),
		('DOLAR', 'ISO 4217', '$'),
        ('EURO', 'EUR', '€');
        
SELECT*FROM MONEDA;


###########################################################################
#PROCEDIMIENTOS ALMACEDANOS#
###########################################################################

DELIMITER $$
CREATE PROCEDURE InsertarUsuario (

	IN p_Nombre VARCHAR(50),
    IN p_Apellido1 VARCHAR(50),
    IN p_Apellido2 VARCHAR(50),
	IN p_Direccion VARCHAR(150),
    IN p_Telefono VARCHAR(20),
    IN p_FechaNacimiento DATE,
    IN p_Email VARCHAR(150),
    IN p_TipoCliente VARCHAR(50),
    IN p_Cedula VARCHAR(30)
    
)
BEGIN 
	INSERT INTO USUARIOS (Nombre, Apellido1, Apellido2, Direccion, Telefono, FechaNacimiento, Email, TipoCliente,Cedula)
    VALUES(p_Nombre, p_Apellido1, p_Apellido2, p_Direccion, p_Telefono, p_FechaNacimiento, p_Email, p_TipoCliente, p_Cedula);
END $$
DELIMITER ;

Drop procedure EditarUsuario;

DELIMITER $$
CREATE PROCEDURE EditarUsuario (

	IN p_Cedula VARCHAR(30),
    IN p_Nombre VARCHAR(50),
    IN p_Apellido1 VARCHAR(50),
    IN p_Apellido2 VARCHAR(50),
	IN p_Direccion VARCHAR(150),
    IN p_Telefono VARCHAR(20),
    IN p_FechaNacimiento DATE,
    IN p_Email VARCHAR(150)
    
    )
    
    BEGIN 
    UPDATE USUARIOS
    SET nombre = p_Nombre, Apellido1= p_Apellido1, Apellido2 = p_Apellido2, Direccion = p_Direccion, Telefono=p_Telefono, FechaNacimiento = p_FechaNacimiento,
    Email = p_Email
    Where Cedula = p_Cedula;
    END$$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE RealizarRetiro(
    IN p_NumeroCuentaEmisor VARCHAR(20),
    IN p_NumeroCuentaReceptor VARCHAR(20),
    IN p_Monto INT
)
BEGIN
    DECLARE v_IdCuentaEmisor INT;
    DECLARE v_IdCuentaReceptor INT;

    -- Obtener el IdCuenta del emisor a partir del NumeroCuenta
    SELECT IdCuenta INTO v_IdCuentaEmisor FROM CUENTAS WHERE NumeroCuenta = p_NumeroCuentaEmisor;
    
    -- Verificar si la cuenta del emisor existe
    IF v_IdCuentaEmisor IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta del emisor no existe.';
    END IF;

    -- Obtener el IdCuenta del receptor a partir del NumeroCuenta
    SELECT IdCuenta INTO v_IdCuentaReceptor FROM CUENTAS WHERE NumeroCuenta = p_NumeroCuentaReceptor;
    
    -- Verificar si la cuenta del receptor existe
    IF v_IdCuentaReceptor IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta del receptor no existe.';
    END IF;

    -- Insertar el retiro en la tabla RETIROS
    INSERT INTO RETIROS (IdCuentaEmisor, IdCuentaReceptor, Fecha, Monto)
    VALUES (v_IdCuentaEmisor, v_IdCuentaReceptor, CURRENT_DATE(), p_Monto);

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE RealizarDeposito(
    IN p_NumeroCuentaEmisor VARCHAR(20),
    IN p_NumeroCuentaReceptor VARCHAR(20),
    IN p_Monto INT
)
BEGIN
    DECLARE v_IdCuentaEmisor INT;
    DECLARE v_IdCuentaReceptor INT;

    -- Obtener el IdCuenta del emisor a partir del NumeroCuenta
    SELECT IdCuenta INTO v_IdCuentaEmisor FROM CUENTAS WHERE NumeroCuenta = p_NumeroCuentaEmisor;
    
    -- Verificar si la cuenta del emisor existe
    IF v_IdCuentaEmisor IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta del emisor no existe.';
    END IF;

    -- Obtener el IdCuenta del receptor a partir del NumeroCuenta
    SELECT IdCuenta INTO v_IdCuentaReceptor FROM CUENTAS WHERE NumeroCuenta = p_NumeroCuentaReceptor;
    
    -- Verificar si la cuenta del receptor existe
    IF v_IdCuentaReceptor IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta del receptor no existe.';
    END IF;

    -- Insertar el depósito en la tabla DEPOSITOS
    INSERT INTO DEPOSITOS (IdCuentaEmisor, IdCuentaReceptor, Fecha, Monto)
    VALUES (v_IdCuentaEmisor, v_IdCuentaReceptor, CURRENT_DATE(), p_Monto);

END $$

DELIMITER ;




DELIMITER ;

drop procedure InsertarUsuarioConCuentaYTarjeta;

DELIMITER $$

CREATE PROCEDURE InsertarUsuarioConCuentaYTarjeta(
    IN p_Nombre VARCHAR(50),
    IN p_Apellido1 VARCHAR(50),
    IN p_Apellido2 VARCHAR(50),
    IN p_Direccion VARCHAR(150),
    IN p_Telefono VARCHAR(20),
    IN p_FechaNacimiento DATE,
    IN p_Email VARCHAR(150),
    IN p_TipoCliente VARCHAR(50),
    IN p_Cedula VARCHAR(30),
    IN p_IdMoneda INT,
    IN p_TipoCuenta VARCHAR(50),
    IN p_EstadoCuenta VARCHAR(50)
)
BEGIN
    DECLARE v_IdUsuario INT;
    DECLARE v_NumeroCuenta VARCHAR(30);
    DECLARE v_TipoCuenta CHAR(2);
    DECLARE v_TipoMoneda CHAR(2);
    DECLARE v_NumAleatorio VARCHAR(10);
    DECLARE v_NumeroTarjeta VARCHAR(16);
    DECLARE v_Pin VARCHAR(4);
    DECLARE v_IdCuenta INT;
    DECLARE v_SaldoInicial INT;
    DECLARE v_EstadoTarjeta VARCHAR(50);
    DECLARE cuentaExistente INT;
    DECLARE usuarioNuevo BOOLEAN DEFAULT FALSE;

    -- Verificar si el usuario ya existe
    SELECT IdUsuario INTO v_IdUsuario FROM USUARIOS WHERE Cedula = p_Cedula LIMIT 1;

    -- Si el usuario ya existe, verificar si tiene una cuenta del mismo tipo y moneda
    IF v_IdUsuario IS NOT NULL THEN
        SELECT COUNT(*) INTO cuentaExistente 
        FROM CUENTAS 
        WHERE IdUsuario = v_IdUsuario AND TipoCuenta = p_TipoCuenta AND IdMoneda = p_IdMoneda;
        
        -- Si ya tiene la cuenta que intenta abrir, mostrar error
        IF cuentaExistente > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario ya tiene una cuenta de este tipo y moneda';
        END IF;
    ELSE
        -- Marcar que el usuario es nuevo para insertarlo más adelante
        SET usuarioNuevo = TRUE;
    END IF;

    -- Validación del estado de cuenta
    IF p_EstadoCuenta = 'Activa' THEN
        SET v_EstadoTarjeta = 'Activa';
    ELSEIF p_EstadoCuenta = 'Inactiva' THEN
        SET v_EstadoTarjeta = 'Inactiva';
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estado de cuenta inválido';
    END IF;

    -- Validación del tipo de cuenta
    IF p_TipoCuenta = 'Ahorro' THEN
        SET v_TipoCuenta = 'AH';
    ELSEIF p_TipoCuenta = 'Corriente' THEN
        SET v_TipoCuenta = 'CO';
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de cuenta inválido';
    END IF;

    -- Validación del tipo de moneda y asignación del saldo inicial
    IF p_IdMoneda = 1 THEN
        SET v_TipoMoneda = '01';
        SET v_SaldoInicial = 10000; -- Colones
    ELSEIF p_IdMoneda = 2 THEN
        SET v_TipoMoneda = '02';
        SET v_SaldoInicial = 20; -- Dólares
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de moneda inválido';
    END IF;

    -- Generar el número aleatorio de 10 dígitos
    SET v_NumAleatorio = LPAD(FLOOR(RAND() * 10000000000), 10, '0');

    -- Construir el número de cuenta
    SET v_NumeroCuenta = CONCAT('CR', v_TipoCuenta, v_TipoMoneda, '0000', v_NumAleatorio);

    -- Asegurar que el número de cuenta sea único
    WHILE EXISTS (SELECT 1 FROM CUENTAS WHERE NumeroCuenta = v_NumeroCuenta) DO
        SET v_NumAleatorio = LPAD(FLOOR(RAND() * 10000000000), 10, '0');
        SET v_NumeroCuenta = CONCAT('CR', v_TipoCuenta, v_TipoMoneda, '0000', v_NumAleatorio);
    END WHILE;
    
    -- Si el usuario era nuevo, insertarlo en la tabla USUARIOS al final
    IF usuarioNuevo THEN
        INSERT INTO USUARIOS (Nombre, Apellido1, Apellido2, Direccion, Telefono, FechaNacimiento, Email, TipoCliente, Cedula)
        VALUES (p_Nombre, p_Apellido1, p_Apellido2, p_Direccion, p_Telefono, p_FechaNacimiento, p_Email, p_TipoCliente, p_Cedula);
        
        -- Obtener el ID del usuario recién creado y actualizar en la cuenta
        SET v_IdUsuario = LAST_INSERT_ID();
        UPDATE CUENTAS SET IdUsuario = v_IdUsuario WHERE IdCuenta = v_IdCuenta;
    END IF;
    
    
    
    -- Insertar la cuenta asociada al usuario con saldo inicial y fecha actual
    INSERT INTO CUENTAS (IdUsuario, IdMoneda, TipoCuenta, Saldo, FechaApertura, EstadoCuenta, NumeroCuenta)
    VALUES (v_IdUsuario, p_IdMoneda, p_TipoCuenta, v_SaldoInicial, CURDATE(), p_EstadoCuenta, v_NumeroCuenta);

    -- Obtener el ID de la cuenta recién creada
    SET v_IdCuenta = LAST_INSERT_ID();

    -- Generar el número de tarjeta de 16 dígitos
    SET v_NumeroTarjeta = LPAD(FLOOR(RAND() * 1000000000000000), 16, '0');

    -- Generar el PIN de 4 dígitos
    SET v_Pin = LPAD(FLOOR(RAND() * 10000), 4, '0');

    -- Insertar la tarjeta vinculada a la cuenta y al usuario con estado dependiente de la cuenta
    INSERT INTO TARJETAS (IdCuenta, EstadoTarjeta, NumeroTarjeta, Pin, FechaVencimiento)
    VALUES (v_IdCuenta, v_EstadoTarjeta, v_NumeroTarjeta, v_Pin, DATE_ADD(CURDATE(), INTERVAL 5 YEAR));

    
    
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ObtenerCuentasPorCedula(
    IN p_Cedula VARCHAR(20)
)
BEGIN
    -- Obtener las cuentas del usuario con su cédula
    SELECT 
        u.Nombre, 
        c.NumeroCuenta, 
        COALESCE(t.NumeroTarjeta, 'Sin Tarjeta') AS NumeroTarjeta, 
        c.Saldo, 
        c.TipoCuenta, 
        CASE 
            WHEN c.IdMoneda = 1 THEN 'Colones'
            WHEN c.IdMoneda = 2 THEN 'Dólares'
            ELSE 'Otra Moneda'
        END AS Moneda
    FROM CUENTAS c
    INNER JOIN USUARIOS u ON c.IdUsuario = u.IdUsuario
    LEFT JOIN TARJETAS t ON c.IdCuenta = t.IdCuenta
    WHERE u.Cedula = p_Cedula;
    
END $$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE ListarUsuarios()
BEGIN
    SELECT 
        IdUsuario, 
        Nombre, 
        Apellido1, 
        Apellido2, 
        Direccion, 
        Telefono, 
        FechaNacimiento, 
        Email, 
        TipoCliente 
    FROM USUARIOS;
END $$
DELIMITER ;

DROP PROCEDURE  InsertarCuenta;
#DELETE FROM CUENTAS WHERE IdCuenta IN (1, 2);

CALL InsertarCuenta( 3, 1, 'Ahorro', 50000, '2025-02-11', 'Activa');
SELECT*FROM CUENTAS;
SELECT*FROM TARJETAS;



DELIMITER $$
CREATE PROCEDURE InsertarRetiros(

	IN p_IdCuentaEmisor INT,
    IN p_IdCuentaReceptor INT,
    IN p_Fecha DATE,
    IN p_Monto INT
) 
BEGIN
	
INSERT INTO Retiros(IdCuentaEmisor, IdCuentaReceptor, fecha, monto)
VALUES (p_IdCuentaEmisor,p_IdCuentaReceptor, p_Fecha,p_Monto);
    
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE InsertarDepositos(

	IN p_IdCuentaEmisor INT,
    IN p_IdCuentaReceptor INT,
    IN p_Fecha DATE,
    IN p_Monto INT
) 
BEGIN
	
INSERT INTO Depositos(IdCuentaEmisor, IdCuentaReceptor, fecha, monto)
VALUES (p_IdCuentaEmisor,p_IdCuentaReceptor, p_Fecha,p_Monto);
    
END $$
DELIMITER ;

#crear usuario y dar todos los permisos
CREATE USER 'jose'@'localhost' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON DBO_BANCO.* TO 'jose'@'localhost';
SELECT user, host FROM mysql.user WHERE user = 'jose';

Select*from usuarios;

drop procedure ValidarUsuario;


DELIMITER $$

CREATE PROCEDURE ValidarUsuario(
    IN cedula_buscar VARCHAR(20),
    IN pin_ingresado VARCHAR(10)
)
BEGIN
    DECLARE id_cuenta INT;
    DECLARE pin_valido INT;

    -- Buscar el IdCuenta por la cédula del usuario
    SELECT IdUsuario INTO id_cuenta 
    FROM usuarios 
    WHERE Cedula = cedula_buscar 
    LIMIT 1;

    -- Si el usuario existe
    IF id_cuenta IS NOT NULL THEN
        -- Verificar si el PIN es correcto en la tabla tarjetas
        SELECT COUNT(*) INTO pin_valido 
        FROM tarjetas 
        WHERE IdCuenta = id_cuenta 
        AND PIN = pin_ingresado;

        -- Validar autenticación
        IF pin_valido > 0 THEN
            SELECT id_cuenta AS 'IdCuenta', 'Autenticación exitosa' AS 'Resultado';
        ELSE
            SELECT id_cuenta AS 'IdCuenta', 'PIN incorrecto' AS 'Resultado';
        END IF;
    ELSE
        -- Si la cédula no existe
        SELECT NULL AS 'IdCuenta', 'Usuario no encontrado' AS 'Resultado';
    END IF;
END $$

DELIMITER ;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM tarjetas WHERE IdCuenta = 12;
SET SQL_SAFE_UPDATES = 1;


DELIMITER $$

CREATE PROCEDURE ObtenerTarjetasPorCedula(IN p_Cedula VARCHAR(20))
BEGIN
    -- Declaramos una variable para almacenar el IdUsuario
    DECLARE v_IdUsuario INT;

    -- Primero, obtenemos el IdUsuario con la cédula
    SELECT IdUsuario INTO v_IdUsuario
    FROM Usuarios
    WHERE Cedula = p_Cedula;

    -- Ahora, con el IdUsuario obtenido, seleccionamos todas las tarjetas asociadas
    SELECT 
        u.IdUsuario, 
        t.NumeroTarjeta, 
        t.FechaVencimiento, 
        c.Saldo, 
        c.TipoCuenta, 
        c.IdMoneda,
        t.Pin,
        u.Nombre
    FROM Usuarios u
    JOIN Cuentas c ON u.IdUsuario = c.IdUsuario
    JOIN Tarjetas t ON c.IdCuenta = t.IdCuenta
    WHERE u.IdUsuario = v_IdUsuario;  -- Filtramos por el IdUsuario

END $$

DELIMITER ;

drop procedure RealizarTransferencia;



DROP PROCEDURE IF EXISTS RealizarTransferencia;

DELIMITER $$

CREATE PROCEDURE RealizarTransferencia(
    IN p_NumeroCuentaEmisor VARCHAR(20),
    IN p_NumeroCuentaReceptor VARCHAR(20),
    IN p_Monto DECIMAL(10,2),
    IN p_Detalle TEXT
)
BEGIN
    -- Declaración de variables
    DECLARE v_SaldoDisponible DECIMAL(10,2);
    DECLARE v_IdCuentaEmisor INT;
    DECLARE v_IdCuentaReceptor INT;
    DECLARE v_IdUsuarioEmisor INT;
    DECLARE v_IdUsuarioReceptor INT;
    DECLARE v_IdMonedaEmisor INT;
    DECLARE v_IdMonedaReceptor INT;
    DECLARE v_EstadoCuentaEmisor VARCHAR(20);
    DECLARE v_EstadoCuentaReceptor VARCHAR(20);


    -- Verificar si las cuentas existen y obtener datos necesarios
    SELECT IdCuenta, IdUsuario, Saldo, IdMoneda, EstadoCuenta 
    INTO v_IdCuentaEmisor, v_IdUsuarioEmisor, v_SaldoDisponible, v_IdMonedaEmisor, v_EstadoCuentaEmisor
    FROM CUENTAS WHERE NumeroCuenta = p_NumeroCuentaEmisor;

    IF v_IdCuentaEmisor IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta del emisor no existe.';
    END IF;

    SELECT IdCuenta, IdUsuario, IdMoneda, EstadoCuenta 
    INTO v_IdCuentaReceptor, v_IdUsuarioReceptor, v_IdMonedaReceptor, v_EstadoCuentaReceptor
    FROM CUENTAS WHERE NumeroCuenta = p_NumeroCuentaReceptor;

    IF v_IdCuentaReceptor IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta del receptor no existe.';
    END IF;

    -- Verificar si ambas cuentas están activas
    IF v_EstadoCuentaEmisor != 'Activa' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta del emisor está inactiva. No se puede realizar la transferencia.';
    END IF;

    IF v_EstadoCuentaReceptor != 'Activa' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cuenta del receptor está inactiva. No se puede realizar la transferencia.';
    END IF;

    -- Verificar si el saldo es suficiente
    IF v_SaldoDisponible < p_Monto THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Fondos insuficientes para la transferencia.';
    END IF;

    -- Verificar si ambas cuentas tienen la misma moneda
    IF v_IdMonedaEmisor != v_IdMonedaReceptor THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Denominación de cuentas diferentes.';
    END IF;
    
    -- Iniciar transacción
    START TRANSACTION;

    -- Restar el monto al emisor
    UPDATE CUENTAS SET Saldo = Saldo - p_Monto WHERE IdCuenta = v_IdCuentaEmisor;

    -- Sumar el monto al receptor
    UPDATE CUENTAS SET Saldo = Saldo + p_Monto WHERE IdCuenta = v_IdCuentaReceptor;

    -- Registrar la transferencia en la tabla TRANSFERENCIAS
    INSERT INTO TRANSFERENCIAS (IdCuentaEmisor, IdCuentaReceptor, Fecha, MONTO, Detalle)
    VALUES (v_IdCuentaEmisor, v_IdCuentaReceptor, CURRENT_DATE(), p_Monto, p_Detalle);

    -- Registrar en el historial del emisor (retiro)
    INSERT INTO HISTORIAL_TRANSACCIONES (IdCuenta, Monto, Fecha, Detalle, IdUsuario)
    VALUES (v_IdCuentaEmisor, -p_Monto, NOW(), p_Detalle, v_IdUsuarioEmisor);

    -- Registrar en el historial del receptor (depósito)
    INSERT INTO HISTORIAL_TRANSACCIONES (IdCuenta, Monto, Fecha, Detalle, IdUsuario)
    VALUES (v_IdCuentaReceptor, p_Monto, NOW(), p_Detalle, v_IdUsuarioReceptor);

    -- Confirmar la transacción
    COMMIT;

END $$

DELIMITER ;



drop procedure ObtenerHistorialPorCedula;



DELIMITER $$

CREATE PROCEDURE ObtenerHistorialPorCuenta(
    IN p_Cedula VARCHAR(20)
)
BEGIN
    DECLARE v_IdUsuario INT;
    DECLARE v_NumeroCuentaEmisor VARCHAR(20);

    -- Obtener el IdUsuario a partir de la cédula
    SELECT IdUsuario INTO v_IdUsuario
    FROM USUARIOS
    WHERE Cedula = p_Cedula;

    -- Verificar si el IdUsuario existe
    IF v_IdUsuario IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El usuario con esta cédula no existe.';
    END IF;

    -- Seleccionar los registros del historial para el IdUsuario, devolviendo el NumeroCuenta en lugar del IdCuenta
    SELECT  c.NumeroCuenta AS NumeroCuenta, 
            ht.Monto, 
            ht.Fecha, 
            ht.Detalle
    FROM HISTORIAL_TRANSACCIONES ht
    JOIN CUENTAS c ON c.IdCuenta = ht.IdCuenta
    WHERE c.IdUsuario = v_IdUsuario;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ObtenerDatosUsuarioPorCedula(
    IN cedula_buscar VARCHAR(20)
)
BEGIN
    -- Declaramos un cursor para almacenar los datos
    DECLARE nombre_usuario NVARCHAR(50);
    DECLARE apellido1_usuario NVARCHAR(50);
    DECLARE apellido2_usuario NVARCHAR(50);
    DECLARE direccion_usuario NVARCHAR(150);
    DECLARE telefono_usuario VARCHAR(20);
    DECLARE fecha_nacimiento_usuario DATE;
    DECLARE email_usuario NVARCHAR(150);

    -- Obtenemos los datos del usuario por la cédula
    SELECT 
        Nombre, 
        Apellido1, 
        Apellido2, 
        Direccion, 
        Telefono, 
        FechaNacimiento, 
        Email
    INTO 
        nombre_usuario, 
        apellido1_usuario, 
        apellido2_usuario, 
        direccion_usuario, 
        telefono_usuario, 
        fecha_nacimiento_usuario, 
        email_usuario
    FROM 
        usuarios 
    WHERE 
        Cedula = cedula_buscar;

    -- Si no se encuentra el usuario
    IF nombre_usuario IS NULL THEN
        SELECT NULL AS 'Resultado', 'Usuario no encontrado' AS 'Mensaje';
    ELSE
        -- Devolver los datos del usuario si se encuentra
        SELECT 
            nombre_usuario AS 'Nombre',
            apellido1_usuario AS 'Apellido1',
            apellido2_usuario AS 'Apellido2',
            direccion_usuario AS 'Direccion',
            telefono_usuario AS 'Telefono',
            fecha_nacimiento_usuario AS 'FechaNacimiento',
            email_usuario AS 'Email',
            'Usuario encontrado' AS 'Resultado';
    END IF;

END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ObtenerUltimaInsercion()
BEGIN
    -- Obtener la última inserción de la tabla CUENTAS
    SELECT IdMoneda, TipoCuenta, Saldo, FechaApertura, EstadoCuenta, NumeroCuenta
    FROM CUENTAS
    ORDER BY IdCuenta DESC
    LIMIT 1;

    -- Obtener la última inserción de la tabla TARJETAS
    SELECT EstadoTarjeta, NumeroTarjeta, Pin, FechaVencimiento
    FROM TARJETAS
    ORDER BY IdTarjeta DESC
    LIMIT 1;
END $$

DELIMITER ;

Drop procedure ActualizarUsuario;
DELIMITER //

CREATE PROCEDURE ActualizarUsuario(
    IN p_Cedula VARCHAR(15),
    IN p_Nombre VARCHAR(50),
    IN p_Apellido1 VARCHAR(50),
    IN p_Apellido2 VARCHAR(50),
    IN p_Direccion VARCHAR(150),
    IN p_Telefono VARCHAR(20),
    IN p_FechaNacimiento DATE,
    IN p_Email VARCHAR(150)
 
)
BEGIN
    -- Verificar si el usuario existe
    IF EXISTS (SELECT 1 FROM USUARIOS WHERE Cedula = p_Cedula) THEN
        -- Realizar la actualización
        UPDATE USUARIOS
        SET
            Nombre = p_Nombre,
            Apellido1 = p_Apellido1,
            Apellido2 = p_Apellido2,
            Direccion = p_Direccion,
            Telefono = p_Telefono,
            FechaNacimiento = p_FechaNacimiento,
            Email = p_Email
            
        WHERE
            Cedula = p_Cedula;

       
        SELECT 'Usuario actualizado correctamente.';
    ELSE
       
        SELECT 'Error: No existe un usuario con el ID proporcionado.';
    END IF;
END //

DELIMITER ;


###########################################################################
#Creacion de Vistas de las tablas#
###########################################################################

CREATE VIEW VistaUsuarios AS
SELECT IdUsuario, Nombre, Apellido1, Apellido2, Cedula
FROM Usuarios;
DROP VIEW  VerHistorialTransacciones;




  
SELECT * FROM tarjetas;


