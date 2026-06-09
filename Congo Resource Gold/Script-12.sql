-- NOMBRE D'ENGINS PAR SITE

SELECT COUNT (e.id_engin) AS Nbres_d_engins,
       s.nom AS Nom_Site,
       s.province AS Province
FROM sites s 
LEFT JOIN engins e  
ON e.id_site = s.id_site
GROUP BY s.nom, s.province

-- IDENTIFICATION DES JOURS Où LA PRODUCTION EST NULLE

SELECT DISTINCT p.date_prod AS Date_Production, p.type_minerai AS Minerais, s.nom AS Nom, p.tonnage_brut AS Tonnage_brut
FROM sites s 
LEFT JOIN production p 
ON p.id_site = s.id_site 
WHERE p.tonnage_brut = '0'

-- LISTE DES ENGINS ET LEUR SITE RESPECTIF

SELECT DISTINCT e.type AS Engins, s.nom AS Site, s.province AS Province
FROM sites s 
JOIN engins e 
ON e.id_site = s.id_site

-- SOMME TONNAGE BRUT PAR PROVINCE ET PAR MINERAI

SELECT s.province AS Province,
       s.nom AS Site,
       p.type_minerai AS Type_de_minerais,
       SUM(p.tonnage_brut) AS Somme_Tonnage_Brut
FROM sites s
LEFT JOIN production p  
ON s.id_site = p.id_site
GROUP BY s.nom, s.province,p.type_minerai

-- CALCUL DU TONNAGE DU METAL PUR

SELECT DISTINCT s.province AS Province,
                s.nom AS Nom,
                p.type_minerai AS Minerais,
                SUM (p.tonnage_brut * p.teneur/100) AS Somme_Metal_pur
FROM sites s 
LEFT JOIN production p 
ON s.id_site = p.id_site
GROUP BY s.province, s.nom, p.type_minerai 

-- CHIFFRE D'AFFAIRES PAR SITE

SELECT DISTINCT s.nom AS Site,
                s.province AS Province,
                p.type_minerai AS Minerais,
                ex.tonnage_vendu AS Tonnage_vendu,
                ex.prix_unitaire_usd AS Prix_unitaire,
                (ex.tonnage_vendu * ex.prix_unitaire_usd) AS Chiffres_d_affaires
FROM sites s
LEFT JOIN exportations ex ON s.id_site = ex.id_site
LEFT JOIN production p ON s.id_site = p.id_site
GROUP BY s.nom, s.province, p.type_minerai

-- TENEUR MOYENNE <2.5% PAR PRODUCTION

SELECT s.id_site AS Id_Site,
       s.nom AS Site,
       s.province AS Province,
       p.type_minerai AS Minerais,
       AVG(p.teneur) AS Teneur_moyen
FROM sites s 
LEFT JOIN production p ON s.id_site = p.id_site 
GROUP BY s.id_site, s.nom, s.province, p.type_minerai
HAVING AVG(p.teneur) < 2.5
ORDER BY Teneur_moyen DESC;
