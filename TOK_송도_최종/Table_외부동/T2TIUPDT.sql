
use TokStk_db
GO

PRINT '----------------------------------------------'
PRINT 'Drop TIUPDTTable'
PRINT '----------------------------------------------'
PRINT ''
DROP	TABLE	T2TIUPDT
GO

PRINT 'Starting CREATION OF TIUPDTTABLE'
PRINT '----------------------------------------------'
PRINT ''


CREATE	TABLE	T2TIUPDT
		(
			UPDT_INDEX		VARCHAR(13) NOT NULL, 	
			UPDT_LOCA		VARCHAR(04) DEFAULT(''),
			UPDT_JOB		VARCHAR(01) DEFAULT(''),	
					/* I : 정상입고, R:재입고, A:보충입고 */
			UPDT_DATE		VARCHAR(08) DEFAULT(''),
			UPDT_TIME		VARCHAR(06) DEFAULT(''),
			CONSTRAINT		PK_T2UPDT	PRIMARY	KEY CLUSTERED (UPDT_INDEX)		
			
		)
GO

