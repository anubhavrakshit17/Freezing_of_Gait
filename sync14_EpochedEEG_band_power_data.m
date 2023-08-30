clc
clear
close all
load("overall_data.mat");
fs = overall_data{1, 1}.EEGsampling_rate;

time_axis = overall_data{1, 1}.EEG_time;
eeg = overall_data{1, 1}.EEG_data(15,:);

% Extract timestamps of 'Freezing_turn'
event_data = overall_data{1, 1}.Events;
freezing_indices = strcmp({event_data.type}, 'Freezing_turn');
freezing_duration = [event_data(freezing_indices).duration]/1000;
freezing_start = [event_data(freezing_indices).init_time];
epoch_duration = 15; % in seconds
desired_epoch_length = fs * (2 * epoch_duration + 1);

alpha_band = [8, 13]; % Define the alpha frequency band (in Hz)
beta_band = [13, 30]; % Define the beta frequency band (in Hz)
theta_band = [4, 8];   % Define the theta frequency band (in Hz)


% Initialize a cell array to store the band power data for each epoch
band_power_data = cell(length(freezing_start), 3); % 3 columns for theta, alpha, beta

for i = 1:length(freezing_start)
    freezing_time = freezing_start(i);
    start_index = find(time_axis >= freezing_time - epoch_duration, 1);
    end_index = start_index + desired_epoch_length - 1;
    
    % Ensure the end index is within bounds
    if end_index > length(time_axis)
        continue;
    end
    
    % Extract and store the epoch
    epoch_data = eeg(start_index:end_index);
    
    % Calculate power for sliding windows
    window_size = 1; % in seconds
    window_samples = round(window_size * fs);
    num_windows = length(epoch_data) - window_samples + 1;
    alpha_power = zeros(1, num_windows);
    beta_power = zeros(1, num_windows);
    theta_power = zeros(1, num_windows);
    
    for j = 1:num_windows
        window_data = epoch_data(j:j+window_samples-1);
        alpha_power(j) = bandpower(window_data, fs, alpha_band);
        beta_power(j) = bandpower(window_data, fs, beta_band);
        theta_power(j) = bandpower(window_data, fs, theta_band);
    end
    
    % Store the band power data in the cell array
    band_power_data{i, 1} = theta_power;
    band_power_data{i, 2} = alpha_power;
    band_power_data{i, 3} = beta_power;
end
