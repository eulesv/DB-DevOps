--**********************************
--  DO NOT BREAK VERSIONING SCHEME
--***********************************

DECLARE @check BIT
-- Current Version
EXEC @check = cicd.CheckVersion '00000000-0000-0000-0000-000000000000'
IF(@check <> 1)
BEGIN
    RAISERROR('Unknown version', 18, 0)
    SET NOEXEC ON
END
GO

--********************
-- BEGIN CHANGES CODE
--********************
--##!



--##!
--********************
-- END CHANGES CODE
--********************

-- Version AFTER changes
EXEC cicd.SetCurrentVersion '11111111-1111-1111-1111-111111111111'

SET NOEXEC OFF
