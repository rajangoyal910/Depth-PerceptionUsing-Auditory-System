close all
clear all
clc

%%

%depth = imread('meeting_small_1_1_depth.png'); 

% Make Depth Map according to need

depth= ones(480, 640);
depth= depth*0.1;
for i= 1:480
    for j= 150:500
        depth(i, j)= (640-j)/1000;
    end
end

%%

%Find world coordinated using depthToCloud function
[pcloud, distance] = depthToCloud(depth);

%Extact (X, Y, Z) coordinates seperately
X= pcloud(:, :, 1);
Y= pcloud(:, :, 2);
Z= pcloud(:, :, 3);

%Display the scene to get idea of orientation as per axis
pcshow(pcloud)
xlabel('X');
ylabel('Y');
zlabel('Z');

%%

%Change cartesian coordinates to spherical coordinates

r= sqrt(X.*X+ Y.*Y+ Z.*Z);

ele= asin((-Y)./r);
ele= ele.*(180/pi);

az= atan((X)./Z);
az= az.*(180/pi);

%%

% This section divides the complete image into blocks as per resolution

%These are the Discrete theta and phi coordinates
az_arr= [-80 -65 -55 -45 -40 -35 -30 -25 -20 -15 -10 -5 0 5 10 15 20 25 30 35 40 45 55 65 80];
el_arr= -45:5.625*2:45;

[row, col]= size(r);
row1= size(el_arr, 2);
col1= size(az_arr, 2);

%arr(:, :, 1) stores distance corresponding to all discrete theta and phi
%arr(:, :, 2) stores number of pixels used for averaging
global arr
arr= zeros(row1, col1, 2);

%Now find the block in which each pixel lies
%Then stores the average in arr(:, :, 1)
for i= 1: row
    for j= 1: col
        if (~isnan(ele(i, j)) && ~isnan(az(i, j)) && ~isnan(r(i, j)))
            [az_in, el_in]= give_ind(az(i, j), ele(i, j));
            if (~isnan(az_in) && ~isnan(el_in))
                arr(el_in, az_in, 1)= arr(el_in, az_in, 1)*arr(el_in, az_in, 2)+ r(i, j);
                arr(el_in, az_in, 2)= arr(el_in, az_in, 2)+ 1;
                arr(el_in, az_in, 1)= arr(el_in, az_in, 1)/ arr(el_in, az_in, 2);
            end
        end
    end
end

%%

%Find the starting and ending coordinates of scenes
startE= 1;
while 1
    if max(arr(startE, :, 1))== 0
        startE= startE+ 1;
    else
        break;
    end
end


startA= 1;
while 10
    if max(arr(:, startA, 1))== 0
        startA= startA+ 1;
    else
        break;
    end
end

lastE= startE;
while 1
    if lastE<= row1 && max(arr(lastE, :, 1))~= 0
        lastE= lastE+ 1;
    else
        break;
    end
end

lastA= startA;
while 1
    if lastA<= col1 && max(arr(:, lastA, 1))~= 0
        lastA= lastA+ 1;
    else
        break;
    end
end

%%

%Pass local variables to Elevation Sweep function to generate sound
Elevation_sweep( startE, startA, lastE, lastA);