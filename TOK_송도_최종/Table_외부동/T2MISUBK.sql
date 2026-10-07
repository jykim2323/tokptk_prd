use TokStk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop T2MIINPT Table'
PRINT '----------------------------------------------'
PRINT ''

DROP	TABLE	T2MISUBK
GO

CREATE	TABLE	T2MISUBK
		(
                        SUBK_LOCA	VARCHAR(07) DEFAULT(''),		/* 저장위치	*/                                
                        SUBK_CODE	VARCHAR(18) NOT NULL,		/* 품번코드	*/ 
                        SUBK_LOTNO	VARCHAR(20) DEFAULT(''),		/* LOT-NO	*/ 		
			            SUBK_FLAG	VARCHAR(01) DEFAULT(''),		/* 작업 Flag	*/
                        SUBK_GUBUN      VARCHAR(01) DEFAULT(''),		/* 입고구분	*/                                  
                        SUBK_WGT        NUMERIC(7,2) DEFAULT(0),            /* 재고수량 */   
                        SUBK_RWGT	NUMERIC(7,2) DEFAULT(0),            /* 예약 수량 */ 
                        SUBK_BOXNO  VARCHAR(30) DEFAULT(''),		/* BOXNO	*/ 
                        SUBK_REMARK     VARCHAR(30) DEFAULT(''),		/* REMARK	*/                                                 	
                        SUBK_INDATE	VARCHAR(08) DEFAULT(''),		/* 입고일자	*/
						SUBK_PLTNO  VARCHAR(12) NOT NULL,       /* PLTNO */  -- 김준영 추가
						SUBK_INTIME	VARCHAR(06) DEFAULT(''),		/* 입고시간	*/                      
						SUBK_USERID VARCHAR(10) DEFAULT(''),    /* USER ID */  -- 김준영 추가 
                       	CONSTRAINT	PK_T2SUBK	PRIMARY	KEY CLUSTERED
             ( SUBK_PLTNO, SUBK_CODE, SUBK_LOTNO )
)  
GO

