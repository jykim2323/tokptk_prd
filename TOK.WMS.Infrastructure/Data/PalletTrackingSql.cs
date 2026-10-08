namespace TOK.WMS.Infrastructure.Data;

internal static class PalletTrackingSql
{
    // 트래킹에는 PLT 번호가 없으므로 작업 인덱스로 입고·출고 작업의 PLT 번호를 확인한다.
    public const string CountByPallet = """
        SELECT COUNT(*)
        FROM dbo.T2TBTRAK AS T WITH (NOLOCK)
        WHERE T.TRAK_INDEX <> ''
          AND (
              EXISTS (
                  SELECT 1
                  FROM dbo.T2MIINPT AS I WITH (NOLOCK)
                  WHERE I.INPT_INDEX = T.TRAK_INDEX
                    AND I.INPT_PLTNO = @PltNo
              )
              OR EXISTS (
                  SELECT 1
                  FROM dbo.T2MIOUPT AS O WITH (NOLOCK)
                  WHERE O.OUPT_INDEX = T.TRAK_INDEX
                    AND O.OUPT_PLTNO = @PltNo
              )
          )
        """;
}
