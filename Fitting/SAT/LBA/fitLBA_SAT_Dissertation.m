function [solution,LL,AIC,BIC,CDF,Trial_Mat] = fitLBA_SAT_Dissertation(FreeFix,plotFlag)

rand('seed',5150);
randn('seed',5150);
% 
% Correct_ = evalin('caller','Correct_');
% Errors_ = evalin('caller','Errors_');
% Target_ = evalin('caller','Target_');
% SAT_ = evalin('caller','SAT_');
% SRT = evalin('caller','SRT');

slow_correct_made_dead = evalin('caller','slow_correct_made_dead');
slow_errors_made_dead = evalin('caller','slow_errors_made_dead');
med_correct = evalin('caller','med_correct');
med_errors = evalin('caller','med_errors');
fast_correct_made_dead_withCleared = evalin('caller','fast_correct_made_dead_withCleared');
fast_errors_made_dead_withCleared = evalin('caller','fast_errors_made_dead_withCleared');

slow_correct_missed_dead = evalin('caller','slow_correct_missed_dead');
slow_errors_missed_dead = evalin('caller','slow_errors_missed_dead');

fast_correct_missed_dead_withCleared = evalin('caller','fast_correct_missed_dead_withCleared');
fast_errors_missed_dead_withCleared = evalin('caller','fast_errors_missed_dead_withCleared');

slow_correct_made_missed = evalin('caller','slow_correct_made_missed');
slow_errors_made_missed = evalin('caller','slow_errors_made_missed');
fast_correct_made_missed_withCleared = evalin('caller','fast_correct_made_missed_withCleared');
fast_errors_made_missed_withCleared = evalin('caller','fast_errors_made_missed_withCleared');

SRT = evalin('caller','SRT');
correct = evalin('caller','correct');
dead = evalin('caller','dead');

%This version assumes equal drift rates, biases, and boundaries for all screen positions.  This boils the
%model down into a 2AFC condition
minimize = 1; %if set to 0, returns fit statistics and plots using starting values
made_dead_only = 0; %if set to 0, includes all trials irregardless of made/missed deadlines
include_med = 1; %if set to 0, fits only fast and slow conditions.  Fits will be different when MED included
truncate_IQR = 1; %if set to 0, no truncation of SRT distributions
truncval = 1.5;

%%%
% FIT ONLY NEUTRAL AND FAST CONDITIONS?
force_neutral_fast = 0;

if force_neutral_fast; include_med = 0; end

if include_med
    numCond = 3;
else
    disp('SKIPPING NEUTRAL CONDITION...')
    numCond = 2;
end

fr = numCond;
fx = 1;
%SET PARAMETERS TO FIXED OR FREE, 1 FOR Fixed, fr FOR NUMBER OF CONDITIONS
%FREE TO VARY ACROSS FOR THAT PARAMETER
% FORMAT:   A  b  v T0  %%% s assumed to always be fixed
if nargin < 2; plotFlag = 1; end
if nargin < 1; FreeFix = [fr fr fr fr]; end%set all parameters free


tic
A(1:FreeFix(1)) = .01;
b(1:FreeFix(2)) = 100;
v(1:FreeFix(3)) = .55; %found this to work.  Some models will perform worse than all constrained if this is too high.  I.e., it will get stuck in a terrible local minima.
T0(1:FreeFix(4)) = 100;
s = .1; % ALWAYS FIXED;

lb.A(1:FreeFix(1)) = 0;
lb.b(1:FreeFix(2)) = 0;
lb.v(1:FreeFix(3)) = .5; %need this to be set to .5 minimim.  Otherwise, models with all fixed but v tend to quit with terrible fits.  This corrects the problem.
lb.T0(1:FreeFix(4)) = 50;

ub.A(1:FreeFix(1)) = 500;
ub.b(1:FreeFix(2)) = 500;
ub.v(1:FreeFix(3)) = 1;
ub.T0(1:FreeFix(4)) = 800;



% getTrials_SAT


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

Trial_Mat(1:length(correct),1) = NaN;
Trial_Mat(:,2) = NaN; %LEGACY
Trial_Mat(:,3) = correct;
Trial_Mat(:,4) = SRT;
Trial_Mat(:,5) = dead(:,2);


%eliminate error trials that were not saccade direction errors and get rid of catch trials
% remove1 = find(nansum(Errors_(valid_trials,1:4),2));
% remove2 = find(Target_(valid_trials,2) == 255);
% remove3 = find(~ismember(valid_trials,1:size(Target_,1)));
% remove4 = find(isnan(Trial_Mat(:,4)));
% remove = unique([remove1 ; remove2 ; remove3 ; remove4]);
% 
% Trial_Mat(remove,:) = [];


if minimize == 1
    param = [A,b,v,T0];
    lower = [lb.A,lb.b,lb.v,lb.T0];
    upper = [ub.A,ub.b,ub.v,ub.T0];
    %options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    options = optimset('MaxIter', 100000,'MaxFunEvals', 100000,'useparallel','always');
    [solution minval exitflag output] = fminsearchbnd(@(param) fitLBA_SAT_calcLL(param,Trial_Mat),param,lower,upper,options);
    %[solution minval exitflag output] = fminsearch(@(param) fitLBA_SAT_calcLL(param,Trial_Mat),param,options);
    
    % options = gaoptimset('Generations',1000,'StallGenLimit',1000,...
    %    'MigrationDirection','forward','TolFun',1e-10);
    % %options.PopInitRange = [0 0 0; 100 100 100];
    % %options = gaoptimset(options,'HybridFcn', {  @fminsearch [] });
    
    %options = gaoptimset('PopulationSize',[ones(1,numel(param))*30],'Display','iter','useparallel','always');
    %options = gaoptimset('PopulationSize',[ones(1,numel(param))*30]);
    %[solution minval exitflag output] = ga(@(param) fitLBA_SAT_calcLL(param,Trial_Mat),numel(param),[],[],[],[],lower,upper,[],[],options);
    
    A = solution(1:length(A));
    b = solution(length(A)+1:length(A)+length(b));
    v = solution(length(A)+length(b)+1:length(A)+length(b)+length(v));
    T0 = solution(length(A)+length(b)+length(v)+1:length(solution));
    s = repmat(s,1,fr);
    
else
    disp('NOT MINIMIZING: USING STARTING VALUES TO FIT')
    param = [A,b,v,T0];
    s = repmat(s,1,fr);
    
    minval = fitLBA_SAT_calcLL(param,Trial_Mat);
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
    elseif all(FreeFix == 1)
        if ~include_med
            A = repmat(A,1,2);
            b = repmat(b,1,2);
            v = repmat(v,1,2);
            T0 = repmat(T0,1,2);
            s = repmat(s,1,2);
        elseif include_med
            A = repmat(A,1,3);
            b = repmat(b,1,3);
            v = repmat(v,1,3);
            T0 = repmat(T0,1,3);
            s = repmat(s,1,3);
        end
    end
        
        winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
        loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
        t.slow = (1:1000) + T0(1);
        
        if max(FreeFix) == 2
            
            winner.fast = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(2))));
            loser.fast = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),v(2),s(2))));
            t.fast = (1:1000) + T0(2);
            
        elseif max(FreeFix) == 3
            winner.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),1-v(2),s(2))));
            loser.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),s(2)) .* (1-linearballisticCDF(1:1000,A(2),b(2),v(2),s(2))));
            t.med = (1:1000) + T0(2);
            
            winner.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),v(3),s(3)) .* (1-linearballisticCDF(1:1000,A(3),b(3),1-v(3),s(3))));
            loser.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),1-v(3),s(3)) .* (1-linearballisticCDF(1:1000,A(3),b(3),v(3),s(3))));
            t.fast = (1:1000) + T0(3);
        else %all Fixed
            if ~include_med
                winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
                loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
                t.slow = (1:1000) + T0(1);
                
                winner.fast = winner.slow;
                loser.fast = loser.slow;
                t.fast = t.slow;
            elseif include_med
                winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
                loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
                t.slow = (1:1000) + T0(1);
                
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
        
        
        figure
        fon
        
        subplot(1,3,1)
        plot(t.slow,winner.slow,'k',t.slow,loser.slow,'r')
        hold on
        plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok',CDF.slow.err(:,1),CDF.slow.err(:,2),'or','markersize',8)
        ylim([0 1])
        xlim([0 1000])
        text(100,.95,['A = ' mat2str(round(A(1)*100)/100)])
        text(100,.90,['b = ' mat2str(round(b(1)*100)/100)])
        text(100,.85,['v = ' mat2str(round(v(1)*100)/100)])
        text(100,.80,['s = ' mat2str(round(s(1)*100)/100)])
        text(100,.75,['T0 = ' mat2str(round(T0(1)*100)/100)])
        title('SLOW/ACCURATE')
        box off
        
        if ~include_med
            subplot(1,3,3)
            plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
            hold on
            plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or','markersize',8)
            ylim([0 1])
            xlim([0 1000])
            text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
            text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
            text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
            text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
            text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
            title('FAST')
            box off
            
            %[ax h] = suplabel(['LL = ' mat2str(round(minval*100)/100) ' BIC = ' mat2str(round(BIC*1000)/1000)],'t');
            [ax h] = suplabel(['Model: ' mat2str(FreeFix) 'LL = ' mat2str(LL)],'t');
            set(h,'fontsize',12)
            
        elseif include_med
            subplot(1,3,2)
            plot(t.med,winner.med,'k',t.med,loser.med,'r')
            hold on
            plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'or','markersize',8)
            ylim([0 1])
            xlim([0 1000])
            text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
            text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
            text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
            text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
            text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
            title('MEDIUM')
            box off
            
            subplot(1,3,3)
            plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
            hold on
            plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or','markersize',8)
            ylim([0 1])
            xlim([0 1000])
            text(100,.95,['A = ' mat2str(round(A(3)*100)/100)])
            text(100,.90,['b = ' mat2str(round(b(3)*100)/100)])
            text(100,.85,['v = ' mat2str(round(v(3)*100)/100)])
            text(100,.80,['s = ' mat2str(round(s(3)*100)/100)])
            text(100,.75,['T0 = ' mat2str(round(T0(3)*100)/100)])
            title('FAST')
            box off
            
            %[ax h] = suplabel(['LL = ' mat2str(round(minval*100)/100) ' BIC = ' mat2str(round(BIC*1000)/1000)],'t');
            [ax h] = suplabel(['Model: ' mat2str(FreeFix) 'LL = ' mat2str(LL)],'t');
            set(h,'fontsize',12)
            
        end
        
        %now create a plot where all conditions are plotted together on same axis
%         figure
%         if ~include_med
%             subplot(2,2,1)
%             plot(t.slow,winner.slow,'r',t.slow,loser.slow,'--r',t.fast,winner.fast,'g',t.fast,lose.fast,'--g')
%             hold on
%             plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'or',CDF.slow.err(:,1),CDF.slow.err(:,2),'or', ...
%                 CDF.fast.correct(:,1),CDF.fast.correct(:,2),'og',CDF.fast.err(:,1),CDF.fast.err(:,2),'og')
%             xlim([150 900])
%             ylim([0 1])
%             set(gca,'xminortick','on')
%             box off
%         elseif include_med
%             subplot(2,2,1)
%             plot(t.slow,winner.slow,'r',t.slow,loser.slow,'--r', ...
%                 t.med,winner.med,'k',t.med,loser.med,'--k', ...
%                 t.fast,winner.fast,'g',t.fast,loser.fast,'--g')
%             hold on
%             plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'or',CDF.slow.err(:,1),CDF.slow.err(:,2),'or', ...
%                 CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'ok', ...
%                 CDF.fast.correct(:,1),CDF.fast.correct(:,2),'og',CDF.fast.err(:,1),CDF.fast.err(:,2),'og')
%             xlim([150 900])
%             ylim([0 1])
%             set(gca,'xminortick','on')
%             box off
%         end

end
    
    disp(['Optimization ran for ' mat2str(round((toc/60)*1000)/1000) ' minutes'])