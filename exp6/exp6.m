clear;clc;
%初始条件
nlon = 20;
ntime = 3000;
dx = 0.05;
dt = 0.004;
c = 1.5;
u = zeros(nlon,ntime);
u(:,1) = sin((1:nlon) * pi * dx);

[u1,uk1] = time_integration(u,c,dx,dt,'backward');
dt = 0.04;
[u2,uk2] = time_integration(u,c,dx,dt,'backward');

subplot(1,2,1)
plot(1:ntime,uk1,'--k','linewidth',1.5);
ylim([-1 100])
xlabel('积分步数','FontSize',14,'FontName','微软雅黑')
ylabel('动能','FontSize',14,'FontName','微软雅黑')
text(-1,105,'(a) dt=0.004','fontsize',12)

subplot(1,2,2)
plot(1:ntime,uk2,'--k','linewidth',1.5);
ylim([-1 100])
xlabel('积分步数','FontSize',14,'FontName','微软雅黑')
ylabel('动能','FontSize',14,'FontName','微软雅黑')
text(-1,105,'(b) dt=0.04','fontsize',12)