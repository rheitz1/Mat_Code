% SIMULATE_SPIKE_TRAIN accepts a psth and generates a spike train with a given number of trials

% simulate_spike_train.m
% 
% Copyright 2008 Vanderbilt University.  All rights reserved.
% John Haitas, Jeremiah Cohen, and Jeff Schall
% 
% This file is part of JPSTH Toolbox.
% 
% JPSTH Toolbox is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

% JPSTH Toolbox is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with JPSTH Toolbox.  If not, see <http://www.gnu.org/licenses/>.

function [spike_train] = simulate_spike_train(psth, trials, time_window, binwidth)
        
        indices = zeros(trials, length(psth));
        
        for i = 1:trials
                random_values = rand(1,length(psth));
                spike_times = find((random_values-psth)<=0);
                if ~isempty(spike_times)
                        indices(i,1:length(spike_times))=spike_times;
                end
        end
        
        % remove 0 values and replace with NaN
    indices(indices==0) = NaN;

        % shift time stamps back from index values
        time_stamps = (indices * binwidth) + time_window(1) - 1;
        
        % convert timestamps into a spike train
        spike_train = spike_counts(time_stamps, time_window, binwidth);
end
