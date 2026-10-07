/************************************************************************/
/*****    TABLE NAME : SYSTEM정보: (TBSTAT)                         *****/
/*****    PRIME KEY  : PK_STAT_PKEY                                 *****/
/*****    내      용 : SYSTEM제어정보관리                           *****/
/************************************************************************/
use TokStk_db
GO

PRINT '----------------------------------------------'
PRINT 'Drop TBSTAT Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.T2TBSTAT
GO

PRINT 'Starting CREATION OF T2TBSTAT TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.T2TBSTAT
(
        STAT_PSWD 	CHAR(4) NOT NULL,               /*PRIMARY KEY = 'JPLS'             */
        STAT_SC1IO	CHAR(1) DEFAULT('3'),	        /* 1:입고가능,2:출고가능,3:입출가능,0:입출불가	*/
        STAT_SC2IO	CHAR(1) DEFAULT('3'),	        /* 1:입고가능,2:출고가능,3:입출가능,0:입출불가	*/
        STAT_SC3IO	CHAR(1) DEFAULT('3'),	        /* 1:입고가능,2:출고가능,3:입출가능,0:입출불가	*/ 
        STAT_IINDX	NUMERIC DEFAULT(1),									
	    STAT_OINDX	NUMERIC DEFAULT(1),		 /* 출고작업순서	 */ 
        STAT_RINDX	NUMERIC DEFAULT(1),     
        STAT_EINDX	NUMERIC DEFAULT(1),  
        STAT_CINDX	NUMERIC DEFAULT(1),    	
        STAT_DATE	VARCHAR(08) DEFAULT('20100501'), 
        STAT_ODATE	VARCHAR(08) DEFAULT('20100501'), 
        STAT_RDATE	VARCHAR(08) DEFAULT('20100501'), 
        STAT_EDATE	VARCHAR(08) DEFAULT('20100501'),  
        STAT_CDATE	VARCHAR(08) DEFAULT('20100501'), 
        STAT_CV1	CHAR(1) DEFAULT('1'),
        STAT_CV2	CHAR(1) DEFAULT('0'),
        STAT_CV3	CHAR(1) DEFAULT('1'),
        STAT_CV4	CHAR(1) DEFAULT('0'),
        STAT_CV5	CHAR(1) DEFAULT('1'),
        STAT_CV6	CHAR(1) DEFAULT('0'),	       
        CONSTRAINT PK_T2STAT PRIMARY KEY CLUSTERED
             ( STAT_PSWD
             )
)
GO
/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/

INSERT INTO T2TBSTAT (stat_PSWD) VALUES ('JPLS')
GO

SELECT * FROM T2TBSTAT
GO
