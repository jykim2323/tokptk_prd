use tokstk_db
set nocount on
Go


PRINT '----------------------------------------------'
PRINT 'Drop OUPT_VIEW_VIEW VIEW Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   view  T2OUPT_VIEW
GO

PRINT 'Starting CREATION OF LINE_VIEW VIEW'
PRINT '----------------------------------------------'
PRINT ''
GO
CREATE VIEW  T2OUPT_VIEW
(
       STK_DATE, STK_CODE, STK_LOTNO,  STK_TQTY
)
AS
( 
  SELECT OUPT_DATE, OUPT_CODE, OUPT_LOTNO,  SUM(oupt_out_wgt)
  FROM   T2MIOUPT (NOLOCK)
  WHERE  OUPT_job_flag <> '0' 
  GROUP BY OUPT_DATE, OUPT_CODE, OUPT_LOTNO   
  
)
GO
PRINT 'OUPT_VIEW VIEW creation completed !!'
PRINT '----------------------------------------------'
PRINT ''
GO

