clc;clear;
%%
%注意，所下数据为整年数据，故有最后一个维度为月份
surface_pressure = ncread('ERA5_surface_pressure_201201.nc','sp');
temperature = ncread('ERA5_temperature_201201.nc','t');%Size:       1440x721x37x12
ncdisp('ERA5_temperature_201201.nc')

pressure_levels = ncread('ERA5_temperature_201201.nc','level');
pressure_levels = pressure_levels * 100;

lons = ncread('ERA5_temperature_201201.nc','longitude');
lats = ncread('ERA5_temperature_201201.nc','latitude');
%%
sigma_levels = [0.995, 0.97999, 0.94995, 0.89988, 0.82977, 0.74468, 0.64954,...
    0.54946, 0.45447, 0.36948, 0.29450, 0.22953, 0.17457, 0.12440, 0.084683,...
    0.0598005, 0.0449337, 0.0349146, 0.02488, 0.00829901];

nlev = numel(sigma_levels);%计数like size
nlat = size(temperature,2);
nlon = size(temperature,1);
temperature_sigma = zeros(nlon,nlat,nlev);

pressure_levels = cast(pressure_levels,'double');%转换类型

%squeeze 删除长度为 1 的维度
%interp1 一维数据插值
%P_T = 0
for i=1:nlon
    for j=1:nlat
        sigma_plev = surface_pressure(i,j,1) * sigma_levels;
        temperature_sigma(i,j,:) = interp1(pressure_levels,squeeze(temperature(i,j,:,1)),sigma_plev,'spline');
    end
end

%%
p_levels = [925 875 825 775 725 675 625 575 550 475 425 375 325 275 225 175 125] * 100;
nlev = numel(p_levels);
temperature_pressure = zeros(nlon,nlat,nlev);

for i=1:nlon
    for j=1:nlat
        pressure_siglev = p_levels/surface_pressure(i,j,1);
        temperature_pressure(i,j,:) = interp1(sigma_levels,squeeze(...
            temperature_sigma(i,j,:)),pressure_siglev,'spline',nan);
    end
end

%%
test_plev = 825;%比较825hPa

for i = 1:nlon
    temperature(i , surface_pressure(i,:,1)<test_plev * 100 , ...
        pressure_levels==test_plev * 100, 1) = nan; %地表下的数据设为缺测 感觉没用
end

%%
clc;
figure('Units','centimeter','Position',[5 5 13 20]);
subplot(3,1,1)
m_proj('Robinson','clo',181);%中央经线 181  robinson投影

[cs,h] = m_contour(lons,lats,temperature(: , : , pressure_levels==test_plev * 100, 1)','-k');

h.LevelStep = 10;

clabel(cs,h,'LabelSpacing',1000,'fontsize',7);

m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',8);

text(-3.5,2,'(a)','fontsize',12);

subplot(3,1,2)
m_proj('Robinson','clo',181);

[cs,h] = m_contour(lons,lats,temperature_sigma(:,:,1)','-k');%cs 等高线矩阵
...:返回为二行矩阵。此矩阵包含等高线层级（高度）和每个层级上各顶点的坐标。
%h 等高线对象：设置属性使用h，在显示等高线图后，使用此对象设置属性。
h.LevelStep = 10;%等值线间隔
clabel(cs,h,'LabelSpacing',1000,'fontsize',7);%加等值线标签 %标签间距

m_coast('linewidth',1,'color',[123,123,123]/255);%绘制海岸线
m_grid('fontsize',8); %网格线和标签设置

text(-3.5,2,'(b)','fontsize',12);

subplot(3,1,3)
m_proj('Robinson','clo',181);

[cs,h] = m_contour(lons,lats,temperature_pressure(:,:,p_levels==test_plev * 100)','-k');

h.LevelStep = 10;
clabel(cs,h,'LabelSpacing',1000,'fontsize',7);

m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',8);

text(-3.5,2,'(c)','fontsize',12);

titles = {'(a)ERA5再分析数据2012年1月平均825hPa温度场(单位:K)',...
    '(b)p坐标系插值到σ=0.995层的2012年1月平均温度场(单位:K)',...
    '(c)σ坐标系插值到p坐标825hPa的2012年1月平均温度场(单位:K)'};

title(titles,'position', [-0.2, -3]);
%%
max( max( abs( temperature_pressure(:,:,p_levels==test_plev * 100) - ...
    temperature(:,:,pressure_levels == test_plev * 100))))