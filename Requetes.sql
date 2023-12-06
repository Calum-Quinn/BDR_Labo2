-- Point 1
SELECT DISTINCT C.*
FROM Client C
JOIN Réservation R ON C.id = R.idClient
JOIN Hôtel H ON R.idChambre = H.id
WHERE C.idVille = H.idVille;

-- Point 2
SELECT MIN(C.prixParNuit) AS prixMin, MAX(C.prixParNuit) AS prixMax, AVG(C.prixParNuit) AS prixAvg
FROM Chambre C
JOIN Hôtel H ON C.idHôtel = H.id
JOIN Ville V ON H.idVille = V.id
WHERE V.nom = 'Montreux';


-- Point 3
SELECT DISTINCT C.*
FROM Client C
JOIN Réservation R ON C.id = R.idClient
JOIN Hôtel H ON R.idChambre = H.id
WHERE H.nbEtoiles <= 2
  AND NOT EXISTS (
    SELECT 1
    FROM Réservation R2
    JOIN Hôtel H2 ON R2.idChambre = H2.id
    WHERE C.id = R2.idClient AND H2.nbEtoiles > 2
  );


-- Point 4
SELECT DISTINCT V.nom
FROM Ville V
JOIN Hôtel H ON V.id = H.idVille
WHERE NOT EXISTS (
    SELECT 1
    FROM Réservation R
    JOIN Chambre C ON R.idChambre = C.idHôtel
    WHERE H.id = C.idHôtel
);


-- Point 5
SELECT H.id, H.nom, COUNT(DISTINCT C.numéro) AS nbTarifs
FROM Hôtel H
JOIN Chambre C ON H.id = C.idHôtel
GROUP BY H.id, H.nom
ORDER BY nbTarifs DESC
LIMIT 1;


-- Point 6
SELECT R.idClient, R.idChambre, R.numéroChambre, COUNT(*) AS nbRéservations
FROM Réservation R
GROUP BY R.idClient, R.idChambre, R.numéroChambre
HAVING COUNT(*) > 1;


-- Point 7
SELECT M.idClient, M.idHôtel
FROM Membre M
JOIN Hôtel H ON M.idHôtel = H.id
WHERE H.nom = 'Kurz Alpinhotel'
  AND NOT EXISTS (
    SELECT 1
    FROM Réservation R
    WHERE M.idClient = R.idClient AND M.idHôtel = R.idChambre
);


-- Point 8
SELECT V.nom, SUM(L.nbPlaces) AS capacitéTotale
FROM Ville V
JOIN Hôtel H ON V.id = H.idVille
JOIN Chambre C ON H.id = C.idHôtel
JOIN Lit L ON C.idHôtel = L.idEquipement
GROUP BY V.nom
ORDER BY capacitéTotale DESC;


-- Point 9
SELECT H.id, H.nom, H.nbEtoiles, V.nom AS ville, COUNT(R.idClient) AS nbRéservations
FROM Hôtel H
JOIN Ville V ON H.idVille = V.id
LEFT JOIN Chambre C ON H.id = C.idHôtel
LEFT JOIN Réservation R ON C.idHôtel = R.idChambre
GROUP BY H.id, H.nom, H.nbEtoiles, V.nom
ORDER BY V.nom, nbRéservations DESC;


-- Point 10
SELECT R.*, CASE WHEN H.rabaisMembre IS NOT NULL THEN 'Oui' ELSE 'Non' END AS aObtenuRabais
FROM Réservation R
JOIN Chambre C ON R.idChambre = C.idHôtel
JOIN Hôtel H ON C.idHôtel = H.id
WHERE H.nom = 'Antique Boutique Hôtel'
  AND R.dateArrivée >= CURRENT_DATE
ORDER BY R.dateArrivée;


-- Point 11
SELECT R.*
FROM Réservation R
JOIN Chambre C ON R.idChambre = C.idHôtel
JOIN Lit L ON C.idHôtel = L.idEquipement
WHERE R.nbPersonnes < L.nbPlaces;


-- Point 12
SELECT C.*
FROM Chambre C
JOIN Hôtel H ON C.idHôtel = H.id
JOIN Ville V ON H.idVille = V.id
JOIN Chambre_Equipement CE ON C.idHôtel = CE.idChambre
JOIN Equipement E ON CE.idEquipement = E.id
WHERE V.nom = 'Lausanne' AND E.nom = 'TV' AND EXISTS (
    SELECT 1
    FROM Chambre_Equipement CE2
    JOIN Equipement E2 ON CE2.idEquipement = E2.id
    WHERE C.idHôtel = CE2.idChambre AND E2.nom = 'Lit à 2 places'
);


-- Point 13
SELECT R.*, (R.dateArrivée - R.dateRéservation) AS joursAvance, 
    CASE WHEN M.idClient IS NOT NULL THEN 'Oui' ELSE 'Non' END AS estMembre
FROM Réservation R
JOIN Chambre C ON R.idChambre = C.idHôtel
LEFT JOIN Membre M ON R.idClient = M.idClient AND C.idHôtel = M.idHôtel
WHERE H.nom = 'Hôtel Royal'
ORDER BY joursAvance DESC, R.nom, R.prénom;


-- Point 14
SELECT SUM(C.prixParNuit * R.nbNuits) AS prixTotal
FROM Réservation R
JOIN Chambre C ON R.idChambre = C.idHôtel
WHERE C.idHôtel = (SELECT id FROM Hôtel WHERE nom = 'Hôtel Royal');
