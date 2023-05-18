function [u,uk] = time_integration(u,c,dx,dt,difference_scheme)

nlon = size(u,1);
ntime = size(u,2);
uk = zeros(ntime,1);
uk(1) = sum(u(:,1).^2/2);

switch difference_scheme
    case 'forward'
        
        for step_id = 2:ntime
            for lon_id = 2:nlon-1
                u(lon_id,step_id) = u(lon_id,step_id-1) - 0.5*c*dt/dx * ...
                    (u(lon_id+1,step_id-1)-u(lon_id-1,step_id-1));
                uk(step_id) = uk(step_id) + u(lon_id,step_id)^2/2;
            end
            
            u(nlon,step_id) = u(nlon,step_id-1);
            u(1,step_id) = u(1,step_id-1);
            uk(step_id) = uk(step_id) + u(nlon,step_id)^2/2 ...
                            + u(1,step_id)^2/2;
        end
        
    case 'backward'
        
        for step_id = 2:ntime
            for lon_id = 3:nlon-2
                u(lon_id,step_id) = u(lon_id,step_id-1) - 0.5*c*dt/dx * ...
                    (u(lon_id+1,step_id-1)-u(lon_id-1,step_id-1)) + ...
                    (0.5*c*dt/dx)^2 * (u(lon_id+2,step_id-1)-2*u(lon_id,step_id-1)...
                    + u(lon_id-2,step_id-1));
                uk(step_id) = uk(step_id) + u(lon_id,step_id)^2/2;
            end
        
            for lon_id = 1:2
                u(lon_id,step_id) = u(lon_id,step_id-1);
                uk(step_id) = uk(step_id) + u(lon_id,step_id)^2/2;
                u(nlon-lon_id+1,step_id)=u(nlon-lon_id+1,step_id-1);
                uk(step_id) = uk(step_id) + u(nlon-lon_id+1,step_id)^2/2;
            end
        end

end