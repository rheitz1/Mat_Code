
%NOTE: Some trials where there was 'no response' actually include
%half-assed, small vector saccades.  To pick these up, have to re-run
%getSRT with lower threshold (for Q, use .000016).
plotBeh = 1;
plotNeurons = 1;
trunc_RT = 2000;

%do you want to discount FAST trials where display was cleared?
remove_cleared_display = 1;


if exist('saccLoc') == 0
    %[SRT saccLoc] = getSRT(EyeX_,EyeY_,0,'Q',.000016);
    [SRT saccLoc] = getSRT(EyeX_,EyeY_);
end


if remove_cleared_display == 0
    %============
    % FIND TRIALS
    
    %All correct trials w/ made deadlines
    slow_correct_made_dead = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_correct_made_dead = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
    
    slow_errors_made_dead = find(Correct_(:,2) == 0 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_errors_made_dead = find(Correct_(:,2) == 0 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
    
    
    %All trials w/ made deadlines
    slow_all_made_dead = [slow_correct_made_dead ; slow_errors_made_dead];
    fast_all_made_dead = [fast_correct_made_dead ; fast_errors_made_dead];
    
    
    %All correct trials w/ missed deadlines (too late in FAST/too early in SLOW
    slow_correct_missed_dead = find(Errors_(:,6) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
    fast_correct_missed_dead = find(Errors_(:,7) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
    
    slow_errors_missed_dead = find(isnan(Errors_(:,6)) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
    fast_errors_missed_dead = find(isnan(Errors_(:,7)) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3));
    
    %All trials w/ missed deadlines
    slow_all_missed_dead = [slow_correct_missed_dead ; slow_errors_missed_dead];
    fast_all_missed_dead = [fast_correct_missed_dead ; fast_errors_missed_dead];
    
    
    %All correct trials made + missed
    slow_correct_made_missed = [slow_correct_made_dead ; slow_correct_missed_dead];
    fast_correct_made_missed = [fast_correct_made_dead ; fast_correct_missed_dead];
    
    
    %All trials made + missed
    slow_all = [slow_all_made_dead ; slow_all_missed_dead];
    fast_all = [fast_all_made_dead ; fast_all_missed_dead];
    
elseif remove_cleared_display == 1
    %===================================================================
    % NOTE: NEED TO GET RID OF *ALL* CLEARED DISPLAY TRIALS BECAUSE IT
    % APPEARS THAT EVEN WHEN DEADLINE MET AND CORRECT, DISPLAY DISAPPEARS
    % QUICKLY THEREAFTER.
    
    %All correct trials w/ made deadlines
    slow_correct_made_dead = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_correct_made_dead = find(Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);
    
    slow_errors_made_dead = find(Correct_(:,2) == 0 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_errors_made_dead = find(Correct_(:,2) == 0 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);
    
    
    %All trials w/ made deadlines
    slow_all_made_dead = [slow_correct_made_dead ; slow_errors_made_dead];
    fast_all_made_dead = [fast_correct_made_dead ; fast_errors_made_dead];
    
    
    %All correct trials w/ missed deadlines (too late in FAST/too early in SLOW
    % This time discard any trials where deadline was missed and display
    % was cleared
    slow_correct_missed_dead = find(Errors_(:,6) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
    fast_correct_missed_dead = find(Errors_(:,7) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3) & SAT_(:,11) == 0);
    
    slow_errors_missed_dead = find(isnan(Errors_(:,6)) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) < SAT_(:,3));
    fast_errors_missed_dead = find(isnan(Errors_(:,7)) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) > SAT_(:,3) & SAT_(:,11) == 0);
    
    %All trials w/ missed deadlines
    slow_all_missed_dead = [slow_correct_missed_dead ; slow_errors_missed_dead];
    fast_all_missed_dead = [fast_correct_missed_dead ; fast_errors_missed_dead];
    
    
    %All correct trials made + missed
    slow_correct_made_missed = [slow_correct_made_dead ; slow_correct_missed_dead];
    fast_correct_made_missed = [fast_correct_made_dead ; fast_correct_missed_dead];
    
    
    %All trials made + missed
    slow_all = [slow_all_made_dead ; slow_all_missed_dead];
    fast_all = [fast_all_made_dead ; fast_all_missed_dead];
    
end
%===============

%======
% To try:  play back FAST trials where deadline missed and display cleared.
% Make sure that this catches the 'juke' trials




%====================
% Calculate ACC rates
%percentage of CORRECT trials that missed the deadline
prc_missed_slow_correct = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
prc_missed_fast_correct = length(fast_correct_missed_dead) / (length(fast_correct_made_dead) + length(fast_correct_missed_dead));

%ACC rate for made deadlines
ACC.slow_made_dead = length(slow_correct_made_dead) / length(slow_all_made_dead);
ACC.fast_made_dead = length(fast_correct_made_dead) / length(fast_all_made_dead);


%ACC rate for missed deadlines
ACC.slow_missed_dead = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
ACC.fast_missed_dead = length(fast_correct_missed_dead) / length(fast_all_missed_dead);


%overall ACC rate for made + missed deadlines
ACC.slow_made_missed = length(slow_correct_made_missed) / length(slow_all);
ACC.fast_made_missed = length(fast_correct_made_missed) / length(fast_all);


% CDFs for correct trials, made deadlines
[bins_correct_fast_made_dead cdf_correct_fast_made_dead] = getCDF(SRT(fast_correct_made_dead,1),50);
[bins_correct_slow_made_dead cdf_correct_slow_made_dead] = getCDF(SRT(slow_correct_made_dead,1),50);

% CDFs for correct trials, made + missed deadlines
[bins_correct_slow_made_missed cdf_correct_slow_made_missed] = getCDF(SRT(slow_correct_made_missed,1),50);
[bins_correct_fast_made_missed cdf_correct_fast_made_missed] = getCDF(SRT(fast_correct_made_missed,1),50);


if plotBeh == 1
    figure
    subplot(3,2,1)
    plot(bins_correct_slow_made_dead,cdf_correct_slow_made_dead,'k', ...
        bins_correct_fast_made_dead,cdf_correct_fast_made_dead,'r')
    %legend('Slow','Medium','Fast','location','northwest')
    xlim([0 1000])
    vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs all made deadlines')
    
    subplot(3,2,2)
    bar(1:2,[ACC.slow_made_dead ACC.fast_made_dead])
    ylim([.5 1])
    set(gca,'xticklabel',['slow' ; 'fast'])
    title('ACC all made deadlines')
    
    subplot(3,2,3)
    plot(bins_correct_slow_made_missed,cdf_correct_slow_made_missed,'k', ...
        bins_correct_fast_made_missed,cdf_correct_fast_made_missed,'r')
    xlim([0 1000])
    vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs missed + made deadlines')
    
    subplot(3,2,4)
    bar(1:2,[ACC.slow_made_missed ACC.fast_made_missed])
    ylim([.5 1])
    set(gca,'xticklabel',['slow';'fast'])
    title('ACC missed + made deadlines')
    
    
    
    
    %================
    % Histograms
    multiHist_SAT(50,slow_correct_made_dead,fast_correct_made_dead)
    title('Correct Made Deadlines')
    
    multiHist_SAT(50,slow_correct_made_missed,fast_correct_made_missed)
    title('Correct Made + Missed Deadlines')
    
end

if plotNeurons
    varlist = who;
    neuronList = varlist(strmatch('DSP',varlist));
    
    %make subplots based on number of usable RFs / MFs
    %target aligned vis and vis-move
    
    figure
    
    numPlots = length(find(~structfun(@isempty,RFs)));
    if numPlots == 1
        plotspace = [1 1];
    elseif numPlots == 2
        plotspace = [1 2];
    elseif numPlots > 2 & numPlots <= 4
        plotspace = [2 2];
    elseif numPlots >4 & numPlots <= 6
        plotspace = [2 3];
    elseif numPlots > 6 & numPlots <= 9
        plotspace = [3 3];
    elseif numPlots > 9 & numPlots <= 16
        plotspace = [4 4];
    end
    
    cur_plot = 0;
    
    for neuron = 1:length(neuronList)
        
        if isempty(RFs.(neuronList{neuron}))
            continue
        else
            
            cur_plot = cur_plot + 1;
            
            sig = eval(neuronList{neuron});
            SDF = sSDF(sig,Target_(:,1),[-100 500]);
            
            RF = RFs.(neuronList{neuron});
            antiRF = mod((RF+4),8);
            
            inRF = find(ismember(Target_(:,2),RF));
            outRF = find(ismember(Target_(:,2),antiRF));
            
            in.slow_correct_made_missed = intersect(inRF,slow_correct_made_missed);
            out.slow_correct_made_missed = intersect(outRF,slow_correct_made_missed);
            
            in.fast_correct_made_missed = intersect(inRF,fast_correct_made_missed);
            out.fast_correct_made_missed = intersect(outRF,fast_correct_made_missed);
            
            subplot(plotspace(1),plotspace(2),cur_plot)
            
            plot(-100:500,nanmean(SDF(in.slow_correct_made_missed,:)),'b', ...
                -100:500,nanmean(SDF(out.slow_correct_made_missed,:)),'--b', ...
                -100:500,nanmean(SDF(in.fast_correct_made_missed,:)),'r', ...
                -100:500,nanmean(SDF(out.fast_correct_made_missed,:)),'--r')
            xlim([-100 500])
            
            TDT.slow = getTDT_SP(sig,in.slow_correct_made_missed,out.slow_correct_made_missed);
            TDT.fast = getTDT_SP(sig,in.fast_correct_made_missed,out.fast_correct_made_missed);
            vline(TDT.slow,'b')
            vline(TDT.fast,'r')
            
            title(neuronList{neuron})
        end
        
    end
    [ax h] = suplabel('Made + Missed Target-Aligned','t');
    set(h,'fontsize',14)
    
    
    %response aligned vis-move and move
    
    figure
    
    numPlots = length(find(~structfun(@isempty,MFs)));
    if numPlots == 1
        plotspace = [1 1];
    elseif numPlots == 2
        plotspace = [1 2];
    elseif numPlots > 2 & numPlots <= 4
        plotspace = [2 2];
    elseif numPlots >4 & numPlots <= 6
        plotspace = [2 3];
    elseif numPlots > 6 & numPlots <= 9
        plotspace = [3 3];
    elseif numPlots > 9 & numPlots <= 16
        plotspace = [4 4];
    end
    
    cur_plot = 0;
    
    for neuron = 1:length(neuronList)
        
        if isempty(MFs.(neuronList{neuron}))
            continue
        else
            
            cur_plot = cur_plot + 1;
            
            sig = eval(neuronList{neuron});
            SDF_r = sSDF(sig,SRT(:,1)+500,[-400 200]);
            
            MF = MFs.(neuronList{neuron});
            antiMF = mod((MF+4),8);
            
            inMF = find(ismember(Target_(:,2),MF));
            outMF = find(ismember(Target_(:,2),antiMF));
            
            in.slow_correct_made_missed = intersect(inMF,slow_correct_made_missed);
            out.slow_correct_made_missed = intersect(outMF,slow_correct_made_missed);
            
            in.fast_correct_made_missed = intersect(inMF,fast_correct_made_missed);
            out.fast_correct_made_missed = intersect(outMF,fast_correct_made_missed);
            
            subplot(plotspace(1),plotspace(2),cur_plot)
            
            plot(-400:200,nanmean(SDF_r(in.slow_correct_made_missed,:)),'b', ...
                -400:200,nanmean(SDF_r(out.slow_correct_made_missed,:)),'--b', ...
                -400:200,nanmean(SDF_r(in.fast_correct_made_missed,:)),'r', ...
                -400:200,nanmean(SDF_r(out.fast_correct_made_missed,:)),'--r')
            xlim([-400 200])
            
            vline(0,'k')
            title(neuronList{neuron})
            
            
        end
    end
    [ax h] = suplabel('Made + Missed Saccade-Aligned','t');
    set(h,'fontsize',14)
end

tileFigs

%clear slow* med* fast* bins* cdf* new_Correct_ num_of_sets sets first_in_set curr_set