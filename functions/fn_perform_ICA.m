function [icaweights,icasphere,icaact] = fn_perform_ICA(filename)
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

% Define the ICA file names

icaweights_filename = [char(filename), '_icaweights.mat'];
icasphere_filename= [char(filename), '_icasphere.mat'];
icaact_filename = [char(filename), '_icaact.mat'];

% Check if the file already exists
if exist(fullfile(ica_folder, icaweights_filename), 'file')  && ...
    exist (fullfile(ica_folder, icasphere_filename), 'file')  && ...
    exist(fullfile(ica_folder, icaact_filename), 'file')
    disp(['The ICA files "', icaact_filename, '" already exists in "', ica_folder, '".']);
    %eeglab;
icaweights = load(fullfile(ica_folder,icaweights_filename),'-mat');
icasphere =    load(fullfile(icasphere_filename),'-mat');
icaact=   load(fullfile(ica_folder,icaact_filename),'-mat');


else
    % Create a dummy EEG structure for the input signal
    eeglab
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
    icaweights = EEG.icaweights;
    icasphere = EEG.icasphere;
    % Extract ICA-transformed EEG data
    icaact = EEG.icaweights * EEG.icasphere * EEG.data;
    
    save(fullfile(ica_folder, icaweights_filename), 'icaweights');
    save(fullfile(ica_folder, icasphere_filename), 'icasphere');
    save(fullfile(ica_folder, icaact_filename), 'icaact');
    disp(['The icaact file "', icaweights_filename, '" has been saved to "', ica_folder, '".']);
    disp(['The icaact file "', icasphere_filename, '" has been saved to "', ica_folder, '".']);
    disp(['The icaact file "', icaact_filename, '" has been saved to "', ica_folder, '".']);
end