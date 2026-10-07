/*********************************************************/
/*****    TABLE NAME : MIMAST(품목마스타)             *****/
/*****    PRIME KEY  : PK_MAST_PKEY                   *****/
/*****    내      용 : ITEM ITEM-MASTER FILE          *****/
/*****    창      고 : 자동창고                       *****/
/*****    작  성  일 : 			              *****/
/*********************************************************/
use TokSTk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop MIMAST Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.MIMAST
GO

PRINT 'Starting CREATION OF MIMAST TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.MIMAST
(
        MAST_CODE 	VARCHAR(18)    NOT NULL,             /*제품코드   */       
        MAST_NAME 	VARCHAR(100)   DEFAULT(''),          /*품명       */
        MAST_UNIT 	VARCHAR(04)    DEFAULT(''),          /*품명       */
        MAST_WEIGHT     NUMERIC(7,2)   DEFAULT(0),           /*단위중량	  */ 
        MAST_GUBN1 	VARCHAR(01)    DEFAULT(''),          /*구분#1       */   
        MAST_GUBN2 	VARCHAR(01)    DEFAULT(''),          /*구분#2       */
        MAST_GUBN3 	VARCHAR(01)    DEFAULT(''),          /*구분#3       */         
		MAST_REF1   VARCHAR(100)   DEFAULT(''),          /* 추가정보1 */
        MAST_DATE 	SMALLDATETIME  default (getdate()),  /*작업일자   */     
        CONSTRAINT PK_MAST_PKEY PRIMARY KEY CLUSTERED
             ( MAST_CODE
             )

)
GO
/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/
