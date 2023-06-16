clc
clear all
close all

%%
EEG = pop_loadset('PD09_.set');
%% Visualize the PSD 
[psdAllChannels, averagePSD] = fn_PSD(EEG.data,EEG.srate);
%% Rejecting Bad channels observing PSD using EEGLAB

% Assuming you have EEGlab installed and an EEG structure loaded

% Set the dataflag to indicate whether you are processing data channels (1) or components (0)
dataflag = 1; % Processing data channels

% Set the epoch time range in milliseconds
timerange = [0 184415]; % Example: Analyze data from 0ms to 1000ms

% Set the process option to specify whether to plot 'EEG', 'ERP', or 'BOTH'
process = 'EEG'; % Example: Plot EEG spectra

% Set the frequency range to plot
freqrange = [1 60]; % Example: Plot frequencies from 1Hz to 30Hz

% Set any additional spectral and scalp map options using 'key', 'val' pairs
% For example, to customize the scalp map:
spectral_options = {'electrodes', 'off', 'maplimits', [-10 10]}; % Example: Turn off electrode labels and set the color map limits

% Call pop_spectopo function
pop_spectopo(EEG, dataflag, timerange, process, 'freqrange', freqrange, spectral_options{:});

%% Deleting channels after inspection

% Set the channels you want to delete
% Display the number of channels before deletion
disp("Number of channels before deletion: " + num2str(EEG.nbchan));
channels_to_delete = [30, 31, 32, 16]; % Example: delete channels 2, 4, and 6

% Exclude the channels from the EEG structure
EEG = pop_select(EEG, 'nochannel', channels_to_delete);

disp("Number of channels after deletion: " + num2str(EEG.nbchan));
%%
