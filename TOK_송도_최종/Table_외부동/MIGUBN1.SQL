/*********************************************************/
/*****    TABLE NAME : MIGUBN1(구분1)             *****/
/*****    PRIME KEY  : PK_GUBN1_PKEY                   *****/
/*****    내      용 : ITEM ITEM-GUBN1ER FILE          *****/
/*****    창      고 : 자동창고                       *****/
/*****    작  성  일 : 			              *****/
/*********************************************************/
use TokSTk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop MIGUBN1 Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.MIGUBN1
GO

PRINT 'Starting CREATION OF MIGUBN1 TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.MIGUBN1
(
        GUBN1_CODE 	VARCHAR(01)    NOT NULL,             /*제품코드   */       
        GUBN1_NAME 	VARCHAR(50)   DEFAULT(''),          /*품명       */                    
        GUBN1_DATE 	SMALLDATETIME  default (getdate()),  /*작업일자   */     
        CONSTRAINT PK_GUBN1_PKEY PRIMARY KEY CLUSTERED
             ( GUBN1_CODE
             )

)
GO
/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/
