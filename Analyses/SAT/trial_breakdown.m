%Commented out; run this after establishing base trials
%getTrials_SAT

%length(med_all) + length(slow_all) + length(fast_all_withCleared)

all_used = [med_all ; slow_all ; fast_all_withCleared];


targ_hold_err = find(Errors_(:,4) == 1);
latency_err = find(Errors_(:,3) == 1);

all = [all_used ; targ_hold_err ; latency_err];


left_out = setdiff(1:size(Target_,1),all)';


Problem_Trials(:,1) = SAT_(left_out,1);
Problem_Trials(:,2) = SRT(left_out,1);
Problem_Trials(:,3) = SAT_(left_out,3);
Problem_Trials(:,4) = Correct_(left_out,2);
Problem_Trials(:,5) = Errors_(left_out,5);
Problem_Trials(:,6) = Errors_(left_out,6);
Problem_Trials(:,7) = Errors_(left_out,7);

add.slow_correct_made_dead = left_out(find(Problem_Trials(:,1) == 1 & (Problem_Trials(:,3) - Problem_Trials(:,2) < 40) & Problem_Trials(:,4) == 1));
add.fast_correct_made_dead_withCleared = left_out(find(Problem_Trials(:,1) == 3 & (Problem_Trials(:,2) - Problem_Trials(:,3) < 40) & Problem_Trials(:,4) == 0));

%disp(['Adding ' mat2str(length(add.slow_correct_made_dead)) ' trials to ACCURATE'])
%disp(['Adding ' mat2str(length(add.fast_correct_made_dead_withCleared)) ' trials to FAST'])

slow_correct_made_dead = sort([slow_correct_made_dead ; add.slow_correct_made_dead]);
slow_all_made_dead = sort([slow_all_made_dead ; add.slow_correct_made_dead]);
slow_all = sort([slow_all ; add.slow_correct_made_dead]);

fast_correct_made_dead_withCleared = sort([fast_correct_made_dead_withCleared ; add.fast_correct_made_dead_withCleared]);
fast_all_made_dead_withCleared = sort([fast_all_made_dead_withCleared ; add.fast_correct_made_dead_withCleared]);
fast_all_withCleared = sort([fast_all_withCleared ; add.fast_correct_made_dead_withCleared]);

Correct_(add.slow_correct_made_dead,2) = 1;
Correct_(add.fast_correct_made_dead_withCleared,2) = 1;

clear all_used targ_hold_err latency_err all left_out Problem_Trials add