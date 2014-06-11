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
    load(filename{file},'Target_','SRT','SAT_','Correct_','Errors_','EyeX_','EyeY_','newfile')
    filename{file}
    
    fixAcq = getFixAcquire(EyeX_,EyeY_);
    
    sig = eval(unit{file});
    
    RF = RFs.(unit{file});
    
    antiRF = mod((RF+4),8);
    
    
    %get block switch baseline effect
    [SDF_switch] = block_switch(unit{file},0);
    
    block_switchSDF.fast_to_slow(file,:) = SDF_switch.fast_to_slow;
    block_switchSDF.slow_to_fast(file,:) = SDF_switch.slow_to_fast;
    block_switchSDF.slow_to_med(file,:) = SDF_switch.slow_to_med;
    block_switchSDF.med_to_fast(file,:) = SDF_switch.med_to_fast;
    
    
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
    
    
    SDF = sSDF(sig,fixAcq+2500,[-400 800]);
    
%     if normalizeSDF == 1
%         SDF = normalize_SP(SDF);
%     end
    

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
    
    keep filename unit file basewf allwf RTs normalizeSDF issig block_switchSDF
    
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



figure
subplot(2,2,1)
plot(-400:800,nanmean(allwf.slow_correct_made_dead(sigpos,:)),'r', ...
    -400:800,nanmean(allwf.med_correct(sigpos,:)),'k', ...
    -400:800,nanmean(allwf.fast_correct_made_dead(sigpos,:)),'g')
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