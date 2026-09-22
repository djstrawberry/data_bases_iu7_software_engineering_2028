-- 1. Тест скалярной функции
SELECT get_prisoner_deals_volume(67) AS prisoner_deals_volume;

-- 2. Тест подставляемой табличной функции
SELECT * FROM get_prisoners_in_cell(15);

-- 3. Тест многооператорной табличной функции
SELECT * FROM analyze_cell_security_risk(111);

-- 4. Тест рекурсивной функции
SELECT * FROM get_prisoners_hierarchy(220);


-- 5. Тест процедуры с параметрами (Перевод)
CALL transfer_prisoner(5, 4);

-- 6. Тест рекурсивной процедуры (Сокращение срока)
CALL reduce_term_recursive(1, 1);

-- 7. Тест процедуры с курсором
CALL process_suspicious_deals(5);

-- 8. Тест процедуры доступа к метаданным
CALL get_table_metadata('prisoners');


-- 9. Тест AFTER триггера (Запись в лог)
UPDATE deals SET deal_volume = deal_volume + 1 WHERE deal_id = 1;
SELECT * FROM deals_audit_log;

-- 10. Тест INSTEAD OF триггера (Вставка через представление)
INSERT INTO prisoners_info (prisoner_id, prisoner_name, criminal_code_article, term, cell_id)
VALUES (9999, 'Тестовый Заключенный', 'УК РФ Ст. 158', 3, 1);

SELECT * FROM prisoners WHERE prisoner_id = 9999;