-- ============================================================
-- PRE-ENTREGA MÓDULO 5: Consultas con JOINs y Combinaciones
-- Proyecto: RetailPro / Ventas_Tech_DB
-- Archivo: m5_consultas_joins.sql
-- ============================================================

USE Ventas_Tech_DB;
GO


SELECT 
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email AS email_cliente,
    c.ciudad AS ciudad_cliente,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;




SELECT 
    c.id_cliente,
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;




SELECT 
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;




SELECT 
    canal,
    SUM(total) AS total_canal
FROM (
   
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Online' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL


    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY canal;

