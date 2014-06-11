clear Trial_Mat remove*
%starting values
% We will assume that T0 is identical between all accumulator units. Do not see a rason why that should
% not be the case.  Additionally, we will first try to also fix b between accumulator units but allow it
% to vary between SAT conditions.  So b and T0 should be more 'cognitive' and 'motor' factors and not
% vary by accumulator.  Bias (A) could change, as could drift rate (v), so these will vary between screen
% locations and SAT conditions


%This version assumes equal drift rates, biases, and boundaries for all screen positions.  This boils the
%model down into a 2AFC condition
minimize = 1; %if set to 0, returns fit statistics and plots using starting values
made_dead_only = 1; %if set to 0, includes all trials irregardless of made/missed deadlines
include_med = 1; %if set to 0, fits only fast and slow conditions.  Fits will be different when MED included
truncate_IQR = 1; %if set to 0, no truncation of SRT distributions
truncval = 1.5;


%FIRST PASS, ACCURATE CONDITION ONLY
% A(1:3,1:8) = .01;
% v(1:3,1:8) = .55;
% b(1:3) = 100;
% T0(1:3) = 100;
% s = .1;
% 
% lb.A(1:3,1:8) = 0;
% lb.v(1:3,1:8) = .5;
% lb.b(1:3) = 0;
% lb.T0(1:3) = 50;
% 
% ub.A(1:3,1:8) = 500;
% ub.v(1:3,1:8) = 1;
% ub.b(1:3) = 500;
% ub.T0(1:3) = 800;
% 
A(1:8) = .01;
v(1:8) = .55;
b(1:8) = 100;
T0(1) = 100;
s = .1;

lb.A(1:8) = 0;
lb.v(1:8) = .5;
lb.b(1:8) = 0;
lb.T0(1) = 50;

ub.A(1:8) = 500;
ub.v(1:8) = 1;
ub.b(1:8) = 500;
ub.T0(1) = 800;



getTrials_SAT
if made_dead_only
    disp('Made Deadline Only')
    % Clean up RT distributions: remove 1.5 * IQR

    if truncate_IQR
        disp(['Truncating ' mat2str(truncval) ' * IQR'])
        highcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) + truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
        lowcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) - truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
        highcut_med = nanmedian(SRT([med_correct ; med_errors],1)) + truncval * iqr(SRT([med_correct ; med_errors],1));
        lowcut_med = nanmedian(SRT([med_correct ; med_errors],1)) - truncval * iqr(SRT([med_correct ; med_errors],1));
        highcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) + truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
        lowcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
        
        
        %Second Pass
        med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        
        %All correct trials w/ made deadlines
        slow_correct = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        fast_correct_withCleared = intersect(fast_correct_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        slow_errors = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        fast_errors_withCleared = intersect(fast_errors_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
    end
    
    
else
    disp('Made + Missed Deadlines')
    %First Pass

    if truncate_IQR
        disp(['Truncating ' mat2str(truncval) ' * IQR'])
        highcut_slow = nanmedian(SRT([slow_correct_made_missed ; slow_errors_made_missed],1)) + truncval * iqr(SRT([slow_correct_made_missed ; slow_errors_made_missed],1));
        lowcut_slow = nanmedian(SRT([slow_correct_made_missed ; slow_errors_made_missed],1)) - truncval * iqr(SRT([slow_correct_made_missed ; slow_errors_made_missed],1));
        highcut_med = nanmedian(SRT([med_correct ; med_errors],1)) + truncval * iqr(SRT([med_correct ; med_errors],1));
        lowcut_med = nanmedian(SRT([med_correct ; med_errors],1)) - truncval * iqr(SRT([med_correct ; med_errors],1));
        highcut_fast = nanmedian(SRT([fast_correct_made_missed_withCleared ; fast_errors_made_missed_withCleared],1)) + truncval * iqr(SRT([fast_correct_made_missed_withCleared ; fast_errors_made_missed_withCleared],1));
        lowcut_fast = nanmedian(SRT([fast_correct_made_missed_withCleared ; fast_errors_made_missed_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_missed_withCleared ; fast_errors_made_missed_withCleared],1));
        
        
        %Second Pass
        med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        
        slow_correct = intersect(slow_correct_made_missed,find(SRT(:,1) < highcut_slow & SRT(:,1) > lowcut_slow));
        fast_correct_withCleared = intersect(fast_correct_made_missed_withCleared,find(SRT(:,1) < highcut_fast & SRT(:,1) > lowcut_fast));
        slow_errors = intersect(slow_errors_made_missed,find(SRT(:,1) < highcut_slow & SRT(:,1) > lowcut_slow));
        fast_errors_withCleared = intersect(fast_errors_made_missed_withCleared,find(SRT(:,1) < highcut_fast & SRT(:,1) > lowcut_fast));

    end
    
    %FIX CORRECT_ VARIABLE FOR MISSED DEADLINES THAT WERE ACTUALLY CORRECT
    Correct_(slow_correct_missed_dead,2) = 1;
    Correct_(fast_correct_missed_dead_withCleared,2) = 1;
end







%FORMAT:
% TARGET LOC  |  ACTUAL LOC (WINNING UNIT)  |  CORRECT/ERR   |  RT | SetSize
% % % % % % % % % % if include_med
% % % % % % % % % %     valid_trials = [slow_correct ; fast_correct_withCleared ; slow_errors ; fast_errors_withCleared ; med_correct ; med_errors];
% % % % % % % % % % else
% % % % % % % % % %     valid_trials = [slow_correct ; fast_correct_withCleared ; slow_errors ; fast_errors_withCleared];
% % % % % % % % % % end

valid_trials = [med_correct ; med_errors];


Trial_Mat(:,1) = Target_(valid_trials,2);
Trial_Mat(:,2) = NaN; %LEGACY
Trial_Mat(:,3) = Correct_(valid_trials,2);
Trial_Mat(:,4) = SRT(valid_trials,1);
Trial_Mat(:,5) = SAT_(valid_trials,1);
Trial_Mat(:,6) = saccLoc(valid_trials);


%eliminate error trials that were not saccade direction errors and get rid of catch trials
remove1 = find(nansum(Errors_(valid_trials,1:4),2));
remove2 = find(Target_(valid_trials,2) == 255);
remove3 = find(~ismember(valid_trials,1:size(Target_,1)));
remove4 = find(isnan(Trial_Mat(:,4)));
remove5 = find(isnan(Trial_Mat(:,6)));
remove = unique([remove1 ; remove2 ; remove3 ; remove4 ; remove5]);
disp(['Removing ' mat2str(length(remove)) ' bad trials.'])

Trial_Mat(remove,:) = [];






param = [A,b,v,T0];
lower = [lb.A,lb.b,lb.v,lb.T0];
upper = [ub.A,ub.b,ub.v,ub.T0];
options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
[solution minval exitflag output] = fminsearchbnd(@(param) fitLBA_SAT_multiLBA_calcLL2(param,Trial_Mat),param,lower,upper,options)

A = solution(1);
b = solution(2);
v = solution(3:10);
s = solution(11);
T0 = solution(12);