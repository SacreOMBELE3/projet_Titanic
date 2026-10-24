USE [TitanicAnalytics];
GO

IF OBJECT_ID(N'gold.train_features', N'U') IS NULL
BEGIN
    CREATE TABLE [gold].[train_features] (
        [PassengerId] INT NOT NULL,
        [Survived] INT NOT NULL,
        [Pclass] INT NULL,
        [Sex] NVARCHAR(50) NULL,
        [Age] FLOAT NULL,
        [SibSp] INT NULL,
        [Parch] INT NULL,
        [Fare] FLOAT NULL,
        [Embarked] NVARCHAR(50) NULL,
        [FamilySize] FLOAT NULL,
        [IsAlone] INT NOT NULL,
        [Title] NVARCHAR(50) NULL,
        [Deck] NVARCHAR(10) NULL
    );
END;

IF OBJECT_ID(N'gold.test_features', N'U') IS NULL
BEGIN
    CREATE TABLE [gold].[test_features] (
        [PassengerId] INT NOT NULL,
        [Pclass] INT NULL,
        [Sex] NVARCHAR(50) NULL,
        [Age] FLOAT NULL,
        [SibSp] INT NULL,
        [Parch] INT NULL,
        [Fare] FLOAT NULL,
        [Embarked] NVARCHAR(50) NULL,
        [FamilySize] FLOAT NULL,
        [IsAlone] INT NOT NULL,
        [Title] NVARCHAR(50) NULL,
        [Deck] NVARCHAR(10) NULL
    );
END;
GO
