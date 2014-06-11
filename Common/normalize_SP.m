% normalizes SDF matrix to max of MEAN SDF across all trials.
%
% each trial value is thus a proportion of the mean
%
% REQUIRES SDF, not raw spike channels
%
% WINDOW not in real-time; WINDOW is column IDs


function [normalized weight] = normalize_SP(SDF,window)

if nargin < 2; window = [1 size(SDF,2)]; end

if ~isvector(SDF)
%     weight = max(Spike(:,window(1):window(2)),[],2);
%     weight = repmat(weight,1,size(Spike,2));
%     normalized = Spike ./weight;

      weight = max(nanmean(SDF(:,window(1):window(2))));
      normalized = SDF ./ weight;
else %weight by reciprocal of peak firing rate of vector
    normalized = SDF ./ max(SDF);
end