function EEG = fn_add_events_and_chanlocs(filename)
%SensesFOG - Load or convert EEG data from .set file

% Check if the file exists in the set_files folder
set_folder = 'datasets/set_files/';
set_file = [set_folder, filename];

if exist(set_file, 'file') == 2
    % If the file exists, load it using EEGLAB's pop_loadset function
    disp("The file already exists.");
    
    EEG = pop_loadset(set_file);
    disp("The set file is loaded."); 
    eeglab;
else
    % If the file does not exist, convert the data from the original files
    disp("The set file "+ filename+ " do not exist, so first, the channel locations will be added. " + ...
        "Default: (Standard-10-20-48chan.locs)");
    chanlocs_file = 'Standard-10-20-48chan.locs';
    EEG = fn_eeg_to_set(chanlocs_file,filename);
    disp("Channels Added Successfully")
    fn_add_event(EEG,filename);

    eeglab;

end

end

%% Functions Related 

function EEG = fn_add_event(EEG,setfilename)
gaitfileinput = input ("Enter the gait file from the gait folder of HIH Server including the "" : ");
load(gaitfileinput);
%%
rf_data = GaitEvents.rf_events;

rf_midswing = rf_data{:, 1};
rf_swing_start = rf_data{:, 3};
rf_swing_end = rf_data{:, 5};
rf_toe_off = rf_data{:, 7};
rf_heelstrike = rf_data{:, 9};

% Load the left foot gait event data from a text file
lf_data = GaitEvents.lf_events;
lf_midswing = lf_data{:, 1};
lf_swing_start = lf_data{:, 3};
lf_swing_end = lf_data{:, 5};
lf_toe_off = lf_data{:, 7};
lf_heelstrike = lf_data{:, 9};

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
EEG = pop_saveset(EEG,'filename',setfilename,'filepath','datasets\set_files');
disp("GaitEvents without duration Added");

%% Added on 16.06.2023
subjectdata = input("Please put the DB<PatientNumber>_subject_data.mat file in inverted comma ");
load(subjectdata)
eventData = subjectdata.events_filt.WalkWS;
events_cell = {};

% Delete rows with all empty cells
emptyRows = all(cellfun(@isempty, {eventData.task})) & all(cellfun(@isempty, {eventData.start})) & all(cellfun(@isempty, {eventData.end}));

% Check for empty cells within each field/column separately
for i = 1:numel(eventData)
    if isempty(eventData(i).task) && isempty(eventData(i).start) && isempty(eventData(i).end)
        emptyRows(i) = true;
    end
end

eventData(emptyRows) = [];

% Iterate over each element in eventData
for i = 1:numel(eventData)
    task = eventData(i).task;
    start = eventData(i).start;
    end_time = eventData(i).end;
    latency = start;
    duration = end_time - start;

    % Create a cell array for the current event
    event_cell = {task, latency, duration};

    % Add the event cell to the events_cell array
    events_cell = [events_cell; event_cell];
end

% Import the events into the EEG dataset
EEG = pop_importevent(EEG, 'event', events_cell, 'fields', {'type', 'latency', 'duration'}, 'append', 'yes');

% Save the EEG dataset with events
EEG = pop_saveset(EEG,'filename',setfilename,'filepath','datasets\set_files');
disp("GaitEvents with duration Added");

end

function [EEG] = fn_eeg_to_set(chanlocs_file,set_filename)
 
% Load the EEG file
% Changes made : 01.05 > EEG.chaninfo.nosedir = '+Y'; as it was +X before
eeg_filename = input("Put the path of the EEGData (patientName_condition_eeg_eegalg.mat file): ");
load(eeg_filename);

% Reduce the number of channels to 48
EEG_File.EEG_signal = EEG_File.EEG_signal(1:48,:);
EEG_File.channels = EEG_File.channels(1:48,:);


% Create an empty EEGLAB dataset
EEG = eeg_emptyset;

% Set the EEG properties
EEG.filename = EEG_File.filename;
EEG.setname = EEG_File.filename;
EEG.nbchan = size(EEG_File.EEG_signal, 1);
EEG.trials = 1;
EEG.pnts = size(EEG_File.EEG_signal, 2);
EEG.srate = EEG_File.fs_eeg;
EEG.xmin = EEG_File.eegtime_new(1);
EEG.xmax = EEG_File.eegtime_new(end);
EEG.times = EEG_File.eegtime_new;
EEG.data = EEG_File.EEG_signal;
EEG.chanlocs = readlocs(chanlocs_file);
EEG.chaninfo.nosedir = '+Y';
EEG = eeg_checkset(EEG);

% Save the EEG structure to a .set file with the same name as the input file

pop_saveset(EEG,'filename',set_filename,'filepath','datasets\set_files');
addpath("datasets\set_files\");
end

