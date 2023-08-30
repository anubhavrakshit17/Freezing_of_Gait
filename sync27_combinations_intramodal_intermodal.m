clc
clear all
close all
%%
load("overall_data_modified.mat");
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
%%