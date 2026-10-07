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
DROP   TABLE dbo.T2TBSCC1
GO

PRINT 'Starting CREATION OF TBSCC1 TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.T2TBSCC1
(
        SCC1_SR	 	CHAR(1)   NOT NULL,                     /*SC번호(1 - 3)   */
        SCC1_CH01 	CHAR(16)  DEFAULT '0000000000000000',   /*format01        */
        SCC1_CH02 	CHAR(04)  DEFAULT '0000',   /*format02        */
        SCC1_CH03 	CHAR(04)  DEFAULT '0000',   /*format03        */
        SCC1_CH04 	CHAR(04)  DEFAULT '0000',   /*format04        */ 
        SCC1_CH05 	CHAR(04)  DEFAULT '0000',   /*format05        */ 
		SCC1_CH06 	CHAR(04)  DEFAULT '0000',   /*입고ST        */ 
        SCC1_CH07 	CHAR(04)  DEFAULT '0000',   /*출고ST        */    		
        SCC1_CH08 	CHAR(16)  DEFAULT '0000000000000000',   /*format06        */   
        CONSTRAINT PK_T2SCC1_PKEY PRIMARY KEY CLUSTERED
             ( SCC1_SR
             )

)
GO

/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/


DECLARE
	@l_c_chanl	CHAR(16)        

BEGIN
      SET @l_c_chanl  =  '0000000000000000'   
    
      BEGIN TRAN

        INSERT INTO T2TBSCC1( SCC1_SR) VALUES( 'S');		

        INSERT INTO T2TBSCC1( SCC1_SR) VALUES( 'R');	
	    
       COMMIT TRAN       

END 
GO 


SELECT * FROM T2TBSCC1;
GO


