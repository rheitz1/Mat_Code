function [solution,LL,AIC,BIC,CDF,Trial_Mat] = fitLBA_oneCond(FreeFix,plotFlag)

rand('seed',5150);
randn('seed',5150);

Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
Target_ = evalin('caller','Target_');
%SAT_ = evalin('caller','SAT_');
SRT = evalin('caller','SRT');

%This version assumes equal drift rates, biases, and boundaries for all screen positions.  This boils the
%model down into a 2AFC condition
minimize = 1; %if set to 0, returns fit statistics and plots using starting values
minimize_routine = 'MLE'; %MLE or X2? %NOTE: X2 seems more sensitive than MLE to starting values
truncate_IQR = 1; %if set to 0, no truncation of SRT distributions
truncval = 1.5;

s_is_free = 1; %do you want the parameter s to be free?

if truncate_IQR
    %calculate limits excluding catch trials, if they exist
    noCatch = find(Target_(:,2) ~= 255);
    disp(['Truncating ' mat2str(truncval) ' * IQR'])
    highcut = nanmedian(SRT(noCatch,1)) + truncval * iqr(SRT(noCatch,1));
    lowcut = nanmedian(SRT(noCatch,1)) - truncval * iqr(SRT(noCatch,1));
    
    removeA = find(SRT(:,1) < lowcut | SRT(:,1) > highcut);
    disp(['Removing ' mat2str(length(removeA)) ' trials due to IQR criterion'])
else
    removeA = [];

end




% FORMAT:   A  b  v T0  %%% s assumed to always be fixed
if nargin < 2; plotFlag = 1; end
%if nargin < 1; FreeFix = [fr fr fr fr]; end %set all parameters free
FreeFix = [1 1 1 1 1];

A = .01;
b = 100;
v = .7; %found this to work.  Some models will perform worse than all constrained if this is too high.  I.e., it will get stuck in a terrible local minima.
T0 = 40;
s = .1;


lb.A = 0;
lb.b = 0;
lb.v = .5; %need this to be set to .5 minimim.  Otherwise, models with all fixed but v tend to quit with terrible fits.  This corrects the problem.
lb.T0 = 40;
lb.s = .01;

ub.A = 700;
ub.b = 800;
ub.v = 1;
ub.T0 = 1000;
ub.s = 1;

valid_trials = 1:size(SRT,1);

Trial_Mat(:,1) = Target_(valid_trials,2);
Trial_Mat(:,2) = NaN; %LEGACY
Trial_Mat(:,3) = Correct_(valid_trials,2);
Trial_Mat(:,4) = SRT(valid_trials,1);
%Trial_Mat(:,5) = SAT_(valid_trials,1);


%eliminate error trials that were not saccade direction errors and get rid of catch trials
remove1 = find(nansum(Errors_(valid_trials,1:4),2));
remove2 = find(Target_(valid_trials,2) == 255);
remove3 = find(~ismember(valid_trials,1:size(Target_,1)));
remove4 = find(isnan(Trial_Mat(:,4)));
remove5 = find(isnan(Trial_Mat(:,3)));

remove = unique([removeA ; remove1 ; remove2 ; remove3 ; remove4 ; remove5]);

Trial_Mat(remove,:) = [];

tic
if minimize == 1
    if s_is_free
        param = [A,b,v,T0,s];
    else
        param = [A,b,v,T0];
    end
    
    if s_is_free
        lower = [lb.A,lb.b,lb.v,lb.T0,lb.s];
        upper = [ub.A,ub.b,ub.v,ub.T0,ub.s];
    else
        lower = [lb.A,lb.b,lb.v,lb.T0];
        upper = [ub.A,ub.b,ub.v,ub.T0];
    end
    
    %options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    options = optimset('MaxIter', 100000,'MaxFunEvals', 100000,'useparallel','always');
    
    if strmatch(minimize_routine,'MLE','exact')
        [solution minval exitflag output] = fminsearchbnd(@(param) fitLBA_oneCond_calcLL(param,Trial_Mat),param,lower,upper,options);
        %[solution minval exitflag output] = fminsearch(@(param) fitLBA_SAT_calcLL(param,Trial_Mat),param,options);
        
%        options = gaoptimset('Generations',1000,'StallGenLimit',1000,...
%           'MigrationDirection','forward','TolFun',1e-10,'Display','iter','useparallel','always');
% 
%         options = gaoptimset(options,'HybridFcn', {  @fminsearch [] });
%         options = gaoptimset(options,'PopulationSize',[ones(1,numel(param))*30]);
%         [solution minval exitflag output] = ga(@(param) fitLBA_oneCond_calcLL(param,Trial_Mat),numel(param),[],[],[],[],lower,upper,[],[],options);
    elseif strmatch(minimize_routine,'X2','exact')
        [solution minval exitflag output] = fminsearchbnd(@(param) fitLBA_oneCond_calcX2(param,Trial_Mat),param,lower,upper,options);
        %[solution minval exitflag output] = fminsearch(@(param) fitLBA_SAT_calcX2(param,Trial_Mat),param,options);
        
        % options = gaoptimset('Generations',1000,'StallGenLimit',1000,...
        %    'MigrationDirection','forward','TolFun',1e-10);
        % %options.PopInitRange = [0 0 0; 100 100 100];
        % %options = gaoptimset(options,'HybridFcn', {  @fminsearch [] });
        
        %options = gaoptimset('PopulationSize',[ones(1,numel(param))*30],'Display','iter','useparallel','always');
        %options = gaoptimset('PopulationSize',[ones(1,numel(param))*30]);
        %[solution minval exitflag output] = ga(@(param) fitLBA_SAT_calcX2(param,Trial_Mat),numel(param),[],[],[],[],lower,upper,[],[],options);
        
    end
    
    
    if s_is_free
        [A b v T0 s] = disperse(solution);
    else
        [A b v T0] = disperse(solution);
    end
    
%     A = solution(1:length(A));
%     b = solution(length(A)+1:length(A)+length(b));
%     v = solution(length(A)+length(b)+1:length(A)+length(b)+length(v));
%     T0 = solution(length(A)+length(b)+length(v)+1:length(solution));
%     s = repmat(s,1,fr);
    
else
    disp('NOT MINIMIZING: USING STARTING VALUES TO FIT')
    param = [A,b,v,T0,s];
    
    
    if strmatch(minimize_routine,'MLE','exact')
        minval = fitLBA_oneCond_calcLL(param,Trial_Mat);
    elseif strmatch(minimize_routine,'X2','exact')
        minval = fitLBA_oneCond_calcX2(param,Trial_Mat);
    end
    
    solution = param; %since we are not minimizing, take starting values as solution.
end
%Bayesian Information Criterion
n_free = numel(param);
n_obs = size(Trial_Mat,1);
LL = -minval; %reset back to positive number, since we minimized the negative to maximize the positive
[AIC BIC] = aicbic(LL,n_free,n_obs);

trls.err = find(Trial_Mat(:,3) == 0);
trls.correct = find(Trial_Mat(:,3) == 1);

%return defective CDFs of current dataset
CDFs = getDefectiveCDF(trls.correct,trls.err,Trial_Mat(:,4));


if plotFlag
    
    winner = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),1-v(1),s(1))));
    loser = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),s(1)) .* (1-linearballisticCDF(1:1000,A(1),b(1),v(1),s(1))));
    t = (1:1000) + T0(1);
    
    figure
    fon
    
    plot(t,winner,'k',t,loser,'r')
    hold on
    plot(CDFs.correct(:,1),CDFs.correct(:,2),'ok',CDFs.err(:,1),CDFs.err(:,2),'or','markersize',8)
    ylim([0 1])
    xlim([0 1000])
    text(100,.95,['A = ' mat2str(round(A(1)*100)/100)])
    text(100,.90,['b = ' mat2str(round(b(1)*100)/100)])
    text(100,.85,['v = ' mat2str(round(v(1)*100)/100)])
    text(100,.80,['s = ' mat2str(round(s(1)*100)/100)])
    text(100,.75,['T0 = ' mat2str(round(T0(1)*100)/100)])
    box off
    %
    %         if ~include_med
    %             subplot(1,3,3)
    %             plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
    %             hold on
    %             plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or','markersize',8)
    %             ylim([0 1])
    %             xlim([0 1000])
    %             text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
    %             text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
    %             text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
    %             text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
    %             text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
    %             title('FAST')
    %             box off
    %
    %             %[ax h] = suplabel(['LL = ' mat2str(round(minval*100)/100) ' BIC = ' mat2str(round(BIC*1000)/1000)],'t');
    %             [ax h] = suplabel(['Model: ' mat2str(FreeFix) 'LL = ' mat2str(LL)],'t');
    %             set(h,'fontsize',12)
    %
    %         elseif include_med
    %             subplot(1,3,2)
    %             plot(t.med,winner.med,'k',t.med,loser.med,'r')
    %             hold on
    %             plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok',CDF.med.err(:,1),CDF.med.err(:,2),'or','markersize',8)
    %             ylim([0 1])
    %             xlim([0 1000])
    %             text(100,.95,['A = ' mat2str(round(A(2)*100)/100)])
    %             text(100,.90,['b = ' mat2str(round(b(2)*100)/100)])
    %             text(100,.85,['v = ' mat2str(round(v(2)*100)/100)])
    %             text(100,.80,['s = ' mat2str(round(s(2)*100)/100)])
    %             text(100,.75,['T0 = ' mat2str(round(T0(2)*100)/100)])
    %             title('MEDIUM')
    %             box off
    %
    %             subplot(1,3,3)
    %             plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')
    %             hold on
    %             plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or','markersize',8)
    %             ylim([0 1])
    %             xlim([0 1000])
    %             text(100,.95,['A = ' mat2str(round(A(3)*100)/100)])
    %             text(100,.90,['b = ' mat2str(round(b(3)*100)/100)])
    %             text(100,.85,['v = ' mat2str(round(v(3)*100)/100)])
    %             text(100,.80,['s = ' mat2str(round(s(3)*100)/100)])
    %             text(100,.75,['T0 = ' mat2str(round(T0(3)*100)/100)])
    %             title('FAST')
    %             box off
    %
    %             %[ax h] = suplabel(['LL = ' mat2str(round(minval*100)/100) ' BIC = ' mat2str(round(BIC*1000)/1000)],'t');
    %             [ax h] = suplabel(['Model: ' mat2str(FreeFix) 'LL = ' mat2str(LL)],'t');
    %             set(h,'fontsize',12)
    %
    %         end
    
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