% COVARIOGRAM_BRODY computes a covariogram of spike_1 and spike_2 at a given lag
%
% to compile enter the following command at the MATLAB Command Window
% >> mex('covariogram_brody.c')
%
% MATLAB equivalent to covariogram_brody.c listed below
%

% covariogram_brody.m
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

function [this_covariogram, sig_high, sig_low] = covariogram_brody(spike_1, spike_2, p1, p2, s1, s2, lag)
    % warn user that they should use compiled version
    warning('JPSTH:compileMex', ...
    		['You are using the MATLAB version of covariogram_brody()\n' ...
				'For better performance please compile covariogram_brody.c with this command: mex(\''covariogram_brody.c\'')']);

	if nargin < 7 lag = 50; end
	
	trials = size(spike_1,1);
	trial_length =  size(spike_1,2);
		
	s1s2 = zeros(1,2*lag+1);
	p1s2 = zeros(1,2*lag+1);
	s1p2 = zeros(1,2*lag+1);
	xcorr =  zeros(1, 2*lag+1);
	shuffle_corrector = zeros(1,2*lag+1);
	
	for i = 1:2*lag+1
		current_lag = i - lag - 1;
		
		if current_lag < 0 
			j_vector = 1-current_lag:trial_length;
		else 
			j_vector = 1:trial_length-current_lag; 
		end
		
		for j = j_vector
			xcorr(i) = xcorr(i) + mean(spike_1(:,j) .* spike_2(:,j+current_lag));
			shuffle_corrector(i) = shuffle_corrector(i) + p1(j) * p2(j+current_lag);
			s1s2(i) = s1s2(i) + s1(j) * s2(j+current_lag);
			p1s2(i) = p1s2(i) + p1(j) * s2(j+current_lag);
			s1p2(i) = s1p2(i) + s1(j) * p2(j+current_lag);
		end
	end
	
	this_covariogram = xcorr - shuffle_corrector;
	
	sigma = sqrt((s1s2 + p1s2 + s1p2)/trials);
	sig_high = 2 * sigma;
	sig_low = -2 * sigma;
end
