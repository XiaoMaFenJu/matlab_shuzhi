clear;clc;
m = 41;
n = 17;
d =300000.0;
clat = 45.0;
clon = 120.0;
s = 0.5;
z500 = ncread('D:\matlabproject\shuzhi\exp8\era5_geopotential_19790109_19790111_00.nc','z');
lon = ncread('D:\matlabproject\shuzhi\exp8\era5_geopotential_19790109_19790111_00.nc','longitude');
lat = ncread('D:\matlabproject\shuzhi\exp8\era5_geopotential_19790109_19790111_00.nc','latitude');
za = z500(:,:,1)/9.8;
zb = z500(:,:,2)/9.8;
zc = z500(:,:,3)/9.8;

[rm,f,lmda_degree,phai_degree] = cmf(d,clat,clon,m,n);

za = interp_proj_grid_z(za,lmda_degree,phai_degree,lon,lat);
zb = interp_proj_grid_z(zb,lmda_degree,phai_degree,lon,lat);
zc = interp_proj_grid_z(zc,lmda_degree,phai_degree,lon,lat);

zb_ori = zb;
zb = ts_lvar(za,zb,zc,s);

subplot(1,2,1)

m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,zb_ori,5000:150:5750,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,-0.5,'(a)','fontsize',16)

subplot(1,2,2)

m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,zb,5000:150:5750,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,-0.5,'(b)','fontsize',16)

sgt = sgtitle({'1979年1月10日500hPa重力位势高度场的空间分布图','(a)原始数据;(b)时间平滑后的结果'});
sgt.FontSize = 18;

