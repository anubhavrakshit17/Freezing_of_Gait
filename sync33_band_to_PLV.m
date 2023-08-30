
% Assuming the data dimensions are (channels, sampleData, epochs, bands)
% num_channels = size(band_data.Freezing_turn_EEG, 1);
data1= band_data.Freezing_turn_EEG;
data2=band_data.Freezing_turn_LFPL;

num_epochs = size(data1, 3);
selected_channel = 1;

% Initialize PLV accumulator for the current band combination
plv_accumulator = zeros(1, num_epochs);

% Iterate over all band combinations
for i = 1:size(data1,4)
    for j = 1:size(data2,4)
        % Accumulate phase differences for the current band combination
        phase_diff_accumulator = zeros(1, num_epochs);
        
        % Calculate the phase differences for the current band combination
        for k = 1:num_epochs
            plv(k) = compute_PLV(data1(selected_channel, :, k, i), data2(1, :, k, j));
        end
        
        % Calculate the PLV for the current band combination
        plv_avg = mean(plv); % Calculate PLV from accumulated phase differences
        
        % Store the PLV value for this band combination
        plv_accumulator(i, j) = plv_avg;
    end
end

% Now you have the plv_accumulator matrix containing PLV values for each band combination
disp("PLV values for each band combination:");
disp(plv_accumulator);
%%