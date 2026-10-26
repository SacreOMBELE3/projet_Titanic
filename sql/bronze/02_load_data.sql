/*
====================================================================================
                         PROJET TITANIC ANALYTICS
====================================================================================

SCRIPT        : Chargement des données dans la couche Bronze
PROCEDURE     : bronze.load_bronze
BASE DE DONNÉES : Titanic

TABLES CIBLES
-------------
    1. bronze.test
    2. bronze.train
    3. bronze.gender_submission

FONCTIONNALITÉS
---------------
    - Chargement des fichiers CSV.
    - Suppression des anciennes données avant le chargement.
    - Mesure du temps de chargement.
    - Gestion des erreurs avec TRY...CATCH.

====================================================================================
*/

USE [Titanic];
GO


CREATE OR ALTER PROCEDURE [bronze].[load_bronze]
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE
        @start_time       DATETIME,
        @end_time         DATETIME,
        @watch_start_time DATETIME,
        @watch_end_time   DATETIME;

    BEGIN TRY

        SET @watch_start_time = GETDATE();

        PRINT '=========================================';
        PRINT 'IMPORTATION ET CHARGEMENT DE BRONZE LAYER';
        PRINT '=========================================';


        /* ============================================================
           1. CHARGEMENT DE LA TABLE BRONZE.TEST
        ============================================================ */

        PRINT '-----------------------------------------';
        PRINT 'Chargement de la table bronze.test';
        PRINT '-----------------------------------------';

        SET @start_time = GETDATE();

        PRINT 'Suppression des anciennes données : bronze.test';

        TRUNCATE TABLE [bronze].[test];

        PRINT 'Insertion des données dans bronze.test';

        BULK INSERT [bronze].[test]
        FROM 'C:\Users\hp\Downloads\titanic\data\processed\test_clean.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            ROWTERMINATOR = '0x0a',
            TABLOCK,
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();

        PRINT 'Chargement de bronze.test terminé.';
        PRINT 'Durée de chargement : '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' secondes';

        PRINT '-----------------------------------------';


        /* ============================================================
           2. CHARGEMENT DE LA TABLE BRONZE.TRAIN
        ============================================================ */

        PRINT 'Chargement de la table bronze.train';

        SET @start_time = GETDATE();

        PRINT 'Suppression des anciennes données : bronze.train';

        TRUNCATE TABLE [bronze].[train];

        PRINT 'Insertion des données dans bronze.train';

        BULK INSERT [bronze].[train]
        FROM 'C:\Users\hp\Downloads\titanic\data\processed\train_clean.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            ROWTERMINATOR = '0x0a',
            TABLOCK,
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();

        PRINT 'Chargement de bronze.train terminé.';
        PRINT 'Durée de chargement : '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' secondes';

        PRINT '-----------------------------------------';


        /* ============================================================
           3. CHARGEMENT DE LA TABLE BRONZE.GENDER_SUBMISSION
        ============================================================ */

        PRINT 'Chargement de la table bronze.gender_submission';

        SET @start_time = GETDATE();

        PRINT 'Suppression des anciennes données : bronze.gender_submission';

        TRUNCATE TABLE [bronze].[gender_submission];

        PRINT 'Insertion des données dans bronze.gender_submission';

        BULK INSERT [bronze].[gender_submission]
        FROM 'C:\Users\hp\Downloads\titanic\data\bronze\gender_submission.csv'
        WITH
        (
            FORMAT = 'CSV',
            FIRSTROW = 2,
            FIELDQUOTE = '"',
            ROWTERMINATOR = '0x0a',
            TABLOCK,
            CODEPAGE = '65001'
        );

        SET @end_time = GETDATE();

        PRINT 'Chargement de bronze.gender_submission terminé.';
        PRINT 'Durée de chargement : '
            + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(20))
            + ' secondes';

        PRINT '-----------------------------------------';


        /* ============================================================
           4. VÉRIFICATION DU NOMBRE DE LIGNES
        ============================================================ */

        PRINT '=========================================';
        PRINT 'VÉRIFICATION DES DONNÉES CHARGÉES';
        PRINT '=========================================';

        SELECT
            'bronze.test' AS NomTable,
            COUNT_BIG(*) AS NombreLignes
        FROM [bronze].[test]

        UNION ALL

        SELECT
            'bronze.train',
            COUNT_BIG(*)
        FROM [bronze].[train]

        UNION ALL

        SELECT
            'bronze.gender_submission',
            COUNT_BIG(*)
        FROM [bronze].[gender_submission];


        /* ============================================================
           5. TEMPS TOTAL D'EXÉCUTION
        ============================================================ */

        SET @watch_end_time = GETDATE();

        PRINT '=========================================';
        PRINT 'CHARGEMENT DE BRONZE LAYER TERMINÉ';
        PRINT 'Durée totale : '
            + CAST(
                DATEDIFF(SECOND, @watch_start_time, @watch_end_time)
                AS NVARCHAR(20)
              )
            + ' secondes';
        PRINT '=========================================';

    END TRY

    BEGIN CATCH

        PRINT '=========================================';
        PRINT 'ERREUR LORS DU CHARGEMENT DE BRONZE LAYER';
        PRINT 'Message d''erreur : ' + ERROR_MESSAGE();
        PRINT 'Numéro d''erreur : '
            + CAST(ERROR_NUMBER() AS NVARCHAR(20));
        PRINT 'Ligne de l''erreur : '
            + CAST(ERROR_LINE() AS NVARCHAR(20));
        PRINT '=========================================';

        THROW;

    END CATCH

END;
GO


/* ============================================================
   EXÉCUTION DE LA PROCÉDURE
============================================================ */

EXEC [bronze].[load_bronze];

