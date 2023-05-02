function ica_scalp_maps = compute_ICA_scalp_maps(EEG, num_components)
% Computes the ICA component scalp maps and plots them for each component
% Inputs:
% - EEG: a structure containing the EEG data
% - num_components: the number of ICA components to plot
%
% Output:
% - ica_scalp_maps: a matrix of the ICA component scalp maps

% Compute ICA component scalp maps
ica_scalp_maps = EEG.icawinv * EEG.icasphere * EEG.icaweights;

% Plot topographic maps for each component
for i = 1:num_components
    figure;
    topoplot(ica_scalp_maps(:, i), EEG.chanlocs);
    caxis([-max(abs(ica_scalp_maps(:,i))) max(abs(ica_scalp_maps(:,i)))]);
    title(sprintf('ICA Component %d', i));
end

end
