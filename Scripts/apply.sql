--**********************************
--  DO NOT BREAK VERSIONING SCHEME
--***********************************

-- Current Version
EXEC cicd.CheckVersion '00000000-0000-0000-0000-000000000000'
IF @@ERROR <> 0
    SET NOEXEC ON
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
EXEC cicd.SetVersion '11111111-1111-1111-1111-111111111111'

SET NOEXEC OFF
