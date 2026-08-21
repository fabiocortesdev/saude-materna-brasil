CREATE OR REPLACE VIEW `saude_materno_infantil.vw_nascidos_vivos_analitico` AS

SELECT
    -- Columns we added ourselves during ingestion
    f.UF,
    f.YEAR,
    f.REGION,

    -- Genuinely numeric SINASC fields, cast from STRING.
    -- SAFE_CAST returns NULL instead of throwing an error when a value
  
    SAFE_CAST(f.IDADEMAE AS INT64)   AS idademae_anos,
    SAFE_CAST(f.IDADEPAI AS INT64)   AS idadepai_anos,
    SAFE_CAST(f.PESO AS INT64)       AS peso_gramas,
    SAFE_CAST(f.APGAR5 AS INT64)     AS apgar5_nota,
    SAFE_CAST(f.QTDFILVIVO AS INT64) AS qtdfilvivo_num,

    -- Coded categorical SINASC fields: original code kept, plus the
    -- decoded label from each dimension table.
    f.PARTO,
    dp.parto_desc,

    f.ESTCIVMAE,
    de.estcivmae_desc,

    f.CONSULTAS,
    dc.consultas_desc,

    f.GESTACAO,
    dg.gestacao_desc,

    f.ESCMAE2010,
    dm.escmae2010_desc,

    -- Fields kept as-is for now
    f.SEXO,
    f.DTNASC,
    f.CODMUNRES

FROM `saude_materno_infantil.nascidos_vivos` AS f
LEFT JOIN `saude_materno_infantil.dim_parto` AS dp
    ON f.PARTO = dp.PARTO
LEFT JOIN `saude_materno_infantil.dim_estcivmae` AS de
    ON f.ESTCIVMAE = de.ESTCIVMAE
LEFT JOIN `saude_materno_infantil.dim_consultas` AS dc
    ON f.CONSULTAS = dc.CONSULTAS
LEFT JOIN `saude_materno_infantil.dim_gestacao` AS dg
    ON f.GESTACAO = dg.GESTACAO
LEFT JOIN `saude_materno_infantil.dim_escmae2010` AS dm
    ON f.ESCMAE2010 = dm.ESCMAE2010;
