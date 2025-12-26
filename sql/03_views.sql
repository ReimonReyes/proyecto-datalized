-- =========================================
-- 03_views.sql
-- Vistas finales para Power BI
-- =========================================

create or replace view vw_participacion_long as
/* =========================
   ENPCC 2017 — CINE
   ========================= */
select
  2017::int as anio,
  "IdComuna"::int as idcomuna,
  "Region"::int as region,
  'cine'::text as disciplina,
  case
    when c7a = 1 then 1
    when c7a = 2 then 0
    else null
  end::int as asistio_12m,
  case
    when c7b = 1 then 1
    when c7b = 2 then 0
    else null
  end::int as alguna_vez,
  null::text as entrada_tipo,
  null::numeric as monto_pagado_clp,
  null::text as monto_tramo
from raw_enpcc_2017

union all

/* =========================
   ENPCC 2017 — MÚSICA EN VIVO
   ========================= */
select
  2017::int as anio,
  "IdComuna"::int as idcomuna,
  "Region"::int as region,
  'musica_vivo'::text as disciplina,
  case
    when c5a = 1 then 1
    when c5a = 2 then 0
    else null
  end::int as asistio_12m,
  case
    when c5b = 1 then 1
    when c5b = 2 then 0
    else null
  end::int as alguna_vez,
  null::text as entrada_tipo,
  null::numeric as monto_pagado_clp,
  null::text as monto_tramo
from raw_enpcc_2017

union all

/* =========================
   ENPCCL 2024 — CINE
   ========================= */
select
  2024::int as anio,
  "IdComuna"::int as idcomuna,
  "region"::int as region,
  'cine'::text as disciplina,
  case
    when scree_asist_cine_mes = 1 then 1
    when scree_asist_cine_mes = 2 then 0
    when scree_asist_cine_mes in (88, 99) then null
    else null
  end::int as asistio_12m,
  case
    when scree_asist_cine_vida = 1 then 1
    when scree_asist_cine_vida = 2 then 0
    when scree_asist_cine_vida in (88, 99) then null
    else null
  end::int as alguna_vez,
  case
    when cine_pago = 1 then 'pagada'
    when cine_pago = 2 then 'gratuita'
    when cine_pago in (88, 99) then 'nsnr'
    else null
  end::text as entrada_tipo,
  null::numeric as monto_pagado_clp,
  cine_entrada::text as monto_tramo
from raw_enpcc_2024

union all

/* =========================
   ENPCCL 2024 — MÚSICA EN VIVO
   ========================= */
select
  2024::int as anio,
  "IdComuna"::int as idcomuna,
  "region"::int as region,
  'musica_vivo'::text as disciplina,
  case
    when scree_asist_musica_mes = 1 then 1
    when scree_asist_musica_mes = 2 then 0
    when scree_asist_musica_mes in (88, 99) then null
    else null
  end::int as asistio_12m,
  case
    when scree_asist_musica_vida = 1 then 1
    when scree_asist_musica_vida = 2 then 0
    when scree_asist_musica_vida in (88, 99) then null
    else null
  end::int as alguna_vez,
  case
    when musica_pago = 1 then 'pagada'
    when musica_pago = 2 then 'gratuita'
    when musica_pago in (88, 99) then 'nsnr'
    else null
  end::text as entrada_tipo,
  null::numeric as monto_pagado_clp,
  musica_entrada::text as monto_tramo
from raw_enpcc_2024
;
