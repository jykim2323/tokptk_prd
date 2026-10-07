/**********************************************************/
/*****    TABLE NAME : TBSCRC                         *****/
/*****    PRIME KEY  : PK_SCRC_PKEY                   *****/
/*****    내      용 : S/C SCRCC FILE                 *****/
/**********************************************************/
use Tokstk_db
set nocount on
Go

PRINT '----------------------------------------------'
PRINT 'Drop T2TBSCRC Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.T2TBSCRC
GO

PRINT 'Starting CREATION OF T2TBSCRC TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.T2TBSCRC
(
        SCRC_NO 	CHAR(1)     NOT NULL,      /*S/C번호(1 - 4)          */
        SCRC_CYCLE 	CHAR(2)     DEFAULT 'I3',  /*작업모드                */        
        SCRC_ONLINE     CHAR(1)     DEFAULT '0',
        SCRC_READY      CHAR(1)     DEFAULT '0',
        SCRC_HOME       CHAR(1)     DEFAULT '0',
        SCRC_LOCA 	CHAR(4)     DEFAULT '',    /*작업위치                */
        SCRC_CENTER	CHAR(01)    DEFAULT '0',   /* FORK CENTER  */
        SCRC_ACK        CHAR(1)     DEFAULT '0',        
        SCRC_LOAD 	CHAR(1)     DEFAULT '0',   /*LOAD OK=1               */
        SCRC_UNLOAD 	CHAR(1)     DEFAULT '0',   /*UNLOAD OK=1             */
        SCRC_SCPLT      CHAR(1)     DEFAULT '0',   /*SC PLT유무BIT           */
        SCRC_POSBY 	CHAR(02)    DEFAULT '00',  /*SC 현위치               */
        SCRC_POSLV 	CHAR(1)     DEFAULT '0',   /*SC 현위치               */  
        SCRC_ERROR 	CHAR(1)     DEFAULT '0',   /*SC 에러 D,E,G,0         */                
        SCRC_INDEX	VARCHAR(13) DEFAULT '',	   /* 작업 순번       */            
        SCRC_WSNO	VARCHAR(01) DEFAULT '',   /* 작업 Station    */    	
        SCRC_DESC       VARCHAR(60) DEFAULT '',        
        SCRC_GUBUN	VARCHAR(01) DEFAULT '', 
        SCRC_HIGH   	VARCHAR(01) DEFAULT '',    /* 입고 단        */      
        CONSTRAINT PK_T2SCRC PRIMARY KEY CLUSTERED
             ( SCRC_NO
             )

)
GO

/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/
insert into T2tbscrc (scrc_no)
values('1')
go

insert into T2tbscrc (scrc_no)
values('2')
go

insert into T2tbscrc (scrc_no)
values('3')
go
SELECT * FROM T2TBSCRC;
GO
