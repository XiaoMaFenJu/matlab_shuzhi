function [ua,va,za] = tbv(ub,vb,zb,m,n)

for j=1:n-1:n
    ua(1:m,j) = ub(1:m,j);
    va(1:m,j) = vb(1:m,j);
    za(1:m,j) = zb(1:m,j);
end

for i=1:m-1:m
    ua(i,1:n) = ub(i,1:n);
    va(i,1:n) = vb(i,1:n);
    za(i,1:n) = zb(i,1:n);
end
return