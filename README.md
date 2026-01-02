# Postulación-Datalized — Panel de participación cultural demanda (ENPC 2017- 2024) v/s oferta (INE)

## 1. Pregunta del panel
¿Qué comunas presentan mayores brechas de participación en **cine** y **música en vivo** (últimos 12 meses), y cómo se relaciona con **pago vs gratuidad**, para orientar programación y mediación de una institución cultural? ¿existen regiones con mayor brecha de oferta y demanda?

Update: **¿Dónde están las brechas territoriales (región/comuna) de participación cultural en Cine y Música en Vivo, y qué trade-off existe entre priorizar equidad territorial versus escala de mercado?**

Producto (Dashboard)
- **Dashboard público (Power BI):** [[link](https://app.powerbi.com/view?r=eyJrIjoiNzVjMjYxMWEtMTYxNy00MTk2LWEwYjAtNjllOWY3YzdhOTIyIiwidCI6IjQ5ZWM5ZjUyLThlMjgtNGIyMC1hNDQxLTkyZWJmMjZjNTQ0YyIsImMiOjR9&pageName=b75a710b6baa696e9e77)]
- **Repositorio GitHub (este):** [[link](https://github.com/ReimonReyes/proyecto-datalized)]

**Páginas del reporte**
1. Portada: propósito y audiencia del análisis.
2. Resumen Regional (2017–2024): embudo de participación + ranking regional.
3. Zoom Comunal (2017): mapa y ranking comunal (solo 2017 por limitación de datos 2024).
4. Recomendaciones: trade-offs y estimación de mercado (CLP) con supuestos explícitos

## Contexto (cliente ficticio)
Una institución cultural municipal necesita priorizar comunas y segmentos para aumentar participación presencial y diseñar estrategias de acceso (precio/gratuidad) antes de la implementación del Pase Cultural.

## 2. Fuentes de datos (públicas)
- ENPC 2017 (base + diccionario + metodología)
- ENPCCL 2024 (base + diccionario + metodología)
- Población regional 15+ (para estimación de mercado) 
- TopoJSON comunal (para mapa 2017) 
- Encuesta de Espectáculos Públicos: Tabulados regionales INE / ECIA (para contraste regional oferta/mercado) *** Finalmente esta idea quedará para después

## 3. Metodología (resumen)
Se construyó un modelo simple orientado a decisión:
- **Indicadores:** 
  - Asistencia alguna vez (vida)
  - Asistencia últimos 12 meses (participación reciente)
  - Pago de entrada (condicional a respuesta / modalidad)
- **Dimensiones:** Año, Región, (Comuna 2017), Disciplina (Cine / Música en vivo)
- **Enfoque:** comparar brechas entre territorios y visualizar el trade-off equidad vs escala.
## 4. Proceso 
## Proceso de limpieza y transformación (reproducible)
Proceso de datos (ETL)
Los scripts SQL dejan listas vistas consumibles por Power BI:

### Estructura
- `sql/01_staging_2017.sql` / `sql/01_staging_2024.sql`  
  Ingesta y tipificación mínima de columnas usadas.
- `sql/02_clean_2017.sql` / `sql/02_clean_2024.sql`  
  Limpieza / recodificación (Sí/No/NSNR, formatos, textos).
- `sql/03_views.sql`  
  Vistas finales:
  - `vw_participacion_long`
  - `vw_kpis_region`
  - `vw_kpis_comuna` (solo 2017)

## 6) Modelado y medidas en Power BI
# 6.1 Modelo lógico (mínimo, orientado al dashboard)

El reporte se construyó sobre un modelo liviano, separando dimensiones (territorio y tiempo) de hechos (KPIs ya agregados desde SQL).

Tablas de hechos (PostgreSQL views):

vw_kpis_region: KPIs por anio, disciplina, region.

vw_kpis_comuna: KPIs por anio, disciplina, region, idcomuna (solo 2017 por limitación de 2024).

(Opcional) vw_participacion_long: formato largo para trazabilidad y revisiones.

# Dimensiones (Power BI / CSV):

- DimRegion (COD_REG, REGION, labels)
- DimComuna (COD_COM, COMUNA, COD_REG, etc.) para mapa comunal 2017
- DimAño
- DimDisciplina (cine / musica_vivo)

# Relaciones (mínimas):
- DimRegion[COD_REG] 1 → * vw_kpis_region[region]
- DimRegion[COD_REG] 1 → * DimComuna[COD_REG]
- DimComuna[COD_COM] 1 → * vw_kpis_comuna[idcomuna] (solo 2017)
- DimAño[anio] 1 → * vw_kpis_region[anio] y vw_kpis_comuna[anio]
- DimDisciplina[disciplina] 1 → * vw_kpis_region[disciplina] y vw_kpis_comuna[disciplina]

Iteración importante: se evitó conectar “hechos con hechos” (muchas a muchas) y se privilegió un esquema simple para que el filtro territorial funcione sin ambigüedad.

# 6.2 Medidas (DAX) y consistencia de porcentajes

Los KPIs provenientes de SQL ya están en el rango 0–1 (proporciones). En Power BI se formatean como porcentaje y se muestran con 1–2 decimales.
Medidas principales (ejemplo):
% Asistencia (vida) = promedio de share_alguna_vez
% Asistencia (12 meses) = promedio de share_asistio_12m
% Pago (condicional) = promedio de share_pago

Iteración importante: al inicio se observó un error típico (tarjetas con valores inflados) por usar sumas en lugar de promedios. Se corrigió estandarizando a promedio (porque son shares).

# 6.3 Ordenamiento del slicer territorial (mejora de legibilidad)

Se construyó una etiqueta COD_REG - REGION para facilitar lectura del slicer.
Iteración importante: la etiqueta se ordenaba mal (1, 12, 13, 2…) por orden lexicográfico. Se corrigió usando “Sort by column” con una columna numérica Region_order.

## 7) Decisiones de diseño del dashboard
El dashboard se diseñó para entregar un diagnóstico territorial accionable, siguiendo un flujo de lectura simple:

### 7.1 Estructura por páginas

a) Portada
Define misión y público objetivo del dashboard.
b) Resumen Regional (2017–2024)
Presenta “embudo” de participación (vida → 12m → pago condicional) para Cine y Música en vivo.
Incluye ranking regional para detectar brechas y priorizar.
c) Zoom Comunal (2017)
Mapa + ranking comunal para evidenciar desigualdad intrarregional.
Se enfoca en 2017 porque la versión 2024 utilizada no incluye comuna.
d) Recomendaciones
Traduce hallazgos a decisiones: trade-off equidad vs escala.
Incluye un estimador simple de mercado anual en CLP con supuestos.

### 7.2 Por qué “embudo” (vida → 12m → pago)

Se eligió este embudo porque permite segmentar acciones públicas/gestión cultural:
Vida alta + 12m baja: desafío de continuidad (frecuencia y acceso).
12m alta + pago bajo: estructura del acceso (gratuito/subsidio).
Pago alto (condicional): oportunidad de sostenibilidad financiera, con riesgo de exclusión.

Nota: el indicador de “pago” es condicional a la declaración de modalidad de acceso (y/o a quienes asistieron), por lo que se interpreta como “% de asistentes que pagaron” (según disponibilidad de respuesta).

### 7.3 Por qué ranking regional + zoom comunal

El ranking regional permite priorizar rápido “dónde mirar primero”.
El zoom comunal permite discutir inequidad dentro de una misma región (caso RM), lo cual es clave para decisiones de mediación y programación territorial.

## 8) Limitaciones (importante)
- ENPCC 2024 utilizada en esta versión **no incluye comuna**, por lo que el zoom comunal se presenta solo para 2017.
- El indicador de “pago” es **condicional a quienes declaran modalidad de acceso** (y/o a quienes asistieron), por lo que no representa necesariamente a toda la población.
- Estimación de mercado usa ticket fijo ($8.000) como supuesto de trabajo.

## 9) Cómo reproducir (local)
1. Cargar datos 2017/2024 en PostgreSQL (tablas staging).
2. Ejecutar scripts en orden: `01_*` → `02_*` → `03_views.sql`
3. Abrir el `.pbix`, configurar conexión a PostgreSQL y refrescar.
