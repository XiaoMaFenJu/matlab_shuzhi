function zd = interp_proj_grid_z(z,lmda_degree,phai_degree,lon,lat)

[X,Y] = meshgrid(lon(161:801),lat(101:321));
zd = interp2(X,Y,z(161:801,101:321)',lmda_degree,phai_degree);

return