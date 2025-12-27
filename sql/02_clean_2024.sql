-- 02_clean_2024.sql

drop table if exists raw_enpcc_2024;

create table raw_enpcc_2024 as
select
  nullif(trim("IdComuna"), '')::int as "IdComuna",
  nullif(trim("region"), '')::int as "region",
  nullif(trim(scree_asist_cine_mes), '')::int as scree_asist_cine_mes,
  nullif(trim(scree_asist_cine_vida), '')::int as scree_asist_cine_vida,
  nullif(trim(scree_asist_musica_mes), '')::int as scree_asist_musica_mes,
  nullif(trim(scree_asist_musica_vida), '')::int as scree_asist_musica_vida,
  nullif(trim(cine_pago), '')::int as cine_pago,
  nullif(trim(cine_entrada), '') as cine_entrada,
  nullif(trim(musica_pago), '')::int as musica_pago,
  nullif(trim(musica_entrada), '') as musica_entrada
from raw_enpcc_2024_txt;
