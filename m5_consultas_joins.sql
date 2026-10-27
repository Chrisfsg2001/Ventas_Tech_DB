-- =============================================================================
-- Pre-entrega 5: Consultas con JOINs para el proyecto RetailPro
-- Base de datos: Ventas_Tech_DB
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: Consolidar transacciones con dimensiones descriptivas para alimentar el modelo en Power BI.
-- -----------------------------------------------------------------------------
USE Ventas_Tech_DB;
go

SELECT 
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    p.precio AS precio_unitario,
    (v.cantidad * p.precio) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- Hallazgo: Se consolidaron 50 transacciones históricas sin inconsistencias de claves foráneas; la categoría 'Computación' concentra el 58% del volumen facturado total.


-- -----------------------------------------------------------------------------
-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: Detectar clientes registrados que nunca compraron para campañas de reactivación de CRM.
-- -----------------------------------------------------------------------------
SELECT 
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: 2 de los 12 clientes registrados en la base no registran compras a la fecha; CRM debe implementar una campaña de bienvenida con cupón de primera compra.


-- -----------------------------------------------------------------------------
-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: Identificar artículos del catálogo sin rotación para evaluar descatalogación o promociones.
-- -----------------------------------------------------------------------------
SELECT 
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: Se detectó 1 producto de la categoría 'Accesorios' sin tracción de ventas; el área de Producto debe evaluar un bundle promocional antes de retirarlo del catálogo.


-- -----------------------------------------------------------------------------
-- Consulta 4: Consolidado por canal (UNION ALL con literal)
-- Propósito: Generar la dimensión analítica de canal mediante valores literales en subconsultas apiladas.
-- -----------------------------------------------------------------------------
SELECT 
    consolidado.canal,
    COUNT(consolidado.id_venta) AS cantidad_transacciones,
    SUM(consolidado.total) AS total_canal
FROM (
    -- Simulación canal Online (ejemplo: compras pares / IDs pares)
    SELECT 
        v.id_venta,
        v.fecha_venta,
        (v.cantidad * p.precio) AS total,
        'Online' AS canal
    FROM ventas v
    INNER JOIN productos p ON v.id_producto = p.id_producto
    WHERE v.id_venta % 2 = 0

    UNION ALL

    -- Simulación canal Presencial (ejemplo: compras impares / IDs impares)
    SELECT 
        v.id_venta,
        v.fecha_venta,
        (v.cantidad * p.precio) AS total,
        'Presencial' AS canal
    FROM ventas v
    INNER JOIN productos p ON v.id_producto = p.id_producto
    WHERE v.id_venta % 2 <> 0
) AS consolidado
GROUP BY consolidado.canal;

