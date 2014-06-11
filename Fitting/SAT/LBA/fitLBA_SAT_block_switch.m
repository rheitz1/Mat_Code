function [solution,LL,CDF] = fitLBA_SAT_block_switch(FreeFix,plotFlag)

%clear Trial_Mat remove* A b v s T0 lb ub

Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
Target_ = evalin('caller','Target_');
SAT_ = evalin('caller','SAT_');
SRT = evalin('caller','SRT');

%This version assumes equal drift rates, biases, and boundaries for all screen positions.  This boils the
%model down into a 2AFC condition
minimize = 1; %if set to 0, returns fit statistics and plots using starting values
made_dead_only = 1; %if set to 0, includes all trials irregardless of made/missed deadlines
include_med = 0; %if set to 0, fits only fast and slow conditions.  Fits will be different when MED included
truncate_IQR = 1; %if set to 0, no truncation of SRT distributions
truncval = 1.5;

if include_med
    numCond = 3;
else
    numCond = 2;
end

fr = numCond;
fx = 1;
%SET PARAMETERS TO FIXED OR FREE, 1 FOR Fixed, fr FOR NUMBER OF CONDITIONS
%FREE TO VARY ACROSS FOR THAT PARAMETER
% FORMAT:   A  b  v T0  %%% s assumed to always be fixed
if nargin < 2; plotFlag = 1; end
if nargin < 1; FreeFix = [fx fx fx fx]; end %for this analysis, allow only 1 value for each parameter


tic
A(1:FreeFix(1)) = 1;
b(1:FreeFix(2)) = 100;
v(1:FreeFix(3)) = .6;
T0(1:FreeFix(4)) = 100;
s = .1; % ALWAYS FIXED;

lb.A(1:FreeFix(1)) = .001;
lb.b(1:FreeFix(2)) = 0;
lb.v(1:FreeFix(3)) = 0;
lb.T0(1:FreeFix(4)) = 50;

ub.A(1:FreeFix(1)) = 500;
ub.b(1:FreeFix(2)) = 500;
ub.v(1:FreeFix(3)) = 1;
ub.T0(1:FreeFix(4)) = 800;



blk_switch = find(abs(diff(SAT_(:,1))) ~= 0) + 1;

%find corresponding conditions
fast_to_slow = blk_switch(find(SAT_(blk_switch-1,1) == 3 & SAT_(blk_switch,1) == 1));
slow_to_fast = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 3));

lag_window = -2:2;

%================================
%5 trial window centered on switch

%FAST to SLOW
fast_to_slow = repmat(fast_to_slow,1,5);
fast_to_slow = fast_to_slow + repmat(lag_window,size(fast_to_slow,1),1);
fast_to_slow(any(fast_to_slow > size(SRT,1),2),:) = []; %removes any indices that are out of bounds


%SLOW to FAST
slow_to_fast = repmat(slow_to_fast,1,5);
slow_to_fast = slow_to_fast + repmat(lag_window,size(slow_to_fast,1),1);
slow_to_fast(any(slow_to_fast > size(SRT,1),2),:) = []; %removes any indices that are out of bounds

slow_correct_made_dead = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
fast_correct_made_dead_withCleared = find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
slow_errors_made_dead = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
fast_errors_made_dead_withCleared = find(Errors_(:,5) == 1 & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));

allValid = [slow_correct_made_dead ; fast_correct_made_dead_withCleared ; slow_errors_made_dead ; fast_errors_made_dead_withCleared];

%remove missed deadline trials
missed.fast_to_slow = ismember(fast_to_slow,setdiff(fast_to_slow(:),allValid));
missed.slow_to_fast = ismember(slow_to_fast,setdiff(slow_to_fast(:),allValid));

fast_to_slow = fast_to_slow .* (1-missed.fast_to_slow);
fast_to_slow(fast_to_slow == 0) = NaN;

slow_to_fast = slow_to_fast .* (1-missed.slow_to_fast);
slow_to_fast(slow_to_fast == 0) = NaN;


for switchTrl = 1:5
    curr_trls.slow_to_fast = removeNaN(slow_to_fast(:,switchTrl));
    curr_trls.fast_to_slow = removeNaN(fast_to_slow(:,switchTrl));
    
    Trial_Mat.slow_to_fast(:,1) = Target_(curr_trls.slow_to_fast,2);
    Trial_Mat.slow_to_fast(:,2) = NaN; %LEGACY
    Trial_Mat.slow_to_fast(:,3) = Correct_(curr_trls.slow_to_fast,2);
    Trial_Mat.slow_to_fast(:,4) = SRT(curr_trls.slow_to_fast,1);
    Trial_Mat.slow_to_fast(:,5) = SAT_(curr_trls.slow_to_fast,1);
    
    Trial_Mat.fast_to_slow(:,1) = Target_(curr_trls.fast_to_slow,2);
    Trial_Mat.fast_to_slow(:,2) = NaN; %LEGACY
    Trial_Mat.fast_to_slow(:,3) = Correct_(curr_trls.fast_to_slow,2);
    Trial_Mat.fast_to_slow(:,4) = SRT(curr_trls.fast_to_slow,1);
    Trial_Mat.fast_to_slow(:,5) = SAT_(curr_trls.fast_to_slow,1);
    
    
    
    %eliminate error trials that were not saccade direction errors and get rid of catch trials
    % remove1 = find(nansum(Errors_(valid_trials,1:4),2));
    % remove2 = find(Target_(valid_trials,2) == 255);
    % remove3 = find(~ismember(valid_trials,1:size(Target_,1)));
    % remove = unique([remove1 ; remove2 ; remove3]);
    %
    % Trial_Mat(remove,:) = [];
    
    
    if minimize == 1
        param = [A,b,v,T0];
        lower = [lb.A,lb.b,lb.v,lb.T0];
        upper = [ub.A,ub.b,ub.v,ub.T0];
        options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
        [solution.slow_to_fast minval exitflag output] = fminsearchbnd(@(param) fitLBA_SAT_calcLL_block_switch(param,Trial_Mat.slow_to_fast),param,lower,upper,options);
        [solution.fast_to_slow minval exitflag output] = fminsearchbnd(@(param) fitLBA_SAT_calcLL_block_switch(param,Trial_Mat.fast_to_slow),param,lower,upper,options);
        
        A_solution.slow_to_fast(switchTrl,1) = solution.slow_to_fast(1);
        b_solution.slow_to_fast(switchTrl,1) = solution.slow_to_fast(2);
        v_solution.slow_to_fast(switchTrl,1) = solution.slow_to_fast(3);
        T0_solution.slow_to_fast(switchTrl,1) = solution.slow_to_fast(4);
        s_solution.slow_to_fast(switchTrl,1) = .1;
        
        A_solution.fast_to_slow(switchTrl,1) = solution.fast_to_slow(1);
        b_solution.fast_to_slow(switchTrl,1) = solution.fast_to_slow(2);
        v_solution.fast_to_slow(switchTrl,1) = solution.fast_to_slow(3);
        T0_solution.fast_to_slow(switchTrl,1) = solution.fast_to_slow(4);
        s_solution.fast_to_slow(switchTrl,1) = .1;
        
    else
        %         s = repmat(s,1,fr);
        %
        %         minval = fitLBA_SAT_fs_calcLL_FREEFIXED(param,Trial_Mat);
        
    end
    
    LL = -minval; %reset back to positive number, since we minimized the negative to maximize the positive
    
    
    
    err.slow_to_fast = find(Trial_Mat.slow_to_fast(:,3) == 0);
    correct.slow_to_fast = find(Trial_Mat.slow_to_fast(:,3) == 1);
    
    err.fast_to_slow = find(Trial_Mat.fast_to_slow(:,3) == 0);
    correct.fast_to_slow = find(Trial_Mat.fast_to_slow(:,3) == 1);
    
    currCDF.slow_to_fast = getDefectiveCDF(correct.slow_to_fast,err.slow_to_fast,Trial_Mat.slow_to_fast(:,4));
    currCDF.fast_to_slow = getDefectiveCDF(correct.fast_to_slow,err.fast_to_slow,Trial_Mat.fast_to_slow(:,4));
    
    CDF.slow_to_fast.correct(:,1:2,switchTrl) = currCDF.slow_to_fast.correct;
    CDF.slow_to_fast.err(:,1:2,switchTrl) = currCDF.slow_to_fast.err;
    CDF.fast_to_slow.correct(:,1:2,switchTrl) = currCDF.fast_to_slow.correct;
    CDF.fast_to_slow.err(:,1:2,switchTrl) = currCDF.fast_to_slow.err;
    
    
    if plotFlag
        
        % %this is kludgy, but will work for plotting.  Tile parameters as if they were free, but just replicate
        % %those that are fixed
        %         A.slow_to_fast = A.slow_to_fast(switchTrl);
        %         b.slow_to_fast = b.slow_to_fast(switchTrl);
        %         v.slow_to_fast = v.slow_to_fast(switchTrl);
        %         T0.slow_to_fast = T0.slow_to_fast(switchTrl);
        %
        %         A.fast_to_slow = A.fast_to_slow(switchTrl);
        %         b.fast_to_slow = b.fast_to_slow(switchTrl);
        %         v.fast_to_slow = v.fast_to_slow(switchTrl);
        %         T0.fast_to_slow = T0.fast_to_slow(switchTrl);
        
        
        
        winner.slow_to_fast = cumsum(linearballisticPDF(1:1000,A_solution.slow_to_fast(switchTrl),b_solution.slow_to_fast(switchTrl),v_solution.slow_to_fast(switchTrl),s_solution.slow_to_fast(switchTrl)) .* (1-linearballisticCDF(1:1000,A_solution.slow_to_fast(switchTrl),b_solution.slow_to_fast(switchTrl),1-v_solution.slow_to_fast(switchTrl),s_solution.slow_to_fast(switchTrl))));
        loser.slow_to_fast = cumsum(linearballisticPDF(1:1000,A_solution.slow_to_fast(switchTrl),b_solution.slow_to_fast(switchTrl),1-v_solution.slow_to_fast(switchTrl),s_solution.slow_to_fast(switchTrl)) .* (1-linearballisticCDF(1:1000,A_solution.slow_to_fast(switchTrl),b_solution.slow_to_fast(switchTrl),v_solution.slow_to_fast(switchTrl),s_solution.slow_to_fast(switchTrl))));
        
        winner.fast_to_slow = cumsum(linearballisticPDF(1:1000,A_solution.fast_to_slow(switchTrl),b_solution.fast_to_slow(switchTrl),v_solution.fast_to_slow(switchTrl),s_solution.fast_to_slow(switchTrl)) .* (1-linearballisticCDF(1:1000,A_solution.fast_to_slow(switchTrl),b_solution.fast_to_slow(switchTrl),1-v_solution.fast_to_slow(switchTrl),s_solution.fast_to_slow(switchTrl))));
        loser.fast_to_slow = cumsum(linearballisticPDF(1:1000,A_solution.fast_to_slow(switchTrl),b_solution.fast_to_slow(switchTrl),1-v_solution.fast_to_slow(switchTrl),s_solution.fast_to_slow(switchTrl)) .* (1-linearballisticCDF(1:1000,A_solution.fast_to_slow(switchTrl),b_solution.fast_to_slow(switchTrl),v_solution.fast_to_slow(switchTrl),s_solution.fast_to_slow(switchTrl))));
        
        t.slow_to_fast = (1:1000) + T0_solution.slow_to_fast(switchTrl);
        t.fast_to_slow = (1:1000) + T0_solution.fast_to_slow(switchTrl);
        
        
        figure
        subplot(1,2,1)
        fon
        
        plot(t.slow_to_fast,winner.slow_to_fast,'k',t.slow_to_fast,loser.slow_to_fast,'r')
        hold on
        plot(CDF.slow_to_fast.correct(:,1,switchTrl),CDF.slow_to_fast.correct(:,2,switchTrl),'ok',CDF.slow_to_fast.err(:,1,switchTrl),CDF.slow_to_fast.err(:,2,switchTrl),'or')
        ylim([0 1])
        xlim([0 1000])
        text(100,.95,['A = ' mat2str(round(A_solution.slow_to_fast(switchTrl)*100)/100)])
        text(100,.90,['b = ' mat2str(round(b_solution.slow_to_fast(switchTrl)*100)/100)])
        text(100,.85,['v = ' mat2str(round(v_solution.slow_to_fast(switchTrl)*100)/100)])
        text(100,.80,['s = ' mat2str(round(s_solution.slow_to_fast(switchTrl)*100)/100)])
        text(100,.75,['T0 = ' mat2str(round(T0_solution.slow_to_fast(switchTrl)*100)/100)])
        title(['Slow to Fast Relative Trial = ' mat2str(switchTrl)])
        box off
        
        subplot(1,2,2)
        fon
        
        plot(t.fast_to_slow,winner.fast_to_slow,'k',t.fast_to_slow,loser.fast_to_slow,'r')
        hold on
        plot(CDF.fast_to_slow.correct(:,1,switchTrl),CDF.fast_to_slow.correct(:,2,switchTrl),'ok',CDF.fast_to_slow.err(:,1,switchTrl),CDF.fast_to_slow.err(:,2,switchTrl),'or')
        ylim([0 1])
        xlim([0 1000])
        text(100,.95,['A = ' mat2str(round(A_solution.fast_to_slow(switchTrl)*100)/100)])
        text(100,.90,['b = ' mat2str(round(b_solution.fast_to_slow(switchTrl)*100)/100)])
        text(100,.85,['v = ' mat2str(round(v_solution.fast_to_slow(switchTrl)*100)/100)])
        text(100,.80,['s = ' mat2str(round(s_solution.fast_to_slow(switchTrl)*100)/100)])
        text(100,.75,['T0 = ' mat2str(round(T0_solution.fast_to_slow(switchTrl)*100)/100)])
        
        title(['Fast to Slow Relative Trial = ' mat2str(switchTrl)])
        box off
        
        
    end
    clear Trial_Mat
end

solution.A = A_solution;
solution.b = b_solution;
solution.v = v_solution;
solution.T0 = T0_solution;
solution.s = s_solution;

