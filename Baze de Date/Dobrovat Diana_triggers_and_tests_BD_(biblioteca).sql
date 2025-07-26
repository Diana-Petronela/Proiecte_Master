-----------------------------------------DOBROVAT DIANA-PETRONELA SIA12 (1207)---------------------------------------------------------------------
---------------------------------------------------TRIGGERE SI TESTE-------------------------------------------------------------------------------


-- Cerința 5: Evitarea duplicatelor în Autori_Carte
-- Trigger pentru evitarea duplicatelor în Autori_Carte


CREATE OR REPLACE FUNCTION evitarea_duplicatelor_autori_carte()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM Autori_Carte
        WHERE id_autor = NEW.id_autor AND id_carte = NEW.id_carte
    ) THEN
        RAISE EXCEPTION 'Duplicat detectat: autorul este deja asociat cu această carte.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trg_Evitare_Duplicat_Autori
BEFORE INSERT ON Autori_Carte
FOR EACH ROW
EXECUTE FUNCTION evitarea_duplicatelor_autori_carte();



-- TESTE cerința 5: Evitarea duplicatelor în Autori_Carte
-- Adăugăm date pentru Carti referințele existente în baza de date
-- INTO Carti (id_carte, id_editura, id_gen, ISBN, titlu, nr_pagini, tag, rating_carte)
--SELECT 1, id_editura, id_gen, '111-222', 'Carte A', 200, 'Tag A', 4.5 FROM Edituri, Genuri LIMIT 1;


INSERT INTO Autori_Carte (id_autor, id_carte)
VALUES (101, 301); -- există 


-- Adăugăm date pentru Autori referințele existente
INSERT INTO Autori_Carte (id_autor, id_carte)
SELECT id_autor, 1 FROM Autori LIMIT 1;

-- Testăm evitarea duplicatelor
-- Această comandă ar trebui să dea eroare

 INSERT INTO Autori_Carte (id_autor, id_carte) VALUES (1, 1);

-----------------------------------------------------------------------------------------------------------------------


-- Cerința 6: Calcularea automată a penalizărilor totale ale unui cititor
-- Trigger pentru calcularea automată a penalizărilor totale


CREATE OR REPLACE FUNCTION calculare_penalizari_totale()
RETURNS TRIGGER AS $$
BEGIN
    -- Actualizăm totalul penalizărilor
    UPDATE Cititori
    SET total_penalizari = COALESCE(total_penalizari, 0) + NEW.valoare_penalizare
    WHERE id_cititor = NEW.id_cititor;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trg_Calculare_Penalizari
AFTER INSERT ON Penalizari
FOR EACH ROW
EXECUTE FUNCTION calculare_penalizari_totale();



--Trigger pentru resetarea automată a penalizărilor după plată
-- Cerința 7: Resetarea automată a penalizărilor după plată
-- Adăugăm coloana total_penalizari în tabelul Cititori


ALTER TABLE Cititori
ADD COLUMN total_penalizari NUMERIC(10, 2) DEFAULT 0;

-- Creăm funcția care va fi apelată de trigger
CREATE OR REPLACE FUNCTION resetare_penalizari_safe()
RETURNS TRIGGER AS $$
BEGIN
    -- Actualizăm totalul penalizărilor și ne asigurăm că nu devine negativ
    UPDATE Cititori
    SET total_penalizari = GREATEST(COALESCE(total_penalizari, 0) - OLD.valoare_penalizare, 0)
    WHERE id_cititor = OLD.id_cititor;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Creăm trigger-ul
CREATE TRIGGER Trg_Resetare_Penalizari_Safe
AFTER DELETE ON Penalizari
FOR EACH ROW
EXECUTE FUNCTION resetare_penalizari_safe();

 
--TESTAREA  cerințelor 6 și 7: Calcularea și resetarea penalizărilor
-- Adăugăm un cititor folosind date existente în baza de date
INSERT INTO Cititori (id_cititor, nume_cititor, total_penalizari)
VALUES (1001, 'Ion Popescu', 0);

-- Adăugăm penalizări pentru cititorul cu id_cititor = 1001
INSERT INTO Penalizari (id_penalizare, id_cititor, valoare_penalizare)
VALUES (2001, 1001, 20),
       (2002, 1001, 30);

-- Verificăm totalul penalizărilor după inserări
SELECT id_cititor, total_penalizari FROM Cititori WHERE id_cititor = 1001;

-- Ștergem penalizarea de 30 pentru cititorul cu id_cititor = 1001
DELETE FROM Penalizari WHERE id_penalizare = 2002;

-- Verificăm totalul penalizărilor după ștergerea primei penalizări
SELECT id_cititor, total_penalizari FROM Cititori WHERE id_cititor = 1001;

-- Ștergem penalizarea de 20 pentru cititorul cu id_cititor = 1001
DELETE FROM Penalizari WHERE id_penalizare = 2001;

-- Verificăm totalul penalizărilor pentru a confirma că este 0
SELECT id_cititor, total_penalizari FROM Cititori WHERE id_cititor = 1001;

--------------------------------------------------------------------------------------------------------------------------------

-- Cerința 8: Actualizarea automată a numărului de exemplare deteriorate
-- Trigger pentru actualizarea numărului de exemplare deteriorate


CREATE OR REPLACE FUNCTION actualizare_exemplare_deteriorate()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Copii_Carte
    SET nr_disponibile = nr_disponibile - 1
    WHERE id_copie = NEW.id_copie;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Trg_Actualizare_Exemplare
AFTER INSERT ON Carti_Afectate
FOR EACH ROW
EXECUTE FUNCTION actualizare_exemplare_deteriorate();



-- TESTE cerința 8: Actualizarea automată a numărului de exemplare deteriorate
-- Adăugăm date pentru Carti_Afectate folosind referințele existente

INSERT INTO Copii_Carte (id_copie, id_carte, Cota, an_publicare, nr_disponibile)
VALUES (1, 1, 'A123', '2020-01-01', 10);

INSERT INTO Carti_Afectate (id_carte_afectata, id_copie, id_cititor, descriere_stare, tip_afectare, data_afectare, cost_reparare)
VALUES (1, 1, 1001, 'Coperta ruptă', 'Major', '2024-12-15', 50);

-- Verificăm actualizarea numărului de exemplare
SELECT * FROM Copii_Carte WHERE id_copie = 1;

--------------------------------------------------------------------------------------------------------------------------

--CERINTA SUPLIMENTARA (nou adaugata) 
-- Trigger pentru gestionarea cărților afectate cu tip_afectare specific
-- Cerință: Gestionarea automată a cărților pierdute/majore
-- Creăm tabelul de istoric pentru a păstra detalii despre cărțile eliminate


CREATE TABLE Istoric_Carti (
    id_carte INT,
    id_editura INT,
    id_gen INT,
    ISBN VARCHAR(75),
    titlu VARCHAR(255),
    nr_pagini INT,
    tag VARCHAR(100),
    rating_carte NUMERIC(10, 2),
    data_mutarii TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Funcția asociată trigger-ului
CREATE OR REPLACE FUNCTION gestionare_carti_afectate()
RETURNS TRIGGER AS $$
BEGIN
    -- Dacă tip_afectare este 'pierduta' sau 'major', eliminăm cartea și o mutăm în istoricul cărților
    IF NEW.tip_afectare IN ('pierduta', 'major') THEN
        -- Mutăm cartea în istoricul cărților
        INSERT INTO Istoric_Carti (id_carte, id_editura, id_gen, ISBN, titlu, nr_pagini, tag, rating_carte)
        SELECT CC.id_carte, C.id_editura, C.id_gen, C.ISBN, C.titlu, C.nr_pagini, C.tag, C.rating_carte
        FROM Copii_Carte AS CC
        JOIN Carti AS C ON C.id_carte = CC.id_carte
        WHERE CC.id_copie = NEW.id_copie;

        -- Ștergem mai întâi din Carti_Afectate pentru a elimina dependențele
        DELETE FROM Carti_Afectate
        WHERE id_copie = NEW.id_copie;

        -- Actualizăm numărul de exemplare în Copii_Carte înainte de ștergere
        UPDATE Copii_Carte
        SET nr_disponibile = nr_disponibile - 1
        WHERE id_copie = NEW.id_copie;

        -- Ștergem înregistrările din Copii_Carte
        DELETE FROM Copii_Carte
        WHERE id_copie = NEW.id_copie;

        -- Ștergem cartea din tabelul Carti
        DELETE FROM Carti
        WHERE id_carte = (
            SELECT id_carte
            FROM Copii_Carte
            WHERE id_copie = NEW.id_copie
            LIMIT 1
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Creăm trigger-ul
CREATE TRIGGER trg_gestionare_carti_afectate
AFTER INSERT ON Carti_Afectate
FOR EACH ROW
EXECUTE FUNCTION gestionare_carti_afectate();

-- Testarea trigger-ului
-- Adăugăm date în Carti_Afectate folosind valori existente
INSERT INTO Carti_Afectate (id_carte_afectata, id_copie, id_cititor, descriere_stare, tip_afectare, data_afectare, cost_reparare)
SELECT COALESCE(MAX(Carti_Afectate.id_carte_afectata), 0) + 1 AS id_carte_afectata, Copii_Carte.id_copie, 1001, 'Cartea a fost pierdută', 'pierduta', '2024-12-15', 100
FROM Copii_Carte
LEFT JOIN Carti_Afectate ON Copii_Carte.id_copie = Carti_Afectate.id_copie
WHERE Copii_Carte.id_carte IS NOT NULL
GROUP BY Copii_Carte.id_copie
LIMIT 1;

-- Verificăm istoricul cărților
SELECT * FROM Istoric_Carti;

-- Verificăm tabelul Carti pentru a confirma că a fost ștearsă
SELECT * FROM Carti;

-- Verificăm tabelul Copii_Carte pentru actualizarea nr_disponibile
SELECT * FROM Copii_Carte WHERE id_copie IN (SELECT id_copie FROM Carti_Afectate);

























