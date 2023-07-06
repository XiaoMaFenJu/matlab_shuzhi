clear;clc;
%参数与初始化
m = 41;
n = 17;
d =300000.0;
clat = 45.0;
clon = 120.0;
dt = 300.0;

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

z500 = z500/9.8;

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

for nn = 1:72
    ub_temp = uc;vb_temp = vc;zb_temp = zc;
    [rk1u,rk1v,rk1z] = tbv(ub_temp,vb_temp,zb_temp,m,n);
    [tmp1,tmp2,tmp3] = ti_xiti1(ub_temp,vb_temp,zb_temp,rm,f,d,dt,zo,m,n);
    rk1u(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
    rk1v(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
    rk1z(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);
    ub_temp = ua + 0.5*rk1u;
    vb_temp = va + 0.5*rk1v;
    zb_temp = za + 0.5*rk1z;
    
    [rk2u,rk2v,rk2z] = tbv(ub_temp,vb_temp,zb_temp,m,n);
    [tmp1,tmp2,tmp3] = ti_xiti1(ub_temp,vb_temp,zb_temp,rm,f,d,dt,zo,m,n);
    rk2u(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
    rk2v(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
    rk2z(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);
    ub_temp = ua + 0.5*rk2u;
    vb_temp = va + 0.5*rk2v;
    zb_temp = za + 0.5*rk2z;
    
    [rk3u,rk3v,rk3z] = tbv(ub_temp,vb_temp,zb_temp,m,n);
    [tmp1,tmp2,tmp3] = ti_xiti1(ub_temp,vb_temp,zb_temp,rm,f,d,dt,zo,m,n);
    rk3u(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
    rk3v(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
    rk3z(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);
    ub_temp = ua + rk3u;
    vb_temp = va + rk3v;
    zb_temp = za + rk3z;
    
    [rk4u,rk4v,rk4z] = tbv(ub_temp,vb_temp,zb_temp,m,n);
    [tmp1,tmp2,tmp3] = ti_xiti1(ub_temp,vb_temp,zb_temp,rm,f,d,dt,zo,m,n);
    rk4u(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
    rk4v(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
    rk4z(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);
    uc = ua + 1/6*(rk1u+2*rk2u+2*rk3u+rk4u);
    vc = va + 1/6*(rk1v+2*rk2v+2*rk3v+rk4v);
    zc = za + 1/6*(rk1z+2*rk2z+2*rk3z+rk4z);
end

zc = ssnp(zc,s,m,n);

subplot(2,1,1)
m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,za_ori,5000:150:5750,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,1.,'(a)','fontsize',9)

subplot(2,1,2)
m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,zc,4700:150:5900,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,1.,'(b)','fontsize',9)

