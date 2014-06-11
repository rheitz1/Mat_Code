% Calculates confidence interval width of a vector based on t distribution n-1 df
%
% NOTE: this should not be used as a substitute for actual independent samples t-tests, because you'll 
% need the pooled variance!!
%
% RPH

function [ci_width] = ci(data)


%First get SEM. Compute here instead of using function to ensure we've removed all NaNs
if ~isvector(data); error('Not a vector'); end

if length(find(isnan(data))) > 0
    disp(['Removing ' mat2str(length(find(isnan(data)))) ' NaNs'])
    data = removeNaN(data);
end


SEM = std(data) / sqrt(length(data));


% Find the critical t, two-tailed, with a 95% rejection region (so 97.5% on either side)
t_crit = tinv(.975,length(data)-1);

ci_width = t_crit * SEM;

disp(['95% CI: [' mat2str(round((mean(data)-ci_width)*100)/100) ',' mat2str(round((mean(data)+ci_width)*100)/100) ']'])