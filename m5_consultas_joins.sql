-- Pre Entrega nº 5
USE TechStore_Clase5

-- Consulta 1 — Vista base del proyecto (INNER JOIN)
SELECT
     v.id_venta,
     v.fecha_venta,
     c.nombre AS cliente,
     c.ciudad,
     p.nombre_producto AS producto,
     cat.nombre_categoria AS categoria,
     v.cantidad,
     v.precio_unitario,
     v.cantidad * v.precio_unitario AS total
     FROM ventas v
INNER JOIN clientes  c   ON v.id_cliente = c.id_cliente
INNER JOIN productos  p  ON v.id_producto = p.id_producto
INNER JOIN categorias  cat  ON p.id_categoria = cat.id_categoria
ORDER BY v.id_venta;
-- Hallazgos: 25 de las ventas se dieron en el año 2026 mientras que solo 1 se realizò a fines del año 2025

-- Consulta 2 — Clientes sin ventas (LEFT JOIN)
SELECT
     c.nombre,
     c.email,
     c.fecha_registro
     FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;
-- Hallazgo: 1 solo cliente de los registrados, a la fecha, no realizò ninguna compra. Esto implica que se registró y posiblemente en breve realizará una compra

-- Consulta 3 — Productos sin ventas (LEFT JOIN)
SELECT
     p.nombre_producto,
     p.precio,
     cat.nombre_categoria AS categoria
     FROM productos p
LEFT JOIN ventas v ON p.id_producto = v.id_producto
LEFT JOIN categorias cat ON p.id_categoria = cat.id_categoria
WHERE v.id_venta IS NULL;
-- Hallazgo: Solamente el Disco SSD 1TB, de la categoria computacion, no se vendio a la fecha. Esto implica que se deba realizar alguna promocion para asi mostrarlo mas y poder venderlo

-- Consulta 4 — Consolidado por canal (UNION ALL)
WITH por_canal AS (
SELECT 
      fecha_venta,
      cantidad * precio_unitario AS total,
      'cliente' AS canal
FROM ventas
WHERE id_cliente IS NOT NULL

UNION ALL

SELECT 
      fecha_venta,
      cantidad * precio_unitario,
      'Online'
FROM ventas
WHERE id_cliente IS NULL
)

SELECT 
      canal,
      COUNT (*) AS ventas,
      SUM(total) AS facturado
FROM por_canal
GROUP BY canal;
-- Hallazgos: Casi el 93% de las ventas se realizaron por el canal (cliente) contando con sus datos; y solo un 7% de forma Online sin registrar