cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_Vis_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Vis_Med_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_VisMove_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Vis_Med_S.txt','%s %s');
[filename8 unit8] = textread('SAT_VisMove_Med_S.txt','%s %s');
filename = [filename1 ; filename2 ; filename3 ; filename4 ; filename5 ; filename6 ; filename7 ; filename8];
unit = [unit1 ; unit2 ; unit3 ; unit4 ; unit5 ; unit6 ; unit7 ; unit8];


% [filename1 unit1] = textread('SAT_Move_NoMed_Q.txt','%s %s');
% [filename2 unit2] = textread('SAT_Move_Med_Q.txt','%s %s');
% [filename3 unit3] = textread('SAT_Move_NoMed_S.txt','%s %s');
% [filename4 unit4] = textread('SAT_Move_Med_S.txt','%s %s');
% filename = [filename1 ; filename2 ; filename3 ; filename4];
% unit = [unit1 ; unit2 ; unit3 ; unit4];




normalizeSDF = 1; %normalize SDFs


cd /volumes/Dump/Search_Data_SAT_longbase/

for file = 1:length(filename)
    
    eval(['load(' '''' filename{file} '''' ',' '''' unit{file} '''' ',' '''' 'RFs' '''' ')'])
    load(filename{file},'Target_','SRT','SAT_','Correct_','Errors_','FixTime_Jit_')
    filename{file}
    
    sig = eval(unit{file});
    
    RF = RFs.(unit{file});
    
    antiRF = mod((RF+4),8);
    
    
    %get block switch baseline effect
    %     [SDF_switch] = block_switch(unit{file},0);
    %
    %     block_switchSDF.fast_to_slow(file,:) = SDF_switch.fast_to_slow;
    %     block_switchSDF.slow_to_fast(file,:) = SDF_switch.slow_to_fast;
    %     block_switchSDF.slow_to_med(file,:) = SDF_switch.slow_to_med;
    %     block_switchSDF.med_to_fast(file,:) = SDF_switch.med_to_fast;
    
    
    %============
    % FIND TRIALS
    %===================================================================
    getTrials_SAT
    
    fast_all = fast_all_withCleared;
%     RTs.slow_correct_made_dead(file,1) = nanmean(SRT(slow_correct_made_dead,1));
%     RTs.med_correct(file,1) = nanmean(SRT(med_correct,1));
%     RTs.fast_correct_made_dead_withCleared(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared,1));
%     
%     
%     RTs.slow_errors_made_dead(file,1) = nanmean(SRT(slow_errors_made_dead,1));
%     RTs.med_errors(file,1) = nanmean(SRT(med_errors,1));
%     RTs.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(fast_errors_made_dead_withCleared,1));
%     
%     RTs.slow_all(file,1) = nanmean(SRT(slow_all,1));
%     RTs.fast_all(file,1) = nanmean(SRT(fast_all_withCleared,1));
%     
    
    SDF_fix = sSDF(sig,3500-FixTime_Jit_,[-2500 3000]);
    SDF_targ = sSDF(sig,Target_(:,1),[-3500 2500]);
    
    fixtime_short = find(FixTime_Jit_ <= 2000);
    fixtime_long = find(FixTime_Jit_ > 2000);
    
    SDF_fix_trunc = SDF_fix;
    for trl = 1:size(SDF_fix_trunc,1)
        SDF_fix_trunc(trl,FixTime_Jit_(trl)+100:end) = NaN;
    end
    
    
    if normalizeSDF == 1
        [SDF_targ weight] = normalize_SP(SDF_targ);
    end
    
    %use weight from target-aligned SDFs to normalize fixation-aligned SDFs
    SDF_fix = SDF_fix ./ weight;
    SDF_fix_trunc = SDF_fix_trunc ./ weight;
    
    
    
    blk_switch = find(abs(diff(SAT_(:,1))) ~= 0) + 1;
    
    %find corresponding conditions
    fast_to_slow = blk_switch(find(SAT_(blk_switch-1,1) == 3 & SAT_(blk_switch,1) == 1));
    slow_to_fast = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 3));
    
    
    slow_to_med = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 2));
    
    if ~isempty(slow_to_med)
        med_included = 1;
    else
        med_included = 0;
    end
    
    %=======================
    %keep track of waveforms
    
%     allwf_targ.slow_correct_made_dead(file,:) = nanmean(SDF_targ(slow_correct_made_dead,:));
%     allwf_targ.fast_correct_made_dead(file,:) = nanmean(SDF_targ(fast_correct_made_dead_withCleared,:));
    
    try
        %allwf_targ.med_correct(file,:) = nanmean(SDF_targ(med_correct,:));
        allwf_targ.med_all(file,:) = nanmean(SDF_targ(med_all,:));
        allwf_targ_short.med_all(file,:) = nanmean(SDF_targ(intersect(fixtime_short,med_all),:));
        allwf_targ_long.med_all(file,:) = nanmean(SDF_targ(intersect(fixtime_long,med_all),:));
    catch
        
        allwf_targ.med_all(file,1:length(-3500:2500)) = NaN;
        allwf_targ_short.med_all(file,1:length(-3500:2500)) = NaN;
        allwf_targ_long.med_all(file,1:length(-3500:2500)) = NaN;
    end
    
    allwf_targ.slow_all(file,:) = nanmean(SDF_targ(slow_all,:));
    allwf_targ.fast_all(file,:) = nanmean(SDF_targ(fast_all_withCleared,:));
    
    allwf_targ_short.slow_all(file,:) = nanmean(SDF_targ(intersect(fixtime_short,slow_all),:));
    allwf_targ_long.slow_all(file,:) = nanmean(SDF_targ(intersect(fixtime_long,slow_all),:));

    allwf_targ_short.fast_all(file,:) = nanmean(SDF_targ(intersect(fixtime_short,fast_all),:));
    allwf_targ_long.fast_all(file,:) = nanmean(SDF_targ(intersect(fixtime_long,fast_all),:));
    
    
    
    allwf_targ.slow_to_fast_all(file,:) = nanmean(SDF_targ(slow_to_fast,:));
    allwf_targ.fast_to_slow_all(file,:) = nanmean(SDF_targ(fast_to_slow,:));
    
    if ~med_included
        allwf_targ.slow_to_fast_all(file,:) = nanmean(SDF_targ(slow_to_fast,:));
        allwf_targ.fast_to_slow_all(file,:) = nanmean(SDF_targ(fast_to_slow,:));
    else
        allwf_targ.slow_to_fast_all(file,1:length(-3500:2500)) = NaN;
        allwf_targ.fast_to_slow_all(file,1:length(-3500:2500)) = NaN;
    end
    
    %=======================
    %allwf_fix.slow_correct_made_dead(file,:) = nanmean(SDF_fix(slow_correct_made_dead,:));
    %allwf_fix.fast_correct_made_dead(file,:) = nanmean(SDF_fix(fast_correct_made_dead_withCleared,:));
    
    try
       % allwf_fix.med_correct(file,:) = nanmean(SDF_fix(med_correct,:));
       allwf_fix.med_all(file,:) = nanmean(SDF_fix(med_all,:));
       allwf_fix_short.med_all(file,:) = nanmean(SDF_fix(intersect(fixtime_short,med_all),:));
       allwf_fix_long.med_all(file,:) = nanmean(SDF_fix(intersect(fixtime_long,med_all),:));
    catch
       % allwf_fix.med_correct(file,:) = NaN;
               
        allwf_fix.med_all(file,1:length(-2500:3000)) = NaN;
        allwf_fix_short.med_all(file,1:length(-2500:3000)) = NaN;
        allwf_fix_long.med_all(file,1:length(-2500:3000)) = NaN;
    end
    allwf_fix.slow_all(file,:) = nanmean(SDF_fix(slow_all,:));
    allwf_fix.fast_all(file,:) = nanmean(SDF_fix(fast_all_withCleared,:));
    
    allwf_fix_short.slow_all(file,:) = nanmean(SDF_fix(intersect(fixtime_short,slow_all),:));
    allwf_fix_long.slow_all(file,:) = nanmean(SDF_fix(intersect(fixtime_long,slow_all),:));

    allwf_fix_short.fast_all(file,:) = nanmean(SDF_fix(intersect(fixtime_short,fast_all),:));
    allwf_fix_long.fast_all(file,:) = nanmean(SDF_fix(intersect(fixtime_long,fast_all),:));
    
    
    allwf_fix.slow_to_fast_all(file,:) = nanmean(SDF_fix(slow_to_fast,:));
    allwf_fix.fast_to_slow_all(file,:) = nanmean(SDF_fix(fast_to_slow,:));
    
    if ~med_included
        allwf_fix.slow_to_fast_all(file,:) = nanmean(SDF_fix(slow_to_fast,:));
        allwf_fix.fast_to_slow_all(file,:) = nanmean(SDF_fix(fast_to_slow,:));
    else
        allwf_fix.slow_to_fast_all(file,1:length(-2500:3000)) = NaN;
        allwf_fix.fast_to_slow_all(file,1:length(-2500:3000)) = NaN;
    end
    
    
    %==========================
    
    allwf_fix_trunc.slow_correct_made_dead(file,:) = nanmean(SDF_fix_trunc(slow_correct_made_dead,:));
    allwf_fix_trunc.fast_correct_made_dead(file,:) = nanmean(SDF_fix_trunc(fast_correct_made_dead_withCleared,:));
    
    try
        %allwf_fix_trunc.med_correct(file,:) = nanmean(SDF_fix_trunc(med_correct,:));
        allwf_fix_trunc.med_all(file,:) = nanmean(SDF_fix_trunc(med_all,:));
        allwf_fix_trunc_short.med_all(file,:) = nanmean(SDF_fix_trunc(intersect(fixtime_short,med_all),:));
        allwf_fix_trunc_long.med_all(file,:) = nanmean(SDF_fix_trunc(intersect(fixtime_long,med_all),:));
    catch
        %allwf_fix_trunc.med_correct(file,:) = NaN;
        allwf_fix_trunc.med_all(file,1:length(-2500:3000)) = NaN;
        allwf_fix_trunc_short.med_all(file,1:length(-2500:3000)) = NaN;
        allwf_fix_trunc_long.med_all(file,1:length(-2500:3000)) = NaN;
    end
    
    allwf_fix_trunc.slow_all(file,:) = nanmean(SDF_fix_trunc(slow_all,:));
    allwf_fix_trunc.fast_all(file,:) = nanmean(SDF_fix_trunc(fast_all_withCleared,:));
    
    %allwf_fix.slow_correct_made_dead(file,:) = nanmean(SDF_fix(slow_correct_made_dead,:));
    %allwf_fix.fast_correct_made_dead(file,:) = nanmean(SDF_fix(fast_correct_made_dead_withCleared,:));
    
    try
        %allwf_fix.med_correct(file,:) = nanmean(SDF_fix(med_correct,:));
    catch
        %allwf_fix.med_correct(file,:) = NaN;
    end
    allwf_fix_trunc.slow_all(file,:) = nanmean(SDF_fix_trunc(slow_all,:));
    allwf_fix_trunc.fast_all(file,:) = nanmean(SDF_fix_trunc(fast_all_withCleared,:));
    
    allwf_fix_trunc_short.slow_all(file,:) = nanmean(SDF_fix_trunc(intersect(fixtime_short,slow_all),:));
    allwf_fix_trunc_long.slow_all(file,:) = nanmean(SDF_fix_trunc(intersect(fixtime_long,slow_all),:));
    
    allwf_fix_trunc_short.fast_all(file,:) = nanmean(SDF_fix_trunc(intersect(fixtime_short,fast_all),:));
    allwf_fix_trunc_long.fast_all(file,:) = nanmean(SDF_fix_trunc(intersect(fixtime_long,fast_all),:));
    
    
    
    allwf_fix_trunc.slow_to_fast_all(file,:) = nanmean(SDF_fix_trunc(slow_to_fast,:));
    allwf_fix_trunc.fast_to_slow_all(file,:) = nanmean(SDF_fix_trunc(fast_to_slow,:));
    
    if ~med_included
        allwf_fix_trunc.slow_to_fast_all(file,:) = nanmean(SDF_fix_trunc(slow_to_fast,:));
        allwf_fix_trunc.fast_to_slow_all(file,:) = nanmean(SDF_fix_trunc(fast_to_slow,:));
    else
        allwf_fix_trunc.slow_to_fast_all(file,1:length(-2500:3000)) = NaN;
        allwf_fix_trunc.fast_to_slow_all(file,1:length(-2500:3000)) = NaN;
    end
    
    
    
    keep filename unit file basewf allwf* RTs normalizeSDF issig block_switchSDF
    
end



%GET sigpos variable from other file
cd /volumes/Dump/Analyses/SAT/
load('/Volumes/Dump/Analyses/SAT/compileSAT_baseline_vis_visMove_Med_NoMed.mat','sigpos')


figure

subplot(2,2,1)
plot(-3500:2500,nanmean(allwf_targ.slow_to_fast_all(sigpos,:)),'r',-3500:2500,nanmean(allwf_targ.fast_to_slow_all(sigpos,:)),'g')
xlim([-3000 200])
ylim([.35 .66])
set(gca,'xminortick','on')
box off
title('block switch targ aligned sig only')

subplot(2,2,2)
plot(-2500:3000,nanmean(allwf_fix.slow_to_fast_all(sigpos,:)),'r',-2500:3000,nanmean(allwf_fix.fast_to_slow_all(sigpos,:)),'g')
xlim([-500 3000])
ylim([.35 .66])
set(gca,'xminortick','on')
box off
title('block switch fixation aligned sig only')

%get time at which fast_to_slow and slow_to_fast significantly diverge
%start looking at time = 0 relative to fixation
x = allwf_fix.slow_to_fast_all(sigpos,2500:end);
y = allwf_fix.fast_to_slow_all(sigpos,2500:end);
for t = 1:size(x,2)
z = removeNaN([x(:,t) y(:,t)]);
[h(t) p(t)] = ttest(z(:,1),z(:,2));
clear z
end
diverge_time = min(findRuns(h,10));
vline(diverge_time,'k')

figure
subplot(2,2,1)
plot(-3500:2500,nanmean(allwf_targ.slow_all(sigpos,:)),'r',-3500:2500,nanmean(allwf_targ.med_all(sigpos,:)),'k',-3500:2500,nanmean(allwf_targ.fast_all(sigpos,:)),'g')
xlim([-3000 200])
box off
set(gca,'xminortick','on')
title('targ aligned sigpos')



subplot(2,2,2)
plot(-2500:3000,nanmean(allwf_fix.slow_all(sigpos,:)),'r',-2500:3000,nanmean(allwf_fix.med_all(sigpos,:)),'k',-2500:3000,nanmean(allwf_fix.fast_all(sigpos,:)),'g')
xlim([-500 3000])
box off
set(gca,'xminortick','on')
title('fix aligned sigpos')