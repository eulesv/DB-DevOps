--**********************************
--  DO NOT BREAK VERSIONING SCHEME
--**********************************

-- Version AFTER changes
EXEC cicd.CheckVersion '11111111-1111-1111-1111-111111111111'
IF @@ERROR <> 0
    SET NOEXEC ON
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
EXEC cicd.SetVersion '00000000-0000-0000-0000-000000000000'

SET NOEXEC OFF
