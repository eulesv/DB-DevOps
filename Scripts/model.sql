CREATE SCHEMA cicd
GO

CREATE PROCEDURE cicd.SetCurrentVersion
    @id UNIQUEIDENTIFIER
AS
    DECLARE @current NVARCHAR(128)
    SELECT @current = [name] FROM fn_listextendedproperty('CICD-VERSION', NULL, NULL, NULL, NULL, NULL, NULL)
    IF(@current IS NULL)
        EXEC sp_addextendedproperty @name = N'CICD-VERSION', @value = @id
    ELSE
         EXEC sp_updateextendedproperty @name = N'CICD-VERSION', @value = @id
GO

CREATE PROCEDURE cicd.CheckVersion
    @id UNIQUEIDENTIFIER
AS
    DECLARE @current NVARCHAR(128)
    SELECT @current = CAST([value] AS VARCHAR(128)) FROM fn_listextendedproperty('CICD-VERSION', NULL, NULL, NULL, NULL, NULL, NULL)
    IF(@current IS NULL)
        RAISERROR('Not a versioned database', 18, 0)
    IF(@current =  @id)
        RETURN 1
    ELSE
        RETURN 0
GO

--##!
EXEC cicd.SetCurrentVersion '00000000-0000-0000-0000-000000000000'
GO
