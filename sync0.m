clc
clear 
close all
LFPalg = load('PD09_walkwstopp.eeg_lfpalg.mat');
EEG = load('PD09_walkwstopp.eeg_eegalg.mat');

fs_eeg = EEG.EEG_File.fs_eeg;
selected_data = 20*(fs_eeg);
% Assuming you have loaded the data into variables as described
lfp_time = LFPalg.LFP.LFP_time;
lfp_right = LFPalg.LFP.LFP_signal_L;
lfp_left = LFPalg.LFP.LFP_signal_R;

lfp_right(isnan(lfp_right)) = 0;
lfp_left(isnan(lfp_left)) = 0;
lfp_right = lfp_right(1:length(lfp_time));
lfp_left = lfp_left(1:length(lfp_time));

eeg_channel_58 = EEG.EEG_File.EEG_signal(58, 1:length(lfp_time));
eeg_channel = EEG.EEG_File.EEG_signal(1:48, 1:length(lfp_time));
eeg_time = EEG.EEG_File.EEG_time(1:length(lfp_time));
lfp_time = lfp_time(1:length(lfp_time));
clear EEG  LFPalg

figure;

% Plot EEG channel 58 on the top
subplot(4, 1, 1);
plot(eeg_time, eeg_channel_58);
title('EEG Channel 58');
xlabel('Time');
ylabel('Amplitude');

subplot(4, 1, 2);
plot(eeg_time, eeg_channel);
title('EEG Channel 58');
xlabel('Time');
ylabel('Amplitude');

% Plot LFP right on the middle
subplot(4, 1, 3);
plot(lfp_time, lfp_right);
title('LFP Right');
xlabel('Time');
ylabel('Amplitude');


% Plot LFP left on the bottom
subplot(4, 1, 4);
plot(lfp_time, lfp_left);
title('LFP Left');
xlabel('Time');
ylabel('Amplitude');

%%
% EEG data
cropped_eeg_channel_58 = eeg_channel_58(1,selected_data:length(lfp_time));
cropped_eeg_channel = eeg_channel(1:48, selected_data:length(lfp_time));
cropped_eeg_time = eeg_time(selected_data:length(lfp_time));
cropped_lfp_right = lfp_right(selected_data:length(lfp_time));
cropped_lfp_left = lfp_left(selected_data:length(lfp_time));
cropped_lfp_time = lfp_time(selected_data:length(lfp_time));

clear eeg_channel eeg_channel_58 eeg_time lfp_time lfp_left lfp_right


%%
% Create a new figure and arrange subplots
figure;

% Plot EEG channel 58 on the top
subplot(4, 1, 1);
plot(cropped_eeg_time, cropped_eeg_channel_58);
title('EEG Channel 58');
xlabel('Time');
ylabel('Amplitude');

subplot(4, 1, 2);
plot(cropped_eeg_time, cropped_eeg_channel);
title('EEG Channel 58');
xlabel('Time');
ylabel('Amplitude');

% Plot LFP right on the middle
subplot(4, 1, 3);
plot(cropped_lfp_time, cropped_lfp_right);
title('LFP Right');
xlabel('Time');
ylabel('Amplitude');


% Plot LFP left on the bottom
subplot(4, 1, 4);
plot(cropped_lfp_time, cropped_lfp_left);
title('LFP Left');
xlabel('Time');
ylabel('Amplitude');
%%

