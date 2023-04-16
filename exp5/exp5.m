clear;clc;
%初始条件
nlon = 20;
ntime = 3000;
dx = 0.05;
dt = 0.004;
c = 1.5;
u = zeros(nlon,ntime);
u(:,1) = sin((1:nlon) * pi * dx);

[u1,uk1] = time_integration(u,c,dx,dt,'forward');

plot(1:ntime,uk1,'--k','linewidth',1.5);
ylim([0 200])
xlabel('积分步数')
ylabel('动能')