-- =========================================
-- 03_views.sql
-- Vistas para Power BI (2017 comuna + 2024 región)
-- =========================================

create or replace view vw_participacion_long as

/* =========================
   ENPCC 2017 — CINE (con comuna)
   ========================= */
select
  2017::int as anio,
  "IdComuna"::int as idcomuna,
  "Region"::int as region,
  'cine'::text as disciplina,
  'ENPCC2017'::text as fuente,
  case when c7a = 1 then 1
       when c7a = 2 then 0
       else null end::int as asistio_12m,
  case when c7b = 1 then 1
       when c7b = 2 then 0
       else null end::int as alguna_vez,
  null::text as entrada_tipo,
  null::numeric as monto_pagado_clp,
  null::text as monto_tramo
from raw_enpcc_2017

union all

/* =========================
   ENPCC 2017 — MÚSICA EN VIVO (con comuna)
   ========================= */
select
  2017::int as anio,
  "IdComuna"::int as idcomuna,
  "Region"::int as region,
  'musica_vivo'::text as disciplina,
  'ENPCC2017'::text as fuente,
  case when c5a = 1 then 1
       when c5a = 2 then 0
       else null end::int as asistio_12m,
  case when c5b = 1 then 1
       when c5b = 2 then 0
       else null end::int as alguna_vez,
  null::text as entrada_tipo,
  null::numeric as monto_pagado_clp,
  null::text as monto_tramo
from raw_enpcc_2017

union all

/* =========================
   ENPCC 2024 — CINE (sin comuna)
   ========================= */
select
  2024::int as anio,
  null::int as idcomuna,
  region::int as region,
  'cine'::text as disciplina,
  'ENPCC2024'::text as fuente,
  case when scree_asist_cine_mes = 1 then 1
       when scree_asist_cine_mes = 2 then 0
       else null end::int as asistio_12m,
  case when scree_asist_cine_vida = 1 then 1
       when scree_asist_cine_vida = 2 then 0
       else null end::int as alguna_vez,
  case
    when cine_pago_txt in ('pagado','pagada') then 'pagada'
    when cine_pago_txt in ('gratuito','gratuita','gratis') then 'gratuita'
    when cine_pago_txt in ('no sabe','no responde','nsnr') then 'nsnr'
    else null
  end::text as entrada_tipo,
  null::numeric as monto_pagado_clp,
  cine_entrada::text as monto_tramo
from raw_enpcc_2024

union all

/* =========================
   ENPCC 2024 — MÚSICA EN VIVO (sin comuna)
   ========================= */
select
  2024::int as anio,
  null::int as idcomuna,
  region::int as region,
  'musica_vivo'::text as disciplina,
  'ENPCC2024'::text as fuente,
  case when scree_asist_musica_mes = 1 then 1
       when scree_asist_musica_mes = 2 then 0
       else null end::int as asistio_12m,
  case when scree_asist_musica_vida = 1 then 1
       when scree_asist_musica_vida = 2 then 0
       else null end::int as alguna_vez,
  case
    when musica_pago_txt in ('pagado','pagada') then 'pagada'
    when musica_pago_txt in ('gratuito','gratuita','gratis') then 'gratuita'
    when musica_pago_txt in ('no sabe','no responde','nsnr') then 'nsnr'
    else null
  end::text as entrada_tipo,
  null::numeric as monto_pagado_clp,
  musica_entrada::text as monto_tramo
from raw_enpcc_2024
;

-- =========================
-- KPI comparables por REGIÓN (2017 y 2024)
-- =========================
create or replace view vw_kpis_region as
select
  anio,
  region,
  disciplina,
  avg(asistio_12m::numeric) as share_asistio_12m,
  avg(alguna_vez::numeric) as share_alguna_vez,
  avg(case when entrada_tipo = 'pagada' then 1
           when entrada_tipo = 'gratuita' then 0
           else null end::numeric) as share_pago
from vw_participacion_long
group by 1,2,3;

-- =========================
-- KPI por COMUNA (solo 2017)
-- =========================
create or replace view vw_kpis_comuna_2017 as
select
  anio,
  region,
  idcomuna,
  disciplina,
  avg(asistio_12m::numeric) as share_asistio_12m,
  avg(alguna_vez::numeric) as share_alguna_vez
from vw_participacion_long
where anio = 2017 and idcomuna is not null
group by 1,2,3,4;
