use Tokstk_db
GO

PRINT '----------------------------------------------'
PRINT 'Drop dumm_tbl Table'
PRINT '----------------------------------------------'
PRINT ''
DROP   TABLE dbo.dumm_tbl
GO

PRINT 'Starting CREATION OF dumm_tbl TABLE'
PRINT '----------------------------------------------'
PRINT ''

CREATE TABLE dbo.dumm_tbl
(
        ddd 	CHAR(10)      NOT NULL,            /* PRIMARY KEY = '1' */
        CONSTRAINT STK1_dumm_KEY PRIMARY KEY CLUSTERED
             ( ddd
             )
)
GO

insert into dumm_tbl values ( '1' );
go
