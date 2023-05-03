function fn_save_gait_events_file()
    % Take input filename from user
    filename = input("Enter the gaitEvents file from the GaitData folder including '.mat': ", 's');
    rf_file = [filename(1:end-4) '_rf.txt'];
    lf_file = [filename(1:end-4) '_lf.txt'];
    gaitdata_folder = fullfile('SenseFOG', 'GaitData');
    
    % Check if files already exist in GaitData folder
    if exist(fullfile(gaitdata_folder, rf_file), 'file') == 2 && exist(fullfile(gaitdata_folder, lf_file), 'file') == 2
        disp('Files already exist in GaitData folder, skipping writing');
        return
    end

    % Load the file
    load(fullfile('GaitData', filename));

    % Get the field names ending with "_Loc"
    rf_fields = fieldnames(GaitEvents.rf_events);
    lf_fields = fieldnames(GaitEvents.lf_events);
    rf_loc_fields = rf_fields(contains(rf_fields, '_Loc'));
    lf_loc_fields = lf_fields(contains(lf_fields, '_Loc'));

    % Loop through the _Loc fields and save the data
    for i = 1:numel(rf_loc_fields)
        field = rf_loc_fields{i};
        data = GaitEvents.rf_events.(field);
        name = ['rf_' strrep(field, '_Loc', '')];
        eval([name ' = data;']);
    end

    for i = 1:numel(lf_loc_fields)
        field = lf_loc_fields{i};
        data = GaitEvents.lf_events.(field);
        name = ['lf_' strrep(field, '_Loc', '')];
        eval([name ' = data;']);
    end

    % Write the rf events to a file
    rf_events = table(rf_Midswing, rf_Swing_Start, rf_Swing_End, rf_Toe_Off, rf_Heelstrike);
    writetable(rf_events, fullfile(gaitdata_folder, rf_file), 'Delimiter', 'tab');

    % Write the lf events to a file
    lf_events = table(lf_Midswing, lf_Swing_Start, lf_Swing_End, lf_Toe_Off, lf_Heelstrike);
    writetable(lf_events, fullfile(gaitdata_folder, lf_file), 'Delimiter', 'tab');
end

