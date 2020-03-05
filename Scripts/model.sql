CREATE SCHEMA cicd
GO

CREATE PROCEDURE cicd.SetProperty
    @n NVARCHAR(128),
    @v NVARCHAR(128)
AS
    DECLARE @current NVARCHAR(128)
    SELECT @current = [name] FROM fn_listextendedproperty(@n, NULL, NULL, NULL, NULL, NULL, NULL)
    IF(@current IS NULL)
        EXEC sp_addextendedproperty @name = @n, @value = @v
    ELSE
         EXEC sp_updateextendedproperty @name = @n, @value = @v
GO

CREATE PROCEDURE cicd.GetProperty
    @n NVARCHAR(128),
    @v NVARCHAR(128) OUTPUT
AS
    SELECT @v = CAST([value] AS VARCHAR(128)) FROM fn_listextendedproperty(@n, NULL, NULL, NULL, NULL, NULL, NULL)
    IF(@v IS NULL)
        RETURN 1
    ELSE
        RETURN 0
GO

CREATE PROCEDURE cicd.SetVersion
    @id UNIQUEIDENTIFIER
AS
    EXEC cicd.SetProperty 'CICD-VERSION', @id
GO

CREATE PROCEDURE cicd.CheckVersion
    @id UNIQUEIDENTIFIER
AS
    DECLARE @current NVARCHAR(128)
    DECLARE @ret INT
    EXEC @ret = cicd.GetProperty'CICD-VERSION', @current OUTPUT
    IF(@ret <> 0)
        RAISERROR('Not a versioned database', 18, 0)
    IF(@current =  @id)
        RETURN 0
    ELSE
        RAISERROR('Unknown version', 18, 0)
GO

--##!
EXEC cicd.SetVersion '00000000-0000-0000-0000-000000000000'
GO
