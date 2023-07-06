function [a] = ssip(a,s,m,n,l)

m1 = m-1;
n1 = n-1;
w = zeros(size(a));

if(l==0)
    for i = 2:m1
        for j = 2:n1
            w(i,j) = a(i,j) + s *(a(i-1,j)+a(i+1,j)+a(i,j-1)+a(i,j+1)-4.0*a(i,j))/4.0;
        end
    end
    a(2:m1,2:n1) = w(2:m1,2:n1);
end

if(l==0)
    for i = 2:m1
        for j = 2:n1
            w(i,j) = a(i,j) - s *(a(i-1,j)+a(i+1,j)+a(i,j-1)+a(i,j+1)-4.0*a(i,j))/4.0;
        end
    end
    a(2:m1,2:n1) = w(2:m1,2:n1);
end

return