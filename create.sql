CREATE TABLE Miejscowosci(
	id INT IDENTITY(1,1) PRIMARY KEY,
	nazwa_miejscowosci VARCHAR(30) NOT NULL
	check (upper(nazwa_miejscowosci)=nazwa_miejscowosci), 
	powiat VARCHAR(30) NOT NULL
	check (upper(powiat)=powiat), 
	wojewodztwo VARCHAR(30) NOT NULL
	check (upper(wojewodztwo)=wojewodztwo)
);

CREATE TABLE Komisariaty(
id INT IDENTITY(1,1) PRIMARY KEY, 
Nazwa VARCHAR(30) NOT NULL, 
MiejscowoscID INT REFERENCES Miejscowosci NOT NULL
);

CREATE TABLE Policjanci(
pesel CHAR(11) PRIMARY KEY CHECK(pesel LIKE  REPLICATE('[0-9]', 11)), 
imie VARCHAR(30) NOT NULL, 
nazwisko VARCHAR(30) NOT NULL
);

CREATE TABLE Kontrakty(
nr_umowy CHAR(8) PRIMARY KEY
CHECK (nr_umowy LIKE '[0-9][0-9]/[0-9][0-9][0-9][0-9][0-9]'), 
data_zawarcia_umowy DATE NOT NULL, 
data_rozwiazania_umowy DATE,
stanowisko VARCHAR(30) NOT NULL DEFAULT 'dzielnicowy', 
zawarty_przez INT REFERENCES Komisariaty NOT NULL, 
zawarty_z CHAR(11) REFERENCES Policjanci NOT NULL,
CHECK (data_rozwiazania_umowy IS NULL OR data_rozwiazania_umowy > data_zawarcia_umowy)
);

CREATE TABLE Zgloszenia(
id INT IDENTITY(1,1) PRIMARY KEY, 
data_zgloszenia DATE NOT NULL, 
pesel_zglaszajacego CHAR(11) NOT NULL
CHECK (pesel_zglaszajacego LIKE  REPLICATE('[0-9]', 11)), 
telefon_zglaszajacego CHAR(11) CHECK(telefon_zglaszajacego LIKE REPLICATE('[0-9]',3)+'-'+REPLICATE('[0-9]',3)+'-'+REPLICATE('[0-9]',3)),
przyjal_zgloszenie CHAR(11) REFERENCES Policjanci NOT NULL
);

CREATE TABLE Dowody(
id INT IDENTITY(1,1) PRIMARY KEY, 
nazwa TEXT, 
miejsce TEXT, 
data_pozyskania DATE, 
pozyskal CHAR(11) REFERENCES Policjanci NOT NULL,
dowody_w_sprawie INT REFERENCES Zgloszenia NOT NULL
);

CREATE TABLE Przestepstwa(
nazwa VARCHAR(60) PRIMARY KEY, 
minimalny_wymiar_kary INT CHECK (minimalny_wymiar_kary >= 1 AND minimalny_wymiar_kary <= 25),
maksymalny_wymiar_kary INT CHECK (maksymalny_wymiar_kary >= 1 AND maksymalny_wymiar_kary <= 25)
);

CREATE TABLE W_sprawie(
id INT IDENTITY(1,1) PRIMARY KEY,
zgloszenie INT REFERENCES Zgloszenia, 
popelnione_przestepstwo VARCHAR(60) REFERENCES Przestepstwa ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Notowani(
pesel CHAR(11) PRIMARY KEY CHECK(pesel LIKE  REPLICATE('[0-9]', 11)), 
imie VARCHAR(30) NOT NULL, 
nazwisko VARCHAR(30) NOT NULL, 
rok_urodzenia DATE
);

CREATE TABLE Aresztowania(
id INT IDENTITY(1,1) PRIMARY KEY, 
data_aresztowania DATE, 
udowodniono BIT DEFAULT 0, 
zeznanie TEXT, 
dokonal CHAR(11) REFERENCES Policjanci, 
dokonane_w_sprawie INT REFERENCES Zgloszenia, 
aresztowany CHAR(11) REFERENCES Notowani
);

CREATE TABLE Odznaczenia(
id INT IDENTITY(1,1) PRIMARY KEY, 
nazwa VARCHAR(60), 
ranga_odznaczenia INT CHECK (ranga_odznaczenia >= 1 AND ranga_odznaczenia <= 6), 
odznaczenie_za INT REFERENCES Aresztowania
);