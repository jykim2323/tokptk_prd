/***********************************************************/
/*****    TABLE NAME  : STOK_ALL                         *****/
/*****    PRIME KEY   : PK_STOK_PKEY                   *****/
/*****    DESCRIPTION : 창고 전체재고FILE(MRP/ERP사용) *****/
/*****                : 건들지 말 것                   *****/
/*****    STOK_WH: 1=자동 2=수동                       *****/
/***********************************************************/
use TokStk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop STOK_ALL VIEW Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   view  dbo.STOK_ALL
GO

PRINT 'Starting CREATION OF STOK_ALL VIEW'
PRINT '----------------------------------------------'
PRINT ''
GO

CREATE VIEW  dbo.STOK_ALL
(
         STOK_WH, STOK_FLAG, STOK_LOCA, STOK_ITEM,  STOK_LOTNO, STOK_QTY, STOK_RQTY, STOK_BOXNO, STOK_REMARK, STOK_INDATE, STOK_INTIME
)
AS
(  
 
  
  SELECT 'A', SUBK_FLAG, SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK, SUBK_INDATE, SUBK_INTIME   
  FROM   MISUBK1
  WHERE  SUBK_CODE <> ''  And Substring(SUBK_LOCA, 1,1) = 'A'
  
   UNION
  SELECT 'B', SUBK_FLAG, SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_RWGT, SUBK_BOXNO,SUBK_REMARK, SUBK_INDATE, SUBK_INTIME   
  FROM   MISUBK1
  WHERE  SUBK_CODE <> ''  And Substring(SUBK_LOCA, 1,1) = 'B'

   UNION
  SELECT 'C', SUBK_FLAG, SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK, SUBK_INDATE, SUBK_INTIME   
  FROM   MISUBK1
  WHERE  SUBK_CODE <> ''  And Substring(SUBK_LOCA, 1,1) = 'C'
  
   UNION
  SELECT 'D', SUBK_FLAG, SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK, SUBK_INDATE, SUBK_INTIME   
  FROM   MISUBK1
  WHERE  SUBK_CODE <> ''  And Substring(SUBK_LOCA, 1,1) = 'D'

   UNION
  SELECT 'E', SUBK_FLAG, SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_RWGT, SUBK_BOXNO, SUBK_REMARK, SUBK_INDATE, SUBK_INTIME   
  FROM   MISUBK1
  WHERE  SUBK_CODE <> ''  And Substring(SUBK_LOCA, 1,1) = 'E'

  UNION

  SELECT 'S', SUBK_FLAG, 'S' + SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_RWGT, '', SUBK_REMARK, SUBK_INDATE, SUBK_INTIME  
  FROM   MISUBK
  WHERE  SUBK_CODE <> ''  

  UNION

  SELECT 'W', SUBK_FLAG, 'W' + SUBK_LOCA, SUBK_CODE, SUBK_LOTNO, SUBK_WGT, SUBK_RWGT, '', SUBK_REMARK, SUBK_INDATE, SUBK_INTIME  
  FROM   T2MISUBK
  WHERE  SUBK_CODE <> ''  
  
)
GO

PRINT 'STOK_ALL VIEW creation completed !!'
PRINT '----------------------------------------------'
PRINT ''
GO

SELECT * FROM STOK_ALL
go
