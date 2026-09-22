-- ----------------------------------------------------------------------------
-- 1. Скалярная функция
-- Назначение: По ID заключенного считает суммарный объем его сделок.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_prisoner_deals_volume(input_prisoner_id INT)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE 
    deals_volume INT;
BEGIN
    SELECT COALESCE(SUM(deal_volume), 0) INTO deals_volume
    FROM deals
    WHERE prisoner_id = input_prisoner_id;
    RETURN deals_volume;
END;
$$;


-- ----------------------------------------------------------------------------
-- 2. Подставляемая табличная функция (Inline Table-Valued Function)
-- Назначение: Возвращает список всех заключенных в указанной камере.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_prisoners_in_cell(input_cell_id INT)
RETURNS TABLE (
    prisoner_id INT,
    prisoner_name VARCHAR,
    term INT,
    criminal_code_article VARCHAR
)
LANGUAGE sql
AS $$
    SELECT prisoner_id, prisoner_name, term, criminal_code_article
    FROM prisoners
    WHERE cell_id = input_cell_id;
$$;


-- ----------------------------------------------------------------------------
-- 3. Многооператорная табличная функция 
-- Назначение: Анализирует уровень риска камеры на основе срока заключенных 
-- и наличия видеонаблюдения.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION analyze_cell_security_risk(input_cell_id INT)
RETURNS TABLE (
    cell_id INT,
    prisoners_quantity INT,
    avg_term NUMERIC,
    security_risk VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
    prisoners_quantity INT;
    avg_term NUMERIC;
    has_cctv BOOLEAN;
    security_risk VARCHAR;
BEGIN
    SELECT COUNT(*), COALESCE(AVG(term), 0) 
    INTO prisoners_quantity, avg_term
    FROM prisoners p
    WHERE p.cell_id = input_cell_id;

    SELECT c.has_cctv INTO has_cctv
    FROM cells c
    WHERE c.cell_id = input_cell_id;

    IF prisoners_quantity = 0 THEN
        security_risk := 'LOW risk';
    ELSIF avg_term BETWEEN 10 AND 15 AND COALESCE(has_cctv, FALSE) THEN
        security_risk := 'HIGH risk';
    ELSIF avg_term > 15 THEN
        security_risk := 'CRITICAL risk';
    ELSE
        security_risk := 'MEDIUM risk';
    END IF;

    RETURN QUERY SELECT input_cell_id, prisoners_quantity, ROUND(avg_term, 2), security_risk;
END;
$$;


-- ----------------------------------------------------------------------------
-- 4. Рекурсивная функция с рекурсивным ОТВ (CTE)
-- Назначение: Возвращает всю криминальную иерархию, начиная с указанного
-- авторитета/босса.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION get_prisoners_hierarchy(input_root_boss_id INT)
RETURNS TABLE (
    prisoner_id INT,
    prisoner_name VARCHAR,
    boss_id INT,
    boss_level INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY 
    WITH RECURSIVE hierarchy AS (
        SELECT 
            p.prisoner_id,
            p.prisoner_name,
            p.boss_id,
            1 AS level
        FROM prisoners p
        WHERE p.prisoner_id = input_root_boss_id

        UNION ALL

        SELECT
            child.prisoner_id,
            child.prisoner_name,
            child.boss_id,
            parent.level + 1
        FROM prisoners child
        INNER JOIN hierarchy AS parent 
        ON child.boss_id = parent.prisoner_id
    )
    SELECT * FROM hierarchy;
END;
$$;