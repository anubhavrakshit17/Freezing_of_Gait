% Define x-axis limits in seconds
x_lim = [-pre_stim_dur post_stim_dur];

% Define x-axis tick values and labels
x_ticks = -pre_stim_dur:0.25:post_stim_dur;
x_tick_labels = arrayfun(@(x) sprintf('%d', x), x_ticks*1000, 'UniformOutput', false);

% Calculate time axis
t = linspace(x_lim(1), x_lim(2), size(epochs, 2));

% Define the current epoch
curr_epoch = 1;

% Create the figure
fig = figure;
set(fig, 'Position', [100 100 800 600]);

% Create the plot
ax = axes('Parent', fig, 'Position', [0.1 0.2 0.8 0.7]);
p = plot(t, epochs(:, :, curr_epoch), 'LineWidth', 2);

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

