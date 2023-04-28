% Define the time vector
clear
fn_addpath();
filename = "PD09_walkwstopp.eeg_eegalg.mat";
load(filename);
EEG_signal = EEG_File.EEG_signal;
EEG_time = EEG_File.eegtime_new;

load('dataset\gaitdata\PD09_walkwstopp.eeg_gaitfilt.mat');
hs_rf = GaitEvents.rf_events.Heelstrike_Loc;
hs_lf = GaitEvents.lf_events.Heelstrike_Loc;
Fs = 1000;
t = linspace(0, size(EEG_signal, 2)/Fs, size(EEG_signal, 2));

% Plot the EEG signal
figure;
plot(t, EEG_signal(1,:),'k');

% Add vertical lines at the heelstrike locations
hold on;
for i = 1:length(hs_rf)
    xline(hs_rf(i), 'r', 'LineWidth', 1,'Alpha',0.3);
end
hold on;
for i = 1:length(hs_lf)
    xline(hs_lf(i), 'g', 'LineWidth', 1,'Alpha',0.3);
end



% Add axis labels and a title
xlabel('Time (s)');
ylabel('EEG Signal');
title('EEG Signal with Heelstrike Events');
xlim([0 190])

%% Converting the hs_lf and hs_rf to trigger +1 and -1 respectively
% Convert timings in seconds to sample points
hs_lf_idx = round(hs_lf * 1000);
hs_rf_idx = round(hs_rf * 1000);

% Create a vector of zeros with the same length as the EEG signal
trig = zeros(1, size(EEG_signal, 2));

% Set the values corresponding to the heel strikes to +1 or -1
trig(hs_lf_idx) = -1;
trig(hs_rf_idx) = +1;

%%
[epoch_data, epoch_time, stimulus_sample, target_indices] = fn_epoching(EEG_signal,trig,300,700,1);