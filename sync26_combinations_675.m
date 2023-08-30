clc
clear all
close all
%load("overall_data_modified.mat");
events = {'FT', 'T', 'W'};
modalities = {'EEG', 'LFPL', 'LFPR'};
frequency_bands = {'alpha', 'beta', 'theta', 'delta', 'gamma'};

combinations = cell(1, length(events) * length(modalities)^2 * length(frequency_bands)^2);

index = 1;
for i = 1:length(events)
    for j = 1:length(modalities)
        for k = 1:length(frequency_bands)
            for l = 1:length(modalities)
                for m = 1:length(frequency_bands)
                    combination = sprintf('%s_%s_%s_%s_%s', events{i}, modalities{j}, frequency_bands{k}, modalities{l}, frequency_bands{m});
                    combinations{index} = combination;
                    index = index + 1;
                end
            end
        end
    end
end

% Display the combinations
disp(combinations');
%%
events = {'FT', 'T', 'W'};
modalities = {'EEG', 'LFPL', 'LFPR'};
frequency_bands = {'alpha', 'beta', 'theta', 'delta', 'gamma'};

num_events = length(events);
num_modalities = length(modalities);
num_frequency_bands = length(frequency_bands);

total_combinations = num_events * num_modalities^2 * num_frequency_bands^2;
disp(['Total number of distinct combinations: ', num2str(total_combinations)]);

