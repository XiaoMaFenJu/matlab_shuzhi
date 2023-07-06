clear;clc;
%参数与初始化
% m = 321;
% n = 129;
% d =300000.0/8;
% clat = 45.0;
% clon = 120.0;
% dt = 150.0/8;

m = 41;
n = 17;
d =300000.0;
clat = 45.0;
clon = 120.0;
dt = 200;

ua(m,n) = 0;va(m,n) = 0;za(m,n) = 0;
ub(m,n) = 0;vb(m,n) = 0;zb(m,n) = 0;
uc(m,n) = 0;vc(m,n) = 0;zc(m,n) = 0;
rm(m,n) = 0;f(m,n) = 0;w(m,n) = 0;

zo = 0;
s = 0.5;
nt2 = 72*3;
nt4 = 6*3;
nt5 = 36*3;
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

% ni = input('Input 0(no static initilaizion) or 1(static initilaizion)');
ni = 1;

if(ni==1)
    [ua,va] = cgw(za,rm,f,d,m,n);
end

%设置工作数组的边界数据并开始预报
[ub,vb,zb] = tbv(ua,va,za,m,n);
[uc,vc,zc] = tbv(ua,va,za,m,n);

disp('Forecasting 12 hours......')
% for na = 1:1
%     nb = 0;

na = 1;nb = 0;
% for nn = 1:6
%     [tmp1,tmp2,tmp3] = ti(ua,va,za,ua,va,za,rm,f,d,dt,zo,m,n);
%     ub(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
%     vb(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
%     zb(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);
%     [tmp1,tmp2,tmp3] = ti(ua,va,za,ub,vb,zb,rm,f,d,dt,zo,m,n);
%     ua(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
%     va(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
%     za(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);
%     nb = nb + 1;
% end
% 
% %进行边界平滑
% za = ssbp(za,s,m,n);
% ua = ssbp(ua,s,m,n);
% va = ssbp(va,s,m,n);


%用欧拉前差格式积分半步
[tmp1,tmp2,tmp3] = ti(ua,va,za,ua,va,za,rm,f,d,c1,zo,m,n);
ub(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
vb(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
zb(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);

%用中央差分积分半步
[tmp1,tmp2,tmp3] = ti(ua,va,za,ub,vb,zb,rm,f,d,dt,zo,m,n);
uc(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
vc(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
zc(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);

%继续中央差积分
nb = nb + 1;

[ub,vb,zb] = ta(uc,vc,zc);

%1h 17
for nn = 1:18*6-1
    [tmp1,tmp2,tmp3] = ti(ua,va,za,ub,vb,zb,rm,f,d,dt,zo,m,n);
    uc(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
    vc(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
    zc(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);
    nb = nb + 1;
    disp(['na=',num2str(na),'nb=',num2str(nb)])
    
    if(nb~=nt2)
        
        if(mod(nb,nt4)==0)
            zc = ssbp(zc,s,m,n);
            uc = ssbp(uc,s,m,n);
            vc = ssbp(vc,s,m,n);
        
        else
            if(nb==nt5||nb==nt5+3)
                
                [tmp1,tmp2,tmp3] = ts(ua,ub,uc,va,vb,vc,za,zb,zc,s,m,n);
                ub(2:m-1,2:n-1) = tmp1(2:m-1,2:n-1);
                vb(2:m-1,2:n-1) = tmp2(2:m-1,2:n-1);
                zb(2:m-1,2:n-1) = tmp3(2:m-1,2:n-1);
                
            else
                
                [ua,va,za] = ta(ub,vb,zb,m,n);
                [ub,vb,zb] = ta(uc,vc,zc,m,n);
                
            end
        end
    end
                

end

disp('Output results.....')
in = fopen('zc.grd','w');
fwrite(in,zc,'float32');
fclose(in);
in = fopen('uc.grd','w');
fwrite(in,uc,'float32');
fclose(in);
in = fopen('vc.grd','w');
fwrite(in,vc,'float32');
fclose(in);

zc = ssnp(zc,s,m,n);
% zc = smooth99(zc);

subplot(2,1,1)
m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,za_ori,5000:150:5750,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,1.,'(a)','fontsize',9)

subplot(2,1,2)
m_proj('lambert','lon',[min(min(lmda_degree)),max(max(lmda_degree))],'lat',[min(min(phai_degree)),max(max(phai_degree))]);
[c,h] = m_contour(lmda_degree,phai_degree,zc,5000:150:5750,'-k');
clabel(c,h,'LabelSpacing',1000,'fontsize',10)
m_coast('linewidth',1,'color',[123,123,123]/255);
m_grid('fontsize',12)
text(-1,1.,'(b)','fontsize',9)







