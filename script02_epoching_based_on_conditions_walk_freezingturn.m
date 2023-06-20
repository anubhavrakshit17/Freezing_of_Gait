clc
clear all
close all
addpath("functions\")
run('fn_addpath')
%%
% EEG = pop_loadset('PD09.set');
%%
% pop_firws() - lowpass filtering data: onepass-zerophase, order 330, hamming-windowed sinc FIR
%   cutoff (-6 dB) 90 Hz
%   transition width 10.0 Hz, passband 0-85.0 Hz, stopband 95.0-500 Hz
%   max. passband deviation 0.0022 (0.22%), stopband attenuation -53 dB
 EEG = pop_loadset('PD09_filtered.set');
%%
[~, name, ~] = fileparts(EEG.filename);
folder = 'datasets';  % Update with your desired folder name

% Create the full path to the file
filename = fullfile(folder, [name '_conditionData.mat']);
filename2 = fullfile(folder, [name '_conditionDataWalk.mat']);
% Step 2: Create event indices for each condition
allEventTypes = {EEG.event.type}; % Get all event types


% Get the event types and durations
eventTypes = {EEG.event.type};
eventDurations = [EEG.event.duration];
eventLatency = [EEG.event.latency];

markerIndices = find(eventDurations == 0);
markerTimes = cell(numel(markerIndices), 2);

for j = 1:numel(markerIndices)
    markerIndex = markerIndices(j);
    markerTime = EEG.event(markerIndex).latency;
    markerTimes{j, 1} = EEG.event(markerIndex).type;
    markerTimes{j, 2} = markerTime/EEG.srate;
end

% Find the indices of events with non-zero durations (conditions)
conditionIndices = find(eventDurations > 0);

% Retrieve the condition types
conditionTypes = eventTypes(conditionIndices);

% Initialize a cell array to store condition start, end times, and marker times
conditionTimes = cell(numel(conditionIndices), 4);

% Extract start, end times, and marker times for each condition
for i = 1:numel(conditionIndices)
    % Get the index of the current condition
    conditionIndex = conditionIndices(i);

    % Retrieve the start time and duration of the condition
    startTime = EEG.event(conditionIndex).init_time;
    duration = EEG.event(conditionIndex).duration;

    % Calculate the end time by adding the duration to the start time
    endTime = startTime + duration/EEG.srate;

    % Store the condition, start time, and end time in the cell array
    conditionTimes{i, 1} = EEG.event(conditionIndex).type;
    conditionTimes{i, 2} = [startTime, endTime];

    % Calculate and store the duration in the cell array
    conditionTimes{i, 3} = endTime - startTime;

    % Find the marker times and types within the condition's duration
    markerTimesWithinCondition = [];
    markerTypesWithinCondition = {};

    for j = 1:size(markerTimes, 1)
        markerType = markerTimes{j, 1};
        markerTime = markerTimes{j, 2};
        if markerTime >= startTime && markerTime <= endTime
            markerTimesWithinCondition = [markerTimesWithinCondition; markerTime];
            markerTypesWithinCondition = [markerTypesWithinCondition; markerType];
        end
    end

    % Store the marker types and times within the condition's duration in the cell array
    conditionTimes{i, 4} = [markerTypesWithinCondition, num2cell(markerTimesWithinCondition)];
    
end

% Convert conditionTimes to a structure
conditionData = struct('Condition', {}, 'StartTime', [], 'EndTime', [], 'Duration', [], 'MarkerTypes', {}, 'MarkerTimes', {});
combinedMarkerData = cell(size(conditionTimes, 1), 1);
% Loop over each condition
for i = 1:size(conditionTimes, 1)
    condition = conditionTimes{i, 1};
    startTime = conditionTimes{i, 2}(1);
    endTime = conditionTimes{i, 2}(2);
    duration = conditionTimes{i, 3};

    % Find the indices of data within the condition's range
    conditionIndices = find(EEG.times >= startTime & EEG.times <= endTime);

    % Extract the data and corresponding times within the condition's range
    conditionData(i).Condition = condition;
    conditionData(i).StartTime = startTime;
    conditionData(i).EndTime = endTime;
    conditionData(i).Duration = duration;
    conditionData(i).MarkerTypes = conditionTimes{i, 4}(:, 1);
    conditionData(i).MarkerTimes = conditionTimes{i, 4}(:, 2);
    conditionData(i).Data = EEG.data(:, conditionIndices);
    conditionData(i).Times = EEG.times(conditionIndices);
    combinedMarkerData{i} = [conditionData(i).MarkerTypes, conditionData(i).MarkerTimes];
end

% Display the condition data structure
disp(conditionData);

% Save the variable conditionData with the specified filename
save(filename, 'conditionData');
%% Statistics of the conditionData

% Assuming the input struct array is named conditionData
uniqueConditions = unique({conditionData.Condition});
conditionCounts = zeros(1, numel(uniqueConditions));
% Iterate through each unique condition
for i = 1:numel(uniqueConditions)
    % Get the current condition name
    currentCondition = uniqueConditions{i};
    
    % Create a new variable name based on the condition name
    newVariableName = ['conditionData', currentCondition];
    
    % Find the indices of elements with the current condition
    conditionIndices = strcmp({conditionData.Condition}, currentCondition);
    
    % Create a new struct variable for the current condition
    eval([newVariableName, ' = conditionData(conditionIndices);']);
    
    % Add the 'Event' field and assign the appropriate value
    currentConditionData = eval(newVariableName);
    occurrenceCount = numel(currentConditionData);
    for j = 1:occurrenceCount
        currentConditionData(j).Event = [currentCondition, num2str(j)];
        
        % Calculate the number of markers for the current condition
        markerTypes = currentConditionData(j).MarkerTypes;
        numMarkers = numel(markerTypes);
        
        % Add the 'Markers' field and assign the number of markers
        currentConditionData(j).Markers = numMarkers;
    end
    
    % Calculate the mean duration
    durations = [currentConditionData.Duration];
    meanDuration = mean(durations);
    
    % Update the variable struct with the modified data
    eval([newVariableName, ' = currentConditionData;']);
    
    % Create a figure for the current condition
    figure;
    
    % Plot the bar chart
    durations = [currentConditionData.Duration];
    bar(durations);
    hold on;
    
    % Plot the mean horizontal line
    numEvents = numel(durations);
    xLimits = xlim;
    line(xLimits, [meanDuration, meanDuration], 'Color', 'r', 'LineWidth', 2,'LineStyle','--');
    
    % Add labels and title
    xlabel('Event');
    ylabel('Duration');
    title(currentCondition);
    
    % Add mean value text in red
    text(numEvents, meanDuration+1, sprintf('Mean: %.2f', meanDuration), 'Color', 'r');
    
    % Adjust the figure's appearance
    set(gca, 'XTick', 1:numEvents, 'XTickLabel', {currentConditionData.Event});
    xtickangle(45);
    
    % Hold off for the next figure
    hold off;
    conditionCounts(i) = numel(eval(newVariableName));
end


% Create a bar chart
figure
bar(conditionCounts)

% Customize the bar chart
xlabel('Conditions')
ylabel('Count')
title('Count of Unique Conditions')
xticks(1:numel(uniqueConditions))
xticklabels(uniqueConditions)
ylim([0 max(conditionCounts) + 5])  % Adjust the y-axis limits to allow some space above the bars
grid on  % Add a grid for better visualization
save(filename2,'conditionDataWalk');

