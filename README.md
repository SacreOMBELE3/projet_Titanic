# Titanic — pipeline Medallion et machine learning

Ce projet propose un parcours complet sur les données de la compétition Kaggle [Titanic — Machine Learning from Disaster](https://www.kaggle.com/competitions/titanic) : import des CSV, stockage dans SQL Server selon l’architecture Medallion, préparation des données, entraînement et évaluation de modèles, puis génération d’un fichier de soumission.

## État d’avancement

Les trois notebooks du dossier `notebook/` couvrent l’importation et l’audit Bronze, la préparation Silver/Gold, puis le machine learning. L’exécution des étapes SQL nécessite une instance SQL Server configurée localement.

## Architecture et flux

```text
CSV source
   │
   ▼
SQL Server — TitanicAnalytics
   ├── bronze : copie brute des CSV
   ├── silver : colonnes typées et contrôles qualité
   └── gold   : variables prêtes pour l’analyse et le ML
                  │
                  ▼
Python / scikit-learn
   ├── validation stratifiée et comparaison de modèles
   ├── pipeline final réentraîné sur tout le train
   └── prédictions test → models/submissions/titanic_submission.csv
```

SQL Server stocke les couches de données. Les notebooks Python réalisent l’importation, les transformations et le machine learning. La chaîne de connexion SQL Server est demandée à l’exécution et n’est pas enregistrée dans les notebooks.

## Arborescence

```text
titanic/
├── data/
│   └── bronze/
│       ├── train.csv
│       ├── test.csv
│       └── gender_submission.csv
├── notebook/
│   ├── 01_load_and_audit.ipynb
│   ├── 02_preparation_silver_gold.ipynb
│   └── 03_machine_learning.ipynb
├── sql/
│   ├── 00_create_database.sql
│   ├── 01_create_schemas.sql
│   ├── bronze/01_create_tables.sql
│   ├── silver/01_create_tables.sql
│   └── gold/01_create_tables.sql
├── models/                         # Modèles, métriques et soumissions générés
├── .gitignore                      # Protection des secrets et artefacts locaux
└── README.md
```

Le dossier `notebook/` contient uniquement ces trois notebooks Jupyter. Exécutez-les dans l’ordre : le premier importe et audite les données Bronze, le deuxième prépare Silver et Gold, et le troisième entraîne les modèles et génère la soumission.

### Rôle des couches

| Couche | Emplacement | Contenu |
| --- | --- | --- |
| Bronze | CSV dans `data/bronze/` et tables SQL `bronze.*` | Valeurs sources importées comme texte, sans nettoyage ; le nom du fichier source et la date d’import sont conservés. |
| Silver | Tables SQL `silver.train` et `silver.test` | Valeurs numériques converties, doublons d’identifiant supprimés, valeurs aberrantes d’âge et tarifs négatifs remplacés par des valeurs manquantes. Les valeurs manquantes ne sont pas imputées ici. |
| Gold | Tables SQL `gold.train_features` et `gold.test_features` | Variables prêtes à l’analyse et au ML, avec taille de famille, indicateur de voyage seul, titre et pont. La cible `Survived` ne figure que dans le train. |

Les schémas `bronze`, `silver` et `gold` sont créés dans la base SQL Server `TitanicAnalytics`. Les tables sont créées par les scripts SQL versionnés ; les tables Silver et Gold sont rechargées à chaque exécution de leur étape.

## Prérequis

- Python 3.10 ou ultérieur.
- SQL Server accessible depuis la machine d’exécution.
- Microsoft ODBC Driver 18 for SQL Server (ou un autre pilote ODBC compatible, avec le nom correspondant dans la chaîne de connexion).
- Les trois CSV Kaggle déjà placés dans `data/bronze/`.
- Un compte autorisé à créer la base et les schémas lors de la première installation, puis à lire et écrire dans les tables.

## Installation

Depuis le dossier racine du projet, créez et activez un environnement virtuel hors du projet afin de conserver l’arborescence demandée :

```powershell
py -m venv "$env:USERPROFILE\.venvs\titanic"
& "$env:USERPROFILE\.venvs\titanic\Scripts\Activate.ps1"
python -m pip install pandas numpy SQLAlchemy pyodbc scikit-learn joblib jupyter matplotlib seaborn
```

Installez également le pilote système Microsoft ODBC Driver 18 for SQL Server. Le notebook demande la chaîne ODBC au démarrage de la connexion ; elle n’est pas écrite dans le fichier.

## Initialisation de SQL Server

Dans SQL Server Management Studio (SSMS), ouvrez et exécutez les scripts dans cet ordre :

1. `sql/00_create_database.sql` — crée `TitanicAnalytics` si elle n’existe pas.
2. `sql/01_create_schemas.sql` — crée les schémas `bronze`, `silver` et `gold`.
3. `sql/bronze/01_create_tables.sql` — crée les tables brutes.
4. `sql/silver/01_create_tables.sql` — crée les tables nettoyées.
5. `sql/gold/01_create_tables.sql` — crée les tables de caractéristiques.

Ces scripts sont prévus pour être réexécutés sans recréer les objets déjà présents. Ils ne chargent pas les CSV ; l’importation se fait dans le notebook de préparation.

## Exécuter les notebooks

Lancez Jupyter depuis la racine du projet :

```powershell
jupyter notebook
```

Exécutez les notebooks **dans l’ordre**, en utilisant le même serveur SQL Server et la même base `TitanicAnalytics` :

1. `notebook/01_load_and_audit.ipynb` est le notebook d’audit d’origine, restauré sans modification.
2. `notebook/02_preparation_silver_gold.ipynb` importe les CSV dans Bronze, puis nettoie Silver et prépare les caractéristiques Gold.
3. `notebook/03_machine_learning.ipynb` compare et évalue les modèles, entraîne le modèle sélectionné et crée les prédictions du jeu test.

Chaque notebook demande la chaîne de connexion ODBC de façon masquée. Les tables attendues doivent avoir été créées en suivant l’étape d’initialisation SQL Server.

### Sorties générées

- `models/titanic_model.joblib` — pipeline scikit-learn réentraîné sur tout le jeu `train`.
- `models/metrics.json` — métriques calculées sur le jeu de validation et modèle retenu.
- `models/submissions/titanic_submission.csv` — fichier Kaggle contenant uniquement `PassengerId` et `Survived`.

Ces fichiers sont générés localement et ignorés par Git. `gender_submission.csv` est une baseline de soumission ; ce n’est pas une vérité terrain pour évaluer les prédictions du jeu `test`.

## Source des données

Les données proviennent de la compétition Kaggle [Titanic — Machine Learning from Disaster](https://www.kaggle.com/competitions/titanic).
