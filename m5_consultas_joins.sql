--- Consulta 1 — Vista base del proyecto (INNER JOIN) ---
-- Propósito: Conectar las tablas que ya tengo para obtener información mas completa.

SELECT
v.Fecha_Venta
, v.ID_Cliente
, c.Nombre AS Nombre_Cliente
, c.Ciudad
, p.Nombre_Producto
, v.Precio_Unitario
, v.Cantidad
, cat.Nombre_Categoria
, cat.Descripcion
, v.Cantidad * v.Precio_Unitario AS Total_Venta
FROM Ventas AS v
INNER JOIN Clientes AS c ON v.ID_Cliente = c.ID_Cliente
INNER JOIN Productos AS p ON v.ID_Producto = p.ID_Producto
INNER JOIN Categorias AS cat ON cat.ID_Categoria = p.ID_Categoria;

--- Consulta 2 — Clientes sin ventas (LEFT JOIN) ---
-- Propósito: Detectar clientes registrados que nunca compraron, para que CRM los contacte. No hay clientes sin ventas.

SELECT 
c.Nombre
, c.Email
, c.Fecha_Registro
FROM Clientes AS c
LEFT JOIN Ventas AS v ON v.ID_Cliente = c.ID_Cliente
WHERE v.ID_Cliente IS NULL;

--- Consulta 3 — Productos sin ventas (LEFT JOIN) ---
-- Propósito: De los 10 productos registrados todos tienen ventas, no hay productos sin ventas.

SELECT 
p.Nombre_Producto
, c.Nombre_Categoria
, p.Precio
FROM Productos AS p
LEFT JOIN Ventas AS v ON v.ID_Producto = p.ID_Producto
LEFT JOIN Categorias AS c ON c.ID_Categoria = p.ID_Categoria
WHERE v.ID_Producto IS NULL;

--- Consulta 4 — Consolidado por canal (UNION ALL) ---
-- Propósito: Juntar información de diferentes orígenes en un único conjunto de datos para poder compararlos.


SELECT
    Canal,
    COUNT(*) AS cantidad_ventas,
    SUM(total) AS total_canal

FROM (
    SELECT
        Fecha_Venta,
        Cantidad * Precio_Unitario AS total,
        'Período 1' AS canal
    FROM Ventas
    WHERE Fecha_Venta BETWEEN '2024-03-05' AND '2024-03-10'

    UNION ALL

    SELECT
        Fecha_Venta,
        Cantidad * Precio_Unitario AS total,
        'Período 2' AS canal
    FROM Ventas
    WHERE Fecha_Venta BETWEEN '2024-03-11' AND '2024-03-15'

) AS consolidado

GROUP BY canal;
