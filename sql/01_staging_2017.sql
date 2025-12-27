-- 01_staging_2017.sql
-- Crea tabla staging (todo TEXT) para importar CSV sin fallos por tipos

drop table if exists raw_enpcc_2017_txt;

create table raw_enpcc_2017_txt (
  "IdEncuesta" text,
  "IdPersona" text,
  "Region" text,
  "IdComuna" text,
  "Sexo" text,
  "Edad" text,
  nivel_educ text,
  esc text,
  c5a text,
  c5b text,
  c5h text,
  c5h_monto text,
  c6a text,
  c7a text,
  c7b text,
  c7g text,
  c7g_monto text,
  c8d text,
  d7_1 text,
  d7_2 text,
  d7_3 text,
  d7_4 text,
  d15 text,
  d26 text
);
