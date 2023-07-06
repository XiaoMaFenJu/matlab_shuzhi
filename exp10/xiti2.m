clear;clc;
%参数与初始化
m = 41;
n = 17;
d =300000.0;
clat = 45.0;
clon = 120.0;
dt = 600.0;

ua(m,n) = 0;va(m,n) = 0;za(m,n) = 0;
ub(m,n) = 0;vb(m,n) = 0;zb(m,n) = 0;
uc(m,n) = 0;vc(m,n) = 0;zc(m,n) = 0;
rm(m,n) = 0;f(m,n) = 0;w(m,n) = 0;

zo = 0;
s = 0.5;
nt2 = 72;
nt4 = 6;
nt5 = 36;
c1 = dt/2.0;
c2 = dt*2.0;
% nx = (358-0)/2+1;
% ny = (90-0)/2+1;
nt = 365;
%读入初始场
z500 = ncread('era5_uv_geopotential_19790109_19790111_00.nc','z');

u500 = ncread('era5_uv_geopotential_19790109_19790111_00.nc','u');
v500 = ncread('era5_uv_geopotential_19790109_19790111_00.nc','v');
lon = ncread('era5_uv_geopotential_19790109_19790111_00.nc','longitude');
lat = ncread('era5_uv_geopotential_19790109_19790111_00.nc','latitude');
nt_f = 2;
u = squeeze(u500(:,:,nt_f));v = squeeze(v500(:,:,nt_f));z = squeeze(z500(:,:,nt_f));

[rm,f,lmda_degree,phai_degree] = cmf(d,clat,clon,m,n);

[ua,va,za] = interp_proj_grid(u,v,z,lmda_degree,phai_degree,m,n,0,359.75,-90,90);
za_ori = za;

uc = ua;vc = va;zc = za;

%%
persai = zc./(2*7.292*10^(-5)*sind(36));
[up,vp] = gradient(persai,d,d);
up = -up;

subplot(2,2,1)
m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,ua,-10:2:10,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,1.,'(a)','fontsize',9)

subplot(2,2,2)
m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,up,-10:2:10,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,1.,'(b)','fontsize',9)

subplot(2,2,3)
m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,va,-10:2:10,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,1.,'(c)','fontsize',9)

subplot(2,2,4)
m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,vp,-10:2:10,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,1.,'(d)','fontsize',9)
