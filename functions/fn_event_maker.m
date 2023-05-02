function EEG = fn_event_maker(EEG,rf_gait,lf_gait)
% Load the right foot gait event data from a text file
%rf = input("Please Input which right foot data txt file you want to input within ' ': ");
%lf = input("Please Input which left foot data txt file you want to input within ' ': ");

rf_data = importdata(rf_gait);
rf_midswing = rf_data.data(:, 1);
rf_swing_start = rf_data.data(:, 2);
rf_swing_end = rf_data.data(:, 3);
rf_toe_off = rf_data.data(:, 4);
rf_heelstrike = rf_data.data(:, 5);

% Load the left foot gait event data from a text file
lf_data = importdata(lf_gait);
lf_midswing = lf_data.data(:, 1);
lf_swing_start = lf_data.data(:, 2);
lf_swing_end = lf_data.data(:, 3);
lf_toe_off = lf_data.data(:, 4);
lf_heelstrike = lf_data.data(:, 5);

% From seconds to sample points 
rf_midswing_samples = round(rf_midswing * EEG.srate);
rf_swing_start_samples = round(rf_swing_start * EEG.srate);
rf_swing_end_samples = round(rf_swing_end * EEG.srate);
rf_toe_off_samples = round(rf_toe_off * EEG.srate);
rf_heelstrike_samples = round(rf_heelstrike * EEG.srate);

lf_midswing_samples = round(lf_midswing * EEG.srate);
lf_swing_start_samples = round(lf_swing_start * EEG.srate);
lf_swing_end_samples = round(lf_swing_end * EEG.srate);
lf_toe_off_samples = round(lf_toe_off * EEG.srate);
lf_heelstrike_samples = round(lf_heelstrike * EEG.srate);

%%
% Define the event types for the right foot
EEG.event= [];
rf_event_types = {'rf_midswing', 'rf_swing_start', 'rf_swing_end', 'rf_toe_off', 'rf_heelstrike'};

% Loop over all right foot events and add them to the EEG event structure
for i = 1:length(rf_heelstrike_samples)
    
    % Loop over all event types and add them to the EEG event structure
    for j = 1:length(rf_event_types)
        % Define the event latency based on the corresponding sample
        switch j
            case 1
                event_latency = rf_midswing_samples(i);
            case 2
                event_latency = rf_swing_start_samples(i);
            case 3
                event_latency = rf_swing_end_samples(i);
            case 4
                event_latency = rf_toe_off_samples(i);
            case 5
                event_latency = rf_heelstrike_samples(i);
        end
        
        % Add the event to the EEG event structure
        EEG.event(end+1).latency = event_latency;
        EEG.event(end).type = rf_event_types{j};
        EEG.event(end).duration = 0;
    end

end

lf_event_types = {'lf_midswing', 'lf_swing_start', 'lf_swing_end', 'lf_toe_off', 'lf_heelstrike'};

% Loop over all left foot events and add them to the EEG event structure
for i = 1:length(lf_heelstrike_samples)
    
    % Loop over all event types and add them to the EEG event structure
    for j = 1:length(lf_event_types)
        % Define the event latency based on the corresponding sample
        switch j
            case 1
                event_latency = lf_midswing_samples(i);
            case 2
                event_latency = lf_swing_start_samples(i);
            case 3
                event_latency = lf_swing_end_samples(i);
            case 4
                event_latency = lf_toe_off_samples(i);
            case 5
                event_latency = lf_heelstrike_samples(i);
        end
        
        % Add the event to the EEG event structure
        EEG.event(end+1).latency = event_latency;
        EEG.event(end).type = lf_event_types{j};
        EEG.event(end).duration = 0;
    end
end
[~,index] = sortrows([EEG.event.latency].');
EEG.event = EEG.event(index);
clear index;

%%
% Save the modified EEG structure
EEG = pop_saveset(EEG);
end