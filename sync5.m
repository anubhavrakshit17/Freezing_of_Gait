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
%%
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
    % User-selected channel index
    selectedChannel = 12;  % Change this to the desired channel index

    % Extract the data for the selected channel
    channelData = eegData(selectedChannel, :);

    % Define frequency ranges for different bands
    bands = {
        'Delta', [0.5, 4];
        'Theta', [4, 8];
        'Alpha', [8, 13];
        'Beta', [13, 30];
        'Gamma', [30, 100];
    };

    % Initialize a figure counter
    figCount = 1;

    % Iterate through different frequency bands
    for bandIndex = 1:size(bands, 1)
        bandName = bands{bandIndex, 1};
        bandRange = bands{bandIndex, 2};

        % Create a filter for the current band
        [b, a] = butter(2, bandRange / (fs / 2), 'bandpass');  % Adjust filter order as needed

        % Frequency response of the filter
        [h, f] = freqz(b, a, 1024, fs);  % Calculate the frequency vector 'f'

        % Apply the filter to the channel data
        filteredData = filtfilt(b, a, channelData);

        % Store decomposed data in the struct
        selectedPatient.([bandName 'EEG']) = filteredData;

        % Plot the raw EEG signal and the filtered wave on a new figure
        figure(figCount);

        subplot(2, 1, 1);
        plot(selectedPatient.EEG_time, channelData);
        hold on;
        plot(selectedPatient.EEG_time, filteredData);
        hold off;
        xlabel('Time (s)');
        ylabel('Amplitude');
        title(['Raw EEG Signal and Filtered ', bandName, ' Wave for Channel ', num2str(selectedChannel)]);
        legend('Raw EEG', ['Filtered ', bandName]);

        subplot(2, 1, 2);
        plot(f, 20*log10(abs(h)));
        xlabel('Frequency (Hz)');
        ylabel('Magnitude (dB)');
        title(['Filter Frequency Response for ', bandName, ' Band']);
        grid on;

        sgtitle(['Raw EEG, ', bandName, ' Wave, and Filter Characteristics for Channel ', num2str(selectedChannel)]);

        % Increment the figure counter
        figCount = figCount + 1;
    end
end
