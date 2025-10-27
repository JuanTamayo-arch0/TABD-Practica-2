-- =====================================================================================================================
-- SISTEMA DE GESTIÓN DE CONTRATACIÓN PÚBLICA - SECOP: CONSULTAS ANALÍTICAS
-- =====================================================================================================================
--
-- PROYECTO:    Consultas Analíticas para Sistema SECOP
-- AUTOR:       Juan Jose Tamayo Ospina
-- ID:          000193632
-- UNIVERSIDAD: Universidad Pontificia Bolivariana
-- FECHA:       Agosto 2025
-- VERSION:     1.0
--
-- DESCRIPCIÓN:
-- Este script implementa consultas analíticas optimizadas para el análisis de datos de 
-- contratación pública del sistema SECOP. Incluye consultas estadísticas, índices de 
-- optimización y vistas materializadas para mejorar el rendimiento.
--
-- CARACTERÍSTICAS:
-- - Consultas optimizadas con índices específicos
-- - Uso de CTEs (Common Table Expressions) para mejor legibilidad
-- - Vistas materializadas para consultas recurrentes
-- - Funciones de ventana para análisis estadísticos
-- - Optimización de costos de ejecución
--
-- DEPENDENCIAS:
-- - Requiere ejecución previa del script Scripts_Implementacion_DB_Corregido.sql
-- - Base de datos: secop_db
-- - Esquemas: inicial, corregido
--
-- =====================================================================================================================

-- =====================================================================================================================
-- SECCIÓN 1: CONSULTAS ANALÍTICAS PRINCIPALES
-- =====================================================================================================================
--
-- Esta sección contiene las consultas principales para análisis de datos de contratación pública,
-- incluyendo estadísticas descriptivas, análisis temporales y agregaciones por diferentes 
-- dimensiones del negocio.
-- =====================================================================================================================

-- ---------------------------------------------------------------------------------------------------------------------
-- CONSULTA 1: Análisis de Duración de Contratos por Ciudad
-- PROPÓSITO: Proporciona estadísticas descriptivas de duración de contratos agrupadas por ciudad
-- MÉTRICAS: Duración mínima, promedio y máxima en días por ciudad
-- OPTIMIZACIÓN: Utiliza índices compuestos para mejorar rendimiento de JOINs
-- ---------------------------------------------------------------------------------------------------------------------

SELECT
    c.descripcion AS ciudad,
    MIN(p.duracion) AS duracion_minima,
    ROUND(AVG(p.duracion)::numeric, 2) AS duracion_promedio,
    MAX(p.duracion) AS duracion_maxima
FROM corregido.Procesos p
         JOIN corregido.Entidades e ON e.nit_entidad = p.nit_entidad
         JOIN corregido.Ciudades c ON c.id = e.ciudad_id
GROUP BY c.descripcion
ORDER BY c.descripcion;


-- ---------------------------------------------------------------------------------------------------------------------
-- Optimización De la consulta con indices
-- ---------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------
-- ÍNDICE 1
-- ---------------------------------------------------------------------------------------------------------------------

CREATE INDEX idx_entidades_nit_ciudad ON corregido.Entidades(nit_entidad, ciudad_id); 

-- ---------------------------------------------------------------------------------------------------------------------
-- ÍNDICE 2
-- ---------------------------------------------------------------------------------------------------------------------

CREATE INDEX idx_procesos_nit_duracion ON corregido.Procesos(nit_entidad, duracion); 


-- ---------------------------------------------------------------------------------------------------------------------
-- CONSULTA 2: Estadísticas Mensuales de Contratación Pública
-- PROPÓSITO: Análisis completo por mes con modalidades y tipos más recurrentes
-- CARACTERÍSTICAS: Utiliza CTEs, funciones de ventana y agregaciones complejas
-- OPTIMIZACIÓN: Diseñada para ser convertida en vista materializada
-- ---------------------------------------------------------------------------------------------------------------------

WITH procesos_mes AS (
    SELECT
        TO_CHAR(p.fecha, 'YYYY-MM') AS anio_mes,
        m.descripcion AS modalidad,
        t.descripcion AS tipo_contrato,
        p.precio_base
    FROM corregido.Procesos p
             JOIN corregido.Modalidades_contratos m ON m.id = p.id_modalidad
             JOIN corregido.Tipos_contratos t ON t.id = p.id_tipo_contrato
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
             ROUND(AVG(precio_base)::numeric,2) AS precio_promedio
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

-- ---------------------------------------------------------------------------------------------------------------------
-- Optimización De la consulta con vista materializada
-- ---------------------------------------------------------------------------------------------------------------------

CREATE MATERIALIZED VIEW mv_estadisticas_mensuales AS 
WITH procesos_mes AS ( 
    SELECT 
        TO_CHAR(p.fecha, 'YYYY-MM') AS anio_mes, 
        m.descripcion AS modalidad, 
        t.descripcion AS tipo_contrato, 
        p.precio_base 
    FROM corregido.Procesos p 
             JOIN corregido.Modalidades_contratos m ON m.id = p.id_modalidad 
             JOIN corregido.Tipos_contratos t ON t.id = p.id_tipo_contrato 
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
             ROUND(AVG(precio_base)::numeric,2) AS precio_promedio 
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

SELECT * FROM mv_estadisticas_mensuales 
ORDER BY anio_mes; 

-- =====================================================================================================================
-- FIN DEL SCRIPT DE CONSULTAS ANALÍTICAS
-- =====================================================================================================================
