%Plots all signals, correct and error trials, one by one and asks for user
%input as to whether you want to use it or not.  If yes, the plot is saved.

cd '/volumes/Dump/Search_Data/'

batch_list = dir('*SEARCH.mat');

for i = 1:length(batch_list)
    
    batch_list(i).name
    
    try
        load(batch_list(i).name,'AD02','AD03')
    catch
        disp('Error loading channels, continuing...')
        continue
    end
    
    
    load(batch_list(i).name,'Correct_','Target_','EyeX_','EyeY_','SRT','Errors_','TrialStart_','newfile')
    
    
    %get saccade metrics including saccade location (do not check for
    %Translate-encoded SaccDir_, due to some question about its accuracy.
    srt
    
    %fix 'Errors_' variable for old files
    fixErrors
    
    
    OL = AD03;
    OR = AD02;
    
    %baseline correct
    OL = baseline_correct(OL,[400 500]);
    OR = baseline_correct(OR,[400 500]);
    
    %truncate 5 ms before saccade
    OL_trunc = truncateAD_targ(OL,SRT,20);
    OR_trunc = truncateAD_targ(OR,SRT,20);
    
    contraCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    contraErrorOL = find(~isnan(OL(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & ismember(saccLoc,[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiErrorOL = find(~isnan(OL(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & ismember(saccLoc,[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraErrorOR = find(~isnan(OR(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & ismember(saccLoc,[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiErrorOR = find(~isnan(OR(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & ismember(saccLoc,[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    N2pc_TDT_OL.correct_notrunc = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL);
    N2pc_TDT_OR.correct_notrunc = getTDT_AD(OR,contraCorrectOR,ipsiCorrectOR);
    N2pc_TDT_OL.error_notrunc = getTDT_AD(OL,contraErrorOL,ipsiErrorOL);
    N2pc_TDT_OR.error_notrunc = getTDT_AD(OR,contraErrorOR,ipsiErrorOR);
    
    N2pc_TDT_OL.correct_trunc = getTDT_AD(OL_trunc,contraCorrectOL,ipsiCorrectOL);
    N2pc_TDT_OR.correct_trunc = getTDT_AD(OR_trunc,contraCorrectOR,ipsiCorrectOR);
    N2pc_TDT_OL.error_trunc = getTDT_AD(OL_trunc,contraErrorOL,ipsiErrorOL);
    N2pc_TDT_OR.error_trunc = getTDT_AD(OR_trunc,contraErrorOR,ipsiErrorOR);
    
    
    h = figure;
    set(gcf,'color','white')
    
    subplot(1,2,1)
    plot(-500:2500,nanmean(OL(contraCorrectOL,:)),'b',-500:2500,nanmean(OL(ipsiCorrectOL,:)),'--b',-500:2500,nanmean(OL(contraErrorOL,:)),'r',-500:2500,nanmean(OL(ipsiErrorOL,:)),'--r')
    axis ij
    xlim([-50 300])
    vline(N2pc_TDT_OL.correct_notrunc,'b')
    vline(N2pc_TDT_OL.error_notrunc,'r')
    title(['OL No Trunc  TDTc = ' mat2str(N2pc_TDT_OL.correct_notrunc) ' TDTe = ' mat2str(N2pc_TDT_OL.error_notrunc)])
    
    subplot(1,2,2)
    plot(-500:2500,nanmean(OL_trunc(contraCorrectOL,:)),'b',-500:2500,nanmean(OL_trunc(ipsiCorrectOL,:)),'--b',-500:2500,nanmean(OL_trunc(contraErrorOL,:)),'r',-500:2500,nanmean(OL_trunc(ipsiErrorOL,:)),'--r')
    axis ij
    xlim([-50 300])
    vline(N2pc_TDT_OL.correct_trunc,'b')
    vline(N2pc_TDT_OL.error_trunc,'r')
    title(['OL Trunc  TDTc = ' mat2str(N2pc_TDT_OL.correct_trunc) ' TDTe = ' mat2str(N2pc_TDT_OL.error_trunc)])
    
    keeper = input('Keep? ');
    
    if keeper == 1
        eval(['print -dpdf /volumes/Dump/Analyses/Errors/find_keeper_error_n2pc/PDF/ ' mat2str(batch_list(i).name) 'AD03.pdf'])
    end
    
    
    
    close(h)
    
    h = figure;
    set(gcf,'color','white')
   
    
    subplot(1,2,1)
    plot(-500:2500,nanmean(OR(contraCorrectOR,:)),'b',-500:2500,nanmean(OR(ipsiCorrectOL,:)),'--b',-500:2500,nanmean(OR(contraErrorOL,:)),'r',-500:2500,nanmean(OR(ipsiErrorOL,:)),'--r')
    axis ij
    xlim([-50 300])
    vline(N2pc_TDT_OR.correct_notrunc,'b')
    vline(N2pc_TDT_OR.error_notrunc,'r')
    title(['OR No Trunc  TDTc = ' mat2str(N2pc_TDT_OR.correct_notrunc) ' TDTe = ' mat2str(N2pc_TDT_OR.error_notrunc)])
    
    
    
    
    subplot(1,2,2)
    plot(-500:2500,nanmean(OR_trunc(contraCorrectOR,:)),'b',-500:2500,nanmean(OR_trunc(ipsiCorrectOL,:)),'--b',-500:2500,nanmean(OR_trunc(contraErrorOL,:)),'r',-500:2500,nanmean(OR_trunc(ipsiErrorOL,:)),'--r')
    axis ij
    xlim([-50 300])
    vline(N2pc_TDT_OR.correct_trunc,'b')
    vline(N2pc_TDT_OR.error_trunc,'r')
    title(['OR Trunc  TDTc = ' mat2str(N2pc_TDT_OR.correct_trunc) ' TDTe = ' mat2str(N2pc_TDT_OR.error_trunc)])
    
    keeper = input('Keep? ');
    
    if keeper == 1
        eval(['print -dpdf /volumes/Dump/Analyses/Errors/find_keeper_error_n2pc/PDF/ ' mat2str(batch_list(i).name) 'AD02.pdf'])
    end
    
    close(h)
    
    keep batch_list i
    
end