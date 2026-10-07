
use TokStk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop MIINPT Table'
PRINT '----------------------------------------------'
PRINT ''

DROP   TABLE T2MIINPT
GO

PRINT 'Starting CREATION OF MIINPT TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE  T2MIINPT
(
        INPT_INDATE	VARCHAR(08)    NOT NULL,	/* 입고일자	*/
        INPT_INDEX	VARCHAR(13)    NOT NULL,	/* 작업 순번	*/        
        INPT_CODE	VARCHAR(18)    NOT NULL,	/* 품번코드	*/                        
        INPT_LOTNO	VARCHAR(20)    DEFAULT(''),	/* LOtno        */                            	                  					
	INPT_WEIGHT	NUMERIC(7,2)   DEFAULT(''),		/* 입고중랼  	*/                                       
        INPT_LOCA       VARCHAR(4)  DEFAULT(''),		/* 저장위치  	*/
        INPT_HOGI	VARCHAR(01)    DEFAULT(''),	/* 호기       */ 
	INPT_GUBUN	VARCHAR(01)    DEFAULT(''),		/* 입고구분	*/ 	
	INPT_STATION	VARCHAR(02) DEFAULT(''),		/* 입고위치구분 */             
        INPT_STIME	VARCHAR(06)    DEFAULT(''),		/* 시작 시간	*/
	INPT_ETIME	VARCHAR(06)    DEFAULT(''),		/* 종료시간	*/
        INPT_RFLAG	VARCHAR(01)    DEFAULT(''),		/* 재입고구분	*/              
	INPT_JOB_FLAG	VARCHAR(01)    DEFAULT(''),		/* 작업 Flag	*/
        INPT_RDATE	VARCHAR(08)    DEFAULT(''),		/* 재입고	*/
        INPT_RTIME	VARCHAR(06)    DEFAULT(''),		/* 재입고시간	*/ 
        INPT_OINDEX	VARCHAR(13)    DEFAULT(''),		/* 출고순번	*/
        INPT_BOXNO       VARCHAR(30)    DEFAULT(''),		/* BOXNO	*/
        INPT_REMARK      VARCHAR(30)    DEFAULT(''),		/* REMARK	*/                
        INPT_ID	        VARCHAR(10)    DEFAULT(''),		/* USERID	*/
        INPT_LABEL	        VARCHAR(01)    DEFAULT('N'),		/* LABEL 프린트	*/  	
		INPT_PLTNO   VARCHAR(12) DEFAULT(''),
        CONSTRAINT PK_T2INPT PRIMARY KEY CLUSTERED
             ( INPT_INDATE, INPT_INDEX, INPT_CODE, INPT_LOTNO
             )

)
GO

