/**********************************************************/
/*****    TABLE NAME : TBTRAK                         *****/
/*****    PRIME KEY  : PK_TRAK_PKEY                   *****/
/*****    내      용 : CONV TRAK  FILE(입고CV)        *****/
/**********************************************************/
use Tokptk_db
set nocount on
Go

PRINT ''
PRINT '----------------------------------------------'
PRINT 'Drop T2TBTRAK Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE T2TBTRAK
GO

PRINT 'Starting CREATION OF TBTRAK TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE T2TBTRAK
(
        TRAK_NO 	VarCHAR(02)  NOT NULL,           /*TRAK번호        */
        TRAK_INDEX	VarCHAR(13)  DEFAULT(''),		 /* INDEX 번호     */     
        TRAK_GUBUN 	VarCHAR(01)  DEFAULT(''),        /* 'P':Picking, 'R': 재입고, 'T': Total , 'I' : 입고	*/    
        TRAK_LOCA 	VarCHAR(04)  DEFAULT(''),        /*입출작업위치*/         
        TRAK_HIGH 	VarCHAR(01)  DEFAULT(''),        /* PIcking 완료	*/ 
        TRAK_FLAG 	VarCHAR(01)  DEFAULT(''),        /* 구분*/         
        TRAK_DATE       VarCHAR(08)  DEFAULT(''),
        TRAK_TIME       VarCHAR(06)  DEFAULT(''),        	
        CONSTRAINT PK_T2TRAK PRIMARY KEY CLUSTERED
             ( TRAK_NO  )

)
GO

PRINT 'Starting CREATION OF TBTRAK'
PRINT '----------------------------------------------'
PRINT ''


/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/
DECLARE
    @l_i_trakno	 NUMERIC(1),    
    @l_c_trakno CHAR(1)   
BEGIN    
  BEGIN TRAN
    insert into T2tbtrak (TRAK_NO) VALUES ('01')
    insert into T2tbtrak (TRAK_NO) VALUES ('02')
    insert into T2tbtrak (TRAK_NO) VALUES ('03')
    insert into T2tbtrak (TRAK_NO) VALUES ('04')
    insert into T2tbtrak (TRAK_NO) VALUES ('05')
    insert into T2tbtrak (TRAK_NO) VALUES ('06')
    insert into T2tbtrak (TRAK_NO) VALUES ('07')
    insert into T2tbtrak (TRAK_NO) VALUES ('08')
    insert into T2tbtrak (TRAK_NO) VALUES ('09')
    insert into T2tbtrak (TRAK_NO) VALUES ('10')   
    insert into T2tbtrak (TRAK_NO) VALUES ('11')
    insert into T2tbtrak (TRAK_NO) VALUES ('12')
    insert into T2tbtrak (TRAK_NO) VALUES ('13') 
    insert into T2tbtrak (TRAK_NO) VALUES ('14')   
    insert into T2tbtrak (TRAK_NO) VALUES ('15')
    insert into T2tbtrak (TRAK_NO) VALUES ('16')
    insert into T2tbtrak (TRAK_NO) VALUES ('17')   
    insert into T2tbtrak (TRAK_NO) VALUES ('18')   
    insert into T2tbtrak (TRAK_NO) VALUES ('19')
    insert into T2tbtrak (TRAK_NO) VALUES ('20')
    insert into T2tbtrak (TRAK_NO) VALUES ('21')  
    insert into T2tbtrak (TRAK_NO) VALUES ('22')   
    insert into T2tbtrak (TRAK_NO) VALUES ('23')
    insert into T2tbtrak (TRAK_NO) VALUES ('24')
    insert into T2tbtrak (TRAK_NO) VALUES ('25')
    insert into T2tbtrak (TRAK_NO) VALUES ('26')
    insert into T2tbtrak (TRAK_NO) VALUES ('27')
    insert into T2tbtrak (TRAK_NO) VALUES ('28')
    insert into T2tbtrak (TRAK_NO) VALUES ('29')
    insert into T2tbtrak (TRAK_NO) VALUES ('30')
    insert into T2tbtrak (TRAK_NO) VALUES ('31')
    insert into T2tbtrak (TRAK_NO) VALUES ('32')
    insert into T2tbtrak (TRAK_NO) VALUES ('33')
    insert into T2tbtrak (TRAK_NO) VALUES ('34')   
    insert into T2tbtrak (TRAK_NO) VALUES ('35')
    insert into T2tbtrak (TRAK_NO) VALUES ('36')
    insert into T2tbtrak (TRAK_NO) VALUES ('37') 
    insert into T2tbtrak (TRAK_NO) VALUES ('38')   
    insert into T2tbtrak (TRAK_NO) VALUES ('39')
    insert into T2tbtrak (TRAK_NO) VALUES ('40')
    insert into T2tbtrak (TRAK_NO) VALUES ('41')   
    insert into T2tbtrak (TRAK_NO) VALUES ('42')   
    insert into T2tbtrak (TRAK_NO) VALUES ('43')
    insert into T2tbtrak (TRAK_NO) VALUES ('44')
    insert into T2tbtrak (TRAK_NO) VALUES ('45')  
    insert into T2tbtrak (TRAK_NO) VALUES ('46')     
 COMMIT TRAN   


END

SELECT * FROM T2TBTRAK
GO

