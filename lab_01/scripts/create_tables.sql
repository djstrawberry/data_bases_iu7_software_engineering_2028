DROP TABLE IF EXISTS deals, prisoners, guards, items, fractions, cells CASCADE;
CREATE TABLE Cells (
    id_камеры INT,
    вместимость INT,
    наличие_видеонаблюдения BOOLEAN,
    количество_охранников INT,
    тип_режима VARCHAR(50)
);

CREATE TABLE Fractions (
    id_группировки INT,
    название_группировки VARCHAR(100),
    влияние INT,
    количество_камер INT,
    главная_плюшка VARCHAR(100)
);

CREATE TABLE Items (
    id_предмета INT,
    название VARCHAR(100),
    стоимость INT,
    редкость VARCHAR(50),
    степень_риска VARCHAR(50)
);

CREATE TABLE Guards (
    id_охранника INT,
    имя_охранника VARCHAR(100),
    склонность_к_сделкам INT,
    внимательность INT,
    смена VARCHAR(50)
);

CREATE TABLE Prisoners (
    id_заключенного INT,
    имя_заключенного VARCHAR(150),
    статья_ук VARCHAR(50),
    статус VARCHAR(50),
    срок INT,
    id_камеры INT,
    id_группировки INT,
    id_босса INT
);

CREATE TABLE Deals (
    id_сделки INT,
    id_заключенного INT,
    id_предмета INT,
    id_охранника INT,
    дата_и_время TIMESTAMP,
    объем_сделки     INT,
    статус_сделки VARCHAR(50)
);