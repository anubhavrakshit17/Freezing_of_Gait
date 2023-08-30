% Assuming band_power_data is a 5x3 cell array containing the data
clc
clear all
close all
load('p1_band_power_data.mat');
load('time_steps_power.mat');
% Initialize variables to store averaged data
theta_avg = zeros(1, 30001);
alpha_avg = zeros(1, 30001);
beta_avg = zeros(1, 30001);
fs = 1000;
% Loop through each epoch's data
for epoch = 1:size(band_power_data, 1)
    % Accumulate data for each frequency band
    theta_avg = theta_avg + band_power_data{epoch, 1};
    alpha_avg = alpha_avg + band_power_data{epoch, 2};
    beta_avg = beta_avg + band_power_data{epoch, 3};
end
%%
% Divide by the number of epochs to get the average

num_epochs = size(band_power_data, 1);
theta_avg = theta_avg / num_epochs;
alpha_avg = alpha_avg / num_epochs;
beta_avg = beta_avg / num_epochs;
% Now you have the row-averaged data for each frequency band
% Assuming you have already calculated the row-averaged data as shown in the previous response
% And you have the x-axis values defined as time_steps_power

% Plot the row-averaged data for each frequency band
figure;

subplot(3,1,1);
plot(time_steps_power, theta_avg);
title('Theta Power');
xlabel('Time');
ylabel('Average Power');

subplot(3,1,2);
plot(time_steps_power, alpha_avg);
title('Alpha Power');
xlabel('Time');
ylabel('Average Power');

subplot(3,1,3);
plot(time_steps_power, beta_avg);
title('Beta Power');
xlabel('Time');
ylabel('Average Power');

sgtitle('Row-Averaged Power for Different Frequency Bands');
%%
% Assuming you have already calculated the row-averaged data as shown in the previous response
% And you have the x-axis values defined as time_steps_power

% Plot the row-averaged data for all frequency bands on the same figure
figure;

hold on;

plot(time_steps_power, theta_avg, 'r', 'DisplayName', 'Theta Power');
plot(time_steps_power, alpha_avg, 'g', 'DisplayName', 'Alpha Power');
plot(time_steps_power, beta_avg, 'b', 'DisplayName', 'Beta Power');

hold off;

title('Row-Averaged Power for Different Frequency Bands');
xlabel('Time');
ylabel('Average Power');
legend;

grid on;
