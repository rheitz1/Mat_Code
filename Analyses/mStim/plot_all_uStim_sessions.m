
cd /volumes/Dump/Search_Data_uStim/
%cd /Search_Data_uStim/

plotFlag = 1;
printFlag = 1;

monkey = 'S';

if monkey == 'S'
    [batch_list hemi] = textread('Sstim.txt', '%s %s');
elseif monkey == 'Q'
    [batch_list hemi] = textread('Qstim.txt', '%s %s');
end


%[batch_list hemi] = textread('Qstim.txt', '%s %s');

for sess = 1:length(batch_list);
    batch_list(sess)
    
    load(cell2mat(batch_list(sess)),'Hemi','SRT','AD02','AD03','Target_','MStim_','TrialStart_','Correct_','Errors_')
    
    
    OL = AD03;
    OR = AD02;
    
    OL = fixClipped(OL,[500 1000]);
    OR = fixClipped(OR,[500 1000]);
    
    OL = baseline_correct(OL,[400 500]);
    OR = baseline_correct(OR,[400 500]);
    
    OL_trunc = truncateAD_targ(OL,SRT);
    OR_trunc = truncateAD_targ(OR,SRT);
    
    contraCorrectOL_stim = find(~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL_stim = find(~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOR_stim = find(~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR_stim = find(~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOL_nostim = find(isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL_nostim = find(isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOR_nostim = find(isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR_nostim = find(isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    % Monkey S has malfunctioning OL electrode; thus we will do analyses
    % only for electrode OR for this monkey
    
    
    if monkey == 'Q'
        
        if cell2mat(hemi(sess)) == 'L'
            %non-truncated signals
            allTDT.ipsistim.stim(sess,1) = getTDT_AD(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allTDT.contrastim.stim(sess,1) = getTDT_AD(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allTDT.ipsistim.nostim(sess,1) = getTDT_AD(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allTDT.contrastim.nostim(sess,1) = getTDT_AD(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allROC.ipsistim.stim(sess,1:3001) = getROC(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allROC.contrastim.stim(sess,1:3001) = getROC(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allROC.ipsistim.nostim(sess,1:3001) = getROC(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allROC.contrastim.nostim(sess,1:3001) = getROC(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            
            %note: convention is:  waveform.relation_to_uStim.relation_to_target
            allwf.ipsistim.contra_stim(sess,1:3001) = nanmean(OL(contraCorrectOL_stim,:));
            allwf.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OL(ipsiCorrectOL_stim,:));
            allwf.contrastim.contra_stim(sess,1:3001) = nanmean(OR(contraCorrectOR_stim,:));
            allwf.contrastim.ipsi_stim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_stim,:));
            
            allwf.ipsistim.contra_nostim(sess,1:3001) = nanmean(OL(contraCorrectOL_nostim,:));
            allwf.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OL(ipsiCorrectOL_nostim,:));
            allwf.contrastim.contra_nostim(sess,1:3001) = nanmean(OR(contraCorrectOR_nostim,:));
            allwf.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_nostim,:));
            
            
            %truncated signals
            allTDT_trunc.ipsistim.stim(sess,1) = getTDT_AD(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allTDT_trunc.contrastim.stim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allTDT_trunc.ipsistim.nostim(sess,1) = getTDT_AD(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allTDT_trunc.contrastim.nostim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            
            allROC_trunc.ipsistim.stim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allROC_trunc.contrastim.stim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allROC_trunc.ipsistim.nostim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allROC_trunc.contrastim.nostim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allwf_trunc.ipsistim.contra_stim(sess,1:3001) = nanmean(OL_trunc(contraCorrectOL_stim,:));
            allwf_trunc.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OL_trunc(ipsiCorrectOL_stim,:));
            allwf_trunc.contrastim.contra_stim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_stim,:));
            allwf_trunc.contrastim.ipsi_stim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_stim,:));
            
            allwf_trunc.ipsistim.contra_nostim(sess,1:3001) = nanmean(OL_trunc(contraCorrectOL_nostim,:));
            allwf_trunc.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OL_trunc(ipsiCorrectOL_nostim,:));
            allwf_trunc.contrastim.contra_nostim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_nostim,:));
            allwf_trunc.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_nostim,:));
            
            
        elseif cell2mat(hemi(sess)) == 'R'
            %non-truncated signals
            allTDT.contrastim.stim(sess,1) = getTDT_AD(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allTDT.ipsistim.stim(sess,1) = getTDT_AD(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allTDT.contrastim.nostim(sess,1) = getTDT_AD(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allTDT.ipsistim.nostim(sess,1) = getTDT_AD(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allROC.contrastim.stim(sess,1:3001) = getROC(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allROC.ipsistim.stim(sess,1:3001) = getROC(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allROC.contrastim.nostim(sess,1:3001) = getROC(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allROC.ipsistim.nostim(sess,1:3001) = getROC(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allwf.contrastim.contra_stim(sess,1:3001) = nanmean(OL(contraCorrectOL_stim,:));
            allwf.contrastim.ipsi_stim(sess,1:3001) = nanmean(OL(ipsiCorrectOL_stim,:));
            allwf.ipsistim.contra_stim(sess,1:3001) = nanmean(OR(contraCorrectOR_stim,:));
            allwf.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_stim,:));
            
            allwf.contrastim.contra_nostim(sess,1:3001) = nanmean(OL(contraCorrectOL_nostim,:));
            allwf.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OL(ipsiCorrectOL_nostim,:));
            allwf.ipsistim.contra_nostim(sess,1:3001) = nanmean(OR(contraCorrectOR_nostim,:));
            allwf.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_nostim,:));
            
            
            %truncated signals
            allTDT_trunc.contrastim.stim(sess,1) = getTDT_AD(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allTDT_trunc.ipsistim.stim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allTDT_trunc.contrastim.nostim(sess,1) = getTDT_AD(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allTDT_trunc.ipsistim.nostim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allROC_trunc.contrastim.stim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allROC_trunc.ipsistim.stim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allROC_trunc.contrastim.nostim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allROC_trunc.ipsistim.nostim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            
            allwf_trunc.contrastim.contra_stim(sess,1:3001) = nanmean(OL_trunc(contraCorrectOL_stim,:));
            allwf_trunc.contrastim.ipsi_stim(sess,1:3001) = nanmean(OL_trunc(ipsiCorrectOL_stim,:));
            allwf_trunc.ipsistim.contra_stim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_stim,:));
            allwf_trunc.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_stim,:));
            
            allwf_trunc.contrastim.contra_nostim(sess,1:3001) = nanmean(OL_trunc(contraCorrectOL_nostim,:));
            allwf_trunc.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OL_trunc(ipsiCorrectOL_nostim,:));
            allwf_trunc.ipsistim.contra_nostim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_nostim,:));
            allwf_trunc.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_nostim,:));
            
        end
        
        %mean RT for stim and nostim, using hemi contra/ipsi relative to stim
        if cell2mat(hemi(sess)) == 'L'
            trls_contra_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            %for accuracy rate
            all_contra_stim = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            all_ipsi_stim = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            
            trls_contra_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            all_contra_nostim = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            all_ipsi_nostim = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            
        elseif cell2mat(hemi(sess)) == 'R'
            trls_contra_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            all_contra_stim = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            all_ipsi_stim = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            trls_contra_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            all_contra_nostim = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            all_ipsi_nostim = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        end
        
        allRT.contratarg.stim(sess,1) = nanmean(SRT(trls_contra_stim,1));
        allRT.ipsitarg.stim(sess,1) = nanmean(SRT(trls_ipsi_stim,1));
        
        allRT.contratarg.nostim(sess,1) = nanmean(SRT(trls_contra_nostim,1));
        allRT.ipsitarg.nostim(sess,1) = nanmean(SRT(trls_ipsi_nostim,1));
        
        allACC.contratarg.stim(sess,1) = length(trls_contra_stim) / length(all_contra_stim);
        allACC.ipsitarg.stim(sess,1) = length(trls_ipsi_stim) / length(all_ipsi_stim);
        
        allACC.contratarg.nostim(sess,1) = length(trls_contra_nostim) / length(all_contra_nostim);
        allACC.ipsitarg.nostim(sess,1) = length(trls_ipsi_nostim) / length(all_ipsi_nostim);
        
    elseif monkey == 'S'
        
        if cell2mat(hemi(sess)) == 'L'
            %non-truncated signals
            allTDT.ipsistim.stim(sess,1) = NaN;
            allTDT.contrastim.stim(sess,1) = getTDT_AD(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allTDT.ipsistim.nostim(sess,1) = NaN;
            allTDT.contrastim.nostim(sess,1) = getTDT_AD(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allROC.ipsistim.stim(sess,1:3001) = NaN;
            allROC.contrastim.stim(sess,1:3001) = getROC(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allROC.ipsistim.nostim(sess,1:3001) = NaN;
            allROC.contrastim.nostim(sess,1:3001) = getROC(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            
            
            allwf.ipsistim.contra_stim(sess,1:3001) = NaN;
            allwf.ipsistim.ipsi_stim(sess,1:3001) = NaN;
            allwf.contrastim.contra_stim(sess,1:3001) = nanmean(OR(contraCorrectOR_stim,:));
            allwf.contrastim.ipsi_stim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_stim,:));
            
            allwf.ipsistim.contra_nostim(sess,1:3001) = NaN;
            allwf.ipsistim.ipsi_nostim(sess,1:3001) = NaN;
            allwf.contrastim.contra_nostim(sess,1:3001) = nanmean(OR(contraCorrectOR_nostim,:));
            allwf.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_nostim,:));
            
            
            %truncated signals
            allTDT_trunc.ipsistim.stim(sess,1) = NaN;
            allTDT_trunc.contrastim.stim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allTDT_trunc.ipsistim.nostim(sess,1) = NaN;
            allTDT_trunc.contrastim.nostim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            
            allROC_trunc.ipsistim.stim(sess,1:3001) = NaN;
            allROC_trunc.contrastim.stim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allROC_trunc.ipsistim.nostim(sess,1:3001) = NaN;
            allROC_trunc.contrastim.nostim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allwf_trunc.ipsistim.contra_stim(sess,1:3001) = NaN;
            allwf_trunc.ipsistim.ipsi_stim(sess,1:3001) = NaN;
            allwf_trunc.contrastim.contra_stim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_stim,:));
            allwf_trunc.contrastim.ipsi_stim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_stim,:));
            
            allwf_trunc.ipsistim.contra_nostim(sess,1:3001) = NaN;
            allwf_trunc.ipsistim.ipsi_nostim(sess,1:3001) = NaN;
            allwf_trunc.contrastim.contra_nostim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_nostim,:));
            allwf_trunc.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_nostim,:));
            
            
        elseif cell2mat(hemi(sess)) == 'R'
            %non-truncated signals
            allTDT.contrastim.stim(sess,1) = NaN;
            allTDT.ipsistim.stim(sess,1) = getTDT_AD(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allTDT.contrastim.nostim(sess,1) = NaN;
            allTDT.ipsistim.nostim(sess,1) = getTDT_AD(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allROC.contrastim.stim(sess,1:3001) = NaN;
            allROC.ipsistim.stim(sess,1:3001) = getROC(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allROC.contrastim.nostim(sess,1:3001) = NaN;
            allROC.ipsistim.nostim(sess,1:3001) = getROC(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allwf.contrastim.contra_stim(sess,1:3001) = NaN;
            allwf.contrastim.ipsi_stim(sess,1:3001) = NaN;
            allwf.ipsistim.contra_stim(sess,1:3001) = nanmean(OR(contraCorrectOR_stim,:));
            allwf.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_stim,:));
            
            allwf.contrastim.contra_nostim(sess,1:3001) = NaN;
            allwf.contrastim.ipsi_nostim(sess,1:3001) = NaN;
            allwf.ipsistim.contra_nostim(sess,1:3001) = nanmean(OR(contraCorrectOR_nostim,:));
            allwf.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_nostim,:));
            
            
            %truncated signals
            allTDT_trunc.contrastim.stim(sess,1) = NaN;
            allTDT_trunc.ipsistim.stim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allTDT_trunc.contrastim.nostim(sess,1) = NaN;
            allTDT_trunc.ipsistim.nostim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            allROC_trunc.contrastim.stim(sess,1:3001) = NaN;
            allROC_trunc.ipsistim.stim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allROC_trunc.contrastim.nostim(sess,1:3001) = NaN;
            allROC_trunc.ipsistim.nostim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            
            allwf_trunc.contrastim.contra_stim(sess,1:3001) = NaN;
            allwf_trunc.contrastim.ipsi_stim(sess,1:3001) = NaN;
            allwf_trunc.ipsistim.contra_stim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_stim,:));
            allwf_trunc.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_stim,:));
            
            allwf_trunc.contrastim.contra_nostim(sess,1:3001) = NaN;
            allwf_trunc.contrastim.ipsi_nostim(sess,1:3001) = NaN;
            allwf_trunc.ipsistim.contra_nostim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_nostim,:));
            allwf_trunc.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_nostim,:));
            
        end
        
        %mean RT for stim and nostim, using hemi contra/ipsi relative to stim
        if cell2mat(hemi(sess)) == 'L'
            trls_contra_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            %for accuracy rate
            all_contra_stim = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            all_ipsi_stim = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            
            trls_contra_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            all_contra_nostim = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            all_ipsi_nostim = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            
        elseif cell2mat(hemi(sess)) == 'R'
            trls_contra_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            all_contra_stim = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            all_ipsi_stim = find(~isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            trls_contra_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            all_contra_nostim = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            all_ipsi_nostim = find(isnan(MStim_(:,1)) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        end
        
        allRT.contratarg.stim(sess,1) = nanmean(SRT(trls_contra_stim,1));
        allRT.ipsitarg.stim(sess,1) = nanmean(SRT(trls_ipsi_stim,1));
        
        allRT.contratarg.nostim(sess,1) = nanmean(SRT(trls_contra_nostim,1));
        allRT.ipsitarg.nostim(sess,1) = nanmean(SRT(trls_ipsi_nostim,1));
        
        allACC.contratarg.stim(sess,1) = length(trls_contra_stim) / length(all_contra_stim);
        allACC.ipsitarg.stim(sess,1) = length(trls_ipsi_stim) / length(all_ipsi_stim);
        
        allACC.contratarg.nostim(sess,1) = length(trls_contra_nostim) / length(all_contra_nostim);
        allACC.ipsitarg.nostim(sess,1) = length(trls_ipsi_nostim) / length(all_ipsi_nostim);
    end
    
    
    
    
    
    
    if plotFlag == 1
        f = figure;
        fw
        
        subplot(3,2,1)
        
        plot(-500:2500,allwf.contrastim.contra_nostim(sess,:),'b',-500:2500,allwf.contrastim.ipsi_nostim(sess,:),'--b','linewidth',2)
        axis ij
        xlim([-50 400])
        set(gca,'YTickLabel',[])
        %y = get(gca,'ylim');
        
        %legend('contra targ nostim','ipsi targ nostim','location','northwest')
        
        newax
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        plot(-500:2500,allwf.contrastim.contra_stim(sess,:),'r',-500:2500,allwf.contrastim.ipsi_stim(sess,:),'--r','linewidth',2)
        axis ij
        xlim([-50 400])
        %set(gca,'ylim',y);
        
        %legend('contra targ stim','ipsi targ stim','location','southwest')
        title('Contra to uStim')
        
        
        vline(allTDT.contrastim.stim(sess),'r')
        vline(allTDT.contrastim.nostim(sess),'b')
        vline(allRT.contratarg.stim(sess),'k')
        vline(allRT.contratarg.nostim(sess),'--k')
        
        
        
        
        subplot(3,2,2)
        
        
        plot(-500:2500,allwf.ipsistim.contra_nostim(sess,:),'b',-500:2500,allwf.ipsistim.ipsi_nostim(sess,:),'--b')
        axis ij
        xlim([-50 400])
        set(gca,'YTickLabel',[])
        %y = get(gca,'ylim');
        
        %legend('contra targ nostim',' ipsi targ nostim','location','northwest')
        
        
        newax
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        plot(-500:2500,allwf.ipsistim.contra_stim(sess,:),'r',-500:2500,allwf.ipsistim.ipsi_stim(sess,:),'--r')
        axis ij
        xlim([-50 400])
        %set(gca,'ylim',y)
        
        %legend('contra targ stim','ipsi targ stim','location','southwest')
        title('Ipsi to uStim')
        
        vline(allTDT.ipsistim.stim(sess),'r')
        vline(allTDT.ipsistim.nostim(sess),'b')
        vline(allRT.ipsitarg.stim(sess),'k')
        vline(allRT.ipsitarg.nostim(sess),'--k')
        
        
        subplot(3,2,3:4)
        plot(-500:2500,allROC.contrastim.stim(sess,:),'r',-500:2500,allROC.contrastim.nostim(sess,:),'b','linewidth',2)
        hold on
        plot(-500:2500,allROC.ipsistim.stim(sess,:),'r',-500:2500,allROC.ipsistim.nostim(sess,:),'b')
        legend('Contra to Stim,uStim','Contra to Stim no uStim','Ipsi to stim,uStim','Ipsi to Stim no uStim','location','northwest')
        
        hline(.5,'k')
        xlim([-50 400])
        
        
        
        subplot(3,2,5)
        bar([allRT.contratarg.nostim(sess) allRT.contratarg.stim(sess) ;...
            allRT.ipsitarg.nostim(sess) allRT.ipsitarg.stim(sess)])
        set(gca,'XTickLabel',['Contra to Targ' ; 'Ipsi  to  Targ'])
        currMaxRT = findMax(allRT.contratarg.nostim(sess),allRT.contratarg.stim(sess),allRT.ipsitarg.nostim(sess),allRT.ipsitarg.stim(sess));
        currMinRT = findMin(allRT.contratarg.nostim(sess),allRT.contratarg.stim(sess),allRT.ipsitarg.nostim(sess),allRT.ipsitarg.stim(sess));
        ylim([currMinRT - 20 currMaxRT + 20])
        title('RT')
        
        % ACC Bar Graph
        subplot(3,2,6)
        bar([allACC.contratarg.nostim(sess) allACC.contratarg.stim(sess) ; ...
            allACC.ipsitarg.nostim(sess) allACC.ipsitarg.stim(sess)])
        set(gca,'XTickLabel',['Contra to Targ' ; 'Ipsi  to  Targ'])
        currMaxACC = findMax(allACC.contratarg.nostim(sess),allACC.contratarg.stim(sess),allACC.ipsitarg.nostim(sess),allACC.ipsitarg.stim(sess));
        currMinACC = findMin(allACC.contratarg.nostim(sess),allACC.contratarg.stim(sess),allACC.ipsitarg.nostim(sess),allACC.ipsitarg.stim(sess));
        ylim([currMinACC - .05 currMaxACC + .05])
        title('Accuracy')
        
        [ax h] = suplabel(batch_list{sess},'t');
        set(ax,'fontsize',12)
        
        
        
        if printFlag == 1
            eval(['print -dpdf /volumes/Dump/Analyses/uStim/Session_Plots/' batch_list{sess} '_nontruncated.pdf'])
        end
        
        
        
        close(f)
        
        %============================================
        %for truncated signals
        f = figure;
        fw
        
        subplot(3,2,1)
        
        
        
        plot(-500:2500,allwf_trunc.contrastim.contra_nostim(sess,:),'b',-500:2500,allwf_trunc.contrastim.ipsi_nostim(sess,:),'--b','linewidth',2)
        axis ij
        xlim([-50 400])
        set(gca,'YTickLabel',[])
        %y = get(gca,'ylim');
        
        %legend('contra targ nostim','ipsi targ nostim','location','northwest')
        
        newax
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        plot(-500:2500,allwf_trunc.contrastim.contra_stim(sess,:),'r',-500:2500,allwf_trunc.contrastim.ipsi_stim(sess,:),'--r','linewidth',2)
        axis ij
        xlim([-50 400])
        %set(gca,'ylim',y);
        
        %legend('contra targ stim','ipsi targ stim','location','southwest')
        title('Contra to uStim')
        
        vline(allTDT_trunc.contrastim.stim(sess,:),'r')
        vline(allTDT_trunc.contrastim.nostim(sess,:),'b')
        vline(allRT.contratarg.stim(sess,:),'k')
        vline(allRT.contratarg.nostim(sess,:),'--k')
        
        
        
        
        subplot(3,2,2)
        
        
        plot(-500:2500,allwf_trunc.ipsistim.contra_nostim(sess,:),'b',-500:2500,allwf_trunc.ipsistim.ipsi_nostim(sess,:),'--b')
        axis ij
        xlim([-50 400])
        set(gca,'YTickLabel',[])
        %y = get(gca,'ylim');
        
        %legend('contra targ nostim',' ipsi targ nostim','location','northwest')
        
        
        newax
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        plot(-500:2500,allwf_trunc.ipsistim.contra_stim(sess,:),'r',-500:2500,allwf_trunc.ipsistim.ipsi_stim(sess,:),'--r')
        axis ij
        xlim([-50 400])
        %set(gca,'ylim',y)
        
        %legend('contra targ stim','ipsi targ stim','location','southwest')
        title('Ipsi to uStim')
        
        vline(allTDT_trunc.ipsistim.stim(sess),'r')
        vline(allTDT_trunc.ipsistim.nostim(sess),'b')
        vline(allRT.ipsitarg.stim(sess),'k')
        vline(allRT.ipsitarg.nostim(sess),'--k')
        
        
        
        subplot(3,2,3:4)
        plot(-500:2500,allROC_trunc.contrastim.stim(sess,:),'r',-500:2500,allROC_trunc.contrastim.nostim(sess,:),'b','linewidth',2)
        hold on
        plot(-500:2500,allROC_trunc.ipsistim.stim(sess,:),'r',-500:2500,allROC_trunc.ipsistim.nostim(sess,:),'b')
        legend('Contra to Stim,uStim','Contra to Stim no uStim','Ipsi to stim,uStim','Ipsi to Stim no uStim','location','northwest')
        
        hline(.5,'k')
        xlim([-50 400])
        
        % RT Bar Graph
        subplot(3,2,5)
        bar([allRT.contratarg.nostim(sess) allRT.contratarg.stim(sess) ;...
            allRT.ipsitarg.nostim(sess) allRT.ipsitarg.stim(sess)])
        set(gca,'XTickLabel',['Contra to Targ' ; 'Ipsi  to  Targ'])
        currMaxRT = findMax(allRT.contratarg.nostim(sess),allRT.contratarg.stim(sess),allRT.ipsitarg.nostim(sess),allRT.ipsitarg.stim(sess));
        currMinRT = findMin(allRT.contratarg.nostim(sess),allRT.contratarg.stim(sess),allRT.ipsitarg.nostim(sess),allRT.ipsitarg.stim(sess));
        ylim([currMinRT - 20 currMaxRT + 20])
        title('RT')
        
        % ACC Bar Graph
        subplot(3,2,6)
        bar([allACC.contratarg.nostim(sess) allACC.contratarg.stim(sess) ; ...
            allACC.ipsitarg.nostim(sess) allACC.ipsitarg.stim(sess)])
        set(gca,'XTickLabel',['Contra to Targ' ; 'Ipsi  to  Targ'])
        currMaxACC = findMax(allACC.contratarg.nostim(sess),allACC.contratarg.stim(sess),allACC.ipsitarg.nostim(sess),allACC.ipsitarg.stim(sess));
        currMinACC = findMin(allACC.contratarg.nostim(sess),allACC.contratarg.stim(sess),allACC.ipsitarg.nostim(sess),allACC.ipsitarg.stim(sess));
        ylim([currMinACC - .05 currMaxACC + .05])
        title('Accuracy')
        
        [ax h] = suplabel(batch_list{sess},'t');
        set(ax,'fontsize',12)
        
        
        if printFlag == 1
            eval(['print -dpdf /volumes/Dump/Analyses/uStim/Session_Plots/' batch_list{sess} '_truncated.pdf'])
        end
        
        
        
        
        close(f)
        
    end
    
    keep monkey hemi allTDT allTDT_trunc allACC allRT allwf allwf_trunc allROC allROC_trunc batch_list sess plotFlag printFlag
end
