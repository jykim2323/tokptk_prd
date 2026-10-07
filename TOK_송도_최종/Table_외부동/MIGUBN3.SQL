/*********************************************************/
/*****    TABLE NAME : MIGUBN3(구분1)             *****/
/*****    PRIME KEY  : PK_GUBN3_PKEY                   *****/
/*****    내      용 : ITEM ITEM-GUBN3ER FILE          *****/
/*****    창      고 : 자동창고                       *****/
/*****    작  성  일 : 			              *****/
/*********************************************************/
use TokSTk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop MIGUBN3 Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.MIGUBN3
GO

PRINT 'Starting CREATION OF MIGUBN3 TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.MIGUBN3
(
        GUBN3_CODE 	VARCHAR(01)    NOT NULL,             /*제품코드   */       
        GUBN3_NAME 	VARCHAR(50)   DEFAULT(''),          /*품명       */                    
        GUBN3_DATE 	SMALLDATETIME  default (getdate()),  /*작업일자   */     
        CONSTRAINT PK_GUBN3_PKEY PRIMARY KEY CLUSTERED
             ( GUBN3_CODE
             )

)
GO
/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/
