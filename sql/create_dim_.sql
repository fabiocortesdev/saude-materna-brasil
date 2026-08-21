
-- ---------------------------------------------------------------------
-- dim_parto - type of delivery
-- ---------------------------------------------------------------------
CREATE OR REPLACE TABLE `saude_materno_infantil.dim_parto` AS
SELECT * FROM UNNEST([
    STRUCT('1' AS PARTO, 'Vaginal' AS parto_desc),
    STRUCT('2' AS PARTO, 'C-section' AS parto_desc),
    STRUCT('9' AS PARTO, 'Not stated' AS parto_desc)
]);


-- ---------------------------------------------------------------------
-- dim_estcivmae - mother's marital status
-- ---------------------------------------------------------------------
CREATE OR REPLACE TABLE `saude_materno_infantil.dim_estcivmae` AS
SELECT * FROM UNNEST([
    STRUCT('1' AS ESTCIVMAE, 'Single' AS estcivmae_desc),
    STRUCT('2' AS ESTCIVMAE, 'Married' AS estcivmae_desc),
    STRUCT('3' AS ESTCIVMAE, 'Widowed' AS estcivmae_desc),
    STRUCT('4' AS ESTCIVMAE, 'Legally separated / Divorced' AS estcivmae_desc),
    STRUCT('5' AS ESTCIVMAE, 'Common-law union' AS estcivmae_desc),
    STRUCT('9' AS ESTCIVMAE, 'Not stated' AS estcivmae_desc)
]);


-- ---------------------------------------------------------------------
-- dim_consultas - number of prenatal visits (bracketed, not exact count)
-- ---------------------------------------------------------------------
CREATE OR REPLACE TABLE `saude_materno_infantil.dim_consultas` AS
SELECT * FROM UNNEST([
    STRUCT('1' AS CONSULTAS, 'None' AS consultas_desc),
    STRUCT('2' AS CONSULTAS, '1 to 3' AS consultas_desc),
    STRUCT('3' AS CONSULTAS, '4 to 6' AS consultas_desc),
    STRUCT('4' AS CONSULTAS, '7 or more' AS consultas_desc),
    STRUCT('9' AS CONSULTAS, 'Not stated' AS consultas_desc)
]);


-- ---------------------------------------------------------------------
-- dim_gestacao - gestational age bracket at birth
-- ---------------------------------------------------------------------
CREATE OR REPLACE TABLE `saude_materno_infantil.dim_gestacao` AS
SELECT * FROM UNNEST([
    STRUCT('1' AS GESTACAO, 'Less than 22 weeks' AS gestacao_desc),
    STRUCT('2' AS GESTACAO, '22 to 27 weeks' AS gestacao_desc),
    STRUCT('3' AS GESTACAO, '28 to 31 weeks' AS gestacao_desc),
    STRUCT('4' AS GESTACAO, '32 to 36 weeks' AS gestacao_desc),
    STRUCT('5' AS GESTACAO, '37 to 41 weeks' AS gestacao_desc),
    STRUCT('6' AS GESTACAO, '42 weeks or more' AS gestacao_desc),
    STRUCT('9' AS GESTACAO, 'Not stated' AS gestacao_desc)
]);


-- ---------------------------------------------------------------------
-- dim_escmae2010 - mother's education level (2010 revision of the field)
-- ---------------------------------------------------------------------
CREATE OR REPLACE TABLE `saude_materno_infantil.dim_escmae2010` AS
SELECT * FROM UNNEST([
    STRUCT('0' AS ESCMAE2010, 'No schooling' AS escmae2010_desc),
    STRUCT('1' AS ESCMAE2010, 'Elementary I (1st-4th grade)' AS escmae2010_desc),
    STRUCT('2' AS ESCMAE2010, 'Elementary II (5th-8th grade)' AS escmae2010_desc),
    STRUCT('3' AS ESCMAE2010, 'High school' AS escmae2010_desc),
    STRUCT('4' AS ESCMAE2010, 'Some college' AS escmae2010_desc),
    STRUCT('5' AS ESCMAE2010, 'College graduate' AS escmae2010_desc),
    STRUCT('9' AS ESCMAE2010, 'Not stated' AS escmae2010_desc)
]);
