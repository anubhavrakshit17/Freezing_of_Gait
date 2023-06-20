function [psdAllChannels,averagePsd]= fn_PSD(eeg_signal,srate, eeg_filtered)
numChannels = size(eeg_signal, 1);

frequencyResolutionfactor = 4;
frequencyResolution = 1/frequencyResolutionfactor;
windowSize = frequencyResolutionfactor * srate;
overlapSize = 0.95 * srate;
% Calculate normalized frequency

% Plot the PSD using normalized frequency



deltaRange = [0.5, 4];
thetaRange = [4, 8];
alphaRange = [8, 12];
betaRange = [12, 30];
gammaRange = [30, 80];

psdAllChannels = [];
psdAllChannels_filtered = [];

if nargin ==2
    figure;
    hold on;
    for channel = 1:numChannels
        channelSignal = eeg_signal(channel, :);
        [psd, f] = pwelch(channelSignal, windowSize, overlapSize, [], srate);
        psdAllChannels = [psdAllChannels, psd];
        plot(f, 10*log10(psd), 'Color', [0.5, 0.5, 0.5]);
    end

    averagePsd = mean(psdAllChannels, 2);
    f = linspace(0, srate/2, size(psdAllChannels, 1));
    h1= plot(f, 10*log10(averagePsd), 'r', 'LineWidth', 2);
    
    ylimits = ylim;
    opacity = 0.1;

    h2 = fill([deltaRange(1), deltaRange(2), deltaRange(2), deltaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'g', 'FaceAlpha', opacity, 'DisplayName', 'Delta');
    h3 = fill([thetaRange(1), thetaRange(2), thetaRange(2), thetaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'b', 'FaceAlpha', opacity, 'DisplayName', 'Theta');
    h4 = fill([alphaRange(1), alphaRange(2), alphaRange(2), alphaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'r', 'FaceAlpha', opacity, 'DisplayName', 'Alpha');
    h5 = fill([betaRange(1), betaRange(2), betaRange(2), betaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'm', 'FaceAlpha', opacity, 'DisplayName', 'Beta');
    h6 = fill([gammaRange(1), gammaRange(2), gammaRange(2), gammaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'y', 'FaceAlpha', opacity, 'DisplayName', 'Gamma');

    hold off;

    ylabel('Power Spectral Density (dB/Hz)');
    title('Power Spectral Density - All Channels');
    xlim([0 30]);

    set(h1, 'DisplayName','Averaged PSD');
    set(h2, 'DisplayName', 'Delta Range');
    set(h3, 'DisplayName', 'Theta Range');
    set(h4, 'DisplayName', 'Alpha Range');
    set(h5, 'DisplayName', 'Beta Range');
    set(h6, 'DisplayName', 'Gamma Range');
    set(gca, 'FontSize', 16)
    legend([h1, h2, h3, h4, h5, h6]);

end


if nargin == 3
    numChannels_filtered = size(eeg_filtered, 1);

    for channel = 1:numChannels
        channelSignal = eeg_signal(channel, :);
        [psd, f] = pwelch(channelSignal, windowSize, overlapSize, [], srate);
        psdAllChannels = [psdAllChannels, psd];

    end

    averagePsd = mean(psdAllChannels, 2);
    f = linspace(0, srate/2, size(psdAllChannels, 1));

    for channel = 1:numChannels_filtered
        channelSignal_filtered = eeg_filtered(channel, :);
        [psd_filtered, ~] = pwelch(channelSignal_filtered, windowSize, overlapSize, [], srate);
        psdAllChannels_filtered = [psdAllChannels_filtered, psd_filtered];
    end

    averagePsd_filtered = mean(psdAllChannels_filtered, 2);
    figure
    h6=  plot(f, 10*log10(averagePsd_filtered), 'b', 'LineWidth', 1.5);
    hold on
    h7 = plot(f, 10*log10(averagePsd), 'r', 'LineWidth', 1.5);


    ylimits = ylim;
    opacity = 0.1;

    h1 = fill([deltaRange(1), deltaRange(2), deltaRange(2), deltaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'g', 'FaceAlpha', opacity, 'DisplayName', 'Delta');
    h2 = fill([thetaRange(1), thetaRange(2), thetaRange(2), thetaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'b', 'FaceAlpha', opacity, 'DisplayName', 'Theta');
    h3 = fill([alphaRange(1), alphaRange(2), alphaRange(2), alphaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'r', 'FaceAlpha', opacity, 'DisplayName', 'Alpha');
    h4 = fill([betaRange(1), betaRange(2), betaRange(2), betaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'm', 'FaceAlpha', opacity, 'DisplayName', 'Beta');
    h5 = fill([gammaRange(1), gammaRange(2), gammaRange(2), gammaRange(1)], [ylimits(1), ylimits(1), ylimits(2), ylimits(2)], 'y', 'FaceAlpha', opacity, 'DisplayName', 'Gamma');

    hold off;
    xlabel('Frequency (Hz)','FontSize',16);
    ylabel('Power Spectral Density (dB/Hz)','FontSize',16);
    title('Power Spectral Density - All Channels');
    xlim([0 30]);

    set(h1, 'DisplayName', 'Delta Range');
    set(h2, 'DisplayName', 'Theta Range');
    set(h3, 'DisplayName', 'Alpha Range');
    set(h4, 'DisplayName', 'Beta Range');
    set(h5, 'DisplayName', 'Gamma Range');
    set(h6, 'DisplayName','Not reference averaged');
    set(h7,'DisplayName','Reference Averaged');
    legend([h1, h2, h3, h4, h5, h6, h7]);
end
% Modify the appearance of the axis lines
ax = gca;
ax.LineWidth = 1.5;  % Increase the line width of the axis lines

% Customize the grid lines
grid on;               % Display grid lines
grid minor;            % Use minor grid lines
ax.GridAlpha = 0.3;    % Set grid line transparency
ax.GridColor = 'k';    % Set grid line color

% Customize the legend
legend('FontSize', 12);       % Increase the legend font size

% Set the figure background color
set(gcf, 'Color', 'w');  % Set the background color to white

% Adjust the plot margins
ax.Position(1) = 0.1;   % Left margin
ax.Position(2) = 0.1;   % Bottom margin
ax.Position(3) = 0.8;   % Width
ax.Position(4) = 0.8;   % Height
set(gca,'FontSize',16);
end
