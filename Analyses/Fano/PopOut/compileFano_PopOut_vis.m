
plotFlag = 0;
PDFflag = 0;
cd ~/Desktop/Mat_Code/Analyses/Fano/PopOut/

[file_name cell_name] = textread('Fano_PopOut_SEF_F.txt', '%s %s');


q = '''';
c = ',';
qcq = [q c q];

Plot_Time_Targ = [-3500 2500];
Plot_Time_Fix = [-100 3300];

normSDF = 1;

for file = 1:size(file_name,1)
    cd /volumes/Dump/Search_Data_PopOut_SEF_longBase/
    %================================================================
    %================================================================
    %FOR SPIKES
    eval(['load(' q file_name{file} qcq cell2mat(cell_name(file)) qcq 'FixTime_Jit_' qcq 'SRT' qcq 'Correct_' qcq 'Errors_' qcq 'Target_' qcq 'newfile' qcq '-mat' q ')'])
    disp([file_name{file} ' ' cell2mat(cell_name(file))])
    Spike = eval(cell_name{file});
    
    
    %compute Fano Factor for uncommonly early and uncommonly late correct responses
    ntiles = prctile(SRT(:,1),[25 75]);
    fast_correct = find(Correct_(:,2) == 1 & SRT(:,1) <= ntiles(1));
    slow_correct = find(Correct_(:,2) == 1 & SRT(:,1) >= ntiles(2));
    
    
    %===========================================
    % Assign relevant trial conditions
%     crt = find(Correct_(:,2) == 1);
%     err = find(Correct_(:,2) == 0);
    
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
    
%     
%     correctTrls_shortest = intersect(crt,shortest);
%     correctTrls_middle = intersect(crt,middle);
%     correctTrls_longest = intersect(crt,longest);
%     
%     errorTrls_shortest = intersect(err,shortest);
%     errorTrls_middle = intersect(err,middle);
%     errorTrls_longest = intersect(err,longest);
    
    allACC.all_shortest(file,1) = nanmean(Correct_(allTrls_shortest,2));
    allACC.all_middle(file,1) = nanmean(Correct_(allTrls_middle,2));
    allACC.all_longest(file,1) = nanmean(Correct_(allTrls_longest,2));
    
    allRT.all_shortest(file,1) = nanmean(SRT(allTrls_shortest,1));
    allRT.all_middle(file,1) = nanmean(SRT(allTrls_middle,1));
    allRT.all_longest(file,1) = nanmean(SRT(allTrls_longest,1));
    
%     allRT.correct_shortest(file,1) = nanmean(SRT(intersect(allTrls_shortest,crt),1));
%     allRT.correct_middle(file,1) = nanmean(SRT(intersect(allTrls_middle,crt),1));
%     allRT.correct_longest(file,1) = nanmean(SRT(intersect(allTrls_longest,crt),1));
%     
%     allRT.err_shortest(file,1) = nanmean(SRT(intersect(allTrls_shortest,err),1));
%     allRT.err_middle(file,1) = nanmean(SRT(intersect(allTrls_middle,err),1));
%     allRT.err_longest(file,1) = nanmean(SRT(intersect(allTrls_longest,err),1));
%     
    
    
    
    [allFano_targ.all(file,:) real_time_targ allCV2_targ.all(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls);
    [allFano_targ.all_shortest(file,:) ,~, allCV2_targ.all_shortest(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls_shortest);
    [allFano_targ.all_middle(file,:) ,~, allCV2_targ.all_middle(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls_middle);
    [allFano_targ.all_longest(file,:) ,~, allCV2_targ.all_longest(file,:)] = getFano_targ(Spike,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls_longest);
    
    [allFano_fix.all(file,:) real_time_fix allCV2_fix.all(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls);
    [allFano_fix.all_shortest(file,:) ,~, allCV2_fix.all_shortest(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_shortest);
    [allFano_fix.all_middle(file,:) ,~, allCV2_fix.all_middle(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_middle);
    [allFano_fix.all_longest(file,:) ,~, allCV2_fix.all_longest(file,:)] = getFano_fix(Spike,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_longest);

    
    %     allFano_fix_acq.all(file,1:length(real_time_fix)) = Fano_fix_acq.all;
    %     allFano_fix_acq.correct(file,1:length(real_time_fix)) = Fano_fix_acq.correct;
    %     allFano_fix_acq.errors(file,1:length(real_time_fix)) = Fano_fix_acq.errors;
    %
    %
    SDF_targ = sSDF(Spike,Target_(:,1),[Plot_Time_Targ(1) Plot_Time_Targ(2)]);
    SDF_fix = sSDF(Spike,Target_(:,1)-FixTime_Jit_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    %
    %     [~,cutoff] = cleanPreStimInterval(sig);
    %     SDF_fix_acq = sSDF(sig,Target_(:,1)+cutoff,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    %
    %
    if normSDF
        SDF_targ = normalize_SP(SDF_targ);
        SDF_fix = normalize_SP(SDF_fix);
        %         SDF_fix_acq = normalize_SP(SDF_fix_acq);
    end
    
    allSDF_targ.all(file,:) = nanmean(SDF_targ);
    allSDF_targ.all_shortest(file,:) = nanmean(SDF_targ(allTrls_shortest,:));
    allSDF_targ.all_middle(file,:) = nanmean(SDF_targ(allTrls_middle,:));
    allSDF_targ.all_longest(file,:) = nanmean(SDF_targ(allTrls_longest,:));
    
    allSDF_fix.all(file,:) = nanmean(SDF_fix);
    allSDF_fix.all_shortest(file,:) = nanmean(SDF_fix(allTrls_shortest,:));
    allSDF_fix.all_middle(file,:) = nanmean(SDF_fix(allTrls_middle,:));
    allSDF_fix.all_longest(file,:) = nanmean(SDF_fix(allTrls_longest,:));
    

    %     allSDF_fix_acq.all(file,:) = nanmean(SDF_fix_acq);
    %     allSDF_fix_acq.correct(file,:) = nanmean(SDF_fix_acq(crt,:));
    %     allSDF_fix_acq.errors(file,:) = nanmean(SDF_fix_acq(err,:));
    
    keep all* file file_name cell_name q c qcq real_time_targ real_time_fix Plot_Time* normSDF
end

%
% figure
% subplot(121)
% plot(real_time_targ,nanmean(allFano.all),'k')
% box off
% title('All trials')
%
% subplot(122)
% plot(real_time_targ,nanmean(allFano.correct),'k',real_time_targ,nanmean(allFano.errors),'--k')
% box off
% title('Correct vs Errors')
