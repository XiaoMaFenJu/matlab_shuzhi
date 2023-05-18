clear;clc;
%初始条件
nlon = 20;
ntime = 300;
dx = 0.05;
dt = 0.004;
c = 1.5;
u = zeros(nlon,ntime);
u(:,1) = sin((1:nlon) * pi * dx);
uk = zeros(ntime,1);
uk(1) = sum(u(:,1).^2/2);

for step_id = 2:ntime
    for lon_id = 2:nlon-1
        u(lon_id,step_id) = u(lon_id,step_id-1) - 0.5*c*dt/dx * ...
                (u(lon_id+1,step_id-1)-u(lon_id-1,step_id-1)) + ...
                (c*dt/dx)^2 * (u(lon_id+1,step_id-1) - 2*u(lon_id,step_id-1) + u(lon_id-1,step_id-1));
        uk(step_id) = uk(step_id) + u(lon_id,step_id)^2/2;
    end
            
    u(nlon,step_id) = u(nlon,step_id-1);
    u(1,step_id) = u(1,step_id-1);
    uk(step_id) = uk(step_id) + u(nlon,step_id)^2/2 ...
            + u(1,step_id)^2/2;
end

plot(1:ntime,uk,'--k','linewidth',1.5);
xlabel('积分步数','FontSize',14,'FontName','微软雅黑')
ylabel('动能','FontSize',14,'FontName','微软雅黑')
title("Lax-Wendroff格式",'FontSize',14,'FontName','微软雅黑');