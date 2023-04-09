clear;clc
M = 6;N = 5;%M东西扩展 N南北扩展
m = zeros(N+1,M+1);%放大系数
f = zeros(N+1,M+1);%科氏力参数
omega = 7.292*10^-5;

d = 80;%格点距
phy0 = 45;%中央纬度
seita1 = 30;seita2 = 60;
k = (log(sind(seita1)) - log(sind(seita2)))/...
    (log(tand(seita1/2)) - log(tand(seita2/2))); %圆锥常数
% k = 0.7156;

a = 6371;%地球半径
le = a*sind(seita1)/k*(1/tand(seita1/2))^k;
% le = 11423.37;
%映像平面上赤道到北极点的距离

l_ref = le * (cosd(phy0)/(1+sind(phy0)))^k;%参考点O到北极点的距离

%求出各网格点到北极点的距离并计算放大系数
for In = 0:M
    for Jn = 0:N
        l = sqrt((abs(In) * d)^2 + (l_ref-Jn*d)^2);
        m(Jn+1,In+1) = k*l/(a*sqrt( 1 -...
            ( ( le^(2/k) - l^(2/k) )/( le^(2/k) + l^(2/k) ) )^2 ));
        f(Jn+1,In+1) = 2 * omega * ( ( le^(2/k) - l^(2/k) )/( le^(2/k) + l^(2/k) ) );
    end
end

m = flipud(m);f = flipud(f);
    
%习题1仅要求北向与东向，所以修改循环。