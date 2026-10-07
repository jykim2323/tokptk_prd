/**********************************************************/
/*****    TABLE NAME : TBSCC2                         *****/
/*****    PRIME KEY  : PK_SCCI_PKEY                   *****/
/*****    내      용 : S/C SCC입력 FILE               *****/
/**********************************************************/
use Tokstk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop  T2TBSCC2 Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.T2TBSCC2
GO

PRINT 'Starting CREATION OF TBSCC2 TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.T2TBSCC2
(
        SCC2_SR	 	        CHAR(1)  NOT NULL,             /*S/R  */
        SCC2_CH01		VARCHAR(16) DEFAULT('0000000000000000'),
        SCC2_CH02		VARCHAR(04) DEFAULT('0000'),
	    SCC2_CH03		VARCHAR(04) DEFAULT('0000'),
	    SCC2_CH04		VARCHAR(04) DEFAULT('0000'),
	    SCC2_CH05		VARCHAR(04) DEFAULT('0000'), 
        SCC2_CH06		VARCHAR(04) DEFAULT('0000'),
        SCC2_CH07		VARCHAR(04) DEFAULT('0000'),         
        CONSTRAINT PK_T2SCC2 PRIMARY KEY CLUSTERED
             ( SCC2_SR
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

        INSERT INTO T2TBSCC2( SCC2_SR) VALUES('S'); 
        INSERT INTO T2TBSCC2( SCC2_SR) VALUES('R');   
	    
       COMMIT TRAN       

END 
GO 


SELECT * FROM T2TBSCC2;
GO

