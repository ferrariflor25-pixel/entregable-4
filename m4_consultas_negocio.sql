USE empresa;

--Resumen ejecutivo mensual--
select
month(fechaVenta) as mes,
Count(Ventas) as ventas,
sum(Cantidad * PrecioUnitario) as facturado,
sum(Cantidad* PrecioUnitario)/count(Ventas) as Ticket_promedio
From dbo.Ventas
Group by month (fechaVenta);

--Ranking de productos--
SELECT 
TOP 5 sum(Cantidad* PrecioUnitario) as facturado,
sum(Cantidad) as vendido,
ID_Productos as productos
FROM dbo.Ventas
GROUP BY ID_Productos 
ORDER BY Facturado desc;

---Clientes recurrentes--
SELECT
ID_Cliente,
COUNT (Ventas) as numerocompras,
SUM (Cantidad*PrecioUnitario) gastado
FROM dbo.Ventas
GROUP BY ID_Cliente
HAVING COUNT (Ventas)>1;

--Meses por encima/ debajo promedio--

WITH FacturacionMensual AS (
    SELECT
        MONTH(fechaVenta) AS mes,
        SUM(Cantidad * PrecioUnitario) AS facturado
    FROM dbo.Ventas
    GROUP BY MONTH(fechaVenta)
)
SELECT
    mes,
    facturado,
    CASE
        WHEN facturado > AVG(facturado) OVER ()
            THEN 'Por encima'
        WHEN facturado < AVG(facturado) OVER ()
            THEN 'Por debajo'
        ELSE 'Venta promedio'
    END AS categoria_ventas
FROM FacturacionMensual
ORDER BY mes;



---En el mes de marzo se realizaron 10 ventas y fue un mes promedio con un número de tickets de 644.4
--Los productos mas vendidos fueron producto 1, 3 y 5.   
--Los clientes recurrentes son ID 1,2 y 3 por orden del que mas gastó al que menos.  