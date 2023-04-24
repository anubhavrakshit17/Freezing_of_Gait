function EEG_ICA = fn_perform_ICA(filename)
% This function performs ICA on an EEG signal stored in a .mat file using the pop_runica() function from EEGlab.
%
% Inputs:
%   filename: path to the .mat file containing the EEG data.
%   num_components (optional): number of independent components to estimate. If not specified, defaults to the number of channels in the EEG data.
%
% Outputs:
%   EEG_ICA: ICA-transformed EEG data matrix of size (num_components, num_samples).


load(filename);
EEG_signal = EEG_File.EEG_signal;

ica_folder = 'ICA_performed_dataset';

% Create the folder if it doesn't exist
if ~exist(ica_folder, 'dir')
    mkdir(ica_folder);
end

% Define the ICA file name
ica_filename = [char(filename), '_ICA.mat'];

% Check if the file already exists
if exist(fullfile(ica_folder, ica_filename), 'file')
    disp(['The ICA file "', ica_filename, '" already exists in "', ica_folder, '".']);
else
    % Create a dummy EEG structure for the input signal
    eeglab;
    EEG = eeg_emptyset;
    EEG.data = EEG_signal;
    
    % Set EEG structure parameters
    EEG.nbchan = size(EEG.data, 1);
    EEG.pnts = size(EEG.data, 2);
    EEG.srate = EEG_File.fs_eeg; % Replace with the actual sampling rate of the EEG signal
    
    % Set default number of components to number of channels
    num_components = EEG.nbchan;

    % Run ICA using EEGlab function
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended', 1, 'interrupt', 'on', 'pca', num_components);

    % Extract ICA-transformed EEG data
    EEG_ICA = EEG.icaweights * EEG.icasphere * EEG.data;
    
    save(fullfile(ica_folder, ica_filename), 'EEG_ICA');
    disp(['The ICA file "', ica_filename, '" has been saved to "', ica_folder, '".']);
end