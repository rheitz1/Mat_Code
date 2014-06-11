% JPSTH calculates jpsth for two spike counts aligned around an event

% jpsth.m
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

function [jpsth_data] = jpsth(n_1, n_2, coin_width, electrode_num1, electrode_num2)
	% Supress divideByZero warning for Eq. 9
	warning('off','MATLAB:divideByZero');
	
	%if the signal names are not input, assume the spikes were recorded on separate electrodes
	if nargin < 5, electrode_num1 = '01'; electrode_num2 = '02'; end
	
	if nargin < 3, coin_width = 10; end

	% calculate PSTH for each signal, Eq. 1 and terms for Eq. 7a
	[psth_1, psth_1_sd, psth_1_var] = JPSTH_psth(n_1);
	[psth_2, psth_2_sd, psth_2_var] = JPSTH_psth(n_2);
	
	% JPSTH Equations from Aertsen et al. 1989
	raw_jpsth = equation3(n_1, n_2);						% Eq. 3 
	psth_outer_product = psth_1(:) * psth_2(:)';			% Eq. 4
	unnormalized_jpsth = raw_jpsth - psth_outer_product;	% Eq. 5
	normalizer = psth_1_sd(:) * psth_2_sd(:)';				% Eq. 7a
	normalized_jpsth = unnormalized_jpsth ./ normalizer;	% Eq. 9
	
	% When normalizer = 0 it causes divide by zero which results in NaN
	% the following for loop replaces these NaN's with 0's
	% this occurs for discrete time points with no spikes
	normalized_jpsth(isnan(normalized_jpsth)) = 0;
	
	% analyze JPSTH
	xcorr_hist = cross_correlation_histogram(normalized_jpsth);
	
	%if pair recorded on same electrode, then negative peak on main diagonal results from recording limitations
	%to keep this from skewing pstch we need to exclude the main diag from pstch in these cases
	if strcmp(electrode_num1,electrode_num2)
		pstch = pst_coincidence_histogram(normalized_jpsth, [-coin_width:-1,1:coin_width]);
    else
        pstch = pst_coincidence_histogram(normalized_jpsth, -coin_width:coin_width);
	end
	
	[covariogram,sig_high,sig_low] = covariogram_brody(n_1,n_2,psth_1,psth_2,psth_1_var,psth_2_var);
	sig_peak_endpoints = significant_span(covariogram,sig_high);
	sig_trough_endpoints = significant_span(-covariogram,-sig_low);
	
	
	% build data structure to return from function
	jpsth_data = struct('psth_1',psth_1,'psth_2',psth_2, ...
						'normalized_jpsth',normalized_jpsth, ...
                        'unnormalized_jpsth',unnormalized_jpsth, ...
						'xcorr_hist',xcorr_hist, ...
						'pstch',pstch, ...
						'covariogram',covariogram, ...
						'sig_low',sig_low, ...
						'sig_high',sig_high, ...
						'sig_peak_endpoints',sig_peak_endpoints,...
						'sig_trough_endpoints',sig_trough_endpoints);
end	
			