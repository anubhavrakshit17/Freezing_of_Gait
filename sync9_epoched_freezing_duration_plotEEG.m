clc
clear
close all
load("overall_data.mat");
fs = overall_data{1, 1}.EEGsampling_rate;

time_axis = overall_data{1, 1}.EEG_time;
eeg = overall_data{1, 1}.EEG_data(15,:);

% Extract timestamps of 'Freezing_turn'
event_data = overall_data{1, 1}.Events;
Eventname = 'Freezing_turn';
freezing_indices = strcmp({event_data.type},Eventname);
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
    epoch_data = eeg(start_index:end_index);
    epochs{i} = epoch_data;
end
time_steps = linspace(-epoch_duration, epoch_duration, length(epoch_data));
%%
% Plot the stored epochs with freezing duration areas
figure;

for i = 1:length(epochs)
    epoch_data = epochs{i};
    time_steps = linspace(-epoch_duration, epoch_duration, length(epoch_data));
    
    subplot(length(epochs), 1, i);
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
end

hold off;
%%
% Convert the cell array to a 3D matrix
numTrials = length(epochs);
numSamples = length(epochs{1}); % Assuming all trials have the same number of samples

% Initialize the epoch data matrix
%epochData = zeros(1, numSamples, numTrials);
eval([Eventname '_epochData'] + " = zeros(1, numSamples, numTrials);");
% Fill the epoch data matrix with the data from each trial
for trial = 1:numTrials
%    epochData(1, :, trial) = epochs{trial};
eval([Eventname '_epochData(1, :, trial) = epochs{trial};']);
end
