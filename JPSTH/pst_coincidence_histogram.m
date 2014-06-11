% PST_COINCIDENCE_HISTOGRAM calculates a psth coincidence histogram of a given width for a JPSTH

% pst_coincidence_histogram.m
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

function [pstch] = pst_coincidence_histogram(jpsth,width_vector)

	if nargin < 2, width_vector= -10:10; end

	pstch = zeros(1,size(jpsth,1));
	for i = width_vector
		pad = abs(i);
		d = diag(jpsth,i)';
		pstch(pad+1:end) = pstch(pad+1:end) + d;
	end
end