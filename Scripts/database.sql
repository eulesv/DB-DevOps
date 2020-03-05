USE master
GO

IF NOT EXISTS (
    SELECT 1
        FROM [sys].[databases]
        WHERE
            [name] = N'DevBench'
)
CREATE DATABASE DevBench