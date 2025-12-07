
IF DB_ID('UK_Immigration') IS NULL
    CREATE DATABASE UK_Immigration;
GO

USE UK_Immigration;
GO


IF OBJECT_ID('dbo.Study_Sector')      IS NOT NULL DROP TABLE dbo.Study_Sector;
IF OBJECT_ID('dbo.Study_Nationality') IS NOT NULL DROP TABLE dbo.Study_Nationality;
IF OBJECT_ID('dbo.Work_Sector')       IS NOT NULL DROP TABLE dbo.Work_Sector;
IF OBJECT_ID('dbo.Work_Nationality')  IS NOT NULL DROP TABLE dbo.Work_Nationality;
GO


 ---STUDY – BY SECTOR (FROM CAS_D01)
CREATE TABLE dbo.Study_Sector (
    Study_Sector_ID      INT IDENTITY(1,1) PRIMARY KEY,
    [Year]               SMALLINT       NOT NULL,   
    Quarter              NVARCHAR(20)   NOT NULL,   
    Quarter_Start_Date   DATE           NULL,       
    Application_Type     NVARCHAR(100)  NULL,       
    Institution_Group    NVARCHAR(200)  NULL,       
    Institution_Type     NVARCHAR(200)  NULL,       
    Applications         INT            NULL        
);
GO


-- STUDY – BY NATIONALITY (FROM CAS_D02)
CREATE TABLE dbo.Study_Nationality (
    Study_Nat_ID         INT IDENTITY(1,1) PRIMARY KEY,
    [Year]               SMALLINT       NOT NULL,
    Quarter              NVARCHAR(20)   NOT NULL,
    Quarter_Start_Date   DATE           NULL,
    Application_Type     NVARCHAR(100)  NULL,
    Institution_Group    NVARCHAR(200)  NULL,
    Geographic_Region    NVARCHAR(200)  NULL,       -- Geographical_region
    Nationality          NVARCHAR(200)  NULL,
    Applications         INT            NULL
);
GO

--  WORK – BY SECTOR (FROM CoS_D01)

CREATE TABLE dbo.Work_Sector (
    Work_Sector_ID       INT IDENTITY(1,1) PRIMARY KEY,
    [Year]               SMALLINT       NOT NULL,
    Quarter              NVARCHAR(20)   NOT NULL,
    Quarter_Start_Date   DATE           NULL,
    Application_Type     NVARCHAR(100)  NULL,       -- Type_of_application
    Visa_Category        NVARCHAR(200)  NULL,       -- Category_of_leave
    Industry             NVARCHAR(200)  NULL,
    Applications         INT            NULL
);
GO

--  WORK – BY NATIONALITY (FROM CoS_D02)

CREATE TABLE dbo.Work_Nationality (
    Work_Nat_ID          INT IDENTITY(1,1) PRIMARY KEY,
    [Year]               SMALLINT       NOT NULL,
    Quarter              NVARCHAR(20)   NOT NULL,
    Quarter_Start_Date   DATE           NULL,
    Application_Type     NVARCHAR(100)  NULL,
    Visa_Category        NVARCHAR(200)  NULL,       -- Category_of_leave
    Geographic_Region    NVARCHAR(200)  NULL,       -- Geographical_region
    Nationality          NVARCHAR(200)  NULL,
    Applications         INT            NULL
);
GO



 --- LOAD & CLEAN DATA FROM RAW TABLES

INSERT INTO dbo.Study_Sector (
    [Year],
    Quarter,
    Quarter_Start_Date,
    Application_Type,
    Institution_Group,
    Institution_Type,
    Applications
)
SELECT
    TRY_CONVERT(SMALLINT, [Year]) AS [Year],
    LTRIM(RTRIM([Quarter])) AS Quarter,
    CASE 
        WHEN TRY_CONVERT(SMALLINT, RIGHT(LTRIM(RTRIM([Quarter])), 1)) BETWEEN 1 AND 4
        THEN DATEFROMPARTS(
                TRY_CONVERT(SMALLINT, [Year]),
                (TRY_CONVERT(SMALLINT, RIGHT(LTRIM(RTRIM([Quarter])), 1)) - 1) * 3 + 1,
                1
             )
        ELSE NULL
    END                                            AS Quarter_Start_Date,
    NULLIF(LTRIM(RTRIM([Type_of_application])), '')  AS Application_Type,
    NULLIF(LTRIM(RTRIM([Institution_type_group])), '')  AS Institution_Group,
    NULLIF(LTRIM(RTRIM([Institution_type])), '')  AS Institution_Type,
    TRY_CONVERT(
        INT,
        REPLACE(
            NULLIF(CAST([Applications] AS NVARCHAR(50)), ''),
            ',',
            ''
        )
    )                                                                   AS Applications
FROM dbo.[migration-study-sponsorship-datasets-mar-2023(Data - CAS_D01)]
WHERE TRY_CONVERT(SMALLINT, [Year]) IS NOT NULL;   
GO


-- STUDY – NATIONALITY (CAS_D02 -> Study_Nationality)

INSERT INTO dbo.Study_Nationality (
    [Year],
    Quarter,
    Quarter_Start_Date,
    Application_Type,
    Institution_Group,
    Geographic_Region,
    Nationality,
    Applications
)
SELECT
    TRY_CONVERT(SMALLINT, [Year])  AS [Year],
    LTRIM(RTRIM([Quarter])) AS Quarter,
    CASE 
        WHEN TRY_CONVERT(SMALLINT, RIGHT(LTRIM(RTRIM([Quarter])), 1)) BETWEEN 1 AND 4
        THEN DATEFROMPARTS(
                TRY_CONVERT(SMALLINT, [Year]),
                (TRY_CONVERT(SMALLINT, RIGHT(LTRIM(RTRIM([Quarter])), 1)) - 1) * 3 + 1,
                1
             )
        ELSE NULL
    END                                             AS Quarter_Start_Date,
    NULLIF(LTRIM(RTRIM([Type_of_application])), '')  AS Application_Type,
    NULLIF(LTRIM(RTRIM([Institution_type_group])), '')  AS Institution_Group,
    NULLIF(LTRIM(RTRIM([Geographical_region])), '')  AS Geographic_Region,
    NULLIF(LTRIM(RTRIM([Nationality])), '') AS Nationality,
    TRY_CONVERT(
        INT,
        REPLACE(
            NULLIF(CAST([Applications] AS NVARCHAR(50)), ''),
            ',',
            ''
        )
    )        AS Applications
FROM dbo.[migration-study-sponsorship-datasets-mar-2023(Data - CAS_D02)]
WHERE TRY_CONVERT(SMALLINT, [Year]) IS NOT NULL;
GO

-- WORK – SECTOR (CoS_D01 -> Work_Sector)

INSERT INTO dbo.Work_Sector (
    [Year],
    Quarter,
    Quarter_Start_Date,
    Application_Type,
    Visa_Category,
    Industry,
    Applications
)
SELECT
    TRY_CONVERT(SMALLINT, [Year])                                       AS [Year],
    LTRIM(RTRIM([Quarter]))                                             AS Quarter,
    CASE 
        WHEN TRY_CONVERT(SMALLINT, RIGHT(LTRIM(RTRIM([Quarter])), 1)) BETWEEN 1 AND 4
        THEN DATEFROMPARTS(
                TRY_CONVERT(SMALLINT, [Year]),
                (TRY_CONVERT(SMALLINT, RIGHT(LTRIM(RTRIM([Quarter])), 1)) - 1) * 3 + 1,
                1
             )
        ELSE NULL
    END                                                                 AS Quarter_Start_Date,
    NULLIF(LTRIM(RTRIM([Type_of_application])), '')                     AS Application_Type,
    NULLIF(LTRIM(RTRIM([Category_of_leave])), '')                       AS Visa_Category,
    NULLIF(LTRIM(RTRIM([Industry])), '')                                AS Industry,
    TRY_CONVERT(
        INT,
        REPLACE(
            NULLIF(CAST([Applications] AS NVARCHAR(50)), ''),
            ',',
            ''
        )
    )                                                                   AS Applications
FROM dbo.[migration-work-sponsorship-datasets-mar-2023(Data - CoS_D01)]
WHERE TRY_CONVERT(SMALLINT, [Year]) IS NOT NULL;
GO


-- WORK – NATIONALITY (CoS_D02 -> Work_Nationality)

INSERT INTO dbo.Work_Nationality (
    [Year],
    Quarter,
    Quarter_Start_Date,
    Application_Type,
    Visa_Category,
    Geographic_Region,
    Nationality,
    Applications
)
SELECT
    TRY_CONVERT(SMALLINT, [Year])                                       AS [Year],
    LTRIM(RTRIM([Quarter]))                                             AS Quarter,
    CASE 
        WHEN TRY_CONVERT(SMALLINT, RIGHT(LTRIM(RTRIM([Quarter])), 1)) BETWEEN 1 AND 4
        THEN DATEFROMPARTS(
                TRY_CONVERT(SMALLINT, [Year]),
                (TRY_CONVERT(SMALLINT, RIGHT(LTRIM(RTRIM([Quarter])), 1)) - 1) * 3 + 1,
                1
             )
        ELSE NULL
    END                                             AS Quarter_Start_Date,
    NULLIF(LTRIM(RTRIM([Type_of_application])), '')  AS Application_Type,
    NULLIF(LTRIM(RTRIM([Category_of_leave])), '')   AS Visa_Category,
    NULLIF(LTRIM(RTRIM([Geographical_region])), '') AS Geographic_Region,
    NULLIF(LTRIM(RTRIM([Nationality])), '')    AS Nationality,
    TRY_CONVERT(
        INT,
        REPLACE(
            NULLIF(CAST([Applications] AS NVARCHAR(50)), ''),
            ',',
            ''
        )
    )                                                                   AS Applications
FROM dbo.[migration-work-sponsorship-datasets-mar-2023(Data - CoS_D02)]
WHERE TRY_CONVERT(SMALLINT, [Year]) IS NOT NULL;
GO


PRINT '=== SQL DATA CLEANING & PREPARATION COMPLETE ===';
GO


SELECT 'Study_Sector'      AS TableName, COUNT(*) AS Row_Count FROM dbo.Study_Sector
UNION ALL
SELECT 'Study_Nationality', COUNT(*) FROM dbo.Study_Nationality
UNION ALL
SELECT 'Work_Sector',       COUNT(*) FROM dbo.Work_Sector
UNION ALL
SELECT 'Work_Nationality',  COUNT(*) FROM dbo.Work_Nationality;
GO
