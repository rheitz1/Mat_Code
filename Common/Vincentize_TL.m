%Returns summed BIC values across a population for a given DDM model
cd /volumes/Dump/Search_Data/
filename = dir('Q*_SEARCH.mat');

truncate_IQR = 0;
truncval = 1.5;
%truncval = 3;
include_med = 1;

trls.ss2.correct = [];
trls.ss2.errors = [];
trls.ss4.correct = [];
trls.ss4.errors = [];
trls.ss8.correct = [];
trls.ss8.errors = [];

if include_med
    trls.med.correct = [];
    trls.med.errors = [];
end

% individual session fits
for file = 1:length(filename)
    
    load(filename(file).name,'Correct_','Target_','SRT','SAT_','Errors_')
    filename(file).name
    
    ss2.correct = find(Target_(:,5) == 2 & Correct_(:,2) == 1);
    ss4.correct = find(Target_(:,5) == 4 & Correct_(:,2) == 1);
    ss8.correct = find(Target_(:,5) == 8 & Correct_(:,2) == 1);
    
    ss2.errors = find(Target_(:,5) == 2 & Errors_(:,5) == 1);
    ss4.errors = find(Target_(:,5) == 4 & Errors_(:,5) == 1);
    ss8.errors = find(Target_(:,5) == 8 & Errors_(:,5) == 1);
    
    
    if truncate_IQR
        disp(['Truncating ' mat2str(truncval) ' * IQR'])
        highcut_ss2 = nanmedian(SRT([ss2.correct ; ss2.errors],1)) + truncval * iqr(SRT([ss2.correct ; ss2.errors],1));
        lowcut_ss2 = nanmedian(SRT([ss2.correct ; ss2.errors],1)) - truncval * iqr(SRT([ss2.correct ; ss2.errors],1));
        highcut_ss4 = nanmedian(SRT([ss4.correct ; ss4.errors],1)) + truncval * iqr(SRT([ss4.correct ; ss4.errors],1));
        lowcut_ss4 = nanmedian(SRT([ss4.correct ; ss4.errors],1)) - truncval * iqr(SRT([ss4.correct ; ss4.errors],1));
        highcut_ss8 = nanmedian(SRT([ss8.correct ; ss8.errors],1)) + truncval * iqr(SRT([ss8.correct ; ss8.errors],1));
        lowcut_ss8 = nanmedian(SRT([ss8.correct ; ss8.errors],1)) - truncval * iqr(SRT([ss8.correct ; ss8.errors],1));
        
        %All correct trials w/ made deadlines
        ss2.correct = intersect(ss2.correct,find(SRT(:,1) > lowcut_ss2 & SRT(:,1) < highcut_ss2));
        ss2.errors = intersect(ss2.errors,find(SRT(:,1) > lowcut_ss2 & SRT(:,1) < highcut_ss2));
        ss4.correct = intersect(ss4.correct,find(SRT(:,1) > lowcut_ss4 & SRT(:,1) < highcut_ss4));
        ss4.errors = intersect(ss4.errors,find(SRT(:,1) > lowcut_ss4 & SRT(:,1) < highcut_ss4));
        ss8.correct = intersect(ss8.correct,find(SRT(:,1) > lowcut_ss8 & SRT(:,1) < highcut_ss8));
        ss8.errors = intersect(ss8.errors,find(SRT(:,1) > lowcut_ss8 & SRT(:,1) < highcut_ss8));
        
    end
    
    
    
    %keep track of all trials. in the calc_X2 script, this is really only used for counting the N's. This
    %should be changed later
    trls.ss2.correct = [trls.ss2.correct ; ss2.correct];
    trls.ss2.errors = [trls.ss2.errors ; ss2.errors];
    trls.ss4.correct = [trls.ss4.correct ; ss4.correct];
    trls.ss4.errors = [trls.ss4.errors ; ss4.errors];
    trls.ss8.correct = [trls.ss8.correct ; ss8.correct];
    trls.ss8.errors = [trls.ss8.errors ; ss8.errors];
   
    
    nts = [10 ; 30 ; 50 ; 70 ; 90 ; 100];
    all_ntiles.ss2.correct(file,:) = prctile(SRT(ss2.correct,1),nts);
    all_ntiles.ss2.errors(file,:) = prctile(SRT(ss2.errors,1),nts);
    all_ntiles.ss4.correct(file,:) = prctile(SRT(ss4.correct,1),nts);
    all_ntiles.ss4.errors(file,:) = prctile(SRT(ss4.errors,1),nts);
    all_ntiles.ss8.correct(file,:) = prctile(SRT(ss8.correct,1),nts);
    all_ntiles.ss8.errors(file,:) = prctile(SRT(ss8.errors,1),nts);
    
    
    
    %     clear slow_correct_made_dead slow_errors_made_dead med_correct med_errors ...
    %         fast_correct_made_dead_withCleared fast_errors_made_dead_withCleared
    
    keep filename include_med file all_ntiles trls truncate_IQR truncval fr fx plotFlag mean_deadline sd_deadline
    
end

%VINCENT AVERAGE
ntiles.ss2.correct = nanmean(all_ntiles.ss2.correct)';
ntiles.ss2.errors = nanmean(all_ntiles.ss2.errors)';
ntiles.ss4.correct = nanmean(all_ntiles.ss4.correct)';
ntiles.ss4.errors = nanmean(all_ntiles.ss4.errors)';
ntiles.ss8.correct = nanmean(all_ntiles.ss8.correct)';
ntiles.ss8.errors = nanmean(all_ntiles.ss8.errors)';


clear all_ntiles

nl = .1 * length(trls.ss2.correct);
nh = .2 * length(trls.ss2.correct);
obs_freq.ss2.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.ss2.errors);
nh = .2 * length(trls.ss2.errors);
obs_freq.ss2.errors = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.ss4.correct);
nh = .2 * length(trls.ss4.correct);
obs_freq.ss4.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.ss4.errors);
nh = .2 * length(trls.ss4.errors);
obs_freq.ss4.errors = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.ss8.correct);
nh = .2 * length(trls.ss8.correct);
obs_freq.ss8.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.ss8.errors);
nh = .2 * length(trls.ss8.errors);
obs_freq.ss8.errors = [nl nh nh nh nh nl];
clear nl nh


clear truncate_IQR truncval include_med file filename