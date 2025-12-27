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

3) Construcción de métricas (KPIs)
4) Dashboard publicado (Power BI)

## 5. Decisiones de diseño del dashboard
- 4 páginas: Resumen, Brechas comunales, Pago/Gratuidad y Precios, Contraste regional (opcional)
- Se evita inferir causalidad: análisis descriptivo

## 6. Limitaciones
- no uso de ponderadores (factores de expansión)
- Comparabilidad 2017–2024: puede haber cambios de formulación o factores exógenos
- Tabulados INE/ECIA son regionales; no se mezclan con nivel comunal; mientras que ENPCC sí es comunal

## 7. Cómo reproducir
- Ver `/docs/` y `/sql/` (se agregará en próximos commits)

## 8. Link al dashboard público
- (pendiente)
