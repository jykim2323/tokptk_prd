using Dapper;
using Microsoft.Data.SqlClient;
using System.Data;

namespace TOK.WMS.Infrastructure.Data;

public class DbConnectionFactory(string connectionString)
{
    static DbConnectionFactory()
    {
        // DateTime 파라미터를 datetime2로 전송.
        // (Dapper 기본은 datetime(1/300초 정밀)이라 datetime2(3) 컬럼과 = 비교가 실패함)
        SqlMapper.AddTypeMap(typeof(DateTime), DbType.DateTime2);
    }

    public IDbConnection Create() => new SqlConnection(connectionString);


}
