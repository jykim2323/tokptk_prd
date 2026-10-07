use tokstk_db
set nocount on
Go


PRINT '----------------------------------------------'
PRINT 'Drop INPT_VIEW_VIEW VIEW Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   view  T2INPT_VIEW
GO

PRINT 'Starting CREATION OF LINE_VIEW VIEW'
PRINT '----------------------------------------------'
PRINT ''
GO
CREATE VIEW  T2INPT_VIEW
(
       STK_DATE, STK_CODE, STK_LOTNO,  STK_TQTY
)
AS
( 
  SELECT INPT_INDATE, INPT_CODE, INPT_LOTNO, SUM(INPT_WEIGHT)
  FROM   T2MIINPT (NOLOCK)
  WHERE  inpt_job_flag <> '0' And inpt_rflag = 'N'
  GROUP BY INPT_INDATE, INPT_CODE, INPT_LOTNO    
  
)
GO
PRINT 'INPT_VIEW VIEW creation completed !!'
PRINT '----------------------------------------------'
PRINT ''
GO



