clc
clear all
close all
fn_addpath()
%%  Add Events and Channel locations
% "J:\My Drive\nr6\Master_thesis\Others\misc\HIH Server\EEGData\DBS09\PD09_walkwstopp.eeg_eegalg.mat"
EEG = fn_add_events_and_chanlocs('PD09.set'); 

%% TASK 2 : Visualize the raw signal PSD
run("script01_visualize_raw_signal.m");

%% TASK 3 : 

 %% Addpath Function

 function fn_addpath()
% Get the current directory
clc
close all
current_dir = pwd;

% Add the current directory to the MATLAB search path
addpath(genpath(current_dir));

% Save the updated MATLAB search path
savepath;
end

