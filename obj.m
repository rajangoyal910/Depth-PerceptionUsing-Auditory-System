function obj( az, ele, dist)
% obj.m - Generates sound signal for given sperical coordinates and inserts
% its values in outx, outy array
%
% Input: 
% az - Index of azimuth array 
% ele - Index of azimuth array
%

    %Load all global variables needed
    global hrir_l hrir_r outx outy cnt d_min d_max
    
    %Extract transfer function corresponding to specific coordinates
    % hl and hr = 2-D hrir data
    hl = squeeze(hrir_l(az,ele,:));
    hr = squeeze(hrir_r(az,ele,:));
    
%%
% design input signal
    
    sd = 200;         % stimulus duration in ms
    gd = 100;         % gap duration of stimulus duration in ms
    fs = 44100;       % sampling frequency
    fm = 9000;        % Modulation frequency (Hz)
    T = sd;
    
    T = fix(fm*(T/1000)+0.9999)/fm;    % Extend duration for an integer
    L = round(fs*T);                   % number of modulation cycles
    x = 0:L-1;
    mL = (0.8/dist)*(1- cos(2*pi*x*fm/fs));
    r = bluenoise(L); %generates L random numbers which are normally distributed
    
    Insig_L = r.*mL;
    
    Insig_L = [Insig_L zeros(1,round(gd/1000*fs))];
    
    Lsig  = length(Insig_L);
    [N,L] = size(hl);
    out   = zeros(N*Lsig,2);
    ramp  = ones(size(Insig_L));
    hann  = hanning(round(.05*fs));
    ramp(1:round(0.025*fs)) = hann(1:round(0.025*fs));
    ramp(end-round(0.025*fs)+1:end) = hann(round(0.025*fs):end);
    Insig_L = Insig_L.*ramp;
        
%%
% Put reverberation in signal

    %Design reverbrator object
    reverb = reverberator('PreDelay',d_min/dist,'WetDryMix',(dist*dist)/(d_max*d_max));
    LR= filter(hl, 1, Insig_L)';
    RR= filter(hr, 1, Insig_L)';
    % add reverberation and extract left and right signals
    LR= step(reverb, LR);
    RR= step(reverb, RR);
    LR1(:, 1)= (LR(:, 1));
    RR1(:, 1)= (RR(:, 2));
    
%%
% Insert output signal in outx and outy array and update cnt

    outx(((cnt)*Lsig+1):((cnt+1)*Lsig)) = LR1(:, 1);
    outy(((cnt)*Lsig+1):((cnt+1)*Lsig)) = RR1(:, 1);
    cnt= cnt+1;
   
end

