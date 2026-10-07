/**********************************************************/
/*****    TABLE NAME : TBSCC2                         *****/
/*****    PRIME KEY  : PK_SCCI_PKEY                   *****/
/*****    내      용 : S/C SCC입력 FILE               *****/
/**********************************************************/
use Tokstk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop  T2TBSCC3 Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.T2TBSCC3
GO

PRINT 'Starting CREATION OF T2TBSCC3 TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.T2TBSCC3
(
        SCC3_SR	 	        CHAR(1)  NOT NULL,             /*S/R  */
        SCC3_CH01		VARCHAR(16) DEFAULT('0000000000000000'),
        SCC3_CH02		VARCHAR(04) DEFAULT('0000'),
	    SCC3_CH03		VARCHAR(04) DEFAULT('0000'),
	    SCC3_CH04		VARCHAR(04) DEFAULT('0000'),
	    SCC3_CH05		VARCHAR(04) DEFAULT('0000'), 
        SCC3_CH06		VARCHAR(04) DEFAULT('0000'), 
        SCC3_CH07		VARCHAR(04) DEFAULT('0000'),  
        CONSTRAINT PK_T2SCC3 PRIMARY KEY CLUSTERED
             ( SCC3_SR
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

        INSERT INTO T2TBSCC3( SCC3_SR) VALUES('S'); 
        INSERT INTO T2TBSCC3( SCC3_SR) VALUES('R');   
	    
       COMMIT TRAN       

END 
GO 


SELECT * FROM T2TBSCC3;
GO

