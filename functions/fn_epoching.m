function [epoch_data, epoch_time, stimulus_sample, target_indices] = fn_epoching(y, trig, pre_stimulus_samples, post_stimulus_samples,tgt_or_ntgt)
% Create epochs based on target triggers in the trig variable, centered
% around the stimulus onset time.
%
% Inputs:
%   y:              2D matrix of EEG data, with channels in columns and samples in rows
%   trig:           1D vector of trigger values corresponding to each sample in y
%   pre_stimulus_samples:    Number of samples to include in the pre-stimulus period
%   post_stimulus_samples:   Number of samples to include in the post-stimulus period
%
% Outputs:
%   epoch_data:     3D matrix of epoch data, with dimensions (epoch length x num channels x num epochs)
%   epoch_time:     1D vector of time points corresponding to each sample in the epoch data
%   stimulus_sample:    Index of the stimulus onset time within each epoch
%   target_indices:  1D vector of indices corresponding to the start of each target epoch in y

% Calculate the epoch length in samples
epoch_length = pre_stimulus_samples + post_stimulus_samples + 1;

% Find the indices of target epochs in the trig variable
% Find the indices of target or non-target epochs in the trig variable
if tgt_or_ntgt == 1
    target_indices = find(trig == 1);
elseif tgt_or_ntgt == -1
    target_indices = find(trig == -1);
else
    error('Invalid tgt_or_ntgt argument. Must be 1 for target or -1 for non-target epochs.');
end

% Initialize the epoch matrix
num_epochs = length(target_indices);
epoch_data = zeros(epoch_length, size(y, 2), num_epochs);

% Create the epochs
for i = 1:num_epochs
    epoch_start = target_indices(i) - pre_stimulus_samples;
    epoch_end = epoch_start + epoch_length - 1;
    
    if epoch_end > size(y, 1)
        continue; % skip epochs that exceed the size of y
    end
    
    epoch_data(:, :, i) = y(epoch_start:epoch_end, :);
end

% Mark the stimulus onset time in each epoch
stimulus_sample = pre_stimulus_samples + 1;

% Create a time vector for the epoch data
epoch_time = linspace(-pre_stimulus_samples/1000, post_stimulus_samples/1000, epoch_length);

end
