
use Tokstk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop T2MIOUPTD Table'
PRINT '----------------------------------------------'
PRINT ''

DROP   TABLE T2MIOUPTD
GO

PRINT 'Starting CREATION OF T2MIOUPT TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE T2MIOUPTD
(
        OUPT_DATE		VARCHAR(08) NOT NULL,		/* 출고일자	*/
	    OUPT_INDEX		VARCHAR(13) NOT NULL,		/* 작업 순번	*/
        OUPT_CODE		VARCHAR(18) NOT NULL,		/* 품번코드	*/ 
        OUPT_LOTNO		VARCHAR(20) DEFAULT(''),		/* LOTNO	*/ 
        OUPT_CUST		VARCHAR(30) DEFAULT(''),		
        OUPT_SEQNO		NUMERIC(04) DEFAULT(0),		/* 출고번호	*/
	    OUPT_GUBUN		VARCHAR(01) DEFAULT(''),		/* 불량구분	*/                                                       		
	    OUPT_WGT		NUMERIC(7,2) DEFAULT(0),		/* 지시수량  	*/
        OUPT_OUT_WGT	NUMERIC(7,2) DEFAULT(0),		/* 출고수량  	*/
        OUPT_RLOCA		VARCHAR(05)  DEFAULT(''),		/* 출고위치	*/
        OUPT_LOCA		VARCHAR(05)  DEFAULT(''),		/* 재고위치	*/                                
        OUPT_TIME		VARCHAR(06)  DEFAULT(''),		/* 시작 시간	*/
        OUPT_RFLAG		VARCHAR(01)  DEFAULT(''),		/* 재입고구분	*/     		                   
    	OUPT_JOB_FLAG	VARCHAR(01)  DEFAULT(''),		/* 출고 구분	*/                         
        OUPT_INDATE		VARCHAR(08)  DEFAULT(''),		/* 입고일자	*/
        OUPT_INTIME		VARCHAR(06)  DEFAULT(''),		/* 입고시간	*/  
        OUPT_BOXNO       VARCHAR(30)  DEFAULT(''),      	/* BOXNO 	*/
        OUPT_REMARK      VARCHAR(30)  DEFAULT(''),      	/* 비고 	*/  
        OUPT_ID          VARCHAR(20)  DEFAULT(''),      	/* 사용자 ID	*/  
        OUPT_LABEL       VARCHAR(01)  DEFAULT('N'),      	/* 라벨프린트	*/ 
        OUPT_CHASU       VARCHAR(03)  DEFAULT(''),      	/* 지시차수 	*/
        OUPT_BOXNO1       VARCHAR(30)  DEFAULT(''),      	/* BOXNO 	*/ 
        OUPT_REMARK1      VARCHAR(30)  DEFAULT(''),      	/* 비고 	*/                  
		OUPT_PLTNO   VARCHAR(12) DEFAULT(''),
        CONSTRAINT PK_T2OUPTD PRIMARY KEY CLUSTERED
             ( OUPT_DATE, OUPT_INDEX, OUPT_CODE, OUPT_LOTNO, OUPT_CUST, OUPT_SEQNO
             )

)
GO
/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/

