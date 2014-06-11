%baseline-RT correlation w/i session
function [r,dat] = baseline_SDF_SDF_corr(unitname1,unitname2,win,plotFlag)

if nargin < 4; plotFlag = 0; end
if nargin < 3 || isempty(win); win = [-300 0]; end

% Options
normSDF = 0; %normalization won't matter for individual session; but if you want to run correlation across the population, best to normalize

if normSDF == 0; disp('Not Normalizing SDF'); end
if normSDF == 1; disp('Normalizing SDF'); end

sig1 = evalin('caller',unitname1);
sig2 = evalin('caller',unitname2);

Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SRT = evalin('caller','SRT');
SAT_ = evalin('caller','SAT_');
Target_ = evalin('caller','Target_');


getTrials_SAT

SDF1 = sSDF(sig1,Target_(:,1),[-400 2500]);
SDF2 = sSDF(sig2,Target_(:,1),[-400 2500]);

%normalize to max firing rate; note we normalize using a constant window size irrespective of the window
%size requested by the user
if normSDF
    SDF1 = normalize_SP(SDF1);
    SDF2 = normalize_SP(SDF2);
end

%limit to window.  Correct by window size used above to create single-trial SDFs and normalize
base1 = SDF1(:,400+win(1)+1 : 400+win(2)+1);
base2 = SDF2(:,400+win(1)+1 : 400+win(2)+1);

base1 = nanmean(base1,2);
base2 = nanmean(base2,2);

%remove 0's, because cells didn't fire
base1(find(base1 == 0)) = NaN;
base2(find(base2 == 0)) = NaN;





dat.slow_correct_made_dead = [base1(slow_correct_made_dead) base2(slow_correct_made_dead)];
%     dat.slow_correct_missed_dead = [base(slow_correct_missed_dead) SRT(slow_correct_missed_dead,1)];
%     dat.slow_correct_made_missed = [base(slow_correct_made_missed) SRT(slow_correct_made_missed,1)];
%
dat.slow_errors_made_dead = [base1(slow_errors_made_dead) base2(slow_errors_made_dead)];
%     dat.slow_errors_missed_dead = [base(slow_errors_missed_dead) SRT(slow_errors_missed_dead,1)];
%     dat.slow_errors_made_missed = [base(slow_errors_made_missed) SRT(slow_errors_made_missed,1)];
%
dat.slow_all = [base1(slow_all) base2(slow_all)];


% Baseline effect won't care whether or not the array is to be cleared or not
dat.fast_correct_made_dead = [base1(fast_correct_made_dead_withCleared) base2(fast_correct_made_dead_withCleared)];
%    dat.fast_correct_missed_dead = [base(fast_correct_missed_dead_withCleared) SRT(fast_correct_missed_dead_withCleared,1)];
%    dat.fast_correct_made_missed = [base(fast_correct_made_missed_withCleared) SRT(fast_correct_made_missed_withCleared,1)];

dat.fast_errors_made_dead = [base1(fast_errors_made_dead_withCleared) base2(fast_errors_made_dead_withCleared)];
%     dat.fast_errors_missed_dead = [base(fast_errors_missed_dead_withCleared) SRT(fast_errors_missed_dead_withCleared,1)];
%     dat.fast_errors_made_missed = [base(fast_errors_made_missed_withCleared) SRT(fast_errors_made_missed_withCleared,1)];

dat.fast_all = [base1(fast_all_withCleared) base2(fast_all_withCleared)];
%
%     if any(SAT_(:,1) == 2)
%         dat.med_correct = [base(med_correct) SRT(med_correct,1)];
%         dat.med_errors = [base(med_errors) SRT(med_errors,1)];
%         dat.med_all = [base(med_all) SRT(med_all,1)];
%     end
% 
% all_correct = [slow_correct_made_missed ; med_correct ; fast_correct_made_missed_withCleared];
% all_errors = [slow_errors_made_missed ; med_errors ; fast_errors_made_missed_withCleared];
% all_all = 1:size(Target_,1);
% 
% dat.ALL_CORRECT = [base(all_correct) SRT(all_correct,1)];
% dat.ALL_ERRORS = [base(all_errors) SRT(all_errors,1)];
% dat.ALL_ALL = [base(all_all) SRT(all_all,1)];
%=============================



%============================
% Single session correlations
r.slow_correct_made_dead = nancorr(base1(slow_correct_made_dead),base2(slow_correct_made_dead));
%     r.slow_correct_missed_dead = nancorr(base(slow_correct_missed_dead),SRT(slow_correct_missed_dead,1));
%     r.slow_correct_made_missed = nancorr(base(slow_correct_made_missed),SRT(slow_correct_made_missed,1));

r.slow_errors_made_dead = nancorr(base1(slow_errors_made_dead),base2(slow_errors_made_dead));
%     r.slow_errors_missed_dead = nancorr(base(slow_errors_missed_dead),SRT(slow_errors_missed_dead,1));
%     r.slow_errors_made_missed = nancorr(base(slow_errors_made_missed),SRT(slow_errors_made_missed,1));

r.slow_all = nancorr(base1(slow_all),base2(slow_all));


% Baseline effect won't care whether or not the array is to be cleared or not
r.fast_correct_made_dead = nancorr(base1(fast_correct_made_dead_withCleared),base2(fast_correct_made_dead_withCleared));
%     r.fast_correct_missed_dead = nancorr(base(fast_correct_missed_dead_withCleared),SRT(fast_correct_missed_dead_withCleared,1));
%     r.fast_correct_made_missed = nancorr(base(fast_correct_made_missed_withCleared),SRT(fast_correct_made_missed_withCleared,1));

r.fast_errors_made_dead = nancorr(base1(fast_errors_made_dead_withCleared),base2(fast_errors_made_dead_withCleared));
%     r.fast_errors_missed_dead = nancorr(base(fast_errors_missed_dead_withCleared),SRT(fast_errors_missed_dead_withCleared,1));
%     r.fast_errors_made_missed = nancorr(base(fast_errors_made_missed_withCleared),SRT(fast_errors_made_missed_withCleared,1));

r.fast_all = nancorr(base1(fast_all_withCleared),base2(fast_all_withCleared));
%
%     if any(SAT_(:,1) == 2)
%         r.med_correct = nancorr(base(med_correct),SRT(med_correct,1));
%         r.med_errors = nancorr(base(med_errors),SRT(med_errors,1));
%         r.med_all = nancorr(base(med_all),SRT(med_all,1));
%     end
%
%     r.ALL_CORRECT = nancorr(base(all_correct),SRT(all_correct,1));
%     r.ALL_ERRORS = nancorr(base(all_errors),SRT(all_errors,1));
%     r.ALL_ALL = nancorr(base(all_all),SRT(all_all,1));
%




if plotFlag
    figure
    scatter(dat.slow_all(:,1),dat.slow_all(:,2),'r')
    hold on
    scatter(dat.fast_all(:,1),dat.fast_all(:,2),'g')
    xlabel('Baseline Amplitude')
    ylabel('RT')
    title('All Trials')
end
