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

% EEG data
cropped_eeg_channel_58 = eeg_channel_58(1,selected_data:length(lfp_time));
cropped_eeg_channel = eeg_channel(1:48, selected_data:length(lfp_time));
cropped_eeg_time = eeg_time(selected_data:length(lfp_time));
cropped_lfp_right = lfp_right(selected_data:length(lfp_time));
cropped_lfp_left = lfp_left(selected_data:length(lfp_time));
cropped_lfp_time = lfp_time(selected_data:length(lfp_time));

clear eeg_channel eeg_channel_58 eeg_time lfp_time lfp_left lfp_right
% Creating the overall data 
% Assuming you have already defined the variables mentioned in your code snippet
% selected_data = 1; % You should provide the actual selected_data value
% Create a cell array to store patient data
overall_data = {};

% For each patient, add their data to the cell array
% Repeat this section for each patient's data


% Patient 1
patient_data = struct();
patient_data.patient_name = 'Patient1';
patient_data.EEGsampling_rate = fs_eeg;
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
patient_data.EEGsampling_rate = fs_eeg;
patient_data.EEG_data = cropped_eeg_channel; % Assuming you have data for Patient 2
patient_data.IPG = cropped_eeg_channel_58; % Assuming you have data for Patient 2
patient_data.EEG_time = cropped_eeg_time; % Assuming you have data for Patient 2
patient_data.lfp_r = cropped_lfp_right; % Assuming you have data for Patient 2
patient_data.lfp_l = cropped_lfp_left; % Assuming you have data for Patient 2
patient_data.lfp_time = cropped_lfp_time; % Assuming you have data for Patient 2
overall_data{end+1} = patient_data;
%%
overall_data = processPatientEEG(overall_data,fs_eeg);

function overall_data = processPatientEEG(overall_data,fs_eeg)
    % Take user input for patient ID
    patientID = input('Enter patient ID: ');

    % Choose the patient based on patientID
    selectedPatient = overall_data{1, patientID}; % Assuming your data structure is a cell array

    % EEG data for the selected patient
    eegData = selectedPatient.EEG_data;

   % Assuming 'selectedPatient', 'eegData', and 'fs' are defined
   selectedPatient = frequency_band_decomposition(selectedPatient, eegData, fs_eeg);


    % Update the 'overall_data' with the modified patient data
    selectedPatient.EEG_data = eegData;
    overall_data{1, patientID} = selectedPatient;
     disp("Now 'overall_data' contains the decomposed EEG data for the selected patient") 
end

function selectedPatient = frequency_band_decomposition(selectedPatient, eegData, fs)
    % Define frequency bands
    bands = struct('name', {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'}, ...
                   'range', {[0.5, 4], [4, 7], [8, 15], [16, 31], [32, 100]});

    % Apply band-pass filters and decompose EEG data
    for bandIdx = 1:length(bands)
        bandName = bands(bandIdx).name;
        frequencyRange = bands(bandIdx).range;

        % Apply band-pass filter
        filteredEEG = bandpass(eegData, frequencyRange, fs);
        
        % Display the filtered EEG data (optional)
        figure;
        plot(selectedPatient.EEG_time, filteredEEG(1,:));
        title([bandName ' EEG']);
        xlabel('Time (s)');
        ylabel('Amplitude');
        grid on;

        % Store decomposed data in the struct
        selectedPatient.([bandName 'EEG']) = filteredEEG;
    end
    
end

