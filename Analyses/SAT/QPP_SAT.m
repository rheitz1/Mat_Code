% Generates the Quantile Probability plot for SAT task
% simply sets up the variables and calls quantile_prob.m

getTrials_SAT

if length(find(SAT_(:,1) == 2)) > 0
    isMed = 1;
else
    isMed = 0;
end

x = [ [SRT(slow_correct_made_dead,1) ; SRT(slow_errors_made_dead,1)] [ones(length(slow_correct_made_dead),1) ; zeros(length(slow_errors_made_dead),1)] ];
z = [ [SRT(fast_correct_made_dead_withCleared,1) ; SRT(fast_errors_made_dead_withCleared,1)] [ones(length(fast_correct_made_dead_withCleared),1) ; zeros(length(fast_errors_made_dead_withCleared),1)] ];


if isMed
    y = [ [SRT(med_correct,1) ; SRT(med_errors,1)] [ones(length(med_correct),1) ; zeros(length(med_errors),1)] ];
    quantile_prob(x,y,z)
else
    quantile_prob(x,z)
end

clear x y z