USE [TitanicAnalytics];
GO

IF OBJECT_ID(N'silver.train', N'U') IS NULL
BEGIN
    CREATE TABLE [silver].[train] (
        [PassengerId] INT NOT NULL,
        [Survived] INT NOT NULL,
        [Pclass] INT NULL,
        [Name] NVARCHAR(255) NULL,
        [Sex] NVARCHAR(50) NULL,
        [Age] FLOAT NULL,
        [SibSp] INT NULL,
        [Parch] INT NULL,
        [Ticket] NVARCHAR(100) NULL,
        [Fare] FLOAT NULL,
        [Cabin] NVARCHAR(100) NULL,
        [Embarked] NVARCHAR(50) NULL
    );
END;

IF OBJECT_ID(N'silver.test', N'U') IS NULL
BEGIN
    CREATE TABLE [silver].[test] (
        [PassengerId] INT NOT NULL,
        [Pclass] INT NULL,
        [Name] NVARCHAR(255) NULL,
        [Sex] NVARCHAR(50) NULL,
        [Age] FLOAT NULL,
        [SibSp] INT NULL,
        [Parch] INT NULL,
        [Ticket] NVARCHAR(100) NULL,
        [Fare] FLOAT NULL,
        [Cabin] NVARCHAR(100) NULL,
        [Embarked] NVARCHAR(50) NULL
    );
END;
GO
