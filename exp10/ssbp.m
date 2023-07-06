% function [a]=ssbp(a,w,s,m,n)
function w=ssbp(a,s,m,n)
%     space smoothing for boundary points ±ß½ç¾ÅµãÆ½»¬
m1=m-1;
m3=m-3;
n1=n-1;
n2=n-2;
n3=n-3;
w = a; %zeros(size(a));
for i=2:m1
    for j=2:n3:n1
        w(i,j)=a(i,j)+0.5*s*(1.0-s)*(a(i-1,j)+a(i+1,j)+a(i,j-1)+a(i,j+1)-4.0*a(i,j))...
            +0.25*s*s*(a(i-1,j-1)+a(i-1,j+1)+a(i+1,j-1)+a(i+1,j+1)-4.0*a(i,j));
    end
end
for i=2:m3:m1
    for j=3:n2
        w(i,j)=a(i,j)+0.5*s*(1.0-s)*(a(i-1,j)+a(i+1,j)+a(i,j-1)+a(i,j+1)-4.0*a(i,j))...
            +0.25*s*s*(a(i-1,j-1)+a(i-1,j+1)+a(i+1,j-1)+a(i+1,j+1)-4.0*a(i,j));
    end
end
% for i=2:m1
%     for j=2:n3:n1
%         a(i,j)=w(i,j);
%     end
% end
% for i=2:m3:m1
%     for j=3:n2
%         a(i,j)=w(i,j);
%     end
% end
return
