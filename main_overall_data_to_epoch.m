clc
clear
close all
load("overall_data.mat");
pn = 1; % patient_number
% Take modality as input (1 for EEG, 2 for LFP left, 3 for LFP right)
modality = input('Enter modality (1 for EEG, 2 for LFP left, 3 for LFP right): ');

% pn is assumed to be defined somewhere before this point
% overall_data is assumed to be a cell array containing the data

if modality == 1
    data = overall_data{1, pn}.EEG_data;
elseif modality == 2
    data = overall_data{1, pn}.lfp_l;
elseif modality == 3
    data = overall_data{1, pn}.lfp_r;
else
    error('Invalid modality input. Please enter 1, 2, or 3.');
end

fs = overall_data{1, pn}.EEGsampling_rate;
time_axis = overall_data{1, pn}.EEG_time;

%%
% Extract timestamps of events
event_data = overall_data{1, pn}.Events;
unique_types = unique({event_data.type});
overall_data{1,pn}.unique_types = unique_types;
%%

event_names = {'Freezing_turn', 'Turn','Walk'}; % Add more event names here

for event_idx = 1:length(event_names)
    Eventname = event_names{event_idx};
    event_indices = strcmp({event_data.type}, Eventname);
    event_duration = [event_data(event_indices).duration]/1000;
    event_start = [event_data(event_indices).init_time];

    % Define epoch duration and desired epoch length
    epoch_duration = 15; % in seconds
    desired_epoch_length = fs * (2 * epoch_duration + 1);

    epochs = cell(length(event_start), 1);

    for i = 1:length(event_start)
        event_time = event_start(i);
        start_index = find(time_axis >= event_time - epoch_duration, 1);
        end_index = start_index + desired_epoch_length - 1;

        % Ensure the end index is within bounds
        if end_index > length(time_axis)
            continue;
        end

        % Extract and store the epoch
        epoch_data = data(:,start_index:end_index);
        epochs{i} = epoch_data;
    end
    % Take modality as input (1 for EEG, 2 for LFP left, 3 for LFP right)


% pn is assumed to be defined somewhere before this point
% overall_data is assumed to be a cell array containing the data

if modality == 1
    eval([['epochDataEEG_' Eventname] ' = cat(3, epochs{:});']);
elseif modality == 2
    eval([['epochDataLFPL_' Eventname] ' = cat(3, epochs{:});']);
elseif modality == 3
    eval([['epochDataLFPR_' Eventname] ' = cat(3, epochs{:});']);
else
    error('Invalid modality input. Please enter 1, 2, or 3.');
end

    
end
% Sample data (replace this with your actual data)
%%
