function zb = ts_lvar(za,zb,zc,s)

zb(2:end-1,2:end-1) = zb(2:end-1,2:end-1) + s * (za(2:end-1,2:end-1)+zc(2:end-1,2:end-1) - 2.0 * zb(2:end-1,2:end-1))/2.0;
return