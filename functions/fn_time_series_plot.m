function fn_time_series_plot(EEG_time,EEG_signal,title_name,choice)
% Subtract the first time point from all time points
% Check if the input argument is valid
% choice 1 for raw eeg, 2 for raw eeg moving

channels = input("Enter which channels you want to display in start:end format : ");
EEG_signal = EEG_signal(channels,:);
if strcmp(title_name,'raw')
    title_input = 'Raw EEG Data';
    disp('The title would be Raw EEG Data.');
    disp('')
elseif strcmp(title_name,'filt')
    disp('The title would be Filtered EEG Data');
    disp('');
    title_input = 'Filtered EEG Data';
else
    disp('Invalid INPUT')
end
switch choice
    % case strcmp(choice, 'picture')
            case 1

        disp('You have chosen to display a still picture of the time domain');
        figure;
        plot(EEG_time, EEG_signal, 'LineWidth',1);
        xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
        ylabel('Amplitude (\muV)', 'FontSize', 14, 'FontWeight', 'bold');
        title(title_input, 'FontSize', 16, 'FontWeight', 'bold');
        grid on;
        xlim([EEG_time(1), EEG_time(end)]);
        ax = gca;
        ax.FontSize = 12;
        ax.XMinorTick = 'on';
        ax.YMinorTick = 'on';
        ax.TickLength = [0.02 0.02];
    % case strcmp(choice, 'movie')
        case 2

        disp('You have chosen to display a movie of the time domain');
        EEG_time = EEG_time - EEG_time(1);
        % Plot the time series
        figure;
        plot(EEG_time, EEG_signal, 'LineWidth',1);
        xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
        ylabel('Amplitude (\muV)', 'FontSize', 14, 'FontWeight', 'bold');
        title(title_input, 'FontSize', 16, 'FontWeight', 'bold');
        grid on;
        xlim([EEG_time(1), EEG_time(end)]);
        ax = gca;
        ax.FontSize = 12;
        ax.XMinorTick = 'on';
        ax.YMinorTick = 'on';
        ax.TickLength = [0.02 0.02];

        % Create a movie from the plot frames
        num_frames = 100;
        frame_time = 10/num_frames;
        M(num_frames) = struct('cdata',[],'colormap',[]);
        for i = 1:num_frames
            t = (i-1)/(num_frames-1)*(EEG_time(end)-EEG_time(1)) + EEG_time(1);
            xlim([t, t+10]);
            xline(t, 'r', 'LineWidth', 1.5);
            M(i) = getframe(gcf);
            pause(frame_time);
        end
        plot(EEG_time, EEG_signal, 'LineWidth',1);
        xlabel('Time (s)', 'FontSize', 14, 'FontWeight', 'bold');
        ylabel('Amplitude (\muV)', 'FontSize', 14, 'FontWeight', 'bold');
        title(title_input, 'FontSize', 16, 'FontWeight', 'bold');
        grid on;
        xlim([EEG_time(1), EEG_time(end)]);
        ax = gca;
        ax.FontSize = 12;
        ax.XMinorTick = 'on';
        ax.YMinorTick = 'on';
        ax.TickLength = [0.02 0.02];



end
