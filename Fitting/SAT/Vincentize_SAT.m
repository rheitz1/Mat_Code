%Returns summed BIC values across a population for a given DDM model
cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1] = textread('SAT_Beh_Med_Q.txt','%s');
%[filename2] = textread('SAT_Beh_NoMed_Q.txt','%s');
[filename3] = textread('SAT_Beh_Med_S.txt','%s');
%[filename4] = textread('SAT_Beh_NoMed_S.txt','%s');
filename = [filename1 ; filename3];


truncate_IQR = 1;
truncval = 1.5;
%truncval = 3;
include_med = 1;

trls.slow.correct = [];
trls.slow.errors = [];
trls.fast.correct = [];
trls.fast.errors = [];

if include_med
    trls.med.correct = [];
    trls.med.errors = [];
end

% individual session fits
for file = 1:length(filename)
    
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_')
    filename{file}
    
    getTrials_SAT
    
    mean_deadline.fast(file,1) = nanmean(SAT_(find(SAT_(:,1) == 3),3));
    mean_deadline.slow(file,1) = nanmean(SAT_(find(SAT_(:,1) == 1),3));
    sd_deadline.fast(file,1) = nanstd(SAT_(find(SAT_(:,1) == 3),3));
    sd_deadline.slow(file,1) = nanstd(SAT_(find(SAT_(:,1) == 1),3));
    
    if truncate_IQR
        disp(['Truncating ' mat2str(truncval) ' * IQR'])
        highcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) + truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
        lowcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) - truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
        highcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) + truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
        lowcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
        
        
        %All correct trials w/ made deadlines
        slow_correct_made_dead = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        fast_correct_made_dead_withCleared = intersect(fast_correct_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        slow_errors_made_dead = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
        fast_errors_made_dead_withCleared = intersect(fast_errors_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
        
        %keep track of total N for calculating AIC/BIC for MLE models
        N.all = numel([slow_correct_made_dead ; slow_errors_made_dead ; fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared]);
        if include_med
            highcut_med = nanmedian(SRT([med_correct ; med_errors],1)) + truncval * iqr(SRT([med_correct ; med_errors],1));
            lowcut_med = nanmedian(SRT([med_correct ; med_errors],1)) - truncval * iqr(SRT([med_correct ; med_errors],1));
            
            med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
            med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
            
            N.all = N.all + numel([med_correct ; med_errors]);
            
        end
        
        all_highcut.slow(file,1) = highcut_slow;
        all_highcut.med(file,1) = highcut_med;
        all_highcut.fast(file,1) = highcut_fast;
        all_lowcut.slow(file,1) = lowcut_slow;
        all_lowcut.med(file,1) = lowcut_med;
        all_lowcut.fast(file,1) = lowcut_fast;
        
    end
    
    
    
    %keep track of all trials. in the calc_X2 script, this is really only used for counting the N's. This
    %should be changed later
    trls.slow.correct = [trls.slow.correct ; slow_correct_made_dead];
    trls.slow.errors = [trls.slow.errors ; slow_errors_made_dead];
    trls.fast.correct = [trls.fast.correct ; fast_correct_made_dead_withCleared];
    trls.fast.errors = [trls.fast.errors ; fast_errors_made_dead_withCleared];
    
    if include_med
        trls.med.correct = [trls.med.correct ; med_correct];
        trls.med.errors = [trls.med.errors ; med_errors];
    end
    
    
    nts = [10 ; 30 ; 50 ; 70 ; 90 ; 100]; %last ntile (100) is just for plotting; is the max value
    all_ntiles.slow_correct_made_dead(file,:) = prctile(SRT(slow_correct_made_dead,1),nts);
    all_ntiles.slow_errors_made_dead(file,:) = prctile(SRT(slow_errors_made_dead,1),nts);
    
    
    all_ntiles.fast_correct_made_dead_withCleared(file,:) = prctile(SRT(fast_correct_made_dead_withCleared,1),nts);
    all_ntiles.fast_errors_made_dead_withCleared(file,:) = prctile(SRT(fast_errors_made_dead_withCleared,1),nts);
    
    if include_med
        all_ntiles.med_correct(file,:) = prctile(SRT(med_correct,1),nts);
        all_ntiles.med_errors(file,:) = prctile(SRT(med_errors,1),nts);
    end
    
    %     clear slow_correct_made_dead slow_errors_made_dead med_correct med_errors ...
    %         fast_correct_made_dead_withCleared fast_errors_made_dead_withCleared
    
    keep filename include_med file all_ntiles trls truncate_IQR truncval fr fx plotFlag mean_deadline sd_deadline all_highcut all_lowcut
    
end

%VINCENT AVERAGE
ntiles.slow.correct = nanmean(all_ntiles.slow_correct_made_dead)';
ntiles.slow.errors = nanmean(all_ntiles.slow_errors_made_dead)';
ntiles.fast.correct = nanmean(all_ntiles.fast_correct_made_dead_withCleared)';
ntiles.fast.errors = nanmean(all_ntiles.fast_errors_made_dead_withCleared)';

if include_med
    ntiles.med.correct = nanmean(all_ntiles.med_correct)';
    ntiles.med.errors = nanmean(all_ntiles.med_errors)';
end

clear all_ntiles

nl = .1 * length(trls.slow.correct);
nh = .2 * length(trls.slow.correct);
obs_freq.slow.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.slow.errors);
nh = .2 * length(trls.slow.errors);
obs_freq.slow.errors = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.fast.correct);
nh = .2 * length(trls.fast.correct);
obs_freq.fast.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.fast.errors);
nh = .2 * length(trls.fast.errors);
obs_freq.fast.errors = [nl nh nh nh nh nl];
clear nl nh

if include_med
    nl = .1 * length(trls.med.correct);
    nh = .2 * length(trls.med.correct);
    obs_freq.med.correct = [nl nh nh nh nh nl];
    clear nl nh
    
    
    nl = .1 * length(trls.med.errors);
    nh = .2 * length(trls.med.errors);
    obs_freq.med.errors = [nl nh nh nh nh nl];
    clear nl nh
end

clear truncate_IQR truncval include_med file filename