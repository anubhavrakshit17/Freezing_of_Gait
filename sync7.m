load("overall_data.mat");
betaEEG= overall_data{1, 1}.BetaEEG(15,:) ;
betaLFPL= overall_data{1, 1}.BetaLFP_left ;
betaLFPR=overall_data{1, 1}.BetaLFP_right ;
%%
% Assuming you have loaded your data into variables: betaEEG, betaLFPL, betaLFPR

% Calculate synchronization between EEG and LFPL using Cross-Correlation
crossCorrelation_EEG_LFPL = xcorr(betaEEG, betaLFPL);
%%
% Calculate coherence between EEG and LFPL
[coherence_EEG_LFPL, freq] = mscohere(betaEEG, betaLFPL);

% Calculate phase locking value (PLV) between EEG and LFPL
plv_EEG_LFPL = abs(mean(exp(1i * (angle(hilbert(betaEEG)) - angle(hilbert(betaLFPL))))));

% Calculate synchronization between EEG and LFPR using Cross-Correlation
crossCorrelation_EEG_LFPR = xcorr(betaEEG, betaLFPR);

% Calculate coherence between EEG and LFPR
[coherence_EEG_LFPR, freq] = mscohere(betaEEG, betaLFPR);

% Calculate phase locking value (PLV) between EEG and LFPR
plv_EEG_LFPR = abs(mean(exp(1i * (angle(hilbert(betaEEG)) - angle(hilbert(betaLFPR))))));

% Calculate synchronization between LFPL and LFPR using Cross-Correlation
crossCorrelation_LFPL_LFPR = xcorr(betaLFPL, betaLFPR);

% Calculate coherence between LFPL and LFPR
[coherence_LFPL_LFPR, freq] = mscohere(betaLFPL, betaLFPR);

% Calculate phase locking value (PLV) between LFPL and LFPR
plv_LFPL_LFPR = abs(mean(exp(1i * (angle(hilbert(betaLFPL)) - angle(hilbert(betaLFPR))))));
%%
time = cropped_eeg_time;
[maxCorrValue, maxCorrIndex] = max(crossCorrelation_EEG_LFPL);

% Calculate the corresponding time of the maximum correlation
timeLagOfMaxCorr = time(maxCorrIndex);

% Define the time window around the maximum correlation point
timeWindow = 10;  % seconds

% Find the indices for the time window
windowStartIndex = find(time >= timeLagOfMaxCorr - timeWindow, 1);
windowEndIndex = find(time <= timeLagOfMaxCorr + timeWindow, 1, 'last');

% Plot EEG and LFPL data in two subplots
figure;

subplot(2,1,1);
plot(time(windowStartIndex:windowEndIndex), betaEEG(windowStartIndex:windowEndIndex));
xlabel('Time (seconds)');
ylabel('EEG');
title('EEG Data');
xlim([timeLagOfMaxCorr - timeWindow, timeLagOfMaxCorr + timeWindow]);

subplot(2,1,2);
plot(time(windowStartIndex:windowEndIndex), betaLFPL(windowStartIndex:windowEndIndex));
xlabel('Time (seconds)');
ylabel('LFPL');
title('LFPL Data');
xlim([timeLagOfMaxCorr - timeWindow, timeLagOfMaxCorr + timeWindow]);

sgtitle('EEG and LFPL Data around Maximum Correlation');

