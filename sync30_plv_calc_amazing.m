clc
clear all
close all

load("overall_data_bands.mat");
%%
events = {'FT', 'T', 'W'};
modalities = {'EEG', 'LFPL', 'LFPR'};
frequency_bands = {'alpha', 'beta', 'theta', 'delta', 'gamma'};

combinations = {};

% Generate all combinations
for i = 1:length(events)
    for j = 1:length(modalities)
        for k = 1:length(frequency_bands)
            for l = 1:length(modalities)
                for m = 1:length(frequency_bands)
                    combination = sprintf('%s_%s_%s_%s_%s', events{i}, modalities{j}, frequency_bands{k}, modalities{l}, frequency_bands{m});
                    combinations{end+1} = combination;
                end
            end
        end
    end
end

Intramodality_list = {};
Intermodality_list = {};
Intramodality_list_same_band45 = {};

% Classify combinations and extract relevant ones
for i = 1:length(combinations)
    parts = strsplit(combinations{i}, '_');
    
    if strcmp(parts{2}, parts{4}) % Intramodality
        Intramodality_list{end+1} = combinations{i};
        
        if strcmp(parts{3}, parts{5}) % Intramodality same band
            Intramodality_list_same_band45{end+1} = combinations{i};
        end
    else % Intermodality
        Intermodality_list{end+1} = combinations{i};
    end
end

% Display the results
disp('Intramodality Combinations:');
disp(Intramodality_list');

fprintf('\n');

disp('Intermodality Combinations:');
disp(Intermodality_list');

fprintf('\n');

disp('Intramodality Combinations same band:');
disp(Intramodality_list_same_band45');

%Intramodality_list= Intramodality_list(224)
%%
% Ask the user for the EEG channel they want to analyze
selected_channel = input('Enter the EEG channel number to analyze: ');

intramodality_plv_results = cell(1, length(Intramodality_list));

for i = 1:length(Intramodality_list)
    % ... (parse element information as before)
    % Parse element information
    parts = strsplit(Intramodality_list{i}, '_');
    event_name = parts{1};
    modality = parts{2};
    band1 = parts{3};
    band2 = parts{5};
    
    % Translate event name to its corresponding field name
    if strcmp(event_name, 'FT')
        event_field_name = 'Freezing_turn';
    elseif strcmp(event_name, 'T')
        event_field_name = 'Turn';
    elseif strcmp(event_name, 'W')
        event_field_name = 'Walk';
    else
        error('Invalid event name.');
    end
    
    % Get band data for the corresponding event and modality
    band_data_event_modality = overall_data_bands{1, 1}.(['epochData_bands_' modality '_' event_field_name]);
    
    % Find the indices for the specified bands
    band_idx1 = find(strcmp(frequency_bands, band1));
    band_idx2 = find(strcmp(frequency_bands, band2));
    
    % Extract EEG data for the selected channel
    if strcmp(modality, 'EEG')
    band_data1_channel = band_data_event_modality(selected_channel, :, :, band_idx1);
    band_data2_channel = band_data_event_modality(selected_channel, :, :, band_idx2);

    elseif strcmp(modality, 'LFPL')
    band_data1_channel = band_data_event_modality(1, :, :, band_idx1);
    band_data2_channel = band_data_event_modality(1, :, :, band_idx2); 
    elseif strcmp(modality, 'LFPR')
    band_data1_channel = band_data_event_modality(1, :, :, band_idx1);
    band_data2_channel = band_data_event_modality(1, :, :, band_idx2); 
    end
    % Calculate PLV for each epoch
    num_epochs = size(band_data_event_modality, 3);
    plv_results = zeros(1, num_epochs);
    
    % for epoch_idx = 1:num_epochs
    %     band_data1 = squeeze(band_data1_channel(:, epoch_idx));
    %     band_data2 = squeeze(band_data2_channel(:, epoch_idx));
    % 
    %     % Calculate PLV
    %     plv = compute_PLV(band_data1, band_data2);
    %     plv_results(epoch_idx) = plv;
    % end
    % 
    for epoch_idx = 1:num_epochs
    epoch_data1 = band_data1_channel(1,:,epoch_idx, :);
    epoch_data2 = band_data2_channel(1,:,epoch_idx, :);
    
    % Calculate PLV for this epoch
    plv = compute_PLV(epoch_data1, epoch_data2);
    plv_results(epoch_idx) = plv;
    end

    % Store PLV results for this combination
    intramodality_plv_results{i} = plv_results;
end
%%
intramodality_plv_avg = {};

for i = 1:length(intramodality_plv_results)
    plv_values = intramodality_plv_results{i};
    num_values = numel(plv_values);
    
    % Calculate the average PLV for this combination
    avg_plv = sum(plv_values) / num_values;
    
    % Store the average PLV in the result cell array
    intramodality_plv_avg{i} = avg_plv;
end

% Convert the cell array to a double array
intramodality_plv_avg = cellfun(@(x) x, intramodality_plv_avg);
%%
combined_data = {};

for i = 1:length(Intramodality_list)
    event_modality = Intramodality_list{i};
    avg_plv = intramodality_plv_avg(i);
    
    combined_entry = {event_modality, avg_plv};
    combined_data{i} = combined_entry;
end
%%
combined_data = cell(length(Intramodality_list), 2);

for i = 1:length(Intramodality_list)
    event_modality = Intramodality_list{i};
    avg_plv = intramodality_plv_avg(i);
    
    combined_data{i, 1} = event_modality;
    combined_data{i, 2} = avg_plv;
end

%%
% Now you have the PLV results for each element in intramodality_plv_results
function plv = compute_PLV(signal1, signal2)
    % Calculate the phase differences between the signals
    phase_diff = angle(signal1) - angle(signal2);
    
    % Calculate the complex exponential of the phase differences
    complex_exponential = exp(1i * phase_diff);
    
    % Calculate the mean of the complex exponential
    mean_complex_exponential = mean(complex_exponential);
    
    % Calculate the PLV
    plv = abs(mean_complex_exponential);
end
%%
