/*
====================================================================================
SCRIPT       : Création de la base de données et des schémas
====================================================================================


DESCRIPTION
------------
Ce script permet d'initialiser l'environnement de travail du projet Titanic.

Il réalise les opérations suivantes :
    1. Vérification de l'existence de la base de données Titanic.
    2. Suppression de la base existante, si nécessaire.
    3. Création d'une nouvelle base de données Titanic.
    4. Création des schémas Bronze, Silver et Gold.

ARCHITECTURE DES DONNÉES : MEDALLION ARCHITECTURE
-------------------------------------------------
L'organisation des données repose sur une architecture en trois couches :

    - BRONZE : stockage des données brutes provenant des sources originales.
    - SILVER : nettoyage, validation et structuration des données.
    - GOLD   : données consolidées et préparées pour l'analyse,
               la visualisation et la prise de décision.

OBJECTIF
--------
Mettre en place une architecture de données structurée, facilitant
l'intégration, la préparation et l'exploitation des données du Titanic.

ATTENTION
---------
Ce script supprime définitivement la base de données Titanic si elle existe
déjà. Toutes les données qu'elle contient seront perdues.

====================================================================================
*/


/* ================================================================================
   ÉTAPE 1 : VÉRIFICATION ET SUPPRESSION DE LA BASE EXISTANTE
================================================================================ */

IF EXISTS (SELECT 1FROM sys.databases WHERE name = 'Titanic')
BEGIN
    ALTER DATABASE Titanic SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE Titanic;
END;
GO


/* ================================================================================
   ÉTAPE 2 : CRÉATION DE LA BASE DE DONNÉES
================================================================================ */

CREATE DATABASE Titanic;
GO

USE Titanic;
GO


/* ================================================================================
   ÉTAPE 3 : CRÉATION DES SCHÉMAS DE L'ARCHITECTURE MEDALLION
================================================================================ */

/* Couche Bronze : données brutes */
CREATE SCHEMA bronze;
GO

/* Couche Silver : données nettoyées et structurées */
CREATE SCHEMA silver;
GO

/* Couche Gold : données finales destinées à l'analyse */
CREATE SCHEMA gold;
GO


/* ================================================================================
   FIN DU SCRIPT
================================================================================

La base de données Titanic est initialisée avec succès.

Les trois schémas sont disponibles pour accueillir les tables correspondant
aux différentes étapes du traitement des données.

Prochaine étape :
    - Charger les données originales dans le schéma Bronze.
    - Nettoyer et structurer les données dans le schéma Silver.
    - Préparer les données analytiques dans le schéma Gold.

================================================================================
*/
