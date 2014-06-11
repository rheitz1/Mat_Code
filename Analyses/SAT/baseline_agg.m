cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
%  [filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
%  [filename2 unit2] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
%  [filename3 unit3] = textread('SAT_Vis_NoMed_S.txt','%s %s');
%  [filename4 unit4] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
%  [filename5 unit5] = textread('SAT_Vis_Med_Q.txt','%s %s');
%  [filename6 unit6] = textread('SAT_VisMove_Med_Q.txt','%s %s');
%  [filename7 unit7] = textread('SAT_Vis_Med_S.txt','%s %s');
%  [filename8 unit8] = textread('SAT_VisMove_Med_S.txt','%s %s');
%   [filename9 unit9] = textread('SAT_Move_Med_Q.txt','%s %s');
%   [filename10 unit10] = textread('SAT_Move_NoMed_Q.txt','%s %s');
%   [filename11 unit11] = textread('SAT_Move_Med_S.txt','%s %s');
%   [filename12 unit12] = textread('SAT_Move_NoMed_S.txt','%s %s');
% 
% filename = [filename1 ; filename2 ; filename3 ; filename4 ; filename5 ; filename6 ; filename7 ; filename8];
% unit = [unit1 ; unit2 ; unit3 ; unit4 ; unit5 ; unit6 ; unit7 ; unit8];


[filename1 unit1] = textread('SAT2_FEF_Vis_NoMed_D.txt','%s %s');
[filename2 unit2] = textread('SAT2_FEF_VisMove_NoMed_D.txt','%s %s');
%[filename3 unit3] = textread('SAT2_SC_Vis_NoMed_E.txt','%s %s');
%[filename4 unit4] = textread('SAT2_SC_VisMove_NoMed_E.txt','%s %s');

filename = [filename1 ; filename2 ];
unit = [unit1 ; unit2];

%=======================
% NOTES
%   (1) When you plot the waveforms, be sure to use 'sigpos' only, as ~50% of neurons did not show the
%   baseline effect.
%
%   (2) Note that if you look at all the data averaged (i.e., Med + NoMed conditions) separately for each
%   monkey, it will appear that the Neutral condition is higher than all others in one monkey and lower
%   than all other conditions in the other monkey, and on average, they will cancel out and fall in the
%   middle of the Accurate and Fast condition.  This seems to suggest that it is simply an averaging
%   artifact, but recall that not all sessions contained the Neutral condition.   Therefore, to
%   demonstrate that the effect is real and not due to averaging, you need to look at MED only files.  I
%   will rush to note that when you do this though, the Neutral condition doesn't so much fall in the
%   middle of Accurate and Fast as it does look just like Fast, for both monkeys....
%=======================

% [filename1 unit1] = textread('SAT_Move_NoMed_Q.txt','%s %s');
% [filename2 unit2] = textread('SAT_Move_Med_Q.txt','%s %s');
% [filename3 unit3] = textread('SAT_Move_NoMed_S.txt','%s %s');
% [filename4 unit4] = textread('SAT_Move_Med_S.txt','%s %s');
% filename = [filename1 ; filename2 ; filename3 ; filename4];
% unit = [unit1 ; unit2 ; unit3 ; unit4];

normalizeSDF = 1; %normalize SDFs
include_med = 0;

for file = 1:length(filename)
    
    eval(['load(' '''' filename{file} '''' ',' '''' unit{file} '''' ',' '''' 'RFs' '''' ')'])
    load(filename{file},'Target_','SRT','SAT_','Correct_','Errors_')
    filename{file}
    
    sig = eval(unit{file});
    
    RF = RFs.(unit{file});
    
    antiRF = mod((RF+4),8);
    
    
    %get block switch baseline effect
    [SDF_switch] = block_switch_SDF(unit{file},-2:2);
    

    block_switchSDF.fast_to_slow(file,:) = SDF_switch.fast_to_slow;
    block_switchSDF.slow_to_fast(file,:) = SDF_switch.slow_to_fast;
    block_switchSDF.slow_to_med(file,:) = SDF_switch.slow_to_med;
    block_switchSDF.med_to_fast(file,:) = SDF_switch.med_to_fast;

    
    if include_med & isnan(block_switchSDF.slow_to_fast(file,1))
    %designate slow_to_med as the same as slow_to_fast
        block_switchSDF.slow_to_fast(file,:) = SDF_switch.slow_to_med;
    end    
    
    %============
    % FIND TRIALS
    %===================================================================
    getTrials_SAT
    
    RTs.slow_correct_made_dead(file,1) = nanmean(SRT(slow_correct_made_dead,1));
    RTs.med_correct(file,1) = nanmean(SRT(med_correct,1));
    RTs.fast_correct_made_dead_withCleared(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared,1));
    
    
    RTs.slow_errors_made_dead(file,1) = nanmean(SRT(slow_errors_made_dead,1));
    RTs.med_errors(file,1) = nanmean(SRT(med_errors,1));
    RTs.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(fast_errors_made_dead_withCleared,1));
    
    RTs.slow_all(file,1) = nanmean(SRT(slow_all,1));
    RTs.fast_all(file,1) = nanmean(SRT(fast_all_withCleared,1));
    
    
    SDF = sSDF(sig,Target_(:,1),[-400 800]);
    
    if normalizeSDF == 1
        SDF = normalize_SP(SDF);
    end
    

    %==============
    % NOTE 2014
    %
    % If baseline waveforms look different when this script is run relative to saved .mat file,
    % the culprit has something to do with what neurons are considered as 'sigpos', which is
    % in turn dependent on baseSDF. Something changed when I started using the longBase
    % datafiles. That, or I had manually removed some crazy outliers...
    %===============
    
    
    %truncate normalized SDFs to window
    baseSDF = SDF(:,200:400);
    
    %keep track of waveforms
    
    allwf.slow_correct_made_dead(file,:) = nanmean(SDF(slow_correct_made_dead,:));
    allwf.slow_errors_made_dead(file,:) = nanmean(SDF(slow_errors_made_dead,:));
    allwf.slow_correct_missed_dead(file,:) = nanmean(SDF(slow_correct_missed_dead,:));
    allwf.slow_errors_missed_dead(file,:) = nanmean(SDF(slow_errors_missed_dead,:));
    allwf.slow_all_made_dead(file,:) = nanmean(SDF(slow_all_made_dead,:));
    allwf.slow_all_missed_dead(file,:) = nanmean(SDF(slow_all_missed_dead,:));
    allwf.slow_correct_all(file,:) = nanmean(SDF(slow_correct_made_missed,:));
    allwf.slow_errors_all(file,:) = nanmean(SDF(slow_errors_made_missed,:));
    
    allwf.fast_correct_made_dead(file,:) = nanmean(SDF(fast_correct_made_dead_withCleared,:));
    allwf.fast_errors_made_dead(file,:) = nanmean(SDF(fast_errors_made_dead_withCleared,:));
    allwf.fast_correct_missed_dead(file,:) = nanmean(SDF(fast_correct_missed_dead_withCleared,:));
    allwf.fast_errors_missed_dead(file,:) = nanmean(SDF(fast_errors_missed_dead_withCleared,:));
    allwf.fast_all_made_dead(file,:) = nanmean(SDF(fast_all_made_dead_withCleared,:));
    allwf.fast_all_missed_dead(file,:) = nanmean(SDF(fast_all_missed_dead_withCleared,:));
    allwf.fast_correct_all(file,:) = nanmean(SDF(fast_correct_made_missed_withCleared,:));
    allwf.fast_errors_all(file,:) = nanmean(SDF(fast_errors_made_missed_withCleared,:));
    
    try
        allwf.med_correct(file,:) = nanmean(SDF(med_correct,:));
        allwf.med_errors(file,:) = nanmean(SDF(med_errors,:));
        allwf.med_all(file,:) = nanmean(SDF([med_correct ; med_errors],:));
    catch
        allwf.med_correct(file,:) = NaN;
        allwf.med_errors(file,:) = NaN;
        allwf.med_all(file,:) = NaN;
        
    end
    allwf.slow_all(file,:) = nanmean(SDF(slow_all,:));
    allwf.fast_all(file,:) = nanmean(SDF(fast_all_withCleared,:));
    
    
    basewf.slow_correct_made_dead(file,:) = nanmean(baseSDF(slow_correct_made_dead,:));
    basewf.slow_errors_made_dead(file,:) = nanmean(baseSDF(slow_errors_made_dead,:));
    basewf.slow_correct_missed_dead(file,:) = nanmean(baseSDF(slow_correct_missed_dead,:));
    basewf.slow_errors_missed_dead(file,:) = nanmean(baseSDF(slow_errors_missed_dead,:));
    basewf.slow_all_made_dead(file,:) = nanmean(baseSDF(slow_all_made_dead,:));
    basewf.slow_all_missed_dead(file,:) = nanmean(baseSDF(slow_all_missed_dead,:));
    basewf.slow_correct_all(file,:) = nanmean(baseSDF(slow_correct_made_missed,:));
    basewf.slow_errors_all(file,:) = nanmean(baseSDF(slow_errors_made_missed,:));
    
    basewf.fast_correct_made_dead(file,:) = nanmean(baseSDF(fast_correct_made_dead_withCleared,:));
    basewf.fast_errors_made_dead(file,:) = nanmean(baseSDF(fast_errors_made_dead_withCleared,:));
    basewf.fast_correct_missed_dead(file,:) = nanmean(baseSDF(fast_correct_missed_dead_withCleared,:));
    basewf.fast_errors_missed_dead(file,:) = nanmean(baseSDF(fast_errors_missed_dead_withCleared,:));
    basewf.fast_all_made_dead(file,:) = nanmean(baseSDF(fast_all_made_dead_withCleared,:));
    basewf.fast_all_missed_dead(file,:) = nanmean(baseSDF(fast_all_missed_dead_withCleared,:));
    basewf.fast_correct_all(file,:) = nanmean(baseSDF(fast_correct_made_missed_withCleared,:));
    basewf.fast_errors_all(file,:) = nanmean(baseSDF(fast_errors_made_missed_withCleared,:));
    
    basewf.med_correct(file,:) = nanmean(baseSDF(med_correct,:));
    basewf.med_errors(file,:) = nanmean(baseSDF(med_errors,:));
    basewf.med_all(file,:) = nanmean(baseSDF([med_correct ; med_errors],:));
    
    basewf.slow_all(file,:) = nanmean(baseSDF(slow_all,:));
    basewf.fast_all(file,:) = nanmean(baseSDF(fast_all_withCleared,:));
    
    
    [~,issig.made_dead(file,1)] = ttest2(nanmean(baseSDF(slow_correct_made_dead,:),2),nanmean(baseSDF(fast_correct_made_dead_withCleared,:),2));
    
    keep filename unit file basewf allwf RTs normalizeSDF issig block_switchSDF include_med
    
end

%FAST vs SLOW MADE DEADLINES
baseslow_made = nanmean(basewf.slow_correct_made_dead,2);
basemed = nanmean(basewf.med_correct,2);
basefast_made = nanmean(basewf.fast_correct_made_dead,2);

%FAST VS SLOW MISSED DEADLINES
baseslow_missed = nanmean(basewf.slow_correct_missed_dead,2);
basefast_missed = nanmean(basewf.fast_correct_missed_dead,2);

%FAST VS SLOW CORRECT + ERROR MADE + MISSED DEADLINES
baseslow_all_made_missed = nanmean(basewf.slow_all,2);
basefast_all_made_missed = nanmean(basewf.fast_all,2);

%Find which are Q and which are S
Q = 1:find(cell2mat(strfind(filename,'Q')),1,'last');
S = find(cell2mat(strfind(filename,'Q')),1,'last')+1:length(filename);

% figure
% subplot(2,2,1)
% scatter(baseslow_made(Q),basefast_made(Q),'k')
% hold on
% scatter(baseslow_made(S),basefast_made(S),'k','filled')
% ylim([0 1]);
% xlim([0 1]);
% dline
% xlabel('Normalized Baseline Slow')
% ylabel('Normalized Baseline Fast')
% title('Correct Made Deadlines')
% 
% 
% 
% subplot(2,2,2)
% scatter(baseslow_missed(Q),basefast_missed(Q),'k')
% hold on
% scatter(baseslow_missed(S),basefast_missed(S),'k','filled')
% ylim([0 1]);
% xlim([0 1]);
% dline
% xlabel('Normalized Baseline Slow')
% ylabel('Normalized Baseline Fast')
% title('Correct Missed Deadlines')


% figure
% 
% subplot(2,2,1)
% scatter(baseslow_all_made_missed(Q),basefast_all_made_missed(Q),'k')
% hold on
% scatter(baseslow_all_made_missed(S),basefast_all_made_missed(S),'k','filled')
% ylim([0 1]);
% xlim([0 1]);
% dline
% xlabel('Normalized Baseline Slow')
% ylabel('Normalized Baseline Fast')
% title('Correct + Error Made + Missed Deadlines')


% Stacked histogram of baseline differences
dif = basefast_made - baseslow_made;
issig.made_dead(1:length(dif),2) = 0;
issig.made_dead(find(issig.made_dead(:,1) < .05),2) = 1;
x = dif(find(issig.made_dead(:,2) == 1));
y = dif(find(issig.made_dead(:,2) == 0));
[a b] = histc(x,-.3:.04:.3);
[c d] = histc(y,-.3:.04:.3);

sigpos = find(dif > 0 & issig.made_dead(:,2) == 1);
signeg = find(dif < 0 & issig.made_dead(:,2) == 1);
signot = find(issig.made_dead(:,2) == 0);

figure
bar(-.3:.04:.3,[a  c],'stacked')



sems.slow_correct_made_dead = sem(allwf.slow_correct_made_dead(sigpos,:));
sems.med_correct = sem(allwf.med_correct(sigpos,:));
sems.fast_correct_made_dead = sem(allwf.fast_correct_made_dead(sigpos,:));

figure
subplot(2,2,1)
plot(-400:800,nanmean(allwf.slow_correct_made_dead(sigpos,:)),'r', ...
    -400:800,nanmean(allwf.med_correct(sigpos,:)),'k', ...
    -400:800,nanmean(allwf.fast_correct_made_dead(sigpos,:)),'g')
%     -400:800,nanmean(allwf.slow_correct_made_dead(sigpos,:)) - sems.slow_correct_made_dead,'r', ...
%     -400:800,nanmean(allwf.slow_correct_made_dead(sigpos,:)) + sems.slow_correct_made_dead,'r', ...
%     -400:800,nanmean(allwf.med_correct(sigpos,:)) - sems.med_correct,'k', ...
%     -400:800,nanmean(allwf.med_correct(sigpos,:)) + sems.med_correct,'k', ...
%     -400:800,nanmean(allwf.fast_correct_made_dead(sigpos,:)) - sems.fast_correct_made_dead,'g', ...
%     -400:800,nanmean(allwf.fast_correct_made_dead(sigpos,:)) + sems.fast_correct_made_dead,'g')
title('Significantly Positive')
box off
xlim([-400 200])
set(gca,'xminortick','on')

subplot(2,2,2)

plot(-400:800,nanmean(allwf.slow_correct_made_dead(signot,:)),'r', ...
    -400:800,nanmean(allwf.med_correct(signot,:)),'k', ...
    -400:800,nanmean(allwf.fast_correct_made_dead(signot,:)),'g')
title('Not Significant')
box off
xlim([-400 200])
set(gca,'xminortick','on')

subplot(2,2,3)

plot(-400:800,nanmean(allwf.slow_correct_made_dead(signeg,:)),'r', ...
    -400:800,nanmean(allwf.med_correct(signeg,:)),'k', ...
    -400:800,nanmean(allwf.fast_correct_made_dead(signeg,:)),'g')
title('Significantly Negative')
box off
xlim([-400 200])
set(gca,'xminortick','on')


%restructure block_switch so that it goes +- mean


correction = mean([block_switchSDF.fast_to_slow block_switchSDF.slow_to_fast],2);
cblock_switchSDF.fast_to_slow = block_switchSDF.fast_to_slow - repmat(correction,1,5);
cblock_switchSDF.slow_to_fast = block_switchSDF.slow_to_fast - repmat(correction,1,5);


correction_withMed = mean([block_switchSDF.fast_to_slow block_switchSDF.slow_to_fast ...
    block_switchSDF.slow_to_med block_switchSDF.med_to_fast]);
cblock_switchSDF_withMed.fast_to_slow = block_switchSDF.fast_to_slow - repmat(correction,1,5);
cblock_switchSDF_withMed.slow_to_fast = block_switchSDF.slow_to_fast - repmat(correction,1,5);
cblock_switchSDF_withMed.slow_to_med = block_switchSDF.slow_to_med - repmat(correction,1,5);
cblock_switchSDF_withMed.med_to_fast = block_switchSDF.med_to_fast - repmat(correction,1,5);



figure
subplot(2,2,1)
plot(-2:2,cblock_switchSDF.fast_to_slow(sigpos,:),'r',-2:2,cblock_switchSDF.slow_to_fast(sigpos,:),'g', ...
    -2:2,nanmean(cblock_switchSDF.fast_to_slow(sigpos,:)),'--k',-2:2,nanmean(cblock_switchSDF.slow_to_fast(sigpos,:)),'k')
box off
title('Significantly Positive')

subplot(2,2,2)
plot(-2:2,cblock_switchSDF.fast_to_slow(signot,:),'r',-2:2,cblock_switchSDF.slow_to_fast(signot,:),'g')
box off
title('Not Significant')

subplot(2,2,3)
plot(-2:2,cblock_switchSDF.fast_to_slow(signeg,:),'r',-2:2,cblock_switchSDF.slow_to_fast(signeg,:),'g')
box off
title('Significantly Negative')


figure
subplot(2,2,1)
plot(-2:2,nanmean(block_switchSDF.fast_to_slow(sigpos,:)),'r',-2:2,nanmean(block_switchSDF.slow_to_fast(sigpos,:)),'g')
box off
title('Significantly Positive')

subplot(2,2,2)
plot(-2:2,nanmean(block_switchSDF.fast_to_slow(signot,:)),'r',-2:2,nanmean(block_switchSDF.slow_to_fast(signot,:)),'g')
box off
title('Not Significant')

subplot(2,2,3)
plot(-2:2,nanmean(block_switchSDF.fast_to_slow(signeg,:)),'r',-2:2,nanmean(block_switchSDF.slow_to_fast(signeg,:)),'g')
box off
title('Significantly Negative')