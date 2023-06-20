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