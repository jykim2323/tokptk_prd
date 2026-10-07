/*********************************************************/
/*****    TABLE NAME : MIGUBN2(구분1)             *****/
/*****    PRIME KEY  : PK_GUBN2_PKEY                   *****/
/*****    내      용 : ITEM ITEM-GUBN2ER FILE          *****/
/*****    창      고 : 자동창고                       *****/
/*****    작  성  일 : 			              *****/
/*********************************************************/
use TokSTk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop MIGUBN2 Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.MIGUBN2
GO

PRINT 'Starting CREATION OF MIGUBN2 TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.MIGUBN2
(
        GUBN2_CODE 	VARCHAR(01)    NOT NULL,             /*제품코드   */       
        GUBN2_NAME 	VARCHAR(50)   DEFAULT(''),          /*품명       */                    
        GUBN2_DATE 	SMALLDATETIME  default (getdate()),  /*작업일자   */     
        CONSTRAINT PK_GUBN2_PKEY PRIMARY KEY CLUSTERED
             ( GUBN2_CODE
             )

)
GO
/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/
