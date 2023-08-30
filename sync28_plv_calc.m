
load("overall_data_bands.mat");
%%
Intermodality_list = Intermodality_list(1);
%%
intramodality_plv_results = cell(1, length(Intramodality_list));

for i = 1:length(Intramodality_list)
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
    
    % Initialize variables for EEG channel data
    band_data1_channel = [];
    band_data2_channel = [];
    
    % Check if the modality is 'EEG' to ask for EEG channel
    if strcmp(modality, 'EEG')
        selected_channel = input('Enter the EEG channel number to analyze: ');
        band_data1_channel = band_data_event_modality(selected_channel, :, :, band_idx1);
        band_data2_channel = band_data_event_modality(selected_channel, :, :, band_idx2);
    else
        % For other modalities, use all channels
        band_data1_channel = band_data_event_modality(:, :, :, band_idx1);
        band_data2_channel = band_data_event_modality(:, :, :, band_idx2);
    end
    
    % Calculate PLV for each epoch
    num_epochs = size(band_data_event_modality, 3);
    plv_results = zeros(1, num_epochs);
    
    for epoch_idx = 1:num_epochs
        band_data1 = squeeze(band_data1_channel(:, epoch_idx));
        band_data2 = squeeze(band_data2_channel(:, epoch_idx));
        
        % Calculate PLV
        plv = compute_PLV(band_data1, band_data2);
        plv_results(epoch_idx) = plv;
    end
    
    % Store PLV results for this combination
    intramodality_plv_results{i} = plv_results;
end
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

