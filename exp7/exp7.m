clear;clc;
%初始条件
nlon = 20;
ntime = 3000;
dx = 0.05;
dt = 0.004;
c = 1.5;
u = zeros(nlon,ntime);
u(:,1) = sin((1:nlon) * pi * dx);

[u,uk] = time_integration(u,c,dx,dt,'central');

plot(1:ntime,uk,'--k','linewidth',1.5);
ylim([0 20])
xlabel('积分步数','FontSize',14,'FontName','微软雅黑')
ylabel('动能','FontSize',14,'FontName','微软雅黑')
title("纬向总动能随积分次数的变化",'FontSize',14,'FontName','微软雅黑');