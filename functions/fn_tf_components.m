function [tf_data, freqs, times] = fn_tf_components(EEG, channel, start_time, end_time)

% Define parameters for the newtimef function
freqs = 2:2:40;
cycles = 0;
time_res = EEG.srate/2;
win_len = EEG.srate*2;

% Extract the channel data
data = EEG.data(1, EEG.times >= start_time & EEG.times <= end_time);

% Calculate the time-frequency data using the newtimef function
[times, tf_data, freqs] = newtimef(data, EEG.pnts, [start_time end_time], EEG.srate, cycles, 'freqs', freqs, 'timesout', time_res, 'winsize', win_len);

% Normalize the tf_data
tf_data = abs(tf_data)./max(abs(tf_data(:)));

end
