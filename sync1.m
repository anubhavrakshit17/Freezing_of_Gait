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
% Assuming you have already defined the variables mentioned in your code snippet
% selected_data = 1; % You should provide the actual selected_data value
% Create a cell array to store patient data
overall_data = {};
pac=48; % patient_averaged_channel = pac = 1

% For each patient, add their data to the cell array
% Repeat this section for each patient's data

% Patient 1
patient_data = struct();
patient_data.patient_name = 'Patient1';
patient_data.EEG_data = cropped_eeg_channel;
patient_data.IPG = cropped_eeg_channel_58;
patient_data.EEG_time = cropped_eeg_time;
patient_data.lfp_r = cropped_lfp_right;
patient_data.lfp_l = cropped_lfp_left;
patient_data.lfp_time = cropped_lfp_time;
overall_data{end+1} = patient_data;

% Patient 2 (similar to Patient 1)
patient_data = struct();
patient_data.patient_name = 'Patient2';
patient_data.EEG_data = cropped_eeg_channel; % Assuming you have data for Patient 2
patient_data.IPG = cropped_eeg_channel_58; % Assuming you have data for Patient 2
patient_data.EEG_time = cropped_eeg_time; % Assuming you have data for Patient 2
patient_data.lfp_r = cropped_lfp_right; % Assuming you have data for Patient 2
patient_data.lfp_l = cropped_lfp_left; % Assuming you have data for Patient 2
patient_data.lfp_time = cropped_lfp_time; % Assuming you have data for Patient 2
overall_data{end+1} = patient_data;
%

% Perform channel-wise averaging for all patients
num_channels = size(overall_data{1}.EEG_data, 1); % Assuming all patients have the same number of channels
average_channel_data = zeros(num_channels, length(cropped_eeg_time));
for i = 1:length(overall_data)
    average_channel_data = average_channel_data + overall_data{i}.EEG_data;
end
average_channel_data = average_channel_data / length(overall_data);
%%
% Plot the data
subplot(3, 1, 1);
plot(cropped_eeg_time, overall_data{1}.EEG_data(pac, :));
title('Patient 1 - EEG Data for Channel 1');
xlabel('Time');
ylabel('Amplitude');

subplot(3, 1, 2);
plot(cropped_eeg_time, overall_data{2}.EEG_data(pac, :));
title('Patient 2 - EEG Data for Channel 1');
xlabel('Time');
ylabel('Amplitude');

subplot(3, 1, 3);
plot(cropped_eeg_time, average_channel_data(pac, :));
title('Average EEG Data for Channel 1 (All Patients)');
xlabel('Time');
ylabel('Amplitude');

