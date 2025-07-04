# 🧠 Défi SQL – Analyse des Ventes avec la base Chinook

Ce dépôt présente ma solution à un **défi SQL** consistant à explorer et analyser des données de ventes issues de la base relationnelle **Chinook**.  
L’objectif était de produire un ensemble de requêtes SQL couvrant différents aspects commerciaux : clients, agents, morceaux, pays et années.

🎯 **But du défi :** Utiliser uniquement du SQL pour extraire, croiser, regrouper et analyser les données métier sans automatisation avancée.

---

## 🗃️ Base de données utilisée

- **Nom :** Chinook Database  
- **Lien officiel :** [lerocha/chinook-database](https://github.com/lerocha/chinook-database)  
- **Structure :** Clients, employés, artistes, albums, morceaux, factures, etc.

---

## 🧠 Enoncé du défi

> Une entreprise souhaite produire un rapport récapitulant les ventes par produit pour le dernier trimestre.  
> Il s’agit ici de répondre **avec des requêtes SQL manuelles** aux principaux besoins d’analyse, sans calcul automatique de période.

---

## 💡 Ce que fait réellement le projet

Le fichier `Automatisation_Rapports_Ventes.sql` contient **plus de 20 requêtes SQL** qui répondent à des cas d’usage précis.

### 📌 Domaines couverts :

#### 🧾 Requêtes de base
- Lister les clients hors USA ou uniquement ceux du Brésil
- Voir les factures associées à ces clients
- Lister les agents commerciaux

#### 📊 Relations & agrégations
- Total de chaque facture avec infos clients et agents
- Liste des pays de facturation
- Factures regroupées par agent

#### 📅 Analyse par année
- Ventes totales en 2021, 2023, 2024 et 2025 (⚠️ pas de découpage par trimestre)
- Meilleur agent de vente par année et globalement

#### 🎵 Données musicales
- Morceaux achetés par facture
- Artistes et albums liés aux morceaux achetés
- Nombre de morceaux par playlist
- Genre, type de média, et albums associés aux morceaux

#### 📈 Indicateurs de performance
- Nombre de factures par pays
- Nombre d’articles par facture
- Total des ventes par agent

---

## 📂 Fichiers inclus

| Fichier                             | Description                                 |
|------------------------------------|---------------------------------------------|
| `Automatisation_Rapports_Ventes.sql` | Script SQL contenant toutes les requêtes    |
| `Défi_SQL_Chinook.pdf` *(optionnel)* | Présentation PDF (si ajoutée au dépôt)      |

---

## 🛠️ Prérequis pour exécution

- Installer un outil SQL compatible : DBeaver, SQLiteStudio, PgAdmin, etc.
- Importer la base Chinook (format SQLite ou PostgreSQL recommandé)
- Lancer les requêtes directement dans votre éditeur

---

## 📍 Exemple de requête

```sql
-- Meilleur agent de vente en 2024
SELECT e.FirstName, e.LastName, SUM(i.Total) AS "Ventes Totales"
FROM employee e
INNER JOIN customer c ON c.SupportRepId = e.EmployeeId
INNER JOIN invoice i ON c.CustomerId = i.CustomerId
WHERE YEAR(i.InvoiceDate) = 2024
GROUP BY e.EmployeeId
ORDER BY SUM(i.Total) DESC
LIMIT 1;
