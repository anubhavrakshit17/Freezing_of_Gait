clc
clear
close all
load("overall_data.mat");

fs = overall_data{1, 1}.EEGsampling_rate;

time_axis = overall_data{1, 1}.EEG_time;
lfpr = overall_data{1, 1}.lfp_r;


% Extract timestamps of 'Freezing_turn'
event_data = overall_data{1, 1}.Events;
freezing_indices = strcmp({event_data.type}, 'Freezing_turn');
freezing_duration = [event_data(freezing_indices).duration]/1000;
freezing_start = [event_data(freezing_indices).init_time];

% Define epoch duration and desired epoch length
epoch_duration = 15; % in seconds
desired_epoch_length = fs * (2 * epoch_duration + 1);

epochs = cell(length(freezing_start), 1);

for i = 1:length(freezing_start)
    freezing_time = freezing_start(i);
    start_index = find(time_axis >= freezing_time - epoch_duration, 1);
    end_index = start_index + desired_epoch_length - 1;
    
    % Ensure the end index is within bounds
    if end_index > length(time_axis)
        continue;
    end
    
    % Extract and store the epoch
    epoch_data = lfpr(start_index:end_index);
    epochs{i} = epoch_data;
end
time_steps = linspace(-epoch_duration, epoch_duration, length(epoch_data));
% Initialize an empty matrix to store the data
FreezingTurnP1Data_lfpr = zeros(1, 31000,5);

% Convert the cell array into a matrix
for i = 1:5
    FreezingTurnP1Data_lfpr(:,:,i) = epochs{i};
end
%%
clear
load time_steps_epoch.mat;
load FreezingTurnP1_LFPR.mat
fs = 1000;
range_cycles = [ 4 10 ];
min_freq =  2;
max_freq = 50;
num_frex = 40;
frex = linspace(min_freq,max_freq,num_frex);
timewin2 = [ -15 15 ]; % in ms
freqwin2 = [ 4 8 ]; % in Hz
time2idx = dsearchn(time_steps',timewin2');
freq2idx = dsearchn(frex',freqwin2');

s = logspace(log10(range_cycles(1)),log10(range_cycles(end)),num_frex) ./ (2*pi*frex);
wavtime = -2:1/fs:2;
half_wave = (length(wavtime)-1)/2;

nWave = length(wavtime);
nData = size(FreezingTurnP1Data_lfpr,2) * size(FreezingTurnP1Data_lfpr,3);
nConv = nWave + nData - 1;

tfall = zeros(2,length(frex),size(FreezingTurnP1Data_lfpr,2),size(FreezingTurnP1Data_lfpr,3));
data4corr = zeros(2,size(FreezingTurnP1Data_lfpr,3));

alldata = reshape( FreezingTurnP1Data_lfpr ,1,[]);

dataX = fft( alldata ,nConv );

for fi=1:length(frex)
        
        % create wavelet and get its FFT
        % (does this need to be computed here inside this double-loop?)
        wavelet  = exp(2*1i*pi*frex(fi).*wavtime) .* exp(-wavtime.^2./(2*s(fi)^2));
        waveletX = fft(wavelet,nConv);
        waveletX = waveletX ./ max(waveletX);
        
        % now run convolution in one step
        as = ifft(waveletX .* dataX);
        as = as(half_wave+1:end-half_wave);
        
        % and reshape back to time X trials
        as = reshape( as, size(FreezingTurnP1Data_lfpr,2), size(FreezingTurnP1Data_lfpr,3) );
        
        % compute power and save for all trials
        tfall(1,fi,:,:) = abs(as).^2;
end

figure(1), clf
contourf(time_steps,frex,squeeze(mean( tfall(1,:,:,:) ,4)),40,'linecolor','none')
set(gca,'clim',[0 5])
xlabel('Time (ms)'), ylabel('Frequency (Hz)')
%eval([ 'title([ ''Channel '' channel' num2str(chani) ' ])' ])
%%
