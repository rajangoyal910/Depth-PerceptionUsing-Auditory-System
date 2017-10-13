function [ az_in, el_in ] = give_ind( az_val, el_val )
% give_ind.m - Find the index (in arr(:, :, :)) to which given coordinate
% belongs
%
% Input: 
% az_val - azimuth coordinate of pixel
% el_val - Elevation coordinate of pixel
%
% Output:
% az_in - Column number of pixel
% el_in - row number of pixel
%
    
%%
    %First find column number using azimuth coordinate

    %Initialize the column value
    az_in= NaN;
    
    %Check for azimuth values smaller than 50 degree
    if(az_val<= -72.5)   az_in= 1;
    else if (az_val<= -60)   az_in= 2;
        else if(az_val<= -50)    az_in= 3;
            end
        end
    end
    
    %Check for azimuth values greater than 50 degree
    if (az_val>= 72.5) az_in= 25;
    else if (az_val>= 60) az_in= 24;
        else if (az_val>= 50)    az_in= 23;
            end
        end
    end
    
    %Check for rest of the values
    if (isnan(az_in))
        temp= az_val/5;
        temp= int8(temp);        
        az_in= temp+ 13;    
    end
    

%%
    % Now find row number using elevation coordinate
    el_in= NaN;
    
    %Check for elevation smaller than -45 degree and greater than 45 degree
    if(el_val <= -45) el_in = 1;
    end
    if(el_val >= 45) el_in = 9;
    end
        
    %Check for rest of the values
    if (isnan(el_in))
        temp= el_val/(5.625*2);
        temp= int8(temp);        
        el_in= temp+ 5;
    end

end

