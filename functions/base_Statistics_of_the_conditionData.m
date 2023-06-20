

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
    
    % Add the 'Occurrence' field and assign the appropriate value
    currentConditionData = eval(newVariableName);
    occurrenceCount = numel(currentConditionData);
    for j = 1:occurrenceCount
        currentConditionData(j).Occurrence = [currentCondition, num2str(j)];
        
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
    numOccurrences = numel(durations);
    xLimits = xlim;
    line(xLimits, [meanDuration, meanDuration], 'Color', 'r', 'LineWidth', 2,'LineStyle','--');
    
    % Add labels and title
    xlabel('Occurrence');
    ylabel('Duration');
    title(currentCondition);
    
    % Add mean value text in red
    text(numOccurrences, meanDuration+1, sprintf('Mean: %.2f', meanDuration), 'Color', 'r');
    
    % Adjust the figure's appearance
    set(gca, 'XTick', 1:numOccurrences, 'XTickLabel', {currentConditionData.Occurrence});
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

