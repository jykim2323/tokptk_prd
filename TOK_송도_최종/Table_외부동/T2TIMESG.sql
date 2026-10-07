/**********************************************************/
/*****    TABLE NAME : TIMESG                         *****/
/*****    PRIME KEY  : PK_mesg_PKEY                   *****/
/*****    내      용 : SC에러이력 FILE                *****/
/**********************************************************/
use Tokstk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop TIMESG Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE T2TIMESG
GO

PRINT 'Starting CREATION OF TIMESG TABLE'
PRINT '----------------------------------------------'
PRINT ''
GO
CREATE TABLE T2TIMESG
(
        mesg_dt  	   VARCHAR(14) NOT NULL,           /*애러발생일          */ 
        mesg_ehogi	   VARCHAR(01)  DEFAULT(''),        /*작업위치연단        */      
        mesg_eloca	   VARCHAR(04)  DEFAULT(''),        /*작업위치연단        */
        mesg_desc	   VARCHAR(60) DEFAULT(''),        /*에러코드(머신에러)  */      
        CONSTRAINT PK_T2MESG PRIMARY KEY CLUSTERED
             ( mesg_dt, mesg_ehogi
             )
)
go
PRINT 'TIMESG table CREATION ....OK'
PRINT '----------------------------------------------'
PRINT ''
GO


/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/

SELECT * FROM T2TIMESG;
GO
