clear;clc
m = zeros(7,8);
f = zeros(7,8);
d = 100;
phy0 = 50;
a = 6371;
omega = 7.292 * 10^(-5);

seita0 = 20;
le = a*sind(seita0)/tand(seita0/2);

l_ref = le * cosd(phy0)/(1+sind(phy0));

for In = 0:7
    for Jn = 0:6
        
        l = sqrt((abs(In)*d)^2+(l_ref-Jn*d)^2);
        
        m(Jn+1,In+1) = sind(seita0)/tand(seita0/2)/(1+((le^2-l^2)/(le^2+l^2)));
        
        f(Jn+1,In+1) = 2 * omega * ((le^2-l^2)/(le^2+l^2));
        
    end
end

m = flipud(m);f=flipud(f);