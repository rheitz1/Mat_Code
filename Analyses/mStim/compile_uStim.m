
cd /volumes/Dump/Search_Data_uStim/
%cd /Search_Data_uStim/

plotFlag = 1;

monkey = 'Q';

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
    
%     contraCorrectOL_stim = find(~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
%     ipsiCorrectOL_stim = find(~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
%     
%     contraCorrectOR_stim = find(~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
%     ipsiCorrectOR_stim = find(~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
%     
%     contraCorrectOL_nostim = find(isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
%     ipsiCorrectOL_nostim = find(isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
%     
%     contraCorrectOR_nostim = find(isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
%     ipsiCorrectOR_nostim = find(isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
%     

    %Try SS2 Only
    contraCorrectOL_stim = find(Target_(:,5) == 2 & ~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL_stim = find(Target_(:,5) == 2 & ~isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOR_stim = find(Target_(:,5) == 2 & ~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR_stim = find(Target_(:,5) == 2 & ~isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOL_nostim = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL_nostim = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOR_nostim = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR_nostim = find(Target_(:,5) == 2 & isnan(MStim_(:,1)) & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    





    % Monkey S has malfunctioning OL electrode; thus we will do analyses
    % only for electrode OR for this monkey
    
    
    if monkey == 'Q'
        
        if cell2mat(hemi(sess)) == 'L'
            %non-truncated signals
            allTDT.ipsistim.stim(sess,1) = getTDT_AD(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allTDT.contrastim.stim(sess,1) = getTDT_AD(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            allTDT.ipsistim.nostim(sess,1) = getTDT_AD(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allTDT.contrastim.nostim(sess,1) = getTDT_AD(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
%             allROC.ipsistim.stim(sess,1:3001) = getROC(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
%             allROC.contrastim.stim(sess,1:3001) = getROC(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
%             allROC.ipsistim.nostim(sess,1:3001) = getROC(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
%             allROC.contrastim.nostim(sess,1:3001) = getROC(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
%             
            
            
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
            
            
%             allROC_trunc.ipsistim.stim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
%             allROC_trunc.contrastim.stim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
%             allROC_trunc.ipsistim.nostim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
%             allROC_trunc.contrastim.nostim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
%             
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
            
%             allROC.contrastim.stim(sess,1:3001) = getROC(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
%             allROC.ipsistim.stim(sess,1:3001) = getROC(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
%             allROC.contrastim.nostim(sess,1:3001) = getROC(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
%             allROC.ipsistim.nostim(sess,1:3001) = getROC(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
%             
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
%             
%             allROC_trunc.contrastim.stim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
%             allROC_trunc.ipsistim.stim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
%             allROC_trunc.contrastim.nostim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
%             allROC_trunc.ipsistim.nostim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
%             
            
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
            
            trls_contra_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
        elseif cell2mat(hemi(sess)) == 'R'
            trls_contra_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            trls_contra_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        end
        
        allRT.contrastim.stim(sess,1) = nanmean(SRT(trls_contra_stim,1));
        allRT.ipsistim.stim(sess,1) = nanmean(SRT(trls_ipsi_stim,1));
        
        allRT.contrastim.nostim(sess,1) = nanmean(SRT(trls_contra_nostim,1));
        allRT.ipsistim.nostim(sess,1) = nanmean(SRT(trls_ipsi_nostim,1));
        
        keep monkey allROC allROC_trunc allTDT allTDT_trunc allRT allwf allwf_trunc batch_list hemi sess plotFlag
        
        
        

        
    elseif monkey == 'S'
        
        if cell2mat(hemi(sess)) == 'L'
            %non-truncated signals
            %allTDT.ipsistim.stim(sess,1) = getTDT_AD(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allTDT.contrastim.stim(sess,1) = getTDT_AD(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            %allTDT.ipsistim.nostim(sess,1) = getTDT_AD(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allTDT.contrastim.nostim(sess,1) = getTDT_AD(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
%             %allROC.ipsistim.stim(sess,1:3001) = getROC(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
%             allROC.contrastim.stim(sess,1:3001) = getROC(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
%             %allROC.ipsistim.nostim(sess,1:3001) = getROC(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
%             allROC.contrastim.nostim(sess,1:3001) = getROC(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
%             
            
            
            %allwf.ipsistim.contra_stim(sess,1:3001) = nanmean(OL(contraCorrectOL_stim,:));
            %allwf.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OL(ipsiCorrectOL_stim,:));
            allwf.contrastim.contra_stim(sess,1:3001) = nanmean(OR(contraCorrectOR_stim,:));
            allwf.contrastim.ipsi_stim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_stim,:));
            
            %allwf.ipsistim.contra_nostim(sess,1:3001) = nanmean(OL(contraCorrectOL_nostim,:));
            %allwf.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OL(ipsiCorrectOL_nostim,:));
            allwf.contrastim.contra_nostim(sess,1:3001) = nanmean(OR(contraCorrectOR_nostim,:));
            allwf.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_nostim,:));
            
            
            %truncated signals
            %allTDT_trunc.ipsistim.stim(sess,1) = getTDT_AD(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allTDT_trunc.contrastim.stim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            %allTDT_trunc.ipsistim.nostim(sess,1) = getTDT_AD(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allTDT_trunc.contrastim.nostim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
            
%             %allROC_trunc.ipsistim.stim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
%             allROC_trunc.contrastim.stim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
%             %allROC_trunc.ipsistim.nostim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
%             allROC_trunc.contrastim.nostim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
%             
            %allwf_trunc.ipsistim.contra_stim(sess,1:3001) = nanmean(OL_trunc(contraCorrectOL_stim,:));
            %allwf_trunc.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OL_trunc(ipsiCorrectOL_stim,:));
            allwf_trunc.contrastim.contra_stim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_stim,:));
            allwf_trunc.contrastim.ipsi_stim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_stim,:));
            
            %allwf_trunc.ipsistim.contra_nostim(sess,1:3001) = nanmean(OL_trunc(contraCorrectOL_nostim,:));
            %allwf_trunc.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OL_trunc(ipsiCorrectOL_nostim,:));
            allwf_trunc.contrastim.contra_nostim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_nostim,:));
            allwf_trunc.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_nostim,:));
            
            
        elseif cell2mat(hemi(sess)) == 'R'
            %non-truncated signals
            %allTDT.contrastim.stim(sess,1) = getTDT_AD(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allTDT.ipsistim.stim(sess,1) = getTDT_AD(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
            %allTDT.contrastim.nostim(sess,1) = getTDT_AD(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allTDT.ipsistim.nostim(sess,1) = getTDT_AD(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
%             %allROC.contrastim.stim(sess,1:3001) = getROC(OL,contraCorrectOL_stim,ipsiCorrectOL_stim);
%             allROC.ipsistim.stim(sess,1:3001) = getROC(OR,contraCorrectOR_stim,ipsiCorrectOR_stim);
%             %allROC.contrastim.nostim(sess,1:3001) = getROC(OL,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
%             allROC.ipsistim.nostim(sess,1:3001) = getROC(OR,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
%             
            %allwf.contrastim.contra_stim(sess,1:3001) = nanmean(OL(contraCorrectOL_stim,:));
            %allwf.contrastim.ipsi_stim(sess,1:3001) = nanmean(OL(ipsiCorrectOL_stim,:));
            allwf.ipsistim.contra_stim(sess,1:3001) = nanmean(OR(contraCorrectOR_stim,:));
            allwf.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_stim,:));
            
            %allwf.contrastim.contra_nostim(sess,1:3001) = nanmean(OL(contraCorrectOL_nostim,:));
            %allwf.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OL(ipsiCorrectOL_nostim,:));
            allwf.ipsistim.contra_nostim(sess,1:3001) = nanmean(OR(contraCorrectOR_nostim,:));
            allwf.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OR(ipsiCorrectOR_nostim,:));
            
            
            %truncated signals
            %allTDT_trunc.contrastim.stim(sess,1) = getTDT_AD(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
            allTDT_trunc.ipsistim.stim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
            %allTDT_trunc.contrastim.nostim(sess,1) = getTDT_AD(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
            allTDT_trunc.ipsistim.nostim(sess,1) = getTDT_AD(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
            
%             %allROC_trunc.contrastim.stim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_stim,ipsiCorrectOL_stim);
%             allROC_trunc.ipsistim.stim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_stim,ipsiCorrectOR_stim);
%             %allROC_trunc.contrastim.nostim(sess,1:3001) = getROC(OL_trunc,contraCorrectOL_nostim,ipsiCorrectOL_nostim);
%             allROC_trunc.ipsistim.nostim(sess,1:3001) = getROC(OR_trunc,contraCorrectOR_nostim,ipsiCorrectOR_nostim);
%             
%             
            %allwf_trunc.contrastim.contra_stim(sess,1:3001) = nanmean(OL_trunc(contraCorrectOL_stim,:));
            %allwf_trunc.contrastim.ipsi_stim(sess,1:3001) = nanmean(OL_trunc(ipsiCorrectOL_stim,:));
            allwf_trunc.ipsistim.contra_stim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_stim,:));
            allwf_trunc.ipsistim.ipsi_stim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_stim,:));
            
            %allwf_trunc.contrastim.contra_nostim(sess,1:3001) = nanmean(OL_trunc(contraCorrectOL_nostim,:));
            %allwf_trunc.contrastim.ipsi_nostim(sess,1:3001) = nanmean(OL_trunc(ipsiCorrectOL_nostim,:));
            allwf_trunc.ipsistim.contra_nostim(sess,1:3001) = nanmean(OR_trunc(contraCorrectOR_nostim,:));
            allwf_trunc.ipsistim.ipsi_nostim(sess,1:3001) = nanmean(OR_trunc(ipsiCorrectOR_nostim,:));
            
        end
        
        %mean RT for stim and nostim, using hemi contra/ipsi relative to stim
        if cell2mat(hemi(sess)) == 'L'
            trls_contra_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            trls_contra_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
        elseif cell2mat(hemi(sess)) == 'R'
            trls_contra_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            
            trls_contra_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            trls_ipsi_nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        end
        
        allRT.contrastim.stim(sess,1) = nanmean(SRT(trls_contra_stim,1));
        allRT.ipsistim.stim(sess,1) = nanmean(SRT(trls_ipsi_stim,1));
        
        allRT.contrastim.nostim(sess,1) = nanmean(SRT(trls_contra_nostim,1));
        allRT.ipsistim.nostim(sess,1) = nanmean(SRT(trls_ipsi_nostim,1));
        
        keep monkey allROC allROC_trunc allTDT allTDT_trunc allRT allwf allwf_trunc batch_list hemi sess plotFlag
        
    end
    
    
    
end


if plotFlag == 1
    figure
    fw
    
    subplot(2,1,1)
    title('Contra to uStim')
    
    
    plot(-500:2500,nanmean(allwf.contrastim.contra_nostim),'b',-500:2500,nanmean(allwf.contrastim.ipsi_nostim),'--b')
    axis ij
    xlim([-50 400])
    %y = get(gca,'ylim');
    
    legend('contra targ nostim','ipsi targ nostim')
    
    newax
    plot(-500:2500,nanmean(allwf.contrastim.contra_stim),'r',-500:2500,nanmean(allwf.contrastim.ipsi_stim),'--r')
    axis ij
    xlim([-50 400])
    %set(gca,'ylim',y);
    
    legend('contra targ stim','ipsi targ stim')
    
    
    vline(nanmean(allTDT.contrastim.stim),'r')
    vline(nanmean(allTDT.contrastim.nostim),'b')
    vline(nanmean(allRT.contrastim.stim),'k')
    vline(nanmean(allRT.contrastim.nostim),'--k')
    
    
    
    
    subplot(2,1,2)
    title('Ipsi to uStim')
    
    plot(-500:2500,nanmean(allwf.ipsistim.contra_nostim),'b',-500:2500,nanmean(allwf.ipsistim.ipsi_nostim),'--b')
    axis ij
    xlim([-50 400])
    %y = get(gca,'ylim');
    
    legend('contra targ nostim',' ipsi targ nostim')
    
    
    newax
    plot(-500:2500,nanmean(allwf.ipsistim.contra_stim),'r',-500:2500,nanmean(allwf.ipsistim.ipsi_stim),'--r')
    axis ij
    xlim([-50 400])
    %set(gca,'ylim',y)
    
    legend('contra targ stim','ipsi targ stim')
    
    vline(nanmean(allTDT.ipsistim.stim),'r')
    vline(nanmean(allTDT.ipsistim.nostim),'b')
    vline(nanmean(allRT.ipsistim.stim),'k')
    vline(nanmean(allRT.ipsistim.nostim),'--k')
    
    
    
    %for truncated signals
    figure
    fw
    
    subplot(2,1,1)
    title('Contra to uStim')
    
    
    plot(-500:2500,nanmean(allwf_trunc.contrastim.contra_nostim),'b',-500:2500,nanmean(allwf_trunc.contrastim.ipsi_nostim),'--b')
    axis ij
    xlim([-50 400])
    %y = get(gca,'ylim');
    
    legend('contra targ nostim','ipsi targ nostim')
    
    newax
    plot(-500:2500,nanmean(allwf_trunc.contrastim.contra_stim),'r',-500:2500,nanmean(allwf_trunc.contrastim.ipsi_stim),'--r')
    axis ij
    xlim([-50 400])
    %set(gca,'ylim',y);
    
    legend('contra targ stim','ipsi targ stim')
    
    
    vline(nanmean(allTDT_trunc.contrastim.stim),'r')
    vline(nanmean(allTDT_trunc.contrastim.nostim),'b')
    vline(nanmean(allRT.contrastim.stim),'k')
    vline(nanmean(allRT.contrastim.nostim),'--k')
    
    
    
    
    subplot(2,1,2)
    title('Ipsi to uStim')
    
    plot(-500:2500,nanmean(allwf_trunc.ipsistim.contra_nostim),'b',-500:2500,nanmean(allwf_trunc.ipsistim.ipsi_nostim),'--b')
    axis ij
    xlim([-50 400])
    %y = get(gca,'ylim');
    
    legend('contra targ nostim',' ipsi targ nostim')
    
    
    newax
    plot(-500:2500,nanmean(allwf_trunc.ipsistim.contra_stim),'r',-500:2500,nanmean(allwf_trunc.ipsistim.ipsi_stim),'--r')
    axis ij
    xlim([-50 400])
    %set(gca,'ylim',y)
    
    legend('contra targ stim','ipsi targ stim')
    
    vline(nanmean(allTDT_trunc.ipsistim.stim),'r')
    vline(nanmean(allTDT_trunc.ipsistim.nostim),'b')
    vline(nanmean(allRT.ipsistim.stim),'k')
    vline(nanmean(allRT.ipsistim.nostim),'--k')
    
end
