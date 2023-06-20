clc
clear all
close all
load("datasets\PD09_filtered_conditionData.mat")
%%
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
    EventCount = numel(currentConditionData);
    for j = 1:EventCount
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
end

%% Display the specific conditionData
% Define the Event you want to plot
 Event = 'Selected_stop2';  % Replace with the specific Event you want to plot
% 
% % Extract the condition name from the Event
 % conditionName = Event(1:end-1); % Cannot handle Walk10 etc
  conditionName = regexprep(Event, '[0-9]', ''); % CAN HANDLE
% Create the variable name for the condition data struct
variableName = ['conditionData', conditionName];
%%
% Retrieve the data for the specific Event from the condition data struct
data = eval([variableName, '(strcmp({', variableName, '.Event}, Event)).Data']);
times = eval([variableName, '(strcmp({', variableName, '.Event}, Event)).Times']);

markers = eval([variableName, '(strcmp({', variableName, '.Event}, Event)).Markers']);
markerTimes = eval([variableName, '(strcmp({', variableName, '.Event}, Event)).MarkerTimes']);
markerTypes = eval([variableName, '(strcmp({', variableName, '.Event}, Event)).MarkerTypes']);

% Find the indices of MarkerTypes with the name 'lf_heelstrike'
% indices = strcmp(markerTypes, 'rf_heelstrike');
indices = strcmp(markerTypes, 'lf_heelstrike') | strcmp(markerTypes, 'rf_heelstrike');
% Filter markerTypes based on the indices
filteredMarkerTypes = markerTypes(indices);
filteredMarkerTimes = markerTimes(indices);

% Display the filtered markerTypes
disp(filteredMarkerTypes);
disp(filteredMarkerTimes);

% Plot the data
figure;
plot(times,data);

hold on; % Enable overlaying of plots

% Loop through all the filtered marker times
for i = 1:numel(filteredMarkerTimes)
    markerTime = filteredMarkerTimes{i,1};
    markerType = filteredMarkerTypes{i,1};
    
    % Set the line color based on the marker type
    if strcmp(markerType, 'lf_heelstrike')
        lineColor = 'r'; % Red color for 'lf_heelstrike'
    elseif strcmp(markerType, 'rf_heelstrike')
        lineColor = 'b'; % Blue color for 'rf_heelstrike'
    end
    
    % Plot the line with the respective color
    line([markerTime markerTime], ylim, 'Color', lineColor, 'LineWidth', 1.5);
end

% Add legend
legend({'rf heelstrike', 'lf heelstrike'});

hold off; % Disable overlaying of plots


xlabel('Time');
ylabel('Amplitude');
title(['Data for Event: ', Event]);
