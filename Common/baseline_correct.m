% Baseline corrects AD signals by subtracting average over 'base_length'
% ms. NOTE THIS REQUIRES UNCORRECTED MATRIX INDICES (i.e., I do not correct
% for the 500 ms baseline here... if we have a signal of -500:2500 and we
% want a 50 ms baseline before target onset, base_window = [450 500].  If
% the signal is response aligned with -600:300 and want baseline -600:-500,
% base_window = [1 100]
%
% RPH

function [signal_out] = baseline_correct(signal_in,base_window)
disp('Baseline Correcting...')

if ndims(signal_in) < 3
    
    base = mean(signal_in(:,base_window(1):base_window(2)),2);
    base = repmat(base,1,size(signal_in,2));
    
    %matrix subtraction
    signal_out = signal_in - base;
    
    %do we have a 3-d matrix?  Do baseline correction separately for each of dimension
    % %3
    
elseif ndims(signal_in) == 3
    base = mean(signal_in(:,base_window(1):base_window(2),:),2);
    base = repmat(base,1,size(signal_in,2));
    signal_out = signal_in - base;
else
    error('Too many dimensions')
end
