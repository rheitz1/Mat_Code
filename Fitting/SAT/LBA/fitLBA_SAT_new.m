% In new version, fits have only 1 single constraint, which is
% s (trial-trial drift variability) in the Accuracy condition.
% drift rates (v) are allowed to vary both between condition and
% independently for correct and error accumulators, which
% actually leads to more free parameters than otherwise
%
% RPH

function [solution,LL,AIC,BIC,CDF,Trial_Mat] = fitLBA_SAT(FreeFix,plotFlag)

rand('seed',5150);
randn('seed',5150);

Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
Target_ = evalin('caller','Target_');
SAT_ = evalin('caller','SAT_');
SRT = evalin('caller','SRT');

%This version assumes equal drift rates, biases, and boundaries for all screen positions.  This boils the
%model down into a 2AFC condition
minimize = 1; %if set to 0, returns fit statistics and plots using starting values
minimize_routine = 'MLE'; %MLE or X2? %NOTE: X2 seems more sensitive than MLE to starting values
made_dead_only = 1; %if set to 0, includes all trials irregardless of made/missed deadlines
include_med = 0; %if set to 0, fits only fast and slow conditions.  Fits will be different when MED included
truncate_IQR = 1; %if set to 0, no truncation of SRT distributions
truncval = 1.5;

show_minimization = 1; %do you want to view the minimization (takes longer)?

%======================================
% FIT ONLY NEUTRAL AND FAST CONDITIONS?
force_neutral_fast = 0;
%======================

if force_neutral_fast; include_med = 0; end

if include_med
    numCond = 3;
else
    disp('SKIPPING NEUTRAL CONDITION...')
    numCond = 2;
end

fr = numCond;

% FORMAT:   A  b  v T0  %%% s assumed to always be fixed
if nargin < 2; plotFlag = 1; end
if nargin < 1; FreeFix = [fr fr fr*2 fr fr]; end %set all parameters free


A(1:FreeFix(1)) = .01;
b(1:FreeFix(2)) = 100;
v(1:FreeFix(3)*2) = 1; %found this to work.  Some models will perform worse than all constrained if this is too high.  I.e., it will get stuck in a terrible local minima.
v = v - repmat([.45 .55],1,length(v)/2); %set better starting parameters
T0(1:FreeFix(4)) = 50;
s(1:numCond-1) = 0.1; % 1st value will be fixed; all others allowed to vary (see Donkin et al. 2009);

s_fixed_value = s(1); %makes sure 1st value of s is always fixed by system

lb.A(1:FreeFix(1)) = 0;
lb.b(1:FreeFix(2)) = 0;
lb.v(1:FreeFix(3)*2) = .01; %need this to be set to .5 minimim.  Otherwise, models with all fixed but v tend to quit with terrible fits.  This corrects the problem.
lb.T0(1:FreeFix(4)) = 50;
lb.s(1:numCond-1) = .001;

ub.A(1:FreeFix(1)) = 1000;
ub.b(1:FreeFix(2)) = 1000;
ub.v(1:FreeFix(3)*2) = 5;
ub.T0(1:FreeFix(4)) = 800;
ub.s(1:numCond-1) = 2;

%Best Fitting:

% Model 1 (all free)
% A = [1.45 100.12 71.02];
% b = [305.25 171.83 146.77];
% v = [.57 .57 .55];
% T0 = [57.74 82.93 73.02];

% Model 14 (free b only)
% A = [85.63];
% b = [325.74 149.87 141.79];
% v = [.57];
% T0 = [101.51];


getTrials_SAT


% q.a = slow_correct_made_dead;
% q.b = slow_errors_made_dead;
% q.c = med_correct;
% q.d = med_errors;
% q.e = fast_correct_made_dead_withCleared;
% q.f = fast_errors_made_dead_withCleared;
%
% slow_correct_made_dead = q.b;
% slow_errors_made_dead = q.a;
% med_correct = q.d;
% med_errors = q.c;
% fast_correct_made_dead_withCleared = q.f;
% fast_errors_made_dead_withCleared = q.e;



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
        
        %just count them so we know how many are being thrown away
        %This is shitty code but easier to add now
        keep_med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        keep_med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        keep_slow_correct = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        keep_fast_correct_withCleared = intersect(fast_correct_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        keep_slow_errors = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        keep_fast_errors_withCleared = intersect(fast_errors_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        
        disp(['Removing ' mat2str(length(slow_correct_made_dead) - length(keep_slow_correct)) ' ACCURACY CORRECT trials'])
        disp(['Removing ' mat2str(length(med_correct) - length(keep_med_correct)) ' NEUTRAL CORRECT trials'])
        disp(['Removing ' mat2str(length(fast_correct_made_dead_withCleared) - length(keep_fast_correct_withCleared)) ' FAST CORRECT trials'])
        disp(['Removing ' mat2str(length(slow_errors_made_dead) - length(keep_slow_errors)) ' ACCURACY ERROR trials'])
        disp(['Removing ' mat2str(length(med_errors) - length(keep_med_errors)) ' MED ERROR trials'])
        disp(['Removing ' mat2str(length(fast_errors_made_dead_withCleared) - length(keep_fast_errors_withCleared)) ' FAST ERROR trials'])
        
        %Second Pass
        med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        
        %All correct trials w/ made deadlines
        slow_correct = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        fast_correct_withCleared = intersect(fast_correct_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        slow_errors = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        fast_errors_withCleared = intersect(fast_errors_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
    else
        slow_correct = slow_correct_made_dead;
        slow_errors = slow_errors_made_dead;
        fast_correct_withCleared = fast_correct_made_dead_withCleared;
        fast_errors_withCleared = fast_errors_made_dead_withCleared;
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
        
        
        %just count them so we know how many are being thrown away
        %This is shitty code but easier to add now
        keep_med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        keep_med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
        keep_slow_correct = intersect(slow_correct_made_missed,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        keep_fast_correct_withCleared = intersect(fast_correct_made_missed_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        keep_slow_errors = intersect(slow_errors_made_missed,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        keep_fast_errors_withCleared = intersect(fast_errors_made_missed_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        
        disp(['Removing ' mat2str(length(slow_correct_made_missed) - length(keep_slow_correct)) ' ACCURACY CORRECT trials'])
        disp(['Removing ' mat2str(length(med_correct) - length(keep_med_correct)) ' NEUTRAL CORRECT trials'])
        disp(['Removing ' mat2str(length(fast_correct_made_missed_withCleared) - length(keep_fast_correct_withCleared)) ' FAST CORRECT trials'])
        disp(['Removing ' mat2str(length(slow_errors_made_missed) - length(keep_slow_errors)) ' ACCURACY ERROR trials'])
        disp(['Removing ' mat2str(length(med_errors) - length(keep_med_errors)) ' MED ERROR trials'])
        disp(['Removing ' mat2str(length(fast_errors_made_missed_withCleared) - length(keep_fast_errors_withCleared)) ' FAST ERROR trials'])
        
        
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



%%%%%%%%%%%%%%
% Temporary: remove Accuracy condition and fit only neutral and fast conditions.  Do this by setting the
% Neutral condition = Accuracy condition
%%%%%%%%%%%%%%
if force_neutral_fast
    slow_correct = med_correct;
    slow_errors = med_errors;
    
    SAT_(find(SAT_(:,1) == 1),1) = NaN;
    SAT_(find(SAT_(:,1) == 2),1) = 1;
end

%FORMAT:
% TARGET LOC  |  ACTUAL LOC (WINNING UNIT)  |  CORRECT/ERR   |  RT | SetSize
if include_med
    valid_trials = [slow_correct ; fast_correct_withCleared ; slow_errors ; fast_errors_withCleared ; med_correct ; med_errors];
else
    valid_trials = [slow_correct ; fast_correct_withCleared ; slow_errors ; fast_errors_withCleared];
end

Trial_Mat(:,1) = Target_(valid_trials,2);
Trial_Mat(:,2) = NaN; %LEGACY
Trial_Mat(:,3) = Correct_(valid_trials,2);
Trial_Mat(:,4) = SRT(valid_trials,1);
Trial_Mat(:,5) = SAT_(valid_trials,1);


%eliminate error trials that were not saccade direction errors and get rid of catch trials
remove1 = find(nansum(Errors_(valid_trials,1:4),2));
remove2 = find(Target_(valid_trials,2) == 255);
remove3 = find(~ismember(valid_trials,1:size(Target_,1)));
remove4 = find(isnan(Trial_Mat(:,4)));
remove = unique([remove1 ; remove2 ; remove3 ; remove4]);

Trial_Mat(remove,:) = [];

tic
if minimize == 1
    param = [A,b,v,T0,s];
    lower = [lb.A,lb.b,lb.v,lb.T0,lb.s];
    upper = [ub.A,ub.b,ub.v,ub.T0,ub.s];
    %options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    options = optimset('MaxIter', 100000,'MaxFunEvals', 100000,'useparallel','always');
    
    if strmatch(minimize_routine,'MLE','exact')
        [solution minval exitflag output] = fminsearchbnd(@(param) fitLBA_SAT_calcLL_new(param,Trial_Mat),param,lower,upper,options);
        %[solution minval exitflag output] = fminsearch(@(param) fitLBA_SAT_calcLL(param,Trial_Mat),param,options);
        
        % options = gaoptimset('Generations',1000,'StallGenLimit',1000,...
        %    'MigrationDirection','forward','TolFun',1e-10);
        % %options.PopInitRange = [0 0 0; 100 100 100];
        % %options = gaoptimset(options,'HybridFcn', {  @fminsearch [] });
        
        %options = gaoptimset('PopulationSize',[ones(1,numel(param))*30],'Display','iter','useparallel','always');
        %options = gaoptimset('PopulationSize',[ones(1,numel(param))*30]);
        %[solution minval exitflag output] = ga(@(param) fitLBA_SAT_calcLL(param,Trial_Mat),numel(param),[],[],[],[],lower,upper,[],[],options);
    elseif strmatch(minimize_routine,'X2','exact')
        [solution minval exitflag output] = fminsearchbnd(@(param) fitLBA_SAT_calcX2(param,Trial_Mat),param,lower,upper,options);
        %[solution minval exitflag output] = fminsearch(@(param) fitLBA_SAT_calcX2(param,Trial_Mat),param,options);
        
        % options = gaoptimset('Generations',1000,'StallGenLimit',1000,...
        %    'MigrationDirection','forward','TolFun',1e-10);
        % %options.PopInitRange = [0 0 0; 100 100 100];
        % %options = gaoptimset(options,'HybridFcn', {  @fminsearch [] });
        
        %options = gaoptimset('PopulationSize',[ones(1,numel(param))*30],'Display','iter','useparallel','always');
        %options = gaoptimset('PopulationSize',[ones(1,numel(param))*30]);
        %[solution minval exitflag output] = ga(@(param) fitLBA_SAT_calcX2(param,Trial_Mat),numel(param),[],[],[],[],lower,upper,[],[],options);
        
    end
    
    A = solution(1:length(A));
    b = solution(length(A)+1:length(A)+length(b));
    v = solution(length(A)+length(b)+1:length(A)+length(b)+length(v));
    T0 = solution(length(A)+length(b)+length(v)+1:length(A)+length(b)+length(v)+length(T0));
    s = solution(length(A)+length(b)+length(v)+length(T0)+1:length(solution));
    
else
    disp('NOT MINIMIZING: USING STARTING VALUES TO FIT')
    param = [A,b,v,T0,s];
    
    
    if strmatch(minimize_routine,'MLE','exact')
        minval = fitLBA_SAT_calcLL(param,Trial_Mat);
    elseif strmatch(minimize_routine,'X2','exact')
        minval = fitLBA_SAT_calcX2(param,Trial_Mat);
    end
    
    solution = param; %since we are not minimizing, take starting values as solution.
end
%Bayesian Information Criterion
n_free = numel(param);
n_obs = size(Trial_Mat,1);
LL = -minval; %reset back to positive number, since we minimized the negative to maximize the positive
[AIC BIC] = aicbic(LL,n_free,n_obs);

slow.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 1);
slow.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 1);
med.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 2);
med.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 2);
fast.err = find(Trial_Mat(:,3) == 0 & Trial_Mat(:,5) == 3);
fast.correct = find(Trial_Mat(:,3) == 1 & Trial_Mat(:,5) == 3);

%return defective CDFs of current dataset
CDF.slow = getDefectiveCDF(slow.correct,slow.err,Trial_Mat(:,4));
CDF.fast = getDefectiveCDF(fast.correct,fast.err,Trial_Mat(:,4));

if include_med
    CDF.med = getDefectiveCDF(med.correct,med.err,Trial_Mat(:,4));
else
    CDF.med.correct = NaN;
    CDF.med.err = NaN;
end


if plotFlag
    
    % %this is kludgy, but will work for plotting.  Tile parameters as if they were free, but just replicate
    % %those that are fixed
    if ~all(FreeFix == 1)
        if FreeFix(1) == 1; A = repmat(A,1,fr); end
        if FreeFix(2) == 1; b = repmat(b,1,fr); end
        if FreeFix(3) == 1; v = repmat(v,1,fr); end
        if FreeFix(4) == 1; T0 = repmat(T0,1,fr); end
        if FreeFix(5) == 1; s = repmat(s_fixed_value,1,fr); end
    elseif all(FreeFix == 1)
        if ~include_med
            A = repmat(A,1,2);
            b = repmat(b,1,2);
            v = repmat(v,1,2);
            T0 = repmat(T0,1,2);
            s = repmat(s_fixed_value,1,2);
        elseif include_med
            A = repmat(A,1,3);
            b = repmat(b,1,3);
            v = repmat(v,1,3);
            T0 = repmat(T0,1,3);
            s = repmat(s_fixed_value,1,3);
        end
    end
    
    winner.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(1),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(2),s_fixed_value)));
    loser.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(2),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(1),s_fixed_value)));
    t.slow = (1:2000) + T0(1);
    
    if max(FreeFix) == 2
        
        winner.fast = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(3),s(1)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(4),s(1))));
        loser.fast = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(4),s(1)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(3),s(1))));
        t.fast = (1:2000) + T0(2);
        
    elseif max(FreeFix) == 3
        winner.med = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(3),s(1)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(4),s(1)))); %note: s indexing appears off because 1st value is actually fixed
        loser.med = cumsum(linearballisticPDF(1:2000,A(2),b(2),v(4),s(1)) .* (1-linearballisticCDF(1:2000,A(2),b(2),v(3),s(1))));
        t.med = (1:2000) + T0(2);
        
        winner.fast = cumsum(linearballisticPDF(1:2000,A(3),b(3),v(5),s(2)) .* (1-linearballisticCDF(1:2000,A(3),b(3),v(6),s(2))));
        loser.fast = cumsum(linearballisticPDF(1:2000,A(3),b(3),v(6),s(2)) .* (1-linearballisticCDF(1:2000,A(3),b(3),v(5),s(2))));
        t.fast = (1:2000) + T0(3);
    else %all Fixed
        if ~include_med
            winner.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(1),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(2),s_fixed_value)));
            loser.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(2),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(1),s_fixed_value)));
            t.slow = (1:2000) + T0(1);
            
            winner.fast = winner.slow;
            loser.fast = loser.slow;
            t.fast = t.slow;
        elseif include_med
            winner.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(1),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(2),s_fixed_value)));
            loser.slow = cumsum(linearballisticPDF(1:2000,A(1),b(1),v(2),s_fixed_value) .* (1-linearballisticCDF(1:2000,A(1),b(1),v(1),s_fixed_value)));
            t.slow = (1:2000) + T0(1);
            
            winner.med = winner.slow;
            loser.med = loser.slow;
            t.med = t.slow;
            
            winner.fast = winner.slow;
            loser.fast = loser.slow;
            t.fast = t.slow;
        else
            error('Something Wrong')
        end
    end
    
    
    ff = figure;
    set(gcf,'Position',[1109 881 1413 436])
    
    subplot(1,3,1)
    plot(t.slow,winner.slow,'k',t.slow,loser.slow,'r')
    hold on
    plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok',CDF.slow.err(:,1),CDF.slow.err(:,2),'or','markersize',8)
    ylim([0 1])
    xlim([0 1600])
    text(100,.95,['A = ' mat2str(round(A(1)*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.90,['b = ' mat2str(round(b(1)*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.85,['vC = ' mat2str(round(v(1)*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.80,['vE = ' mat2str(round(v(2)*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.75,['s = ' mat2str(round(s_fixed_value*100)/100)],'fontweight','bold','fontsize',16)
    text(100,.70,['T0 = ' mat2str(round(T0(1)*100)/100)],'fontweight','bold','fontsize',16)
    title('ACCURATE')
    box off
    set(gca,'xminortick','on')
    
    if ~include_med
        subplot(1,3,3)
        plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
        hold on
        plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or','markersize',8)
        ylim([0 1])
        xlim([0 1600])
        text(100,.95,['A = ' mat2str(round(A(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.90,['b = ' mat2str(round(b(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.85,['vC = ' mat2str(round(v(3)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.80,['vE = ' mat2str(round(v(4)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.75,['s = ' mat2str(round(s(1)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.70,['T0 = ' mat2str(round(T0(2)*100)/100)],'fontweight','bold','fontsize',16)
        title('FAST','fontsize',16,'fontweight','bold')
        box off
        set(gca,'xminortick','on')
        
        %[ax h] = suplabel(['LL = ' mat2str(round(minval*100)/100) ' BIC = ' mat2str(round(BIC*1000)/1000)],'t');
        [ax h] = suplabel(['Model: ' mat2str(FreeFix) ' LL = ' mat2str(round(LL*100)/100)],'t');
        set(h,'fontsize',16,'fontweight','bold')
        
    elseif include_med
        subplot(1,3,2)
        plot(t.med,winner.med,'k',t.med,loser.med,'r')
        hold on
        plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'or','markersize',8)
        ylim([0 1])
        xlim([0 1600])
        text(100,.95,['A = ' mat2str(round(A(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.90,['b = ' mat2str(round(b(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.85,['vC = ' mat2str(round(v(3)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.80,['vE = ' mat2str(round(v(4)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.75,['s = ' mat2str(round(s(1)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.70,['T0 = ' mat2str(round(T0(2)*100)/100)],'fontweight','bold','fontsize',16)
        title('NEUTRAL','fontsize',16,'fontweight','bold')
        box off
        set(gca,'xminortick','on')
        
        subplot(1,3,3)
        plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
        hold on
        plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or','markersize',8)
        ylim([0 1])
        xlim([0 1600])
        text(100,.95,['A = ' mat2str(round(A(3)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.90,['b = ' mat2str(round(b(3)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.85,['vC = ' mat2str(round(v(5)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.80,['vE = ' mat2str(round(v(6)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.75,['s = ' mat2str(round(s(2)*100)/100)],'fontweight','bold','fontsize',16)
        text(100,.70,['T0 = ' mat2str(round(T0(3)*100)/100)],'fontweight','bold','fontsize',16)
        title('FAST','fontsize',16,'fontweight','bold')
        box off
        set(gca,'xminortick','on')
        
        %[ax h] = suplabel(['LL = ' mat2str(round(minval*100)/100) ' BIC = ' mat2str(round(BIC*1000)/1000)],'t');
        [ax h] = suplabel(['Model: ' mat2str(FreeFix) 'LL = ' mat2str(round(LL*100)/100)],'t');
        set(h,'fontsize',16,'fontweight','bold')
        
    end
    
    %now create a plot where all conditions are plotted together on same axis
            figure
            set(gcf,'position',[1107 377 560 420])
            
            if ~include_med
                %subplot(2,2,1)
                plot(t.slow,winner.slow,'r',t.slow,loser.slow,'--r',t.fast,winner.fast,'g',t.fast,loser.fast,'--g')
                hold on
                plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'or',CDF.slow.err(:,1),CDF.slow.err(:,2),'or', ...
                    CDF.fast.correct(:,1),CDF.fast.correct(:,2),'og',CDF.fast.err(:,1),CDF.fast.err(:,2),'og')
                xlim([0 1600])
                ylim([0 1])
                set(gca,'xminortick','on')
                box off
            elseif include_med
                %subplot(2,2,1)
                plot(t.slow,winner.slow,'r',t.slow,loser.slow,'--r', ...
                    t.med,winner.med,'k',t.med,loser.med,'--k', ...
                    t.fast,winner.fast,'g',t.fast,loser.fast,'--g')
                hold on
                plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'or',CDF.slow.err(:,1),CDF.slow.err(:,2),'or', ...
                    CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'ok', ...
                    CDF.fast.correct(:,1),CDF.fast.correct(:,2),'og',CDF.fast.err(:,1),CDF.fast.err(:,2),'og')
                xlim([0 1600])
                ylim([0 1])
                set(gca,'xminortick','on')
                box off
            end
    
end
%bring main figure to foreground
%figure(ff);

disp(['Optimization ran for ' mat2str(round((toc/60)*1000)/1000) ' minutes'])