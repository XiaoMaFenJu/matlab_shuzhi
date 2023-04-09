clear;clc;
m = zeros(7,8);
f = zeros(7,8);
d = 100;
phy0 = 5;
a = 6371;
omega = 7.292 * 10^(-5);

l_ref = a * cosd(22.5) * tand(phy0);

for In = 0:7
    for Jn = 0:6
        
        l = sqrt((l_ref+Jn*d)^2);
        
        m(Jn+1,In+1) = sqrt((a*cosd(22.5))^2+l^2)/a;
        
        f(Jn+1,In+1) = 2*omega*l/sqrt((a*cosd(22.5))^2+l^2);
    end
end

m = flipud(m);f = flipud(f);