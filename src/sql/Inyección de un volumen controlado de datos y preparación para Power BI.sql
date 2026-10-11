USE DW_CrediAvanza_Final;
GO

-- 1. LIMPIAR STAGING PARA EVITAR DUPLICADOS
TRUNCATE TABLE STG_Clientes_Origen;

-- 2. INYECTAR DATOS REALISTAS CON DIFERENTES NIVELES DE RIESGO Y SUCURSALES
INSERT INTO STG_Clientes_Origen VALUES 
('CLI001', 'Juan Perez Mendoza', 'COMERCIO', 'DNI', '45781269', 101, 'Agencia Centro Lima', 'LIMA', 'LIMA', '2026-10-10', 5000.00, 4200.00, 0.00, 5),
('CLI002', 'Maria Silva Torres', 'PRODUCCION', 'DNI', '70142536', 102, 'Agencia Norte Independencia', 'LIMA', 'INDEPENDENCIA', '2026-10-10', 12000.00, 9500.00, 1500.00, 22),
('CLI003', 'Carlos Lopez Vega', 'SERVICIOS', 'RUC', '20124578963', 103, 'Agencia Sur Arequipa', 'AREQUIPA', 'AREQUIPA', '2026-10-10', 25000.00, 18000.00, 4500.00, 45),
('CLI004', 'Ana Gomez Rios', 'COMERCIO', 'DNI', '41253698', 101, 'Agencia Centro Lima', 'LIMA', 'LIMA', '2026-10-10', 3000.00, 2900.00, 2900.00, 95),
('CLI005', 'Luis Castro Huaman', 'AGRICULTURA', 'DNI', '09562314', 104, 'Agencia Oriente Iquitos', 'LORETO', 'IQUITOS', '2026-10-10', 8000.00, 0.00, 0.00, 0),
('CLI006', 'Elena Portal Ramos', 'SERVICIOS', 'DNI', '47859612', 102, 'Agencia Norte Independencia', 'LIMA', 'INDEPENDENCIA', '2026-10-10', 15000.00, 14000.00, 3500.00, 65),
('CLI007', 'Pedro Arce Palacios', 'PRODUCCION', 'RUC', '20457812369', 103, 'Agencia Sur Arequipa', 'AREQUIPA', 'AREQUIPA', '2026-10-10', 45000.00, 41000.00, 12000.00, 120);

-- 3. EJECUTAR EL PROCESAMIENTO AUTOMÁTICO
EXEC SP_Ejecutar_ETL_CrediAvanza;
GO

-- 4. CONSULTA DE VERIFICACIÓN FINAL (Muestra las métricas integradas)
SELECT 
    H.id_prestamo,
    C.nombre_cliente,
    A.nombre_agencia AS sucursal,
    E.nivel_riesgo,
    E.estado_morosidad,
    H.monto_prestado,
    H.saldo_pendiente,
    H.monto_mora,
    H.dias_atraso_actual
FROM H_Prestamos H
INNER JOIN D_Cliente C ON H.id_cliente = C.id_cliente
INNER JOIN D_Agencia A ON H.id_sucursal = A.id_agencia
INNER JOIN D_EstadoCredito E ON H.id_estado = E.id_estado;
GO