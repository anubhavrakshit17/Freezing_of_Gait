clc
clear all
close all
%%
load time_steps_epoch.mat;
FreezingTurnP1Data_lfpr = load("FreezingTurnP1_LFPR.mat");
data1 = FreezingTurnP1Data_lfpr.FreezingTurnP1Data_lfpr;
clear FreezingTurnP1Data_lfpr;
%%
FreezingTurnP1Data_eeg= load("FreezingTurnP1_EEG_48.mat");
data2= FreezingTurnP1Data_eeg.FreezingTurnP1Data(1,:,:);
clear FreezingTurnP1Data_eeg;
%%
fs =1000;
range_cycles = [ 4 10 ];
min_freq =  2;
max_freq = 50;
num_frex = 40;
frex = linspace(min_freq,max_freq,num_frex);

s = logspace(log10(range_cycles(1)),log10(range_cycles(end)),num_frex) ./ (2*pi*frex);
wavtime = -2:1/fs:2;
half_wave = (length(wavtime)-1)/2;
nWave = length(wavtime);

timewin1 = [ -15 15 ]; % in ms
freqwin1 = [ 4 8 ]; % in Hz
time1idx = dsearchn(time_steps',timewin1');
freq1idx = dsearchn(frex',freqwin1');


data1_points = size(data1,2);
data1_trials = size(data1,3);
nData1 = data1_points * data1_trials;
nConv1 = nWave + nData1 - 1;

timewin2 = [ -15 15 ]; % in ms
freqwin2 = [ 4 8 ]; % in Hz
time2idx = dsearchn(time_steps',timewin2');
freq2idx = dsearchn(frex',freqwin2');

data2_points = size(data2,2);
data2_trials = size(data2,3);
nData2 = data2_points * data2_trials;
nConv2 = nWave + nData2 - 1;

%%

tfall = zeros(2,length(frex),data1_points,data1_trials);
data4corr = zeros(2,data1_trials);
%%
alldata2 = reshape( data1 ,1,[]);
data1X = fft( alldata2 ,nConv1 );

alldata2 = reshape( data2 ,1,[]);
data2X = fft( alldata2 ,nConv2 );
%%
for fi=1:length(frex)
        
        % create wavelet and get its FFT
        % (does this need to be computed here inside this double-loop?)
        wavelet  = exp(2*1i*pi*frex(fi).*wavtime) .* exp(-wavtime.^2./(2*s(fi)^2));
        waveletX = fft(wavelet,nConv2);
        waveletX = waveletX ./ max(waveletX);
        
        % now run convolution in one step
        as1 = ifft(waveletX .* data1X);
        as1 = as1(half_wave+1:end-half_wave);
        
        % and reshape back to time X trials
        as1 = reshape( as1, data1_points,data1_trials);
        
        as2 = ifft(waveletX .* data2X);
        as2 = as2(half_wave+1:end-half_wave);
        
        % and reshape back to time X trials
        as2 = reshape( as2, data2_points,data2_trials);
        
        % compute power and save for all trials
        tfall(1,fi,:,:) = abs(as1).^2;
        tfall(2,fi,:,:) = abs(as2).^2;
end
%%
figure(1), clf
subplot(2,1,1)
contourf(time_steps,frex,squeeze(mean( tfall(1,:,:,:) ,4)),40,'linecolor','none')
set(gca,'clim',[0 5])
xlabel('Time (ms)'), ylabel('Frequency (Hz)')
%eval([ 'title([ ''Channel '' channel' num2str(chani) ' ])' ])
subplot(2,1,2)
contourf(time_steps,frex,squeeze(mean( tfall(2,:,:,:) ,4)),40,'linecolor','none')
set(gca,'clim',[0 5])
xlabel('Time (ms)'), ylabel('Frequency (Hz)')
%%
data4corr(1,:) = squeeze(mean(mean( tfall(1,freq1idx(1):freq1idx(2),time1idx(1):time1idx(2),:) ,2),3));
data4corr(2,:) = squeeze(mean(mean( tfall(2,freq2idx(1):freq2idx(2),time2idx(1):time2idx(2),:) ,2),3));
%%
figure(2), clf
plot(data4corr(1,:),data4corr(2,:),'o')
%xlabel([ 'Power: ' channel1 ', ' num2str(freqwin1(1)) '-' num2str(freqwin1(2)) 'Hz, ' num2str(timewin1(1)) '-' num2str(timewin1(2)) 'ms' ])
%ylabel([ 'Power: ' channel2 ', ' num2str(freqwin2(1)) '-' num2str(freqwin2(2)) 'Hz, ' num2str(timewin2(1)) '-' num2str(timewin2(2)) 'ms' ])

[r,p] = corr(data4corr','type','spearman');

title([ 'Correlation R=' num2str(r(1,2)) ', p=' num2str(p(1,2)) ])

%%