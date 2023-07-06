function [ub,vb,zb] = ts(ua,ub,uc,va,vb,vc,za,zb,zc,s)

[m.n] = size(ua);
m1 = m - 1;
n1 = n - 1;

for i = 2:m1
    for j = 2:n1
        ub(i,j) = ub(i,j) + s * (ua(i,j)+uc(i,j) - 2.0 * ub(i,j))/2.0;
        vb(i,j) = vb(i,j) + s * (va(i,j)+vc(i,j) - 2.0 * vb(i,j))/2.0;
        zb(i,j) = zb(i,j) + s * (za(i,j)+zc(i,j) - 2.0 * zb(i,j))/2.0;
    end
end
return