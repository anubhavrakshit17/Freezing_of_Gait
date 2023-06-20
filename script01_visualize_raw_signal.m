clc
clear all
close all

%%
EEG = pop_loadset('PD09.set');
%% Visualize the PSD 
[psdAllChannels, averagePSD] = fn_PSD(EEG.data,EEG.srate);

%%
