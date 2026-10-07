/**********************************************************/
/*****    TABLE NAME : TBSCC2                         *****/
/*****    PRIME KEY  : PK_SCCI_PKEY                   *****/
/*****    내      용 : S/C SCC입력 FILE               *****/
/**********************************************************/
use Tokstk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop  T2TBCVC2 Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.T2TBCVC2
GO

PRINT 'Starting CREATION OF TBCVC2 TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.T2TBCVC2
(
        CVC2_SR	 	        CHAR(1)  NOT NULL,             /*S/R  */
        CVC2_CH01		VARCHAR(16) DEFAULT('0000000000000000'),
        CVC2_CH02		VARCHAR(16) DEFAULT('0000000000000000'),
	    CVC2_CH03		VARCHAR(16) DEFAULT('0000000000000000'),	     
        CONSTRAINT PK_T2CVC2 PRIMARY KEY CLUSTERED
             ( CVC2_SR
             )

)
GO

/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/


DECLARE
	@l_c_chanl	CHAR(16)

BEGIN
      SET @l_c_chanl =  '0000000000000000'   
    
      BEGIN TRAN

        INSERT INTO T2TBCVC2( CVC2_SR) VALUES('S'); 
        INSERT INTO T2TBCVC2( CVC2_SR) VALUES('R');   
	    
       COMMIT TRAN       

END 
GO 


SELECT * FROM T2TBCVC2;
GO

