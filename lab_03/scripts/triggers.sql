-- ----------------------------------------------------------------------------
-- Вспомогательная таблица аудита для AFTER триггера
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS deals_audit_log (
    log_id SERIAL PRIMARY KEY,
    deal_id INT,
    act VARCHAR(20),
    old_volume INT,
    new_volume INT,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    username VARCHAR(50) DEFAULT CURRENT_USER
);


-- ----------------------------------------------------------------------------
-- 1. Триггер AFTER (После INSERT или UPDATE на таблице deals)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION after_deals_audit()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO deals_audit_log (deal_id, act, old_volume, new_volume)
        VALUES (NEW.deal_id, 'INSERT', NULL, NEW.deal_volume);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO deals_audit_log (deal_id, act, old_volume, new_volume)
        VALUES (NEW.deal_id, 'UPDATE', OLD.deal_volume, NEW.deal_volume);
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_after_deals_audit ON deals;

CREATE TRIGGER trg_after_deals_audit
AFTER INSERT OR UPDATE ON deals
FOR EACH ROW
EXECUTE FUNCTION after_deals_audit();


-- ----------------------------------------------------------------------------
-- 2. Триггер INSTEAD OF (На обновляемое представление)
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW prisoners_info AS
SELECT 
    p.prisoner_id,
    p.prisoner_name,
    p.criminal_code_article,
    p.term,
    c.cell_id,
    c.regime_type
FROM prisoners p
JOIN cells c ON p.cell_id = c.cell_id;

CREATE OR REPLACE FUNCTION instead_of_prisoner_insert()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO prisoners (prisoner_id, prisoner_name, criminal_code_article, status, term, cell_id, fraction_id, boss_id)
    VALUES (
        NEW.prisoner_id,
        NEW.prisoner_name,
        NEW.criminal_code_article,
        'Ожидает суда',
        NEW.term,
        NEW.cell_id,
        NULL,
        NULL
    );

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_instead_of_prisoner_insert ON prisoners_info;

CREATE TRIGGER trg_instead_of_prisoner_insert
INSTEAD OF INSERT ON prisoners_info
FOR EACH ROW
EXECUTE FUNCTION instead_of_prisoner_insert();