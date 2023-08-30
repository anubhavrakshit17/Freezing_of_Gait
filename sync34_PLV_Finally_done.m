clc
clear all
close all
load("band_data.mat");
%%
data1 = band_data.Freezing_turn_EEG;
data2 = band_data.Freezing_turn_LFPL;
data3 = band_data.Freezing_turn_LFPR;

num_epochs = size(data1, 3);
selected_channel = 1;

% Initialize PLV accumulators for different combinations
plv_accumulator_12 = zeros(size(data1, 4), size(data2, 4));
plv_accumulator_13 = zeros(size(data1, 4), size(data3, 4));
plv_accumulator_23 = zeros(size(data2, 4), size(data3, 4));

% Iterate over all band combinations for data1 and data2
for i = 1:size(data1, 4)
    for j = 1:size(data2, 4)
        % Accumulate phase differences for the current band combination
        phase_diff_accumulator = zeros(1, num_epochs);
        
        % Calculate the phase differences for the current band combination
        for k = 1:num_epochs
            plv = compute_PLV(data1(selected_channel, :, k, i), data2(1, :, k, j));
            phase_diff_accumulator(k) = plv;
        end
        
        % Calculate the average PLV for the current band combination
        plv_avg = mean(phase_diff_accumulator);
        
        % Store the average PLV value for this band combination
        plv_accumulator_12(i, j) = plv_avg;
    end
end

% Iterate over all band combinations for data1 and data3
for i = 1:size(data1, 4)
    for j = 1:size(data3, 4)
        % Accumulate phase differences for the current band combination
        phase_diff_accumulator = zeros(1, num_epochs);
        
        % Calculate the phase differences for the current band combination
        for k = 1:num_epochs
            plv = compute_PLV(data1(selected_channel, :, k, i), data3(1, :, k, j));
            phase_diff_accumulator(k) = plv;
        end
        
        % Calculate the average PLV for the current band combination
        plv_avg = mean(phase_diff_accumulator);
        
        % Store the average PLV value for this band combination
        plv_accumulator_13(i, j) = plv_avg;
    end
end

% Iterate over all band combinations for data2 and data3
for i = 1:size(data2, 4)
    for j = 1:size(data3, 4)
        % Accumulate phase differences for the current band combination
        phase_diff_accumulator = zeros(1, num_epochs);
        
        % Calculate the phase differences for the current band combination
        for k = 1:num_epochs
            plv = compute_PLV(data2(selected_channel, :, k, i), data3(1, :, k, j));
            phase_diff_accumulator(k) = plv;
        end
        
        % Calculate the average PLV for the current band combination
        plv_avg = mean(phase_diff_accumulator);
        
        % Store the average PLV value for this band combination
        plv_accumulator_23(i, j) = plv_avg;
    end
end

% Display PLV values for each band combination
disp("PLV values between data1 and data2:");
disp(plv_accumulator_12);

disp("PLV values between data1 and data3:");
disp(plv_accumulator_13);

disp("PLV values between data2 and data3:");
disp(plv_accumulator_23);
