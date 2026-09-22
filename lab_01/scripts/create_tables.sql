DROP TABLE IF EXISTS deals, prisoners, guards, items, fractions, cells CASCADE;

CREATE TABLE cells (
    cell_id INT,
    capacity INT,
    has_cctv BOOLEAN,
    guards_count INT,
    regime_type VARCHAR(50)
);

CREATE TABLE fractions (
    fraction_id INT,
    fraction_name VARCHAR(100),
    influence INT,
    cells_count INT,
    main_perk VARCHAR(100)
);

CREATE TABLE items (
    item_id INT,
    item_name VARCHAR(100),
    cost INT,
    rarity VARCHAR(50),
    risk_level VARCHAR(50)
);

CREATE TABLE guards (
    guard_id INT,
    guard_name VARCHAR(100),
    deal_tendency INT,
    attentiveness INT,
    shift VARCHAR(50)
);

CREATE TABLE prisoners (
    prisoner_id INT,
    prisoner_name VARCHAR(150),
    criminal_code_article VARCHAR(50),
    status VARCHAR(50),
    term INT,
    cell_id INT,
    fraction_id INT,
    boss_id INT
);

CREATE TABLE deals (
    deal_id INT,
    prisoner_id INT,
    item_id INT,
    guard_id INT,
    deal_date TIMESTAMP,
    deal_volume INT,
    deal_status VARCHAR(50)
);