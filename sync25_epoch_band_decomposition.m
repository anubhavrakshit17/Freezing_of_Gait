clc
clear
close all
load("overall_data.mat");

% Define patient numbers
patient_numbers = 1;

% Define event names
event_names = {'Freezing_turn', 'Turn', 'Walk'}; % Add more event names here

% Define modality names
modality_names = {'EEG', 'LFPL', 'LFPR'};

for pn = patient_numbers
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
                epoch_data = data(:, start_index:end_index);
                epochs{i} = epoch_data;
            end

            % Store epoch data with descriptive variable names
            epoch_data_variable_name = ['epochData_' modality_name '_' Eventname];
            eval([epoch_data_variable_name ' = cat(3, epochs{:});']);

            % Calculate and store the averaged epoch data
            avg_epoch_data_variable_name = ['epochData_Avg_' modality_name '_' Eventname];
            avg_epoch_data = mean(eval(epoch_data_variable_name), 3);
            eval([avg_epoch_data_variable_name ' = avg_epoch_data;']);

            % Perform time-frequency analysis
            % TF_variable_name = ['epochData_TF_' modality_name '_' Eventname];
            % TF_data = compute_TF(eval(epoch_data_variable_name), fs);
            % eval([TF_variable_name ' = TF_data;']);

            % Perform band decomposition
            band_variable_name = ['epochData_bands_' modality_name '_' Eventname];
            band_data = fn_band_decomposition(eval(epoch_data_variable_name), fs);
            eval([band_variable_name ' = band_data;']);

            % Append epoch data to overall_data
            eval(['overall_data{1, pn}.' epoch_data_variable_name ' = ' epoch_data_variable_name ';']);
            eval(['overall_data{1, pn}.' avg_epoch_data_variable_name ' = ' avg_epoch_data_variable_name ';']);
            %eval(['overall_data{1, pn}.' TF_variable_name ' = ' TF_variable_name ';']);
            eval(['overall_data{1, pn}.' band_variable_name ' = ' band_variable_name ';']);
        end
    end
end
%%
% Save the modified overall_data
save('overall_data_modified.mat', 'overall_data');
%%
load("time_steps_epoch.mat")
plot(time_steps,epochData_bands_LFPR_Walk(1,:,1,1))
% (channel,data points, epoch number, band)
% 1.Delta: 1 - 4 Hz
% 2. Theta: 4 - 8 Hz
% 3. Alpha: 8 - 13 Hz
% 4. Beta: 13 - 30 Hz   
% 5. Gamma: 30 - 100 Hz

%%
function band_data = fn_band_decomposition(epoch_data, fs)
    % Define frequency bands
    bands = [1 4; 4 8; 8 13; 13 30; 30 100]; % Define your frequency bands here

    % Get the number of bands
    num_bands = size(bands, 1);

    % Initialize the 4D array to store band data
    [num_channels, num_samples, num_epochs] = size(epoch_data);
    band_data = zeros(num_channels, num_samples, num_epochs, num_bands);

    % Perform band decomposition for each epoch
    for epoch_idx = 1:num_epochs
        epoch = epoch_data(:, :, epoch_idx);

        for band_idx = 1:num_bands
            band_range = bands(band_idx, :);
            band_freq_range = band_range / fs * 2 * pi;
            
            % Perform bandpass filtering
            [b, a] = butter(4, band_freq_range, 'bandpass');
            band_filtered = filtfilt(b, a, epoch')';

            % Store band data in the 4D array
            band_data(:, :, epoch_idx, band_idx) = band_filtered;
        end
    end
end
%%
