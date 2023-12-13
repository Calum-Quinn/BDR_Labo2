# BDR_Labo2

**Groupe :** numéro 7   
**Auteurs :** Piemontesi Gwendal, Quinn Calum, Trüeb Guillaume   
**Date :** 6 décembre 2023
***

## Sommaire
- [Introduction](#introduction)
- [Modélisation](#modélisation)
  - [Schéma-EA](#schéma-ea)
  - [Contraintes d’intégrité](#contraintes-dintégrité)
  - [Questions ouvertes et choix de conception](#questions-ouvertes-et-choix-de-conception)
- [Conclusion](#conclusion)

## Partie 1 

### Requête 1 
#### Enoncé :
Les clients ayant fait au moins une réservation dans un hôtel se trouvant dans la ville dans laquelle ils habitent.

#### Requête :
```sql
SELECT DISTINCT Client.id,Client.nom,Client.prénom FROM Client 
JOIN Réservation ON Client.id = Réservation.idClient
JOIN Hôtel ON Réservation.idChambre = Hôtel.id
WHERE Client.idVille = Hôtel.idVille;
```

#### Resultat :
| id   | nom         | prénom      |
|------|-------------|-------------|
| 1    | Dupont      | Jean        |
| 3    | Tremblay    | Marie       |
| 5    | Leroy       | Pierre      |


### Requête 2 
#### Enoncé :
Le prix minimum, maximum et moyen pour passer une nuit dans une chambre d'hôtel dans la ville de Montreux.

#### Requête :
```sql
SELECT min(prixParNuit) AS "Minimum", max(prixParNuit) AS "Maximum", avg(prixParNuit) AS "Moyen" FROM chambre
JOIN Hôtel ON Chambre.idhôtel = Hôtel.id
JOIN Ville ON Ville.id = Hôtel.idville
WHERE Ville.nom = 'Montreux';
```

#### Resultat :



### Requête 3 
#### Enoncé :
Les clients qui n'ont fait des réservations que dans des hôtels de 2 étoiles ou moins.

#### Requête :
```sql
SELECT DISTINCT Client.id, Client.nom, Client.prénom FROM Client
LEFT JOIN Réservation ON Client.id = Réservation.idClient
LEFT JOIN Hôtel ON Réservation.idChambre = Hôtel.id
WHERE Hôtel.nbEtoiles <= 2
  AND NOT EXISTS (
    SELECT 1
    FROM Réservation R2
    LEFT JOIN Hôtel H2 ON R2.idChambre = H2.id
    WHERE Client.id = R2.idClient AND H2.nbEtoiles > 2
  );
```

#### Resultat :

### Requête 4 
#### Enoncé :
Le nom des villes avec au moins un hôtel qui n'a aucune réservation.

#### Requête :
```sql
SELECT DISTINCT Ville.nom FROM Ville
JOIN Hôtel ON Ville.id = Hôtel.idville
WHERE NOT EXISTS (
  SELECT 1 FROM Réservation
  WHERE Réservation.idchambre = Hôtel.id
);
```

#### Resultat :

### Requête 5 
#### Enoncé :
L'hôtel qui a le plus de tarifs de chambres différents.

#### Requête :
```sql
SELECT Hôtel.nom AS nom_hôtel, COUNT(DISTINCT Chambre.prixParNuit) AS nb_tarifs_différents
FROM Hôtel
JOIN Chambre ON Hôtel.id = Chambre.idHôtel
GROUP BY Hôtel.id, Hôtel.nom
ORDER BY nb_tarifs_différents DESC
LIMIT 1;
```

#### Resultat :

### Requête 6 
#### Enoncé :
Les clients ayant réservé plus d'une fois la même chambre. Indiquer les clients et les chambres concernées.

#### Requête :
```sql
SELECT Client.id, Client.nom, Hôtel.nom AS nom_hotel, Réservation.numéroChambre FROM Client 
INNER JOIN Réservation ON Réservation.idClient = Client.id
INNER JOIN Hôtel ON Hôtel.id = Réservation.idChambre
GROUP BY Client.id, Hôtel.id, Réservation.numéroChambre
HAVING COUNT(*) >= 2;
```

#### Resultat :

### Requête 7 
#### Enoncé :
Les membres de l'hôtel "Kurz Alpinhotel" qui n'y ont fait aucune réservation depuis qu'ils en sont devenus membre.

#### Requête :
```sql
SELECT DISTINCT Client.id, Client.nom, Client.prénom FROM Client 
INNER JOIN Membre ON Membre.idClient = Client.id 
INNER JOIN Hôtel ON Membre.idHôtel = Hôtel.id
LEFT JOIN Réservation ON Membre.idclient = Réservation.idclient AND Réservation.dateréservation > Membre.depuis
WHERE Hôtel.nom = 'Kurz Alpinhotel'
GROUP BY Client.id
HAVING count(Réservation) = 0;
```

#### Resultat :

### Requête 8 
#### Enoncé :
Les villes, classées dans l'ordre décroissant de leur capacité d'accueil totale (nombre de places des lits de leurs hôtels).

#### Requête :
```sql
SELECT Ville.nom FROM Ville
JOIN Hôtel ON Ville.id = Hôtel.idVille
JOIN Chambre ON Hôtel.id = Chambre.idHôtel
JOIN Chambre_Equipement ON Chambre.idHôtel = Chambre_Equipement.idChambre
JOIN Lit ON Chambre_Equipement.idEquipement = Lit.idEquipement
GROUP BY Ville.nom
ORDER BY SUM(Lit.nbPlaces) DESC;
```

#### Resultat :

### Requête 9 
#### Enoncé :
Les hôtels avec leur classement par ville en fonction du nombre de réservations.

#### Requête :
```sql
SELECT Hôtel.nom, Ville.nom,
RANK() OVER (PARTITION BY Ville.nom 
  ORDER BY SUM(
    CASE 
      WHEN Réservation.idchambre = Hôtel.id 
      THEN 1 
      ELSE 0 
    END) 
  DESC) AS Classement_par_ville
FROM Hôtel
JOIN Ville ON Hôtel.idville = Ville.id
LEFT JOIN Réservation ON Hôtel.id = Réservation.idchambre
GROUP BY Ville.nom, Hôtel.nom
ORDER BY Ville.nom, Classement_par_ville;
```

#### Resultat :

### Requête 10 
#### Enoncé :
Lister, par ordre d'arrivée, les prochaines réservations pour l'hôtel "Antique Boutique Hôtel" en indiquant si le client a obtenu un rabais.

#### Requête :
```sql
SELECT Client.id, Client.nom, Client.prénom, 
  (Membre IS NOT NULL AND Réservation.dateréservation > Membre.depuis) AS Rabais, Hôtel.nom AS Hôtel, Chambre.numéro AS numérochambre, 
  TO_CHAR(Réservation.datearrivée,'DD.MM.YYYY') AS datearrivée,
  TO_CHAR(Réservation.dateréservation,'DD.MM.YYYY') AS dateréservation, Réservation.nbnuits, Réservation.nbpersonnes
FROM Réservation
JOIN Client ON Réservation.idclient = Client.id
JOIN Chambre ON Réservation.idchambre = Chambre.idhôtel AND Réservation.numérochambre = Chambre.numéro
JOIN Hôtel ON Réservation.idchambre = Hôtel.id AND Hôtel.nom = 'Antique Boutique Hôtel'
LEFT JOIN Membre ON Client.id = Membre.idclient AND Hôtel.id = Membre.idhôtel
WHERE Réservation.datearrivée > now()
ORDER BY Réservation.datearrivée;
```

#### Resultat :

### Requête 11 
#### Enoncé :
Les réservations faites dans des chambres qui ont un nombre de lits supérieur au nombre de personnes de la réservation.

#### Requête :
```sql
SELECT Client.id, Client.nom, Client.prénom, Hôtel.nom AS Hôtel, Chambre.numéro AS numérochambre, 
  TO_CHAR(Réservation.datearrivée,'DD.MM.YYYY') AS datearrivée,
  TO_CHAR(Réservation.dateréservation,'DD.MM.YYYY') AS dateréservation, Réservation.nbnuits, Réservation.nbpersonnes
FROM Réservation
JOIN Client ON Réservation.idclient = Client.id
JOIN Chambre ON Réservation.idchambre = Chambre.idhôtel 
  AND Réservation.numérochambre = Chambre.numéro
JOIN chambre_equipement ON Chambre.idhôtel = chambre_equipement.idchambre 
  AND Chambre.numéro = chambre_equipement.numérochambre 
  AND chambre_equipement.quantité > Réservation.nbpersonnes
JOIN Hôtel ON Réservation.idchambre = Hôtel.id
ORDER BY Hôtel, Chambre.numéro;
```

#### Resultat :

### Requête 12 
#### Enoncé :
Les chambres à Lausanne ayant au moins une TV et un lit à 2 places.

#### Requête :
```sql
SELECT Hôtel.nom, Chambre.numéro FROM Chambre
JOIN Hôtel ON Chambre.idhôtel = Hôtel.id
JOIN Ville ON Hôtel.idville = Ville.id AND Ville.nom = 'Lausanne'
JOIN chambre_equipement ON Chambre.idhôtel = chambre_equipement.idchambre AND Chambre.numéro = chambre_equipement.numérochambre
LEFT JOIN Equipement ON chambre_equipement.idequipement = Equipement.id AND Equipement.nom = 'TV'
LEFT JOIN Lit ON chambre_equipement.idequipement = Lit.idequipement AND Lit.nbplaces > 1
GROUP BY Hôtel.nom, Chambre.numéro
HAVING count(Equipement) > 0 AND max(Lit.nbPlaces) > 1;
```

#### Resultat :

### Requête 13 
#### Enoncé :
Pour l'hôtel "Hôtel Royal", lister toutes les réservations en indiquant de combien de jours elles ont été faites à l'avance (avant la date d'arrivée) ainsi que si la réservation a été faite
en tant que membre de l'hôtel. Trier les résultats par ordre des réservations (en 1er celles faites le plus à l’avance), puis par clients (ordre croissant du nom puis du prénom).

#### Requête :
```sql
SELECT Client.id, Client.nom, Client.prénom, 
  (Membre IS NOT NULL AND Réservation.dateréservation > Membre.depuis) AS Membre, Hôtel.nom AS Hôtel, Chambre.numéro AS numérochambre, 
  TO_CHAR(Réservation.datearrivée,'DD.MM.YYYY') AS datearrivée, 
  TO_CHAR(Réservation.dateréservation,'DD.MM.YYYY') AS dateréservation, 
  (Réservation.datearrivée - Réservation.dateréservation) AS Avance, Réservation.nbnuits, Réservation.nbpersonnes
FROM Réservation
JOIN Client ON Réservation.idclient = Client.id
JOIN Chambre ON Réservation.idchambre = Chambre.idhôtel AND Réservation.numérochambre = Chambre.numéro
JOIN Hôtel ON Réservation.idchambre = Hôtel.id AND Hôtel.nom = 'Hôtel Royal'
LEFT JOIN Membre ON Client.id = Membre.idclient AND Hôtel.id = Membre.idhôtel
ORDER BY Avance DESC, Client.nom, Client.prénom;
```

#### Resultat :

### Requête 14 
#### Enoncé :
Calculer le prix total de toutes les réservations faites pour l'hôtel "Hôtel Royal".

#### Requête :
```sql
SELECT sum((Chambre.prixparnuit * Réservation.nbnuits) * (100 - (CASE 
                                                                    WHEN Membre IS NOT NULL
                                                                    AND Réservation.dateréservation > Membre.depuis 
                                                                    THEN Hôtel.rabaismembre 
                                                                    ELSE 0
                                                                  END))/ 100)
FROM Réservation
JOIN Hôtel ON Réservation.idChambre = Hôtel.id
JOIN Chambre ON Hôtel.id = Chambre.idHôtel AND Chambre.numéro = Réservation.numérochambre
LEFT JOIN Membre ON Hôtel.id = Membre.idhôtel AND Membre.idclient = Réservation.idclient
WHERE Hôtel.nom = 'Hôtel Royal';
```

#### Resultat :




## Partie 2
