/*
===============================================================================
PROJET : TITANIC ANALYTICS
SCRIPT : Création des vues Gold
BASE   : Titanic
OBJECTIF
--------
Exposer les données nettoyées de Silver dans la couche Gold
pour faciliter l'analyse et la visualisation dans Power BI.
===============================================================================
*/

USE Titanic;
GO

/* =============================================================================
   1. CRÉATION DU SCHÉMA GOLD
============================================================================= */

IF SCHEMA_ID(N'gold') IS NULL
BEGIN
    EXEC(N'CREATE SCHEMA gold;');
END;
GO

/* =============================================================================
   2. VUE GOLD : DONNÉES D'ENTRAÎNEMENT
============================================================================= */

CREATE OR ALTER VIEW gold.vw_train
AS
SELECT
    PassengerId AS PassengerID,
    Survived    AS Survivant,
    Pclass      AS Classe_Passager,
    Name        AS Nom_Passager,
    Sex         AS Sexe,
    Age         AS Age,
    SibSp       AS Frere_soeur_epoux_bord,
    Parch       AS Parent_enfant_bord,
    Ticket      AS Number_ticket,
    Fare        AS Fare,
    Cabin       AS Cabin,
    Embarked    AS Port_enbarquement
FROM silver.train;
GO

/* =============================================================================
   3. TEST DE LA VUE
============================================================================= */

SELECT *
FROM gold.vw_train;
GO

