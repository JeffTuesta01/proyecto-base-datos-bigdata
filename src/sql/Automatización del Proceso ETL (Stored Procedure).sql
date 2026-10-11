USE DW_CrediAvanza_Final;
GO

CREATE OR ALTER PROCEDURE SP_Ejecutar_ETL_CrediAvanza
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Limpieza preventiva para asegurar la reproducibilidad del experimento (Requisito ABET)
    TRUNCATE TABLE H_Prestamos;
    DELETE FROM D_Cliente; 
    DELETE FROM D_Agencia; 
    DELETE FROM D_Tiempo;

    -- 2. Poblado automático de la dimensión fija de Riesgo (Regla de Negocio de la Financiera)
    DELETE FROM D_EstadoCredito;
    INSERT INTO D_EstadoCredito (id_estado, nivel_riesgo, estado_morosidad) VALUES
    (1, 'BAJO', 'VIGENTE'), 
    (2, 'MEDIO', 'MOROSO'), 
    (3, 'ALTO', 'MOROSO'), 
    (4, 'CRÍTICO', 'MOROSO');

    -- 3. Extracción, Limpieza y Carga (ETL) de la Dimensión Cliente
    INSERT INTO D_Cliente (id_cliente, nombre_cliente, sector_economico, tipo_documento)
    SELECT DISTINCT 
        LTRIM(RTRIM(id_cliente)), 
        STATUS = LTRIM(RTRIM(nombre_cliente)), 
        LTRIM(RTRIM(sector_economico)), 
        LTRIM(RTRIM(tipo_documento))
    FROM STG_Clientes_Origen 
    WHERE id_cliente IS NOT NULL;

    -- 4. Extracción, Limpieza y Carga (ETL) de la Dimensión Agencia
    INSERT INTO D_Agencia (id_agencia, nombre_agencia, departamento, ciudad)
    SELECT DISTINCT 
        id_agencia, 
        LTRIM(RTRIM(nombre_agencia)), 
        LTRIM(RTRIM(departamento)), 
        LTRIM(RTRIM(ciudad))
    FROM STG_Clientes_Origen 
    WHERE id_agencia IS NOT NULL;

    -- 5. Extracción, Limpieza y Carga (ETL) de la Dimensión Tiempo
    INSERT INTO D_Tiempo (id_tiempo, mes, [año])
    SELECT DISTINCT 
        FORMAT(fecha_corte, 'yyyyMM'), 
        MONTH(fecha_corte), 
        YEAR(fecha_corte)
    FROM STG_Clientes_Origen 
    WHERE fecha_corte IS NOT NULL;

    -- 6. Carga de la Tabla de Hechos aplicando las Reglas de Negocio Automatizadas
    INSERT INTO H_Prestamos (id_cliente, id_sucursal, id_estado, id_tiempo, monto_prestado, saldo_pendiente, monto_mora, dias_atraso_actual)
    SELECT 
        LTRIM(RTRIM(id_cliente)), 
        id_agencia, -- Mapea id_agencia de origen al campo id_sucursal de tu estrella
        CASE 
            WHEN dias_atraso <= 15 THEN 1 
            WHEN dias_atraso <= 30 THEN 2 
            WHEN dias_atraso <= 90 THEN 3 
            ELSE 4 
        END,
        FORMAT(fecha_corte, 'yyyyMM'), 
        ISNULL(monto_prestado, 0), 
        ISNULL(saldo_pendiente, 0), 
        ISNULL(monto_mora, 0), 
        ISNULL(dias_atraso, 0)
    FROM STG_Clientes_Origen;

    PRINT '¡Proceso ETL completado con éxito total calzando con el diagrama!';
END;
GO

-- Compilar el SP en el servidor
EXEC SP_Ejecutar_ETL_CrediAvanza;