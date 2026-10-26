/*
====================================================================================
SCRIPT       : Création des tables de la couche Silver
BASE DE DONNÉES : Titanic
COUCHE       : Silver
====================================================================================

DESCRIPTION
------------
Ce script crée les tables Silver destinées à recevoir les données nettoyées
et converties depuis la couche Bronze.

TABLES CIBLES
-------------
    1. silver.train : données d'entraînement avec la variable Survived.
    2. silver.test  : données de test sans la variable Survived.

RÈGLES DE GESTION
-----------------
    - Création du schéma Silver s'il n'existe pas.
    - Création des tables uniquement si elles n'existent pas.
    - Utilisation de types de données adaptés aux colonnes.
    - Aucune colonne technique supplémentaire.

====================================================================================
*/

USE Titanic;
GO

/* ================================================================================
   ÉTAPE 1 : CRÉATION DU SCHÉMA SILVER
================================================================================ */

IF SCHEMA_ID(N'silver') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA silver;');
END;
GO


/* ================================================================================
   ÉTAPE 2 : CRÉATION DE LA TABLE SILVER.TRAIN
================================================================================ */

IF OBJECT_ID(N'silver.train', N'U') IS NULL
BEGIN
    CREATE TABLE silver.train
    (
        PassengerId INT,
        Survived    INT,
        Pclass      INT,
        Name        NVARCHAR(255),
        Sex         NVARCHAR(50),
        Age         FLOAT,
        SibSp       INT,
        Parch       INT,
        Ticket      NVARCHAR(100),
        Fare        FLOAT,
        Cabin       NVARCHAR(100),
        Embarked    NVARCHAR(50),
		dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT 'Table silver.train créée avec succès.';
END
ELSE
BEGIN
    PRINT 'La table silver.train existe déjà.';
END;
GO


/* ================================================================================
   ÉTAPE 3 : CRÉATION DE LA TABLE SILVER.TEST
================================================================================ */

IF OBJECT_ID(N'silver.test', N'U') IS NULL
BEGIN
    CREATE TABLE silver.test
    (
        PassengerId INT,
        Pclass      INT,
        Name        NVARCHAR(255),
        Sex         NVARCHAR(50),
        Age         FLOAT,
        SibSp       INT,
        Parch       INT,
        Ticket      NVARCHAR(100),
        Fare        FLOAT,
        Cabin       NVARCHAR(100),
        Embarked    NVARCHAR(50),
		dwh_create_date DATETIME2 DEFAULT GETDATE()
    );

    PRINT 'Table silver.test créée avec succès.';
END
ELSE
BEGIN
    PRINT 'La table silver.test existe déjà.';
END;
GO


/* ================================================================================
   ÉTAPE 4 : VÉRIFICATION DES TABLES SILVER
================================================================================ */

SELECT
    TABLE_SCHEMA AS Nom_Schema,
    TABLE_NAME   AS Nom_Table
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = N'silver'
  AND TABLE_TYPE = N'BASE TABLE'
  AND TABLE_NAME IN (N'train', N'test')
ORDER BY TABLE_NAME;
GO