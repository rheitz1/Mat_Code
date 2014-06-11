

flist = textread('catch_trials.txt','%s');

totalSpikes = 0;
totalLFP = 0;
totalOR = 0;
totalOL = 0;
q = '''';
c = ',';
qcq = [q c q];

for sess = 1:length(flist)
    
    %load(flist{sess});
    %catch trials
    %varlist = who;
    
    try
        ChanStruct = loadChan(flist{sess},'DSP');
        DSPlist = fieldnames(ChanStruct);
        decodeChanStruct
    catch
        DSPlist = [];
        disp('ERROR IN DSP CHANNELS....SKIPPING')
    end
    
    
    try
        ChanStruct = loadChan(flist{sess},'LFP');
        LFPlist = fieldnames(ChanStruct);
        decodeChanStruct
    catch
        LFPlist = [];
        disp('ERROR IN LFP CHANNELS ....SKIPPING')
    end
    
    %manually add AD02 and AD03
    try
        load(flist{sess},'AD02')
        disp('loading AD02')
        chanlist3{1,1} = 'AD02';
    catch
        disp('Missing AD02')
    end
    
    try
        load(flist{sess},'AD03')
        chanlist3{2,1} = 'AD03';
        disp('loading AD03')
    catch
        disp('Missing AD03')
    end
    
    EEGlist = chanlist3;
    
    %load Target_ & Correct_ variable
    load(flist{sess},'EyeX_','EyeY_','SaccDir_','Hemi','RFs','newfile','Errors_','SRT','Target_','Correct_','TrialStart_','saccLoc');
    
    fixErrors
    
    
    
    %full chanlist
    %allchanlist = [DSPlist;LFPlist;EEGlist];
    
    for DSPchan = 1:length(DSPlist)
        RF = RFs.(cell2mat(DSPlist(DSPchan)));
        
        if isempty(RF)
            disp('Empty RF...')
            continue
        end
        
        antiRF = mod((RF+4),8);
        
        Spike = eval(cell2mat(DSPlist(DSPchan)));
        
        SDF = sSDF(Spike,Target_(:,1),[-100 500]);
        
        
        in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        in_incorrect = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF));
        out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF));
        
        catch_correct_with_sacc_in = find(Target_(:,2) == 255 & Correct_(:,2) == 1 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
        catch_errors_with_sacc_in = find(Target_(:,2) == 255 & Errors_(:,5) == 1 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
        catch_without_sacc = find(Target_(:,2) == 255 & Correct_(:,2) == 1 & isnan(SRT(:,1)));
        
        totalSpikes = totalSpikes + 1;
        wf.Spike.correct_in(totalSpikes,1:601) = nanmean(SDF(in_correct,:));
        wf.Spike.correct_out(totalSpikes,1:601) = nanmean(SDF(out_correct,:));
        wf.Spike.errors_in(totalSpikes,1:601) = nanmean(SDF(in_incorrect,:));
        wf.Spike.errors_out(totalSpikes,1:601) = nanmean(SDF(out_incorrect,:));
        wf.Spike.catch_correct_with_sacc_in(totalSpikes,1:601) = nanmean(SDF(catch_correct_with_sacc_in,:));
        wf.Spike.catch_errors_with_sacc_in(totalSpikes,1:601) = nanmean(SDF(catch_errors_with_sacc_in,:));
        wf.Spike.catch_without_sacc(totalSpikes,1:601) = nanmean(SDF(catch_without_sacc,:));
        
        f = figure;
        plot(-100:500,nanmean(SDF(in_correct,:)),'k',-100:500,nanmean(SDF(out_correct,:)),'--k',-100:500,nanmean(SDF(catch_correct_with_sacc_in,:)),'b',-100:500,nanmean(SDF(catch_errors_with_sacc_in,:)),'r',-100:500,nanmean(SDF(catch_without_sacc,:)),'g')
        fon
        legend('Correct In','Correct Out','Slow Cat Err','Fast Cat Err','Cat Corr')
        title('Correct + catch')
        
        %     figure
        %     plot(-100:500,nanmean(SDF(in_incorrect,:)),'k',-100:500,nanmean(SDF(out_incorrect,:)),'--k',-100:500,nanmean(SDF(catch_correct_with_sacc_in,:)),'b',-100:500,nanmean(SDF(catch_errors_with_sacc_in,:)),'r')
        %     fon
        %     title('Errors + catch')
        eval(['print -dpdf /volumes/Dump/Analyses/Errors/Catch_Trials/PDF/' flist{sess} '_' cell2mat(DSPlist(DSPchan)) '_SPK.pdf'])
        close(f)
    end
    
    %==============================================
    
    for LFPchan = 1:length(LFPlist)
        if Hemi.(cell2mat(LFPlist(LFPchan))) == 'R'
            RF = [3 4 5];
        elseif Hemi.(cell2mat(LFPlist(LFPchan))) == 'L'
            RF = [7 0 1];
        end
        
        antiRF = mod((RF+4),8);
        
        
        LFP = eval(cell2mat(LFPlist(LFPchan)));
        LFP = fixClipped(LFP);
        LFP = baseline_correct(LFP,[400 500]);
        RF = [3 4 5];
        antiRF = mod((RF+4),8);
        
        in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        in_incorrect = find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF));
        out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF));
        
        catch_correct_with_sacc_in = find(Target_(:,2) == 255 & Correct_(:,2) == 1 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
        catch_errors_with_sacc_in = find(Target_(:,2) == 255 & Errors_(:,5) == 1 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
        catch_without_sacc = find(Target_(:,2) == 255 & Correct_(:,2) == 1 & isnan(SRT(:,1)));
        
        totalLFP = totalLFP + 1;
        wf.LFP.correct_in(totalLFP,1:3001) = nanmean(LFP(in_correct,:));
        wf.LFP.correct_out(totalLFP,1:3001) = nanmean(LFP(out_correct,:));
        wf.LFP.errors_in(totalLFP,1:3001) = nanmean(LFP(in_incorrect,:));
        wf.LFP.errors_out(totalLFP,1:3001) = nanmean(LFP(out_incorrect,:));
        wf.LFP.catch_correct_with_sacc_in(totalLFP,1:3001) = nanmean(LFP(catch_correct_with_sacc_in,:));
        wf.LFP.catch_errors_with_sacc_in(totalLFP,1:3001) = nanmean(LFP(catch_errors_with_sacc_in,:));
        wf.LFP.catch_without_sacc(totalLFP,1:3001) = nanmean(LFP(catch_without_sacc,:));
        
        
        f = figure;
        plot(-500:2500,nanmean(LFP(in_correct,:)),'k',-500:2500,nanmean(LFP(out_correct,:)),'--k',-500:2500,nanmean(LFP(catch_correct_with_sacc_in,:)),'b',-500:2500,nanmean(LFP(catch_errors_with_sacc_in,:)),'r',-500:2500,nanmean(LFP(catch_without_sacc,:)),'g')
        fon
        axis ij
        xlim([-50 400])
        title('Correct + catch')
        eval(['print -dpdf /volumes/Dump/Analyses/Errors/Catch_Trials/PDF/' flist{sess} '_' cell2mat(LFPlist(LFPchan)) '_LFP.pdf'])
        
        close(f)
        %     figure
        %     plot(-500:2500,nanmean(LFP(in_incorrect,:)),'k',-500:2500,nanmean(LFP(out_incorrect,:)),'--k',-500:2500,nanmean(LFP(catch_correct_with_sacc_in,:)),'b',-500:2500,nanmean(LFP(catch_errors_with_sacc_in,:)),'r')
        %     fon
        %     axis ij
        %     xlim([-50 400])
        %     title('Errors + catch')
        %
        
    end
    
    
    
    %==============================================
    OR = AD02;
    
    OR = fixClipped(OR);
    OR = baseline_correct(OR,[400 500]);
    RF = [3 4 5];
    antiRF = mod((RF+4),8);
    
    contra_corr = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsi_corr = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    catch_correct_with_sacc_contra = find(Target_(:,2) == 255 & Correct_(:,2) == 1 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
    catch_errors_with_sacc_contra = find(Target_(:,2) == 255 & Errors_(:,5) == 1 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
    catch_without_sacc = find(Target_(:,2) == 255 & Correct_(:,2) == 1 & isnan(SRT(:,1)));
    
    
    totalOR = totalOR + 1;
    wf.OR.correct_in(totalOR,1:3001) = nanmean(OR(contra_corr,:));
    wf.OR.correct_out(totalOR,1:3001) = nanmean(OR(ipsi_corr,:));
    %         wf.OR.errors_in(totalOR,1:3001) = nanmean(OR(in_incorrect,:));
    %         wf.OR.errors_out(totalOR,1:3001) = nanmean(OR(out_incorrect,:));
    wf.OR.catch_correct_with_sacc_in(totalOR,1:3001) = nanmean(OR(catch_correct_with_sacc_contra,:));
    wf.OR.catch_errors_with_sacc_in(totalOR,1:3001) = nanmean(OR(catch_errors_with_sacc_contra,:));
    wf.OR.catch_without_sacc(totalOR,1:3001) = nanmean(OR(catch_without_sacc,:));
    
    
    
    
    f = figure;
    plot(-500:2500,nanmean(OR(contra_corr,:)),'k',-500:2500,nanmean(OR(ipsi_corr,:)),'--k',-500:2500,nanmean(OR(catch_correct_with_sacc_contra,:)),'b',-500:2500,nanmean(OR(catch_errors_with_sacc_contra,:)),'r',-500:2500,nanmean(OR(catch_without_sacc,:)),'g')
    xlim([-50 400])
    legend('Correct In','Correct Out','Slow Cat Err','Fast Cat Err','Cat Corr')
    axis ij
    
    eval(['print -dpdf /volumes/Dump/Analyses/Errors/Catch_Trials/PDF/' flist{sess} '_OR.pdf'])
    
    close(f)
    
    %==============================================
    OL = AD03;
    OL = fixClipped(OL);
    OL = baseline_correct(OL,[400 500]);
    RF = [7 0 1];
    antiRF = mod((RF+4),8);
    
    contra_corr = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsi_corr = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    catch_correct_with_sacc_contra = find(Target_(:,2) == 255 & Correct_(:,2) == 1 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
    catch_errors_with_sacc_contra = find(Target_(:,2) == 255 & Errors_(:,5) == 1 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
    catch_without_sacc = find(Target_(:,2) == 255 & Correct_(:,2) == 1 & isnan(SRT(:,1)));
    
    totalOL = totalOL + 1;
    wf.OL.correct_in(totalOL,1:3001) = nanmean(OL(contra_corr,:));
    wf.OL.correct_out(totalOL,1:3001) = nanmean(OL(ipsi_corr,:));
    %         wf.OL.errors_in(totalOL,1:3001) = nanmean(OL(in_incorrect,:));
    %         wf.OL.errors_out(totalOL,1:3001) = nanmean(OL(out_incorrect,:));
    wf.OL.catch_correct_with_sacc_in(totalOL,1:3001) = nanmean(OL(catch_correct_with_sacc_contra,:));
    wf.OL.catch_errors_with_sacc_in(totalOL,1:3001) = nanmean(OL(catch_errors_with_sacc_contra,:));
    wf.OL.catch_without_sacc(totalOL,1:3001) = nanmean(OL(catch_without_sacc,:));
    
    
    
    f = figure;
    plot(-500:2500,nanmean(OL(contra_corr,:)),'k',-500:2500,nanmean(OL(ipsi_corr,:)),'--k',-500:2500,nanmean(OL(catch_correct_with_sacc_contra,:)),'b',-500:2500,nanmean(OL(catch_errors_with_sacc_contra,:)),'r',-500:2500,nanmean(OL(catch_without_sacc,:)),'g')
    xlim([-50 400])
    legend('Correct In','Correct Out','Slow Cat Err','Fast Cat Err','Cat Corr')
    axis ij
    
    eval(['print -dpdf /volumes/Dump/Analyses/Errors/Catch_Trials/PDF/' flist{sess} '_OL.pdf'])
    close(f)
    
    %save variables
    eval(['save(' q '/volumes/Dump/Analyses/Errors/Catch_Trials/Matrices/',flist{sess} qcq 'wf' qcq '-mat' q ')'])
    
    %clean up
    keep flist sess wf q c qcq total*
end