\copy Cells FROM '../data/cells.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy Fractions FROM '../data/fractions.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy Items FROM '../data/items.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy Guards FROM '../data/guards.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy Prisoners FROM '../data/prisoners.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
\copy Deals FROM '../data/deals.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');