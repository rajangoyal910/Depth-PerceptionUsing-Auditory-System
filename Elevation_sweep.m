function Elevation_sweep( startE, startA, lastE, lastA )

%Elevation_sweep.m- Generates sound for every point in space and stores
%that in array

%Input- startA: Highest value of Elevation in scene
%       startE: Left most value of azimuth in scene
%       lastE; lowest Elevation value in scene
%       lastA: rightmost value of azimuth in scene
 

%%

%This section explains and loads variables required

%Load hrtf database
load('hrir_final.mat');

% arr: stores average depth at each pixel (found in main body)
%hrir_l hrir_r: stores hrtf data for left and right ears respectively
%outx outy: stores output signal for left and right ears respectively
%d_min d_max: stores minimum and maximum depth in whole scene respectively
%cnt: stores number of coordinates cooresponding to which sound has been
%stored in outx and outy
global arr hrir_l hrir_r outx outy cnt d_min d_max

%Initialize cnt
cnt= 0;

%Find d_max and multiply by 2 to remove boundary cases in reverberation
d_max= max(max(arr(:, :, 1)));
d_max= d_max*2;


%Find d_min and divide by 2 to remove boundary cases in reverberation
d_min = arr(startE, startA, 1);
for j= startE:lastE
    for i= startA:lastA
        if arr(j, i, 1)~= 0 && d_min> arr(j, i, 1)
            d_min= arr(j, i, 1);
        end
    end
end
d_min= d_min/2;

%%

%This section puts values in output array

for j= startE:lastE
    for i= startA:lastA
        ele= j;
        az= i;
        % Check if there is any pixel in original scene corresponding to current
        %location and then pass its coordiantes to obj.m
        if arr(j, i, 2)~= 0
           obj(az, ele, arr(j, i, 1));
        end
        
    end
end


%%

%This normalize the of output signal
max_val1 = 1.05*max(abs(outx));
max_val = 1.05*max(abs(outy));

if max_val1> max_val
    max_val= max_val1;
end

outx= outx/max_val;
outy= outy/max_val;

%%
%Combine two arrays to generate stereo signal
out1(1, :)= outx(1, :);
out1(2, :)= outy(1, :);
out1= out1.';

%%

%This generates required audio file

%fs: sampling frequency
fs= 44100;

%Generate audio file
filename_mix= 'test.wav';
audiowrite(filename_mix, out1, fs);