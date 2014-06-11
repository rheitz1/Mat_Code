%finds onset time of a function by successive linear regressions
% compute linear regression using all possible intervals (stepped by 5 ms).
% keep track of the fit r^2, the slope m, and the length of the regressed
% vector.
% we want to maximize all three - the best fitting line with the steepest
% (positive) slope with the longest vector length.

% so we create a composite variable of these three and find the maximum.
% the onset time is the start point of that one regression that maximizes
% the composite.

function [onset_index] = change_point(sig,plotFlag)

if nargin < 2; plotFlag = 0; end

%smooth with low-pass filter
if size(sig,1) > 1; error('Only vector input is accepted'); end
  

%BUILD IN BASELINE PERIOD CRITERION -- MUST PASS ABOVE!!

sig = filtSig(sig,50,'lowpass');

y = sig;
x = 1:length(sig);

% what is the maximum length of vector to consider?
max_length = 100;
min_length = 0; %very small == functionally off

startP = 0;
endP = length(x);
iter = 0;

while startP < length(x)-5
    endP = length(x); %re-set stopping point to end of array and start again
    startP = startP + 5;
    while endP > startP + 5
        iter = iter + 1;
        curr_segment_x = x(startP:endP);
        curr_segment_y = y(startP:endP);
        
        [m b R] = linear_regression(curr_segment_y,curr_segment_x);
        
        
        results.time(iter,1) = startP;%-(b / m); %solve for x-intercept (onset time)
        results.endP(iter,1) = endP;
        results.m(iter,1) = m;
        results.b(iter,1) = b;
        results.R(iter,1) = R;
        results.length(iter,1) = length(startP:endP);
        
        endP = endP-5;
    end
end




%we want to use only regressions with positive slopes, so set all others to
%NaN

results.time(find(results.m <= 0)) = NaN;
results.endP(find(results.endP <=0)) = NaN;
results.m(find(results.m <= 0)) = NaN;
results.b(find(results.m <= 0)) = NaN;
results.R(find(results.m <= 0)) = NaN;
results.length(find(results.length <= 0)) = NaN;


%now remove any segments > x ms wide because those aren't sharp enough
results.time(find(results.length > max_length | results.length < min_length)) = NaN;
results.m(find(results.length > max_length | results.length < min_length)) = NaN;
results.b(find(results.length > max_length | results.length < min_length)) = NaN;
results.r(find(results.length > max_length | results.length < min_length)) = NaN;
results.length(find(results.length > max_length | results.length < min_length)) = NaN;

%create composite variable
composite = results.m .* results.R .* results.length;

[mval mdex] = max(composite);
onset_index = results.time(mdex);

if plotFlag
    if ~isnan(onset_index)
        fig
        plot(sig)
        hold on
        plot(x(results.time(mdex):results.endP(mdex)),y(results.time(mdex):results.endP(mdex)),'r')
    else
        disp('NaN index...supressing plot')
    end
end