use tokstk_db
set nocount on
Go


PRINT '----------------------------------------------'
PRINT 'Drop SUBK_VIEW_VIEW VIEW Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   view  T2SUBK_VIEW
GO

PRINT 'Starting CREATION OF LINE_VIEW VIEW'
PRINT '----------------------------------------------'
PRINT ''
GO
CREATE VIEW  T2SUBK_VIEW
(
       STK_CODE, STK_LOTNO,  STK_TQTY
)
AS
( 
  SELECT SUBK_CODE, SUBK_LOTNO,  SUM(SUBK_WGT)
  FROM   T2MISUBK (NOLOCK)
  WHERE  ISNULL(SUBK_CODE, '') <> ''
  GROUP BY SUBK_CODE, SUBK_LOTNO    
)
GO
PRINT 'SUBK_VIEW VIEW creation completed !!'
PRINT '----------------------------------------------'
PRINT ''
GO

