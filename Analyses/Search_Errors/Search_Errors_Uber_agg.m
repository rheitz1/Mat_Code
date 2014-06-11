
cd /Volumes/Dump/Analyses/Errors/Uber_5runs_.05_catch/Matrices

batch_list = dir('Q*.*');
totalSpikes = 0;
totalLFPs_RF = 0;
totalLFPs_Hemi = 0;
plotFlag = 1;
q = '''';

for sess = 1:length(batch_list)
    batch_list(sess).name
    
    load(batch_list(sess).name)
    
    %============================================================
    % This is POS code to deal with my stupid naming of variables in the
    % unaggregated files.
    %find out what variables are in data set
    vars = fields(TDT);
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
    
    
    OLList = strfind(vars,'OL'); %because the EEGs are already renamed.
    %convert
    for c = 1:length(OLList)
        if isempty(OLList{c})
            OLList{c} = NaN;
        end
    end
    OLList = ~isnan(cell2mat(OLList));
    OLList = find(OLList);
    
    ORList = strfind(vars,'OR'); %because the EEGs are already renamed.
    %convert
    for c = 1:length(ORList)
        if isempty(ORList{c})
            ORList{c} = NaN;
        end
    end
    ORList = ~isnan(cell2mat(ORList));
    ORList = find(ORList);
    
    
    if isempty(OLList)
        OLskip = 1;
    else
        OLskip = 0;
    end
    
    if isempty(ORList);
        ORskip = 1;
    else
        ORskip = 0;
    end
    
    %========================================================
    % For Spikes
    for spikeCount = 1:length(spikeList)
        totalSpikes = totalSpikes + 1;
        %take averages for correct trials because only these were
        %sub-sampled
        wf_all.Spike.correct.in(totalSpikes,1:601) = nanmean(wf.(cell2mat(vars(spikeList(spikeCount)))).correct.in);
        wf_all.Spike.correct.out(totalSpikes,1:601) = nanmean(wf.(cell2mat(vars(spikeList(spikeCount)))).correct.out);
        wf_all.Spike.errors.in(totalSpikes,1:601) = wf.(cell2mat(vars(spikeList(spikeCount)))).errors.in;
        wf_all.Spike.errors.out(totalSpikes,1:601) = wf.(cell2mat(vars(spikeList(spikeCount)))).errors.out;
        
        if ~isempty(TDT.(cell2mat(vars(spikeList(spikeCount)))).correct_nosub)
            TDT_all.Spike.correct_nosub(totalSpikes,1) = TDT.(cell2mat(vars(spikeList(spikeCount)))).correct_nosub;
        else
            TDT_all.Spike.correct_nosub(totalSpikes,1) = NaN;
        end
        
        if ~isempty(TDT.(cell2mat(vars(spikeList(spikeCount)))).correct)
            TDT_all.Spike.correct(totalSpikes,1) = nanmean(TDT.(cell2mat(vars(spikeList(spikeCount)))).correct);
        else
            TDT_all.Spike.correct(totalSpikes,1) = NaN;
        end
        
        
        if ~isempty(TDT.(cell2mat(vars(spikeList(spikeCount)))).errors)
            TDT_all.Spike.errors(totalSpikes,1) = TDT.(cell2mat(vars(spikeList(spikeCount)))).errors;
        else
            TDT_all.Spike.errors(totalSpikes,1) = NaN;
        end
        
        %keep track of RTs
        TDT_all.Spike.RTs.correct(totalSpikes,1) = nanmean(RTs.correct);
        TDT_all.Spike.RTs.errors(totalSpikes,1) = nanmean(RTs.errors);
        
    end
    
    %===================================
    % LFP TDT using neuron RF
    for LFPCount = 1:length(LFPList)
        
        %check to make sure RF condition exists (it may not, if there was a
        %missing RF for the associated neuron...
        
        try
            wf_all.LFP.RF.correct.in(totalLFPs_RF,1:3001) = nanmean(wf.(cell2mat(vars(LFPList(LFPCount)))).RF.correct.in);
            wf_all.LFP.RF.correct.out(totalLFPs_RF,1:3001) = nanmean(wf.(cell2mat(vars(LFPList(LFPCount)))).RF.correct.out);
            wf_all.LFP.RF.errors.in(totalLFPs_RF,1:3001) = wf.(cell2mat(vars(LFPList(LFPCount)))).RF.errors.in;
            wf_all.LFP.RF.errors.out(totalLFPs_RF,1:3001) = wf.(cell2mat(vars(LFPList(LFPCount)))).RF.errors.out;
            
            totalLFPs_RF = totalLFPs_RF + 1;
            
            if ~isempty(TDT.(cell2mat(vars(LFPList(LFPCount)))).RF.correct_nosub)
                TDT_all.LFP.RF.correct_nosub(totalLFPs_RF,1) = TDT.(cell2mat(vars(LFPList(LFPCount)))).RF.correct_nosub;
            else
                TDT_all.LFP.RF.correct_nosub(totalLFPs_RF,1) = NaN;
            end
            
            if ~isempty(TDT.(cell2mat(vars(LFPList(LFPCount)))).RF.correct)
                TDT_all.LFP.RF.correct(totalLFPs_RF,1) = nanmean(TDT.(cell2mat(vars(LFPList(LFPCount)))).RF.correct);
            else
                TDT_all.LFP.RF.correct(totalLFPs_RF,1) = NaN;
            end
            
            if ~isempty(TDT.(cell2mat(vars(LFPList(LFPCount)))).RF.errors)
                TDT_all.LFP.RF.errors(totalLFPs_RF,1) = TDT.(cell2mat(vars(LFPList(LFPCount)))).RF.errors;
            else
                TDT_all.LFP.RF.errors(totalLFPs_RF,1) = NaN;
            end
        catch
            totalLFPs_RF = totalLFPs_RF + 1;
            wf_all.LFP.RF.correct.in(totalLFPs_RF,1:3001) = NaN;
            wf_all.LFP.RF.correct.out(totalLFPs_RF,1:3001) = NaN;
            wf_all.LFP.RF.errors.in(totalLFPs_RF,1:3001) = NaN;
            wf_all.LFP.RF.errors.out(totalLFPs_RF,1:3001) = NaN;
            TDT_all.LFP.RF.correct_nosub(totalLFPs_RF,1) = NaN;
            TDT_all.LFP.RF.correct(totalLFPs_RF,1) = NaN;
            TDT_all.LFP.RF.errors(totalLFPs_RF,1) = NaN;
        end
        TDT_all.LFP.RF.RTs.correct(totalLFPs_RF,1) = nanmean(RTs.correct);
        TDT_all.LFP.RF.RTs.errors(totalLFPs_RF,1) = nanmean(RTs.errors);
    end
    
    
    %=======================================
    % LFP TDT using hemifield RF
    for LFPCount = 1:length(LFPList)
        try
            wf_all.LFP.Hemi.correct.in(totalLFPs_Hemi,1:3001) = nanmean(wf.(cell2mat(vars(LFPList(LFPCount)))).Hemi.correct.in);
            wf_all.LFP.Hemi.correct.out(totalLFPs_Hemi,1:3001) = nanmean(wf.(cell2mat(vars(LFPList(LFPCount)))).Hemi.correct.out);
            wf_all.LFP.Hemi.errors.in(totalLFPs_Hemi,1:3001) = wf.(cell2mat(vars(LFPList(LFPCount)))).Hemi.errors.in;
            wf_all.LFP.Hemi.errors.out(totalLFPs_Hemi,1:3001) = wf.(cell2mat(vars(LFPList(LFPCount)))).Hemi.errors.out;
            
            totalLFPs_Hemi = totalLFPs_Hemi + 1;
            
            
            if ~isempty(TDT.(cell2mat(vars(LFPList(LFPCount)))).Hemi.correct_nosub)
                TDT_all.LFP.Hemi.correct_nosub(totalLFPs_Hemi,1) = TDT.(cell2mat(vars(LFPList(LFPCount)))).Hemi.correct_nosub;
            else
                TDT_all.LFP.Hemi.correct_nosub(totalLFPs_Hemi,1) = NaN;
            end
            
            if ~isempty(TDT.(cell2mat(vars(LFPList(LFPCount)))).Hemi.correct)
                TDT_all.LFP.Hemi.correct(totalLFPs_Hemi,1) = nanmean(TDT.(cell2mat(vars(LFPList(LFPCount)))).Hemi.correct);
            else
                TDT_all.LFP.Hemi.correct(totalLFPs_Hemi,1) = NaN;
            end
            
            if ~isempty(TDT.(cell2mat(vars(LFPList(LFPCount)))).Hemi.errors)
                TDT_all.LFP.Hemi.errors(totalLFPs_Hemi,1) = TDT.(cell2mat(vars(LFPList(LFPCount)))).Hemi.errors;
            else
                TDT_all.LFP.Hemi.errors(totalLFPs_Hemi,1) = NaN;
            end
            
            
        catch
            totalLFPs_Hemi = totalLFPs_Hemi + 1;
            wf_all.LFP.Hemi.correct.in(totalLFPs_Hemi,1:3001) = NaN;
            wf_all.LFP.Hemi.correct.out(totalLFPs_Hemi,1:3001) = NaN;
            wf_all.LFP.Hemi.errors.in(totalLFPs_Hemi,1:3001) = NaN;
            wf_all.LFP.Hemi.errors.out(totalLFPs_Hemi,1:3001) = NaN;
            TDT_all.LFP.Hemi.correct_nosub(totalLFPs_Hemi,1) = NaN;
            TDT_all.LFP.Hemi.correct(totalLFPs_Hemi,1) = NaN;
            TDT_all.LFP.Hemi.errors(totalLFPs_Hemi,1) = NaN;
        end
        TDT_all.LFP.Hemi.RTs.correct(totalLFPs_Hemi,1) = nanmean(RTs.correct);
        TDT_all.LFP.Hemi.RTs.errors(totalLFPs_Hemi,1) = nanmean(RTs.errors);
    end
    
    
    
    %=========================================================
    % For p2pc
    
    if ORskip ~= 1
        wf_all.OR.correct.contra(sess,1:3001) = nanmean(wf.OR.correct.contra);
        wf_all.OR.correct.ipsi(sess,1:3001) = nanmean(wf.OR.correct.ipsi);
        wf_all.OR.errors.contra(sess,1:3001) = wf.OR.errors.contra;
        wf_all.OR.errors.ipsi(sess,1:3001) = wf.OR.errors.ipsi;
        
        TDT_all.OR.correct_nosub(sess,1) = TDT.OR.correct_nosub;
        TDT_all.OR.correct(sess,1) = nanmean(TDT.OR.correct);
        TDT_all.OR.errors(sess,1) = TDT.OR.errors;
    else
        wf_all.OR.correct.contra(sess,1:3001) = NaN;
        wf_all.OR.correct.ipsi(sess,1:3001) = NaN;
        wf_all.OR.errors.contra(sess,1:3001) = NaN;
        wf_all.OR.errors.ipsi(sess,1:3001) = NaN;
        
        TDT_all.OR.correct_nosub(sess,1) = NaN;
        TDT_all.OR.correct(sess,1) = NaN;
        TDT_all.OR.errors(sess,1) = NaN;
        
    end
    
    TDT_all.OL.RTs.correct(sess,1) = nanmean(RTs.correct);
    TDT_all.OL.RTs.errors(sess,1) = nanmean(RTs.errors);
    
    if OLskip ~= 1
        wf_all.OL.correct.contra(sess,1:3001) = nanmean(wf.OL.correct.contra);
        wf_all.OL.correct.ipsi(sess,1:3001) = nanmean(wf.OL.correct.ipsi);
        wf_all.OL.errors.contra(sess,1:3001) = wf.OL.errors.contra;
        wf_all.OL.errors.ipsi(sess,1:3001) = wf.OL.errors.ipsi;
        
        
        TDT_all.OL.correct_nosub(sess,1) = TDT.OL.correct_nosub;
        TDT_all.OL.correct(sess,1) = nanmean(TDT.OL.correct);
        TDT_all.OL.errors(sess,1) = TDT.OL.errors;
        
    else
        wf_all.OL.correct.contra(sess,1:3001) = NaN;
        wf_all.OL.correct.ipsi(sess,1:3001) = NaN;
        wf_all.OL.errors.contra(sess,1:3001) = NaN;
        wf_all.OL.errors.ipsi(sess,1:3001) = NaN;
        
        
        TDT_all.OL.correct_nosub(sess,1) = NaN;
        TDT_all.OL.correct(sess,1) = NaN;
        TDT_all.OL.errors(sess,1) = NaN;
    end
    
    TDT_all.OR.RTs.correct(sess,1) = nanmean(RTs.correct);
    TDT_all.OR.RTs.errors(sess,1) = nanmean(RTs.errors);
    
    
    keep batch_list i wf_all* keeper* totalSpikes totalLFPs_RF totalLFPs_Hemi TDT_all plotFlag sess
end





%==========================
% Plotting
if plotFlag == 1
    figure
    plot(-100:500,nanmean(wf_all.Spike.correct.in),'b',-100:500,nanmean(wf_all.Spike.correct.out),'--b',-100:500,nanmean(wf_all.Spike.errors.in),'r',-100:500,nanmean(wf_all.Spike.errors.out),'--r')
    xlim([-50 300])
    vline(nanmean(TDT_all.Spike.correct_nosub),'--b')
    vline(nanmean(TDT_all.Spike.correct),'b')
    vline(nanmean(TDT_all.Spike.errors),'r')
    fon
    title('Spikes')
    
    figure
    plot(-500:2500,nanmean(wf_all.LFP.Hemi.correct.in),'b',-500:2500,nanmean(wf_all.LFP.Hemi.correct.out),'--b',-500:2500,nanmean(wf_all.LFP.Hemi.errors.in),'r',-500:2500,nanmean(wf_all.LFP.Hemi.errors.out),'--r')
    axis ij
    xlim([-50 300])
    vline(nanmean(nonzeros(TDT_all.LFP.Hemi.correct_nosub)),'--b')
    vline(nanmean(nonzeros(TDT_all.LFP.Hemi.correct)),'b')
    vline(nanmean(nonzeros(TDT_all.LFP.Hemi.errors)),'r')
    fon
    title('LFP Hemi')
    
    figure
    plot(-500:2500,nanmean(wf_all.LFP.RF.correct.in),'b',-500:2500,nanmean(wf_all.LFP.RF.correct.out),'--b',-500:2500,nanmean(wf_all.LFP.RF.errors.in),'r',-500:2500,nanmean(wf_all.LFP.RF.errors.out),'--r')
    axis ij
    xlim([-50 300])
    vline(nanmean(nonzeros(TDT_all.LFP.RF.correct_nosub)),'--b')
    vline(nanmean(nonzeros(TDT_all.LFP.RF.correct)),'b')
    vline(nanmean(nonzeros(TDT_all.LFP.RF.errors)),'r')
    fon
    title('LFP RF')
    
    figure
    plot(-500:2500,nanmean(wf_all.OL.correct.contra),'b',-500:2500,nanmean(wf_all.OL.correct.ipsi),'--b',-500:2500,nanmean(wf_all.OL.errors.contra),'r',-500:2500,nanmean(wf_all.OL.errors.ipsi),'--r')
    axis ij
    xlim([-50 300])
    vline(nanmean(TDT_all.OL.correct_nosub),'--b')
    vline(nanmean(TDT_all.OL.correct),'b')
    vline(nanmean(TDT_all.OL.errors),'r')
    fon
    title('OL')
    
    figure
    plot(-500:2500,nanmean(wf_all.OR.correct.contra),'b',-500:2500,nanmean(wf_all.OR.correct.ipsi),'--b',-500:2500,nanmean(wf_all.OR.errors.contra),'r',-500:2500,nanmean(wf_all.OR.errors.ipsi),'--r')
    axis ij
    xlim([-50 300])
    vline(nanmean(TDT_all.OR.correct_nosub),'--b')
    vline(nanmean(TDT_all.OR.correct),'b')
    vline(nanmean(TDT_all.OR.errors),'r')
    fon
    title('OR')
    
    figure
    [bins.Spike.correct CDF.Spike.correct] = getCDF(TDT_all.Spike.correct(~isnan(TDT_all.Spike.correct)),30);
    [bins.Spike.errors CDF.Spike.errors] = getCDF(TDT_all.Spike.errors(~isnan(TDT_all.Spike.errors)),30);
    
    [bins.LFP.RF.correct CDF.LFP.RF.correct] = getCDF(nonzeros(TDT_all.LFP.RF.correct(~isnan(TDT_all.LFP.RF.correct))),30);
    [bins.LFP.RF.errors CDF.LFP.RF. errors] = getCDF(nonzeros(TDT_all.LFP.RF.errors(~isnan(TDT_all.LFP.RF.errors))),30);
    
    [bins.LFP.Hemi.correct CDF.LFP.Hemi.correct] = getCDF(nonzeros(TDT_all.LFP.Hemi.correct(~isnan(TDT_all.LFP.Hemi.correct))),30);
    [bins.LFP.Hemi.errors CDF.LFP.Hemi. errors] = getCDF(nonzeros(TDT_all.LFP.Hemi.errors(~isnan(TDT_all.LFP.Hemi.errors))),30);
    
    [bins.OL.correct CDF.OL.correct] = getCDF(TDT_all.OL.correct(~isnan(TDT_all.OL.correct)),30);
    [bins.OL.errors CDF.OL.errors] = getCDF(TDT_all.OL.errors(~isnan(TDT_all.OL.errors)),30);

    [bins.OR.correct CDF.OR.correct] = getCDF(TDT_all.OR.correct(~isnan(TDT_all.OR.correct)),30);
    [bins.OR.errors CDF.OR.errors] = getCDF(TDT_all.OR.errors(~isnan(TDT_all.OR.errors)),30);

    plot(bins.Spike.correct,CDF.Spike.correct,'b',bins.Spike.errors,CDF.Spike.errors,'--b', ...
        bins.LFP.Hemi.correct,CDF.LFP.Hemi.correct,'r',bins.LFP.Hemi.errors,CDF.LFP.Hemi.errors,'--r', ...
        bins.OL.correct,CDF.OL.correct,'g',bins.OL.errors,CDF.OL.errors,'--g', ...
        bins.OR.correct,CDF.OR.correct,'k',bins.OR.errors,CDF.OR.errors,'--k')
end