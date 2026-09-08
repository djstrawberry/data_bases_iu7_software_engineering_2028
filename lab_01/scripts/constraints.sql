ALTER TABLE Cells ADD PRIMARY KEY (id_камеры);
ALTER TABLE Fractions ADD PRIMARY KEY (id_группировки);
ALTER TABLE Items ADD PRIMARY KEY (id_предмета);
ALTER TABLE Guards ADD PRIMARY KEY (id_охранника);
ALTER TABLE Prisoners ADD PRIMARY KEY (id_заключенного);
ALTER TABLE Deals ADD PRIMARY KEY (id_сделки);

ALTER TABLE Prisoners 
    ADD CONSTRAINT fk_prisoners_cell FOREIGN KEY (id_камеры) REFERENCES Cells(id_камеры),
    ADD CONSTRAINT fk_prisoners_fraction FOREIGN KEY (id_группировки) REFERENCES Fractions(id_группировки),
    ADD CONSTRAINT fk_prisoners_boss FOREIGN KEY (id_босса) REFERENCES Prisoners(id_заключенного);

ALTER TABLE Deals 
    ADD CONSTRAINT fk_deals_prisoner FOREIGN KEY (id_заключенного) REFERENCES Prisoners(id_заключенного),
    ADD CONSTRAINT fk_deals_item FOREIGN KEY (id_предмета) REFERENCES Items(id_предмета),
    ADD CONSTRAINT fk_deals_guard FOREIGN KEY (id_охранника) REFERENCES Guards(id_охранника);

ALTER TABLE Cells ADD CONSTRAINT chk_cells_capacity CHECK (вместимость > 0);
ALTER TABLE Fractions ADD CONSTRAINT chk_fractions_influence CHECK (влияние BETWEEN 1 AND 10);
ALTER TABLE Guards 
    ADD CONSTRAINT chk_guards_corruption CHECK (склонность_к_сделкам BETWEEN 1 AND 10),
    ADD CONSTRAINT chk_guards_attention CHECK (внимательность BETWEEN 1 AND 10);
ALTER TABLE Prisoners ADD CONSTRAINT chk_prisoners_term CHECK (срок > 0);