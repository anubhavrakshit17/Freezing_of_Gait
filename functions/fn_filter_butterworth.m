function filtered_data = fn_filter_butterworth(eeg_data, low_cutoff, high_cutoff, sampling_rate, order)
% Implements a Butterworth filter on EEG data
% Inputs:
% - eeg_data: the raw EEG data to filter (n_channels x n_samples)
% - low_cutoff: the low cutoff frequency for the filter (in Hz)
% - high_cutoff: the high cutoff frequency for the filter (in Hz)
% - sampling_rate: the sampling rate of the EEG data (in Hz)
% - order: the order of the Butterworth filter
% Outputs:
% - filtered_data: the filtered EEG data (n_channels x n_samples)

% Convert the cutoff frequencies to the appropriate values for the filter function
nyquist_freq = sampling_rate / 2;
Wn = [low_cutoff high_cutoff] / nyquist_freq;

% Create a Butterworth filter
[b, a] = butter(order, Wn);

% Apply the filter to the data
filtered_data = filtfilt(b, a, eeg_data);

end
