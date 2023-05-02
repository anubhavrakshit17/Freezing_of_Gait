function EEG = fn_import(filename)
%SensesFOG - Load or convert EEG data from .set file

% Check if the file exists in the set_files folder
set_folder = 'SenseFOG/.set_files/';
set_file = [set_folder, filename];

if exist(set_file, 'file') == 2
    % If the file exists, load it using EEGLAB's pop_loadset function
    disp("The file already exists.");
    
    EEG = pop_loadset(set_file);
    disp("The set file is loaded."); 
    eeglab;
else
    % If the file does not exist, convert the data from the original files
    eeg_filename= input('Input the filename from SenseFOG/EEGData folder including "" : ');
    chanlocs_file = 'Standard-10-20-48chan.locs';
    EEG = fn_convert_to_eeglab(eeg_filename, chanlocs_file,filename);
    eeglab;
end

end
