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

% Get user input for frequency range
lower_freq = input('Enter the lower frequency limit: ');
upper_freq = input('Enter the upper frequency limit: ');

% Initialize cell array to store epoch data
epochs = cell(length(freezing_start), 1);

% Initialize variables for accumulating S values
total_spectrogram = 0;

% Initialize figure for plotting
figure;

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
    [S, F, T] = spectrogram(epoch_data, hamming(256), 128, 512, fs);
    
    % Store epoch data in the cell array
    epochs{i} = struct('data', epoch_data, 'S', S, 'F', F, 'T', T);
    
    % Accumulate S values for average spectrogram
    total_spectrogram = total_spectrogram + S;
    desired_freq_start_index = find(F >= lower_freq, 1);
    desired_freq_end_index = find(F <= upper_freq, 1, 'last');
    % Plotting
    time_steps = linspace(-epoch_duration, epoch_duration, length(epoch_data));
    
       % Plot spectrogram on the left side
    subplot(length(epochs), 2, 2 * i - 1);
    imagesc(linspace(-epoch_duration, epoch_duration, size(S, 2)), ...
        F(desired_freq_start_index:desired_freq_end_index), ...
        10*log10(abs(S(desired_freq_start_index:desired_freq_end_index, :))));
    colormap(jet);
    axis xy;
    hold on;
    plot([freezing_start(i), freezing_start(i)], [0, 100], 'r:', 'LineWidth', 1.5); % Freezing start marker
    
    % Calculate frequency indices within the desired range
    freezing_freq_start_index = find(F >= desired_freq_start_index, 1);
    freezing_freq_end_index = find(F <= desired_freq_end_index, 1, 'last');
    
    % Calculate rectangle position based on frequency indices
    rectangle_y = F(freezing_freq_start_index);
    rectangle_height = F(freezing_freq_end_index) - F(freezing_freq_start_index);
    
    % Plot the freezing duration area
    rectangle('Position', [freezing_start(i) - freezing_duration(i), ...
        rectangle_y, 2 * freezing_duration(i), rectangle_height], ...
        'FaceColor', [1, 0, 0, 0.3], 'EdgeColor', 'none');
    
    hold off;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Spectrogram');
    hold off;
    
    % Plot the epoch on the right side
    subplot(length(epochs), 2, 2 * i);
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
end

% Calculate the average S matrix
average_spectrogram = total_spectrogram / length(epochs);
%%
% Plot the average spectrogram
figure;
% imagesc(linspace(-epoch_duration, epoch_duration, size(S, 2)), ...
%         F(desired_freq_start_index:desired_freq_end_index), ...
%         10*log10(abs(S(desired_freq_start_index:desired_freq_end_index, :))));
% imagesc(epochs{1}.T, epochs{1}.F, 10*log10(abs(average_spectrogram)));
imagesc(epochs{1}.T, epochs{1}.F(desired_freq_start_index:desired_freq_end_index), ...
    10*log10(abs(average_spectrogram(desired_freq_start_index:desired_freq_end_index, :))));
colormap(jet);

axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Average Spectrogram');
colorbar;
