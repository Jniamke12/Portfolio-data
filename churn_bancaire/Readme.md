# 🏦 Analyse Prédictive du Churn Bancaire

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)
[![Scikit-learn](https://img.shields.io/badge/Scikit--learn-1.0+-orange.svg)](https://scikit-learn.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

> Prédiction du churn client dans le secteur bancaire | Master 2 MIAGE

![Dashboard Preview](https://www.genspark.ai/api/files/s/36PK9ps5)

---

## 🎯 Objectif

Développer un système de prédiction du churn bancaire pour identifier les clients à risque de départ et permettre aux banques d'agir proactivement.

---

## ✨ Fonctionnalités

- 📊 **Analyse exploratoire** : Distribution du churn par pays, nombre de produits, statut membre
- 🤖 **3 Modèles ML** : Logistic Regression, Decision Tree, Random Forest
- 📈 **Métriques complètes** : Accuracy, Precision, Recall, F1-Score, ROC-AUC
- 🖥️ **Dashboard interactif** : Visualisation temps réel des KPI

---

## 📊 Résultats Clés

### Statistiques
- **10 000** clients analysés
- **43,05%** taux de churn
- **7 946** clients actifs
- **48,3 ans** âge moyen

### 3 Insights Majeurs

1️⃣ **Taux de churn élevé** : 43,05% des clients en risque de départ

2️⃣ **Disparité géographique** : Variation significative entre l'Allemagne, l'Espagne et la France

3️⃣ **Impact du cross-selling** : Les clients multi-produits montrent une meilleure rétention

---

## 🛠️ Technologies

```
Python 3.8+ | Pandas | NumPy | Scikit-learn | Matplotlib | Seaborn
```

---

## 📥 Installation

```bash
# Cloner le repository
git clone https://github.com/[votre-username]/churn-bancaire-analysis.git
cd churn-bancaire-analysis

# Installer les dépendances
pip install -r requirements.txt

# Lancer le notebook
jupyter notebook Churn_bancaire.ipynb
```

---

## 📁 Structure

```
churn-bancaire-analysis/
│
├── Churn_bancaire.ipynb      # Notebook principal
├── data/                      # Données
├── requirements.txt           # Dépendances
└── README.md                  # Documentation
```

---

## 🚀 Utilisation Rapide

```python
# Charger les données
import pandas as pd
df = pd.read_csv('data/bank_churn.csv')

# Entraîner un modèle
from sklearn.ensemble import RandomForestClassifier
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Prédire
predictions = model.predict(X_test)
```

---

## 🔮 Prochaines Étapes

- [ ] Déploiement du dashboard (Streamlit)
- [ ] API REST pour prédictions en temps réel
- [ ] Modèles avancés (XGBoost, LightGBM)
- [ ] Feature engineering amélioré

---

## 👤 Auteur

**[Votre Nom]**  
🎓 Master 2 MIAGE  
💼 [LinkedIn](https://www.linkedin.com/in/votre-profil)  
🐙 [GitHub](https://github.com/votre-username)

---

## 📄 Licence

MIT License - Projet académique

---

⭐ **N'hésitez pas à mettre une étoile si ce projet vous a plu !**


