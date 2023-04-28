% Load the EEG data into a variable called eeg_data
% Load the heelstrike timepoints into a variable called hs_rf
eeg_data = EEG_signal;
% Define the sampling frequency
fs = 1000;  % Hz
%%
% Assume eeg_data is a 58xN matrix containing the EEG data
% Assume fs is the sampling frequency in Hz
% Assume hs_rf is a 1x179 array containing the heelstrike timepoints


% Define pre-stimulus and post-stimulus durations in seconds
pre_stim_dur = 0.5; % 500 ms
post_stim_dur = 0.5; % 500 ms

% Define epoch length in seconds
epoch_length = pre_stim_dur+post_stim_dur; % 1 second total (pre- and post-stimulus combined)

% Convert epoch length to samples
epoch_samples = round(epoch_length * fs);

% Convert pre- and post-stimulus durations to samples
pre_stim_samples = round(pre_stim_dur * fs);
post_stim_samples = round(post_stim_dur * fs);

% Preallocate array to store epochs
epochs = zeros(size(eeg_data, 1), epoch_samples, length(hs_rf));

%%
% Loop through heelstrike timepoints and extract epochs
for i = 1:length(hs_rf)
    event_sample = round(hs_rf(i) * fs); % Convert event time to sample
    start_sample = event_sample - pre_stim_samples;
    end_sample = event_sample + post_stim_samples - 1;
    epochs(:,:,i) = eeg_data(:, start_sample:end_sample);
end
%%
% Define x-axis limits in seconds
x_lim = [-pre_stim_dur post_stim_dur];

% Define x-axis tick values and labels
x_ticks = -pre_stim_dur:0.25:post_stim_dur;
x_tick_labels = arrayfun(@(x) sprintf('%d', x), x_ticks*1000, 'UniformOutput', false);

% Calculate time axis
t = linspace(x_lim(1), x_lim(2), size(epochs, 2));

% Create figure
figure;
set(gcf, 'Position', [100 100 800 600]);

% Plot the first epoch
curr_epoch = 1;
curr_chan = 1:5;
plot(t, epochs(curr_chan,:,curr_epoch),'LineWidth', 1.5);

% Add a red dotted line at stimulus onset
hold on;
stim_line = plot([0 0], ylim, 'r--', 'LineWidth', 1.5);

% Add axis labels and title
xlabel('Time (ms)');
ylabel('Amplitude');
title(sprintf('Epoch %d', curr_epoch));

% Set x-axis limits and tick marks
xlim(x_lim);
xticks(x_ticks);
xticklabels(x_tick_labels);