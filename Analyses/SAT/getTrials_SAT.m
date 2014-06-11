% Returns vectors of relevant trial types and ntiles for SAT experiment
% I highly advise that this routine be called by all parent SAT routines to avoid coding errors.  Task
% coding is very complex, and there is a high potential for problems.  If it is correct here, it will be
% correct (and consistent) in all other routines.
%
% RPH
%
% Notes:
% (1) To evaluate deadlines, find SRT <> SAT_(:,3), which holds the explicit deadline for that trial.  Note
%     that this will occassionally lead to a coding error, because Tempo's timing is off relative to our SRT
%     values.  Typically, the number of trials is small. To evaluate all trials that were uncategorized, use
%     file 'trial_breakdown.m'
%
% (2) Due to the way the SAT task was coded in Tempo, the variable Correct_ is not accurate for missed
%     deadline trials.  It will always record a 0, because no reward was provided. This script fixes
%     that.
%     Errors column 6 = Correct but too fast in SLOW
%     Errors column 7 = Correct but too slow in FAST
%
% (3) RT quantiles are computed separately for each condition of correct, errors, made deadline, and
%     missed deadline.  This is done because we usually want to compare quantiles within a condition.

%

% 7/24/2013: NEW VERSION:
% Takes into account trials where SRT was right at the boundary of the
% deadlines, and Tempo did not code it properly.  Adds those trials back
% in.
%
slow_correct_made_dead = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
slow_correct_missed_dead = find(Target_(:,2) ~= 255 & Errors_(:,6) == 1 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
slow_correct_made_missed = [slow_correct_made_dead ; slow_correct_missed_dead];

slow_errors_made_dead = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
slow_errors_missed_dead = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & isnan(Errors_(:,6)) == 1 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
slow_errors_made_missed = [slow_errors_made_dead ; slow_errors_missed_dead];

slow_all_made_dead = [slow_correct_made_dead ; slow_errors_made_dead];
slow_all_missed_dead = [slow_correct_missed_dead ; slow_errors_missed_dead];
slow_all = [slow_all_made_dead ; slow_all_missed_dead];


med_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SAT_(:,1) == 2);
med_errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SAT_(:,1) == 2);
med_all = [med_correct ; med_errors];

fast_correct_made_dead_withCleared = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
fast_correct_missed_dead_withCleared = find(Target_(:,2) ~= 255 & Errors_(:,7) == 1 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
fast_correct_made_missed_withCleared = [fast_correct_made_dead_withCleared ; fast_correct_missed_dead_withCleared];
fast_errors_made_dead_withCleared = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
fast_errors_missed_dead_withCleared = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & isnan(Errors_(:,7)) == 1 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
fast_errors_made_missed_withCleared = [fast_errors_made_dead_withCleared ; fast_errors_missed_dead_withCleared];
fast_all_made_dead_withCleared = [fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared];
fast_all_missed_dead_withCleared = [fast_correct_missed_dead_withCleared ; fast_errors_missed_dead_withCleared];
fast_all_withCleared = [fast_all_made_dead_withCleared ; fast_all_missed_dead_withCleared];

fast_correct_made_dead_noCleared = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);
fast_correct_missed_dead_noCleared = find(Target_(:,2) ~= 255 & Errors_(:,7) == 1 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3) & SAT_(:,11) == 0);
fast_correct_made_missed_noCleared = [fast_correct_made_dead_noCleared ; fast_correct_missed_dead_noCleared];
fast_errors_made_dead_noCleared = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);
fast_errors_missed_dead_noCleared = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & isnan(Errors_(:,7)) == 1 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3) & SAT_(:,11) == 0);
fast_errors_made_missed_noCleared = [fast_errors_made_dead_noCleared ; fast_errors_missed_dead_noCleared];
fast_all_made_dead_noCleared = [fast_correct_made_dead_noCleared ; fast_errors_made_dead_noCleared];
fast_all_missed_dead_noCleared = [fast_correct_missed_dead_noCleared ; fast_errors_missed_dead_noCleared];
fast_all_noCleared = [fast_all_made_dead_noCleared ; fast_all_missed_dead_noCleared];



%=============================
% DEAL WITH TARGET HOLD ERRORS
slow_errors_made_dead_targHold = find(Target_(:,2) ~= 255 & Errors_(:,4) == 1 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
slow_errors_missed_dead_targHold = find(Target_(:,2) ~= 255 & Errors_(:,4) == 1 & isnan(Errors_(:,6)) == 1 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
slow_all_withTargHold = [slow_all_made_dead ; slow_all_missed_dead ; slow_errors_made_dead_targHold ; slow_errors_missed_dead_targHold];

med_errors_targHold = find(Target_(:,2) ~= 255 & Errors_(:,4) == 1 & SAT_(:,1) == 2);
med_all_withTargHold = [med_correct ; med_errors ; med_errors_targHold];

fast_errors_made_dead_withCleared_targHold = find(Target_(:,2) ~= 255 & Errors_(:,4) == 1 & isnan(Errors_(:,7)) == 1 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
fast_errors_missed_dead_withCleared_targHold = find(Target_(:,2) ~= 255 & Errors_(:,4) == 1 & isnan(Errors_(:,7)) == 1 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
fast_all_withCleared_withTargHold = [fast_all_made_dead_withCleared ; fast_all_missed_dead_withCleared ; fast_errors_made_dead_withCleared_targHold ; fast_errors_missed_dead_withCleared_targHold];


slow_NOID = setdiff(find(SAT_(:,1) == 1),slow_all_withTargHold);
med_NOID = setdiff(find(SAT_(:,1) == 2),med_all_withTargHold);
fast_NOID = setdiff(find(SAT_(:,1) == 3),fast_all_withCleared_withTargHold);

% fprintf(2,['# Unidentified ACCURATE trials = ' mat2str(length(slow_NOID)) '\n'])
% fprintf(2,['# Unidentified NEUTRAL trials = ' mat2str(length(med_NOID)) '\n'])
% fprintf(2,['# Unidentified FAST trials = ' mat2str(length(fast_NOID)) '\n'])
%=======================================================================================================
% RT BINS within condition
% binFAST: X <= 33%
% binMED:  X > 33% & X <= 66%
% binSLOW: X > 66%

ntile.slow_correct_made_dead.n33 = prctile(SRT(slow_correct_made_dead,1),33);
ntile.slow_correct_made_dead.n66 = prctile(SRT(slow_correct_made_dead,1),66);
ntile.slow_correct_missed_dead.n33 = prctile(SRT(slow_correct_missed_dead,1),33);
ntile.slow_correct_missed_dead.n66 = prctile(SRT(slow_correct_missed_dead,1),66);
ntile.slow_errors_made_dead.n33 = prctile(SRT(slow_errors_made_dead,1),33);
ntile.slow_errors_made_dead.n66 = prctile(SRT(slow_errors_made_dead,1),66);
ntile.slow_errors_missed_dead.n33 = prctile(SRT(slow_errors_missed_dead,1),33);
ntile.slow_errors_missed_dead.n66 = prctile(SRT(slow_errors_missed_dead,1),66);

ntile.med_correct.n33 = prctile(SRT(med_correct,1),33);
ntile.med_correct.n66 = prctile(SRT(med_correct,1),66);
ntile.med_errors.n33 = prctile(SRT(med_errors,1),33);
ntile.med_errors.n66 = prctile(SRT(med_errors,1),66);

ntile.fast_correct_made_dead_withCleared.n33 = prctile(SRT(fast_correct_made_dead_withCleared,1),33);
ntile.fast_correct_made_dead_withCleared.n66 = prctile(SRT(fast_correct_made_dead_withCleared,1),66);
ntile.fast_correct_missed_dead_withCleared.n33 = prctile(SRT(fast_correct_missed_dead_withCleared,1),33);
ntile.fast_correct_missed_dead_withCleared.n66 = prctile(SRT(fast_correct_missed_dead_withCleared,1),66);
ntile.fast_errors_made_dead_withCleared.n33 = prctile(SRT(fast_errors_made_dead_withCleared,1),33);
ntile.fast_errors_made_dead_withCleared.n66 = prctile(SRT(fast_errors_made_dead_withCleared,1),66);
ntile.fast_errors_missed_dead_withCleared.n33 = prctile(SRT(fast_errors_missed_dead_withCleared,1),33);
ntile.fast_errors_missed_dead_withCleared.n66 = prctile(SRT(fast_errors_missed_dead_withCleared,1),66);

% ntile.fast_correct_made_dead_noCleared.n33 = prctile(SRT(fast_correct_made_dead_noCleared,1),33);
% ntile.fast_correct_made_dead_noCleared.n66 = prctile(SRT(fast_correct_made_dead_noCleared,1),66);
% ntile.fast_correct_missed_dead_noCleared.n33 = prctile(SRT(fast_correct_missed_dead_noCleared,1),33);
% ntile.fast_correct_missed_dead_noCleared.n66 = prctile(SRT(fast_correct_missed_dead_noCleared,1),66);
% ntile.fast_errors_made_dead_noCleared.n33 = prctile(SRT(fast_errors_made_dead_noCleared,1),33);
% ntile.fast_errors_made_dead_noCleared.n66 = prctile(SRT(fast_errors_made_dead_noCleared,1),66);
% ntile.fast_errors_missed_dead_noCleared.n33 = prctile(SRT(fast_errors_missed_dead_noCleared,1),33);
% ntile.fast_errors_missed_dead_noCleared.n66 = prctile(SRT(fast_errors_missed_dead_noCleared,1),66);
 
 

% Match percentiles with trials.  Use 'intersect' to avoid re-typing everything from above.
slow_correct_made_dead_binFAST = intersect(find(SRT(:,1) <= ntile.slow_correct_made_dead.n33),slow_correct_made_dead);
slow_correct_made_dead_binMED = intersect(find(SRT(:,1) > ntile.slow_correct_made_dead.n33 & SRT(:,1) <= ntile.slow_correct_made_dead.n66),slow_correct_made_dead);
slow_correct_made_dead_binSLOW = intersect(find(SRT(:,1) > ntile.slow_correct_made_dead.n66),slow_correct_made_dead);
slow_correct_missed_dead_binFAST = intersect(find(SRT(:,1) <= ntile.slow_correct_missed_dead.n33),slow_correct_missed_dead);
slow_correct_missed_dead_binMED = intersect(find(SRT(:,1) > ntile.slow_correct_missed_dead.n33 & SRT(:,1) <= ntile.slow_correct_missed_dead.n66),slow_correct_missed_dead);
slow_correct_missed_dead_binSLOW = intersect(find(SRT(:,1) > ntile.slow_correct_missed_dead.n66),slow_correct_missed_dead);
slow_errors_made_dead_binFAST = intersect(find(SRT(:,1) <= ntile.slow_errors_made_dead.n33),slow_errors_made_dead);
slow_errors_made_dead_binMED = intersect(find(SRT(:,1) > ntile.slow_errors_made_dead.n33 & SRT(:,1) <= ntile.slow_errors_made_dead.n66),slow_errors_made_dead);
slow_errors_made_dead_binSLOW = intersect(find(SRT(:,1) > ntile.slow_errors_made_dead.n66),slow_errors_made_dead);
slow_errors_missed_dead_binFAST = intersect(find(SRT(:,1) <= ntile.slow_errors_missed_dead.n33),slow_errors_missed_dead);
slow_errors_missed_dead_binMED = intersect(find(SRT(:,1) > ntile.slow_errors_missed_dead.n33 & SRT(:,1) <= ntile.slow_errors_missed_dead.n66),slow_errors_missed_dead);
slow_errors_missed_dead_binSLOW = intersect(find(SRT(:,1) > ntile.slow_errors_missed_dead.n66),slow_errors_missed_dead);

med_correct_binFAST = intersect(find(SRT(:,1) <= ntile.med_correct.n33),med_correct);
med_correct_binMED = intersect(find(SRT(:,1) > ntile.med_correct.n33 & SRT(:,1) <= ntile.med_correct.n66),med_correct);
med_correct_binSLOW = intersect(find(SRT(:,1) > ntile.med_correct.n66),med_correct);
med_errors_binFAST = intersect(find(SRT(:,1) <= ntile.med_errors.n33),med_errors);
med_errors_binMED = intersect(find(SRT(:,1) > ntile.med_errors.n33 & SRT(:,1) <= ntile.med_errors.n66),med_errors);
med_errors_binSLOW = intersect(find(SRT(:,1) > ntile.med_errors.n66),med_errors);

fast_correct_made_dead_withCleared_binFAST = intersect(find(SRT(:,1) <= ntile.fast_correct_made_dead_withCleared.n33),fast_correct_made_dead_withCleared);
fast_correct_made_dead_withCleared_binMED = intersect(find(SRT(:,1) > ntile.fast_correct_made_dead_withCleared.n33 & SRT(:,1) <= ntile.fast_correct_made_dead_withCleared.n66),fast_correct_made_dead_withCleared);
fast_correct_made_dead_withCleared_binSLOW = intersect(find(SRT(:,1) > ntile.fast_correct_made_dead_withCleared.n66),fast_correct_made_dead_withCleared);
fast_correct_missed_dead_withCleared_binFAST = intersect(find(SRT(:,1) <= ntile.fast_correct_missed_dead_withCleared.n33),fast_correct_missed_dead_withCleared);
fast_correct_missed_dead_withCleared_binMED = intersect(find(SRT(:,1) > ntile.fast_correct_missed_dead_withCleared.n33 & SRT(:,1) <= ntile.fast_correct_missed_dead_withCleared.n66),fast_correct_missed_dead_withCleared);
fast_correct_missed_dead_withCleared_binSLOW = intersect(find(SRT(:,1) > ntile.fast_correct_missed_dead_withCleared.n66),fast_correct_missed_dead_withCleared);
fast_errors_made_dead_withCleared_binFAST = intersect(find(SRT(:,1) <= ntile.fast_errors_made_dead_withCleared.n33),fast_errors_made_dead_withCleared);
fast_errors_made_dead_withCleared_binMED = intersect(find(SRT(:,1) > ntile.fast_errors_made_dead_withCleared.n33 & SRT(:,1) <= ntile.fast_errors_made_dead_withCleared.n66),fast_errors_made_dead_withCleared);
fast_errors_made_dead_withCleared_binSLOW = intersect(find(SRT(:,1) > ntile.fast_errors_made_dead_withCleared.n66),fast_errors_made_dead_withCleared);
fast_errors_missed_dead_withCleared_binFAST = intersect(find(SRT(:,1) <= ntile.fast_errors_missed_dead_withCleared.n33),fast_errors_missed_dead_withCleared);
fast_errors_missed_dead_withCleared_binMED = intersect(find(SRT(:,1) > ntile.fast_errors_missed_dead_withCleared.n33 & SRT(:,1) <= ntile.fast_errors_missed_dead_withCleared.n66),fast_errors_missed_dead_withCleared);
fast_errors_missed_dead_withCleared_binSLOW = intersect(find(SRT(:,1) > ntile.fast_errors_missed_dead_withCleared.n66),fast_errors_missed_dead_withCleared);

% fast_correct_made_dead_noCleared_binFAST = intersect(find(SRT(:,1) <= ntile.fast_correct_made_dead_noCleared.n33),fast_correct_made_dead_noCleared);
% fast_correct_made_dead_noCleared_binMED = intersect(find(SRT(:,1) > ntile.fast_correct_made_dead_noCleared.n33 & SRT(:,1) <= ntile.fast_correct_made_dead_noCleared.n66),fast_correct_made_dead_noCleared);
% fast_correct_made_dead_noCleared_binSLOW = intersect(find(SRT(:,1) > ntile.fast_correct_made_dead_noCleared.n66),fast_correct_made_dead_noCleared);
% fast_correct_missed_dead_noCleared_binFAST = intersect(find(SRT(:,1) <= ntile.fast_correct_missed_dead_noCleared.n33),fast_correct_missed_dead_noCleared);
% fast_correct_missed_dead_noCleared_binMED = intersect(find(SRT(:,1) > ntile.fast_correct_missed_dead_noCleared.n33 & SRT(:,1) <= ntile.fast_correct_missed_dead_noCleared.n66),fast_correct_missed_dead_noCleared);
% fast_correct_missed_dead_noCleared_binSLOW = intersect(find(SRT(:,1) > ntile.fast_correct_missed_dead_noCleared.n66),fast_correct_missed_dead_noCleared);
% fast_errors_made_dead_noCleared_binFAST = intersect(find(SRT(:,1) <= ntile.fast_errors_made_dead_noCleared.n33),fast_errors_made_dead_noCleared);
% fast_errors_made_dead_noCleared_binMED = intersect(find(SRT(:,1) > ntile.fast_errors_made_dead_noCleared.n33 & SRT(:,1) <= ntile.fast_errors_made_dead_noCleared.n66),fast_errors_made_dead_noCleared);
% fast_errors_made_dead_noCleared_binSLOW = intersect(find(SRT(:,1) > ntile.fast_errors_made_dead_noCleared.n66),fast_errors_made_dead_noCleared);
% fast_errors_missed_dead_noCleared_binFAST = intersect(find(SRT(:,1) <= ntile.fast_errors_missed_dead_noCleared.n33),fast_errors_missed_dead_noCleared);
% fast_errors_missed_dead_noCleared_binMED = intersect(find(SRT(:,1) > ntile.fast_errors_missed_dead_noCleared.n33 & SRT(:,1) <= ntile.fast_errors_missed_dead_noCleared.n66),fast_errors_missed_dead_noCleared);
% fast_errors_missed_dead_noCleared_binSLOW = intersect(find(SRT(:,1) > ntile.fast_errors_missed_dead_noCleared.n66),fast_errors_missed_dead_noCleared);



% Find MEDIUM (Neutral) trials that match mean RT +- 1 sd for the Accurate and Fast conditions
RT_range.slow(1) = nanmean(SRT(slow_correct_made_dead,1)) - nanstd(SRT(slow_correct_made_dead,1));
RT_range.slow(2) = nanmean(SRT(slow_correct_made_dead,1)) + nanstd(SRT(slow_correct_made_dead,1));
RT_range.fast(1) = nanmean(SRT(fast_correct_made_dead_withCleared,1)) - nanstd(SRT(fast_correct_made_dead_withCleared,1));
RT_range.fast(2) = nanmean(SRT(fast_correct_made_dead_withCleared,1)) + nanstd(SRT(fast_correct_made_dead_withCleared,1));

med_correct_match_slow = intersect(med_correct,find(SRT(:,1) >= RT_range.slow(1) & SRT(:,1) <= RT_range.slow(2)));
med_correct_match_fast = intersect(med_correct,find(SRT(:,1) >= RT_range.fast(1) & SRT(:,1) <= RT_range.fast(2)));
med_correct_nomatch = intersect(med_correct,find(SRT(:,1) > RT_range.fast(2) & SRT(:,1) < RT_range.slow(1)));

%now create medium trials that not only do not match Fast and Accurate RTs, but have very small
%variability
RT_range_med_nomatch(1) = nanmean(SRT(med_correct_nomatch),1) - nanstd(SRT(med_correct_nomatch,1));
RT_range_med_nomatch(2) = nanmean(SRT(med_correct_nomatch),1) + nanstd(SRT(med_correct_nomatch,1));

med_correct_nomatch_small_sd = intersect(med_correct_nomatch,find(SRT(:,1) >= RT_range_med_nomatch(1) & SRT(:,1) <= RT_range_med_nomatch(2)));


% Find ACCURATE (slow) trials that match median RT +- 1 sd for the Medium (neutral) condition
RT_range.med(1) = nanmedian(SRT(med_correct,1)) - nanstd(SRT(med_correct,1));
RT_range.med(2) = nanmedian(SRT(med_correct,1)) + nanstd(SRT(med_correct,1));

fast_correct_match_med = intersect(fast_correct_made_missed_withCleared,find(SRT(:,1) >= RT_range.med(1) & SRT(:,1) <= RT_range.med(2)));
med_correct_match_med = intersect(med_correct,find(SRT(:,1) >= RT_range.med(1) & SRT(:,1) <= RT_range.med(2)));
slow_correct_match_med = intersect(slow_correct_made_missed,find(SRT(:,1) >= RT_range.med(1) & SRT(:,1) <= RT_range.med(2)));


% Find Target Hold Errors on FAST trials with cleared displays, set to
% correct on MISSED DEADLINES
% addto = find(Errors_(:,4) == 1 & SAT_(:,1) == 3 & SAT_(:,11) == 1);
% disp(length(addto))
% fast_correct_missed_dead_withCleared = [fast_correct_missed_dead_withCleared ; addto];

%RPH 5/7/13
% NOTE: IF YOU ARE TRYING TO NUMERICALLY REPLICATE HEITZ & SCHALL 2013, YOU NEED TO COMMENT OUT THE BELOW
trial_breakdown %this also adds back in marginally undefined trials VERY IMPORTANT!!(see comments)