% Calculates TDT & ROC curves for uStim experiment
% RPH

[file_name] = textread('stimRight.txt', '%s');

q = '''';

plotFlag = 1;
saveFlag = 1;

totalLFP = 0;
totalDSP = 0;
totalEEG = 0;

for sess = 1:length(file_name)
    cell2mat(file_name(sess))
    
    load(cell2mat(file_name(sess)), ...
        'AD02','AD03','newfile','MStim_','Target_','Errors_','Correct_','RFs','Hemi','SRT','TrialStart_')
    
    loadChan(file_name{sess},'LFP');
%     
%     if ~isempty(ChanStruct)
%         LFPlist = fieldnames(ChanStruct);
%         decodeChanStruct
%         clear ChanStruct
%     else
%         LFPlist = [];
%     end
    
    loadChan(file_name{sess},'DSP');
    
    varlist = who;
    DSPlist = varlist(strmatch('DSP',varlist));
    LFPlist = varlist(strmatch('AD',varlist));
%     decodeChanStruct
%     clear ChanStruct
    clear varlist
    
    %================================
    % LFPs
    for currLFP = 1:length(LFPlist)
        
        LFP = eval(LFPlist{currLFP});
        LFP_bc = baseline_correct(LFP,[400 500]);
        
        %keep track of all signals used
        totalLFP = totalLFP + 1;
        
        %Stimulating in the Right so all LFPs are in the left hemisphere
        RF = [7 0 1];
        antiRF = [3 4 5];
        
        in.stim = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out.stim = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        
        in.nostim = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out.nostim = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        
        RT.LFP.in.stim(totalLFP,1) = nanmean(SRT(in.stim,1));
        RT.LFP.out.stim(totalLFP,1) = nanmean(SRT(out.stim,1));
        RT.LFP.in.nostim(totalLFP,1) = nanmean(SRT(in.nostim,1));
        RT.LFP.out.nostim(totalLFP,1) = nanmean(SRT(out.nostim,1));
        
        TDT.LFP.stim_bc(totalLFP,1) = getTDT_AD(LFP_bc,in.stim,out.stim);
        TDT.LFP.nostim_bc(totalLFP,1) = getTDT_AD(LFP_bc,in.nostim,out.nostim);
        
        TDT.LFP.stim(totalLFP,1) = getTDT_AD(LFP,in.stim,out.stim);
        TDT.LFP.nostim(totalLFP,1) = getTDT_AD(LFP,in.nostim,out.nostim);
        
        %NOTE: have to enter trials backwards for LFPs if you want
        %selectivity to go positive because LFPs express selectivity as a
        %relative negativity.
        
        ROC.LFP.stim_bc(totalLFP,1:601) = getROC(LFP_bc(:,400:1000),out.stim,in.stim,30);
        ROC.LFP.nostim_bc(totalLFP,1:601) = getROC(LFP_bc(:,400:1000),out.nostim,in.nostim,30);
        
        ROC.LFP.stim(totalLFP,1:601) = getROC(LFP(:,400:1000),out.stim,in.stim,30);
        ROC.LFP.nostim(totalLFP,1:601) = getROC(LFP(:,400:1000),out.nostim,in.nostim,30);
        
        wf.LFP.in.stim_bc(totalLFP,1:3001) = nanmean(LFP_bc(in.stim,:));
        wf.LFP.in.nostim_bc(totalLFP,1:3001) = nanmean(LFP_bc(in.nostim,:));
        
        wf.LFP.in.stim(totalLFP,1:3001) = nanmean(LFP(in.stim,:));
        wf.LFP.in.nostim(totalLFP,1:3001) = nanmean(LFP(in.nostim,:));
        
        wf.LFP.out.stim_bc(totalLFP,1:3001) = nanmean(LFP_bc(out.stim,:));
        wf.LFP.out.nostim_bc(totalLFP,1:3001) = nanmean(LFP_bc(out.nostim,:));
        
        wf.LFP.out.stim(totalLFP,1:3001) = nanmean(LFP(out.stim,:));
        wf.LFP.out.nostim(totalLFP,1:3001) = nanmean(LFP(out.nostim,:));
        
        clear LFP RF antiRF
        
        if plotFlag == 1
            f = figure;
            
            subplot(1,2,1)
            plot(-500:2500,wf.LFP.in.stim(totalLFP,1:3001),'r',-500:2500,wf.LFP.out.stim(totalLFP,1:3001),'--r', ...
                -500:2500,wf.LFP.in.nostim(totalLFP,1:3001),'b',-500:2500,wf.LFP.out.nostim(totalLFP,1:3001),'--b')
            axis ij
            xlim([-100 500])
            
            vline(TDT.LFP.stim(totalLFP,1),'r')
            vline(TDT.LFP.nostim(totalLFP,1),'b')
            vline(TDT.LFP.stim_bc(totalLFP,1),'--r')
            vline(TDT.LFP.nostim_bc(totalLFP,1),'--b')
            
            subplot(1,2,2)
            plot(-100:500,ROC.LFP.stim(totalLFP,1:601),'r',-100:500,ROC.LFP.nostim(totalLFP,1:601),'b')
            xlim([-100 500])
            
            
            
            eval(['print -dpdf ',q,'/volumes/Dump/Analyses/uStim/TDT_uStim/StimRight/PDF/',file_name{sess},'_',LFPlist{currLFP},'.pdf',q])
            close(f)
        end
    end
    %=======================================
    
    
    
    %=======================================
    % SPIKES
    for currDSP = 1:length(DSPlist)
        
        
        DSP = eval(DSPlist{currDSP});
        
        RF = RFs.(DSPlist{currDSP});
        
        if isempty(RF)
            disp('Empty RF')
            continue
        else
            totalDSP = totalDSP + 1;
        end
        
        antiRF = mod((RF+4),8);
        
        
        in.stim = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out.stim = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        
        in.nostim = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out.nostim = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        
        RT.DSP.in.stim(totalLFP,1) = nanmean(SRT(in.stim,1));
        RT.DSP.out.stim(totalLFP,1) = nanmean(SRT(out.stim,1));
        RT.DSP.in.nostim(totalLFP,1) = nanmean(SRT(in.nostim,1));
        RT.DSP.out.nostim(totalLFP,1) = nanmean(SRT(out.nostim,1));
        
        TDT.DSP.stim(totalDSP,1) = getTDT_SP(DSP,in.stim,out.stim);
        TDT.DSP.nostim(totalDSP,1) = getTDT_SP(DSP,in.nostim,out.nostim);
        
        SDF = sSDF(DSP,Target_(:,1),[-100 500]);
        
        ROC.DSP.stim(totalDSP,1:601) = getROC(SDF,in.stim,out.stim,30);
        ROC.DSP.nostim(totalDSP,1:601) = getROC(SDF,in.nostim,out.nostim,30);
        
        wf.DSP.in.stim(totalDSP,1:601) = spikedensityfunct(DSP,Target_(:,1),[-100 500],in.stim,TrialStart_);
        wf.DSP.in.nostim(totalDSP,1:601) = spikedensityfunct(DSP,Target_(:,1),[-100 500],in.nostim,TrialStart_);
        
        wf.DSP.out.stim(totalDSP,1:601) = spikedensityfunct(DSP,Target_(:,1),[-100 500],out.stim,TrialStart_);
        wf.DSP.out.nostim(totalDSP,1:601) = spikedensityfunct(DSP,Target_(:,1),[-100 500],out.nostim,TrialStart_);
        
        clear DSP RF antiRF in out
        
        
        if plotFlag == 1
            f = figure;
            
            subplot(1,2,1)
            plot(-100:500,wf.DSP.in.stim(totalDSP,1:601),'r',-100:500,wf.DSP.out.stim(totalDSP,1:601),'--r', ...
                -100:500,wf.DSP.in.nostim(totalDSP,1:601),'b',-100:500,wf.DSP.out.nostim(totalDSP,1:601),'--b')
            
            xlim([-100 500])
            vline(TDT.DSP.stim(totalDSP,1),'r')
            vline(TDT.DSP.nostim(totalDSP,1),'b')
            
            
            subplot(1,2,2)
            plot(-100:500,ROC.DSP.stim(totalDSP,1:601),'r',-100:500,ROC.DSP.nostim(totalDSP,1:601),'b')
            xlim([-100 500])
            
            eval(['print -dpdf ',q,'/volumes/Dump/Analyses/uStim/TDT_uStim/StimRight/PDF/',file_name{sess},LFPlist{currLFP},'spikes.pdf',q])
            close(f)
        end
        
    end
    %=======================================
    
    
    %=======================================
    % EEG
    totalEEG = totalEEG + 1;
    OL = AD03;
    OR = AD02;
    
    OL = baseline_correct(OL,[400 500]);
    OR = baseline_correct(OR,[400 500]);
    
    %     OL = truncateAD_targ(OL,SRT,20);
    %     OR = truncateAD_targ(OR,SRT,20);
    
    
    
    %=== OL ====%
    RF = [7 0 1];
    antiRF = [3 4 5];
    
    in.stim = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.stim = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.nostim = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.nostim = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    RT.OL.in.stim(totalEEG,1) = nanmean(SRT(in.stim,1));
    RT.OL.out.stim(totalEEG,1) = nanmean(SRT(out.stim,1));
    RT.OL.in.nostim(totalEEG,1) = nanmean(SRT(in.nostim,1));
    RT.OL.out.nostim(totalEEG,1) = nanmean(SRT(out.nostim,1));
    
    
    TDT.OL.stim(totalEEG,1) = getTDT_AD(OL,in.stim,out.stim);
    TDT.OL.nostim(totalEEG,1) = getTDT_AD(OL,in.nostim,out.nostim);
    
    ROC.OL.stim(totalEEG,1:601) = getROC(OL(:,400:1000),in.stim,out.stim,30);
    ROC.OL.nostim(totalEEG,1:601) = getROC(OL(:,400:1000),in.nostim,out.nostim,30);
    
    wf.OL.in.stim(totalEEG,1:3001) = nanmean(OL(in.stim,:));
    wf.OL.in.nostim(totalEEG,1:3001) = nanmean(OL(in.nostim,:));
    
    wf.OL.out.stim(totalEEG,1:3001) = nanmean(OL(out.stim,:));
    wf.OL.out.nostim(totalEEG,1:3001) = nanmean(OL(out.nostim,:));
    
    clear LFP RF antiRF
    
    if plotFlag == 1
        f = figure;
        
        subplot(1,2,1)
        plot(-500:2500,wf.OL.in.stim(totalEEG,1:3001),'r',-500:2500,wf.OL.out.stim(totalEEG,1:3001),'--r', ...
            -500:2500,wf.OL.in.nostim(totalEEG,1:3001),'b',-500:2500,wf.OL.out.nostim(totalEEG,1:3001),'--b')
        axis ij
        xlim([-100 500])
        
        vline(TDT.OL.stim(totalEEG,1),'r')
        vline(TDT.OL.nostim(totalEEG,1),'b')
        
        subplot(1,2,2)
        plot(-100:500,ROC.OL.stim(totalEEG,1:601),'r',-100:500,ROC.OL.nostim(totalEEG,1:601),'b')
        xlim([-100 500])
        
        
        
        eval(['print -dpdf ',q,'/volumes/Dump/Analyses/uStim/TDT_uStim/StimRight/PDF/',file_name{sess},'_','OL.pdf',q])
        close(f)
    end
    
    
    
    
    %=== OR ====%
    RF = [3 4 5];
    antiRF = [7 0 1];
    
    in.stim = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.stim = find(Correct_(:,2) == 1 & ~isnan(MStim_(:,1)) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.nostim = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.nostim = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    RT.OR.in.stim(totalEEG,1) = nanmean(SRT(in.stim,1));
    RT.OR.out.stim(totalEEG,1) = nanmean(SRT(out.stim,1));
    RT.OR.in.nostim(totalEEG,1) = nanmean(SRT(in.nostim,1));
    RT.OR.out.nostim(totalEEG,1) = nanmean(SRT(out.nostim,1));
    
    
    TDT.OR.stim(totalEEG,1) = getTDT_AD(OR,in.stim,out.stim);
    TDT.OR.nostim(totalEEG,1) = getTDT_AD(OR,in.nostim,out.nostim);
    
    ROC.OR.stim(totalEEG,1:601) = getROC(OR(:,400:1000),in.stim,out.stim,30);
    ROC.OR.nostim(totalEEG,1:601) = getROC(OR(:,400:1000),in.nostim,out.nostim,30);
    
    wf.OR.in.stim(totalEEG,1:3001) = nanmean(OR(in.stim,:));
    wf.OR.in.nostim(totalEEG,1:3001) = nanmean(OR(in.nostim,:));
    
    wf.OR.out.stim(totalEEG,1:3001) = nanmean(OR(out.stim,:));
    wf.OR.out.nostim(totalEEG,1:3001) = nanmean(OR(out.nostim,:));
    
    clear LFP RF antiRF
    
    if plotFlag == 1
        f = figure;
        
        subplot(1,2,1)
        plot(-500:2500,wf.OR.in.stim(totalEEG,1:3001),'r',-500:2500,wf.OR.out.stim(totalEEG,1:3001),'--r', ...
            -500:2500,wf.OR.in.nostim(totalEEG,1:3001),'b',-500:2500,wf.OR.out.nostim(totalEEG,1:3001),'--b')
        axis ij
        xlim([-100 500])
        
        vline(TDT.OR.stim(totalEEG,1),'r')
        vline(TDT.OR.nostim(totalEEG,1),'b')
        
        subplot(1,2,2)
        plot(-100:500,ROC.OR.stim(totalEEG,1:601),'r',-100:500,ROC.OR.nostim(totalEEG,1:601),'b')
        xlim([-100 500])
        
        
        
        eval(['print -dpdf ',q,'/volumes/Dump/Analyses/uStim/TDT_uStim/StimRight/PDF/',file_name{sess},'_','OR.pdf',q])
        close(f)
    end
    
end


keep file_name sess plotFlag saveFlag q RT TDT ROC wf totalLFP totalDSP totalEEG


if saveFlag == 1
    save('/volumes/Dump/Analyses/uStim/TDT_uStim/StimRight/StimRight.mat', ...
        'TDT','RT','ROC','wf','-mat')
end