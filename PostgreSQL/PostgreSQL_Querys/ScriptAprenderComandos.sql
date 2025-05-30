--Comandos SELECT FROM para seleccionar columnas de tablas especificas
SELECT*FROM "esquema"."DEPARTAMENTOS";
SELECT*FROM "esquema"."PRODUCTOS";
SELECT "NOMBRE","APELLIDO1","EDAD" FROM "esquema"."PERSONAS";
SELECT "PRODUCTO","PRECIO" FROM "esquema"."PRODUCTOS";

--Comando SELECT DISTINCT: para seleccionar valores distintos en alguna columna 
SELECT DISTINCT("NOMBRE") FROM "esquema"."PERSONAS";
SELECT DISTINCT("PRODUCTO") FROM "esquema"."PEDIDOS";

--Comando SELECT COUNT: contar elementos en una tabla
SELECT COUNT(*) FROM "esquema"."PRODUCTOS"; --Me cuenta las filas de la tabla
SELECT COUNT("CANTIDAD") FROM "esquema"."PEDIDOS";

--Comando WHERE: incluye una condicion a la seleccion de datos
SELECT*FROM "esquema"."PERSONAS";
--Por ejemplo, queremos seleccionar personas con edades mayor o igual 32.
SELECT*FROM "esquema"."PERSONAS" WHERE("EDAD">=32);
--Seleccionar de la tabla personas, las filas con el nombre Antonio
SELECT*FROM "esquema"."PERSONAS" WHERE("NOMBRE"= 'ANTONIO');
-- Con condiciones:
SELECT*FROM "esquema"."PERSONAS" WHERE("NOMBRE"= 'ANTONIO' AND "EDAD"<=30);
--Seleccion de pedidos cuyo importe sea mayor que 100 y que haya solicitado varias cantidades 
SELECT*FROM "esquema"."PEDIDOS" WHERE("IMPORTE">100 AND "CANTIDAD">1 );












