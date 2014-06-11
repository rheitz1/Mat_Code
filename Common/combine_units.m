function [combined] = combine_units(unit1,unit2)

% Combines two Spike units that are on the same electrode
%
% RPH

combined = [unit1 unit2];
combined(find(combined == 0)) = NaN;
combined = sort(combined')';