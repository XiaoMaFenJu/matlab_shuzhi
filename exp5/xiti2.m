clear;clc;
%初始条件
nlon = 20;
ntime = 3000;
dx = 0.05;
dt = 0.004;
c = 2.5;
u1 = zeros(nlon,ntime);
u1(:,1) = sin((1:nlon) * pi * dx)+1.5;
uk1 = zeros(ntime,1);

% 时间层采用后差，空间层中央差分
for step_id = 2:ntime 
    for lon_id = 2:nlon-1
            u1(lon_id,step_id) = u1(lon_id,step_id-1  ) - 0.5*c*dt/dx * ...
                    (u1(lon_id+1,step_id)-u1(lon_id-1,step_id));
            uk1(step_id) = uk1(step_id) + u1(lon_id,step_id)^2/2;
    end
            
        u1(lon_id,step_id) = u1(lon_id,step_id-1);
        u1(1,step_id) = u1(1,step_id-1);
        uk1(step_id) = uk1(step_id) + u1(lon_id,step_id)^2/2 ...
                            + u1(1,step_id-1)^2/2;
end

u2 = zeros(nlon,ntime);
u2(:,1) = sin((1:nlon) * pi * dx)+1.5;
uk2 = zeros(ntime,1);
% 时间层采用后差，空间层前差
for step_id = 2:ntime 
    for lon_id = 2:nlon-1
            u2(lon_id,step_id) = u2(lon_id,step_id-1  ) - c*dt/dx * ...
                    (u2(lon_id+1,step_id)-u2(lon_id,step_id));
            uk2(step_id) = uk2(step_id) + u2(lon_id,step_id)^2/2;
    end
            
        u2(lon_id,step_id) = u2(lon_id,step_id-1);
        u2(1,step_id) = u2(1,step_id-1);
        uk2(step_id) = uk2(step_id) + u2(lon_id,step_id)^2/2 ...
                            + u2(1,step_id-1)^2/2;
end

figure('Units','centimeter','Position',[5 5 32 10]);

subplot(1,2,1)
plot(1:ntime,uk1,'--k','linewidth',1.5);
title("时间层后差，空间层中央差");
ylim([0 200])
xlabel('积分步数')
ylabel('动能')

subplot(1,2,2)
plot(1:ntime,uk2,'--k','linewidth',1.5);
title("时间层后差，空间层前差");
ylim([0 200])
xlabel('积分步数')
ylabel('动能')
