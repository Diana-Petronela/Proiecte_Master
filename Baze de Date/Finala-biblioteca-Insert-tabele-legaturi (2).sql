DROP TABLE IF EXISTS Genuri;
DROP TABLE IF EXISTS Autori;
DROP TABLE IF EXISTS Edituri;
DROP TABLE IF EXISTS Carti;
DROP TABLE IF EXISTS Periodice;
DROP TABLE IF EXISTS Detalii_Periodice;
DROP TABLE IF EXISTS Penalizari;
DROP TABLE IF EXISTS Carti_Afectate;
DROP TABLE IF EXISTS Imprumuturi;
DROP TABLE IF EXISTS Feedback_Angajati;
DROP TABLE IF EXISTS Angajati;
DROP TABLE IF EXISTS Cititori;
DROP TABLE IF EXISTS Categorii_Cititori;
DROP TABLE IF EXISTS Detalii_Imprumuturi;
DROP TABLE IF EXISTS Review_uri;
DROP TABLE IF EXISTS Operatiuni_Imprumuturi;
DROP TABLE IF EXISTS Copii_Carte;
DROP TABLE IF EXISTS Autori_Carte;




CREATE TABLE Genuri (
    id_gen INT NOT NULL,
    denumire_gen VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Genuri PRIMARY KEY (id_gen)
);

CREATE TABLE Autori (
    id_autor INT NOT NULL,
    nume_autor VARCHAR (100),
    nationalitate VARCHAR(50),
    data_nastere DATE,
	CONSTRAINT PK_Autori PRIMARY KEY (id_autor)
);

CREATE TABLE Edituri (
    id_editura INT NOT NULL,
    nume_editura VARCHAR (255) NOT NULL,
	CONSTRAINT PK_Edituri PRIMARY KEY (id_editura)
);

CREATE TABLE Carti (
    id_carte INT NOT NULL,
	id_editura INT,
	id_gen INT,
    ISBN VARCHAR (75) NOT NULL,
    titlu VARCHAR (255) NOT NULL,
    nr_pagini INT,
    tag VARCHAR (100),
    rating_carte NUMERIC(10,2),
	CONSTRAINT PK_Carti PRIMARY KEY (id_carte)
);

 CREATE TABLE Periodice (
    id_periodic INT NOT NULL,
	 id_editura INT NOT NULL,
    titlu VARCHAR(255) NOT NULL,
    volum NUMERIC(10),
    numar NUMERIC (10),
    nr_pagini NUMERIC(10),
    data_publicare DATE,
    
    CONSTRAINT PK_Periodice PRIMARY KEY (id_periodic)
);

 CREATE TABLE Detalii_Periodice (
    id_detaliu_periodic INT NOT NULL ,
	 id_periodic INT,
    numar NUMERIC (10) NOT NULL,
    tematica VARCHAR (255),
    nr_pagini NUMERIC(10),
    data_aparitie DATE,
    CONSTRAINT PK_Detalii_Periodice PRIMARY KEY (id_detaliu_periodic)
);

CREATE TABLE Penalizari (
    id_penalizare INT NOT NULL,
	id_cititor INT,
	id_imprumut INT,
    valoare_penalizare NUMERIC(10,2) NOT NULL,
    motiv_penalizare VARCHAR(255),
    data_penalizare DATE,
    CONSTRAINT PK_Penalizari PRIMARY KEY (id_penalizare)
);

CREATE TABLE Carti_Afectate (
    id_carte_afectata INT NOT NULL,
	id_copie INT,
	id_cititor INT,
    descriere_stare VARCHAR (255),
    tip_afectare VARCHAR (75),
    data_afectare DATE,
	cost_reparare NUMERIC(10,2),
    CONSTRAINT PK_Carti_Afectate PRIMARY KEY (id_carte_afectata)
);

CREATE TABLE Imprumuturi (
    id_imprumut INT NOT NULL,
	id_cititor INT,
	id_angajat INT,
    data_imprumut DATE NOT NULL,
    data_returnare DATE,
   nr_carti_imprumutate NUMERIC(10) NOT NULL,
	nr_carti_restituite NUMERIC(10),
	CONSTRAINT PK_Imprumuturi PRIMARY KEY (id_imprumut)
);

CREATE TABLE Feedback_Angajati (
    id_feedback INT NOT NULL,
	id_angajat INT,
	id_cititor INT,
    data_feedback DATE,
    feedback VARCHAR(255),
CONSTRAINT PK_Feedback_Angajati PRIMARY KEY (id_feedback)
	);

CREATE TABLE Angajati (
    id_angajat INT NOT NULL,
    nume_angajat VARCHAR(255),
    functie VARCHAR (100),
    data_angajare DATE,
    salariu NUMERIC(10, 2),
	CONSTRAINT PK_Angajati PRIMARY KEY (id_angajat)
);

CREATE TABLE Cititori (
    id_cititor INT NOT NULL,
	id_categorie INT,
    nume_cititor VARCHAR (255),
    varsta NUMERIC (10),
    adresa_cititor VARCHAR (100),
    telefon_cititor VARCHAR (75),
    email_cititor VARCHAR(100),
	nr_carti_imprumutate_curent NUMERIC(10),
		CONSTRAINT PK_Cititori PRIMARY KEY (id_cititor)
);

CREATE TABLE Categorii_Cititori (
    id_categorie INT NOT NULL,
    max_imprumuturi NUMERIC(10),
	denumire_categorie VARCHAR (255),
	CONSTRAINT PK_Categorii_Cititori PRIMARY KEY (id_categorie)
);

CREATE TABLE Detalii_Imprumuturi (
    id_detaliu INT NOT NULL,
	id_imprumut INT,
	 id_copie INT,
    data_returnare_prevazuta DATE,
    data_returnare_realizata DATE,
    CONSTRAINT PK_Detalii_Imprumuturi PRIMARY KEY (id_detaliu)
);

CREATE TABLE Operatiuni_Imprumuturi (
    id_operatiune INT NOT NULL,
	id_imprumut INT,
    tip_operatiune VARCHAR (100),
    ora_operatiune TIMESTAMP,
    CONSTRAINT PK_Operatiuni_Imprumuturi PRIMARY KEY (id_operatiune)
);

CREATE TABLE Review_uri (
    id_review INT NOT NULL,
	id_cititor INT,
	id_carte INT,
    rating NUMERIC(10),
    comentarii VARCHAR(255),
    data_review TIMESTAMP,
     CONSTRAINT PK_Review_uri PRIMARY KEY (id_review)
);

CREATE TABLE Copii_Carte (
    id_copie INT NOT NULL,
	id_carte INT,
    Cota VARCHAR(100),
    an_publicare DATE,
    nr_disponibile NUMERIC (10),
	CONSTRAINT PK_Copii_Carte PRIMARY KEY (id_copie)
);


CREATE TABLE Autori_Carte (
    id_autor INT,
    id_carte INT,
    CONSTRAINT PK_Autori_Carte PRIMARY KEY (id_autor, id_carte)
);


-- legatura dintre tabele
--carti are fk din edituri si gen???
ALTER TABLE Carti ADD CONSTRAINT FK_CartiIdEditura
    FOREIGN KEY (id_editura) REFERENCES Edituri(id_editura) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_CartiIdEditura ON Carti(id_editura);

ALTER TABLE Carti ADD CONSTRAINT FK_CartiIdGen
    FOREIGN KEY (id_gen) REFERENCES Genuri(id_gen) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_CartiIdGen ON Carti(id_gen);
-- 1.periodice are fk din edituri
ALTER TABLE Periodice ADD CONSTRAINT FK_PeriodiceIdEditura
    FOREIGN KEY (id_editura) REFERENCES Edituri(id_editura) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_PeriodiceIdEditura ON Periodice(id_editura);
-- detalii periodice are fk din periodice??
ALTER TABLE Detalii_Periodice ADD CONSTRAINT FK_Detalii_PeriodiceIdPeriodic
    FOREIGN KEY (id_periodic) REFERENCES Periodice(id_periodic) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Detalii_PeriodiceIdPeriodic ON Periodice(id_periodic);
-- penalizari are fk din cititori si imprumuturi??
ALTER TABLE Penalizari ADD CONSTRAINT FK_PenalizariIdCititor
    FOREIGN KEY (id_cititor) REFERENCES Cititori(id_cititor) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_PenalizariIdCititor ON Penalizari(id_cititor);

ALTER TABLE Penalizari ADD CONSTRAINT FK_PenalizariIdImprumut
    FOREIGN KEY (id_imprumut) REFERENCES Imprumuturi(id_imprumut) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_PenalizariIdImprumut ON Penalizari(id_imprumut);
-- carti_afectate are fk din copie_carte si cititori??
ALTER TABLE Carti_Afectate ADD CONSTRAINT FK_Carti_AfectateIdCopie
    FOREIGN KEY (id_copie) REFERENCES Copii_Carte(id_copie) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Carti_AfectateIdCopie ON Carti_Afectate(id_copie);

ALTER TABLE Carti_Afectate ADD CONSTRAINT FK_Carti_AfectateIdCititor
    FOREIGN KEY (id_cititor) REFERENCES Cititori(id_cititor) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Carti_AfectateIdCititor ON Carti_Afectate(id_cititor);
-- imprumuturi are fk din  cititor si angajat???

ALTER TABLE Imprumuturi ADD CONSTRAINT FK_ImprumuturiIdCititor
    FOREIGN KEY (id_cititor) REFERENCES Cititori(id_cititor) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_ImprumuturiIdCititor ON Imprumuturi(id_cititor);

ALTER TABLE Imprumuturi ADD CONSTRAINT FK_ImprumuturiIdAngajat
    FOREIGN KEY (id_angajat) REFERENCES Angajati(id_angajat) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_ImprumuturiIdAngajat ON Imprumuturi(id_angajat);
-- feedback_angajat are fk din angajat si cititor??
ALTER TABLE Feedback_Angajati ADD CONSTRAINT FK_Feedback_AngajatiIdAngajat
    FOREIGN KEY (id_angajat) REFERENCES Angajati(id_angajat) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Feedback_AngajatiIdAngajat ON Feedback_Angajati(id_angajat);

ALTER TABLE Feedback_Angajati ADD CONSTRAINT FK_Feedback_AngajatiIdCititor
    FOREIGN KEY (id_cititor) REFERENCES Cititori(id_cititor) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Feedback_AngajatiIdCititor ON Feedback_Angajati(id_cititor);
--cititori are fk din cititori_categorie?
ALTER TABLE Cititori ADD CONSTRAINT FK_CititoriIdCategorie
    FOREIGN KEY (id_categorie) REFERENCES Categorii_Cititori(id_categorie) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_CititoriIdCategorie ON Cititori(id_categorie);
-- detalii_imprumuturi are fk din imprumuturi si copie carte?
ALTER TABLE Detalii_Imprumuturi ADD CONSTRAINT FK_Detalii_ImprumuturiIdCopie
    FOREIGN KEY (id_copie) REFERENCES Copii_Carte(id_copie) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Detalii_ImprumuturiIdCopie ON Detalii_Imprumuturi(id_copie);

ALTER TABLE Detalii_Imprumuturi ADD CONSTRAINT FK_Detalii_ImprumuturiIdImprumut
    FOREIGN KEY (id_imprumut) REFERENCES Imprumuturi(id_imprumut) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Detalii_ImprumuturiIdImprumut ON Detalii_Imprumuturi(id_imprumut);
-- operatiuni_imprumuturi are fk cu imprumuturi?
ALTER TABLE Operatiuni_Imprumuturi ADD CONSTRAINT FK_Operatiuni_ImprumuturiIdImprumut
    FOREIGN KEY (id_imprumut) REFERENCES Imprumuturi(id_imprumut) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Operatiuni_ImprumuturiIdImprumut ON Operatiuni_Imprumuturi(id_imprumut);
--review are fk din carti si cititori??
ALTER TABLE Review_uri ADD CONSTRAINT FK_Review_uriIdCititor
    FOREIGN KEY (id_cititor) REFERENCES Cititori(id_cititor) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Review_uriIdCititor ON Review_uri(id_cititor);

ALTER TABLE Review_uri ADD CONSTRAINT FK_Review_uriIdCarte
    FOREIGN KEY (id_carte) REFERENCES Carti(id_carte) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Review_uriIdCarte ON Review_uri(id_carte);
-- copii_carte are fk din carte?
ALTER TABLE Copii_Carte ADD CONSTRAINT FK_Copii_CarteIdCarte
    FOREIGN KEY (id_carte) REFERENCES Carti(id_carte) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Copii_CarteIdCarte ON Copii_Carte(id_carte);

-- carti_autori are fk din autori si carti++
ALTER TABLE Autori_Carte ADD CONSTRAINT FK_Autori_CarteIdCarte
    FOREIGN KEY (id_carte) REFERENCES Carti(id_carte) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Autori_CarteIdCarte ON Autori_Carte(id_carte);

ALTER TABLE Autori_Carte ADD CONSTRAINT FK_Autori_CarteIdAutor
    FOREIGN KEY (id_autor) REFERENCES Autori(id_autor) ON DELETE NO ACTION ON UPDATE NO ACTION;
CREATE INDEX IDX_Autori_CarteIdAutor ON Autori_Carte(id_autor);


INSERT INTO Genuri (id_gen, denumire_gen) VALUES
(11, 'Ficțiune'),
(12, 'Istorie'),
(13, 'Știință'),
(14, 'Artă'),
(15, 'Tehnologie'),
(16, 'Biografie'),
(17, 'Psihologie'),
(18, 'Literatură'),
(19, 'Fantasy'),
(110, 'Jurnalism'),
(111, 'Filosofie'),
(112, 'Religie'),
(113, 'Politică'),
(114, 'Economie'),
(115, 'Educație'),
(116, 'Afaceri'),
(117, 'Medicină'),
(118, 'Matematică'),
(119, 'Sport'),
(120, 'Culinărie');



INSERT INTO Autori (id_autor, nume_autor, nationalitate, data_nastere) VALUES
(101, 'Ionescu Mihai', 'romana', '1975-03-15'),
(102, 'Popescu Andreea', 'moldoveneasca', '1980-07-22'),
(103, 'Mariscu John', 'britanica', '1968-11-09'),
(104, 'Radu Elena', 'romana', '1992-01-05'),
(105, 'Dumi Charlotte', 'american', '1985-06-19'),
(106, 'Rogrigos Cristian', 'spaniola', '1970-08-30'),
(107, 'Neagu Alina', 'romana', '1988-04-12'),
(108, 'Negrii Constantin', 'moldoveneasca', '1979-09-25'),
(109, 'Merlo Maria', 'italiana', '1995-12-03'),
(1010, 'Vasilescu Daniel', 'romana', '1983-02-14'),
(1011, 'Kovacs Istvan', 'maghiara', '1990-03-11'),
(1012, 'Dragović Ana', 'sarba', '1972-07-08'),
(1013, 'Peterson Lars', 'suedeza', '1965-05-22'),
(1014, 'O’Connor Fiona', 'irlandeza', '1998-10-17'),
(1015, 'Matsuda Akira', 'japoneza', '1981-12-29'),
(1016, 'Chen Li', 'chineza', '1976-04-04'),
(1017, 'Garcia Sofia', 'mexicana', '1994-11-05'),
(1018, 'Bălan Gabriel', 'romana', '1987-03-21'),
(1019, 'Nicoară Raluca', 'moldoveneasca', '1978-09-01'),
(1020, 'Pavel Mihnea', 'bulgara', '1984-06-14');


INSERT INTO Edituri (id_editura, nume_editura) VALUES
(201, 'Editura Universitară'),
(202, 'Editura Academica'),
(203, 'Editura Litera'),
(204, 'Editura Tehnica'),
(205, 'Editura Artă și Cultură'),
(206, 'Editura Științifică'),
(207, 'Editura Ficțiune'),
(208, 'Editura Istorie și Politică'),
(209, 'Editura Filosofie'),
(2010, 'Editura Medicală'),
(2011, 'Editura Educație'),
(2012, 'Editura Business'),
(2013, 'Editura Sportivă'),
(2014, 'Editura Culinărie'),
(2015, 'Editura Psihologie'),
(2016, 'Editura Fantasy World'),
(2017, 'Editura Religie'),
(2018, 'Editura Jurnalism'),
(2019, 'Editura Economie'),
(2020, 'Editura Literatură Universală');


INSERT INTO Carti (id_carte, id_editura, id_gen, ISBN, titlu, nr_pagini, tag, rating_carte) VALUES
(301, 208, 12, '978-1234567890', 'Istoria României', 300, 'Istorie', 4.5),
(302, 206, 13, '978-1234567891', 'Știința Modernă', 250, 'Știință', 4.0),
(303, 205, 14, '978-1234567892', 'Pictura Secolului 20', 200, 'Artă', 4.7),
(304, 204, 15, '978-1234567893', 'Bazele Fizicii', 350, 'Tehnologie', 4.8),
(305, 205, 16, '978-1234567894', 'Biografia unui Geniu', 400, 'Biografie', 4.2),
(306, 209, 111, '978-1234567895', 'Filosofia Antică', 500, 'Filosofie', 4.9),
(307, 2017, 112, '978-1234567896', 'Religie și Cultură', 180, 'Religie', 4.1),
(308, 2020, 18, '978-1234567897', 'Literatura Română', 450, 'Literatură', 4.6),
(309, 2016, 19, '978-1234567898', 'Fantasy World', 600, 'Fantasy', 4.3),
(3010, 2015, 17, '978-1234567899', 'Psihologia Pozitivă', 300, 'Psihologie', 4.4),
(3011, 2013, 119, '978-1234567810', 'Sportivi de Legendă', 250, 'Sport', 4.0),
(3012, 2014, 120, '978-1234567811', 'Rețete Internaționale', 280, 'Culinărie', 4.7),
(3013, 2011, 118, '978-1234567812', 'Matematică pentru Începători', 220, 'Matematică', 4.8),
(3014, 208, 113, '978-1234567813', 'Istorie Politică', 340, 'Politică', 4.2),
(3015, 2019, 114, '978-1234567814', 'Bazele Economiei', 400, 'Economie', 4.6),
(3016, 2011, 115, '978-1234567815', 'Educația Modernă', 360, 'Educație', 4.5),
(3017, 2012, 116, '978-1234567816', 'Management de Succes', 500, 'Afaceri', 4.3),
(3018, 2010, 117, '978-1234567817', 'Medicina pentru Toți', 600, 'Medicină', 4.9),
(3019, 2018, 110, '978-1234567818', 'Jurnalism Modern', 300, 'Jurnalism', 4.1),
(3020, 205, 14, '978-1234567819', 'Arta de a Scrie', 400, 'Artă', 4.8);



INSERT INTO Periodice (id_periodic, id_editura, titlu, volum, numar, nr_pagini, data_publicare) VALUES
(401, 206, 'Revista de Știință', 5.0, 2, 50, '2024-10-15'),
(402, 208, 'Gazeta Istorică', 10.0, 1, 60, '2024-11-01'),
(403, 2020, 'Literatura Contemporană', 3.0, 12, 45, '2024-09-10'),
(404, 204, 'Revista Tehnologică', 7.0, 3, 80, '2024-08-05'),
(405, 205, 'Revista de Artă', 12.0, 5, 40, '2024-07-20'),
(406, 204, 'Tehnologia Viitorului', 6.0, 6, 55, '2024-06-15'),
(407, 206, 'Știința Astăzi', 4.0, 7, 65, '2024-05-25'),
(408, 208, 'Istoria secolului 21', 8.0, 4, 70, '2024-04-18'),
(409, 205, 'Inovație în Artă', 11.0, 8, 60, '2024-03-10'),
(4010, 2020, 'Cultura Digitală', 9.0, 9, 85, '2024-02-05'),
(4011, 209, 'Filosofie Aplicată', 7.0, 10, 50, '2024-01-20'),
(4012, 208, 'Războiul din Istorie', 15.0, 11, 100, '2023-12-25'),
(4013, 2010, 'Medicina în Mâinile Tale', 6.0, 2, 40, '2023-11-30'),
(4014, 2012, 'Gândire Strategică', 5.0, 4, 60, '2023-10-12'),
(4015, 2016, 'Povești din Lumea Fantasy', 3.0, 1, 50, '2023-09-07'),
(4016, 206, 'Explorând Universul', 10.0, 3, 80, '2023-08-20'),
(4017, 208, 'Istoria Artefactelor', 12.0, 5, 75, '2023-07-15'),
(4018, 2011, 'Fiecare Zi un Pas', 9.0, 7, 60, '2023-06-10'),
(4019, 2013, 'Sportivii de Mâine', 5.0, 9, 50, '2023-05-01'),
(4020, 204, 'Tehnologia în Viitorul Aproape', 4.0, 8, 90, '2023-04-15');

 

INSERT INTO Detalii_Periodice (id_detaliu_periodic, id_periodic, numar, tematica, nr_pagini, data_aparitie) VALUES
(41, 401, 2, 'Știință Aplicată', 50, '2024-10-15'),
(42, 402, 1, 'Istorie Modernă', 60, '2024-11-01'),
(43, 403, 12, 'Literatură', 45, '2024-09-10'),
(44, 404, 3, 'Tehnologie Avansată', 80, '2024-08-05'),
(45, 405, 5, 'Artă Contemporană', 40, '2024-07-20'),
(46, 406, 6, 'Tehnologii emergente', 55, '2024-06-15'),
(47, 407, 7, 'Știință modernă', 65, '2024-05-25'),
(48, 408, 4, 'Istorie secolul XXI', 70, '2024-04-18'),
(49, 409, 8, 'Artă digitală', 60, '2024-03-10'),
(410, 4010, 9, 'Inovații tehnologice', 85, '2024-02-05'),
(411, 4011, 10, 'Filosofie și gândire critică', 50, '2024-01-20'),
(412, 4012, 11, 'Istorie mondială', 100, '2023-12-25'),
(413, 4013, 2, 'Medicină și sănătate', 40, '2023-11-30'),
(414, 4014, 4, 'Strategii economice', 60, '2023-10-12'),
(415, 4015, 1, 'Povești fantastice', 50, '2023-09-07'),
(416, 4016, 3, 'Astronomie și științe', 80, '2023-08-20'),
(417, 4017, 5, 'Istorie antică', 75, '2023-07-15'),
(418, 4018, 7, 'Psihologie și comportament', 60, '2023-06-10'),
(419, 4019, 9, 'Sport de performanță', 50, '2023-05-01'),
(420, 4020, 8, 'Tehnologii emergente', 90, '2023-04-15');

INSERT INTO Categorii_Cititori (id_categorie, denumire_categorie, max_imprumuturi) VALUES
(81, 'Adulți 26-55', 4 ),
(82, 'Tineri 12-25', 3),
(83, 'Seniori 56<', 4),
(84, 'Profesori', 10),
(85, 'Studenți', 5),
(86, 'Cititori frecvenți',10 ),
(87, 'Cititori ocazionali', 2);

INSERT INTO Cititori (id_cititor, id_categorie, nume_cititor, varsta, adresa_cititor, telefon_cititor, email_cititor, nr_carti_imprumutate_curent) VALUES
(8011, 81, 'Raluca Ene', 34, 'Str. Păcii nr. 12, București', '0745123456', 'raluca.ene@gmail.com', 3),
(8012, 83, 'Ion Stoica', 58, 'Str. Unirii nr. 45, Cluj-Napoca', '0732123456', 'ion.stoica@gmail.com', NULL),
(8013, 85, 'Ana Marcu', 21, 'Str. Speranței nr. 7, Iași', '0756123456', 'ana.marcu@gmail.com', 1),
(8014, 81, 'Victor Pop', 40, 'Str. Libertății nr. 20, Brașov', '0767123456', 'victor.pop@gmail.com', 4),
(8015, 81, 'Carmen Gheorghe', 36, 'Str. Dunării nr. 14, Constanța', '0748123456', 'carmen.gheorghe@gmail.com', 2),
(8016, 82, 'Daniela Banu', 24, 'Str. Revoluției nr. 3, Sibiu', '0739123456', 'daniela.banu@gmail.com', NULL),
(8017, 83, 'Gheorghe Ilie', 65, 'Str. Viilor nr. 1, Timișoara', '0721123456', 'gheorghe.ilie@gmail.com', 5),
(8018, 81, 'Simona Badea', 33, 'Str. Mioriței nr. 22, Oradea', '0772123456', 'simona.badea@gmail.com', NULL),
(8019, 84, 'Marian Luca', 45, 'Str. Plopilor nr. 9, Pitești', '0783123456', 'marian.luca@gmail.com', 8),
(8020, 82, 'Laura Cristea', 19, 'Str. Cerbului nr. 18, Craiova', '0714123456', 'laura.cristea@gmail.com', 1),
(8021, 83, 'Dumitru Iancu', 55, 'Str. Cireșului nr. 6, București', '0795123456', 'dumitru.iancu@gmail.com', NULL),
(8022, 84, 'Andreea Vasile', 38, 'Str. Alunișului nr. 15, Galați', '0706123456', 'andreea.vasile@gmail.com', 7),
(8023, 82, 'Bogdan Ene', 22, 'Str. Prutului nr. 11, Cluj-Napoca', '0757123456', 'bogdan.ene@gmail.com', NULL),
(8024, 81, 'Mihai Dobre', 42, 'Str. Fagului nr. 30, Brașov', '0768123456', 'mihai.dobre@gmail.com', 4),
(8025, 83, 'Veronica Toma', 67, 'Str. Someșului nr. 4, Iași', '0779123456', 'veronica.toma@gmail.com', 5);

INSERT INTO Angajati (id_angajat, nume_angajat, functie, data_angajare, salariu) VALUES
(701, 'Popescu Andrei', 'Librar', '2022-01-15', 3000.00),
(702, 'Ionescu Maria', 'Bibliotecar', '2021-11-20', 3500.00),
(703, 'Vasilescu Ion', 'Director', '2020-03-10', 5000.00),
(704, 'Munteanu Elena', 'Asistent', '2022-05-01', 2800.00),
(705, 'Georgescu Andra', 'Administrator', '2021-07-30', 3200.00),
(706, 'Constantin Florin', 'Librar', '2023-02-12', 2900.00),
(707, 'Dumitru Alexandra', 'Bibliotecar', '2022-09-15', 3300.00),
(708, 'Nistor Cosmin', 'Asistent', '2023-01-20', 2600.00),
(709, 'Popa Loredana', 'Administrator', '2021-10-10', 3100.00),
(7010, 'Sima Gheorghe', 'Director', '2019-06-25', 6000.00);

INSERT INTO Copii_Carte (id_copie, id_carte, Cota, an_publicare, nr_disponibile) VALUES
(55, 301, 'A1', '2020-06-15', 10),
(56, 301, 'A2', '2021-05-20', 10),
(57, 301, 'A3', '2022-07-10', 10),
(58, 301, 'A4', '2023-11-30', 10),
(59, 301, 'A5', '2024-03-25', 10),

(510, 302, 'B1', '2020-08-12', 10),
(511, 302, 'B2', '2021-01-15', 10),
(512, 302, 'B3', '2022-04-10', 10),
(513, 302, 'B4', '2023-02-20', 10),
(514, 302, 'B5', '2024-12-05', 10),

(515, 303, 'C1', '2020-10-01', 10),
(516, 303, 'C2', '2021-09-22', 10),
(517, 303, 'C3', '2022-06-05', 10),
(518, 303, 'C4', '2023-04-10', 10),
(519, 303, 'C5', '2024-07-20', 10),

(520, 304, 'D1', '2020-05-30', 10),
(521, 304, 'D2', '2021-02-15', 10),
(522, 304, 'D3', '2022-11-10', 10),
(523, 304, 'D4', '2023-09-05', 10),
(524, 304, 'D5', '2024-01-12', 10),

(525, 305, 'E1', '2020-06-15', 10),
(526, 305, 'E2', '2021-05-20', 10),
(527, 305, 'E3', '2022-07-10', 10),
(528, 305, 'E4', '2023-11-30', 10),
(529, 305, 'E5', '2024-03-25', 10),

(530, 306, 'F1', '2020-08-12', 10),
(531, 306, 'F2', '2021-01-15', 10),
(532, 306, 'F3', '2022-04-10', 10),
(533, 306, 'F4', '2023-02-20', 10),
(534, 306, 'F5', '2024-12-05', 10),

(535, 307, 'G1', '2020-10-01', 10),
(536, 307, 'G2', '2021-09-22', 10),
(537, 307, 'G3', '2022-06-05', 10),
(538, 307, 'G4', '2023-04-10', 10),
(539, 307, 'G5', '2024-07-20', 10),

(540, 308, 'H1', '2020-05-30', 10),
(541, 308, 'H2', '2021-02-15', 10),
(542, 308, 'H3', '2022-11-10', 10),
(543, 308, 'H4', '2023-09-05', 10),
(544, 308, 'H5', '2024-01-12', 10),

(545, 309, 'I1', '2020-06-15', 10),
(546, 309, 'I2', '2021-05-20', 10),
(547, 309, 'I3', '2022-07-10', 10),
(548, 309, 'I4', '2023-11-30', 10),
(549, 309, 'I5', '2024-03-25', 10),

(550, 3010, 'J1', '2020-08-12', 10),
(551, 3010, 'J2', '2021-01-15', 10),
(552, 3010, 'J3', '2022-04-10', 10),
(553, 3010, 'J4', '2023-02-20', 10),
(554, 3010, 'J5', '2024-12-05', 10);



INSERT INTO Imprumuturi (id_imprumut, id_cititor, id_angajat, data_imprumut, data_returnare, nr_carti_imprumutate, nr_carti_restituite) VALUES
(601, 8015, 707, '2023-11-10', '2023-11-15', 2, 2),
(602, 8020, 704, '2024-08-17', '2024-08-20', 2, 2),
(603, 8017, 704, '2024-09-10', '2024-09-24', 3, 3),
(604, 8016, 707, '2024-08-05', '2024-08-19', 2, 2),
(605, 8011, 7010, '2024-07-20', '2024-08-03', 1, 1),
(606, 8017, 7010, '2024-10-05', '2024-10-10', 2, 2),
(607, 8019, 709, '2024-09-09', '2024-09-15', 4, 4),
(608, 8024, 708, '2024-04-25', '2024-05-09', 3, 3),
(609, 8024, 706, '2024-07-20', '2024-07-25', 1, 1),
(6010, 8011, 706, '2024-02-05', '2024-02-19', 3, 3),
(6011, 8015, 705, '2024-01-20', '2024-02-03', 3, 3),
(6012, 8011, 701, '2023-12-25', '2024-01-08', 2, 2),
(6013, 8016, 702, '2023-11-05', '2023-11-19', 2, 2),
(6014, 8018, 702, '2023-10-12', '2023-10-26', 3, 3),
(6015, 8014, 703, '2023-09-22', '2023-10-06', 3, 3),
(6016, 8013, 703, '2023-08-15', '2023-08-29', 4, 4),
(6017, 8019, 705, '2023-07-20', '2023-07-22', 1, 1),
(6018, 8017, 705, '2023-06-10', '2023-06-24', 3, 3),
(6019, 8020, 706, '2023-05-25', '2023-06-08', 2, 2),
(6020, 8012, 706, '2023-04-12', '2023-04-26', 1, 1),
(6021, 8013, 708, '2024-11-12', NULL, 2, NULL),
(6022, 8011, 709, '2024-12-12', NULL, 3, NULL),
(6023, 8014, 705, '2024-11-22', NULL, 1, NULL),
(6024, 8015, 701, '2024-12-02', NULL, 2, NULL),
(6025, 8017, 705, '2024-12-05', NULL, 1, NULL),
(6026, 8019, 707, '2024-12-02', NULL, 2, NULL),
(6027, 8020, 707, '2024-10-20', NULL, 2, NULL),
(6028, 8022, 703, '2024-10-29', NULL, 2, NULL),
(6029, 8024, 702, '2024-11-17', NULL, 1, NULL),
(6030, 8025, 707, '2024-09-28', NULL, 1, NULL);



INSERT INTO Penalizari (id_penalizare, id_cititor, id_imprumut, valoare_penalizare, motiv_penalizare, data_penalizare) VALUES
(501, 8011, 604, 15.0, 'Întârziere returnare carte', '2024-12-01'),
(502, 8021, 605, 10.0, 'Carte deteriorată', '2024-11-20'),
(503, 8023, 607, 20.0, 'Întârziere returnare carte', '2024-10-15'),
(504, 8024, 608, 25.0, 'Carte deteriorată', '2024-09-10'),
(505, 8025, 6010, 30.0, 'Întârziere returnare carte', '2024-08-05'),
(506, 8016, 6011, 10.0, 'Întârziere returnare carte', '2024-07-20'),
(507, 8017, 6012, 5.0, 'Carte pierdută', '2024-06-10'),
(508, 8018, 6013, 15.0, 'Întârziere returnare carte', '2024-05-15'),
(509, 8019, 6014, 12.0, 'Carte deteriorată', '2024-04-10'),
(5010, 8017, 6015, 18.0, 'Întârziere returnare carte', '2024-03-05'),
(5011, 8011, 6016, 20.0, 'Carte deteriorată', '2024-02-28'),
(5012, 8012, 6017, 8.0, 'Întârziere returnare carte', '2024-01-20'),
(5013, 8013, 6018, 30.0, 'Carte pierdută', '2023-12-10'),
(5014, 8014, 6019, 25.0, 'Întârziere returnare carte', '2023-11-15'),
(5015, 8015, 6020, 5.0, 'Carte deteriorată', '2023-10-01'),
(5016, 8016, 6021, 10.0, 'Întârziere returnare carte', '2023-09-25'),
(5017, 8017, 6022, 15.0, 'Carte pierdută', '2023-08-15'),
(5018, 8018, 6023, 20.0, 'Întârziere returnare carte', '2023-07-10'),
(5019, 8019, 6024, 12.0, 'Carte deteriorată', '2023-06-05'),
(5020, 8020, 6025, 30.0, 'Carte pierdută', '2023-05-10');


INSERT INTO Carti_Afectate (id_carte_afectata, id_copie, id_cititor, descriere_stare, tip_afectare, data_afectare, cost_reparare) VALUES
(41, 55, 8015, 'Pagini rupte', 'deteriorata', '2023-11-15', 50.00),
(42, 56, 8017, 'Coperta deteriorată', 'deteriorata', '2024-10-10', 30.00),
(43, 57, 8019, 'Pagini lipite', 'deteriorata', '2024-09-15', 40.00),
(44, 58, 8020, 'Pierduta', 'pierduta', '2024-08-20', 20.00),
(45, 59, 8024, 'Deteriorare la colțuri', 'deteriorata', '2024-07-25', 15.00);

INSERT INTO Feedback_Angajati (id_feedback, id_angajat, id_cititor,  data_feedback, feedback) VALUES
(71, 707, 8015, '2023-11-10', 'Angajat foarte responsabil și eficient.'),
(72, 704, 8020, '2024-08-20', 'Necesită îmbunătățirea comunicării cu colegii.'),
(73, 704, 8017, '2024-09-24', 'Lucrează bine sub presiune.'),
(74, 707, 8016, '2024-08-19', 'Este un angajat dedicat și punctual.'),
(75, 709, 8019, '2024-09-15', 'Ar trebui să îmbunătățească gestionarea timpului.'),
(76, 706, 8024, '2024-07-25', 'Este foarte atent la detalii.'),
(77, 703, 8014, '2023-10-06', 'Comunicarea cu clienții este excepțională.'),
(78, 702, 8018, '2023-10-26', 'Demonstrând abilități excelente de leadership.'),
(79, 701, 8011, '2024-01-08', 'Pune un mare accent pe colaborare.'),
(710, 7010, 8017, '2024-10-10', 'Angajat foarte organizat și eficient.');

INSERT INTO Detalii_Imprumuturi (id_detaliu, id_copie, id_imprumut, data_returnare_prevazuta, data_returnare_realizata)
VALUES
(61, 55, 601, '2023-11-10'::DATE + INTERVAL '14 days', '2023-11-15'),
(62, 58, 601, '2023-11-10'::DATE + INTERVAL '14 days', '2023-11-15'),
(63, 58, 602, '2024-08-17'::DATE + INTERVAL '14 days', '2024-08-20'),
(64, 55, 602, '2024-08-17'::DATE + INTERVAL '14 days', '2024-08-20'),
(65, 59, 603, '2024-09-10'::DATE + INTERVAL '14 days', '2024-09-24'),
(66, 545, 603, '2024-09-10'::DATE + INTERVAL '14 days', '2024-09-24'),
(67, 539, 603, '2024-09-10'::DATE + INTERVAL '14 days', '2024-09-24'),
(68, 539, 604, '2024-08-05'::DATE + INTERVAL '14 days', '2024-08-19'),
(69, 527, 604, '2024-08-05'::DATE + INTERVAL '14 days', '2024-08-19'),
(610, 55, 605, '2024-07-20'::DATE + INTERVAL '14 days', '2024-08-03'),
(611, 56, 606, '2024-10-05'::DATE + INTERVAL '14 days', '2024-10-10'),
(612, 546, 606, '2024-10-05'::DATE + INTERVAL '14 days', '2024-10-10'),
(613, 57, 607, '2024-09-09'::DATE + INTERVAL '14 days', '2024-09-15'),
(614, 547, 607, '2024-09-09'::DATE + INTERVAL '14 days', '2024-09-15'),
(615, 537, 607, '2024-09-09'::DATE + INTERVAL '14 days', '2024-09-15'),
(616, 517, 607, '2024-09-09'::DATE + INTERVAL '14 days', '2024-09-15'),
(617, 548, 608, '2024-04-25'::DATE + INTERVAL '14 days', '2024-05-09'),
(618, 542, 608, '2024-04-25'::DATE + INTERVAL '14 days', '2024-05-09'),
(619, 528, 608, '2024-04-25'::DATE + INTERVAL '14 days', '2024-05-09'),
(620, 59, 609, '2024-07-20'::DATE + INTERVAL '14 days', '2024-07-25'),
(621, 510, 6010, '2024-02-05'::DATE + INTERVAL '14 days', '2024-02-19'),
(622, 512, 6010, '2024-02-05'::DATE + INTERVAL '14 days', '2024-02-19'),
(623, 522, 6010, '2024-02-05'::DATE + INTERVAL '14 days', '2024-02-19'),
(624, 511, 6011, '2024-01-20'::DATE + INTERVAL '14 days', '2024-02-03'),
(625, 521, 6011, '2024-01-20'::DATE + INTERVAL '14 days', '2024-02-03'),
(626, 531, 6011, '2024-01-20'::DATE + INTERVAL '14 days', '2024-02-03'),
(627, 522, 6012, '2023-12-25'::DATE + INTERVAL '14 days', '2024-01-08'),
(628, 512, 6012, '2023-12-25'::DATE + INTERVAL '14 days', '2024-01-08'),
(629, 513, 6013, '2023-11-05'::DATE + INTERVAL '14 days', '2023-11-19'),
(630, 523, 6013, '2023-11-05'::DATE + INTERVAL '14 days', '2023-11-19'),
(631, 514, 6014, '2023-10-12'::DATE + INTERVAL '14 days', '2023-10-26'),
(632, 524, 6014, '2023-10-12'::DATE + INTERVAL '14 days', '2023-10-26'),
(633, 534, 6014, '2023-10-12'::DATE + INTERVAL '14 days', '2023-10-26'),
(634, 515, 6015, '2023-09-22'::DATE + INTERVAL '14 days', '2023-10-06'),
(635, 525, 6015, '2023-09-22'::DATE + INTERVAL '14 days', '2023-10-06'),
(636, 545, 6015, '2023-09-22'::DATE + INTERVAL '14 days', '2023-10-06'),
(637, 516, 6016, '2023-08-15'::DATE + INTERVAL '14 days', '2023-08-29'),
(638, 536, 6016, '2023-08-15'::DATE + INTERVAL '14 days', '2023-08-29'),
(639, 526, 6016, '2023-08-15'::DATE + INTERVAL '14 days', '2023-08-29'),
(640, 546, 6016, '2023-08-15'::DATE + INTERVAL '14 days', '2023-08-29'),
(641, 517, 6017, '2023-08-03'::DATE + INTERVAL '14 days', '2023-07-22'),
(642, 518, 6018, '2023-06-24'::DATE + INTERVAL '14 days', '2023-06-24'),
(643, 528, 6018, '2023-06-24'::DATE + INTERVAL '14 days', '2023-06-24'),
(644, 548, 6018, '2023-06-24'::DATE + INTERVAL '14 days', '2023-06-24'),
(645, 519, 6019, '2023-06-08'::DATE + INTERVAL '14 days', '2023-06-08'),
(646, 549, 6019, '2023-06-08'::DATE + INTERVAL '14 days', '2023-06-08'),
(647, 520, 6020, '2023-04-26'::DATE + INTERVAL '14 days', '2023-04-26'),
(648, 521, 6021, '2024-11-26'::DATE + INTERVAL '14 days', NULL),
(649, 511, 6021, '2024-11-26'::DATE + INTERVAL '14 days', NULL),
(650, 529, 6022, '2024-12-26'::DATE + INTERVAL '14 days', NULL),
(651, 549, 6022, '2024-12-26'::DATE + INTERVAL '14 days', NULL),
(652, 519, 6022, '2024-12-26'::DATE + INTERVAL '14 days', NULL),
(653, 530, 6023, '2024-12-06'::DATE + INTERVAL '14 days', NULL),
(654, 538, 6024, '2024-12-16'::DATE + INTERVAL '14 days', NULL),
(655, 528, 6024, '2024-12-16'::DATE + INTERVAL '14 days', NULL),
(656, 539, 6025, '2024-12-19'::DATE + INTERVAL '14 days', NULL),
(657, 554, 6026, '2024-12-16'::DATE + INTERVAL '14 days', NULL),
(658, 534, 6026, '2024-12-16'::DATE + INTERVAL '14 days', NULL),
(659, 551, 6027, '2024-11-03'::DATE + INTERVAL '14 days', NULL),
(660, 552, 6027, '2024-11-03'::DATE + INTERVAL '14 days', NULL),
(661, 545, 6028, '2024-11-12'::DATE + INTERVAL '14 days', NULL),
(662, 520, 6028, '2024-11-12'::DATE + INTERVAL '14 days', NULL),
(663, 546, 6029, '2024-12-01'::DATE + INTERVAL '14 days', NULL),
(664, 533, 6030, '2024-10-12'::DATE + INTERVAL '14 days', NULL);



INSERT INTO Review_uri (id_review, id_cititor, id_carte, rating, comentarii, data_review) VALUES
(21, 8011, 301, 5, 'Cartea este foarte bine scrisă și utilă.', '2024-11-01'),
(22, 8022, 302, 4, 'Informativă, dar ar fi putut fi mai detaliată.', '2024-10-10'),
(23, 8023, 303, 5, 'O lucrare excelentă pentru iubitorii de filozofie.', '2024-09-25'),
(24, 8014, 304, 3, 'M-a făcut să reflectez la multe aspecte ale vieții.', '2024-09-10'),
(25, 8015, 305, 4, 'O poveste interesantă, dar finalul nu m-a convins.', '2024-08-15'),
(26, 8016, 306, 5, 'Cartea mi-a schimbat perspectiva despre știință.', '2024-07-30'),
(27, 8017, 307, 3, 'Unele părți au fost plictisitoare.', '2024-07-01'),
(28, 8018, 308, 4, 'Un subiect fascinant, dar stilul de scriere a fost prea tehnic.', '2024-06-05'),
(29, 8019, 309, 5, 'O poveste care te captivează de la început la sfârșit.', '2024-05-12');
  

INSERT INTO Operatiuni_Imprumuturi (id_operatiune, id_imprumut, tip_operatiune, ora_operatiune) VALUES
(6001, 601, 'Imprumut', '2023-11-10 08:30:00'),
(6002, 601, 'Returnare', '2023-11-15 10:00:00'),
(6003, 602, 'Imprumut', '2024-08-17 09:30:00'),
(6004, 602, 'Returnare', '2024-08-20 12:00:00'),
(6005, 603, 'Imprumut', '2024-09-10 10:45:00'),
(6006, 603, 'Returnare', '2024-09-24 14:00:00'),
(6007, 604, 'Imprumut', '2024-08-05 11:00:00'),
(6008, 604, 'Returnare', '2024-08-19 16:30:00'),
(6009, 605, 'Imprumut', '2024-07-20 08:15:00'),
(6010, 605, 'Returnare', '2024-08-03 12:45:00'),
(6011, 606, 'Imprumut', '2024-10-05 09:00:00'),
(6012, 606, 'Returnare', '2024-10-10 14:30:00'),
(6013, 607, 'Imprumut', '2024-09-09 15:15:00'),
(6014, 607, 'Returnare', '2024-09-15 11:30:00'),
(6015, 608, 'Imprumut', '2024-04-25 10:45:00'),
(6016, 608, 'Returnare', '2024-05-09 16:00:00'),
(6017, 609, 'Imprumut', '2024-07-20 08:30:00'),
(6018, 609, 'Returnare', '2024-07-25 14:15:00'),
(6019, 6010, 'Imprumut', '2024-02-05 12:00:00'),
(6020, 6010, 'Returnare', '2024-02-19 13:30:00'),
(6021, 6011, 'Imprumut', '2024-01-20 09:15:00'),
(6022, 6011, 'Returnare', '2024-02-03 11:45:00'),
(6023, 6012, 'Imprumut', '2023-12-25 14:30:00'),
(6024, 6012, 'Returnare', '2024-01-08 15:00:00'),
(6025, 6013, 'Imprumut', '2023-11-05 08:00:00'),
(6026, 6013, 'Returnare', '2023-11-19 10:30:00'),
(6027, 6014, 'Imprumut', '2023-10-12 11:45:00'),
(6028, 6014, 'Returnare', '2023-10-26 12:15:00'),
(6029, 6015, 'Imprumut', '2023-09-22 09:30:00'),
(6030, 6015, 'Returnare', '2023-10-06 16:45:00'),
(6031, 6016, 'Imprumut', '2023-08-15 08:30:00'),
(6032, 6016, 'Returnare', '2023-08-29 14:30:00'),
(6033, 6017, 'Imprumut', '2023-07-20 09:00:00'),
(6034, 6017, 'Returnare', '2023-07-22 11:30:00'),
(6035, 6018, 'Imprumut', '2023-06-10 10:00:00'),
(6036, 6018, 'Returnare', '2023-06-24 14:45:00'),
(6037, 6019, 'Imprumut', '2023-05-25 11:15:00'),
(6038, 6019, 'Returnare', '2023-06-08 15:00:00'),
(6039, 6020, 'Imprumut', '2023-04-12 09:00:00'),
(6040, 6020, 'Returnare', '2023-04-26 12:30:00'),
(6041, 6021, 'Imprumut', '2024-11-12 10:30:00'),
(6042, 6022, 'Imprumut', '2024-12-12 11:00:00'),
(6043, 6023, 'Imprumut', '2024-11-22 09:15:00'),
(6044, 6024, 'Imprumut', '2024-12-02 08:45:00'),
(6045, 6025, 'Imprumut', '2024-12-05 10:15:00'),
(6046, 6026, 'Imprumut', '2024-12-02 11:30:00'),
(6047, 6027, 'Imprumut', '2024-10-20 09:00:00'),
(6048, 6028, 'Imprumut', '2024-10-29 14:15:00'),
(6049, 6029, 'Imprumut', '2024-11-17 11:30:00'),
(6050, 6030, 'Imprumut', '2024-09-28 12:00:00');


INSERT INTO Autori_Carte (id_autor, id_carte) VALUES
(101, 301),
(102, 302),
(103, 303),
(104, 304),
(105, 305),
(106, 306),
(107, 307),
(108, 308),
(109, 309),
(1010, 3010),
(1011, 3011),
(1012, 3012),
(1013, 3013),
(1014, 3014),
(1015, 3015),
(1016, 3016),
(1017, 3017),
(1018, 3018),
(1019, 3019),
(1020, 3020);
