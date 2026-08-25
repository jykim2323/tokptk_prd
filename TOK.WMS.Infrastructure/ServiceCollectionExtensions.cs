using TOK.WMS.Infrastructure.Data;

using Microsoft.Extensions.DependencyInjection;
using TOK.WMS.Core.Interfaces.Inbounds;
using TOK.WMS.Infrastructure.Repositories.Inbounds;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Infrastructure.Repositories;
using TOK.WMS.Infrastructure.Repositories.Inventory;
using TOK.WMS.Core.Interfaces.Inventory;

namespace TOK.WMS.Infrastructure
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection AddInfrastructure(this IServiceCollection services, string connectionString)
        {
            services.AddSingleton(new DbConnectionFactory(connectionString));

            //로그인
            services.AddScoped<ILoginRepository, LoginRepository>();

            //입고 관리
            services.AddScoped<IFrm3100Repository, Frm3100Repository>();



            //재고 관리
            services.AddScoped<IFrm6100Repository, Frm6100Repository>();

            //services.AddScoped<IInboundRepository, InboundRepository>();
            //services.AddScoped<IOutboundRepository, OutboundRepository>();
            //services.AddScoped<IStackerCraneRepository, StackerCraneRepository>();
            //services.AddScoped<ITrackRepository, TrackRepository>();
            //services.AddScoped<IChannelRepository, ChannelRepository>();
            //services.AddScoped<ISystemRepository, SystemRepository>();
            //services.AddScoped<IErrorHistoryRepository, ErrorHistoryRepository>();
            //services.AddScoped<IHistoryCleanupRepository, HistoryClaenupRepository>();
            return services;
        }
    }
}
