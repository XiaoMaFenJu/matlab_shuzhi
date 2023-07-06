function [ui,vi,zi] = interp_proj_grid(u,v,z,lmda_degree,phai_degree,m,n,minlon,maxlon,minlat,maxlat)

[X,Y] = meshgrid(minlon:0.25:maxlon,minlat:0.25:maxlat);

for i = 1:m
    for j = 1:n
        ui(i,j) = interp2(X,Y,u',lmda_degree(i,j),phai_degree(i,j));
        vi(i,j) = interp2(X,Y,v',lmda_degree(i,j),phai_degree(i,j));
        zi(i,j) = interp2(X,Y,z',lmda_degree(i,j),phai_degree(i,j));
    end
end

return