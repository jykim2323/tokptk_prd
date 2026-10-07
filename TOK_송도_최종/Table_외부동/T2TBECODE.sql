use TokStk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop T2TBECODE Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.T2TBECODE
GO

PRINT 'Starting CREATION OF TIECODE TABLE'
PRINT '----------------------------------------------'
PRINT ''
GO
CREATE TABLE dbo.T2TBECODE
(       
        err_ecode	   VARCHAR(4)  NOT NULL,           /*에러코드        */
        err_desc	   VARCHAR(50) DEFAULT(''),        /*에러코드(머신에러)  */  
        CONSTRAINT PK_T2ERR_PKEY PRIMARY KEY CLUSTERED
             (  err_ecode
             )
)
go
PRINT 'TIECODE table CREATION ....OK'
PRINT '----------------------------------------------'
PRINT ''
GO

/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/

SELECT * FROM T2TBECODE;
GO
