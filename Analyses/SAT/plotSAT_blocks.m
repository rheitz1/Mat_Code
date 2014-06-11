
%NOTE: Some trials where there was 'no response' actually include
%half-assed, small vector saccades.  To pick these up, have to re-run
%getSRT with lower threshold (for Q, use .000016).

plotBeh = 0;
plotNeurons = 1;
trunc_RT = 1000;

if exist('saccLoc') == 0
    %[SRT saccLoc] = getSRT(EyeX_,EyeY_,0,'Q',.000016);
    [SRT saccLoc] = getSRT(EyeX_,EyeY_);
end


%DO SEPARATELY FOR EACH 'SET' OF TRIALS.  ONE SET IS A SLOW-MED-FAST OR
%SLOW-FAST SEQUENCE.  THIS LOGIC WILL FAIL IF BLOCKS ARE RUN IN REVERSE
%ORDER

%note: last number in 'first_in_set' is actually the final trial + 1. See
%logic below
first_in_set = [1 ; find(diff(SAT_(:,1)) < 0)+1 ; size(SAT_,1)+1];

num_of_sets = length(first_in_set)-1;

for sets = 1:num_of_sets
    curr_set = (first_in_set(sets):first_in_set(sets+1)-1)';
    
    %remove first 100 trials as practice
    %curr_set(1:100) = [];
    
    % All trials w/ made deadlines (not a catch error (1), not a hold error (2),
    % not a latency error (3), not a target hold error (4)
    slow_all_made_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,2) == 1 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & ~isnan(SRT(:,1))))));
    med_all_made_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,2) == 2 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & ~isnan(SRT(:,1))))));
    fast_all_made_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,2) == 3 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & ~isnan(SRT(:,1))))));
    
    %All correct trials w/ made deadlines
    slow_correct_made_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,2) == 1 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & ~isnan(SRT(:,1))))));
    med_correct_made_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,2) == 2 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & ~isnan(SRT(:,1))))));
    fast_correct_made_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SAT_(:,2) == 3 & Errors_(:,1) ~= 1 & Errors_(:,2) ~= 1 & Errors_(:,3) ~= 1 & Errors_(:,4) ~= 1 & ~isnan(SRT(:,1))))));
    
    %all trials w/ missed deadlines and there was a response
    slow_all_missed_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & SAT_(:,2) == 1 & Target_(:,2) ~= 255 & Errors_(:,3) == 1 & ~isnan(SRT(:,1))))));
    med_all_missed_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & SAT_(:,2) == 2 & Target_(:,2) ~= 255 & Errors_(:,3) == 1 & ~isnan(SRT(:,1))))));
    fast_all_missed_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & SAT_(:,2) == 3 & Target_(:,2) ~= 255 & Errors_(:,3) == 1 & ~isnan(SRT(:,1))))));
    
    %all trials w/ missed deadlines including no-response errors
    slow_all_missed_dead_andNoResp = curr_set(find(ismember(curr_set,find(SAT_(:,2) == 1 & Target_(:,2) ~= 255 & Errors_(:,3) == 1))));
    med_all_missed_dead_andNoResp = curr_set(find(ismember(curr_set,find(SAT_(:,2) == 2 & Target_(:,2) ~= 255 & Errors_(:,3) == 1))));
    fast_all_missed_dead_andNoResp = curr_set(find(ismember(curr_set,find(SAT_(:,2) == 3 & Target_(:,2) ~= 255 & Errors_(:,3) == 1))));
    
    
    
    %all correct trials w/ missed deadlines
    %NOTE: THESE ARE ACTUALLY CORRECT SACCADES, BUT TOO LATE.
    %To account for this, make a new 'Correct_' variable and set those trials
    %to 1.
    slow_correct_missed_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & SAT_(:,2) == 1 & (Target_(:,2) == saccLoc & Errors_(:,3) == 1) & ~isnan(SRT(:,1))))));
    med_correct_missed_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & SAT_(:,2) == 2 & (Target_(:,2) == saccLoc & Errors_(:,3) == 1) & ~isnan(SRT(:,1))))));
    fast_correct_missed_dead = curr_set(find(ismember(curr_set,find(SRT(:,1) < trunc_RT & SAT_(:,2) == 3 & (Target_(:,2) == saccLoc & Errors_(:,3) == 1) & ~isnan(SRT(:,1))))));
    
    new_Correct_ = Correct_;
    %set those trials that were to the correct location, but too late, to 1.
    new_Correct_(slow_correct_missed_dead,2) = 1;
    new_Correct_(med_correct_missed_dead,2) = 1;
    new_Correct_(fast_correct_missed_dead,2) = 1;
    
    slow_all_alldead = [slow_all_made_dead ; slow_all_missed_dead];
    med_all_alldead = [med_all_made_dead ; med_all_missed_dead];
    fast_all_alldead = [fast_all_made_dead ; fast_all_missed_dead];
    
    slow_correct_alldead = [slow_correct_made_dead ; slow_correct_missed_dead];
    med_correct_alldead = [med_correct_made_dead ; med_correct_missed_dead];
    fast_correct_alldead = [fast_correct_made_dead ; fast_correct_missed_dead];
    
    
    %including 'no response'
    slow_all_alldead_andNoResp = [slow_all_made_dead ; slow_all_missed_dead_andNoResp];
    med_all_alldead_andNoResp = [med_all_made_dead ; med_all_missed_dead_andNoResp];
    fast_all_alldead_andNoResp = [fast_all_made_dead ; fast_all_missed_dead_andNoResp];
    
    n.correct_made_dead = length(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255));
    n.correct_missed_dead = length(find(Target_(:,2) == saccLoc & Errors_(:,3) == 1 & ~isnan(SRT(:,1))));
    n.errors_made_dead = length(find(Errors_(:,5) == 1 & Target_(:,2) ~= 255));
    n.errors_missed_dead_withResp = length(find(Target_(:,2) ~= 255 & Target_(:,2) ~= saccLoc & Errors_(:,3) == 1 & ~isnan(SRT(:,1))));
    n.errors_missed_dead_noResp = length(find(Target_(:,2) ~= 255 & Errors_(:,3) == 1 & isnan(SRT(:,1))));
    n.catch_withResp = length(find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ~isnan(SRT(:,1))));
    n.catch_noResp = length(find(Correct_(:,2) == 0 & Target_(:,2) == 255 & isnan(SRT(:,1))));
    n.targHoldErr = length(find(Errors_(:,4) == 1));
    n.NaNs = length(find(isnan(Correct_(:,2))));
    
    
    % CDFs for correct trials, made deadlines
    [bins_correct_fast_made_dead cdf_correct_fast_made_dead] = getCDF(SRT(fast_correct_made_dead,1),50);
    [bins_correct_med_made_dead cdf_correct_med_made_dead] = getCDF(SRT(med_correct_made_dead,1),50);
    [bins_correct_slow_made_dead cdf_correct_slow_made_dead] = getCDF(SRT(slow_correct_made_dead,1),50);
    
    % CDFs for correct trials, made + missed deadlines
    [bins_correct_slow_alldead cdf_correct_slow_alldead] = getCDF(SRT(slow_correct_alldead,1),50);
    [bins_correct_med_alldead cdf_correct_med_alldead] = getCDF(SRT(med_correct_alldead,1),50);
    [bins_correct_fast_alldead cdf_correct_fast_alldead] = getCDF(SRT(fast_correct_alldead,1),50);
    
    
    if plotBeh
    figure
    subplot(3,2,1)
    plot(bins_correct_slow_made_dead,cdf_correct_slow_made_dead,'k', ...
        bins_correct_med_made_dead,cdf_correct_med_made_dead,'b', ...
        bins_correct_fast_made_dead,cdf_correct_fast_made_dead,'r')
    %legend('Slow','Medium','Fast','location','northwest')
    xlim([0 1000])
    vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs all made deadlines')
    
    subplot(3,2,2)
    bar(1:3,[mean(Correct_(slow_all_made_dead,2)) ...
        mean(Correct_(med_all_made_dead,2)) ...
        mean(Correct_(fast_all_made_dead,2))])
    ylim([.5 1])
    set(gca,'xticklabel',['slow' ; 'med '; 'fast'])
    title('ACC all made deadlines')
    
    subplot(3,2,3)
    plot(bins_correct_slow_alldead,cdf_correct_slow_alldead,'k', ...
        bins_correct_med_alldead,cdf_correct_med_alldead,'b', ...
        bins_correct_fast_alldead,cdf_correct_fast_alldead,'r')
    xlim([0 1000])
    vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs missed + made deadlines')
    
    subplot(3,2,4)
    bar(1:3,[mean(new_Correct_(slow_all_alldead,2)) mean(new_Correct_(med_all_alldead,2)) ...
        mean(new_Correct_(fast_all_alldead,2))])
    ylim([.5 1])
    set(gca,'xticklabel',['slow';'med ';'fast'])
    title('ACC missed + made deadlines')
    
    subplot(3,2,6)
    bar(1:3,[mean(new_Correct_(slow_all_alldead_andNoResp,2)) ...
        mean(new_Correct_(med_all_alldead_andNoResp,2)) ...
        mean(new_Correct_(fast_all_alldead_andNoResp,2))])
    ylim([.5 1])
    set(gca,'xticklabel',['slow';'med ';'fast'])
    title('ACC missed + made deadlines & No Responses')
    
    [ax h] = suplabel(['BLOCK SET: ' mat2str(sets)],'t');
    set(h,'fontsize',12)
    
    
    %============
    % Histograms
    multiHist_SAT(50,slow_correct_alldead,fast_correct_alldead)
    title('Correct all deadlines')
    
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
                
                %try baseline correcting to deal with drift over experiment
                %SDF = baseline_correct(SDF,[1 100]);
                
                RF = RFs.(neuronList{neuron});
                antiRF = mod((RF+4),8);
                
                inRF = find(ismember(Target_(:,2),RF));
                outRF = find(ismember(Target_(:,2),antiRF));
                
                in.slow_correct_alldead = intersect(inRF,slow_correct_alldead);
                out.slow_correct_alldead = intersect(outRF,slow_correct_alldead);
                
                in.fast_correct_alldead = intersect(inRF,fast_correct_alldead);
                out.fast_correct_alldead = intersect(outRF,fast_correct_alldead);
                
                in.slow_correct_made_dead = intersect(inRF,slow_correct_made_dead);
                out.slow_correct_made_dead = intersect(outRF,slow_correct_made_dead);
                
                in.fast_correct_made_dead = intersect(inRF,fast_correct_made_dead);
                out.fast_correct_made_dead = intersect(outRF,fast_correct_made_dead);
                
                subplot(plotspace(1),plotspace(2),cur_plot)
                
                plot(-100:500,nanmean(SDF(in.slow_correct_alldead,:)),'b', ...
                    -100:500,nanmean(SDF(out.slow_correct_alldead,:)),'--b', ...
                    -100:500,nanmean(SDF(in.fast_correct_alldead,:)),'r', ...
                    -100:500,nanmean(SDF(out.fast_correct_alldead,:)),'--r')
                xlim([-100 500])
                
%                 plot(-100:500,nanmean(SDF(in.slow_correct_made_dead,:)),'b', ...
%                     -100:500,nanmean(SDF(out.slow_correct_made_dead,:)),'--b', ...
%                     -100:500,nanmean(SDF(in.fast_correct_made_dead,:)),'r', ...
%                     -100:500,nanmean(SDF(out.fast_correct_made_dead,:)),'--r')
%                 xlim([-100 500])
                
                
                TDT.slow = getTDT_SP(sig,in.slow_correct_alldead,out.slow_correct_alldead);
                TDT.fast = getTDT_SP(sig,in.fast_correct_alldead,out.fast_correct_alldead);
%                 TDT.slow = getTDT_SP(sig,in.slow_correct_made_dead,out.slow_correct_madedead);
%                 TDT.fast = getTDT_SP(sig,in.fast_correct_made_dead,out.fast_correct_madedead);
                vline(TDT.slow,'b')
                vline(TDT.fast,'r')
                
            end
        end
        
        
        
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
                
                in.slow_correct_alldead = intersect(inMF,slow_correct_alldead);
                out.slow_correct_alldead = intersect(outMF,slow_correct_alldead);
                
                in.fast_correct_alldead = intersect(inMF,fast_correct_alldead);
                out.fast_correct_alldead = intersect(outMF,fast_correct_alldead);
                
                subplot(plotspace(1),plotspace(2),cur_plot)
                
                plot(-400:200,nanmean(SDF_r(in.slow_correct_alldead,:)),'b', ...
                    -400:200,nanmean(SDF_r(out.slow_correct_alldead,:)),'--b', ...
                    -400:200,nanmean(SDF_r(in.fast_correct_alldead,:)),'r', ...
                    -400:200,nanmean(SDF_r(out.fast_correct_alldead,:)),'--r')
                xlim([-400 200])
                
                vline(0,'k')
                
            end
            
        end
    end
    
    clear slow* med* fast* bins* cdf* new_Correct_ curr_set 
    
end

tileFigs

