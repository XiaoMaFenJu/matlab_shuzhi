function w = ssnp(a,s,m,n)

m1 = m - 1;
n1 = n - 1;
w = a;

for i = 2:m1
    for j = 2:n1
        w(i,j) = a(i,j) + 0.5*s*(1.0-s)*(a(i-1,j)+a(i+1,j)+a(i,j-1)+a(i,j+1)-4.0*a(i,j))+0.25*s*s*(a(i-1,j-1)+a(i-1,j+1)+a(i+1,j-1)+a(i+1,j+1)-4.0*a(i,j));
    end
end

return