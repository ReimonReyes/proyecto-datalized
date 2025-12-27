# Postulación-Datalized — Panel de participación cultural (ENPC 2017 vs ENPCCL 2024) v/s oferta

## 1. Pregunta del panel
¿Qué comunas presentan mayores brechas de participación en **cine** y **música en vivo** (últimos 12 meses), y cómo se relaciona con **pago vs gratuidad**, para orientar programación y mediación de una institución cultural? ¿existen regiones con mayor brecha de oferta y demanda?

## 2. Contexto (cliente ficticio)
Una institución cultural municipal necesita priorizar comunas y segmentos para aumentar participación presencial y diseñar estrategias de acceso (precio/gratuidad) antes de la implementación del Pase Cultural.

## 3. Fuentes de datos (públicas)
- ENPC 2017 (base + diccionario + metodología)
- ENPCCL 2024 (base + diccionario + metodología)
- Encuesta de Espectáculos Públicos: Tabulados regionales INE / ECIA (para contraste regional oferta/mercado)

> Nota: este repo no incluye microdatos por tamaño/licencia; incluye scripts y pasos para reproducir.

## 4. Proceso 
## Proceso de limpieza y transformación (reproducible)

### 1) Carga local a PostgreSQL (staging)
Los microdatos se procesan localmente (PostgreSQL + pgAdmin) para asegurar reproducibilidad y separar:
- **staging (raw texto)**: ingesta sin fallos por tipos de datos
- **tabla limpia (tipada)**: conversión a tipos numéricos para análisis

**Motivo**: durante la importación se detectaron campos con valores vacíos/espacios en variables numéricas (p. ej. `d7_3`), lo que provoca errores al cargar directo a columnas `integer`. Se resuelve con un staging `TEXT` y posterior limpieza (`TRIM + NULLIF`) antes del casteo.

### 2) Limpieza (casting seguro)
Se aplica:
- `TRIM()` para eliminar espacios
- `NULLIF(x,'')` para transformar vacío en `NULL`
- cast a `INT` solo después de normalizar

Resultado: tabla `raw_enpcc_2017` tipada y estable para crear vistas analíticas.
### Vistas analíticas
Se crean dos vistas:

- `vw_participacion_long`: estandariza 2017/2024 a un formato común (cine y música en vivo) con variables binarias (0/1) y campos de pago/tramo cuando existen.
- `vw_kpis_comuna`: agrega la información por comuna-año-disciplina y calcula KPIs (porcentajes) listos para el dashboard.

> Nota: las vistas no exportan archivos; se consultan directamente desde Power BI conectando a PostgreSQL.


3) Construcción de métricas (KPIs)


4) Dashboard publicado (Power BI)
## SQL / Estructura del repositorio

- `/sql/01_staging_2017.sql`: crea tabla `raw_enpcc_2017_txt` (todo TEXT).
- `/sql/02_clean_2017.sql`: crea `raw_enpcc_2017` desde staging con limpieza y casteo.
- `/sql/03_views.sql`: crea vistas analíticas para el dashboard (tabla larga + KPIs).

## 5. Decisiones de diseño del dashboard
- 4 páginas: Resumen, Brechas comunales, Pago/Gratuidad y Precios, Contraste regional (opcional)
- Se evita inferir causalidad: análisis descriptivo

## 6. Limitaciones
- no uso de ponderadores (factores de expansión)
- Comparabilidad 2017–2024: puede haber cambios de formulación o factores exógenos
- Tabulados INE/ECIA son regionales; no se mezclan con nivel comunal; mientras que ENPCC sí es comunal

## 7. Cómo reproducir
## Cómo reproducir (local)

1. Crear base `datalized_enpcc` en PostgreSQL.
2. Importar CSV 2017 a `raw_enpcc_2017_txt` usando pgAdmin (delimiter `;`, header ON, encoding UTF-8).
3. Ejecutar `/sql/02_clean_2017.sql` para generar `raw_enpcc_2017`.
4. Repetir el mismo patrón para 2024.
5. Ejecutar `/sql/03_views.sql` y conectar Power BI a las vistas (`vw_kpis_comuna`).


## 8. Link al dashboard público
- (pendiente)
