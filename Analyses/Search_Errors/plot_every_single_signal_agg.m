%aggregation for 'plot_all_error_and_correct_signals

cd /volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_NotTruncated/Matrices/

batch_list = dir('Q*.*');
totalSpikes = 0;
totalLFPs = 0;
plotFlag = 0;

for sess = 1:length(batch_list)
    batch_list(sess).name
    
    load(batch_list(sess).name)
    
    %============================================================
    % This is POS code to deal with my stupid naming of variables in the
    % unaggregated files.
    %find out what variables are in data set
    vars = fields(wf);
    spikeList = strfind(vars,'DSP');
    %convert spikeList
    for c = 1:length(spikeList)
        if isempty(spikeList{c})
            spikeList{c} = NaN;
        end
    end
    spikeList = ~isnan(cell2mat(spikeList));
    spikeList = find(spikeList);
    
    
    LFPList = strfind(vars,'AD'); %because the EEGs are already renamed.
    %convert
    for c = 1:length(LFPList)
        if isempty(LFPList{c})
            LFPList{c} = NaN;
        end
    end
    LFPList = ~isnan(cell2mat(LFPList));
    LFPList = find(LFPList);
    
    
    %
    %
    %     %now find correct values
    %     correctList = strfind(vars,'_correct');
    %
    %     %convert correctList
    %     for c = 1:length(correctList)
    %         if isempty(correctList{c})
    %             correctList{c} = NaN;
    %         end
    %     end
    %     correctList = ~isnan(cell2mat(correctList));
    %     correctList = find(correctList);
    %
    %
    %
    %     %now find error values
    %     errorList = strfind(vars,'_errors');
    %
    %     %convert correctList
    %     for c = 1:length(errorList)
    %         if isempty(errorList{c})
    %             errorList{c} = NaN;
    %         end
    %     end
    %     errorList = ~isnan(cell2mat(errorList));
    %     errorList = find(errorList);
    %
    %
    %     SpikeCorrectList = intersect(spikeList,correctList);
    %     LFPCorrectList = intersect(LFPList,correctList);
    %============================================================
    
    
    %========================================================
    % For Spikes
    for spikeCount = 1:length(spikeList)
        totalSpikes = totalSpikes + 1;
        wf_all.Spike_correct.in(totalSpikes,1:601) = wf.(cell2mat(vars(spikeList(spikeCount)))).correct.in;
        wf_all.Spike_correct.out(totalSpikes,1:601) = wf.(cell2mat(vars(spikeList(spikeCount)))).correct.out;
        wf_all.Spike_errors.in(totalSpikes,1:601) = wf.(cell2mat(vars(spikeList(spikeCount)))).errors.in;
        wf_all.Spike_errors.out(totalSpikes,1:601) = wf.(cell2mat(vars(spikeList(spikeCount)))).errors.out;
        
        if ~isempty(TDT.(cell2mat(vars(spikeList(spikeCount)))).correct)
            TDT_all.Spike.correct(totalSpikes,1) = TDT.(cell2mat(vars(spikeList(spikeCount)))).correct;
        else
            TDT_all.Spike.correct(totalSpikes,1) = NaN;
        end
        
        if ~isempty(TDT.(cell2mat(vars(spikeList(spikeCount)))).errors)
            TDT_all.Spike.errors(totalSpikes,1) = TDT.(cell2mat(vars(spikeList(spikeCount)))).errors;
        else
            TDT_all.Spike.errors(totalSpikes,1) = NaN;
        end
        
        if plotFlag == 1
            f = figure;
            plot(-100:500,wf_all.Spike_correct.in(totalSpikes,:),'b',-100:500,wf_all.Spike_correct.out(totalSpikes,:),'--b',-100:500,wf_all.Spike_errors.in(totalSpikes,:),'r',-100:500,wf_all.Spike_errors.out(totalSpikes,:),'--r')
            xlim([-50 200])
            fon
            title('Spike')
            
            keeper_SP(totalSpikes,1) = input('Keep? ');
            close(f)
        end
    end
    
    
    for LFPCount = 1:length(LFPList)
        totalLFPs = totalLFPs + 1;
        wf_all.LFP_correct.in(totalLFPs,1:3001) = wf.(cell2mat(vars(LFPList(LFPCount)))).correct.in;
        wf_all.LFP_correct.out(totalLFPs,1:3001) = wf.(cell2mat(vars(LFPList(LFPCount)))).correct.out;
        wf_all.LFP_errors.in(totalLFPs,1:3001) = wf.(cell2mat(vars(LFPList(LFPCount)))).errors.in;
        wf_all.LFP_errors.out(totalLFPs,1:3001) = wf.(cell2mat(vars(LFPList(LFPCount)))).errors.out;
        
        if ~isempty(TDT.(cell2mat(vars(LFPList(LFPCount)))).correct)
            TDT_all.LFP.correct(totalLFPs,1) = TDT.(cell2mat(vars(LFPList(LFPCount)))).correct;
        else
            TDT_all.LFP.correct(totalLFPs,1) = NaN;
        end
        
        if ~isempty(TDT.(cell2mat(vars(LFPList(LFPCount)))).errors)
            TDT_all.LFP.errors(totalLFPs,1) = TDT.(cell2mat(vars(LFPList(LFPCount)))).errors;
        else
            TDT_all.LFP.errors(totalLFPs,1) = NaN;
        end
        if plotFlag == 1
            f = figure;
            plot(-500:2500,wf_all.LFP_correct.in(totalLFPs,:),'b',-500:2500,wf_all.LFP_correct.out(totalLFPs,:),'--b',-500:2500,wf_all.LFP_errors.in(totalLFPs,:),'r',-500:2500,wf_all.LFP_errors.out(totalLFPs,:),'--r')
            xlim([-50 200])
            fon
            title('LFP')
            
            keeper_LFP(totalLFPs,1) = input('Keep? ');
            close(f)
        end
    end
    
    
    
    
    
    
    %=========================================================
    % For p2pc
    wf_all.OL_correct.contra(sess,1:3001) = wf.OL_correct.contra;
    wf_all.OL_correct.ipsi(sess,1:3001) = wf.OL_correct.ipsi;
    wf_all.OR_correct.contra(sess,1:3001) = wf.OR_correct.contra;
    wf_all.OR_correct.ipsi(sess,1:3001) = wf.OR_correct.ipsi;
    
    wf_all.OL_errors.contra(sess,1:3001) = wf.OL_errors.contra;
    wf_all.OL_errors.ipsi(sess,1:3001) = wf.OL_errors.ipsi;
    wf_all.OR_errors.contra(sess,1:3001) = wf.OR_errors.contra;
    wf_all.OR_errors.ipsi(sess,1:3001) = wf.OR_errors.ipsi;
    
    TDT_all.OL_correct(sess,1) = TDT.OL_correct;
    TDT_all.OL_errors(sess,1) = TDT.OL_errors;
    TDT_all.OR_correct(sess,1) = TDT.OR_correct;
    TDT_all.OR_errors(sess,1) = TDT.OR_errors;
    
    if plotFlag == 1
        f = figure;
        plot(-500:2500,wf.OL_correct.contra,'b',-500:2500,wf.OL_correct.ipsi,'--b',-500:2500,wf.OL_errors.contra,'r',-500:2500,wf.OL_errors.ipsi,'--r')
        xlim([-50 200])
        axis ij
        fon
        title('OL')
        
        keeper_OL(sess,1) = input('Keep? ');
        close(f)
        
        f = figure;
        plot(-500:2500,wf.OR_correct.contra,'b',-500:2500,wf.OR_correct.ipsi,'--b',-500:2500,wf.OR_errors.contra,'r',-500:2500,wf.OR_errors.ipsi,'--r')
        xlim([-50 200])
        axis ij
        fon
        title('OR')
        
        keeper_OR(sess,1) = input('Keep? ');
        
        close(f)
    end
    
    keep batch_list i wf_all* keeper* totalSpikes totalLFPs TDT_all plotFlag
end

for sess = 1:size(keeper_OR,1)
    if keeper_OL(sess) == 0
        wf_all.OL_correct.contra(sess,:) = NaN;
        wf_all.OL_correct.ipsi(sess,:) = NaN;
        wf_all.OL_errors.contra(sess,:) = NaN;
        wf_all.OL_errors.ipsi(sess,:) = NaN;
    end
    
    if keeper_OR(sess) == 0
        wf_all.OR_correct.contra(sess,:) = NaN;
        wf_all.OR_correct.ipsi(sess,:) = NaN;
        wf_all.OR_errors.contra(sess,:) = NaN;
        wf_all.OR_errors.ipsi(sess,:) = NaN;
    end
end

for sess = 1:size(keeper_SP,1)
    if keeper_SP(sess) == 0
        wf_all.Spike_correct.in(sess,:) = NaN;
        wf_all.Spike_correct.out(sess,:) = NaN;
        wf_all.Spike_errors.in(sess,:) = NaN;
        wf_all.Spike_errors.out(sess,:) = NaN;
    end
end

for sess = 1:size(keeper_LFP,1)
    if keeper_LFP(sess) == 0
        wf_all.LFP_correct.in(sess,:) = NaN;
        wf_all.LFP_correct.out(sess,:) = NaN;
        wf_all.LFP_errors.in(sess,:) = NaN;
        wf_all.LFP_errors.out(sess,:) = NaN;
    end
end

