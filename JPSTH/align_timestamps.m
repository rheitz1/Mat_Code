% ALIGN_TIMESTAMPS align signal by subtracting event timstamp from spike timestamps

% align_timestamps.m
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

function [ aligned_timestamps ] = align_timestamps( time_stamps, event)
	% set 0's and spikes outside window to NaN
	time_stamps(time_stamps==0) = NaN;
	
	% subtract event time to make all timestamps relative to this event
	aligned_timestamps = time_stamps-repmat(event(:),1,size(time_stamps,2));

	
end
