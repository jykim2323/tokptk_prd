use TokStk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop T2HHOUPT Table'
PRINT '----------------------------------------------'
PRINT ''

DROP   TABLE T2HHOUPT
GO

PRINT 'Starting CREATION OF T2HHOUPT TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE T2HHOUPT
(       
        HO_DATE       VARCHAR(08)    DEFAULT(''),   /* 일자 */ 
        HO_CHASU      VARCHAR(03)    DEFAULT(''),    /* 차수 */
        HO_CODE       VARCHAR(18)    DEFAULT(''),   /* 제품코드 */ 
        HO_LOTNO      VARCHAR(20)    DEFAULT(''),   /* 로트번호 */ 
        HO_CUST       VARCHAR(30)    DEFAULT(''),            
        HO_QTY 	      NUMERIC(7,2)    DEFAULT(0),    /* 수량 */    
        HO_OUTQTY     NUMERIC(7,2)    DEFAULT(0),    /* 출고수량 */          
        HO_BOXNO      VARCHAR(30)    DEFAULT(''),  
        HO_REMARK     VARCHAR(30)    DEFAULT(''),          
        HO_FLAG       VARCHAR(01)    DEFAULT('N'),  /* 처리상태	*/ 
        HO_TIME       VARCHAR(10)    DEFAULT(''),   /* 시간 */          
        CONSTRAINT PK_T2HHOUPT PRIMARY KEY CLUSTERED
             ( HO_DATE,HO_CHASU,HO_CODE, HO_LOTNO, HO_CUST
             )

)
GO

/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/


select * from T2HHOUPT

	
