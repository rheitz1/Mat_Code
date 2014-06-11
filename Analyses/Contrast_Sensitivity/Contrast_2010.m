% luminance response analysis 2010 version
% already saved results of Poisson Burst into files
% RPH

cd /Volumes/Dump/Search_Data_with_Bursts/MG_FEF

file_list = dir('*_MG*');

printFlag = 0;

totalNeuron = 0;
totalLFP = 0;
totalEEG = 0;

for sess = 3:length(file_list)
    file_list(sess).name
    
    load(file_list(sess).name,'Target_','Correct_','SRT','BurstStartTimes','RFs','TrialStart_','Hemi')
    
    if size(Target_,1) < 300
        disp('Too few trials.  Skipping...')
        continue
    end
    
    
    %load DSP and AD channels
    loadChan(file_list(sess).name,'DSP');
    loadChan(file_list(sess).name,'LFP');
    
    varlist = who;
    NeuronList = varlist(strmatch('DSP',varlist'));
    LFPlist = varlist(strmatch('AD',varlist));
    clear varlist
    
    %manually load AD02 & AD03
    load(file_list(sess).name,'AD02','AD03');
    
    
    lumarray = unique(Target_(:,3));
    
    %remove any stray '1'
    lumarray = lumarray(find(lumarray > 1));
    
    %sometimes MG didn't have more than 1 luminance - possibly actually a
    %detection session
    if length(lumarray) < 5
        disp('Too few luminances!')
        continue
    end
    
    %take note as to whether we are using the low or high spectrum
    if min(lumarray) == 101
        range(sess,1) = 'L';
    elseif min(lumarray) == 140
        range(sess,1) = 'H';
    else
        error('range unknown')
    end
    
    
    %what is division between spacings?
    jump = lumarray(2) - lumarray(1);
    
    %also group some together
    spacing = ceil(length(lumarray) / 3);
    L1 = lumarray(1):jump:lumarray(spacing);
    L2 = lumarray(spacing+1):jump:lumarray(spacing*2);
    L3 = lumarray(spacing*2+1):jump:lumarray(end);
    
    %RTs by luminance, regardless of RF position
    RTs.low(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & ismember(Target_(:,3),L1) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.med(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & ismember(Target_(:,3),L2) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.high(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & ismember(Target_(:,3),L3) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin1(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(1) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin2(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(2) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin3(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(3) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin4(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(4) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin5(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(5) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin6(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(6) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin7(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(7) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin8(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(8) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin9(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(9) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin10(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(10) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.bin11(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,3) == lumarray(11) & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    
    
    if length(lumarray) ~= 11; error('not 11 luminance values...'); end
    
    %%===================================
    % FOR NEURONS
    Plot_Time = [-100 500];
    NeuronList = fields(RFs);
    for neuron = 1:length(NeuronList)
        
        if ~isempty(RFs.(NeuronList{neuron}))
            totalNeuron = totalNeuron + 1;
            RF = RFs.(NeuronList{neuron});
        else
            disp('Missing RF...')
            continue
        end
        
        
        L1_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L1) & ismember(Target_(:,2),RF));
        L2_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L2) & ismember(Target_(:,2),RF));
        L3_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L3) & ismember(Target_(:,2),RF));
        
        lum_trls.bin1 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(1)) & ismember(Target_(:,2),RF));
        lum_trls.bin2 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(2)) & ismember(Target_(:,2),RF));
        lum_trls.bin3 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(3)) & ismember(Target_(:,2),RF));
        lum_trls.bin4 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(4)) & ismember(Target_(:,2),RF));
        lum_trls.bin5 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(5)) & ismember(Target_(:,2),RF));
        lum_trls.bin6 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(6)) & ismember(Target_(:,2),RF));
        lum_trls.bin7 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(7)) & ismember(Target_(:,2),RF));
        lum_trls.bin8 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(8)) & ismember(Target_(:,2),RF));
        lum_trls.bin9 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(9)) & ismember(Target_(:,2),RF));
        lum_trls.bin10 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(10)) & ismember(Target_(:,2),RF));
        lum_trls.bin11 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(11)) & ismember(Target_(:,2),RF));
        
        n.low(totalNeuron,1) = length(L1_trls);
        n.med(totalNeuron,1) = length(L2_trls);
        n.high(totalNeuron,1) = length(L3_trls);
        n.bin1(totalNeuron,1) = length(lum_trls.bin1);
        n.bin2(totalNeuron,1) = length(lum_trls.bin2);
        n.bin3(totalNeuron,1) = length(lum_trls.bin3);
        n.bin4(totalNeuron,1) = length(lum_trls.bin4);
        n.bin5(totalNeuron,1) = length(lum_trls.bin5);
        n.bin6(totalNeuron,1) = length(lum_trls.bin6);
        n.bin7(totalNeuron,1) = length(lum_trls.bin7);
        n.bin8(totalNeuron,1) = length(lum_trls.bin8);
        n.bin9(totalNeuron,1) = length(lum_trls.bin9);
        n.bin10(totalNeuron,1) = length(lum_trls.bin10);
        n.bin11(totalNeuron,1) = length(lum_trls.bin11);
        
        
        Spike = eval(NeuronList{neuron});
        SDF.alltr = sSDF(Spike,Target_(:,1),[Plot_Time(1) Plot_Time(2)]);
        
        SDF.low(totalNeuron,:) = nanmean(SDF.alltr(L1_trls,:));
        SDF.med(totalNeuron,:) = nanmean(SDF.alltr(L2_trls,:));
        SDF.high(totalNeuron,:) = nanmean(SDF.alltr(L3_trls,:));
        
        SDF.bin1(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin1,:));
        SDF.bin2(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin2,:));
        SDF.bin3(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin3,:));
        SDF.bin4(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin4,:));
        SDF.bin5(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin5,:));
        SDF.bin6(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin6,:));
        SDF.bin7(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin7,:));
        SDF.bin8(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin8,:));
        SDF.bin9(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin9,:));
        SDF.bin10(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin10,:));
        SDF.bin11(totalNeuron,:) = nanmean(SDF.alltr(lum_trls.bin11,:));
        
        Bursts.low.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(L1_trls,1));']);
        Bursts.med.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(L2_trls,1));']);
        Bursts.high.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(L3_trls,1));']);
        Bursts.bin1.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin1,1));']);
        Bursts.bin2.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin2,1));']);
        Bursts.bin3.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin3,1));']);
        Bursts.bin4.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin4,1));']);
        Bursts.bin5.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin5,1));']);
        Bursts.bin6.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin6,1));']);
        Bursts.bin7.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin7,1));']);
        Bursts.bin8.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin8,1));']);
        Bursts.bin9.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin9,1));']);
        Bursts.bin10.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin10,1));']);
        Bursts.bin11.mean(totalNeuron,1) = eval(['nanmean(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin11,1));']);
        
        Bursts.low.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(L1_trls,1));']);
        Bursts.med.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(L2_trls,1));']);
        Bursts.high.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(L3_trls,1));']);
        Bursts.bin1.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin1,1));']);
        Bursts.bin2.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin2,1));']);
        Bursts.bin3.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin3,1));']);
        Bursts.bin4.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin4,1));']);
        Bursts.bin5.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin5,1));']);
        Bursts.bin6.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin6,1));']);
        Bursts.bin7.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin7,1));']);
        Bursts.bin8.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin8,1));']);
        Bursts.bin9.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin9,1));']);
        Bursts.bin10.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin10,1));']);
        Bursts.bin11.median(totalNeuron,1) = eval(['nanmedian(BurstStartTimes.' (NeuronList{neuron}) '(lum_trls.bin11,1));']);
        
        
        
        %calculate onset times using successive Wilcoxon ranksum tests
        base_low = nanmean(SDF.alltr(L1_trls,1:99),2);
        for t = 100:601
            [p(t) h(t)] = ranksum(SDF.alltr(L1_trls,t),base_low);
        end
        rank_onset.low = min(findRuns(h,5));
        clear p h
        
        base_med = nanmean(SDF.alltr(L2_trls,1:99),2);
        for t = 100:601
            [p(t) h(t)] = ranksum(SDF.alltr(L2_trls,t),base_med);
        end
        rank_onset.med = min(findRuns(h,5));
        clear p h
        
        base_high = nanmean(SDF.alltr(L3_trls,1:99),2);
        for t = 100:601
            [p(t) h(t)] = ranksum(SDF.alltr(L3_trls,t),base_high);
        end
        rank_onset.high = min(findRuns(h,5));
        clear p h
        
        
        
        infos.neuron(totalNeuron,1) = {file_list(sess).name};
        infos.neuron(totalNeuron,2) = {NeuronList{neuron}};
        
        cp_low.neuron(totalNeuron,1) = change_point(nanmean(SDF.alltr(L1_trls,100:end)));
        cp_med.neuron(totalNeuron,1) = change_point(nanmean(SDF.alltr(L2_trls,100:end)));
        cp_high.neuron(totalNeuron,1) = change_point(nanmean(SDF.alltr(L3_trls,100:end)));
        
        
        clear L1_trls L2_trls L3_trls lum_trls Spike RF
        
        
        if printFlag == 1
            f = figure;
            
            subplot(2,2,1)
            plot(-100:500,SDF.high(totalNeuron,:),'k',-100:500,SDF.med(totalNeuron,:),'b',-100:500,SDF.low(totalNeuron,:),'r')
            xlim([-100 500])
            
            vline(Bursts.high.median(totalNeuron,1),'k')
            vline(Bursts.med.median(totalNeuron,1),'b')
            vline(Bursts.low.median(totalNeuron,1),'r')
            
            vline(cp_low.neuron(totalNeuron,1),'--r')
            vline(cp_med.neuron(totalNeuron,1),'--b')
            vline(cp_high.neuron(totalNeuron,1),'--k')
            
            subplot(2,2,2)
            graylines
            plot(-100:500,SDF.bin11(totalNeuron,:),-100:500,SDF.bin10(totalNeuron,:), ...
                -100:500,SDF.bin9(totalNeuron,:),-100:500,SDF.bin8(totalNeuron,:), ...
                -100:500,SDF.bin7(totalNeuron,:),-100:500,SDF.bin6(totalNeuron,:), ...
                -100:500,SDF.bin5(totalNeuron,:),-100:500,SDF.bin4(totalNeuron,:), ...
                -100:500,SDF.bin3(totalNeuron,:),-100:500,SDF.bin2(totalNeuron,:), ...
                -100:500,SDF.bin1(totalNeuron,:))
            
            xlim([-100 500])
            
            colorlines
            
            subplot(2,2,3)
            plot(lumarray,[Bursts.bin11.median(totalNeuron,1) Bursts.bin10.median(totalNeuron,1) ...
                Bursts.bin9.median(totalNeuron,1) Bursts.bin8.median(totalNeuron,1) ...
                Bursts.bin7.median(totalNeuron,1) Bursts.bin6.median(totalNeuron,1) ...
                Bursts.bin5.median(totalNeuron,1) Bursts.bin4.median(totalNeuron,1) ...
                Bursts.bin3.median(totalNeuron,1) Bursts.bin2.median(totalNeuron,1) ...
                Bursts.bin1.median(totalNeuron,1)],'k')
            xlim([lumarray(1) lumarray(11)])
            
            subplot(2,2,4)
            plot(1:3,[Bursts.low.median(totalNeuron,1) Bursts.med.median(totalNeuron,1) ...
                Bursts.high.median(totalNeuron,1)],'ok')
            
            %put in regression line
            lsline
            
            xlim([.8 3.2])
            set(gca,'xticklabel',['high';'med ';'low '])
            
            eval(['print -dpdf /volumes/Dump/Analyses/Contrast_Sensitivity/PDF/' file_list(sess).name '_' NeuronList{neuron} '.pdf'])
            
            close(f)
        end
        
    end
    
    
    
    
    %%===================================
    % FOR LFP
    Plot_Time = [-500 2500];
    
    for currLFP = 1:length(LFPlist)
        totalLFP = totalLFP + 1;
        
        LFPsig = eval(LFPlist{currLFP});
        
        %fix saturated trials
        LFPsig = fixClipped(LFPsig);
        
        %baseline correct
        LFPsig = baseline_correct(LFPsig,[400 500]);
        
        if Hemi.(LFPlist{currLFP}) == 'L'
            RF = [7 0 1];
        elseif Hemi.(LFPlist{currLFP}) == 'R'
            RF = [3 4 5];
        else
            error('Error with Hemi')
        end
        
        
        L1_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L1) & ismember(Target_(:,2),RF));
        L2_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L2) & ismember(Target_(:,2),RF));
        L3_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L3) & ismember(Target_(:,2),RF));
        
        lum_trls.bin1 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(1)) & ismember(Target_(:,2),RF));
        lum_trls.bin2 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(2)) & ismember(Target_(:,2),RF));
        lum_trls.bin3 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(3)) & ismember(Target_(:,2),RF));
        lum_trls.bin4 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(4)) & ismember(Target_(:,2),RF));
        lum_trls.bin5 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(5)) & ismember(Target_(:,2),RF));
        lum_trls.bin6 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(6)) & ismember(Target_(:,2),RF));
        lum_trls.bin7 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(7)) & ismember(Target_(:,2),RF));
        lum_trls.bin8 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(8)) & ismember(Target_(:,2),RF));
        lum_trls.bin9 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(9)) & ismember(Target_(:,2),RF));
        lum_trls.bin10 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(10)) & ismember(Target_(:,2),RF));
        lum_trls.bin11 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(11)) & ismember(Target_(:,2),RF));
        
        
        n.low(totalLFP,1) = length(L1_trls);
        n.med(totalLFP,1) = length(L2_trls);
        n.high(totalLFP,1) = length(L3_trls);
        n.bin1(totalLFP,1) = length(lum_trls.bin1);
        n.bin2(totalLFP,1) = length(lum_trls.bin2);
        n.bin3(totalLFP,1) = length(lum_trls.bin3);
        n.bin4(totalLFP,1) = length(lum_trls.bin4);
        n.bin5(totalLFP,1) = length(lum_trls.bin5);
        n.bin6(totalLFP,1) = length(lum_trls.bin6);
        n.bin7(totalLFP,1) = length(lum_trls.bin7);
        n.bin8(totalLFP,1) = length(lum_trls.bin8);
        n.bin9(totalLFP,1) = length(lum_trls.bin9);
        n.bin10(totalLFP,1) = length(lum_trls.bin10);
        n.bin11(totalLFP,1) = length(lum_trls.bin11);
        
        LFP.low(totalLFP,:) = nanmean(LFPsig(L1_trls,:));
        LFP.med(totalLFP,:) = nanmean(LFPsig(L2_trls,:));
        LFP.high(totalLFP,:) = nanmean(LFPsig(L3_trls,:));
        
        LFP.bin1(totalLFP,:) = nanmean(LFPsig(lum_trls.bin1,:));
        LFP.bin2(totalLFP,:) = nanmean(LFPsig(lum_trls.bin2,:));
        LFP.bin3(totalLFP,:) = nanmean(LFPsig(lum_trls.bin3,:));
        LFP.bin4(totalLFP,:) = nanmean(LFPsig(lum_trls.bin4,:));
        LFP.bin5(totalLFP,:) = nanmean(LFPsig(lum_trls.bin5,:));
        LFP.bin6(totalLFP,:) = nanmean(LFPsig(lum_trls.bin6,:));
        LFP.bin7(totalLFP,:) = nanmean(LFPsig(lum_trls.bin7,:));
        LFP.bin8(totalLFP,:) = nanmean(LFPsig(lum_trls.bin8,:));
        LFP.bin9(totalLFP,:) = nanmean(LFPsig(lum_trls.bin9,:));
        LFP.bin10(totalLFP,:) = nanmean(LFPsig(lum_trls.bin10,:));
        LFP.bin11(totalLFP,:) = nanmean(LFPsig(lum_trls.bin11,:));
        
        
        infos.LFP(totalLFP,1) = {file_list(sess).name};
        infos.LFP(totalLFP,2) = {LFPlist{currLFP}};
        
        cp_low.LFP(totalLFP,1) = change_point(nanmean(-LFPsig(L1_trls,500:700)));
        cp_med.LFP(totalLFP,1) = change_point(nanmean(-LFPsig(L2_trls,500:700)));
        cp_high.LFP(totalLFP,1) = change_point(nanmean(-LFPsig(L3_trls,500:700)));
        
        clear L1_trls L2_trls L3_trls lum_trls LFPsig RF
        
        if printFlag == 1
            f = figure;
            
            subplot(1,2,1)
            plot(-500:2500,LFP.high(totalLFP,:),'k',-500:2500,LFP.med(totalLFP,:),'b',-500:2500,LFP.low(totalLFP,:),'r')
            xlim([-100 500])
            axis ij
            
            vline(cp_low.LFP(totalLFP,1),'r')
            vline(cp_med.LFP(totalLFP,1),'b')
            vline(cp_high.LFP(totalLFP,1),'k')
            
            subplot(1,2,2)
            graylines
            plot(-500:2500,LFP.bin11(totalLFP,:),-500:2500,LFP.bin10(totalLFP,:), ...
                -500:2500,LFP.bin9(totalLFP,:),-500:2500,LFP.bin8(totalLFP,:), ...
                -500:2500,LFP.bin7(totalLFP,:),-500:2500,LFP.bin6(totalLFP,:), ...
                -500:2500,LFP.bin5(totalLFP,:),-500:2500,LFP.bin4(totalLFP,:), ...
                -500:2500,LFP.bin3(totalLFP,:),-500:2500,LFP.bin2(totalLFP,:), ...
                -500:2500,LFP.bin1(totalLFP,:))
            
            xlim([-100 500])
            axis ij
            
            colorlines
            
            
            
            eval(['print -dpdf /volumes/Dump/Analyses/Contrast_Sensitivity/PDF/' file_list(sess).name '_' LFPlist{currLFP} '.pdf'])
            
            close(f)
        end
    end
    
    
    
    %%===================================
    % FOR AD02
    Plot_Time = [-500 2500];
    
    for currEEG = 1:2
        totalEEG = totalEEG + 1;
        
        EEGsig = AD02;
        
        %fix saturated trials
        EEGsig = fixClipped(EEGsig);
        
        %truncate 20 ms before saccade
        EEGsig = truncateAD_targ(EEGsig,SRT);
        
        %baseline correct
        EEGsig = baseline_correct(EEGsig,[400 500]);
        
        %AD02 = OR, so RF = left hemisphere
        RF = [3 4 5];
        
        L1_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L1) & ismember(Target_(:,2),RF));
        L2_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L2) & ismember(Target_(:,2),RF));
        L3_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L3) & ismember(Target_(:,2),RF));
        
        lum_trls.bin1 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(1)) & ismember(Target_(:,2),RF));
        lum_trls.bin2 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(2)) & ismember(Target_(:,2),RF));
        lum_trls.bin3 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(3)) & ismember(Target_(:,2),RF));
        lum_trls.bin4 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(4)) & ismember(Target_(:,2),RF));
        lum_trls.bin5 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(5)) & ismember(Target_(:,2),RF));
        lum_trls.bin6 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(6)) & ismember(Target_(:,2),RF));
        lum_trls.bin7 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(7)) & ismember(Target_(:,2),RF));
        lum_trls.bin8 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(8)) & ismember(Target_(:,2),RF));
        lum_trls.bin9 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(9)) & ismember(Target_(:,2),RF));
        lum_trls.bin10 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(10)) & ismember(Target_(:,2),RF));
        lum_trls.bin11 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(11)) & ismember(Target_(:,2),RF));
        
        
        n.low(totalEEG,1) = length(L1_trls);
        n.med(totalEEG,1) = length(L2_trls);
        n.high(totalEEG,1) = length(L3_trls);
        n.bin1(totalEEG,1) = length(lum_trls.bin1);
        n.bin2(totalEEG,1) = length(lum_trls.bin2);
        n.bin3(totalEEG,1) = length(lum_trls.bin3);
        n.bin4(totalEEG,1) = length(lum_trls.bin4);
        n.bin5(totalEEG,1) = length(lum_trls.bin5);
        n.bin6(totalEEG,1) = length(lum_trls.bin6);
        n.bin7(totalEEG,1) = length(lum_trls.bin7);
        n.bin8(totalEEG,1) = length(lum_trls.bin8);
        n.bin9(totalEEG,1) = length(lum_trls.bin9);
        n.bin10(totalEEG,1) = length(lum_trls.bin10);
        n.bin11(totalEEG,1) = length(lum_trls.bin11);
        
        EEG.low(totalEEG,:) = nanmean(EEGsig(L1_trls,:));
        EEG.med(totalEEG,:) = nanmean(EEGsig(L2_trls,:));
        EEG.high(totalEEG,:) = nanmean(EEGsig(L3_trls,:));
        
        EEG.bin1(totalEEG,:) = nanmean(EEGsig(lum_trls.bin1,:));
        EEG.bin2(totalEEG,:) = nanmean(EEGsig(lum_trls.bin2,:));
        EEG.bin3(totalEEG,:) = nanmean(EEGsig(lum_trls.bin3,:));
        EEG.bin4(totalEEG,:) = nanmean(EEGsig(lum_trls.bin4,:));
        EEG.bin5(totalEEG,:) = nanmean(EEGsig(lum_trls.bin5,:));
        EEG.bin6(totalEEG,:) = nanmean(EEGsig(lum_trls.bin6,:));
        EEG.bin7(totalEEG,:) = nanmean(EEGsig(lum_trls.bin7,:));
        EEG.bin8(totalEEG,:) = nanmean(EEGsig(lum_trls.bin8,:));
        EEG.bin9(totalEEG,:) = nanmean(EEGsig(lum_trls.bin9,:));
        EEG.bin10(totalEEG,:) = nanmean(EEGsig(lum_trls.bin10,:));
        EEG.bin11(totalEEG,:) = nanmean(EEGsig(lum_trls.bin11,:));
        
        
        infos.EEG(totalEEG,1) = {file_list(sess).name};
        infos.EEG(totalEEG,2) = {'AD02'};
        
        
        clear L1_trls L2_trls L3_trls lum_trls EEGsig RF
        
        if printFlag == 1
            f = figure;
            
            subplot(1,2,1)
            plot(-500:2500,EEG.high(totalEEG,:),'k',-500:2500,EEG.med(totalEEG,:),'b',-500:2500,EEG.low(totalEEG,:),'r')
            xlim([-100 500])
            axis ij
            
            subplot(1,2,2)
            graylines
            plot(-500:2500,EEG.bin11(totalEEG,:),-500:2500,EEG.bin10(totalEEG,:), ...
                -500:2500,EEG.bin9(totalEEG,:),-500:2500,EEG.bin8(totalEEG,:), ...
                -500:2500,EEG.bin7(totalEEG,:),-500:2500,EEG.bin6(totalEEG,:), ...
                -500:2500,EEG.bin5(totalEEG,:),-500:2500,EEG.bin4(totalEEG,:), ...
                -500:2500,EEG.bin3(totalEEG,:),-500:2500,EEG.bin2(totalEEG,:), ...
                -500:2500,EEG.bin1(totalEEG,:))
            
            
            xlim([-100 500])
            axis ij
            
            colorlines
            
            
            
            eval(['print -dpdf /volumes/Dump/Analyses/Contrast_Sensitivity/PDF/' file_list(sess).name '_AD02.pdf'])
            
            close(f)
        end
    end
    
    
    
    %%===================================
    % FOR AD03
    Plot_Time = [-500 2500];
    
    for currEEG = 1:2
        totalEEG = totalEEG + 1;
        
        EEGsig = AD03;
        
        %fix saturated trials
        EEGsig = fixClipped(EEGsig);
        
        %truncate 20 ms before saccade
        EEGsig = truncateAD_targ(EEGsig,SRT);
        
        %baseline correct
        EEGsig = baseline_correct(EEGsig,[400 500]);
        
        %AD03 = OR, so RF = left hemisphere
        RF = [7 0 1];
        
        
        L1_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L1) & ismember(Target_(:,2),RF));
        L2_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L2) & ismember(Target_(:,2),RF));
        L3_trls = find(Correct_(:,2) == 1 & ismember(Target_(:,3),L3) & ismember(Target_(:,2),RF));
        
        lum_trls.bin1 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(1)) & ismember(Target_(:,2),RF));
        lum_trls.bin2 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(2)) & ismember(Target_(:,2),RF));
        lum_trls.bin3 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(3)) & ismember(Target_(:,2),RF));
        lum_trls.bin4 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(4)) & ismember(Target_(:,2),RF));
        lum_trls.bin5 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(5)) & ismember(Target_(:,2),RF));
        lum_trls.bin6 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(6)) & ismember(Target_(:,2),RF));
        lum_trls.bin7 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(7)) & ismember(Target_(:,2),RF));
        lum_trls.bin8 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(8)) & ismember(Target_(:,2),RF));
        lum_trls.bin9 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(9)) & ismember(Target_(:,2),RF));
        lum_trls.bin10 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(10)) & ismember(Target_(:,2),RF));
        lum_trls.bin11 = find(Correct_(:,2) == 1 & ismember(Target_(:,3),lumarray(11)) & ismember(Target_(:,2),RF));
        
        
        n.low(totalEEG,1) = length(L1_trls);
        n.med(totalEEG,1) = length(L2_trls);
        n.high(totalEEG,1) = length(L3_trls);
        n.bin1(totalEEG,1) = length(lum_trls.bin1);
        n.bin2(totalEEG,1) = length(lum_trls.bin2);
        n.bin3(totalEEG,1) = length(lum_trls.bin3);
        n.bin4(totalEEG,1) = length(lum_trls.bin4);
        n.bin5(totalEEG,1) = length(lum_trls.bin5);
        n.bin6(totalEEG,1) = length(lum_trls.bin6);
        n.bin7(totalEEG,1) = length(lum_trls.bin7);
        n.bin8(totalEEG,1) = length(lum_trls.bin8);
        n.bin9(totalEEG,1) = length(lum_trls.bin9);
        n.bin10(totalEEG,1) = length(lum_trls.bin10);
        n.bin11(totalEEG,1) = length(lum_trls.bin11);
        
        EEG.low(totalEEG,:) = nanmean(EEGsig(L1_trls,:));
        EEG.med(totalEEG,:) = nanmean(EEGsig(L2_trls,:));
        EEG.high(totalEEG,:) = nanmean(EEGsig(L3_trls,:));
        
        EEG.bin1(totalEEG,:) = nanmean(EEGsig(lum_trls.bin1,:));
        EEG.bin2(totalEEG,:) = nanmean(EEGsig(lum_trls.bin2,:));
        EEG.bin3(totalEEG,:) = nanmean(EEGsig(lum_trls.bin3,:));
        EEG.bin4(totalEEG,:) = nanmean(EEGsig(lum_trls.bin4,:));
        EEG.bin5(totalEEG,:) = nanmean(EEGsig(lum_trls.bin5,:));
        EEG.bin6(totalEEG,:) = nanmean(EEGsig(lum_trls.bin6,:));
        EEG.bin7(totalEEG,:) = nanmean(EEGsig(lum_trls.bin7,:));
        EEG.bin8(totalEEG,:) = nanmean(EEGsig(lum_trls.bin8,:));
        EEG.bin9(totalEEG,:) = nanmean(EEGsig(lum_trls.bin9,:));
        EEG.bin10(totalEEG,:) = nanmean(EEGsig(lum_trls.bin10,:));
        EEG.bin11(totalEEG,:) = nanmean(EEGsig(lum_trls.bin11,:));
        
        
        infos.EEG(totalEEG,1) = {file_list(sess).name};
        infos.EEG(totalEEG,2) = {'AD03'};
        
        
        clear L1_trls L2_trls L3_trls lum_trls EEGsig RF
        
        if printFlag == 1
            f = figure;
            
            subplot(1,2,1)
            plot(-500:2500,EEG.high(totalEEG,:),'k',-500:2500,EEG.med(totalEEG,:),'b',-500:2500,EEG.low(totalEEG,:),'r')
            xlim([-100 500])
            axis ij
            
            subplot(1,2,2)
            graylines
            plot(-500:2500,EEG.bin11(totalEEG,:),-500:2500,EEG.bin10(totalEEG,:), ...
                -500:2500,EEG.bin9(totalEEG,:),-500:2500,EEG.bin8(totalEEG,:), ...
                -500:2500,EEG.bin7(totalEEG,:),-500:2500,EEG.bin6(totalEEG,:), ...
                -500:2500,EEG.bin5(totalEEG,:),-500:2500,EEG.bin4(totalEEG,:), ...
                -500:2500,EEG.bin3(totalEEG,:),-500:2500,EEG.bin2(totalEEG,:), ...
                -500:2500,EEG.bin1(totalEEG,:))
            
            
            xlim([-100 500])
            axis ij
            
            colorlines
            
            
            
            eval(['print -dpdf /volumes/Dump/Analyses/Contrast_Sensitivity/PDF/' file_list(sess).name '_AD03.pdf'])
            
            close(f)
        end
    end
    
    keep printFlag totalNeuron totalLFP totalEEG file_list sess range RTs Bursts SDF LFP EEG n infos
    
end