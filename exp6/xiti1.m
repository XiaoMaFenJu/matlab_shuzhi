clear;clc;
%初始条件
nlon = 20;
ntime = 300;
dx = 0.05;
dt = 0.004;
c = 1.5;
u1 = zeros(nlon,ntime);
u1(:,1) = sin((1:nlon) * pi * dx);
uk1 = zeros(ntime,1);
uk1(1) = sum(u1(:,1).^2/2);

for lon_id = 2:nlon-1
    eval(['syms ut',num2str(lon_id)])
end

% 时间层后差，空间层中央差
for step_id = 2:ntime 
% step_id = 2;
        
    u1(nlon,step_id) = u1(nlon,step_id-1);
    u1(1,step_id) = u1(1,step_id-1);
    ut1 = u1(1,step_id-1);ut20 = u1(nlon,step_id-1);

    for lon_id = 2:nlon-1
        eval(['eqn(lon_id-1) = (ut',num2str(lon_id),'==u1(lon_id,step_id-1) - 0.5*c*dt/dx * (ut',num2str(lon_id+1),'-ut',num2str(lon_id-1),'));'])
    end
    
    ut = [ut2,ut3,ut4,ut5,ut6,ut7,ut8,ut9,ut10,ut11,ut12,ut13,ut14,ut15,ut16,ut17,ut18,ut19];
    ut = solve(eqn, ut);
    
    for lon_id = 2:nlon-1
        eval(['u1(lon_id,step_id) = ut.ut',num2str(lon_id),';'])
    end
    
    uk1(step_id) = sum(u1(:,step_id).^2/2);
    
end

% 时间层后差，空间层前差
u2 = zeros(nlon,ntime);
u2(:,1) = sin((1:nlon) * pi * dx);
uk2 = zeros(ntime,1);
uk2(1) = sum(u2(:,1).^2/2);

for step_id = 2:ntime 
% step_id = 2;
        
    u2(nlon,step_id) = u2(nlon,step_id-1);
    u2(1,step_id) = u2(1,step_id-1);
    ut1 = u2(1,step_id-1);ut20 = u2(nlon,step_id-1);
    for lon_id = 2:nlon-1
        eval(['syms ut',num2str(lon_id)])
    end
    for lon_id = 2:nlon-1
        eval(['eqn(lon_id-1) = (ut',num2str(lon_id),'==u2(lon_id,step_id-1) - c*dt/dx * (ut',num2str(lon_id+1),'-ut',num2str(lon_id),'));'])
    end
    
    ut = [ut2,ut3,ut4,ut5,ut6,ut7,ut8,ut9,ut10,ut11,ut12,ut13,ut14,ut15,ut16,ut17,ut18,ut19];
    ut = solve(eqn, ut);
    
    for lon_id = 2:nlon-1
        eval(['u2(lon_id,step_id) = ut.ut',num2str(lon_id),';'])
    end
    
    uk2(step_id) = sum(u2(:,step_id).^2/2);
    
end

figure('Units','centimeter','Position',[5 5 30 10]);

subplot(1,2,1)
plot(1:ntime,uk1,'--k','linewidth',1.5);
title("时间层后差，空间层中央差",'FontSize',14,'FontName','微软雅黑');
ylim([0 10])
xlabel('积分步数','FontSize',14,'FontName','微软雅黑')
ylabel('动能','FontSize',14,'FontName','微软雅黑')

subplot(1,2,2)
plot(1:ntime,uk2,'--k','linewidth',1.5);
title("时间层后差，空间层前差",'FontSize',14,'FontName','微软雅黑');
ylim([0 100])
xlabel('积分步数','FontSize',14,'FontName','微软雅黑')
ylabel('动能','FontSize',14,'FontName','微软雅黑')