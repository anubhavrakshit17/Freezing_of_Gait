function EEG = fn_ICA_compute(EEG)
% This function checks whether the fields EEG.icaact, EEG.icawinv, EEG.icasphere,
% EEG.icaweights, and EEG.icachansind are empty in an EEGLAB EEG dataset structure,
% and runs independent component analysis (ICA) using the pop_runica function if they
% are empty.

if isempty(EEG.icaact) || isempty(EEG.icawinv) || isempty(EEG.icasphere) ...
        || isempty(EEG.icaweights) || isempty(EEG.icachansind)
    % Some or all of the ICA fields are empty, so run ICA using pop_runica
    EEG = pop_runica(EEG, 'extended', 1);
else
    disp("You already performed ICA, All ICA elements are present inside EEG");
end

end
