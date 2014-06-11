%baseline-RT correlation w/i session
function [r,dat] = baseline_RT_corr(unitname,win,plotFlag)

if nargin < 3; plotFlag = 0; end
if nargin < 2 || isempty(win); win = [-300 0]; end

% Options
normSDF = 1; %normalization won't matter for individual session; but if you want to run correlation across the population, best to normalize
zscoreSRT = 1; %z-scoring won't matter for individual session; but will if running across population

if zscoreSRT; disp('Z-Scoring SRT'); end
if ~zscoreSRT; disp('Not Z-Scoring SRT'); end
if normSDF == 0; disp('Not Normalizing SDF'); end
if normSDF == 1; disp('Normalizing SDF'); end

sig = evalin('caller',unitname);
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SRT = evalin('caller','SRT');
SAT_ = evalin('caller','SAT_');
Target_ = evalin('caller','Target_');


getTrials_SAT

SDF = sSDF(sig,Target_(:,1),[-400 2500]);

%normalize to max firing rate; note we normalize using a constant window size irrespective of the window
%size requested by the user
if normSDF
    SDF = normalize_SP(SDF);
end

%limit to window.  Correct by window size used above to create single-trial SDFs and normalize
base = SDF(:,400+win(1)+1 : 400+win(2)+1);

base = nanmean(base,2);

%remove 0's, because cells didn't fire
base(find(base == 0)) = NaN;


%is there a significant effect on firing rates between the ACCURATE and FAST conditions?
dat.h = ttest2(removeNaN(base(slow_all)),removeNaN(base(fast_all_withCleared)));

% if significant, keep a record of which direction the effect was in.  +1 = FAST > ACCURATE; -1 =
% ACCURATE > FAST
if dat.h == 1 & nanmean(base(slow_all)) < nanmean(base(fast_all_withCleared))
    dat.h_dir = 1;
elseif dat.h == 1 & nanmean(base(slow_all)) > nanmean(base(fast_all_withCleared))
    dat.h_dir = -1;
else
    dat.h_dir = 0;
end


%============================
% Single session data

if zscoreSRT
    dat.slow_correct_made_dead = [base(slow_correct_made_dead) nanzscore(SRT(slow_correct_made_dead,1))];
    dat.slow_correct_missed_dead = [base(slow_correct_missed_dead) nanzscore(SRT(slow_correct_missed_dead,1))];
    dat.slow_correct_made_missed = [base(slow_correct_made_missed) nanzscore(SRT(slow_correct_made_missed,1))];
    
    dat.slow_errors_made_dead = [base(slow_errors_made_dead) nanzscore(SRT(slow_errors_made_dead,1))];
    dat.slow_errors_missed_dead = [base(slow_errors_missed_dead) nanzscore(SRT(slow_errors_missed_dead,1))];
    dat.slow_errors_made_missed = [base(slow_errors_made_missed) nanzscore(SRT(slow_errors_made_missed,1))];
    
    dat.slow_all = [base(slow_all) nanzscore(SRT(slow_all,1))];
    
    
    % Baseline effect won't care whether or not the array is to be cleared or not
    dat.fast_correct_made_dead = [base(fast_correct_made_dead_withCleared) nanzscore(SRT(fast_correct_made_dead_withCleared,1))];
    dat.fast_correct_missed_dead = [base(fast_correct_missed_dead_withCleared) nanzscore(SRT(fast_correct_missed_dead_withCleared,1))];
    dat.fast_correct_made_missed = [base(fast_correct_made_missed_withCleared) nanzscore(SRT(fast_correct_made_missed_withCleared,1))];
    
    dat.fast_errors_made_dead = [base(fast_errors_made_dead_withCleared) nanzscore(SRT(fast_errors_made_dead_withCleared,1))];
    dat.fast_errors_missed_dead = [base(fast_errors_missed_dead_withCleared) nanzscore(SRT(fast_errors_missed_dead_withCleared,1))];
    dat.fast_errors_made_missed = [base(fast_errors_made_missed_withCleared) nanzscore(SRT(fast_errors_made_missed_withCleared,1))];
    
    dat.fast_all = [base(fast_all_withCleared) nanzscore(SRT(fast_all_withCleared,1))];
    
    if any(SAT_(:,1) == 2)
        dat.med_correct = [base(med_correct) nanzscore(SRT(med_correct,1))];
        dat.med_errors = [base(med_errors) nanzscore(SRT(med_errors,1))];
        dat.med_all = [base(med_all) nanzscore(SRT(med_all,1))];
    end
    
    all_correct = [slow_correct_made_missed ; med_correct ; fast_correct_made_missed_withCleared];
    all_errors = [slow_errors_made_missed ; med_errors ; fast_errors_made_missed_withCleared];
    all_all = 1:size(Target_,1);
    
    dat.ALL_CORRECT = [base(all_correct) nanzscore(SRT(all_correct,1))];
    dat.ALL_ERRORS = [base(all_errors) nanzscore(SRT(all_errors,1))];
    dat.ALL_ALL = [base(all_all) nanzscore(SRT(all_all,1))];
    %=============================
    
    
    
    %============================
    % Single session correlations
    r.slow_correct_made_dead = nancorr(base(slow_correct_made_dead),nanzscore(SRT(slow_correct_made_dead,1)));
    r.slow_correct_missed_dead = nancorr(base(slow_correct_missed_dead),nanzscore(SRT(slow_correct_missed_dead,1)));
    r.slow_correct_made_missed = nancorr(base(slow_correct_made_missed),nanzscore(SRT(slow_correct_made_missed,1)));
    
    r.slow_errors_made_dead = nancorr(base(slow_errors_made_dead),nanzscore(SRT(slow_errors_made_dead,1)));
    r.slow_errors_missed_dead = nancorr(base(slow_errors_missed_dead),nanzscore(SRT(slow_errors_missed_dead,1)));
    r.slow_errors_made_missed = nancorr(base(slow_errors_made_missed),nanzscore(SRT(slow_errors_made_missed,1)));
    
    r.slow_all = nancorr(base(slow_all),nanzscore(SRT(slow_all,1)));
    
    
    % Baseline effect won't care whether or not the array is to be cleared or not
    r.fast_correct_made_dead = nancorr(base(fast_correct_made_dead_withCleared),nanzscore(SRT(fast_correct_made_dead_withCleared,1)));
    r.fast_correct_missed_dead = nancorr(base(fast_correct_missed_dead_withCleared),nanzscore(SRT(fast_correct_missed_dead_withCleared,1)));
    r.fast_correct_made_missed = nancorr(base(fast_correct_made_missed_withCleared),nanzscore(SRT(fast_correct_made_missed_withCleared,1)));
    
    r.fast_errors_made_dead = nancorr(base(fast_errors_made_dead_withCleared),nanzscore(SRT(fast_errors_made_dead_withCleared,1)));
    r.fast_errors_missed_dead = nancorr(base(fast_errors_missed_dead_withCleared),nanzscore(SRT(fast_errors_missed_dead_withCleared,1)));
    r.fast_errors_made_missed = nancorr(base(fast_errors_made_missed_withCleared),nanzscore(SRT(fast_errors_made_missed_withCleared,1)));
    
    r.fast_all = nancorr(base(fast_all_withCleared),nanzscore(SRT(fast_all_withCleared,1)));
    
    if any(SAT_(:,1) == 2)
        r.med_correct = nancorr(base(med_correct),nanzscore(SRT(med_correct,1)));
        r.med_errors = nancorr(base(med_errors),nanzscore(SRT(med_errors,1)));
        r.med_all = nancorr(base(med_all),nanzscore(SRT(med_all,1)));
    end
    
    r.ALL_CORRECT = nancorr(base(all_correct),nanzscore(SRT(all_correct,1)));
    r.ALL_ERRORS = nancorr(base(all_errors),nanzscore(SRT(all_errors,1)));
    r.ALL_ALL = nancorr(base(all_all),nanzscore(SRT(all_all,1)));
    
    
else
    
    dat.slow_correct_made_dead = [base(slow_correct_made_dead) SRT(slow_correct_made_dead,1)];
    dat.slow_correct_missed_dead = [base(slow_correct_missed_dead) SRT(slow_correct_missed_dead,1)];
    dat.slow_correct_made_missed = [base(slow_correct_made_missed) SRT(slow_correct_made_missed,1)];
    
    dat.slow_errors_made_dead = [base(slow_errors_made_dead) SRT(slow_errors_made_dead,1)];
    dat.slow_errors_missed_dead = [base(slow_errors_missed_dead) SRT(slow_errors_missed_dead,1)];
    dat.slow_errors_made_missed = [base(slow_errors_made_missed) SRT(slow_errors_made_missed,1)];
    
    dat.slow_all = [base(slow_all) SRT(slow_all,1)];
    
    
    % Baseline effect won't care whether or not the array is to be cleared or not
    dat.fast_correct_made_dead = [base(fast_correct_made_dead_withCleared) SRT(fast_correct_made_dead_withCleared,1)];
    dat.fast_correct_missed_dead = [base(fast_correct_missed_dead_withCleared) SRT(fast_correct_missed_dead_withCleared,1)];
    dat.fast_correct_made_missed = [base(fast_correct_made_missed_withCleared) SRT(fast_correct_made_missed_withCleared,1)];
    
    dat.fast_errors_made_dead = [base(fast_errors_made_dead_withCleared) SRT(fast_errors_made_dead_withCleared,1)];
    dat.fast_errors_missed_dead = [base(fast_errors_missed_dead_withCleared) SRT(fast_errors_missed_dead_withCleared,1)];
    dat.fast_errors_made_missed = [base(fast_errors_made_missed_withCleared) SRT(fast_errors_made_missed_withCleared,1)];
    
    dat.fast_all = [base(fast_all_withCleared) SRT(fast_all_withCleared,1)];
    
    if any(SAT_(:,1) == 2)
        dat.med_correct = [base(med_correct) SRT(med_correct,1)];
        dat.med_errors = [base(med_errors) SRT(med_errors,1)];
        dat.med_all = [base(med_all) SRT(med_all,1)];
    end
    
    all_correct = [slow_correct_made_missed ; med_correct ; fast_correct_made_missed_withCleared];
    all_errors = [slow_errors_made_missed ; med_errors ; fast_errors_made_missed_withCleared];
    all_all = 1:size(Target_,1);
    
    dat.ALL_CORRECT = [base(all_correct) SRT(all_correct,1)];
    dat.ALL_ERRORS = [base(all_errors) SRT(all_errors,1)];
    dat.ALL_ALL = [base(all_all) SRT(all_all,1)];
    %=============================
    
    
    
    %============================
    % Single session correlations
    r.slow_correct_made_dead = nancorr(base(slow_correct_made_dead),SRT(slow_correct_made_dead,1));
    r.slow_correct_missed_dead = nancorr(base(slow_correct_missed_dead),SRT(slow_correct_missed_dead,1));
    r.slow_correct_made_missed = nancorr(base(slow_correct_made_missed),SRT(slow_correct_made_missed,1));
    
    r.slow_errors_made_dead = nancorr(base(slow_errors_made_dead),SRT(slow_errors_made_dead,1));
    r.slow_errors_missed_dead = nancorr(base(slow_errors_missed_dead),SRT(slow_errors_missed_dead,1));
    r.slow_errors_made_missed = nancorr(base(slow_errors_made_missed),SRT(slow_errors_made_missed,1));
    
    r.slow_all = nancorr(base(slow_all),SRT(slow_all,1));
    
    
    % Baseline effect won't care whether or not the array is to be cleared or not
    r.fast_correct_made_dead = nancorr(base(fast_correct_made_dead_withCleared),SRT(fast_correct_made_dead_withCleared,1));
    r.fast_correct_missed_dead = nancorr(base(fast_correct_missed_dead_withCleared),SRT(fast_correct_missed_dead_withCleared,1));
    r.fast_correct_made_missed = nancorr(base(fast_correct_made_missed_withCleared),SRT(fast_correct_made_missed_withCleared,1));
    
    r.fast_errors_made_dead = nancorr(base(fast_errors_made_dead_withCleared),SRT(fast_errors_made_dead_withCleared,1));
    r.fast_errors_missed_dead = nancorr(base(fast_errors_missed_dead_withCleared),SRT(fast_errors_missed_dead_withCleared,1));
    r.fast_errors_made_missed = nancorr(base(fast_errors_made_missed_withCleared),SRT(fast_errors_made_missed_withCleared,1));
    
    r.fast_all = nancorr(base(fast_all_withCleared),SRT(fast_all_withCleared,1));
    
    if any(SAT_(:,1) == 2)
        r.med_correct = nancorr(base(med_correct),SRT(med_correct,1));
        r.med_errors = nancorr(base(med_errors),SRT(med_errors,1));
        r.med_all = nancorr(base(med_all),SRT(med_all,1));
    end
    
    r.ALL_CORRECT = nancorr(base(all_correct),SRT(all_correct,1));
    r.ALL_ERRORS = nancorr(base(all_errors),SRT(all_errors,1));
    r.ALL_ALL = nancorr(base(all_all),SRT(all_all,1));
    
    
end


if plotFlag
    figure
    scatter(dat.slow_correct_made_missed(:,1),dat.slow_correct_made_missed(:,2),'r')
    hold on
    scatter(dat.fast_correct_made_missed(:,1),dat.fast_correct_made_missed(:,2),'g')
    xlabel('Baseline Amplitude')
    ylabel('RT')
    title('Correct Made + Missed')
end
