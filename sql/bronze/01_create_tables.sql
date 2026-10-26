USE master
GO
/*
====================================================================================
SCRIPT          : Création des tables de la couche Bronze
====================================================================================

DESCRIPTION
------------
Ce script initialise les tables de la couche Bronze destinées à recevoir
les données brutes issues des fichiers CSV du projet Titanic.

TABLES CONCERNÉES
-----------------
1. bronze.train
   Contient les données d'entraînement, notamment la variable cible Survived.

2. bronze.test
   Contient les données de test utilisées pour les analyses et les prédictions.
   La colonne Survived n'est pas présente dans ce fichier source.

3. bronze.gender_submission
   Contient les prédictions de référence fournies dans le fichier
   gender_submission.csv de la compétition Titanic sur Kaggle.

CONVENTIONS DE STOCKAGE
-----------------------
- Les colonnes métier sont stockées au format NVARCHAR afin de préserver
  les valeurs brutes avant leur validation et leur conversion.
- SourceFile identifie le fichier source utilisé lors du chargement.
- IngestedAt enregistre la date et l'heure d'intégration des données.

RÈGLE DE CRÉATION
-----------------
Chaque table est créée uniquement si elle n'existe pas déjà.

IMPORTANT
---------
La couche Bronze conserve les données dans leur format d'origine.
Le nettoyage, la validation et la conversion des types seront réalisés
dans les couches suivantes de l'architecture Medallion.

====================================================================================
*/


/* ================================================================================
   ÉTAPE 1 : CRÉATION DE LA TABLE BRONZE.TRAIN
================================================================================ */

USE Titanic;
GO

IF OBJECT_ID(N'bronze.train', N'U') IS NULL
BEGIN
    CREATE TABLE bronze.train
    (
        PassengerId NVARCHAR(50)  ,
        Survived   NVARCHAR(50)  ,
        Pclass     NVARCHAR(50)  ,
        Name       NVARCHAR(255) ,
        Sex        NVARCHAR(50)  ,
        Age        NVARCHAR(50)  ,
        SibSp      NVARCHAR(50)  ,
        Parch      NVARCHAR(50)  ,
        Ticket     NVARCHAR(100) ,
        Fare      NVARCHAR(50)  ,
        Cabin      NVARCHAR(100),
        Embarked   NVARCHAR(50) ,


    );
END;
GO


/* ================================================================================
   ÉTAPE 2 : CRÉATION DE LA TABLE BRONZE.TEST
================================================================================ */

IF OBJECT_ID(N'bronze.test', N'U') IS NULL
BEGIN
    CREATE TABLE bronze.test
    (
        PassengerId NVARCHAR(50)  ,
        [Pclass]       NVARCHAR(50) ,
        [Name]         NVARCHAR(255) ,
        [Sex]          NVARCHAR(50)  ,
        [Age]           NVARCHAR(50) ,
        [SibSp]        NVARCHAR(50)  ,
        [Parch]        NVARCHAR(50)  ,
        [Ticket]       NVARCHAR(100) ,
        [Fare]         NVARCHAR(50)  ,
        [Cabin]        NVARCHAR(100) ,
        [Embarked]     NVARCHAR(50)  ,
    );
END;
GO


/* ================================================================================
   ÉTAPE 3 : CRÉATION DE LA TABLE BRONZE.GENDER_SUBMISSION
================================================================================ */

IF OBJECT_ID(N'bronze.gender_submission', N'U') IS NULL
BEGIN
    CREATE TABLE bronze.gender_submission
    (
        PassengerId NVARCHAR(50),
        Survived    NVARCHAR(50),

    );
END;
GO


/* ================================================================================
   ÉTAPE 4 : VÉRIFICATION DES TABLES CRÉÉES
================================================================================ */

SELECT
    TABLE_SCHEMA AS SchemaName,
    TABLE_NAME   AS TableName
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'bronze'
  AND TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO


/* ================================================================================
   FIN DU SCRIPT
================================================================================

La structure de la couche Bronze est prête à recevoir les données du Titanic.

Tables concernées :
    - bronze.train
    - bronze.test
    - bronze.gender_submission

Prochaine étape :
    Charger les fichiers CSV dans les tables Bronze, puis contrôler le nombre
    de lignes importées et vérifier la qualité initiale des données.

================================================================================
*/
