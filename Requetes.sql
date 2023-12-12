-- Point 1 Les clients ayant fait au moins une réservation dans un hôtel se trouvant dans la ville dans laquelle ils habitent.
SELECT DISTINCT Client.nom,Client.prénom FROM Client 
JOIN Réservation ON Client.id = Réservation.idClient
JOIN Hôtel ON Réservation.idChambre = Hôtel.id
where Client.idVille = Hôtel.idVille;

-- Point 2 Le prix minimum, maximum et moyen pour passer une nuit dans une chambre d'hôtel dans la ville de Montreux.
SELECT min(prixParNuit) AS "Minimum", max(prixParNuit) AS "Maximum", avg(prixParNuit) AS "Moyen" FROM chambre
JOIN Hôtel ON Chambre.idhôtel = Hôtel.id
JOIN Ville ON Ville.id = Hôtel.idville
WHERE Ville.nom = 'Montreux';


-- Point 3 Les clients qui n'ont fait des réservations que dans des hôtels de 2 étoiles ou moins.
SELECT DISTINCT C.id, C.nom, C.prénom
FROM Client C
LEFT JOIN Réservation R ON C.id = R.idClient
LEFT JOIN Chambre CH ON R.idChambre = CH.idHôtel AND R.numéroChambre = CH.numéro
LEFT JOIN Hôtel H ON CH.idHôtel = H.id
WHERE H.nbEtoiles <= 2 AND H.id IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM Réservation R2
    LEFT JOIN Chambre CH2 ON R2.idChambre = CH2.idHôtel AND R2.numéroChambre = CH2.numéro
    LEFT JOIN Hôtel H2 ON CH2.idHôtel = H2.id
    WHERE C.id = R2.idClient AND H2.nbEtoiles > 2
  );


-- Point 4 Le nom des villes avec au moins un hôtel qui n'a aucune réservation.
SELECT DISTINCT V.nom
FROM Ville V
INNER JOIN Hôtel H ON V.id = H.idVille
WHERE NOT EXISTS (
    SELECT 1
    FROM Réservation R
    INNER JOIN Chambre CH ON R.idChambre = CH.idHôtel AND R.numéroChambre = CH.numéro
    WHERE CH.idHôtel = H.id
);


-- Point 5 L'hôtel qui a le plus de tarifs de chambres différents.
SELECT H.id, H.nom AS nom_hôtel, COUNT(DISTINCT CH.prixParNuit) AS nb_tarifs_différents
FROM Hôtel H
JOIN Chambre CH ON H.id = CH.idHôtel
GROUP BY H.id, H.nom
ORDER BY nb_tarifs_différents DESC
LIMIT 1;


-- Point 6 Les clients ayant réservé plus d'une fois la même chambre. Indiquer les clients et les chambres concernées.



-- Point 7 Les membres de l'hôtel "Kurz Alpinhotel" qui n'y ont fait aucune réservation depuis qu'ils en sont devenus membre.



-- Point 8 Les villes, classées dans l'ordre décroissant de leur capacité d'accueil totale (nombre de places des lits de leurs hôtels).



-- Point 9 Les hôtels avec leur classement par ville en fonction du nombre de réservations.



-- Point 10 Lister, par ordre d'arrivée, les prochaines réservations pour l'hôtel "Antique Boutique Hôtel" en indiquant si le client a obtenu un rabais.



-- Point 11 Les réservations faites dans des chambres qui ont un nombre de lits supérieur au nombre de personnes de la réservation.



-- Point 12 Les chambres à Lausanne ayant au moins une TV et un lit à 2 places.



-- Point 13 Pour l'hôtel "Hôtel Royal", lister toutes les réservations en indiquant de combien de jours elles ont été faites à l'avance (avant la date d'arrivée) ainsi que si la réservation a été faite en tant que membre de l'hôtel. Trier les résultats par ordre des réservations (en 1er celles faites le plus à l’avance), puis par clients (ordre croissant du nom puis du prénom).



-- Point 14 Calculer le prix total de toutes les réservations faites pour l'hôtel "Hôtel Royal".