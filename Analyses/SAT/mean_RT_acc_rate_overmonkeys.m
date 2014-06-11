cd ~/desktop/Mat_Code/Analyses/SAT/
 [filename1] = textread('SAT_Beh_Med_Q.txt','%s');
 [filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
 filename = [filename1 ; filename2];


% [filename1] = textread('SAT2_Beh_NoMed_D.txt','%s');
% filename = [filename1];

for file = 1:length(filename)
    
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_','Correct_')
    filename{file}
    
    %============
    % FIND TRIALS
    %===================================================================
    if exist('SRT') == 0
        SRT = getSRT(EyeX_,EyeY_);
    end
    
    trunc_RT = 2000;
    getTrials_SAT
   
    
    
    %====================
    % Calculate ACC rates
    %percentage of CORRECT trials that missed the deadline
    prc_missed_Q.slow_correct(file,1) = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
    prc_missed_Q.fast_correct_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / (length(fast_correct_made_dead_withCleared) + length(fast_correct_missed_dead_withCleared));
    prc_missed_Q.fast_correct_noCleared(file,1) = length(fast_correct_missed_dead_noCleared) / (length(fast_correct_made_dead_noCleared) + length(fast_correct_missed_dead_noCleared));
    
    %ACC rate for made deadlines
    ACC_Q.slow_made_dead(file,1) = 1 - (length(slow_correct_made_dead) / length(slow_all_made_dead));
    ACC_Q.fast_made_dead_withCleared(file,1) = 1 - (length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared));
    ACC_Q.fast_made_dead_noCleared(file,1) = 1 - (length(fast_correct_made_dead_noCleared) / length(fast_all_made_dead_noCleared));
    
    
    %ACC rate for missed deadlines
    ACC_Q.slow_missed_dead(file,1) = 1 - (length(slow_correct_missed_dead) / length(slow_all_missed_dead));
    ACC_Q.fast_missed_dead_withCleared(file,1) = 1 - (length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared));
    ACC_Q.fast_missed_dead_noCleared(file,1) = 1 - (length(fast_correct_missed_dead_noCleared) / length(fast_all_missed_dead_noCleared));
    
    
    %overall ACC rate for made + missed deadlines
    ACC_Q.slow_made_missed(file,1) = 1 - (length(slow_correct_made_missed) / length(slow_all));
    ACC_Q.fast_made_missed_withCleared(file,1) = 1 - (length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared));
    ACC_Q.fast_made_missed_noCleared(file,1) = 1 - (length(fast_correct_made_missed_noCleared) / length(fast_all_noCleared));
    
    ACC_Q.med(file,1) = 1 - (length(med_correct) / length(med_all));
    
    
    RTs_Q.slow_correct_made_dead(file,1) = nanmean(SRT(slow_correct_made_dead,1));
    RTs_Q.med_correct(file,1) = nanmean(SRT(med_correct,1));
    RTs_Q.fast_correct_made_dead_withCleared(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared,1));
    RTs_Q.fast_correct_made_dead_noCleared(file,1) = nanmean(SRT(fast_correct_made_dead_noCleared,1));
    
    RTs_Q.slow_errors_made_dead(file,1) = nanmean(SRT(slow_errors_made_dead,1));
    RTs_Q.med_errors(file,1) = nanmean(SRT(med_errors,1));
    RTs_Q.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(fast_errors_made_dead_withCleared,1));
    RTs_Q.fast_errors_made_dead_noCleared(file,1) = nanmean(SRT(fast_errors_made_dead_noCleared,1));
    
    RTs_Q.slow_correct_missed_dead(file,1) = nanmean(SRT(slow_correct_missed_dead,1));
    RTs_Q.med_correct(file,1) = nanmean(SRT(med_correct,1));
    RTs_Q.fast_correct_missed_dead_withCleared(file,1) = nanmean(SRT(fast_correct_missed_dead_withCleared,1));
    RTs_Q.fast_correct_missed_dead_noCleared(file,1) = nanmean(SRT(fast_correct_missed_dead_noCleared,1));
    
    RTs_Q.slow_errors_missed_dead(file,1) = nanmean(SRT(slow_errors_missed_dead,1));
    RTs_Q.med_errors(file,1) = nanmean(SRT(med_errors,1));
    RTs_Q.fast_errors_missed_dead_withCleared(file,1) = nanmean(SRT(fast_errors_missed_dead_withCleared,1));
    RTs_Q.fast_errors_missed_dead_noCleared(file,1) = nanmean(SRT(fast_errors_missed_dead_noCleared,1));
    
    
    CDFtemp_slow = getDefectiveCDF(slow_correct_made_dead,slow_errors_made_dead);
    CDFtemp_med = getDefectiveCDF(med_correct,med_errors);
    CDFtemp_fast = getDefectiveCDF(fast_correct_made_dead_withCleared,fast_errors_made_dead_withCleared);
    
    CDF_Q.slow.correct(:,1:2,file) = CDFtemp_slow.correct;
    CDF_Q.slow.err(:,1:2,file) = CDFtemp_slow.err;
    CDF_Q.med.correct(:,1:2,file) = CDFtemp_med.correct;
    CDF_Q.med.err(:,1:2,file) = CDFtemp_med.err;
    CDF_Q.fast.correct(:,1:2,file) = CDFtemp_fast.correct;
    CDF_Q.fast.err(:,1:2,file) = CDFtemp_fast.err;
    
    file_list{file,1} = filename;
    
    keep filename file ACC* RTs* CDF_* file_list prc_missed*
    
end





 [filename1] = textread('SAT_Beh_Med_S.txt','%s');
 [filename2] = textread('SAT_Beh_NoMed_S.txt','%s');
 filename = [filename1 ; filename2];

%[filename1] = textread('SAT2_Beh_NoMed_E.txt','%s');
%filename = [filename1];

for file = 1:length(filename)
    
    load(filename{file},'Correct_','RFs','MFs','Target_','SRT','SAT_','Errors_','Correct_')
    filename{file}
    
    %============
    % FIND TRIALS
    %===================================================================
    getTrials_SAT
    
    %====================
    % Calculate ACC rates
    %percentage of CORRECT trials that missed the deadline
    prc_missed_S.slow_correct(file,1) = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
    prc_missed_S.fast_correct_withCleared(file,1) = length(fast_correct_missed_dead_withCleared) / (length(fast_correct_made_dead_withCleared) + length(fast_correct_missed_dead_withCleared));
    prc_missed_S.fast_correct_noCleared(file,1) = length(fast_correct_missed_dead_noCleared) / (length(fast_correct_made_dead_noCleared) + length(fast_correct_missed_dead_noCleared));
    
    %ACC rate for made deadlines
    ACC_S.slow_made_dead(file,1) = 1 - (length(slow_correct_made_dead) / length(slow_all_made_dead));
    ACC_S.fast_made_dead_withCleared(file,1) = 1 - (length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared));
    ACC_S.fast_made_dead_noCleared(file,1) = 1 - (length(fast_correct_made_dead_noCleared) / length(fast_all_made_dead_noCleared));
    
    
    %ACC rate for missed deadlines
    ACC_S.slow_missed_dead(file,1) = 1 - (length(slow_correct_missed_dead) / length(slow_all_missed_dead));
    ACC_S.fast_missed_dead_withCleared(file,1) = 1 - (length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared));
    ACC_S.fast_missed_dead_noCleared(file,1) = 1 - (length(fast_correct_missed_dead_noCleared) / length(fast_all_missed_dead_noCleared));
    
    
    %overall ACC rate for made + missed deadlines
    ACC_S.slow_made_missed(file,1) = 1 - (length(slow_correct_made_missed) / length(slow_all));
    ACC_S.fast_made_missed_withCleared(file,1) = 1 - (length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared));
    ACC_S.fast_made_missed_noCleared(file,1) = 1 - (length(fast_correct_made_missed_noCleared) / length(fast_all_noCleared));
    
    ACC_S.med(file,1) = 1 - (length(med_correct) / length(med_all));
    
    
    RTs_S.slow_correct_made_dead(file,1) = nanmean(SRT(slow_correct_made_dead,1));
    RTs_S.med_correct(file,1) = nanmean(SRT(med_correct,1));
    RTs_S.fast_correct_made_dead_withCleared(file,1) = nanmean(SRT(fast_correct_made_dead_withCleared,1));
    RTs_S.fast_correct_made_dead_noCleared(file,1) = nanmean(SRT(fast_correct_made_dead_noCleared,1));
    
    RTs_S.slow_errors_made_dead(file,1) = nanmean(SRT(slow_errors_made_dead,1));
    RTs_S.med_errors(file,1) = nanmean(SRT(med_errors,1));
    RTs_S.fast_errors_made_dead_withCleared(file,1) = nanmean(SRT(fast_errors_made_dead_withCleared,1));
    RTs_S.fast_errors_made_dead_noCleared(file,1) = nanmean(SRT(fast_errors_made_dead_noCleared,1));
    
    
    RTs_S.slow_correct_missed_dead(file,1) = nanmean(SRT(slow_correct_missed_dead,1));
    RTs_S.med_correct(file,1) = nanmean(SRT(med_correct,1));
    RTs_S.fast_correct_missed_dead_withCleared(file,1) = nanmean(SRT(fast_correct_missed_dead_withCleared,1));
    RTs_S.fast_correct_missed_dead_noCleared(file,1) = nanmean(SRT(fast_correct_missed_dead_noCleared,1));
    
    RTs_S.slow_errors_missed_dead(file,1) = nanmean(SRT(slow_errors_missed_dead,1));
    RTs_S.med_errors(file,1) = nanmean(SRT(med_errors,1));
    RTs_S.fast_errors_missed_dead_withCleared(file,1) = nanmean(SRT(fast_errors_missed_dead_withCleared,1));
    RTs_S.fast_errors_missed_dead_noCleared(file,1) = nanmean(SRT(fast_errors_missed_dead_noCleared,1));
    
    
    CDFtemp_slow = getDefectiveCDF(slow_correct_made_dead,slow_errors_made_dead);
    CDFtemp_med = getDefectiveCDF(med_correct,med_errors);
    CDFtemp_fast = getDefectiveCDF(fast_correct_made_dead_withCleared,fast_errors_made_dead_withCleared);
    
    CDF_S.slow.correct(:,1:2,file) = CDFtemp_slow.correct;
    CDF_S.slow.err(:,1:2,file) = CDFtemp_slow.err;
    CDF_S.med.correct(:,1:2,file) = CDFtemp_med.correct;
    CDF_S.med.err(:,1:2,file) = CDFtemp_med.err;
    CDF_S.fast.correct(:,1:2,file) = CDFtemp_fast.correct;
    CDF_S.fast.err(:,1:2,file) = CDFtemp_fast.err;
    
    file_list{file,1} = filename;
    
    keep filename file ACC* RTs* CDF_* file_list prc_missed*
    
end


% MEANS AND SEM
meanRT_Q.slow_correct_made_dead = nanmean(RTs_Q.slow_correct_made_dead);
meanRT_Q.slow_correct_missed_dead = nanmean(RTs_Q.slow_correct_missed_dead);
meanRT_Q.med_correct = nanmean(RTs_Q.med_correct);
meanRT_Q.fast_correct_made_dead = nanmean(RTs_Q.fast_correct_made_dead_withCleared);
meanRT_Q.fast_correct_missed_dead = nanmean(RTs_Q.fast_correct_missed_dead_withCleared);

meanACC_Q.slow_made_dead = nanmean(ACC_Q.slow_made_dead);
meanACC_Q.slow_missed_dead = nanmean(ACC_Q.slow_missed_dead);
meanACC_Q.med = nanmean(ACC_Q.med);
meanACC_Q.fast_made_dead = nanmean(ACC_Q.fast_made_dead_withCleared);
meanACC_Q.fast_missed_dead = nanmean(ACC_Q.fast_missed_dead_withCleared);

meanPrcMissed_Q.slow = nanmean(prc_missed_Q.slow_correct);
meanPrcMissed_Q.fast = nanmean(prc_missed_Q.fast_correct_withCleared);

semRT_Q.slow_correct_made_dead = sem(RTs_Q.slow_correct_made_dead);
semRT_Q.slow_correct_missed_dead = sem(RTs_Q.slow_correct_missed_dead);
semRT_Q.med_correct = sem(RTs_Q.med_correct);
semRT_Q.fast_correct_made_dead = sem(RTs_Q.fast_correct_made_dead_withCleared);
semRT_Q.fast_correct_missed_dead = sem(RTs_Q.fast_correct_missed_dead_withCleared);

semACC_Q.slow_made_dead = sem(ACC_Q.slow_made_dead);
semACC_Q.slow_missed_dead = sem(ACC_Q.slow_missed_dead);
semACC_Q.med = sem(ACC_Q.med);
semACC_Q.fast_made_dead = sem(ACC_Q.fast_made_dead_withCleared);
semACC_Q.fast_missed_dead = sem(ACC_Q.fast_missed_dead_withCleared);

semPrcMissed_Q.slow = sem(prc_missed_Q.slow_correct);
semPrcMissed_Q.fast = sem(prc_missed_Q.fast_correct_withCleared);

%=======
meanRT_S.slow_correct_made_dead = nanmean(RTs_S.slow_correct_made_dead);
meanRT_S.slow_correct_missed_dead = nanmean(RTs_S.slow_correct_missed_dead);
meanRT_S.med_correct = nanmean(RTs_S.med_correct);
meanRT_S.fast_correct_made_dead = nanmean(RTs_S.fast_correct_made_dead_withCleared);
meanRT_S.fast_correct_missed_dead = nanmean(RTs_S.fast_correct_missed_dead_withCleared);
 
meanACC_S.slow_made_dead = nanmean(ACC_S.slow_made_dead);
meanACC_S.slow_missed_dead = nanmean(ACC_S.slow_missed_dead);
meanACC_S.med = nanmean(ACC_S.med);
meanACC_S.fast_made_dead = nanmean(ACC_S.fast_made_dead_withCleared);
meanACC_S.fast_missed_dead = nanmean(ACC_S.fast_missed_dead_withCleared);
 
meanPrcMissed_S.slow = nanmean(prc_missed_S.slow_correct);
meanPrcMissed_S.fast = nanmean(prc_missed_S.fast_correct_withCleared);
 
semRT_S.slow_correct_made_dead = sem(RTs_S.slow_correct_made_dead);
semRT_S.slow_correct_missed_dead = sem(RTs_S.slow_correct_missed_dead);
semRT_S.med_correct = sem(RTs_S.med_correct);
semRT_S.fast_correct_made_dead = sem(RTs_S.fast_correct_made_dead_withCleared);
semRT_S.fast_correct_missed_dead = sem(RTs_S.fast_correct_missed_dead_withCleared);
 
semACC_S.slow_made_dead = sem(ACC_S.slow_made_dead);
semACC_S.slow_missed_dead = sem(ACC_S.slow_missed_dead);
semACC_S.med = sem(ACC_S.med);
semACC_S.fast_made_dead = sem(ACC_S.fast_made_dead_withCleared);
semACC_S.fast_missed_dead = sem(ACC_S.fast_missed_dead_withCleared);
 
semPrcMissed_S.slow = sem(prc_missed_S.slow_correct);
semPrcMissed_S.fast = sem(prc_missed_S.fast_correct_withCleared);



figure
subplot(2,2,1) %use so that can be more easily made same size as all other plots
errorbar([meanRT_Q.slow_correct_made_dead meanRT_Q.med_correct meanRT_Q.fast_correct_made_dead], ...
    [semRT_Q.slow_correct_made_dead semRT_Q.med_correct semRT_Q.fast_correct_made_dead],'-ok','markersize',6)
hold on
errorbar([meanRT_S.slow_correct_made_dead meanRT_S.med_correct meanRT_S.fast_correct_made_dead], ...
    [semRT_S.slow_correct_made_dead semRT_S.med_correct semRT_S.fast_correct_made_dead],'-ok','markerfacecolor','k','markersize',6)
ylim([0 700])
xlim([.5 3.5])
box off

newax
errorbar([meanACC_Q.slow_made_dead meanACC_S.slow_made_dead ; meanACC_Q.med meanACC_S.med ; meanACC_Q.fast_made_dead meanACC_S.fast_made_dead], ...
    [semACC_Q.slow_made_dead semACC_S.slow_made_dead ; semACC_Q.med semACC_S.med ; semACC_Q.fast_made_dead semACC_S.fast_made_dead])
hold on
bar([meanACC_Q.slow_made_dead meanACC_S.slow_made_dead ; meanACC_Q.med meanACC_S.med ; meanACC_Q.fast_made_dead meanACC_S.fast_made_dead])
ylim([0 1.3])
xlim([.5 3.5])
set(gca,'xticklabel',[])
title('Made Dead Only')


 
 
figure
subplot(2,2,1) %use so that can be more easily made same size as all other plots
errorbar([meanRT_Q.slow_correct_missed_dead meanRT_Q.med_correct meanRT_Q.fast_correct_missed_dead], ...
    [semRT_Q.slow_correct_missed_dead semRT_Q.med_correct semRT_Q.fast_correct_missed_dead],'-ok','markersize',6)
hold on
errorbar([meanRT_S.slow_correct_missed_dead meanRT_S.med_correct meanRT_S.fast_correct_missed_dead], ...
    [semRT_S.slow_correct_missed_dead semRT_S.med_correct semRT_S.fast_correct_missed_dead],'-ok','markerfacecolor','k','markersize',6)
ylim([0 700])
xlim([.5 3.5])
box off
 
newax
errorbar([meanACC_Q.slow_missed_dead meanACC_S.slow_missed_dead ; meanACC_Q.med meanACC_S.med ; meanACC_Q.fast_missed_dead meanACC_S.fast_missed_dead], ...
    [semACC_Q.slow_missed_dead semACC_S.slow_missed_dead ; semACC_Q.med semACC_S.med ; semACC_Q.fast_missed_dead semACC_S.fast_missed_dead])
hold on
bar([meanACC_Q.slow_missed_dead meanACC_S.slow_missed_dead ; meanACC_Q.med meanACC_S.med ; meanACC_Q.fast_missed_dead meanACC_S.fast_missed_dead])
ylim([0 1.3])
xlim([.5 3.5])
set(gca,'xticklabel',[])
title('Missed Dead Only')






 
figure
subplot(2,2,1) %use so that can be more easily made same size as all other plots
errorbar([meanRT_Q.slow_correct_missed_dead  meanRT_Q.fast_correct_missed_dead], ...
    [semRT_Q.slow_correct_missed_dead semRT_Q.fast_correct_missed_dead],'-ok','markersize',6)
hold on
errorbar([meanRT_S.slow_correct_missed_dead meanRT_S.fast_correct_missed_dead], ...
    [semRT_S.slow_correct_missed_dead semRT_S.fast_correct_missed_dead],'-ok','markerfacecolor','k','markersize',6)
ylim([0 700])
xlim([.5 2.5])
box off
 
newax
errorbar([meanACC_Q.slow_missed_dead meanACC_S.slow_missed_dead ; meanACC_Q.fast_missed_dead meanACC_S.fast_missed_dead], ...
    [semACC_Q.slow_missed_dead semACC_S.slow_missed_dead ; semACC_Q.fast_missed_dead semACC_S.fast_missed_dead])
hold on
bar([meanACC_Q.slow_missed_dead meanACC_S.slow_missed_dead ; meanACC_Q.fast_missed_dead meanACC_S.fast_missed_dead])
ylim([0 1.3])
xlim([.5 2.5])
set(gca,'xticklabel',[])
title('Missed Dead Only')

