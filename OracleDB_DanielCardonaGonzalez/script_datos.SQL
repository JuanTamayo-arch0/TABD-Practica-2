--------------------------------------------------------------------------------
-- 1. Poblar Ciudades (usando MERGE para evitar duplicados)
--------------------------------------------------------------------------------
MERGE INTO Ciudades c
USING (
    SELECT DISTINCT TRIM(ciudad_entidad) as descripcion
    FROM esquema_sin_corregir
    WHERE ciudad_entidad IS NOT NULL
) src
ON (c.descripcion = src.descripcion)
WHEN NOT MATCHED THEN
    INSERT (descripcion) VALUES (src.descripcion);

--------------------------------------------------------------------------------
-- 2. Poblar Ordenes
--------------------------------------------------------------------------------
MERGE INTO Ordenes o
USING (
    SELECT DISTINCT TRIM(orden_entidad) as descripcion
    FROM esquema_sin_corregir
    WHERE orden_entidad IS NOT NULL
) src
ON (o.descripcion = src.descripcion)
WHEN NOT MATCHED THEN
    INSERT (descripcion) VALUES (src.descripcion);

--------------------------------------------------------------------------------
-- 3. Poblar Modalidades de Contratación
--------------------------------------------------------------------------------
MERGE INTO Modalidades_contratos m
USING (
    SELECT DISTINCT TRIM(modalidad_contratacion) as descripcion
    FROM esquema_sin_corregir
    WHERE modalidad_contratacion IS NOT NULL
) src
ON (m.descripcion = src.descripcion)
WHEN NOT MATCHED THEN
    INSERT (descripcion) VALUES (src.descripcion);

--------------------------------------------------------------------------------
-- 4. Poblar Tipos de Contrato
--------------------------------------------------------------------------------
MERGE INTO Tipos_contratos t
USING (
    SELECT DISTINCT TRIM(tipo_contrato) as descripcion
    FROM esquema_sin_corregir
    WHERE tipo_contrato IS NOT NULL
) src
ON (t.descripcion = src.descripcion)
WHEN NOT MATCHED THEN
    INSERT (descripcion) VALUES (src.descripcion);

--------------------------------------------------------------------------------
-- 5. Poblar Entidades (CORREGIDO - sin duplicados de NIT)
--------------------------------------------------------------------------------
MERGE INTO Entidades e
USING (
    SELECT 
        TO_NUMBER(nit_entidad) AS nit_entidad,
        MAX(ciudad_id) AS ciudad_id,
        MAX(orden_id) AS orden_id,
        MAX(centralizada) AS centralizada
    FROM (
        SELECT DISTINCT
            s.nit_entidad,
            c.id AS ciudad_id,
            o.id AS orden_id,
            CASE
                WHEN LOWER(TRIM(s.entidad_centralizada)) LIKE 'centralizada%' THEN 'S'
                WHEN LOWER(TRIM(s.entidad_centralizada)) LIKE 'descentralizada%' THEN 'N'
                ELSE NULL
            END AS centralizada
        FROM esquema_sin_corregir s
        JOIN Ciudades c ON c.descripcion = TRIM(s.ciudad_entidad)
        JOIN Ordenes o ON o.descripcion = TRIM(s.orden_entidad)
        WHERE s.nit_entidad IS NOT NULL
    )
    GROUP BY TO_NUMBER(nit_entidad)
) src
ON (e.nit_entidad = src.nit_entidad)
WHEN NOT MATCHED THEN
    INSERT (nit_entidad, ciudad_id, orden_id, centralizada)
    VALUES (src.nit_entidad, src.ciudad_id, src.orden_id, src.centralizada);

--------------------------------------------------------------------------------
-- 6. Poblar Procesos (únicos por id_proceso, con duración en días)
--------------------------------------------------------------------------------
INSERT INTO Procesos (id, fecha, precio_base, id_modalidad, duracion,
                      id_tipo_contrato, nit_entidad)
SELECT 
    id_proceso,
    TO_DATE(fecha_proceso, 'MM/DD/YYYY'),   -- Ajusta el formato según tus datos
    TO_NUMBER(REPLACE(precio_base, ',', '')),
    m.id,
    CASE
        WHEN LOWER(unidad_duracion) LIKE '%mes%'    THEN TO_NUMBER(REPLACE(duracion, ',', '')) * 30
        WHEN LOWER(unidad_duracion) LIKE '%año%'    THEN TO_NUMBER(REPLACE(duracion, ',', '')) * 365
        WHEN LOWER(unidad_duracion) LIKE '%semana%' THEN TO_NUMBER(REPLACE(duracion, ',', '')) * 7
        ELSE TO_NUMBER(REPLACE(duracion, ',', ''))
    END AS duracion_dias,
    t.id,
    TO_NUMBER(s.nit_entidad)
FROM (
    SELECT DISTINCT 
        id_proceso, 
        fecha_proceso, 
        precio_base, 
        modalidad_contratacion,
        duracion, 
        unidad_duracion, 
        tipo_contrato, 
        nit_entidad
    FROM esquema_sin_corregir
) s
JOIN Modalidades_contratos m ON m.descripcion = TRIM(s.modalidad_contratacion)
JOIN Tipos_contratos t ON t.descripcion = TRIM(s.tipo_contrato);