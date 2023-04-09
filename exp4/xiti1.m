clear;clc
fai = [50;60;70;80];

a = 6371;
omega = 7.292 * 10^(-5);

k = 1;
seita0 = 30;

le = a*sind(seita0)/tand(seita0/2);
l = le*tand((90-fai)/2);

sinfai = (le.^2 - l.^2)./(le.^2 + l.^2);

m = sind(seita0)/tand(seita0/2) ./ (1 + sinfai);
f = 2*omega.*sinfai;
