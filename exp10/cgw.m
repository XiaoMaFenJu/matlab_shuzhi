function [ua,va] = cgw(za,rm,f,d,m,n)

c = 9.8/d;
for i = 1:m
    ua(i,1) = -c*rm(i,1)*(za(i,2)-za(i,1))/f(i,1);
    ua(i,n) = -c*rm(i,n)*(za(i,n)-za(i,n-1))/f(i,n);
    for j = 2:n-1
        ua(i,j) = -c*rm(i,j)*(za(i,j+1)-za(i,j))/(1.0*f(i,j));
    end
end

for j = 1:n
    va(1,j) = c*rm(1,j)*(za(2,j)-za(1,j))/f(1,j);
    va(m,j) = c*rm(m,j)*(za(m,j)-za(m-1,j))/f(m,j);
    for i = 2:m-1
        va(i,j) = c*rm(i,j)*(za(i+1,j)-za(i,j))/(1.0*f(i,j));
    end
end

return