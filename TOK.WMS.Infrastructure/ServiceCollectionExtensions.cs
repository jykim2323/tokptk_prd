using Microsoft.Extensions.DependencyInjection;
using TOK.WMS.Core.ETC;
using TOK.WMS.Core.Interfaces;
using TOK.WMS.Core.Interfaces.Inbounds;
using TOK.WMS.Core.Interfaces.Inventory;
using TOK.WMS.Infrastructure.Data;
using TOK.WMS.Infrastructure.Repositories;
using TOK.WMS.Infrastructure.Repositories.Inbounds;
using TOK.WMS.Infrastructure.Repositories.Inventory;

namespace TOK.WMS.Infrastructure
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection AddInfrastructure(this IServiceCollection services, string connectionString)
        {
            services.AddSingleton(new DbConnectionFactory(connectionString));

            //services.AddScoped<IWarehouseRequestContext, WarehouseRequestContext>();

            //로그인
            services.AddScoped<ILoginRepository, LoginRepository>();


            //공통 쿼리문
            services.AddScoped<ICoreRepository, CoreRepository>();

            //입고 관리
            services.AddScoped<IFrm3100Repository, Frm3100Repository>();



            //재고 관리
            services.AddScoped<IFrm6100Repository, Frm6100Repository>();
            services.AddScoped<IFrm6200Repository, Frm6200Repository>();
            services.AddScoped<IFrm6300Repository, Frm6300Repository>();
            services.AddScoped<IFrm6450Repository, Frm6450Repository>();
            services.AddScoped<IFrm6550Repository, Frm6550Repository>();
            services.AddScoped<IFrm6700Repository, Frm6700Repository>();
            services.AddScoped<IFrm6900Repository, Frm6900Repository>();
            services.AddScoped<ISFrm6110Repository, SFrm6110Repository>();
            services.AddScoped<ISFrm6120Repository, SFrm6120Repository>();
            services.AddScoped<ILocaAddRepository, LocaAddRepository>();

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
