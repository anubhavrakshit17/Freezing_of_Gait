clear
fn_addpath();
filename = "PD09_walkwstopp.eeg_eegalg.mat";
load(filename);
%%
EEG_signal = EEG_File.EEG_signal(1:48,:);
EEG_time = EEG_File.eegtime_new;
%%
channel = 1:5;
%fn_time_series_plot(EEG_time, EEG_signal(channel,:),2,1); %1 for image, 2 for movie

%% Filtering
eeg_filtered_butterworth = fn_filter_butterworth(EEG_signal,10,40,1000,4);
%fn_time_series_plot(EEG_time, eeg_filtered_butterworth(channel,:),1,2); % 1:raw, 2 filtered
%% 
channel = 4;
%fn_plot_filtering(EEG_signal(channel,:),eeg_filtered_butterworth(channel,:),1000,1);
%% ICA 
[icaweights,icasphere,icawinv,icaact] = fn_perform_ICA(filename,eeg_filtered_butterworth);
% When you run for the first time, remove the last part, for example, 
% icaweights = icaweights;
% icasphere = icasphere;
% icawinv = icawinv ;
% icaact = icaact ;

icaweights = icaweights.icaweights;
icasphere= icasphere.icasphere;
icawinv = icawinv.icawinv;
icaact = icaact.icaact;

%% Plot the component maps

for i = 1:size(icawinv, 2)
    pop_topoplot(icawinv(:,i), EEG.chanlocs, 'electrodes', 'off', 'style', 'both', 'numcontour', 8);
    title(['Component ' num2str(i)]);
end

%% 
