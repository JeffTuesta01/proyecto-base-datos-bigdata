# Ecosistema Analítico Híbrido para la Gestión de Morosidad - Financiera CrediAvanza 🚀

Este repositorio contiene los artefactos de software, scripts de automatización relacional e infraestructura analítica en lote desarrollados para optimizar la evaluación del riesgo crediticio y mitigar los cuellos de botella en la consolidación de información financiera en la **Financiera CrediAvanza**. El proyecto está estructurado bajo los lineamientos internacionales de acreditación **ABET EAC Student Outcome 6**.

## 📊 Arquitectura del Sistema
El ecosistema implementa un diseño híbrido standalone compuesto por dos capas críticas de ingeniería:
1. **Capa Relacional (BI):** Data Warehouse estructurado bajo un modelo dimensional en estrella optimizado en SQL Server, automatizado mediante Stored Procedures ETL en T-SQL y expuesto en un Dashboard interactivo en Power BI Desktop.
2. **Capa Big Data (Almacenamiento Columnar):** Pipeline analítico programado en Python vectorizado en memoria RAM mediante el motor de alta densidad **PyArrow**, persistiendo y compactando la información en archivos binarios estructurados **Parquet** bajo criterios de particionamiento físico.

## 📁 Estructura del Repositorio
```text
├── data/
│   └── datalake_experimento/      # Almacenamiento Big Data (Data Lake Standalone)
│       ├── raw/                   # Zona Cruda: Dataset original y de control (CSV)
│       │   └── transacciones_credito.csv
│       └── curado/                # Zona Optimizada: Bloques Parquet particionados por riesgo
│           ├── nivel_riesgo=ALTO/
│           ├── nivel_riesgo=BAJO/
│           ├── nivel_riesgo=CRÍTICO/
│           └── nivel_riesgo=MEDIO/
├── docs/                          # Capa de documentación técnica de presentación
│   └── dashboard_crediavanza.pbix.txt # Bitácora de empaquetado del cuadro de mando
├── src/                           # Código fuente del ecosistema híbrido
│   ├── python/                    # Capa analítica masiva y pipelines en memoria
│   │   ├── 04_experimento_masivo_1m.py
│   │   └── pipeline_big_data.py
│   └── sql/                       # Capa relacional y automatización ETL dimensional
│       ├── Automatización del Proceso ETL (Stored Procedure).sql
│       ├── Creación de Objetos y Estructura Física (DDL).sql
│       └── Inyección de un volumen controlado de datos... .sql
└── README.md                      # Manual técnico de despliegue y auditoría ABET
```

## 🛠️ Instrucciones de Despliegue y Ejecución

### 1. Despliegue de la Capa de Inteligencia de Negocios (SQL Server)
Ejecutar los scripts de la ruta `src/sql/` en la instancia local de SQL Server Management Studio (SSMS) en el siguiente orden secuencial:
```sql
-- Compilar estructuras físicas, índices y llaves foráneas
:r ./01_ddl_estructura_dw.sql

-- Compilar motor de transformación analítica y reglas de negocio
:r ./02_etl_automatizacion_sp.sql

-- Ejecutar el pipeline de carga atómica del lote testigo
EXEC SP_Ejecutar_ETL_CrediAvanza;
```

### 2. Ejecución del Pipeline de Big Data y Estrés Experimental (Python)
Garantizar la instalación previa de las dependencias base en el entorno standalone corporativo:
```bash
pip install pandas numpy pyarrow sqlalchemy mysql-connector-python
```
Ejecutar el script analítico de alta densidad vectorizada para procesar la prueba de estrés masiva:
```bash
python ./src/python/04_experimento_masivo_1m.py
```

## 📈 Resultados Experimentales Consolidados (Métricas ABET SO6)
El diseño experimental de estrés masivo evaluó de forma controlada el comportamiento de la infraestructura bajo un muestreo estadístico de 5 repeticiones consecutivas por escala operativa:

* **Dataset de Entrada (Carga Masiva):** 1,000,000 de registros transaccionales financieros.
* **Latencia de Ingesta en Memoria:** 1.0038 segundos.
* **Velocidad de Transferencia (Throughput):** **181,980.96 registros / segundo**.
* **Tiempo de Serialización y Persistencia:** 0.7850 segundos (Compresión Parquet Columnar).
* **Variabilidad Operativa:** Desviación estándar controlada de $\pm$ 0.12 segundos.

## ⚖️ Declaración de Autoría e Integridad Académica
Este ecosistema analítico, sus códigos fuentes, tableros de control y documentación técnica adjunta constituyen un producto de software original de desarrollo académico exclusivo.

* **Autor Principal / Líder de Repositorio:** TUESTA MALPARTIDA, Jefferson P. (Ingeniería de Sistemas Computacionales - UPN).
