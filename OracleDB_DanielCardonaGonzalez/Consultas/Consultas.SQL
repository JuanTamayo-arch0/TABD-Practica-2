--consulta 1

SELECT 
    c.descripcion AS ciudad,
    MIN(p.duracion) AS duracion_minima,
    ROUND(AVG(p.duracion),2) AS duracion_promedio,
    MAX(p.duracion) AS duracion_maxima
FROM Procesos p
JOIN Entidades e ON e.nit_entidad = p.nit_entidad
JOIN Ciudades c ON c.id = e.ciudad_id
GROUP BY c.descripcion
ORDER BY c.descripcion;


-- consulta 2

WITH procesos_mes AS (
    SELECT 
        TO_CHAR(TO_DATE(p.fecha, 'YYYY-MM-DD'), 'YYYY-MM') AS anio_mes,
        m.descripcion AS modalidad,
        t.descripcion AS tipo_contrato,
        p.precio_base
    FROM Procesos p
    JOIN Modalidades_contratos m ON m.id = p.id_modalidad
    JOIN Tipos_contratos t ON t.id = p.id_tipo_contrato
),
conteos_modalidad AS (
    SELECT 
        anio_mes,
        modalidad,
        COUNT(*) AS cnt,
        RANK() OVER (PARTITION BY anio_mes ORDER BY COUNT(*) DESC) AS rnk
    FROM procesos_mes
    GROUP BY anio_mes, modalidad
),
conteos_tipo AS (
    SELECT 
        anio_mes,
        tipo_contrato,
        COUNT(*) AS cnt,
        RANK() OVER (PARTITION BY anio_mes ORDER BY COUNT(*) DESC) AS rnk
    FROM procesos_mes
    GROUP BY anio_mes, tipo_contrato
),
estadisticas AS (
    SELECT 
        anio_mes,
        COUNT(*) AS total_procesos,
        MIN(precio_base) AS precio_minimo,
        MAX(precio_base) AS precio_maximo,
        ROUND(AVG(precio_base),2) AS precio_promedio
    FROM procesos_mes
    GROUP BY anio_mes
)
SELECT 
    e.anio_mes,
    e.total_procesos,
    cm.modalidad AS modalidad_mas_recurrente,
    ct.tipo_contrato AS tipo_contrato_mas_recurrente,
    e.precio_minimo,
    e.precio_maximo,
    e.precio_promedio
FROM estadisticas e
LEFT JOIN conteos_modalidad cm 
    ON cm.anio_mes = e.anio_mes AND cm.rnk = 1
LEFT JOIN conteos_tipo ct 
    ON ct.anio_mes = e.anio_mes AND ct.rnk = 1
ORDER BY e.anio_mes;
