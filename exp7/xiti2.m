clear;clc;
%初始条件
nlon = 20;
dx = 0.1;
ntime = 5500;
dt = 0.004;
c = 1.5;
u = zeros(nlon,ntime);
u(:,1) = sin((1:nlon) * pi * dx/2);

uk = zeros(ntime,1);
uk(1) = sum(u(:,1).^2/2);
u(:,2) = u(:,1);
uk(2) = sum(u(:,2).^2/2);

%%
% 第一种格式

for step_id = 3:ntime
    for lon_id = 2:nlon-1
        u(lon_id,step_id) = u(lon_id,step_id-2) - 0.25*dt/dx * ( (u(lon_id+1,step_id-1) + u(lon_id,step_id-1))^2 - (u(lon_id,step_id-1) + u(lon_id-1,step_id-1))^2 );
        uk(step_id) = uk(step_id) + u(lon_id,step_id)^2/2;
    end
            
u(nlon,step_id) = u(nlon,step_id-1);
u(1,step_id) = u(1,step_id-1);
uk(step_id) = uk(step_id) + u(nlon,step_id)^2/2 + u(1,step_id)^2/2;
end

plot(1:ntime,uk,'--k','linewidth',1.5);
xlabel('积分步数','FontSize',14,'FontName','微软雅黑')
ylabel('动能','FontSize',14,'FontName','微软雅黑')
title("纬向总动能随积分次数的变化",'FontSize',14,'FontName','微软雅黑');
set(gca,'YScale','log')

%%
%第二种格式
ntime = 3;

for lon_id = 2:nlon-1
    eval(['syms ut',num2str(lon_id)])
end

for step_id = 3:ntime 
        
    u(nlon,step_id) = u(nlon,step_id-1);
    u(1,step_id) = u(1,step_id-1);
    ut1 = u(1,step_id-1);ut20 = u(nlon,step_id-1);
    
    for lon_id = 2:nlon-1
        eval(['eqn(lon_id-1) = (ut',num2str(lon_id),'==u(lon_id,step_id-2) - 1/16*c*dt/dx * (ut',num2str(lon_id+1),'^2+2*ut',num2str(lon_id+1),'*u(lon_id+1,step_id-1)+u(lon_id+1,step_id-1)^2-',...
            'ut',num2str(lon_id-1),'^2-2*ut',num2str(lon_id+1),'*u(lon_id+1,step_id-1)-u(lon_id+1,step_id-1)^2)','-1/24*c*dt/dx *(ut',...
            num2str(lon_id),'+u(lon_id,step_id-1))*(ut',num2str(lon_id+1),'-ut',num2str(lon_id-1),'+u(lon_id+1,step_id-1)-u(lon_id-1,step_id-1))',');'])
    end
    
    ut = [ut2,ut3,ut4,ut5,ut6,ut7,ut8,ut9,ut10,ut11,ut12,ut13,ut14,ut15,ut16,ut17,ut18,ut19];
    ut = solve(eqn, ut);
    
    for lon_id = 2:nlon-1
        eval(['u(lon_id,step_id) = ut.ut',num2str(lon_id),';'])
    end
    
    uk(step_id) = sum(u(:,step_id).^2/2);
    
end

uk(3) = sum(u(:,3).^2/2);

plot(1:ntime,uk(1:3),'--k','linewidth',1.5);
xlabel('积分步数','FontSize',14,'FontName','微软雅黑')
ylabel('动能','FontSize',14,'FontName','微软雅黑')
title("纬向总动能随积分次数的变化",'FontSize',14,'FontName','微软雅黑');