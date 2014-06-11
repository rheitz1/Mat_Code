% cond = congruent Flanker (1) / incongruent flanker (2)
% evaldead = was deadline made (2) or missed (1)
% dead = SAT condition (1) = Slow (2) = Med (3) = Fast

cd '/volumes/Dump/Analyses/Dissertation_Data/'
load exp2.mat

slow_correct_made_dead = find(correct == 1 & evaldead == 2 & cond == 1 & dead(:,2) == 1);
slow_errors_made_dead = find(correct == 0 & evaldead == 2 & cond == 1 & dead(:,2) == 1);

med_correct = find(correct == 1 & evaldead == 2 & cond == 1 & dead(:,2) == 2);
med_errors = find(correct == 0 & evaldead == 2 & cond == 1 & dead(:,2) == 2);

fast_correct_made_dead_withCleared = find(correct == 1 & evaldead == 2 & cond == 1 & dead(:,2) == 3);
fast_errors_made_dead_withCleared = find(correct == 0 & evaldead == 2 & cond == 1 & dead(:,2) == 3);


slow_correct_missed_dead = find(correct == 1 & evaldead == 1 & cond == 1 & dead(:,2) == 1);
slow_errors_missed_dead = find(correct == 0 & evaldead == 1 & cond == 1 & dead(:,2) == 1);
 
med_correct = find(correct == 1 & evaldead == 1 & cond == 1 & dead(:,2) == 2);
med_errors = find(correct == 0 & evaldead == 1 & cond == 1 & dead(:,2) == 2);
 
fast_correct_missed_dead_withCleared = find(correct == 1 & evaldead == 1 & cond == 1 & dead(:,2) == 3);
fast_errors_missed_dead_withCleared = find(correct == 0 & evaldead == 1 & cond == 1 & dead(:,2) == 3);


slow_correct_made_missed = [slow_correct_made_dead ; slow_correct_missed_dead];
slow_errors_made_missed = [slow_errors_made_dead ; slow_errors_missed_dead];

fast_correct_made_missed_withCleared = [fast_correct_made_dead_withCleared ; fast_correct_missed_dead_withCleared];
fast_errors_made_missed_withCleared = [fast_errors_made_dead_withCleared ; fast_errors_missed_dead_withCleared];


fitLBA_SAT_Dissertation([1 3 1 1],1)

%fitLBA_SAT_Dissertation([3 3 3 3],1)