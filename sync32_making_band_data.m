% Create the 'band_data' structure
band_data = struct();

% Assuming you have the original data stored in 'overall_data_bands{1,1}'

% Renaming EEG data
band_data.Freezing_turn_EEG = overall_data_bands{1, 1}.epochData_bands_EEG_Freezing_turn;
band_data.Turn_EEG = overall_data_bands{1, 1}.epochData_bands_EEG_Turn;
band_data.Walk_EEG = overall_data_bands{1, 1}.epochData_bands_EEG_Walk;

% Renaming LFPL data
band_data.Freezing_turn_LFPL = overall_data_bands{1, 1}.epochData_bands_LFPL_Freezing_turn;
band_data.Turn_LFPL = overall_data_bands{1, 1}.epochData_bands_LFPL_Turn;
band_data.Walk_LFPL = overall_data_bands{1, 1}.epochData_bands_LFPL_Walk;

% Renaming LFPR data
band_data.Freezing_turn_LFPR = overall_data_bands{1, 1}.epochData_bands_LFPR_Freezing_turn;
band_data.Turn_LFPR = overall_data_bands{1, 1}.epochData_bands_LFPR_Turn;
band_data.Walk_LFPR = overall_data_bands{1, 1}.epochData_bands_LFPR_Walk;
%%
