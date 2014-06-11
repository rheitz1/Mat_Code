%calculate Fano factor across SAT databases

cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename unit] = textread('Fano_SAT_Q.txt','%s %s');

plotFlag = 0;
plotSess = 0;

normSDF = 1; %normalize SDFs?
cleanSaccSpike = 1; %keep only 1st stretch of time prior to target onset without saccades?

Plot_Time_Targ = [-3500 2500];
Plot_Time_Fix = [-100 3300];

for file = 1:length(filename)
    cd /volumes/Dump/Search_Data_SAT/
    load(filename{file},unit{file},'saccLoc')
    
    cd /volumes/Dump/Search_Data_SAT_longBase/
    
    load(filename{file},unit{file},'EyeX_','EyeY_','saccLoc','Correct_','Target_','SRT','SAT_','Errors_','RFs','newfile','TrialStart_','FixTime_Jit_')
    
    filename{file}
    
    sig = eval(unit{file});
    
    
    %================
    % NOTE: COMPUTING THE SDFS HERE PREVENTS THEM FROM BEING 'CLEANED' WITH REGARDS TO PRESTIM INTERVAL,
    % AS BELOW FOR FANO FACTOR
    SDF = sSDF(sig,Target_(:,1),[Plot_Time_Targ(1) Plot_Time_Targ(2)]);
    %     SDF_clean = SDF;
    SDF_Fix = sSDF(sig,Target_(:,1)-FixTime_Jit_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    
    
    [~,cutoff] = cleanPreStimInterval(sig);
    SDF_FixAcq = sSDF(sig,Target_(:,1)+cutoff,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    %======================
    
    if normSDF
        SDF = normalize_SP(SDF);
        SDF_Fix = normalize_SP(SDF_Fix);
        SDF_FixAcq = normalize_SP(SDF_FixAcq);
    end
    
    
    
    %     if cleanSaccSpike
    %         load(filename{file},unit{file},'EyeX_','EyeY_')
    %         SDF_clean = cleanPreStimInterval(SDF); %Because this is a 6001 ms long signal, the function will treat it as continuous and clean it accordingly
    %         sig = cleanPreStimInterval(sig);
    %     end
    
    %     RF = RFs.(unit{file});
    %
    %     antiRF = mod((RF+4),8);
    
    
    
    
    
    %============
    % FIND TRIALS
    %============
    
    getTrials_SAT
    
    %     inTrls = find(ismember(Target_(:,2),RF));
    %     outTrls = find(ismember(Target_(:,2),antiRF));
    %
    %     in.slow.correct = intersect(slow_correct_made_dead,inTrls);
    %     in.med.correct = intersect(med_correct,inTrls);
    %     in.fast.correct = intersect(fast_correct_made_dead_withCleared,inTrls);
    %
    %     out.slow.correct = intersect(slow_correct_made_dead,outTrls);
    %     out.med.correct = intersect(med_correct,outTrls);
    %     out.fast.correct = intersect(fast_correct_made_dead_withCleared,outTrls);
    %
    %     in.slow.error = intersect(slow_errors_made_dead,find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF)));
    %     in.med.error = intersect(med_errors,find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF)));
    %     in.fast.error = intersect(fast_errors_made_dead_withCleared,find(ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF)));
    %
    %     out.slow.error = intersect(slow_errors_made_dead,find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF)));
    %     out.med.error = intersect(med_errors,find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF)));
    %     out.fast.error = intersect(fast_errors_made_dead_withCleared,find(ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF)));
    
    
    %============
    % CALC FANO
    %============
    
    %calculate real_time only on the first instance because of a problem file. Don't want to remove the
    %problem file from the main file list for reproduction purposes...
    
    winsize = 50;
    %winsize = 100;
    time_step = 10;
    
    %     if file == 1
    %         [~,real_time] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],in.slow.correct);
    %     else
    %         %[Fano_targ.in.slow.correct] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],in.slow.correct);
    %     end
    
    %     [Fano_targ.in.med.correct] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],in.med.correct);
    %     [Fano_targ.in.fast.correct] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],in.fast.correct);
    %
    %     [Fano_targ.out.slow.correct] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],out.slow.correct);
    %     [Fano_targ.out.med.correct] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],out.med.correct);
    %     [Fano_targ.out.fast.correct] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],out.fast.correct);
    %
    %     [Fano_targ.in.slow.error] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],in.slow.error);
    %     [Fano_targ.in.med.error] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],in.med.error);
    %     [Fano_targ.in.fast.error] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],in.fast.error);
    %
    %     [Fano_targ.out.slow.error] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],out.slow.error);
    %     [Fano_targ.out.med.error] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],out.med.error);
    %     [Fano_targ.out.fast.error] = getFano_targ(sig,winsize,time_step,[Plot_Time(1) Plot_Time(2)],out.fast.error);
    
    
    %Break apart by length of Fixation period
    ntiles = prctile(FixTime_Jit_,[33 66]);
    
    shortest = find(FixTime_Jit_ <= ntiles(1));
    middle = find(FixTime_Jit_ > ntiles(1) & FixTime_Jit_ <= ntiles(2));
    longest = find(FixTime_Jit_ > ntiles(2));
    
    % Aligned to Target onset
    [Fano_targ.all,real_time_targ] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],1:size(sig,1));
    Fano_targ.all_shortest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],shortest);
    Fano_targ.all_middle = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],middle);
    Fano_targ.all_longest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],longest);
    
    Fano_targ.slow = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],slow_all);
    Fano_targ.slow_shortest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,slow_all));
    Fano_targ.slow_middle = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,slow_all));
    Fano_targ.slow_longest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,slow_all));
    
    %Fano_targ.med = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],med_all);
    Fano_targ.fast = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],fast_all_withCleared);
    Fano_targ.fast_shortest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,fast_all_withCleared));
    Fano_targ.fast_middle = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,fast_all_withCleared));
    Fano_targ.fast_longest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,fast_all_withCleared));
    
    
    % Aligned to fixation hold time
    [Fano_fix.all real_time_fix] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],1:size(sig,1));
    Fano_fix.all_shortest = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],shortest);
    Fano_fix.all_middle = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],middle);
    Fano_fix.all_longest = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],longest);
    
    
    Fano_fix.slow = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slow_all);
    Fano_fix.slow_shortest = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all,shortest));
    Fano_fix.slow_middle = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all,middle));
    Fano_fix.slow_longest = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all,longest));
    
    Fano_fix.fast = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fast_all_withCleared);
    Fano_fix.fast_shortest = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_withCleared,shortest));
    Fano_fix.fast_middle = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_withCleared,middle));
    Fano_fix.fast_longest = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_withCleared,longest));
    
    
    
    
    % Aligned to estimated fixation acquire time
    [Fano_fix_acq.all real_time_fix] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],1:size(sig,1));
    Fano_fix_acq.all_shortest = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],shortest);
    Fano_fix_acq.all_middle = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],middle);
    Fano_fix_acq.all_longest = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],longest);
    
    
    Fano_fix_acq.slow = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slow_all);
    Fano_fix_acq.slow_shortest = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all,shortest));
    Fano_fix_acq.slow_middle = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all,middle));
    Fano_fix_acq.slow_longest = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all,longest));
    
    Fano_fix_acq.fast = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fast_all_withCleared);
    Fano_fix_acq.fast_shortest = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_withCleared,shortest));
    Fano_fix_acq.fast_middle = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_withCleared,middle));
    Fano_fix_acq.fast_longest = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_withCleared,longest));
    
    
    %===================
    % KEEP RECORD OF SDF
    %===================
    
    %     allSDF_targ.in.slow.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.slow.correct,:));
    %     allSDF_targ.in.med.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.med.correct,:));
    %     allSDF_targ.in.fast.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.fast.correct,:));
    %
    %     allSDF_targ.out.slow.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.slow.correct,:));
    %     allSDF_targ.out.med.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.med.correct,:));
    %     allSDF_targ.out.fast.correct(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.fast.correct,:));
    %
    %     allSDF_targ.in.slow.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.slow.error,:));
    %     allSDF_targ.in.med.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.med.error,:));
    %     allSDF_targ.in.fast.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(in.fast.error,:));
    %
    %     allSDF_targ.out.slow.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.slow.error,:));
    %     allSDF_targ.out.med.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.med.error,:));
    %     allSDF_targ.out.fast.error(file,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(SDF(out.fast.error,:));
    %
    
    allSDF_targ.all(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF);
    
    allSDF_targ.slow(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(slow_all,:));
    allSDF_targ.slow_shortest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(shortest,slow_all),:));
    allSDF_targ.slow_middle(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(middle,slow_all),:));
    allSDF_targ.slow_longest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(longest,slow_all),:));
    
    %allSDF_targ.med(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(med_all,:));
    allSDF_targ.fast(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(fast_all_withCleared,:));
    allSDF_targ.fast_shortest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(shortest,fast_all_withCleared),:));
    allSDF_targ.fast_middle(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(middle,fast_all_withCleared),:));
    allSDF_targ.fast_longest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(longest,fast_all_withCleared),:));
    
    %also break SDFs by length of Fixation Period
    allSDF_fix.all(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix);
    allSDF_fix.shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(shortest,:));
    allSDF_fix.middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(middle,:));
    allSDF_fix.longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(longest,:));
    
    allSDF_fix.slow(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(slow_all,:));
    allSDF_fix.slow_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(slow_all,shortest),:));
    allSDF_fix.slow_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(slow_all,middle),:));
    allSDF_fix.slow_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(slow_all,longest),:));
    
    allSDF_fix.fast(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(fast_all_withCleared,:));
    allSDF_fix.fast_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(fast_all_withCleared,shortest),:));
    allSDF_fix.fast_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(fast_all_withCleared,middle),:));
    allSDF_fix.fast_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(fast_all_withCleared,longest),:));
    
    
    
    % aligned to estimated fixation acquire time
    allSDF_fix_acq.all(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq);
    allSDF_fix_acq.shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(shortest,:));
    allSDF_fix_acq.middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(middle,:));
    allSDF_fix_acq.longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(longest,:));
    
    allSDF_fix_acq.slow(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(slow_all,:));
    allSDF_fix_acq.slow_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(slow_all,shortest),:));
    allSDF_fix_acq.slow_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(slow_all,middle),:));
    allSDF_fix_acq.slow_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(slow_all,longest),:));
    
    allSDF_fix_acq.fast(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(fast_all_withCleared,:));
    allSDF_fix_acq.fast_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(fast_all_withCleared,shortest),:));
    allSDF_fix_acq.fast_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(fast_all_withCleared,middle),:));
    allSDF_fix_acq.fast_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(fast_all_withCleared,longest),:));
    
    
    %===================allS============
    % KEEP RECORD OF ALL FANO FACTOR
    %===============================
    %
    %     allFano_targ.in.slow.correct(file,1:length(real_time)) = Fano_targ.in.slow.correct;
    %     allFano_targ.in.med.correct(file,1:length(real_time)) = Fano_targ.in.med.correct;
    %     allFano_targ.in.fast.correct(file,1:length(real_time)) = Fano_targ.in.fast.correct;
    %
    %     allFano_targ.out.slow.correct(file,1:length(real_time)) = Fano_targ.out.slow.correct;
    %     allFano_targ.out.med.correct(file,1:length(real_time)) = Fano_targ.out.med.correct;
    %     allFano_targ.out.fast.correct(file,1:length(real_time)) = Fano_targ.out.fast.correct;
    %
    %     allFano_targ.in.slow.error(file,1:length(real_time)) = Fano_targ.in.slow.error;
    %     allFano_targ.in.med.error(file,1:length(real_time)) = Fano_targ.in.med.error;
    %     allFano_targ.in.fast.error(file,1:length(real_time)) = Fano_targ.in.fast.error;
    %
    %     allFano_targ.out.slow.error(file,1:length(real_time)) = Fano_targ.out.slow.error;
    %     allFano_targ.out.med.error(file,1:length(real_time)) = Fano_targ.out.med.error;
    %     allFano_targ.out.fast.error(file,1:length(real_time)) = Fano_targ.out.fast.error;
    allFano_targ.all(file,1:length(real_time_targ)) = Fano_targ.all;
    allFano_targ.slow(file,1:length(real_time_targ)) = Fano_targ.slow;
    allFano_targ.slow_shortest(file,1:length(real_time_targ)) = Fano_targ.slow_shortest;
    allFano_targ.slow_middle(file,1:length(real_time_targ)) = Fano_targ.slow_middle;
    allFano_targ.slow_longest(file,1:length(real_time_targ)) = Fano_targ.slow_longest;
    
    %allFano_targ.med(file,1:length(real_time_targ)) = Fano_targ.med;
    allFano_targ.fast(file,1:length(real_time_targ)) = Fano_targ.fast;
    allFano_targ.fast_shortest(file,1:length(real_time_targ)) = Fano_targ.fast_shortest;
    allFano_targ.fast_middle(file,1:length(real_time_targ)) = Fano_targ.fast_middle;
    allFano_targ.fast_longest(file,1:length(real_time_targ)) = Fano_targ.fast_longest;
    
    allFano_fix.all(file,1:length(real_time_fix)) = Fano_fix.all;
    allFano_fix.all_shortest(file,1:length(real_time_fix)) = Fano_fix.all_shortest;
    allFano_fix.all_middle(file,1:length(real_time_fix)) = Fano_fix.all_middle;
    allFano_fix.all_longest(file,1:length(real_time_fix)) = Fano_fix.all_longest;
    
    allFano_fix.slow(file,1:length(real_time_fix)) = Fano_fix.slow;
    allFano_fix.slow_shortest(file,1:length(real_time_fix)) = Fano_fix.slow_shortest;
    allFano_fix.slow_middle(file,1:length(real_time_fix)) = Fano_fix.slow_middle;
    allFano_fix.slow_longest(file,1:length(real_time_fix)) = Fano_fix.slow_longest;
    
    allFano_fix.fast(file,1:length(real_time_fix)) = Fano_fix.fast;
    allFano_fix.fast_shortest(file,1:length(real_time_fix)) = Fano_fix.fast_shortest;
    allFano_fix.fast_middle(file,1:length(real_time_fix)) = Fano_fix.fast_middle;
    allFano_fix.fast_longest(file,1:length(real_time_fix)) = Fano_fix.fast_longest;
    
    
    allFano_fix_acq.all(file,1:length(real_time_fix)) = Fano_fix_acq.all;
    allFano_fix_acq.all_shortest(file,1:length(real_time_fix)) = Fano_fix_acq.all_shortest;
    allFano_fix_acq.all_middle(file,1:length(real_time_fix)) = Fano_fix_acq.all_middle;
    allFano_fix_acq.all_longest(file,1:length(real_time_fix)) = Fano_fix_acq.all_longest;
    
    allFano_fix_acq.slow(file,1:length(real_time_fix)) = Fano_fix_acq.slow;
    allFano_fix_acq.slow_shortest(file,1:length(real_time_fix)) = Fano_fix_acq.slow_shortest;
    allFano_fix_acq.slow_middle(file,1:length(real_time_fix)) = Fano_fix_acq.slow_middle;
    allFano_fix_acq.slow_longest(file,1:length(real_time_fix)) = Fano_fix_acq.slow_longest;
    
    allFano_fix_acq.fast(file,1:length(real_time_fix)) = Fano_fix_acq.fast;
    allFano_fix_acq.fast_shortest(file,1:length(real_time_fix)) = Fano_fix_acq.fast_shortest;
    allFano_fix_acq.fast_middle(file,1:length(real_time_fix)) = Fano_fix_acq.fast_middle;
    allFano_fix_acq.fast_longest(file,1:length(real_time_fix)) = Fano_fix_acq.fast_longest;
    
    
    if plotSess
        subplot(121)
        plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(SDF(slow_all,:)),'r',Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(SDF(fast_all_withCleared,:)),'g')
        box off
        
        title(['# ' mat2str(file)],'fontsize',20,'fontweight','bold')
        
        subplot(122)
        plot(real_time_targ,Fano_targ.slow,'r',real_time_targ,Fano_targ.fast,'g')
        box off
        
        title([filename{file} '  ' unit{file}],'fontsize',20,'fontweight','bold')
        
        pause
        cla
        subplot(121)
        cla
    end
    
    keep filename unit file all* real_time plotSess Plot_Time* real_time* normSDF cleanSaccSpike plotFlag
    
end

if plotFlag
    subplot(121)
    plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDF_targ.slow),'r',Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDF_targ.fast),'g')
    box off
    
    subplot(122)
    plot(real_time_targ,nanmean(allFano_targ.slow),'r',real_time_targ,nanmean(allFano_targ.fast),'g')
    box off
end
