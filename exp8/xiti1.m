clear;clc;

S = 0.5;
dx = 1;
dy = dx;
L = 1:36;

R5 = 1 - S .* (sind(180./L.*dx).^2 + sind(180./L.*dy).^2);
R9 = (1 - 2 * S .* sind(180./L.*dx).^2) .* (1 - 2 * S .* sind(180./L.*dy).^2);
y = [R5;R9;R9-R5]';
x = 2:36;

plot(x,y(2:36,1),'k',x,y(2:36,2),'--k',x,y(2:36,3),'-.k','LineWidth',1.5);
xlim([0 36])
title('五点平滑、九点平滑的响应函数随波长的变化')
xlabel(['L/','\Deltax'])
set(gca,'xtick',[0,2,4,8,12,16,20,24,28,32,36],'xtickLabel',{'0','2','4','8','12','16','20','24','28','32','36',},...
    'ytick',[-0.5,0,0.5,1],'ytickLabel',{'-0.5','0','0.5','1'},...
    'FontSize',13,'FontName','微软雅黑','ylim',[-0.5 1])

yline(0,'LineWidth',2);
legend('R_{5}(1/2,L)','R_{9}(-1/2,L)','R_{5}(1/2,L)-R_{9}(-1/2,L)','Location','east')