function [EEG] = fn_convert_to_eeglab(eeg_filename, chanlocs_file,set_filename)
 
% Load the EEG file
% Changes made : 01.05 > EEG.chaninfo.nosedir = '+Y'; as it was +X before
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

pop_saveset(EEG,'filename',set_filename,'filepath','SenseFOG\.set_files\');
addpath("dataset\.set_files\");
end
