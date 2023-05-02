%% Import the data
close 
clear
fn_addpath()
EEG = fn_import('PD09_48.set');

%% Import the events
rf_gait = 'rf.txt';
lf_gait = 'lf.txt';
EEG = fn_event_maker(EEG,rf_gait,lf_gait);
%%
close 
clear
fn_addpath()
EEG = fn_import('PD09_48_event.set');
%% 
fn_save_gait_events_file()
