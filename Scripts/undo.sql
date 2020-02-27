--**********************************
--  DO NOT BREAK VERSIONING SCHEME
--**********************************

DECLARE @check BIT
-- Version AFTER changes
EXEC @check = cicd.CheckVersion '11111111-1111-1111-1111-111111111111'
IF(@check <> 1)
BEGIN
    RAISERROR('Unknown version', 18, 0)
    SET NOEXEC ON
END
GO

--********************
-- BEGIN ROLLBACK CODE
--********************
--##!



--##!
--********************
-- END ROLLBACK CODE
--********************

-- Return to MODEL Version 
EXEC cicd.SetCurrentVersion '00000000-0000-0000-0000-000000000000'

SET NOEXEC OFF
