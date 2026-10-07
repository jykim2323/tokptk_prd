/**********************************************************/
/*****    TABLE NAME : MILSTK                         *****/
/*****    PRIME KEY  : PK_LSTK_PKEY                   *****/
/*****    내      용 : LOCATION별 재고FILE            *****/
/*****    창      고 :        창고                    *****/
/*****    작  성  일 : 10년 04월                      *****/
/**********************************************************/
use Tokstk_db
set nocount on
Go


PRINT '----------------------------------------------'
PRINT 'Drop T2MILSTK Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE T2MILSTK
GO

PRINT 'Starting CREATION OF T2MILSTK TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE T2MILSTK
(
        LSTK_LOCA 	CHAR(4)        NOT NULL,        /*LOCA번호 X-X-X     */
        LSTK_BK 	CHAR(1)        NOT NULL,        /*BANK번호            */
        LSTK_BY 	CHAR(2)        NOT NULL,        /*BAY 번호            */
        LSTK_LV 	CHAR(1)        NOT NULL,        /*LEVL번호            */
        LSTK_FLAG 	VARCHAR(1)     DEFAULT('0'),    /*1=사용,0=금지        */    	        
        LSTK_INDATE       VARCHAR(8)     DEFAULT(''), 
        LSTK_INTIME       VARCHAR(6)     DEFAULT(''),
        CONSTRAINT PK_T2LSTK PRIMARY KEY CLUSTERED
             ( LSTK_LOCA
             )

)
GO

/************************************************************************/
/*****                	END OF TABLE                                *****/
/************************************************************************/

PRINT 'Starting CREATION OF MILSTK Record'
PRINT '----------------------------------------------'
PRINT ''

use Tokstk_db
GO
DECLARE
       @I_BK  NUMERIC(1),
       @I_BY  NUMERIC(2),
       @I_LV  NUMERIC(1),
       @I_TY  NUMERIC(2),
       @C_BK  CHAR(1),
       @C_BY  CHAR(2),
       @C_LV  CHAR(1),
       @C_LOCA  CHAR(4),
       @C_LOCA1  CHAR(4),
       @C_TY  CHAR(1)
BEGIN
       SET @I_BK = 0
       SET @I_BY = 0
       SET @I_LV = 0
       WHILE   @I_BK  >= 0
       BEGIN
           SELECT @I_BK = @I_BK + 1
           IF  @I_BK >= 7
               BEGIN
                  SET @I_BK = 0
                  BREAK
               END
            WHILE @I_BY  >= 0
            BEGIN
                SELECT @I_BY  = @I_BY + 1
                IF  @I_BY >= 14
                    BEGIN
                       SET @I_BY = 0
                       BREAK
                    END                

                 WHILE @I_LV  >= 0
                 BEGIN
                     SELECT @I_LV  = @I_LV + 1
                     IF  @I_LV >= 9
                         BEGIN
                             SET @I_LV = 0
                             BREAK
                         END

                      BEGIN TRAN
                        SET  @C_BK = @I_BK
                        SET  @C_BY = @I_BY
                        SET  @C_LV = @I_LV                      
                        SELECT @C_BK = STR(@C_BK,1)
                        SELECT @C_BK = REPLACE(@C_BK,' ','0')
                        SELECT @C_BY = STR(@C_BY,2)
                        SELECT @C_BY = REPLACE(@C_BY,' ','0')
                        SELECT @C_LV = STR(@C_LV,1)
                        SELECT @C_LV = REPLACE(@C_LV,' ','0')                       
                        SELECT @C_LOCA = @C_BK + @C_BY + @C_LV
                        INSERT INTO T2milstk (LSTK_BK ,    lstk_by,    lstk_lv,     lstk_loca,  lstk_flag,
                                            lstk_indate, lstk_intime )
                                     VALUES(@C_BK,      @C_BY,      @C_LV,       @C_LOCA,    '0',
                                               '',     '')

                       IF @I_LV = 8
                       BEGIN
                           SELECT @C_LOCA1 = @C_BK + @C_BY + '9'
                           INSERT INTO T2milstk (LSTK_BK ,    lstk_by,    lstk_lv,     lstk_loca,  lstk_flag,
                                            lstk_indate, lstk_intime )
                                     VALUES(@C_BK,      @C_BY,      '9',       @C_LOCA1,    '0',
                                               '',     '')
                        END
           
                       COMMIT TRAN
                       END
             END
        END
END
GO 


PRINT 'Location creation completed !!'
PRINT '----------------------------------------------'
PRINT ''


select * from T2milstk
go
