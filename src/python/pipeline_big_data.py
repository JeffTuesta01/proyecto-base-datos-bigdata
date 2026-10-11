import os
import pandas as pd

def ejecutar_pipeline_big_data():
    print("=========================================================================")
    print(" INICIANDO PIPELINE DE PROCESAMIENTO DISTRIBUIDO (BIG DATA - COMPACTION)")
    print("=========================================================================")
    
    base_dir = "datalake"
    raw_dir = os.path.join(base_dir, "raw")
    curated_dir = os.path.join(base_dir, "curado")
    os.makedirs(raw_dir, exist_ok=True)
    os.makedirs(curated_dir, exist_ok=True)
    
    data_transaccional = {
        'id_cliente': [
            'CLI001', 'CLI002', 'CLI003', 'CLI004', 'CLI005', 'CLI006', 'CLI007'
        ],
        'id_sucursal': [
            101, 102, 103, 101, 104, 102, 103
        ],
        'monto_prestado': [
            5000.0, 12000.0, 25000.0, 30000.0, 8000.0, 15000.0, 45000.0
        ],
        'saldo_pendiente': [
            4200.0, 9500.0, 18000.0, 2900.0, 0.0, 14000.0, 41000.0
        ],
        'monto_mora': [
            0.0, 1500.0, 4500.0, 2900.0, 0.0, 3500.0, 12000.0
        ],
        'dias_atraso': [
            5, 22, 45, 95, 0, 65, 120
        ],
        'fecha_corte': [
            '2026-10-10', '2026-10-10', '2026-10-10', '2026-10-10', '2026-10-10', '2026-10-10', '2026-10-10'
        ]
    }
    
    df_raw = pd.DataFrame(data_transaccional)
    raw_file_path = os.path.join(raw_dir, "transacciones_credito.csv")
    df_raw.to_csv(raw_file_path, index=False)
    print(f"[INGESTA OK] Datos crudos almacenados en la zona RAW: {raw_file_path}")
    
    print("[PROCESAMIENTO] Ejecutando transformaciones complejas y particionamiento...")
    df_analitico = df_raw.copy()
    
    def clasificar_riesgo(dias):
        if dias <= 15: return 'BAJO'
        elif dias <= 30: return 'MEDIO'
        elif dias <= 90: return 'ALTO'
        else: return 'CRÍTICO'
        
    df_analitico['nivel_riesgo'] = df_analitico['dias_atraso'].apply(clasificar_riesgo)
    
    print("[ALMACENAMIENTO] Exportando datos a formato comprimido Parquet columnar...")
    df_analitico.to_parquet(curated_dir, engine='pyarrow', partition_cols=['nivel_riesgo'], index=False)
    print(f"[ALMACENAMIENTO OK] Data Lake persistido exitosamente en zona CURADO.")
    print("=========================================================================")

if __name__ == "__main__":
    ejecutar_pipeline_big_data()