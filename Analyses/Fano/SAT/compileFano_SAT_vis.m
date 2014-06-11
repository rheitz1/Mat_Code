%calculate Fano factor across SAT databases

cd ~/desktop/Mat_Code/Analyses/Fano/SAT_FEF_SEF/
%[filename unit] = textread('Fano_SAT_FEF_Q.txt','%s %s');

% [filename1 unit1] = textread('SAT2_SC_Vis_NoMed_D.txt','%s %s');
% [filename2 unit2] = textread('SAT2_SC_VisMove_NoMed_D.txt','%s %s');
% [filename3 unit3] = textread('SAT2_SC_Vis_NoMed_E.txt','%s %s');
% [filename4 unit4] = textread('SAT2_SC_VisMove_NoMed_E.txt','%s %s');
%
% filename = [filename1 ; filename2 ; filename3 ; filename4];
% unit = [unit1 ; unit2 ; unit3 ; unit4];

[filename1 unit1] = textread('Fano_SAT_Q_notTaskRelated.txt','%s %s');
[filename2 unit2] = textread('Fano_SAT_S_notTaskRelated.txt','%s %s');

filename = [filename1 ; filename2];
unit = [unit1 ; unit2];

plotFlag = 1;
plotSess = 0;

normSDF = 1; %normalize SDFs?
cleanSaccSpike = 0; %keep only 1st stretch of time prior to target onset without saccades?

Plot_Time_Targ = [-3500 2500];
Plot_Time_Fix = [-100 3300];

for file = 1:length(filename)
    cd /volumes/Dump/Search_Data_SAT_longBase/
    load(filename{file},unit{file},'saccLoc')
    
    cd /volumes/Dump/Search_Data_SAT_longBase/
    
    load(filename{file},unit{file},'EyeX_','EyeY_','saccLoc','Correct_','Target_','SRT','SAT_','Errors_','RFs','newfile','TrialStart_','FixTime_Jit_')
    
    FixAcqPresent = 1;
    try
        load(filename{file},'FixAcqTime_')
    catch
        FixAcqPresent = 0;
        disp('No FixAcqTime Detected')
    end
    
    filename{file}
    
    sig = eval(unit{file});
    
    
    %================
    % NOTE: COMPUTING THE SDFS HERE PREVENTS THEM FROM BEING 'CLEANED' WITH REGARDS TO PRESTIM INTERVAL,
    % AS BELOW FOR FANO FACTOR
    SDF = sSDF(sig,Target_(:,1),[Plot_Time_Targ(1) Plot_Time_Targ(2)]);
    %     SDF_clean = SDF;
    SDF_Fix = sSDF(sig,Target_(:,1)-FixTime_Jit_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    
    
    if FixAcqPresent
        SDF_FixAcq = sSDF(sig,Target_(:,1)+ FixAcqTime_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    end
    
    % [~,cutoff] = cleanPreStimInterval(sig);
    % SDF_FixAcq = sSDF(sig,Target_(:,1)+cutoff,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    %======================
    
    if normSDF
        SDF = normalize_SP(SDF);
        SDF_Fix = normalize_SP(SDF_Fix);
        
        if FixAcqPresent
            SDF_FixAcq = normalize_SP(SDF_FixAcq);
        end
        %   SDF_FixAcq = normalize_SP(SDF_FixAcq);
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
    
    
    %============
    % CALC FANO
    %============
    
    %calculate real_time only on the first instance because of a problem file. Don't want to remove the
    %problem file from the main file list for reproduction purposes...
    
    winsize = 50;
    %winsize = 100;
    time_step = 10;
    
    
    
    %Break apart by length of Fixation period
    ntiles = prctile(FixTime_Jit_,[33 66]);
    
    shortest = find(FixTime_Jit_ <= ntiles(1));
    middle = find(FixTime_Jit_ > ntiles(1) & FixTime_Jit_ <= ntiles(2));
    longest = find(FixTime_Jit_ > ntiles(2));
    
    allTrls = [slow_all_made_dead ; med_all ; fast_all_made_dead_withCleared];
    allTrls_shortest = intersect(allTrls,shortest);
    allTrls_middle = intersect(allTrls,middle);
    allTrls_longest = intersect(allTrls,longest);
    
    
    slowTrls_shortest = intersect(slow_all_made_dead,shortest);
    slowTrls_middle = intersect(slow_all_made_dead,middle);
    slowTrls_longest = intersect(slow_all_made_dead,longest);
    
    fastTrls_shortest = intersect(fast_all_made_dead_withCleared,shortest);
    fastTrls_middle = intersect(fast_all_made_dead_withCleared,middle);
    fastTrls_longest = intersect(fast_all_made_dead_withCleared,longest);
    
    allACC.all_shortest(file,1) = nanmean(Correct_(allTrls_shortest,2));
    allACC.all_middle(file,1) = nanmean(Correct_(allTrls_middle,2));
    allACC.all_longest(file,1) = nanmean(Correct_(allTrls_longest,2));
    
    allACC.slow_shortest(file,1) = nanmean(Correct_(slowTrls_shortest,2));
    allACC.slow_middle(file,1) = nanmean(Correct_(slowTrls_middle,2));
    allACC.slow_longest(file,1) = nanmean(Correct_(slowTrls_longest,2));
    
    allACC.fast_shortest(file,1) = nanmean(Correct_(fastTrls_shortest,2));
    allACC.fast_middle(file,1) = nanmean(Correct_(fastTrls_middle,2));
    allACC.fast_longest(file,1) = nanmean(Correct_(fastTrls_longest,2));
    
    
    allRT.all_shortest(file,1) = nanmean(SRT(allTrls_shortest,1));
    allRT.all_middle(file,1) = nanmean(SRT(allTrls_middle,1));
    allRT.all_longest(file,1) = nanmean(SRT(allTrls_longest,1));
    
    allRT.slow_shortest(file,1) = nanmean(SRT(slowTrls_shortest,1));
    allRT.slow_middle(file,1) = nanmean(SRT(slowTrls_middle,1));
    allRT.slow_longest(file,1) = nanmean(SRT(slowTrls_longest,1));
    
    allRT.fast_shortest(file,1) = nanmean(SRT(fastTrls_shortest,1));
    allRT.fast_middle(file,1) = nanmean(SRT(fastTrls_middle,1));
    allRT.fast_longest(file,1) = nanmean(SRT(fastTrls_longest,1));
    
    
    %=============================================
    %=============================================
    % MADE DEADLINES
    %=============================================
    %=============================================
    
    
    % Aligned to Target onset
    [Fano_targ_made_dead.all,real_time_targ,CV2_targ_made_dead.all] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],[slow_all_made_dead ; fast_all_made_dead_withCleared]);
    [Fano_targ_made_dead.all_shortest,~,CV2_targ_made_dead.all_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
    [Fano_targ_made_dead.all_middle,~,CV2_targ_made_dead.all_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
    [Fano_targ_made_dead.all_longest,~,CV2_targ_made_dead.all_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
    
    [Fano_targ_made_dead.slow,~,CV2_targ_made_dead.slow] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],slow_all_made_dead);
    [Fano_targ_made_dead.slow_shortest,~,CV2_targ_made_dead.slow_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,slow_all_made_dead));
    [Fano_targ_made_dead.slow_middle,~,CV2_targ_made_dead.slow_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,slow_all_made_dead));
    [Fano_targ_made_dead.slow_longest,~,CV2_targ_made_dead.slow_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,slow_all_made_dead));
    
    %Fano_targ_made_dead.med = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],med_all);
    [Fano_targ_made_dead.fast,~,CV2_targ_made_dead.fast] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],fast_all_made_dead_withCleared);
    [Fano_targ_made_dead.fast_shortest,~,CV2_targ_made_dead.fast_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,fast_all_made_dead_withCleared));
    [Fano_targ_made_dead.fast_middle,~,CV2_targ_made_dead.fast_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,fast_all_made_dead_withCleared));
    [Fano_targ_made_dead.fast_longest,~,CV2_targ_made_dead.fast_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,fast_all_made_dead_withCleared));
    
    
    % Aligned to fixation hold time
    [Fano_fix_made_dead.all,real_time_fix,CV2_fix_made_dead.all] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],[slow_all_made_dead ; fast_all_made_dead_withCleared]);
    [Fano_fix_made_dead.all_shortest,~,CV2_fix_made_dead.all_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(shortest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
    [Fano_fix_made_dead.all_middle,~,CV2_fix_made_dead.all_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(middle,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
    [Fano_fix_made_dead.all_longest,~,CV2_fix_made_dead.all_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(longest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
    
    
    [Fano_fix_made_dead.slow,~,CV2_fix_made_dead.slow] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slow_all_made_dead);
    [Fano_fix_made_dead.slow_shortest,~,CV2_fix_made_dead.slow_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,shortest));
    [Fano_fix_made_dead.slow_middle,~,CV2_fix_made_dead.slow_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,middle));
    [Fano_fix_made_dead.slow_longest,~,CV2_fix_made_dead.slow_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,longest));
    
    [Fano_fix_made_dead.fast,~,CV2_fix_made_dead.fast] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fast_all_made_dead_withCleared);
    [Fano_fix_made_dead.fast_shortest,~,CV2_fix_made_dead.fast_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,shortest));
    [Fano_fix_made_dead.fast_middle,~,CV2_fix_made_dead.fast_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,middle));
    [Fano_fix_made_dead.fast_longest,~,CV2_fix_made_dead.fast_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,longest));
    
    
    if FixAcqPresent
        [Fano_FixAcq_made_dead.all,real_time_fix,CV2_fixAcq_made_dead.all] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],[slow_all_made_dead ; fast_all_made_dead_withCleared]);
        [Fano_FixAcq_made_dead.all_shortest,~,CV2_fixAcq_made_dead.all_shortest] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(shortest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
        [Fano_FixAcq_made_dead.all_middle,~,CV2_fixAcq_made_dead.all_middle] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(middle,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
        [Fano_FixAcq_made_dead.all_longest,~,CV2_fixAcq_made_dead.all_longest] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(longest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
        
        
        [Fano_FixAcq_made_dead.slow,~,CV2_fixAcq_made_dead.slow] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slow_all_made_dead);
        [Fano_FixAcq_made_dead.slow_shortest,~,CV2_fixAcq_made_dead.slow_shortest] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,shortest));
        [Fano_FixAcq_made_dead.slow_middle,~,CV2_fixAcq_made_dead.slow_middle] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,middle));
        [Fano_FixAcq_made_dead.slow_longest,~,CV2_fixAcq_made_dead.slow_longest] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,longest));
        
        [Fano_FixAcq_made_dead.fast,~,CV2_fixAcq_made_dead.fast] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fast_all_made_dead_withCleared);
        [Fano_FixAcq_made_dead.fast_shortest,~,CV2_fixAcq_made_dead.fast_shortest] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,shortest));
        [Fano_FixAcq_made_dead.fast_middle,~,CV2_fixAcq_made_dead.fast_middle] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,middle));
        [Fano_FixAcq_made_dead.fast_longest,~,CV2_fixAcq_made_dead.fast_longest] = getFano_FixAcq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,longest));
    end
    
end

%===================
% KEEP RECORD OF SDF
%===================


allSDF_targ_made_dead.all(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF);
allSDF_targ_made_dead.all_shortest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(shortest,:));
allSDF_targ_made_dead.all_middle(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(middle,:));
allSDF_targ_made_dead.all_longest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(longest,:));

allSDF_targ_made_dead.slow(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(slow_all_made_dead,:));
allSDF_targ_made_dead.slow_shortest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(shortest,slow_all_made_dead),:));
allSDF_targ_made_dead.slow_middle(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(middle,slow_all_made_dead),:));
allSDF_targ_made_dead.slow_longest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(longest,slow_all_made_dead),:));

%allSDF_targ_made_dead.med(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(med_all,:));
allSDF_targ_made_dead.fast(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(fast_all_made_dead_withCleared,:));
allSDF_targ_made_dead.fast_shortest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(shortest,fast_all_made_dead_withCleared),:));
allSDF_targ_made_dead.fast_middle(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(middle,fast_all_made_dead_withCleared),:));
allSDF_targ_made_dead.fast_longest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(longest,fast_all_made_dead_withCleared),:));
%
%     %also break SDFs by length of Fixation Period
allSDF_fix_made_dead.all(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix);
allSDF_fix_made_dead.shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(shortest,:));
allSDF_fix_made_dead.middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(middle,:));
allSDF_fix_made_dead.longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(longest,:));

allSDF_fix_made_dead.slow(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(slow_all_made_dead,:));
allSDF_fix_made_dead.slow_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(slow_all_made_dead,shortest),:));
allSDF_fix_made_dead.slow_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(slow_all_made_dead,middle),:));
allSDF_fix_made_dead.slow_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(slow_all_made_dead,longest),:));

allSDF_fix_made_dead.fast(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(fast_all_made_dead_withCleared,:));
allSDF_fix_made_dead.fast_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(fast_all_made_dead_withCleared,shortest),:));
allSDF_fix_made_dead.fast_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(fast_all_made_dead_withCleared,middle),:));
allSDF_fix_made_dead.fast_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(fast_all_made_dead_withCleared,longest),:));

if FixAcqPresent
    allSDF_fixAcq_made_dead.all(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq);
    allSDF_fixAcq_made_dead.shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(shortest,:));
    allSDF_fixAcq_made_dead.middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(middle,:));
    allSDF_fixAcq_made_dead.longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(longest,:));
    
    allSDF_fixAcq_made_dead.slow(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(slow_all_made_dead,:));
    allSDF_fixAcq_made_dead.slow_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(slow_all_made_dead,shortest),:));
    allSDF_fixAcq_made_dead.slow_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(slow_all_made_dead,middle),:));
    allSDF_fixAcq_made_dead.slow_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(slow_all_made_dead,longest),:));
    
    allSDF_fixAcq_made_dead.fast(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(fast_all_made_dead_withCleared,:));
    allSDF_fixAcq_made_dead.fast_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(fast_all_made_dead_withCleared,shortest),:));
    allSDF_fixAcq_made_dead.fast_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(fast_all_made_dead_withCleared,middle),:));
    allSDF_fixAcq_made_dead.fast_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_FixAcq(intersect(fast_all_made_dead_withCleared,longest),:));
    
end

%===================allS============
% KEEP RECORD OF ALL FANO FACTOR
%===============================

allFano_targ_made_dead.all(file,1:length(real_time_targ)) = Fano_targ_made_dead.all;
allFano_targ_made_dead.all_shortest(file,1:length(real_time_targ)) = Fano_targ_made_dead.all_shortest;
allFano_targ_made_dead.all_middle(file,1:length(real_time_targ)) = Fano_targ_made_dead.all_middle;
allFano_targ_made_dead.all_longest(file,1:length(real_time_targ)) = Fano_targ_made_dead.all_longest;

allFano_targ_made_dead.slow(file,1:length(real_time_targ)) = Fano_targ_made_dead.slow;
allFano_targ_made_dead.slow_shortest(file,1:length(real_time_targ)) = Fano_targ_made_dead.slow_shortest;
allFano_targ_made_dead.slow_middle(file,1:length(real_time_targ)) = Fano_targ_made_dead.slow_middle;
allFano_targ_made_dead.slow_longest(file,1:length(real_time_targ)) = Fano_targ_made_dead.slow_longest;

%allFano_targ_made_dead.med(file,1:length(real_time_targ)) = Fano_targ_made_dead.med;
allFano_targ_made_dead.fast(file,1:length(real_time_targ)) = Fano_targ_made_dead.fast;
allFano_targ_made_dead.fast_shortest(file,1:length(real_time_targ)) = Fano_targ_made_dead.fast_shortest;
allFano_targ_made_dead.fast_middle(file,1:length(real_time_targ)) = Fano_targ_made_dead.fast_middle;
allFano_targ_made_dead.fast_longest(file,1:length(real_time_targ)) = Fano_targ_made_dead.fast_longest;

allFano_fix_made_dead.all(file,1:length(real_time_fix)) = Fano_fix_made_dead.all;
allFano_fix_made_dead.all_shortest(file,1:length(real_time_fix)) = Fano_fix_made_dead.all_shortest;
allFano_fix_made_dead.all_middle(file,1:length(real_time_fix)) = Fano_fix_made_dead.all_middle;
allFano_fix_made_dead.all_longest(file,1:length(real_time_fix)) = Fano_fix_made_dead.all_longest;

allFano_fix_made_dead.slow(file,1:length(real_time_fix)) = Fano_fix_made_dead.slow;
allFano_fix_made_dead.slow_shortest(file,1:length(real_time_fix)) = Fano_fix_made_dead.slow_shortest;
allFano_fix_made_dead.slow_middle(file,1:length(real_time_fix)) = Fano_fix_made_dead.slow_middle;
allFano_fix_made_dead.slow_longest(file,1:length(real_time_fix)) = Fano_fix_made_dead.slow_longest;

allFano_fix_made_dead.fast(file,1:length(real_time_fix)) = Fano_fix_made_dead.fast;
allFano_fix_made_dead.fast_shortest(file,1:length(real_time_fix)) = Fano_fix_made_dead.fast_shortest;
allFano_fix_made_dead.fast_middle(file,1:length(real_time_fix)) = Fano_fix_made_dead.fast_middle;
allFano_fix_made_dead.fast_longest(file,1:length(real_time_fix)) = Fano_fix_made_dead.fast_longest;

if FixAcqPresent
    allFano_fixAcq_made_dead.all(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.all;
    allFano_fixAcq_made_dead.all_shortest(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.all_shortest;
    allFano_fixAcq_made_dead.all_middle(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.all_middle;
    allFano_fixAcq_made_dead.all_longest(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.all_longest;
    
    allFano_fixAcq_made_dead.slow(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.slow;
    allFano_fixAcq_made_dead.slow_shortest(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.slow_shortest;
    allFano_fixAcq_made_dead.slow_middle(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.slow_middle;
    allFano_fixAcq_made_dead.slow_longest(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.slow_longest;
    
    allFano_fixAcq_made_dead.fast(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.fast;
    allFano_fixAcq_made_dead.fast_shortest(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.fast_shortest;
    allFano_fixAcq_made_dead.fast_middle(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.fast_middle;
    allFano_fixAcq_made_dead.fast_longest(file,1:length(real_time_fix)) = Fano_FixAcq_made_dead.fast_longest;
    
end

allCV2_targ_made_dead.all(file,1:length(real_time_targ)) = CV2_targ_made_dead.all;
allCV2_targ_made_dead.all_shortest(file,1:length(real_time_targ)) = CV2_targ_made_dead.all_shortest;
allCV2_targ_made_dead.all_middle(file,1:length(real_time_targ)) = CV2_targ_made_dead.all_middle;
allCV2_targ_made_dead.all_longest(file,1:length(real_time_targ)) = CV2_targ_made_dead.all_longest;

allCV2_targ_made_dead.slow(file,1:length(real_time_targ)) = CV2_targ_made_dead.slow;
allCV2_targ_made_dead.slow_shortest(file,1:length(real_time_targ)) = CV2_targ_made_dead.slow_shortest;
allCV2_targ_made_dead.slow_middle(file,1:length(real_time_targ)) = CV2_targ_made_dead.slow_middle;
allCV2_targ_made_dead.slow_longest(file,1:length(real_time_targ)) = CV2_targ_made_dead.slow_longest;

allCV2_targ_made_dead.fast(file,1:length(real_time_targ)) = CV2_targ_made_dead.fast;
allCV2_targ_made_dead.fast_shortest(file,1:length(real_time_targ)) = CV2_targ_made_dead.fast_shortest;
allCV2_targ_made_dead.fast_middle(file,1:length(real_time_targ)) = CV2_targ_made_dead.fast_middle;
allCV2_targ_made_dead.fast_longest(file,1:length(real_time_targ)) = CV2_targ_made_dead.fast_longest;


allCV2_fix_made_dead.all(file,1:length(real_time_fix)) = CV2_fix_made_dead.all;
allCV2_fix_made_dead.all_shortest(file,1:length(real_time_fix)) = CV2_fix_made_dead.all_shortest;
allCV2_fix_made_dead.all_middle(file,1:length(real_time_fix)) = CV2_fix_made_dead.all_middle;
allCV2_fix_made_dead.all_longest(file,1:length(real_time_fix)) = CV2_fix_made_dead.all_longest;

allCV2_fix_made_dead.slow(file,1:length(real_time_fix)) = CV2_fix_made_dead.slow;
allCV2_fix_made_dead.slow_shortest(file,1:length(real_time_fix)) = CV2_fix_made_dead.slow_shortest;
allCV2_fix_made_dead.slow_middle(file,1:length(real_time_fix)) = CV2_fix_made_dead.slow_middle;
allCV2_fix_made_dead.slow_longest(file,1:length(real_time_fix)) = CV2_fix_made_dead.slow_longest;

allCV2_fix_made_dead.fast(file,1:length(real_time_fix)) = CV2_fix_made_dead.fast;
allCV2_fix_made_dead.fast_shortest(file,1:length(real_time_fix)) = CV2_fix_made_dead.fast_shortest;
allCV2_fix_made_dead.fast_middle(file,1:length(real_time_fix)) = CV2_fix_made_dead.fast_middle;
allCV2_fix_made_dead.fast_longest(file,1:length(real_time_fix)) = CV2_fix_made_dead.fast_longest;

if FixAcqPresent
    allCV2_fixAcq_made_dead.all(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.all;
    allCV2_fixAcq_made_dead.all_shortest(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.all_shortest;
    allCV2_fixAcq_made_dead.all_middle(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.all_middle;
    allCV2_fixAcq_made_dead.all_longest(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.all_longest;
    
    allCV2_fixAcq_made_dead.slow(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.slow;
    allCV2_fixAcq_made_dead.slow_shortest(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.slow_shortest;
    allCV2_fixAcq_made_dead.slow_middle(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.slow_middle;
    allCV2_fixAcq_made_dead.slow_longest(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.slow_longest;
    
    allCV2_fixAcq_made_dead.fast(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.fast;
    allCV2_fixAcq_made_dead.fast_shortest(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.fast_shortest;
    allCV2_fixAcq_made_dead.fast_middle(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.fast_middle;
    allCV2_fixAcq_made_dead.fast_longest(file,1:length(real_time_fixAcq)) = CV2_fixAcq_made_dead.fast_longest;
    
end


%=============================================
%=============================================
% MISSED DEADLINES
%=============================================
%=============================================

% Aligned to Target onset
[Fano_targ_missed_dead.all,real_time_targ,CV2_targ_missed_dead.all] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],[slow_all_missed_dead ; fast_all_missed_dead_withCleared]);
[Fano_targ_missed_dead.all_shortest,~,CV2_targ_missed_dead.all_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
[Fano_targ_missed_dead.all_middle,~,CV2_targ_missed_dead.all_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
[Fano_targ_missed_dead.all_longest,~,CV2_targ_missed_dead.all_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));

[Fano_targ_missed_dead.slow,~,CV2_targ_missed_dead.slow] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],slow_all_missed_dead);
[Fano_targ_missed_dead.slow_shortest,~,CV2_targ_missed_dead.slow_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,slow_all_missed_dead));
[Fano_targ_missed_dead.slow_middle,~,CV2_targ_missed_dead.slow_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,slow_all_missed_dead));
[Fano_targ_missed_dead.slow_longest,~,CV2_targ_missed_dead.slow_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,slow_all_missed_dead));

%Fano_targ_missed_dead.med = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],med_all);
[Fano_targ_missed_dead.fast,~,CV2_targ_missed_dead.fast] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],fast_all_missed_dead_withCleared);
[Fano_targ_missed_dead.fast_shortest,~,CV2_targ_missed_dead.fast_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,fast_all_missed_dead_withCleared));
[Fano_targ_missed_dead.fast_middle,~,CV2_targ_missed_dead.fast_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,fast_all_missed_dead_withCleared));
[Fano_targ_missed_dead.fast_longest,~,CV2_targ_missed_dead.fast_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,fast_all_missed_dead_withCleared));


% Aligned to fixation hold time
[Fano_fix_missed_dead.all,real_time_fix,CV2_fix_missed_dead.all] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],[slow_all_missed_dead ; fast_all_missed_dead_withCleared]);
[Fano_fix_missed_dead.all_shortest,~,CV2_fix_missed_dead.all_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(shortest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
[Fano_fix_missed_dead.all_middle,~,CV2_fix_missed_dead.all_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(middle,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
[Fano_fix_missed_dead.all_longest,~,CV2_fix_missed_dead.all_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(longest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));


[Fano_fix_missed_dead.slow,~,CV2_fix_missed_dead.slow] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slow_all_missed_dead);
[Fano_fix_missed_dead.slow_shortest,~,CV2_fix_missed_dead.slow_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_missed_dead,shortest));
[Fano_fix_missed_dead.slow_middle,~,CV2_fix_missed_dead.slow_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_missed_dead,middle));
[Fano_fix_missed_dead.slow_longest,~,CV2_fix_missed_dead.slow_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_missed_dead,longest));

[Fano_fix_missed_dead.fast,~,CV2_fix_missed_dead.fast] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fast_all_missed_dead_withCleared);
[Fano_fix_missed_dead.fast_shortest,~,CV2_fix_missed_dead.fast_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_missed_dead_withCleared,shortest));
[Fano_fix_missed_dead.fast_middle,~,CV2_fix_missed_dead.fast_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_missed_dead_withCleared,middle));
[Fano_fix_missed_dead.fast_longest,~,CV2_fix_missed_dead.fast_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_missed_dead_withCleared,longest));





%===================
% KEEP RECORD OF SDF
%===================


allSDF_targ_missed_dead.all(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF);
allSDF_targ_missed_dead.all_shortest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(shortest,:));
allSDF_targ_missed_dead.all_middle(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(middle,:));
allSDF_targ_missed_dead.all_longest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(longest,:));

allSDF_targ_missed_dead.slow(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(slow_all_missed_dead,:));
allSDF_targ_missed_dead.slow_shortest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(shortest,slow_all_missed_dead),:));
allSDF_targ_missed_dead.slow_middle(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(middle,slow_all_missed_dead),:));
allSDF_targ_missed_dead.slow_longest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(longest,slow_all_missed_dead),:));

%allSDF_targ_missed_dead.med(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(med_all,:));
allSDF_targ_missed_dead.fast(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(fast_all_missed_dead_withCleared,:));
allSDF_targ_missed_dead.fast_shortest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(shortest,fast_all_missed_dead_withCleared),:));
allSDF_targ_missed_dead.fast_middle(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(middle,fast_all_missed_dead_withCleared),:));
allSDF_targ_missed_dead.fast_longest(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(intersect(longest,fast_all_missed_dead_withCleared),:));
%
%     %also break SDFs by length of Fixation Period
allSDF_fix_missed_dead.all(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix);
allSDF_fix_missed_dead.shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(shortest,:));
allSDF_fix_missed_dead.middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(middle,:));
allSDF_fix_missed_dead.longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(longest,:));

allSDF_fix_missed_dead.slow(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(slow_all_missed_dead,:));
allSDF_fix_missed_dead.slow_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(slow_all_missed_dead,shortest),:));
allSDF_fix_missed_dead.slow_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(slow_all_missed_dead,middle),:));
allSDF_fix_missed_dead.slow_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(slow_all_missed_dead,longest),:));

allSDF_fix_missed_dead.fast(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(fast_all_missed_dead_withCleared,:));
allSDF_fix_missed_dead.fast_shortest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(fast_all_missed_dead_withCleared,shortest),:));
allSDF_fix_missed_dead.fast_middle(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(fast_all_missed_dead_withCleared,middle),:));
allSDF_fix_missed_dead.fast_longest(file,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = nanmean(SDF_Fix(intersect(fast_all_missed_dead_withCleared,longest),:));



%===================allS============
% KEEP RECORD OF ALL FANO FACTOR
%===============================

allFano_targ_missed_dead.all(file,1:length(real_time_targ)) = Fano_targ_missed_dead.all;
allFano_targ_missed_dead.all_shortest(file,1:length(real_time_targ)) = Fano_targ_missed_dead.all_shortest;
allFano_targ_missed_dead.all_middle(file,1:length(real_time_targ)) = Fano_targ_missed_dead.all_middle;
allFano_targ_missed_dead.all_longest(file,1:length(real_time_targ)) = Fano_targ_missed_dead.all_longest;

allFano_targ_missed_dead.slow(file,1:length(real_time_targ)) = Fano_targ_missed_dead.slow;
allFano_targ_missed_dead.slow_shortest(file,1:length(real_time_targ)) = Fano_targ_missed_dead.slow_shortest;
allFano_targ_missed_dead.slow_middle(file,1:length(real_time_targ)) = Fano_targ_missed_dead.slow_middle;
allFano_targ_missed_dead.slow_longest(file,1:length(real_time_targ)) = Fano_targ_missed_dead.slow_longest;

%allFano_targ_missed_dead.med(file,1:length(real_time_targ)) = Fano_targ_missed_dead.med;
allFano_targ_missed_dead.fast(file,1:length(real_time_targ)) = Fano_targ_missed_dead.fast;
allFano_targ_missed_dead.fast_shortest(file,1:length(real_time_targ)) = Fano_targ_missed_dead.fast_shortest;
allFano_targ_missed_dead.fast_middle(file,1:length(real_time_targ)) = Fano_targ_missed_dead.fast_middle;
allFano_targ_missed_dead.fast_longest(file,1:length(real_time_targ)) = Fano_targ_missed_dead.fast_longest;

allFano_fix_missed_dead.all(file,1:length(real_time_fix)) = Fano_fix_missed_dead.all;
allFano_fix_missed_dead.all_shortest(file,1:length(real_time_fix)) = Fano_fix_missed_dead.all_shortest;
allFano_fix_missed_dead.all_middle(file,1:length(real_time_fix)) = Fano_fix_missed_dead.all_middle;
allFano_fix_missed_dead.all_longest(file,1:length(real_time_fix)) = Fano_fix_missed_dead.all_longest;

allFano_fix_missed_dead.slow(file,1:length(real_time_fix)) = Fano_fix_missed_dead.slow;
allFano_fix_missed_dead.slow_shortest(file,1:length(real_time_fix)) = Fano_fix_missed_dead.slow_shortest;
allFano_fix_missed_dead.slow_middle(file,1:length(real_time_fix)) = Fano_fix_missed_dead.slow_middle;
allFano_fix_missed_dead.slow_longest(file,1:length(real_time_fix)) = Fano_fix_missed_dead.slow_longest;

allFano_fix_missed_dead.fast(file,1:length(real_time_fix)) = Fano_fix_missed_dead.fast;
allFano_fix_missed_dead.fast_shortest(file,1:length(real_time_fix)) = Fano_fix_missed_dead.fast_shortest;
allFano_fix_missed_dead.fast_middle(file,1:length(real_time_fix)) = Fano_fix_missed_dead.fast_middle;
allFano_fix_missed_dead.fast_longest(file,1:length(real_time_fix)) = Fano_fix_missed_dead.fast_longest;



allCV2_targ_missed_dead.all(file,1:length(real_time_targ)) = CV2_targ_missed_dead.all;
allCV2_targ_missed_dead.all_shortest(file,1:length(real_time_targ)) = CV2_targ_missed_dead.all_shortest;
allCV2_targ_missed_dead.all_middle(file,1:length(real_time_targ)) = CV2_targ_missed_dead.all_middle;
allCV2_targ_missed_dead.all_longest(file,1:length(real_time_targ)) = CV2_targ_missed_dead.all_longest;

allCV2_targ_missed_dead.slow(file,1:length(real_time_targ)) = CV2_targ_missed_dead.slow;
allCV2_targ_missed_dead.slow_shortest(file,1:length(real_time_targ)) = CV2_targ_missed_dead.slow_shortest;
allCV2_targ_missed_dead.slow_middle(file,1:length(real_time_targ)) = CV2_targ_missed_dead.slow_middle;
allCV2_targ_missed_dead.slow_longest(file,1:length(real_time_targ)) = CV2_targ_missed_dead.slow_longest;

allCV2_targ_missed_dead.fast(file,1:length(real_time_targ)) = CV2_targ_missed_dead.fast;
allCV2_targ_missed_dead.fast_shortest(file,1:length(real_time_targ)) = CV2_targ_missed_dead.fast_shortest;
allCV2_targ_missed_dead.fast_middle(file,1:length(real_time_targ)) = CV2_targ_missed_dead.fast_middle;
allCV2_targ_missed_dead.fast_longest(file,1:length(real_time_targ)) = CV2_targ_missed_dead.fast_longest;


allCV2_fix_missed_dead.all(file,1:length(real_time_fix)) = CV2_fix_missed_dead.all;
allCV2_fix_missed_dead.all_shortest(file,1:length(real_time_fix)) = CV2_fix_missed_dead.all_shortest;
allCV2_fix_missed_dead.all_middle(file,1:length(real_time_fix)) = CV2_fix_missed_dead.all_middle;
allCV2_fix_missed_dead.all_longest(file,1:length(real_time_fix)) = CV2_fix_missed_dead.all_longest;

allCV2_fix_missed_dead.slow(file,1:length(real_time_fix)) = CV2_fix_missed_dead.slow;
allCV2_fix_missed_dead.slow_shortest(file,1:length(real_time_fix)) = CV2_fix_missed_dead.slow_shortest;
allCV2_fix_missed_dead.slow_middle(file,1:length(real_time_fix)) = CV2_fix_missed_dead.slow_middle;
allCV2_fix_missed_dead.slow_longest(file,1:length(real_time_fix)) = CV2_fix_missed_dead.slow_longest;

allCV2_fix_missed_dead.fast(file,1:length(real_time_fix)) = CV2_fix_missed_dead.fast;
allCV2_fix_missed_dead.fast_shortest(file,1:length(real_time_fix)) = CV2_fix_missed_dead.fast_shortest;
allCV2_fix_missed_dead.fast_middle(file,1:length(real_time_fix)) = CV2_fix_missed_dead.fast_middle;
allCV2_fix_missed_dead.fast_longest(file,1:length(real_time_fix)) = CV2_fix_missed_dead.fast_longest;

%==================================
%==================================


if plotSess
    subplot(121)
    plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(SDF(slow_all_made_dead,:)),'r',Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(SDF(fast_all_made_dead_withCleared,:)),'g')
    box off
    
    title(['# ' mat2str(file)],'fontsize',20,'fontweight','bold')
    
    subplot(122)
    plot(real_time_targ,Fano_targ_made_dead.slow,'r',real_time_targ,Fano_targ_made_dead.fast,'g')
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
    %     fig1
    %     subplot(121)
    %     plot(Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDF_targ_made_dead.slow),'r',Plot_Time_Targ(1):Plot_Time_Targ(2),nanmean(allSDF_targ_made_dead.fast),'g')
    %     box off
    %     xlim([-2000 800])
    %
    %     subplot(122)
    %     plot(real_time_targ,nanmean(allFano_targ_made_dead.slow),'r',real_time_targ,nanmean(allFano_targ_made_dead.fast),'g')
    %     box off
    %     xlim([-2000 800])
    %
    %     title('Target Aligned')
    %
    %
    fig1
    subplot(121)
    plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDF_fix_made_dead.slow),'r',Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDF_fix_made_dead.fast),'g')
    box off
    xlim([-50 3000])
    
    subplot(122)
    plot(real_time_fix,nanmean(allFano_fix_made_dead.slow),'r',real_time_fix,nanmean(allFano_fix_made_dead.fast),'g')
    box off
    xlim([-50 3000])
    
    title('Fixation Aligned - All')
    
    fig2
    subplot(121)
    plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDF_fix_made_dead.slow_shortest),'r',Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDF_fix_made_dead.fast_shortest),'g')
    box off
    xlim([-50 3000])
    
    subplot(122)
    plot(real_time_fix,nanmean(allFano_fix_made_dead.slow_shortest),'r',real_time_fix,nanmean(allFano_fix_made_dead.fast_shortest),'g')
    box off
    xlim([-50 3000])
    
    title('Fixation Aligned - Shortest Fixation Hold Times')
    
    
    fig3
    subplot(121)
    plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDF_fix_made_dead.slow_middle),'r',Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDF_fix_made_dead.fast_middle),'g')
    box off
    xlim([-50 3000])
    
    subplot(122)
    plot(real_time_fix,nanmean(allFano_fix_made_dead.slow_middle),'r',real_time_fix,nanmean(allFano_fix_made_dead.fast_middle),'g')
    box off
    xlim([-50 3000])
    
    title('Fixation Aligned - Middle Fixation Hold Times')
    
    
    
    fig4
    subplot(121)
    plot(Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDF_fix_made_dead.slow_longest),'r',Plot_Time_Fix(1):Plot_Time_Fix(2),nanmean(allSDF_fix_made_dead.fast_longest),'g')
    box off
    xlim([-50 3000])
    
    subplot(122)
    plot(real_time_fix,nanmean(allFano_fix_made_dead.slow_longest),'r',real_time_fix,nanmean(allFano_fix_made_dead.fast_longest),'g')
    box off
    xlim([-50 3000])
    
    title('Fixation Aligned - Longest Fixation Hold Times')
end
