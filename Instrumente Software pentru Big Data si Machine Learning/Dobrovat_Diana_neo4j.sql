--1.Totalul cartilor imprumutate si calcularea penalizarilor totale pt fiecare cititor.

SELECT 
    c.id_cititor,
    c.nume_cititor,
    COALESCE(SUM(p.valoare_penalizare), 0) AS total_penalizari,
    COALESCE(SUM(i.nr_carti_imprumutate), 0) AS total_carti_imprumutate
FROM 
    Cititori c
LEFT JOIN 
    Penalizari p ON c.id_cititor = p.id_cititor
LEFT JOIN 
    Imprumuturi i ON c.id_cititor = i.id_cititor
GROUP BY 
    c.id_cititor, c.nume_cititor
ORDER BY 
    total_penalizari DESC;
	
	
--cypher	
	MATCH (c:Cititor)
OPTIONAL MATCH (c)-[r:IMPRUMUTAT_DE]->(i:Imprumut)
OPTIONAL MATCH (c)-[:ARE_PENALIZARE]->(p:Penalizare)
WITH c, 
     SUM(CASE WHEN r IS NOT NULL THEN SIZE(r.detalii_carti) ELSE 0 END) AS total_carti_imprumutate,
     COALESCE(SUM(TOFLOAT(p.valoare_penalizare)), 0) AS total_penalizari
RETURN c.id_cititor AS id_cititor, 
       c.nume_cititor AS nume_cititor, 
       total_penalizari, 
       total_carti_imprumutate
ORDER BY total_penalizari DESC;
	

--2. SQL: Găsește editurile care au publicat cele mai multe cărți și media a ratingurilor acestora
SELECT 
    e.id_editura,
    e.nume_editura,
    COUNT(c.id_carte) AS numar_carti_publicate,
    COALESCE(AVG(c.rating_carte), 0) AS media_ratinguri
FROM 
    Edituri e
LEFT JOIN 
    Carti c ON e.id_editura = c.id_editura
GROUP BY 
    e.id_editura, e.nume_editura
ORDER BY 
    numar_carti_publicate DESC, media_ratinguri DESC;
	
	
--------cypher	
	MATCH (e:Editura)
OPTIONAL MATCH (e)<-[:PUBLICATA_DE]-(c:Carte)
OPTIONAL MATCH (c)<-[:REVIEW_PENTRU]-(r:Review)
WITH e, 
     COUNT(DISTINCT c) AS numar_carti_publicate,
     COALESCE(AVG(TOFLOAT(r.rating)), 0) AS media_ratinguri
RETURN e.id_editura AS id_editura, 
       e.nume_editura AS nume_editura, 
       numar_carti_publicate, 
       media_ratinguri
ORDER BY numar_carti_publicate DESC, media_ratinguri DESC;
	
-------BONUS---------top 10 edituri care au publicat cele mai multe carti, in caz de egalitte se ia in considerare  ratingului
MATCH (e:Editura)
OPTIONAL MATCH (e)<-[:PUBLICATA_DE]-(c:Carte)
OPTIONAL MATCH (c)<-[:REVIEW_PENTRU]-(r:Review)
WITH e, 
     COUNT(DISTINCT c) AS numar_carti_publicate,
     COALESCE(MAX(TOFLOAT(r.rating)), 0) AS max_rating
RETURN e.id_editura AS id_editura, 
       e.nume_editura AS nume_editura, 
       numar_carti_publicate, 
       max_rating
ORDER BY numar_carti_publicate DESC, max_rating DESC
LIMIT 10;
	
		

--3.Afișează numărul de cărți afectate și cel mai frecvent tip de afectare pentru fiecare cititor
SELECT 
    c.id_cititor,
    c.nume_cititor,
    COUNT(ca.id_carte_afectata) AS numar_carti_afectate,
    (
        SELECT tip_afectare
        FROM Carti_Afectate ca2
        WHERE ca2.id_cititor = c.id_cititor
        GROUP BY tip_afectare
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS tip_afectare_frecvent
FROM 
    Cititori c
INNER JOIN 
    Carti_Afectate ca ON c.id_cititor = ca.id_cititor
GROUP BY 
    c.id_cititor, c.nume_cititor
ORDER BY 
    numar_carti_afectate DESC;
	
------------cypher	
	MATCH (c:Cititor)-[:AFECTAT]->(ca:Carte_Afectata)
WITH c, 
     COUNT(ca) AS numar_carti_afectate,
     COLLECT(ca.tip_afectare) AS tipuri_afectare
WITH c, 
     numar_carti_afectate,
     [tip IN tipuri_afectare | tip] AS lista_tipuri
WITH c, 
     numar_carti_afectate,
     REDUCE(
         acc = {tip: '', count: 0}, 
         tip IN lista_tipuri | 
         CASE 
             WHEN SIZE([x IN lista_tipuri WHERE x = tip]) > acc.count 
             THEN {tip: tip, count: SIZE([x IN lista_tipuri WHERE x = tip])}
             ELSE acc 
         END
     ).tip AS tip_afectare_frecvent
RETURN c.id_cititor AS id_cititor, 
       c.nume_cititor AS nume_cititor, 
       numar_carti_afectate, 
       tip_afectare_frecvent
ORDER BY numar_carti_afectate DESC;


	
	
---4.Distribuția angajaților și analiza salariilor pe funcții

SELECT 
    functie,
    COUNT(*) AS numar_angajati,
    MIN(salariu) AS salariu_minim,
    MAX(salariu) AS salariu_maxim,
    AVG(salariu) AS salariu_mediu
FROM 
    Angajati
GROUP BY 
    functie
ORDER BY 
    numar_angajati DESC, salariu_mediu DESC;
	
--------cypher	
MATCH (a:Angajat)
WITH a.functie AS functie, 
     COUNT(*) AS numar_angajati,
     MIN(a.salariu) AS salariu_minim,
     MAX(a.salariu) AS salariu_maxim,
     AVG(a.salariu) AS salariu_mediu
RETURN functie, numar_angajati, salariu_minim, salariu_maxim, salariu_mediu
ORDER BY numar_angajati DESC, salariu_mediu DESC;