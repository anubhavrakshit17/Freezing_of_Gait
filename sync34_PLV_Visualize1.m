
% Define frequency bands and modalities
frequencyBands = {'Delta', 'Theta', 'Alpha', 'Beta', 'Gamma'};
modalities = {'EEG', 'LFPL', 'LFPR'};

events = {'Freezing Turn', 'Turning', 'Walking'};
test = plv_accumulator_23;
%% Only for sanity check
test(2,2)= 1;
%%
% Iterate over each event
for eventIndex = 1:length(events)
    % Create a new figure for the current event
    figure;
    
    % Create subplots for the distinct combinations of modalities
    subplotIndex = 1;
    for modalityIndex1 = 1:length(modalities)
        for modalityIndex2 = modalityIndex1+1:length(modalities) % Avoid repetition
            subplot(1, 3, subplotIndex);
            
            % Create a matrix for the combinations
            combinationMatrix = test;
            
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
            modality1 = modalities{modalityIndex1};
            modality2 = modalities{modalityIndex2};
            
            % Set custom labels with modalities
            xlabel(modality1);
            ylabel(modality2);
            
            title([modality1, ' vs ', modality2]);
            
            % Add colorbar
            colorbar;
            
            % Set aspect ratio to make the subplot square
            axis square;
            
            % Increment subplot index
            subplotIndex = subplotIndex + 1;
        end
    end
    
    % Add title for the entire figure based on the event
    sgtitle(['Event: ', events{eventIndex}]);
end
