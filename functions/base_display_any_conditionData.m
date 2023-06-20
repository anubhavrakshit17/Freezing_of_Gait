
% Define the occurrence you want to plot
 occurrence = 'Walk8';  % Replace with the specific occurrence you want to plot
% 
% % Extract the condition name from the occurrence
 % conditionName = occurrence(1:end-1); % Cannot handle Walk10 etc
  conditionName = regexprep(occurrence, '[0-9]', ''); % CAN HANDLE
% Create the variable name for the condition data struct
variableName = ['conditionData', conditionName];

% Retrieve the data for the specific occurrence from the condition data struct
data = eval([variableName, '(strcmp({', variableName, '.Occurrence}, occurrence)).Data']);

% Plot the data
figure;
plot(data);
xlabel('Time');
ylabel('Amplitude');
title(['Data for Occurrence: ', occurrence]);
