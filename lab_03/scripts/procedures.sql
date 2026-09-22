-- ----------------------------------------------------------------------------
-- 1. Хранимая процедура с параметрами
-- Назначение: Перевод заключенного в другую камеру с проверкой вместимости.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE transfer_prisoner(input_prisoner_id INT, target_cell_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    capacity INT;
    current_count INT;
BEGIN
    RAISE NOTICE '[transfer_prisoner] Старт. Заключенный ID: %, целевая камера: %', input_prisoner_id, target_cell_id;

    SELECT c.capacity INTO capacity
    FROM cells c
    WHERE cell_id = target_cell_id;

    IF NOT FOUND THEN 
        RAISE EXCEPTION 'The cell with ID % doesn`t exist!', target_cell_id;
    END IF;

    SELECT COUNT(*) INTO current_count 
    FROM prisoners
    WHERE cell_id = target_cell_id;

    IF current_count >= capacity THEN
        RAISE EXCEPTION 'Transition impossible: cell % is full (%/%)!', 
                        target_cell_id, current_count, capacity;
    END IF;

    UPDATE prisoners
    SET cell_id = target_cell_id
    WHERE prisoner_id = input_prisoner_id;

    RAISE NOTICE '[transfer_prisoner] Успех. Заключенный % переведен в камеру %.', input_prisoner_id, target_cell_id;

  END;
  $$;


-- ----------------------------------------------------------------------------
-- 2. Рекурсивная хранимая процедура
-- Назначение: Рекурсивный пересчет срока для босса и всей его 
-- цепочки подчиненных.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE reduce_term_recursive(input_boss_id INT, input_years_to_reduce INT)
LANGUAGE plpgsql
AS $$
DECLARE
  rec RECORD;
BEGIN
    RAISE NOTICE '[reduce_term_recursive] Обработка заключенного ID: %, уменьшение на % лет', input_boss_id, input_years_to_reduce;

    UPDATE prisoners 
    SET term = GREATEST(1, term - input_years_to_reduce)
    WHERE prisoner_id = input_boss_id;

    FOR rec IN SELECT prisoner_id FROM prisoners WHERE boss_id = input_boss_id LOOP
        RAISE NOTICE '[reduce_term_recursive] Найден подчиненный ID: %. Рекурсивный вызов.', rec.prisoner_id;
        CALL reduce_term_recursive(rec.prisoner_id, input_years_to_reduce);
    END LOOP;
END;
$$;


-- ----------------------------------------------------------------------------
-- 3. Хранимая процедура с курсором
-- Назначение: Построчно анализирует сделки и меняет статус 
-- подозрительных крупных сделок.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE process_suspicious_deals(input_min_volume INT)
LANGUAGE plpgsql
AS $$
DECLARE
    cur_deals CURSOR FOR
        SELECT deal_id, deal_volume, deal_status
        FROM deals
        WHERE deal_volume >= input_min_volume;

    rec RECORD;
    updated_count INT := 0;
BEGIN
    RAISE NOTICE '[process_suspicious_deals] Старт. Минимальный объем: %', input_min_volume;

    OPEN cur_deals;

    LOOP
        FETCH cur_deals INTO rec;
        EXIT WHEN NOT FOUND;

        IF rec.deal_status <> 'Раскрыта начальством' AND rec.deal_status <> 'Расследуется' THEN
            UPDATE deals
            SET deal_status = 'Расследуется'
            WHERE deal_id = rec.deal_id;
            updated_count := updated_count + 1;
            RAISE NOTICE '[process_suspicious_deals] Сделка ID % обновлена на статус "Расследуется".', rec.deal_id;
        ELSE
            RAISE NOTICE '[process_suspicious_deals] Сделка ID % пропущена (статус: %).', rec.deal_id, rec.deal_status;
        END IF;
    END LOOP;

    CLOSE cur_deals;
    RAISE NOTICE '[process_suspicious_deals] Завершено. Всего обновлено записей: %', updated_count;
END;
$$;


-- ----------------------------------------------------------------------------
-- 4. Хранимая процедура доступа к метаданным
-- Назначение: Выводит информацию о колонках, типах данных и 
-- ограничениях любой таблицы БД.
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE get_table_metadata(input_table_name VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    rec RECORD;
BEGIN
    RAISE NOTICE '=== Метаданные таблицы: % ===', input_table_name;

    FOR rec IN SELECT
        column_name,
        data_type,
        is_nullable
        FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = input_table_name
        ORDER BY ordinal_position
    LOOP
        RAISE NOTICE 'column: %, type: %, is nullable: %', 
                     rec.column_name, rec.data_type, rec.is_nullable;
    END LOOP;
END;
$$;