
plotFlag = 0;
PDFflag = 0;
cd ~/Desktop/Mat_Code/Analyses/Fano/uStim//

[file_name cell_name] = textread('Fano_uStim_S.txt', '%s %s');


q = '''';
c = ',';
qcq = [q c q];

Plot_Time_Targ = [-3500 2500];
Plot_Time_Fix = [-100 3300];

normSDF = 1;

for file = 1:size(file_name,1)
    cd /volumes/Dump/Search_Data_uStim_longBase/
    %================================================================
    %================================================================
    %FOR SPIKES
    eval(['load(' q file_name{file} qcq cell2mat(cell_name(file)) qcq 'MStim_' qcq 'FixTime_Jit_' qcq 'SRT' qcq 'Correct_' qcq 'Errors_' qcq 'Target_' qcq 'newfile' qcq '-mat' q ')'])
    disp([file_name{file} ' ' cell2mat(cell_name(file))])
    Spike = eval(cell_name{file});
    
    
    %compute Fano Factor for uncommonly early and uncommonly late correct responses
    ntiles = prctile(SRT(:,1),[25 75]);
    fast_correct = find(Correct_(:,2) == 1 & SRT(:,1) <= ntiles(1));
    slow_correct = find(Correct_(:,2) == 1 & SRT(:,1) >= ntiles(2));
    
    
    %===========================================
    % Assign relevant trial conditions
    stim = find(~isnan(MStim_(:,1)));
    nostim = find(isnan(MStim_(:,1)));
    
    %===========================================
    
    winsize = 50;
    %winsize = 100;
    time_step = 10;
    
    
    
    %Break apart by length of Fixation period
    ntiles = prctile(FixTime_Jit_,[33 66]);
    
    shortest = find(FixTime_Jit_ <= ntiles(1));
    middle = find(FixTime_Jit_ > ntiles(1) & FixTime_Jit_ <= ntiles(2));
    longest = find(FixTime_Jit_ > ntiles(2));
    
    allTrls = 1:size(Target_,1);
    allTrls_shortest = intersect(allTrls,shortest);
    allTrls_middle = intersect(allTrls,middle);
    allTrls_longest = intersect(allTrls,longest);
    
    stimTrls_all = intersect(allTrls,stim);
    stimTrls_shortest = intersect(stim,shortest);
    stimTrls_middle = intersect(stim,middle);
    stimTrls_longest = intersect(stim,longest);
    
    nostimTrls_all = intersect(allTrls,nostim);
    nostimTrls_shortest = intersect(nostim,shortest);
    nostimTrls_middle = intersect(nostim,middle);
    nostimTrls_longest = intersect(nostim,longest);
    
    
    allACC.all(file,1) = nanmean(Correct_(:,1));
    allACC.all_shortest(file,1) = nanmean(Correct_(allTrls_shortest,2));
    allACC.all_middle(file,1) = nanmean(Correct_(allTrls_middle,2));
    allACC.all_longest(file,1) = nanmean(Correct_(allTrls_longest,2));
    
    allACC.stim_all(file,1) = nanmean(Correct_(stimTrls_all,2));
    allACC.stim_shortest(file,1) = nanmean(Correct_(stimTrls_shortest,2));
    allACC.stim_middle(file,1) = nanmean(Correct_(stimTrls_middle,2));
    allACC.stim_longest(file,1) = nanmean(Correct_(stimTrls_longest,2));
    
    allACC.nostim_all(file,1) = nanmean(Correct_(nostimTrls_all,2));
    allACC.nostim_shortest(file,1) = nanmean(Correct_(nostimTrls_shortest,2));
    allACC.nostim_middle(file,1) = nanmean(Correct_(nostimTrls_middle,2));
    allACC.nostim_longest(file,1) = nanmean(Correct_(nostimTrls_longest,2));

    allRT.all(file,1) = nanmean(SRT(:,1));
    allRT.all_shortest(file,1) = nanmean(SRT(allTrls_shortest,1));
    allRT.all_middle(file,1) = nanmean(SRT(allTrls_middle,1));
    allRT.all_longest(file,1) = nanmean(SRT(allTrls_longest,1));
    
    allRT.stim_all(file,1) = nanmean(SRT(stimTrls_all,1));
    allRT.stim_shortest(file,1) = nanmean(SRT(stimTrls_shortest,1));
    allRT.stim_middle(file,1) = nanmean(SRT(stimTrls_middle,1));
    allRT.stim_longest(file,1) = nanmean(SRT(stimTrls_longest,1));

    allRT.nostim_all(file,1) = nanmean(SRT(nostimTrls_all,1));
    allRT.nostim_shortest(file,1) = nanmean(SRT(nostimTrls_shortest,1));
    allRT.nostim_middle(file,1) = nanmean(SRT(nostimTrls_middle,1));
    allRT.nostim_longest(file,1) = nanmean(SRT(nostimTrls_longest,1));

    
    
      
    
    
    [allFano_targ.all(file,:) real_time_targ allCV2_targ.all(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls);
    [allFano_targ.all_shortest(file,:) ,~, allCV2_targ.all_shortest(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls_shortest);
    [allFano_targ.all_middle(file,:) ,~, allCV2_targ.all_middle(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls_middle);
    [allFano_targ.all_longest(file,:) ,~, allCV2_targ.all_longest(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls_longest);
    
    [allFano_targ.stim_all(file,:) real_time_targ allCV2_targ.stim(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],stimTrls_all);
    [allFano_targ.stim_shortest(file,:) ,~, allCV2_targ.stim_shortest(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],stimTrls_shortest);
    [allFano_targ.stim_middle(file,:) ,~, allCV2_targ.stim_middle(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],stimTrls_middle);
    [allFano_targ.stim_longest(file,:) ,~, allCV2_targ.stim_longest(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],stimTrls_longest);
    
    [allFano_targ.nostim_all(file,:) real_time_targ allCV2_targ.nostim(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],nostimTrls_all);
    [allFano_targ.nostim_shortest(file,:) ,~, allCV2_targ.nostim_shortest(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],nostimTrls_shortest);
    [allFano_targ.nostim_middle(file,:) ,~, allCV2_targ.nostim_middle(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],nostimTrls_middle);
    [allFano_targ.nostim_longest(file,:) ,~, allCV2_targ.nostim_longest(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],nostimTrls_longest);
    
    
    [allFano_fix.all(file,:) real_time_fix allCV2_fix.all(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls);
    [allFano_fix.all_shortest(file,:) ,~, allCV2_fix.all_shortest(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_shortest);
    [allFano_fix.all_middle(file,:) ,~, allCV2_fix.all_middle(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_middle);
    [allFano_fix.all_longest(file,:) ,~, allCV2_fix.all_longest(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_longest);
    
    [allFano_fix.stim_all(file,:) real_time_fix stimCV2_fix.stim(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],stimTrls_all);
    [allFano_fix.stim_shortest(file,:) ,~, stimCV2_fix.stim_shortest(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],stimTrls_shortest);
    [allFano_fix.stim_middle(file,:) ,~, stimCV2_fix.stim_middle(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],stimTrls_middle);
    [allFano_fix.stim_longest(file,:) ,~, stimCV2_fix.stim_longest(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],stimTrls_longest);
    
    
    [allFano_fix.nostim_all(file,:) real_time_fix nostimCV2_fix.nostim(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],nostimTrls_all);
    [allFano_fix.nostim_shortest(file,:) ,~, nostimCV2_fix.nostim_shortest(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],nostimTrls_shortest);
    [allFano_fix.nostim_middle(file,:) ,~, nostimCV2_fix.nostim_middle(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],nostimTrls_middle);
    [allFano_fix.nostim_longest(file,:) ,~, nostimCV2_fix.nostim_longest(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],nostimTrls_longest);
    
    
    
    SDF_targ = sSDF(Spike,Target_(:,1),[Plot_Time_Targ(1) Plot_Time_Targ(2)]);
    SDF_fix = sSDF(Spike,Target_(:,1)-FixTime_Jit_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    
    if normSDF
        SDF_targ = normalize_SP(SDF_targ);
        SDF_fix = normalize_SP(SDF_fix);
        %         SDF_fix_acq = normalize_SP(SDF_fix_acq);
    end
    
    allSDF_targ.all(file,:) = nanmean(SDF_targ);
    allSDF_targ.all_shortest(file,:) = nanmean(SDF_targ(allTrls_shortest,:));
    allSDF_targ.all_middle(file,:) = nanmean(SDF_targ(allTrls_middle,:));
    allSDF_targ.all_longest(file,:) = nanmean(SDF_targ(allTrls_longest,:));
    
    allSDF_targ.stim_all(file,:) = nanmean(SDF_targ(stimTrls_all,:));
    allSDF_targ.stim_shortest(file,:) = nanmean(SDF_targ(stimTrls_shortest,:));
    allSDF_targ.stim_middle(file,:) = nanmean(SDF_targ(stimTrls_middle,:));
    allSDF_targ.stim_longest(file,:) = nanmean(SDF_targ(stimTrls_longest,:));
    
    allSDF_targ.nostim_all(file,:) = nanmean(SDF_targ(nostimTrls_all,:));
    allSDF_targ.nostim_shortest(file,:) = nanmean(SDF_targ(nostimTrls_shortest,:));
    allSDF_targ.nostim_middle(file,:) = nanmean(SDF_targ(nostimTrls_middle,:));
    allSDF_targ.nostim_longest(file,:) = nanmean(SDF_targ(nostimTrls_longest,:));

    
    allSDF_fix.all(file,:) = nanmean(SDF_fix);
    allSDF_fix.all_shortest(file,:) = nanmean(SDF_fix(allTrls_shortest,:));
    allSDF_fix.all_middle(file,:) = nanmean(SDF_fix(allTrls_middle,:));
    allSDF_fix.all_longest(file,:) = nanmean(SDF_fix(allTrls_longest,:));
    
    allSDF_fix.stim_all(file,:) = nanmean(SDF_fix(stimTrls_all,:));
    allSDF_fix.stim_shortest(file,:) = nanmean(SDF_fix(stimTrls_shortest,:));
    allSDF_fix.stim_middle(file,:) = nanmean(SDF_fix(stimTrls_middle,:));
    allSDF_fix.stim_longest(file,:) = nanmean(SDF_fix(stimTrls_longest,:));
    
    allSDF_fix.nostim_all(file,:) = nanmean(SDF_fix(nostimTrls_all,:));
    allSDF_fix.nostim_shortest(file,:) = nanmean(SDF_fix(nostimTrls_shortest,:));
    allSDF_fix.nostim_middle(file,:) = nanmean(SDF_fix(nostimTrls_middle,:));
    allSDF_fix.nostim_longest(file,:) = nanmean(SDF_fix(nostimTrls_longest,:));


    

    %     allSDF_fix_acq.all(file,:) = nanmean(SDF_fix_acq);
    %     allSDF_fix_acq.stim(file,:) = nanmean(SDF_fix_acq(stim,:));
    %     allSDF_fix_acq.nostims(file,:) = nanmean(SDF_fix_acq(nostim,:));
    
    keep all* file file_name cell_name q c qcq real_time* Plot_Time* normSDF
end

%
% figure
% subplot(121)
% plot(real_time_targ,nanmean(allFano.all),'k')
% box off
% title('All trials')
%
% subplot(122)
% plot(real_time_targ,nanmean(allFano.stim),'k',real_time_targ,nanmean(allFano.nostims),'--k')
% box off
% title('stim vs nostims')