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

% % Display PLV values for each band combination
% disp("PLV values between data1 and data2:");
% disp(plv_accumulator_12);
% 
% disp("PLV values between data1 and data3:");
% disp(plv_accumulator_13);
% 
% disp("PLV values between data2 and data3:");
% disp(plv_accumulator_23);

%%
% Define frequency bands and modalities
frequencyBands = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
modalities = {'EEG', 'LFPL', 'LFPR'};

events = {'Freezing Turn', 'Turning', 'Walking'};

% Create a matrix for each combination
combinationMatrices = {plv_accumulator_12, plv_accumulator_13, plv_accumulator_23};

% Iterate over each event
for eventIndex = 1:length(events)
    % Create a new figure for the current event
    figure;
    
    % Iterate over each combination matrix
    for combinationIndex = 1:length(combinationMatrices)
        combinationMatrix = combinationMatrices{combinationIndex};
        
        % Create a new subplot for each combination matrix
        subplot(1, length(modalities), combinationIndex);
        
        % Create a heatmap to visualize the matrix
        imagesc(combinationMatrix);
        
        % Set colormap to a built-in colormap (e.g., 'jet', 'parula', 'cool')
        colormap('jet');
        
        % Set labels for frequency bands and modalities
        xticks(1:length(frequencyBands));
        yticks(1:length(frequencyBands));
        xticklabels(frequencyBands);
        yticklabels(frequencyBands);
        
        % Get the modalities for this subplot
     
        if combinationIndex==1
            modality1 = modalities{1,1};
            modality2 = modalities{1,2};
        elseif combinationIndex==2
            modality1 = modalities{1,1};
            modality2 = modalities{1,3};
        elseif combinationIndex==3
            modality1 = modalities{1,2};
            modality2 = modalities{1,3};
        end
        % Set custom labels with modalities
        xlabel(modality1);
        ylabel(modality2);

        title([modality1, ' vs ', modality2]);

        % Add colorbar
        colorbar;
        
        % Set aspect ratio to make the subplot square
        axis square;
    end
    
    % Add title for the entire figure based on the event
    sgtitle(['Event: ', events{eventIndex}]);
end
