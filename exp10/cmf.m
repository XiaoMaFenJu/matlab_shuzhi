function [rm,f,lmda_degree,phai_degree] = cmf(d,clat,clon,m,n)

R = 6371000;
omega = 2 * pi/(23*60*60 + 56*60 +4);

kk = (log(sind(30)) - log(sind(60)))/(log(tand(30/2)) - log(tand(60/2)));

theta = 30;
N = n;
M = m;
le = R * sind(theta)/kk * (1/tand(theta/2))^kk;
l1 = le * (tand(clat/2))^kk;

for i = 1:M
    for j = 1:N
        
        II(i,j) = (i-1-(M-1)/2);
        JJ(i,j) = l1/d + (N-1)/2-(j-1);
        l(i,j) = sqrt(II(i,j)^2 + JJ(i,j)^2) * d;
        l_tmp = (le^(2/kk) - l(i,j)^(2/kk))/(le^(2/kk) + l(i,j)^(2/kk));
        phai_degree(i,j) = asin(l_tmp) * 180/pi;
        lmda_degree(i,j) = atan(II(i,j)/JJ(i,j))/kk * 180/pi + clon;
        rm(i,j) = sind(theta)/sind(90 - phai_degree(i,j)) * (tand(90 - phai_degree(i,j)/2)/tand(theta/2))^kk;
        f(i,j) = 2 * omega * sind(phai_degree(i,j));

    end
end
return