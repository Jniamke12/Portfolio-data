# 📊 Tableau de bord Power BI – Analyse Commerciale Globale

Ce projet est un tableau de bord interactif créé avec **Power BI**, conçu pour permettre un suivi global de l'activité commerciale : ventes, marges, transactions, coûts et inventaire. Il inclut des visualisations dynamiques, des filtres contextuels et des mesures DAX avancées.

---

## 🎯 Objectifs du projet

- Visualiser les indicateurs commerciaux clés
- Suivre l’évolution mensuelle des quantités, du chiffre d’affaires et des marges
- Comparer les performances N / N-1
- Mettre en évidence les écarts par période
- Automatiser le nettoyage et la transformation des données via Power Query

---

## 🔍 Fonctions principales

- KPIs dynamiques : Quantité totale, Nombre de transactions, Chiffre d’affaires, Marges, Ventes nettes
- Segmentation par :
  - Département
  - Catégorie
  - Fournisseur / Magasin
  - Période personnalisable
- Évolution mensuelle des quantités
- Répartition des ventes et marges par catégorie
- Comparaison N / N-1 avec variation en pourcentage (DAX)

---

## 🧠 DAX & Power BI Techniques

Exemples de mesures DAX utilisées :
- `chiffre_affaire`
- `ecart_chiffre_affaire n-1 %`
- `cout YTD`
- `indicateur_selectionne`
- `PeriodeDynamique` pour la sélection contextuelle

Transformations réalisées avec **Power Query** : nettoyage, types de données, jointures.

---

## 📁 Fichiers inclus

- `fichier_pbix/` : le fichier `.pbix` Power BI complet
- `captures/vue_globale.png` : aperçu du dashboard principal
- `captures/mesures_dax.png` : aperçu des mesures DAX

---

## 🛠️ Outils utilisés

| Outil / Langage | Utilisation |
|------------------|-------------|
| **Power BI**     | Visualisation, rapports interactifs |
| **DAX**          | Calculs dynamiques et personnalisés |
| **Power Query**  | Transformation et nettoyage des données |
| **Excel / CSV**  | Source de données (si applicable) |

---

## 🧠 Compétences développées

- Conception de dashboards métier
- DAX avancé : comparaison temporelle, variation %
- Nettoyage de données avec Power Query
- Visualisation orientée business

---

📌 Ce tableau de bord est conçu pour une **analyse stratégique et opérationnelle**. Il pourrait être utilisé par des équipes commerciales ou de direction pour le suivi quotidien et mensuel des performances.
