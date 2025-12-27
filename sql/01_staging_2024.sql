-- 01_staging_2024.sql

drop table if exists raw_enpcc_2024_txt;

create table raw_enpcc_2024_txt (
  "IdComuna" text,
  "region" text,
  scree_asist_cine_mes text,
  scree_asist_cine_vida text,
  scree_asist_musica_mes text,
  scree_asist_musica_vida text,
  cine_pago text,
  cine_entrada text,
  musica_pago text,
  musica_entrada text
);
