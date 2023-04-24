function fn_plot_filtering2(unfiltered_signal, filtered_signal, Fs, display_overlap)
    % Set default value for display_overlap if not provided
    if nargin < 4
        display_overlap = 0;
    end
    
    % Compute pwelch for unfiltered and filtered signals
    [unfiltered_pxx, unfiltered_freq] = pwelch(unfiltered_signal,[],[],[],Fs);
    [filtered_pxx, filtered_freq] = pwelch(filtered_signal,[],[],[],Fs);
    
    % Plot signals and pwelch
    if display_overlap
        % Display filtered and unfiltered signals in the same subplot
        subplot(2,1,1)
        plot(1/Fs*(0:length(unfiltered_signal)-1), unfiltered_signal, 'b')
        hold on
        plot(1/Fs*(0:length(filtered_signal)-1), filtered_signal, 'r')
        xlabel('Time (s)')
        ylabel('Amplitude')
        title('Filtered and Unfiltered Signals')
        legend('Unfiltered', 'Filtered')
        
        % Display pwelch of filtered and unfiltered signals
        subplot(2,1,2)
        semilogy(unfiltered_freq, unfiltered_pxx, 'b')
        hold on
        semilogy(filtered_freq, filtered_pxx, 'r')
        xlabel('Frequency (Hz)')
        ylabel('Power/Frequency (dB/Hz)')
        title('Pwelch of Filtered and Unfiltered Signals')
        legend('Unfiltered', 'Filtered')
        
    else
        % Display unfiltered signal and pwelch
        subplot(2,2,1)
        plot(1/Fs*(0:length(unfiltered_signal)-1), unfiltered_signal, 'b')
        xlabel('Time (s)')
        ylabel('Amplitude')
        title('Unfiltered Signal')
        
        subplot(2,2,2)
        semilogy(unfiltered_freq, unfiltered_pxx, 'b')
        xlabel('Frequency (Hz)')
        ylabel('Power/Frequency (dB/Hz)')
        title('Pwelch of Unfiltered Signal')
        
        % Display filtered signal and pwelch
        subplot(2,2,3)
        plot(1/Fs*(0:length(filtered_signal)-1), filtered_signal, 'r')
        xlabel('Time (s)')
        ylabel('Amplitude')
        title('Filtered Signal')
        
        subplot(2,2,4)
        semilogy(filtered_freq, filtered_pxx, 'r')
        xlabel('Frequency (Hz)')
        ylabel('Power/Frequency (dB/Hz)')
        title('Pwelch of Filtered Signal')
    end
    
    % Set axis properties
    ax = gca;
    ax.FontSize = 12;
    ax.XMinorTick = 'on';
    ax.YMinorTick = 'on';
    ax.TickLength = [0.02 0.02];
end
