%中南半岛10N~28N 92E~110E
clear;clc;
M = 9;N = 9;%M东西扩展 N南北扩展
m = zeros(2 * N+1,2* M+1);%放大系数
f = zeros(2 * N+1,2* M+1);
phy0 = 19;
a = 6371;
d = round(a*cosd(phy0)*2*3.14/360);
% d = 100;  
omega = 7.292 * 10^(-5);

%寻找最佳标准维度
for stdi = 1:31
    for i = -N:N
        l_ref_test = a * cosd(stdi-1) * tand(phy0);
        l_test = sqrt((l_ref_test+i*d)^2);
        m_test(i+1+N,1) = sqrt((a*cosd(stdi-1))^2+l_test^2)/a;
        s2(stdi,1) = sum((m_test-1).^2)/(2 * N+1);
    end
end
[~,k] = min(s2);

stdlat = k-1;
l_ref = a * cosd(stdlat) * tand(phy0);

for In = -M:M
    for Jn = -N:N
        
        l = sqrt((l_ref+Jn*d)^2);
        
        m(Jn+1+N,In+1+M) = sqrt((a*cosd(stdlat))^2+l^2)/a;
        
        f(Jn+1+N,In+1+M) = 2*omega*l/sqrt((a*cosd(stdlat))^2+l^2);
    end
end

m = flipud(m);f = flipud(f);

stdlat_WPS = 22.5;

m_WPS = zeros(2 * N+1,2* M+1);%放大系数
f_WPS = zeros(2 * N+1,2* M+1);

l_ref = a * cosd(stdlat_WPS) * tand(phy0);
for In = -M:M
    for Jn = -N:N
        
        l = sqrt((l_ref+Jn*d)^2);
        
        m_WPS(Jn+1+N,In+1+M) = sqrt((a*cosd(stdlat_WPS))^2+l^2)/a;
        
        f_WPS(Jn+1+N,In+1+M) = 2*omega*l/sqrt((a*cosd(stdlat_WPS))^2+l^2);
    end
end
m_WPS = flipud(m_WPS);f_WPS = flipud(f_WPS);


% stdlat = 22.5;
% s2_t = sum((m_WPS-1).^2,'all')/((2 * N+1) + (2* M+1) );
% 不可以平均分寻找最佳标准维度
% WPS（WRF preprocessing system）是WRF的预处理系统，主要用于实测数据处理。认为该对比的习题放在这并不合适
% 学生大多并未掌握WRF与WPS的相关知识，所以我与标准麦卡托投影进行了对比。
