clc
clear
close all
load("band_data.mat");
load("time_steps_epoch.mat");

%%
% Define frequency bands and modalities
frequencyBands = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
modalities = {'EEG', 'LFPL', 'LFPR'};
events = {'Freezing Turn', 'Turn', 'Walking'};

%%
eventIndex = 1;
selected_EEG_channel = 40;
%%

disp('Enter ROI:');
timeRanges = {
    'between -15s to -10s';
    'between -10s to -5s';
    'between -5s to 0s';
    'between 0s to 5s';
    'between 5s to 10s';
    'between 10s to 15s';
};
for i = 1:length(timeRanges)
    disp([num2str(i), ' for sample Data ', timeRanges{i}]);
end

% Create if-else loop to map ROI to ROI1 and ROI2

%%
% Create a VideoWriter object to save the movie
videoFilename = 'output_movie.mp4';
videoObj = VideoWriter(videoFilename, 'MPEG-4');
videoObj.FrameRate = 1;  % Set the frame rate (1 frame per second)
open(videoObj);
% Iterate over all ROIs
for ROI = 1:length(timeRanges)
    ROI1 = ROI;
    ROI2 = ROI + 1;
%%
if eventIndex==1
data1 = band_data.Freezing_turn_EEG;
data2 = band_data.Freezing_turn_LFPL;
data3 = band_data.Freezing_turn_LFPR;

elseif eventIndex==2
data1 = band_data.Turn_EEG;
data2 = band_data.Turn_LFPL;
data3 = band_data.Turn_LFPR;

elseif eventIndex==3
data1 = band_data.Walk_EEG;
data2 = band_data.Walk_LFPL;
data3 = band_data.Walk_LFPR;
end
%% Choosing the sample Data range
total_samples = size(data1,2);
sampling_rate = 1000;
total_duration = (total_samples/sampling_rate)-1;
samples_per_second = total_samples / total_duration;
central_point = total_duration / 2;
offsets = [-15, -10, -5, 0, 5, 10, 15];

sample_numbers = zeros(1, length(offsets));
for i = 1:length(offsets)
    sample_number = round(samples_per_second * (central_point + offsets(i))) + 1;
    sample_numbers(i) = min(max(sample_number, 1), total_samples);
end

disp(sample_numbers);

%%
sampledata_range1= sample_numbers(ROI1)
sampledata_range2= sample_numbers(ROI2)
num_epochs = size(data1, 3);
%%
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
            plv = compute_PLV(data1(selected_EEG_channel, sampledata_range1:sampledata_range2, k, i), data2(1, sampledata_range1:sampledata_range2, k, j));
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
            plv = compute_PLV(data1(selected_EEG_channel, sampledata_range1:sampledata_range2, k, i), data3(1, sampledata_range1:sampledata_range2, k, j));
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
            plv = compute_PLV(data2(1, sampledata_range1:sampledata_range2, k, i), data3(1, sampledata_range1:sampledata_range2, k, j));
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

% Normalize the PLV matrices for visualization
plv_accumulator_12_normalized = (plv_accumulator_12 - min(plv_accumulator_12(:))) / (max(plv_accumulator_12(:)) - min(plv_accumulator_12(:))) * 2 - 1;
plv_accumulator_13_normalized = (plv_accumulator_13 - min(plv_accumulator_13(:))) / (max(plv_accumulator_13(:)) - min(plv_accumulator_13(:))) * 2 - 1;
plv_accumulator_23_normalized = (plv_accumulator_23 - min(plv_accumulator_23(:))) / (max(plv_accumulator_23(:)) - min(plv_accumulator_23(:))) * 2 - 1;

% Calculate the Z-score normalized values
% plv_accumulator_12_normalized = (plv_accumulator_12 - mean(plv_accumulator_12(:))) / std(plv_accumulator_12(:));
% plv_accumulator_13_normalized = (plv_accumulator_13 - mean(plv_accumulator_13(:))) / std(plv_accumulator_13(:));
% plv_accumulator_23_normalized = (plv_accumulator_23 - mean(plv_accumulator_23(:))) / std(plv_accumulator_23(:));

% Create a matrix for each normalized combination
normalized_combinationMatrices = {plv_accumulator_12_normalized, plv_accumulator_13_normalized, plv_accumulator_23_normalized};


% Create a matrix for each combination
 %combinationMatrices = {plv_accumulator_12, plv_accumulator_13, plv_accumulator_23};

% Iterate over each event

    % Create a new figure for the current event
    fig = figure; 
    % Iterate over each combination matrix
    for combinationIndex = 1:length(normalized_combinationMatrices)
        combinationMatrix = normalized_combinationMatrices{combinationIndex};
        
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
            modality1_with_channel = [modality1 ' Channel: ' num2str(selected_EEG_channel)];
            modality2 = modalities{1,2};
            xlabel(modality1_with_channel);
            ylabel(modality2);
            title([modality1, ' vs ', modality2]);
        elseif combinationIndex==2
            modality1 = modalities{1,1};
            modality1_with_channel = [modality1 ' Channel: ' num2str(selected_EEG_channel)];            modality2 = modalities{1,3};
            xlabel(modality1_with_channel);
            ylabel(modality2);
            title([modality1, ' vs ', modality2]);
        elseif combinationIndex==3
            modality1 = modalities{1,2};
            modality2 = modalities{1,3};
            xlabel(modality1);
            ylabel(modality2);
            title([modality1, ' vs ', modality2]);
        end
        % Set custom labels with modalities
        

        % Add colorbar
        colorbar;
        
        % Set aspect ratio to make the subplot square
        axis square;
if eventIndex==1
    sgtitle(['Event: ', events(1), timeRanges{ROI}])
elseif eventIndex==2
    sgtitle(['Event: ', events(2), timeRanges{ROI}])
elseif eventIndex==3
    sgtitle(['Event: ', events(3),  timeRanges{ROI}])
end
    end
  % Write the current figure to the video
    frame = getframe(fig);
    writeVideo(videoObj, frame);

    % Close the figure
    close(fig);
end
close(videoObj);

disp(['Movie saved as ', videoFilename]);
