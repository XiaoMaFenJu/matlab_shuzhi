clc;clear;
%%
%注意，所下数据为整年数据，故有最后一个维度为月份
surface_pressure = ncread('ERA5_surface_pressure_201201.nc','sp');
temperature = ncread('ERA5_temperature_201201.nc','t');%Size:    1440x721x37x12
ncdisp('ERA5_temperature_201201.nc')

pressure_levels = ncread('ERA5_temperature_201201.nc','level');
pressure_levels = pressure_levels * 100;

lons = ncread('ERA5_temperature_201201.nc','longitude');
lats = ncread('ERA5_temperature_201201.nc','latitude');

Ps = surface_pressure(:,:,1);
%%
A_19 = [0.0 ,2000.0 ,4000.0 , 6046.110595, 8267.92756, 10609.513232, 12851.100169, 14698.498086,...
    15861.125180, 16116.236610, 15356.924115, 13621.460403, 11101.561987, 8127.144155,...
    5125.141747, 2549.969411, 783.195032, 0.000000, 0.000000, 0.000000];
B_19 = [0.0, 0.0, 0.0, 0.0003389933, 0.0033571866, 0.0130700434, 0.0340771467, 0.0706498323, ...
    0.1259166826, 0.2011954093, 0.2955196487, 0.4054091989, 0.5249322235, 0.6461079479, ...
    0.7596983769, 0.8564375573, 0.9287469142, 0.9729851852, 0.9922814815, 1.0000000000];

%%
yita_t = 0;yita__s = 1;
P0 = 101325;

nlev = numel(A_19);
nlat = size(temperature,2);
nlon = size(temperature,1);
Pk = zeros(nlon,nlat,nlev);yita_k = zeros(nlon,nlat,nlev);

for i=1:nlon
    for j=1:nlat
        for k=1:nlev
        Pk(i,j,k) = A_19(k) + B_19(k) * Ps(i,j);
        yita_k(i,j,k) = A_19(k)/P0 + B_19(k);
        end
    end
end

%%
P_yita = zeros(nlon,nlat,nlev-1);

pressure_levels = cast(pressure_levels,'double');%转换类型

yita_levels = [0.995, 0.97999, 0.94995, 0.89988, 0.82977, 0.74468, 0.64954,...
    0.54946, 0.45447, 0.36948, 0.29450, 0.22953, 0.17457, 0.12440, 0.084683,...
    0.0598005, 0.0449337, 0.0349146, 0.02488, 0.00829901];

temperature_yita = zeros(nlon,nlat,nlev-1);
for i=1:nlon
    for j=1:nlat
        for k=2:nlev
            P_yita(i,j,k-1) = Pk(i,j,k-1) + (( yita_levels(k-1) - yita_k(i,j,k-1) )*( Pk(i,j,k) - Pk(i,j,k-1) ))/( yita_k(i,j,k)-yita_k(i,j,k-1) );
        end
        temperature_yita(i,j,:) = interp1(pressure_levels,squeeze(temperature(i,j,:,1)),P_yita(i,j,:),'linear');
    end
end

%%
clc;
test_plev = 550;%比较550hPa
figure('Units','centimeter','Position',[5 5 13 17.5]);

subplot(2,1,1)
m_proj('Robinson','clo',181);%中央经线 181  robinson投影
[cs,h] = m_contour(lons,lats,temperature(: , : , pressure_levels==test_plev * 100, 1)','-k');
h.LevelStep = 10;
clabel(cs,h,'LabelSpacing',800,'fontsize',7);
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',8);
text(-3.5,2,'(a)','fontsize',12);

subplot(2,1,2)
m_proj('Robinson','clo',181);%中央经线 181  robinson投影
[cs1,h1] = m_contour(lons,lats,temperature_yita(:,:,8)','-k');
h1.LevelStep = 10;
clabel(cs1,h1,'LabelSpacing',800,'fontsize',7);
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',8);
text(-3.5,2,'(b)','fontsize',12);

titles = {'550hPa气温场的坐标系转换结果','(a)ERA5再分析数据2012年1月平均气温场(单位:K)',...
    '(b)p坐标系插值到η=0.54946层的2012年1月平均气温场(单位:K)'};

title(titles,'position', [0, -3]);