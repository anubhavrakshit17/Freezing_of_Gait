% Parameters
center_freq = 10;       % Center frequency of the alpha band (adjust as needed)
cycles = 16;            % Number of cycles in the Morlet wavelet
fs = 1000;              % Sampling frequency
time = -cycles/center_freq : 1/fs : cycles/center_freq;  % Adjusted time vector

% Create complex Morlet wavelet for one cycle
wavelet = exp(2*1i*pi*center_freq.*time) .* exp(-time.^2./(2*(cycles/(2*pi*center_freq))^2));

% Calculate the Fourier transform
wavelet_fft = fftshift(fft(wavelet));
frequency = linspace(-fs/2, fs/2, length(wavelet_fft));

% Calculate -3dB cutoff frequencies
cutoff_freq_lower = center_freq - (center_freq / (2*cycles));
cutoff_freq_upper = center_freq + (center_freq / (2*cycles));

% Find corresponding indices for -3dB frequencies
[~, index_lower] = min(abs(frequency - cutoff_freq_lower));
[~, index_upper] = min(abs(frequency - cutoff_freq_upper));

% Plot the time domain representation of the one-cycle Morlet wavelet
subplot(2,1,1);
plot(time, real(wavelet), 'b', 'LineWidth', 2);
hold on;
plot(time, imag(wavelet), 'r', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Amplitude');
title(sprintf('Time Domain Representation of One-Cycle Alpha Bandpass Filter (Morlet Wavelet)\nCenter Frequency: %.2f Hz', center_freq));
grid on;
legend('Real Part', 'Imaginary Part');
xlim([-0.1, 0.1]);  % Adjust axis limits as needed

% Plot the frequency domain representation of the filter
subplot(2,1,2);
plot(frequency, abs(wavelet_fft), 'LineWidth', 2);
hold on;

% Mark the center frequency
line([center_freq, center_freq], [0, max(abs(wavelet_fft))], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.5);

% Mark the -3dB cutoff frequencies
line([cutoff_freq_lower, cutoff_freq_lower], [0, max(abs(wavelet_fft)) * sqrt(2)/2], 'Color', 'g', 'LineStyle', ':', 'LineWidth', 1.5);
line([cutoff_freq_upper, cutoff_freq_upper], [0, max(abs(wavelet_fft)) * sqrt(2)/2], 'Color', 'g', 'LineStyle', ':', 'LineWidth', 1.5);

% Plot -3dB line
plot([frequency(1), frequency(end)], [max(abs(wavelet_fft)) * sqrt(2)/2, max(abs(wavelet_fft)) * sqrt(2)/2], 'Color', 'b', 'LineStyle', '-.', 'LineWidth', 1.5);

xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Domain Representation');
grid on;
legend('Filter Response', 'Center Frequency', '-3dB Cutoff Frequencies', '-3dB Line');

% Set x-axis ticks and labels for -3dB cutoff frequencies
xticks([cutoff_freq_lower, center_freq, cutoff_freq_upper]);
xticklabels({sprintf('%.2f Hz', cutoff_freq_lower), sprintf('%.2f Hz (Center)', center_freq), sprintf('%.2f Hz', cutoff_freq_upper)});
xtickangle(45);

% Adjust x-axis limits based on the highest cutoff frequency
if cutoff_freq_upper > fs/2
    xlim([-30, fs/2]);  % Adjust axis limits if cutoff exceeds Nyquist frequency
else
    xlim([-30, 30]);  % Adjust axis limits for lower cutoff frequencies
end

ylim([0, max(abs(wavelet_fft))*1.1]);  % Adjust axis limits as needed

% Adjust overall layout
sgtitle('One-Cycle Alpha Bandpass Filter using Morlet Wavelet');
