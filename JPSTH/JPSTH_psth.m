% PSTH computes the PSTH of a single spike train
% Equations from Aertsen et al. 1989
% psth_:		Equation 1
% psth_std:		for Equation 7a
% psth_var:		for Brody Covariogram

% psth.m
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

function [psth_, psth_std, psth_var] = psth(spike_counts)
	
	% take the mean, standard deviation, and variance from the spike count
	psth_ = mean(spike_counts);
	psth_std = std(spike_counts);
	psth_var = var(spike_counts);
end
