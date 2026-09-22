ALTER TABLE cells ADD PRIMARY KEY (cell_id);
ALTER TABLE fractions ADD PRIMARY KEY (fraction_id);
ALTER TABLE items ADD PRIMARY KEY (item_id);
ALTER TABLE guards ADD PRIMARY KEY (guard_id);
ALTER TABLE prisoners ADD PRIMARY KEY (prisoner_id);
ALTER TABLE deals ADD PRIMARY KEY (deal_id);

ALTER TABLE prisoners 
    ADD CONSTRAINT fk_prisoners_cell FOREIGN KEY (cell_id) REFERENCES cells(cell_id),
    ADD CONSTRAINT fk_prisoners_fraction FOREIGN KEY (fraction_id) REFERENCES fractions(fraction_id),
    ADD CONSTRAINT fk_prisoners_boss FOREIGN KEY (boss_id) REFERENCES prisoners(prisoner_id);

ALTER TABLE deals
    ADD CONSTRAINT fk_deals_prisoner FOREIGN KEY (prisoner_id) REFERENCES prisoners(prisoner_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_deals_item FOREIGN KEY (item_id) REFERENCES items(item_id) ON DELETE CASCADE,
    ADD CONSTRAINT fk_deals_guard FOREIGN KEY (guard_id) REFERENCES guards(guard_id) ON DELETE CASCADE;

ALTER TABLE cells 
    ALTER COLUMN capacity SET NOT NULL,
    ALTER COLUMN has_cctv SET NOT NULL,
    ALTER COLUMN regime_type SET NOT NULL;

ALTER TABLE fractions 
    ALTER COLUMN fraction_name SET NOT NULL,
    ALTER COLUMN influence SET NOT NULL;

ALTER TABLE items 
    ALTER COLUMN item_name SET NOT NULL,
    ALTER COLUMN cost SET NOT NULL,
    ALTER COLUMN risk_level SET NOT NULL;

ALTER TABLE guards 
    ALTER COLUMN guard_name SET NOT NULL,
    ALTER COLUMN deal_tendency SET NOT NULL,
    ALTER COLUMN attentiveness SET NOT NULL,
    ALTER COLUMN shift SET NOT NULL;

ALTER TABLE prisoners 
    ALTER COLUMN prisoner_name SET NOT NULL,
    ALTER COLUMN criminal_code_article SET NOT NULL,
    ALTER COLUMN status SET NOT NULL,
    ALTER COLUMN term SET NOT NULL;

ALTER TABLE deals 
    ALTER COLUMN prisoner_id SET NOT NULL,
    ALTER COLUMN item_id SET NOT NULL,
    ALTER COLUMN guard_id SET NOT NULL,
    ALTER COLUMN deal_date SET NOT NULL,
    ALTER COLUMN deal_volume SET NOT NULL,
    ALTER COLUMN deal_status SET NOT NULL;

ALTER TABLE cells ADD CONSTRAINT chk_cells_capacity CHECK (capacity > 0);
ALTER TABLE fractions ADD CONSTRAINT chk_fractions_influence CHECK (influence BETWEEN 1 AND 10);
ALTER TABLE guards 
    ADD CONSTRAINT chk_guards_corruption CHECK (deal_tendency BETWEEN 1 AND 10),
    ADD CONSTRAINT chk_guards_attention CHECK (attentiveness BETWEEN 1 AND 10);
ALTER TABLE prisoners ADD CONSTRAINT chk_prisoners_term CHECK (term > 0);