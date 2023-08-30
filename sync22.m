clc
clear
close all
load("overall_data.mat");
pn = 1; % patient_number

% Define event names
event_names = {'Freezing_turn', 'Turn', 'Walk'}; % Add more event names here

% Define modality names
modality_names = {'EEG', 'LFPL', 'LFPR'};

% Loop through all modalities
for modality = 1:length(modality_names)
    modality_name = modality_names{modality};
    
    if modality == 1
        data = overall_data{1, pn}.EEG_data;
    elseif modality == 2
        data = overall_data{1, pn}.lfp_l;
    elseif modality == 3
        data = overall_data{1, pn}.lfp_r;
    else
        error('Invalid modality.');
    end

    fs = overall_data{1, pn}.EEGsampling_rate;
    time_axis = overall_data{1, pn}.EEG_time;

    % Extract timestamps of events
    event_data = overall_data{1, pn}.Events;

    for event_idx = 1:length(event_names)
        Eventname = event_names{event_idx};
        event_indices = strcmp({event_data.type}, Eventname);
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

        % Store epoch data with descriptive variable names
        eval(['epochData_' modality_name '_' Eventname ' = cat(3, epochs{:});']);
        
    end
end
