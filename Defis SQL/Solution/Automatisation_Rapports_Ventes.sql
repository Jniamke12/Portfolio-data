
-- 01 - Clients non américains
SELECT CustomerID, FirstName, LastName, Country 
FROM Customer
WHERE NOT Country = 'USA';

-- 02 - Clients brésiliens
SELECT CustomerID, FirstName, LastName, Country 
FROM Customer
WHERE Country = 'Brazil';

-- 03 - Factures des clients brésiliens
SELECT c.FirstName, c.LastName, i.InvoiceId, i.InvoiceDate, i.BillingCountry 
FROM invoice i
INNER JOIN customer c ON c.CustomerId = i.CustomerId
WHERE i.BillingCountry = 'Brazil';

-- 04 - Agents de vente
SELECT EmployeeId, LastName, FirstName, Title, Country 
FROM employee
WHERE Title = 'Sales Support Agent';

-- 05 - Pays uniques dans les factures
SELECT BillingCountry AS Pays 
FROM invoice;

-- 06 - Factures par agent de vente
SELECT e.FirstName, e.LastName, c.CustomerId, i.InvoiceId, c.FirstName 
FROM employee e
INNER JOIN customer c ON e.EmployeeId = c.SupportRepId
INNER JOIN invoice i ON c.CustomerId = i.CustomerId;

-- 07 - Détails des factures
SELECT i.InvoiceId, CONCAT(c.FirstName, ' ',c.LastName) AS NomClient, 
       i.BillingCountry, i.Total, 
       CONCAT(e.FirstName, ' ',e.LastName) AS AgentVente 
FROM employee e
INNER JOIN customer c ON e.EmployeeId = c.SupportRepId
INNER JOIN invoice i ON c.CustomerId = i.CustomerId
ORDER BY i.InvoiceId;

-- 08 - Ventes par année (2021 et 2025)
SELECT COUNT(invoiceId) AS NomFacture, 
       SUM(i.Total) AS TotalVentes,
       YEAR(i.InvoiceDate) 
FROM invoice i
WHERE YEAR(i.InvoiceDate) IN (2021, 2025)
GROUP BY YEAR(i.InvoiceDate);

-- 09 - Nombre d’articles pour la facture 37
SELECT i.InvoiceId, SUM(il.InvoicelineId) AS "Nombres Articles" 
FROM invoice i
INNER JOIN invoiceline il ON i.InvoiceId = il.InvoiceId
WHERE i.InvoiceId = 37
GROUP BY i.InvoiceId;

-- 10 - Nombre d’articles par facture
SELECT i.InvoiceId, COUNT(il.InvoicelineId) AS "Nombres Articles" 
FROM invoice i
INNER JOIN invoiceline il ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId;

-- 11 - Nom des morceaux par ligne de facture
SELECT i.InvoiceLineId AS "Facture", t.Name AS "Noms Morceaux" 
FROM invoiceline i
INNER JOIN track t ON i.TrackId = t.TrackId
GROUP BY i.InvoiceLineId;

-- 12 - Morceaux et artistes
SELECT i.InvoiceLineId AS "Facture", t.Name AS "Noms Morceaux", a.Name AS "Nom Artiste"
FROM invoiceline i
INNER JOIN track t ON i.TrackId = t.TrackId
INNER JOIN album al ON t.AlbumId = al.AlbumId
INNER JOIN artist a ON a.ArtistId = al.ArtistId
GROUP BY i.InvoiceLineId;

-- 13 - Nombre de factures par pays
SELECT DISTINCT BillingCountry AS "Pays", 
       COUNT(InvoiceId) AS "Nombre de facture"
FROM invoice
GROUP BY BillingCountry;

-- 14 - Nombre de morceaux par playlist
SELECT DISTINCT p.Name AS "Nom Playlist", 
       COUNT(t.TrackId) AS "Nombre de morceaux"  
FROM track t
INNER JOIN playlisttrack pl ON t.TrackId = pl.TrackId
INNER JOIN playlist p ON p.PlaylistId = pl.PlaylistId
GROUP BY p.PlaylistId;

-- 15 - Liste des morceaux avec album, média et genre
SELECT t.TrackId, t.Name AS "Tracks", 
       al.Title AS "Album", m.Name AS "Type de media", g.Name AS "Genre"  
FROM track t
INNER JOIN album al ON al.AlbumId = t.AlbumId
INNER JOIN mediatype m ON m.MediaTypeId = t.MediaTypeId
INNER JOIN genre g ON g.GenreId = t.GenreId
GROUP BY t.TrackId;

-- 16 - Factures et nombre d’articles
SELECT i.InvoiceId, COUNT(il.InvoicelineId) AS "Nombre d'articles"
FROM invoice i
INNER JOIN invoiceline il ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId;

-- 17 - Ventes totales par agent de vente
SELECT e.FirstName, e.LastName AS "Agent de vente", 
       SUM(i.Total) AS "Total ventes"
FROM employee e
INNER JOIN customer c ON e.EmployeeId = c.SupportRepId
INNER JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId;

-- 18 - Meilleur agent de vente en 2024
SELECT e.FirstName, e.LastName, SUM(i.Total) AS "Ventes Totales"
FROM employee e
INNER JOIN customer c ON c.SupportRepId = e.EmployeeId
INNER JOIN invoice i ON c.CustomerId = i.CustomerId
WHERE YEAR(i.InvoiceDate) = 2024
GROUP BY e.EmployeeId
ORDER BY SUM(i.Total) DESC
LIMIT 1;

-- 19 - Meilleur agent de vente en 2023
SELECT e.FirstName, e.LastName, SUM(i.Total) AS "Ventes Totales"
FROM employee e
INNER JOIN customer c ON c.SupportRepId = e.EmployeeId
INNER JOIN invoice i ON c.CustomerId = i.CustomerId
WHERE YEAR(i.InvoiceDate) = 2023
GROUP BY e.EmployeeId
ORDER BY SUM(i.Total) DESC
LIMIT 1;

-- 20 - Meilleur agent global (toutes années confondues)
SELECT e.FirstName, e.LastName, SUM(i.Total) AS "Ventes Totales"
FROM employee e
INNER JOIN customer c ON c.SupportRepId = e.EmployeeId
INNER JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId
ORDER BY SUM(i.Total) DESC
LIMIT 1;
