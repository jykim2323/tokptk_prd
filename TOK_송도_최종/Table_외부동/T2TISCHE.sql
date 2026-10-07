use Tokstk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop T2TISCHE Table'
PRINT '----------------------------------------------'
PRINT ''


DROP	TABLE	T2TISCHE
GO

PRINT 'Starting CREATION OF T2TISCHE TABLE'
PRINT '----------------------------------------------'
PRINT ''


CREATE	TABLE	T2TISCHE
		(				
			SCHE_SC			VARCHAR(01) NOT NULL,		/* Stacker no	*/		
			SCHE_INDEX		VARCHAR(13) NOT NULL,		/* Serial no	*/
			SCHE_JOBGUBUN		VARCHAR(01) DEFAULT(''),		/* 입출고 작업 구분 	*/ 
					/* I:정상입고, R: 재입고, A : 보충입고 	*/
					/* T:정상출고(Full), P : Picking 출고, U : 보충출고 	*/					
			SCHE_LOCA		VARCHAR(04) DEFAULT(''),		/* 출고 랙	*/			 
			SCHE_WSNO	VARCHAR(1) DEFAULT(''),		/* 도착위치	*/ 
                       	SCHE_DATE		VARCHAR(08) DEFAULT(''),		/* 일자         */
			SCHE_TIME		VARCHAR(06) DEFAULT(''),		/* 시 간        */	
                        SCHE_EMER		VARCHAR(1) DEFAULT(''),		/* 긴급출고 E, N  */	
			CONSTRAINT		PK_T2SCHE	PRIMARY	KEY CLUSTERED (SCHE_SC,SCHE_INDEX)
		
		)
GO
 