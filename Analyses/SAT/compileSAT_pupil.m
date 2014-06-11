cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT2_Beh_NoMed_D.txt','%s');
[filename2] = textread('SAT2_Beh_NoMed_E.txt','%s');

filename = [filename1 ; filename2];

%[filename] = textread('SAT2_Beh_NoMed_D.txt','%s');


for file = 1:length(filename)
    
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_','Correct_','TrialStart_','Pupil_')
    filename{file}
    
    %============
    % FIND TRIALS
    %===================================================================
    if exist('SRT') == 0
        SRT = getSRT(EyeX_,EyeY_);
    end
    
    trunc_RT = 2000;
    getTrials_SAT
    

    %Compute pupil
    Pupil_bc = baseline_correct(Pupil_,[2750 2760]);
   
    
    allPupil.slow(file,:) = nanmean(Pupil_bc(slow_all,:));
    allPupil.fast(file,:) = nanmean(Pupil_bc(fast_all_withCleared,:));
    
%     base_slow = nanmean(nanmean(Pupil_(slow_all,2750:2760),2));
%     base_fast = nanmean(nanmean(Pupil_(fast_all_withCleared,2750:2760),2));
%     allPupil_percent.slow(file,:) = (nanmean(Pupil_(slow_all,:)) - base_slow) ./ base_slow;
%     allPupil_percent.fast(file,:) = (nanmean(Pupil_(fast_all_withCleared,:)) - base_fast) ./ base_fast;
%     
    file_list{file,1} = filename;
    
    keep filename file file_list allPupil*
    
end

sems.slow = sem(nanmean(allPupil.slow));
sems.fast = sem(nanmean(allPupil.fast));

figure
plot(-3500:2500,nanmean(allPupil.slow),'r', ...
    -3500:2500,nanmean(allPupil.fast),'g')
xlim([-800 200])
box off

