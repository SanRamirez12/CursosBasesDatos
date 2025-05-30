--Clase 6:

--Cambio de base de datos
USE RentaCarUlat
GO

--Consulta de  tabla completa
SELECT*FROM Cliente;
SELECT*FROM Marca;
SELECT*FROM Vehiculo;
SELECT*FROM Sucursal;
SELECT*FROM Empleado;
SELECT*FROM Alquiler;
GO
--Consulta de campos específicos de una tabla:
SELECT NombreCliente, Ape1Cliente,Ape2Cliente,DireccionCliente FROM Cliente
GO
SELECT Marca, PaisOrigen FROM Marca
GO
SELECT ModeloVehiculo, PlacaVehiculo, MontoAlqDia FROM Vehiculo
GO
SELECT NombreSucursal FROM Sucursal
GO
SELECT NombreEmpleado, Ape1Empleado, TelefonoEmpleado FROM Empleado 
GO
SELECT IDCliente, FechaInicio, Total FROM Alquiler
GO

--Consulta filtrada por un campo 
SELECT*FROM Cliente WHERE IDCliente=1 GO
SELECT*FROM Cliente WHERE CedulaCliente='1-1111-1112' GO
SELECT*FROM Marca WHERE Marca='Toyota' GO
SELECT*FROM Vehiculo WHERE PlacaVehiculo='FGT123' GO

--Consulta sin repetir valores:
SELECT DISTINCT MontoAlqDia FROM Vehiculo GO

--Consulta con uso de alias
SELECT *FROM Vehiculo GO -- Version Normal

SELECT IDVehiculo AS 'ID', ModeloVehiculo AS 'Modelo vehículo', PlacaVehiculo AS 'Placa vehículo', MontoAlqDia AS 'Monto de alquiler diario'
FROM Vehiculo GO-- Version con Alias

--Version Normal
SELECT*FROM Cliente

--Version con alias:
SELECT CedulaCliente AS 'Número de Cédula', NombreCliente AS 'Nombre del cliente', Ape1Cliente AS 'Primer apellido', Ape2Cliente AS 'Segundo apellido'
FROM Cliente GO


--Consulta con ordenamiento ascendente:
SELECT*FROM Vehiculo ORDER BY ModeloVehiculo ASC 
GO
SELECT*FROM Vehiculo ORDER BY MontoAlqDia DESC
GO

--Consulta de tablas relacionadas con uso de join:
SELECT Suc.NombreSucursal AS 'Nombre de la Sucursal', Emp.NombreEmpleado AS 'Nombre del empleado',Emp.Ape1Empleado AS 'Apellido del empleado'
FROM Sucursal AS Suc  JOIN Empleado AS Emp 
ON Suc.IDSucursal = Emp.IDSucursal

-----------EJERCICIO DE CLASE------------------
--Consulta de nombre de cliente, apellidos, total de alquiler:
SELECT cli.NombreCliente AS 'Nombre Cliente', cli.Ape1Cliente AS 'Apellido del cliente', Alq.Total AS 'Total de alquiler'
FROM Cliente AS cli JOIN Alquiler AS  Alq 
ON  cli.IDCliente = Alq.IDCliente

--Consulta de marca, país de origen, modelo y año de los vehículos
SELECT ma.Marca, ma.PaisOrigen AS 'País de origen', ve.ModeloVehiculo AS 'Modelo Vehículo', Ve.AnioVehiculo AS 'Año del vehículo'
FROM Marca AS Ma JOIN Vehiculo AS Ve 
ON Ma.IDMarca = ve.IDMarca

--Consulta modelo, placa, fecha inicio y fecha fin de vehículos alquilados
SELECT ve.ModeloVehiculo AS 'Modelo del Vehículo', ve.PlacaVehiculo AS 'Placa del Vehículo', Al.FechaInicio AS 'Fecha de inicio de alquiler', Al.FechaFinaliza AS 'Fecha de fin de alquiler'
FROM Vehiculo AS ve JOIN Alquiler AS Al 
ON ve.IDVehiculo = Al.IDVehiculo
