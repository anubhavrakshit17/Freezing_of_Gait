clc
clear all
close all

load time_steps_epoch.mat;
FreezingTurnP1Data_lfpr = load("FreezingTurnP1_LFPR.mat");
data1 = FreezingTurnP1Data_lfpr.FreezingTurnP1Data_lfpr;
clear FreezingTurnP1Data_lfpr;

FreezingTurnP1Data_eeg= load("FreezingTurnP1_EEG_48.mat");
data2= FreezingTurnP1Data_eeg.FreezingTurnP1Data(15,:,:);
clear FreezingTurnP1Data_eeg;

%% Define the time region of interest
% Specify the start and end times of the time region you're interested in
start_time = -10; % Start time in ms
end_time = 0;   % End time in ms

% Find the indices corresponding to the start and end times
start_idx = find(time_steps >= start_time, 1);
end_idx = find(time_steps <= end_time, 1, 'last');

% Extract the data within the specified time region
data1_roi = data1(:, start_idx:end_idx, :);
data2_roi = data2(:, start_idx:end_idx, :);
time_steps_roi = time_steps(start_idx:end_idx);
data1 = data1_roi;
data2= data2_roi;
time_steps=time_steps_roi;


% names of the channels you want to compute connectivity between
channel1 = 'p1';
channel2 = 'pz';
fs =1000;


% create complex Morlet wavelet
center_freq = 5;
time      = -1:1/fs:1;
wavelet   = exp(2*1i*pi*center_freq.*time) .* exp(-time.^2./(2*(4/(2*pi*center_freq))^2));
half_wavN = (length(time)-1)/2;


% FFT parameters
n_wavelet = length(time);
n_data    = size(data1,2);
n_conv    = n_wavelet+n_data-1;

% FFT of wavelet
waveletX = fft(wavelet,n_conv);
waveletX = waveletX ./ max(waveletX);

% initialize output time-frequency data
phase_data = zeros(2,n_data);
real_data  = zeros(2,n_data);
%%
% find channel indices
% analytic signal of channel 1
fft_data = fft(squeeze(data1(1,:,1)),n_conv);
as = ifft(waveletX.*fft_data,n_conv);
as = as(half_wavN+1:end-half_wavN);

% collect real and phase data
phase_data(1,:) = angle(as);
real_data(1,:)  = real(as);

% analytic signal of channel 2
fft_data = fft(squeeze(data2(1,:,1)),n_conv);
as = ifft(waveletX.*fft_data,n_conv);
as = as(half_wavN+1:end-half_wavN);

% collect real and phase data
phase_data(2,:) = angle(as);
real_data(2,:)  = real(as);

%% setup figure and define plot handles

% open and name figure
figure, set(gcf,'Name','Movie magic minimizes the magic.');

% draw the filtered signals
subplot(221)
filterplotH1= plot(time_steps,real_data(1,:),'b');
hold on
filterplotH2 = plot(time_steps,real_data(2,:),'m');
set(gca,'xlim',[time_steps(1) time_steps(end)],'ylim',[min(real_data(:)) max(real_data(:))])
xlabel('Time (ms)')
ylabel('Voltage (\muV)')
title([ 'Filtered signal at ' num2str(center_freq) ' Hz' ])


% draw the phase angle time series
subplot(222)
phaseanglesH1 = plot(time_steps,phase_data(1,:),'b');
hold on
phaseanglesH2 = plot(time_steps,phase_data(2,:),'m');
set(gca,'xlim',[time_steps(1) time_steps(end)],'ylim',[-pi pi]*1.1)
xlabel('Time (ms)')
ylabel('Phase angle (radian)')
title('Phase angle time series')

phase_row = phase_data(1, :);

% Create an array of angles corresponding to the phase values
angles = linspace(0, 2*pi, numel(phase_row));

% Create a polar plot

% draw phase angles in polar space
subplot(223)

polar2chanH1 = polarplot(angles, phase_row, 'b');
hold on
phase_row = phase_data(2, :);
polar2chanH2 = polarplot(angles, phase_row,'m');
title('Phase angles from two channels')

% draw phase angle differences in polar space
subplot(224)
phase_row= phase_data(2,:)-phase_data(1,:);
polarplot(angles, phase_row, 'k');
title('Phase angle differences from two channels')

phase_angle_differences = phase_data(2,:)-phase_data(1,:);
% euler representation of angles
euler_phase_differences = exp(1i*phase_angle_differences);
% mean vector (in complex space)
mean_complex_vector = mean(euler_phase_differences);
mean_complex_angle = angle(mean_complex_vector);
phase_synchronization = abs(mean(exp(1i*(phase_data(2,:)-phase_data(1,:)))));
hold on
%h=polar([0 angle(mean_complex_vector)],[0 phase_synchronization]);
h=polarplot([0 mean_complex_angle], [0 phase_synchronization]);
set(h,'linewidth',6,'color','g')
