function [ui,vi,zi] = interp_proj_grid(u,v,z,lmda_degree,phai_degreee,m,n,minlon,maxlon,minlat,maxlat)

[X,Y] = meshgrid(minlon:2:maxlon,minlat:2:maxlat);

for i = 1:m
    for j = 1:n
        ui(i,j) = interp2(X,Y,u',lmda_degree(i,j),phai_degreee(i,j));
        vi(i,j) = interp2(X,Y,v',lmda_degree(i,j),phai_degreee(i,j));
        zi(i,j) = interp2(X,Y,z',lmda_degree(i,j),phai_degreee(i,j));
    end
end

return