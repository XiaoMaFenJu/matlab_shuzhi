clc;clear;
%%
%注意，温度与地表气压数据为整年数据，故有最后一个维度为月份
surface_pressure = ncread('ERA5_surface_pressure_201201.nc','sp');
geopotential = ncread('ERA5_geopotential_201201.nc','z');%Size:     1440x721x37
ncdisp('ERA5_geopotential_201201.nc')
% geopotential = geopotential/10; %转换成位势十米

pressure_levels = ncread('ERA5_geopotential_201201.nc','level');
pressure_levels = pressure_levels * 100;

lons = ncread('ERA5_geopotential_201201.nc','longitude');
lats = ncread('ERA5_geopotential_201201.nc','latitude');
%%
sigma_levels = [0.995, 0.97999, 0.94995, 0.89988, 0.82977, 0.74468, 0.64954,...
    0.54946, 0.45447, 0.36948, 0.29450, 0.22953, 0.17457, 0.12440, 0.084683,...
    0.0598005, 0.0449337, 0.0349146, 0.02488, 0.00829901];

nlev = numel(sigma_levels);%计数like size
nlat = size(geopotential,2);
nlon = size(geopotential,1);
geopotential_sigma = zeros(nlon,nlat,nlev);

pressure_levels = cast(pressure_levels,'double');%转换类型

%squeeze 删除长度为 1 的维度
%interp1 一维数据插值
%P_T = 0
for i=1:nlon
    for j=1:nlat
        sigma_plev = surface_pressure(i,j,1) * sigma_levels;
        geopotential_sigma(i,j,:) = interp1(pressure_levels,squeeze(...
            geopotential(i,j,:)),sigma_plev,'spline');
    end
end

%%
p_levels = [925 875 825 775 725 675 625 575 550 475 ...
    425 375 325 275 225 175 125] * 100;
nlev = numel(p_levels);
geopotential_pressure = zeros(nlon,nlat,nlev);

for i=1:nlon
    for j=1:nlat
        pressure_siglev = p_levels/surface_pressure(i,j,1);
        geopotential_pressure(i,j,:) = interp1(sigma_levels,squeeze(...
            geopotential_sigma(i,j,:)),pressure_siglev,'spline',nan);
    end
end

%%
test_plev = 825;%比较825hPa

for i = 1:nlon
    geopotential(i , surface_pressure(i,:,1)<test_plev * 100 , ...
        pressure_levels==test_plev * 100 ) = nan; %地表下的数据设为缺测
end

%%
clc;
figure('Units','centimeter','Position',[5 5 13 20]);
subplot(3,1,1)

m_proj('Robinson','clo',181);%中央经线 181  robinson投影
[cs,h]= m_contour(lons,lats,geopotential(:,:,pressure_levels==test_plev*100 )','-k');
h.LevelStep = 1000;
clabel(cs,h,'LabelSpacing',1000,'fontsize',7);
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',8);
text(-3.5,2,'(a)','fontsize',12);

subplot(3,1,2)
m_proj('Robinson','clo',181);%中央经线 181  robinson投影
[cs,h1] = m_contour(lons,lats,geopotential_sigma(:,:,1)','-k');
% h1.LevelList = [1000,5000,10000,15000];
h1.LevelStep = 8000;
clabel(cs,h1,'LabelSpacing',1000,'fontsize',7);
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',8);
text(-3.5,2,'(b)','fontsize',12);

subplot(3,1,3)
m_proj('Robinson','clo',181);%中央经线 181  robinson投影
[cs,h] = m_contour(lons,lats,geopotential_pressure(: , : , ...
    p_levels==test_plev * 100 )','-k');
h.LevelStep = 1000;
clabel(cs,h,'LabelSpacing',1000,'fontsize',7);
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',8);
text(-3.5,2,'(c)','fontsize',12);

titles = {'(a)ERA5再分析数据2012年1月平均825hPa重力位势高度场(单位:m^2/s^2)',...
    '(b)p坐标系插值到σ=0.995层的2012年1月平均重力位势高度场(单位:m^2/s^2)',...
    '(c)σ坐标系插值到p坐标825hPa的2012年1月平均重力位势高度场(单位:m^2/s^2)'};

title(titles,'position', [-0.2, -3]);

%%
max( max( abs( geopotential_pressure(:,:,p_levels==test_plev * 100) - ...
    geopotential(:,:,pressure_levels == test_plev * 100))))