% SMOOTH_HIST performs 19 point gaussian sigma 3 smoothing

% smooth_hist.m
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

function [smooth_histogram] = smooth_hist(hist_data)
	% 19 point gaussian sigma 3 smoothing
	points = 19;
	sigma = 3;
	fil=normpdf([-floor(points/2):floor(points/2)],0,sigma);
	smooth_histogram = convn(hist_data,fil,'same');
end