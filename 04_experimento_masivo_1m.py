import os
import time
import numpy as np
import pandas as pd

def pipeline_experimento_masivo():
    print("=========================================================================")
    print("        INICIANDO EXPERIMENTO DE ESTRÉS DE BIG DATA (1,000,000 REG)      ")
    print("=========================================================================")
    
    # 1. Configuración de carpetas exclusivas para el hito experimental
    base_dir = "datalake_experimento"
    raw_dir = os.path.join(base_dir, "raw")
    curated_dir = os.path.join(base_dir, "curado")
    os.makedirs(raw_dir, exist_ok=True)
    os.makedirs(curated_dir, exist_ok=True)
    
    # 2. Generación matemática real de 1 millón de registros sintéticos (Semilla fija 42)
    print("[SIMULACIÓN] Generando 1,000,000 de filas financieras en memoria...")
    np.random.seed(42)
    n_registros = 1000000
    
    start_time = time.time()
    
    data = {
        'id_cliente': [f"CLI{i:07d}" for i in range(1, n_registros + 1)],
        'id_sucursal': np.random.choice([101, 102, 103, 104], size=n_registros),
        'monto_prestado': np.round(np.random.uniform(1000, 50000, size=n_registros), 2),
        'dias_atraso': np.random.randint(0, 150, size=n_registros),
        'fecha_corte': ['2026-10-10'] * n_registros
    }
    
    df_raw = pd.DataFrame(data)
    # Deducción matemática de saldos y moras reales para el estrés
    df_raw['saldo_pendiente'] = np.round(df_raw['monto_prestado'] * np.random.uniform(0.1, 0.9, size=n_registros), 2)
    df_raw['monto_mora'] = np.where(df_raw['dias_atraso'] > 0, np.round(df_raw['saldo_pendiente'] * 0.2, 2), 0.0)
    
    generation_time = time.time() - start_time
    print(f"[INGESTA OK] 1M de registros creados en memoria en {generation_time:.2f} segundos.")
    
    # Escribir el archivo masivo crudo en el disco
    csv_path = os.path.join(raw_dir, "dataset_masivo_credito.csv")
    print("[ALMACENAMIENTO] Escribiendo CSV crudo en disco (Zona RAW)...")
    df_raw.to_csv(csv_path, index=False)
    
    # 3. Procesamiento analítico masivo y transformación columnar (Big Data Compaction)
    print("\n[PROCESAMIENTO] Aplicando reglas de negocio y transformaciones...")
    start_process = time.time()
    
    # Clasificación paralela por vectores de rendimiento
    df_raw['nivel_riesgo'] = np.select(
        [df_raw['dias_atraso'] <= 15, df_raw['dias_atraso'] <= 30, df_raw['dias_atraso'] <= 90],
        ['BAJO', 'MEDIO', 'ALTO'],
        default='CRÍTICO'
    )
    
    print("[ALMACENAMIENTO] Exportando a formato optimizado Parquet particionado (Zona CURADO)...")
    df_raw.to_parquet(curated_dir, engine='pyarrow', partition_cols=['nivel_riesgo'], index=False)
    
    process_time = time.time() - start_process
    total_time = time.time() - start_time
    throughput = n_registros / total_time
    
    print("\n=========================================================================")
    print("                      MÉTRICAS REALES OBTENIDAS                          ")
    print("=========================================================================")
    print(f"-> Registros Totales Procesados : {n_registros:,} filas")
    print(f"-> Tiempo de Ingesta y Carga    : {generation_time:.4f} segundos")
    print(f"-> Tiempo de Transformación/Writ : {process_time:.4f} segundos")
    print(f"-> Tiempo Total de Ejecución     : {total_time:.4f} segundos")
    print(f"-> Rendimiento del Pipeline      : {throughput:.2f} registros/segundo")
    print("=========================================================================")

if __name__ == "__main__":
    pipeline_experimento_masivo()