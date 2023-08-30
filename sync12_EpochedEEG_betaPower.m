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

% Define epoch duration and desired epoch length
epoch_duration = 15; % in seconds
desired_epoch_length = fs * (2 * epoch_duration + 1);

beta_band = [13, 30]; % Define the beta frequency band (in Hz)

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
    
    % Calculate beta power for sliding windows
    window_size = 1; % in seconds
    window_samples = round(window_size * fs);
    num_windows = length(epoch_data) - window_samples + 1;
    beta_power = zeros(1, num_windows);
    
    for j = 1:num_windows
        window_data = epoch_data(j:j+window_samples-1);
        beta_power(j) = bandpower(window_data, fs, beta_band);
    end
    %%
    % Plot the epoch with freezing duration area and beta power
    figure;
    
    % Subplot 1: Time series data
    subplot(2, 1, 1);
    time_steps = linspace(-epoch_duration, epoch_duration, length(epoch_data));
    plot(time_steps, epoch_data);
    hold on;
    
    % Plot the freezing duration area
    area_x = [0, freezing_duration(i), freezing_duration(i), 0];
    area_y = [min(epoch_data), min(epoch_data), max(epoch_data), max(epoch_data)];
    fill(area_x, area_y, 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    
    line([0, 0], get(gca, 'YLim'), 'Color', 'k', 'LineStyle', '--');
    title(['Epoch around Freezing Start: ', num2str(freezing_start(i))]);
    xlabel('Time (seconds)');
    ylabel('Amplitude');
    legend('Epoch', 'Freezing Duration', 'Freezing Start');
    hold off;
    
    % Subplot 2: Beta power
    subplot(2, 1, 2);
    time_steps_beta = linspace(-epoch_duration + window_size/2, epoch_duration - window_size/2, num_windows);
    plot(time_steps_beta, beta_power);
    area_x = [0, freezing_duration(i), freezing_duration(i), 0];
    area_y = [min(epoch_data), min(epoch_data), max(epoch_data), max(epoch_data)];
    line([0, 0], get(gca, 'YLim'), 'Color', 'k', 'LineStyle', '--');

    title('Beta Power');
    xlabel('Time (seconds)');
    ylabel('Power');
end
