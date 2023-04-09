function [m,f] = magnification_factor_and_coriolis_parameter(proj,In,Jn,d)
%参考点为北极点(0,0)
a = 6371;omega = 7.292*10^-5;

switch(proj)
    
    case 'lambert'
        k = 0.7156;le = 11423.37;
        l = sqrt((In^2+Jn^2)*d^2);
        m = k * l/a/sqrt( 1 - ( (le^(2/k) - l^(2/k))/(le^(2/k) + l^(2/k)) )^2 );
        f = 2 * omega * (le^(2/k) - l^(2/k))/(le^(2/k) + l^(2/k));

    case 'mercator'
        m = sqrt((a * cosd(22.5))^2+(Jn*d)^2 )/a;
        f = 2 * omega * sin(Jn *d/sqrt((a * cosd(22.5))^2+(Jn*d)^2));
        
    case 'stereographic'
        le = 11888.45;
        l = sqrt((In^2+Jn^2)*d^2);
        m = (2+sqrt(3))/2/(1+((le^2-l^2)/(le^2+l^2)));
        f = 2 * omega * ((le^2-l^2)/(le^2+l^2));
        
    otherwise
        disp('投影方式输入错误！')
end
end

%该计算程序汇编成一个即可，不必按实习进行区分