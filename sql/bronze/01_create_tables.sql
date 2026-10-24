USE [TitanicAnalytics];
GO

IF OBJECT_ID(N'bronze.train', N'U') IS NULL
BEGIN
    CREATE TABLE [bronze].[train] (
        [PassengerId] NVARCHAR(50) NULL,
        [Survived] NVARCHAR(50) NULL,
        [Pclass] NVARCHAR(50) NULL,
        [Name] NVARCHAR(255) NULL,
        [Sex] NVARCHAR(50) NULL,
        [Age] NVARCHAR(50) NULL,
        [SibSp] NVARCHAR(50) NULL,
        [Parch] NVARCHAR(50) NULL,
        [Ticket] NVARCHAR(100) NULL,
        [Fare] NVARCHAR(50) NULL,
        [Cabin] NVARCHAR(100) NULL,
        [Embarked] NVARCHAR(50) NULL,
        [SourceFile] NVARCHAR(255) NOT NULL,
        [IngestedAt] DATETIME2 NOT NULL
    );
END;

IF OBJECT_ID(N'bronze.test', N'U') IS NULL
BEGIN
    CREATE TABLE [bronze].[test] (
        [PassengerId] NVARCHAR(50) NULL,
        [Pclass] NVARCHAR(50) NULL,
        [Name] NVARCHAR(255) NULL,
        [Sex] NVARCHAR(50) NULL,
        [Age] NVARCHAR(50) NULL,
        [SibSp] NVARCHAR(50) NULL,
        [Parch] NVARCHAR(50) NULL,
        [Ticket] NVARCHAR(100) NULL,
        [Fare] NVARCHAR(50) NULL,
        [Cabin] NVARCHAR(100) NULL,
        [Embarked] NVARCHAR(50) NULL,
        [SourceFile] NVARCHAR(255) NOT NULL,
        [IngestedAt] DATETIME2 NOT NULL
    );
END;

IF OBJECT_ID(N'bronze.gender_submission', N'U') IS NULL
BEGIN
    CREATE TABLE [bronze].[gender_submission] (
        [PassengerId] NVARCHAR(50) NULL,
        [Survived] NVARCHAR(50) NULL,
        [SourceFile] NVARCHAR(255) NOT NULL,
        [IngestedAt] DATETIME2 NOT NULL
    );
END;
GO
