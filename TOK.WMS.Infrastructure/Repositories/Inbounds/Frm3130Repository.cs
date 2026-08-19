using Dapper;
using System.ComponentModel.DataAnnotations;
using System.Data;
using System.Globalization;
using TOK.WMS.Core.DTOs.Inbounds;
using TOK.WMS.Core.Entities.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;
using TOK.WMS.Infrastructure.Data;

namespace TOK.WMS.Infrastructure.Repositories.Inbounds;

public class Frm3130Repository(DbConnectionFactory db) : IFrm3130Repository
{

}
