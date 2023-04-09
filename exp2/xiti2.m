% clear;clc
% M = 25;N = 20;%M东西扩展 N南北扩展
% m = zeros(2 * N+1,2* M+1);%放大系数
% %https://blog.csdn.net/weixin_44237337/article/details/123363027
% 
% phy0 = 40;%中央纬度
% seita1 = 40;seita2 = 60;
% k = (log(sind(seita1)) - log(sind(seita2)))/...
%     (log(tand(seita1/2)) - log(tand(seita2/2))); %圆锥常数
% 
% a = 6371;%地球半径
% le = a*sind(seita1)/k*(1/tand(seita1/2))^k;
% %11423.37;%映像平面上赤道到北极点的距离
% d = a*cosd(phy0)*2*3.14/360;%格点距
% 
% l_ref = le * (cosd(phy0)/(1+sind(phy0)))^k;%参考点O到北极点的距离
% 
% %求出各网格点到北极点的距离并·计算放大系数
% for In = -M:M
%     for Jn = -N:N
%         l = sqrt((abs(In) * d)^2 + (l_ref-Jn*d)^2);
%         m(Jn+1+N,In+1+M) = k*l/(a*sqrt( 1 -...
%             ( ( le^(2/k) - l^(2/k) )/( le^(2/k) + l^(2/k) ) )^2 ));
%     end
% end
% 
% m = flipud(m);

%%

clear;clc
M = 25;N = 26;%M东西扩展 N南北扩展
m = zeros(2 * N+1,2* M+1);%放大系数
%https://blog.csdn.net/weixin_44237337/article/details/123363027

phy0 = 40;%中央纬度

a = 6371;%地球半径

%11423.37;%映像平面上赤道到北极点的距离
d = round(a*cosd(phy0)*2*3.14/360);%格点距

m_test = zeros(2 * N+1,1);
%寻找最佳标准维度
for stdi1 = 1:70
    for stdi2 = stdi1:70
        for i = -N:N
            k_test = (log(sind(stdi1)) - log(sind(stdi2)))/...
            (log(tand(stdi1/2)) - log(tand(stdi2/2))); %圆锥常数
            le_test = a*sind(stdi1)/k_test*(1/tand(stdi1/2))^k_test;
            
            l_ref_test = le_test * (cosd(phy0)/(1+sind(phy0)))^k_test;
            l_test = sqrt((l_ref_test-i*d)^2);
            
            m_test(i+1+N,1) = k_test*l_test/(a*sqrt( 1 -...
            ( ( le_test^(2/k_test) - l_test^(2/k_test) )/( le_test^(2/k_test) + l_test^(2/k_test) ) )^2 ));
        
            s2(stdi1,stdi2) = sum((m_test-1).^2)/(2 * N+1);
        end
    end
end

s2(isnan(s2)) = max(max(s2));
s2(s2==0) = max(max(s2));

mins2 = min(min(s2));
[seita1,seita2] = find(s2==mins2);

k = (log(sind(seita1)) - log(sind(seita2)))/...
    (log(tand(seita1/2)) - log(tand(seita2/2))); %圆锥常数

a = 6371;%地球半径
le = a*sind(seita1)/k*(1/tand(seita1/2))^k;
%11423.37;%映像平面上赤道到北极点的距离
d = round(a*cosd(phy0)*2*3.14/360);%格点距

l_ref = le * (cosd(phy0)/(1+sind(phy0)))^k;%参考点O到北极点的距离

%求出各网格点到北极点的距离并计算放大系数
for In = -M:M
    for Jn = -N:N
        l = sqrt((abs(In) * d)^2 + (l_ref-Jn*d)^2);
        m(Jn+1+N,In+1+M) = k*l/(a*sqrt( 1 -...
            ( ( le^(2/k) - l^(2/k) )/( le^(2/k) + l^(2/k) ) )^2 ));
    end
end

m = flipud(m);

%放到wrf模式应该为30°N和45°N 最佳应该是31°N和50°N
%d是按1经度算的