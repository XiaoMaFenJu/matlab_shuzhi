clear;clc
M = 6;N = 7;%M东西扩展 N南北扩展
m = zeros(2 * N+1,2* M+1);%放大系数

d = 100;%格点距
phy0 = 30;%中央纬度
seita1 =30;seita2 = 60;
k = (log(sind(seita1)) - log(sind(seita2)))/...
    (log(tand(seita1/2)) - log(tand(seita2/2))); %圆锥常数

a = 6371;%地球半径
le = a*sind(seita1)/k*(1/tand(seita1/2))^k;
%11423.37;%映像平面上赤道到北极点的距离

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

%k与le并未直接采用数值，而是使用公式计算，便于后期修改，因此也会有部分精度差异
%实习参考点为北极点(0,0)