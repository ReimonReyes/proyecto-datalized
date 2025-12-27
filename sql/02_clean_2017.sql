-- 02_clean_2017.sql
-- Limpia espacios/vacíos y convierte a tipos numéricos

drop table if exists raw_enpcc_2017;

create table raw_enpcc_2017 as
select
  nullif(trim("IdEncuesta"), '')::int as "IdEncuesta",
  nullif(trim("IdPersona"), '')::int as "IdPersona",
  nullif(trim("Region"), '')::int as "Region",
  nullif(trim("IdComuna"), '')::int as "IdComuna",
  nullif(trim("Sexo"), '')::int as "Sexo",
  nullif(trim("Edad"), '')::int as "Edad",
  nullif(trim(nivel_educ), '')::int as nivel_educ,
  nullif(trim(esc), '')::int as esc,
  nullif(trim(c5a), '')::int as c5a,
  nullif(trim(c5b), '')::int as c5b,
  nullif(trim(c5h), '')::int as c5h,
  nullif(trim(c5h_monto), '')::int as c5h_monto,
  nullif(trim(c6a), '')::int as c6a,
  nullif(trim(c7a), '')::int as c7a,
  nullif(trim(c7b), '')::int as c7b,
  nullif(trim(c7g), '')::int as c7g,
  nullif(trim(c7g_monto), '')::int as c7g_monto,
  nullif(trim(c8d), '')::int as c8d,
  nullif(trim(d7_1), '')::int as d7_1,
  nullif(trim(d7_2), '')::int as d7_2,
  nullif(trim(d7_3), '')::int as d7_3,
  nullif(trim(d7_4), '')::int as d7_4,
  nullif(trim(d15), '')::int as d15,
  nullif(trim(d26), '')::int as d26
from raw_enpcc_2017_txt;
