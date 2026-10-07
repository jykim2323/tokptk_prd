use TokStk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop STK1_STOK VIEW2 Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   view  STOK_VIEW2
GO

PRINT 'Starting CREATION OF STK2_STOK_VIEW'
PRINT '----------------------------------------------'
PRINT ''
GO

CREATE VIEW  dbo.STOK_VIEW2
(
      STOK_CODE, STOK_LOTNO, STOK_QTY
)
AS
( 
  SELECT SUBK_CODE, SUBK_LOTNO, SUM(SUBK_WGT) SUBK_WGTO
  FROM T2MISUBK
  LEFT OUTER JOIN T2MILSTK (NOLOCK) ON LSTK_LOCA = SUBK_LOCA 
  WHERE  SUBK_FLAG = '1' And LSTK_FLAG = '1'
  GROUP BY SUBK_CODE, SUBK_LOTNO
)
GO

PRINT 'STK2_STOK_VIEW2 creation completed !!'
PRINT '----------------------------------------------'
PRINT ''
GO

SELECT * FROM STOK_VIEW2
go
