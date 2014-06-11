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

trls.slow1.correct = [];
trls.slow2.correct = [];
trls.slow3.correct = [];

trls.slow1.errors = [];
trls.slow2.errors = [];
trls.slow3.errors = [];

trls.fast1.correct = [];
trls.fast2.correct = [];
trls.fast3.correct = [];

trls.fast1.errors = [];
trls.fast2.errors = [];
trls.fast3.errors = [];

if include_med
    trls.med1.correct = [];
    trls.med2.correct = [];
    trls.med3.correct = [];
    
    trls.med1.errors = [];
    trls.med2.errors = [];
    trls.med3.errors = [];
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
        highcut_slow1 = nanmedian(SRT([slow_correct_made_dead_binSLOW ; slow_errors_made_dead_binSLOW],1)) + truncval * iqr(SRT([slow_correct_made_dead_binSLOW ; slow_errors_made_dead_binSLOW],1));
        highcut_slow2 = nanmedian(SRT([slow_correct_made_dead_binMED ; slow_errors_made_dead_binMED],1)) + truncval * iqr(SRT([slow_correct_made_dead_binMED ; slow_errors_made_dead_binMED],1));
        highcut_slow3 = nanmedian(SRT([slow_correct_made_dead_binFAST ; slow_errors_made_dead_binFAST],1)) + truncval * iqr(SRT([slow_correct_made_dead_binFAST ; slow_errors_made_dead_binFAST],1));
        
        lowcut_slow1 = nanmedian(SRT([slow_correct_made_dead_binSLOW ; slow_errors_made_dead_binSLOW],1)) - truncval * iqr(SRT([slow_correct_made_dead_binSLOW ; slow_errors_made_dead_binSLOW],1));
        lowcut_slow2 = nanmedian(SRT([slow_correct_made_dead_binMED ; slow_errors_made_dead_binMED],1)) - truncval * iqr(SRT([slow_correct_made_dead_binMED ; slow_errors_made_dead_binMED],1));
        lowcut_slow3 = nanmedian(SRT([slow_correct_made_dead_binFAST ; slow_errors_made_dead_binFAST],1)) - truncval * iqr(SRT([slow_correct_made_dead_binFAST ; slow_errors_made_dead_binFAST],1));
        
        highcut_fast1 = nanmedian(SRT([fast_correct_made_dead_withCleared_binSLOW ; fast_errors_made_dead_withCleared_binSLOW],1)) + truncval * iqr(SRT([fast_correct_made_dead_withCleared_binSLOW ; fast_errors_made_dead_withCleared_binSLOW],1));
        highcut_fast2 = nanmedian(SRT([fast_correct_made_dead_withCleared_binMED ; fast_errors_made_dead_withCleared_binMED],1)) + truncval * iqr(SRT([fast_correct_made_dead_withCleared_binMED ; fast_errors_made_dead_withCleared_binMED],1));
        highcut_fast3 = nanmedian(SRT([fast_correct_made_dead_withCleared_binFAST ; fast_errors_made_dead_withCleared_binFAST],1)) + truncval * iqr(SRT([fast_correct_made_dead_withCleared_binFAST ; fast_errors_made_dead_withCleared_binFAST],1));
        
        lowcut_fast1 = nanmedian(SRT([fast_correct_made_dead_withCleared_binSLOW ; fast_errors_made_dead_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_dead_withCleared_binSLOW ; fast_errors_made_dead_withCleared_binSLOW],1));
        lowcut_fast2 = nanmedian(SRT([fast_correct_made_dead_withCleared_binMED ; fast_errors_made_dead_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_dead_withCleared_binMED ; fast_errors_made_dead_withCleared_binMED],1));
        lowcut_fast3 = nanmedian(SRT([fast_correct_made_dead_withCleared_binFAST ; fast_errors_made_dead_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_dead_withCleared_binFAST ; fast_errors_made_dead_withCleared_binFAST],1));
        
        
        %All correct trials w/ made deadlines
        slow_correct_made_dead_binSLOW = intersect(slow_correct_made_dead_binSLOW,find(SRT(:,1) > lowcut_slow1 & SRT(:,1) < highcut_slow1));
        slow_correct_made_dead_binMED = intersect(slow_correct_made_dead_binMED,find(SRT(:,1) > lowcut_slow2 & SRT(:,1) < highcut_slow2));
        slow_correct_made_dead_binFAST = intersect(slow_correct_made_dead_binFAST,find(SRT(:,1) > lowcut_slow3 & SRT(:,1) < highcut_slow3));
        
        fast_correct_made_dead_withCleared_binSLOW = intersect(fast_correct_made_dead_withCleared_binSLOW,find(SRT(:,1) > lowcut_fast1 & SRT(:,1) < highcut_fast1));
        fast_correct_made_dead_withCleared_binMED = intersect(fast_correct_made_dead_withCleared_binMED,find(SRT(:,1) > lowcut_fast2 & SRT(:,1) < highcut_fast2));
        fast_correct_made_dead_withCleared_binFAST = intersect(fast_correct_made_dead_withCleared_binFAST,find(SRT(:,1) > lowcut_fast3 & SRT(:,1) < highcut_fast3));
        
        slow_errors_made_dead_binSLOW = intersect(slow_errors_made_dead_binSLOW,find(SRT(:,1) > lowcut_slow1 & SRT(:,1) < highcut_slow1));
        slow_errors_made_dead_binMED = intersect(slow_errors_made_dead_binMED,find(SRT(:,1) > lowcut_slow2 & SRT(:,1) < highcut_slow2));
        slow_errors_made_dead_binFAST = intersect(slow_errors_made_dead_binFAST,find(SRT(:,1) > lowcut_slow3 & SRT(:,1) < highcut_slow3));
        
        fast_errors_made_dead_withCleared_binSLOW = intersect(fast_errors_made_dead_withCleared_binSLOW,find(SRT(:,1) > lowcut_fast1 & SRT(:,1) < highcut_fast1));
        fast_errors_made_dead_withCleared_binMED = intersect(fast_errors_made_dead_withCleared_binMED,find(SRT(:,1) > lowcut_fast2 & SRT(:,1) < highcut_fast2));
        fast_errors_made_dead_withCleared_binFAST = intersect(fast_errors_made_dead_withCleared_binFAST,find(SRT(:,1) > lowcut_fast3 & SRT(:,1) < highcut_fast3));
        
        %keep track of total N for calculating AIC/BIC for MLE models
        N.all = numel([slow_correct_made_dead_binSLOW ; slow_correct_made_dead_binMED ; slow_correct_made_dead_binFAST ; ...
            slow_errors_made_dead_binSLOW ; slow_errors_made_dead_binMED ; slow_errors_made_dead_binFAST ; ...
            fast_correct_made_dead_withCleared_binSLOW ; fast_correct_made_dead_withCleared_binMED ; fast_correct_made_dead_withCleared_binFAST ; ...
            fast_errors_made_dead_withCleared_binSLOW ; fast_errors_made_dead_withCleared_binMED ; fast_errors_made_dead_withCleared_binFAST]);
        if include_med
            highcut_med1 = nanmedian(SRT([med_correct_binSLOW ; med_errors_binSLOW],1)) + truncval * iqr(SRT([med_correct_binSLOW ; med_errors_binSLOW],1));
            highcut_med2 = nanmedian(SRT([med_correct_binMED ; med_errors_binMED],1)) + truncval * iqr(SRT([med_correct_binMED ; med_errors_binMED],1));
            highcut_med3 = nanmedian(SRT([med_correct_binFAST ; med_errors_binFAST],1)) + truncval * iqr(SRT([med_correct_binFAST ; med_errors_binFAST],1));
            
            lowcut_med1 = nanmedian(SRT([med_correct_binSLOW ; med_errors_binSLOW],1)) - truncval * iqr(SRT([med_correct_binSLOW ; med_errors_binSLOW],1));
            lowcut_med2 = nanmedian(SRT([med_correct_binMED ; med_errors_binMED],1)) - truncval * iqr(SRT([med_correct_binMED ; med_errors_binMED],1));
            lowcut_med3 = nanmedian(SRT([med_correct_binFAST ; med_errors_binFAST],1)) - truncval * iqr(SRT([med_correct_binFAST ; med_errors_binFAST],1));
            
            med_correct_binSLOW = intersect(med_correct_binSLOW,find(SRT(:,1) > lowcut_med1 & SRT(:,1) < highcut_med1));
            med_correct_binMED = intersect(med_correct_binMED,find(SRT(:,1) > lowcut_med2 & SRT(:,1) < highcut_med2));
            med_correct_binFAST = intersect(med_correct_binFAST,find(SRT(:,1) > lowcut_med3 & SRT(:,1) < highcut_med3));
            
            med_errors_binSLOW = intersect(med_errors_binSLOW,find(SRT(:,1) > lowcut_med1 & SRT(:,1) < highcut_med1));
            med_errors_binMED = intersect(med_errors_binMED,find(SRT(:,1) > lowcut_med2 & SRT(:,1) < highcut_med2));
            med_errors_binFAST = intersect(med_errors_binFAST,find(SRT(:,1) > lowcut_med3 & SRT(:,1) < highcut_med3));
            
            N.all = N.all + numel([med_correct_binSLOW ; med_correct_binMED ; med_correct_binFAST ; ...
                med_errors_binSLOW ; med_errors_binMED ; med_errors_binFAST]);
            
        end
        
        all_highcut.slow1(file,1) = highcut_slow1;
        all_highcut.slow2(file,1) = highcut_slow2;
        all_highcut.slow3(file,1) = highcut_slow3;
        
        all_highcut.med1(file,1) = highcut_med1;
        all_highcut.med2(file,1) = highcut_med2;
        all_highcut.med3(file,1) = highcut_med3;
        
        all_highcut.fast1(file,1) = highcut_fast1;
        all_highcut.fast2(file,1) = highcut_fast2;
        all_highcut.fast3(file,1) = highcut_fast3;
        
        all_lowcut.slow1(file,1) = lowcut_slow1;
        all_lowcut.slow2(file,1) = lowcut_slow2;
        all_lowcut.slow3(file,1) = lowcut_slow3;
        
        all_lowcut.med1(file,1) = lowcut_med1;
        all_lowcut.med2(file,1) = lowcut_med2;
        all_lowcut.med3(file,1) = lowcut_med3;
        
        all_lowcut.fast1(file,1) = lowcut_fast1;
        all_lowcut.fast2(file,1) = lowcut_fast2;
        all_lowcut.fast3(file,1) = lowcut_fast3;
        
    end
    
    
    
    %keep track of all trials. in the calc_X2 script, this is really only used for counting the N's. This
    %should be changed later
    trls.slow1.correct = [trls.slow1.correct ; slow_correct_made_dead_binSLOW];
    trls.slow2.correct = [trls.slow2.correct ; slow_correct_made_dead_binMED];
    trls.slow3.correct = [trls.slow3.correct ; slow_correct_made_dead_binFAST];
    
    trls.slow1.errors = [trls.slow1.errors ; slow_errors_made_dead_binSLOW];
    trls.slow2.errors = [trls.slow2.errors ; slow_errors_made_dead_binMED];
    trls.slow3.errors = [trls.slow3.errors ; slow_errors_made_dead_binFAST];
    
    trls.fast1.correct = [trls.fast1.correct ; fast_correct_made_dead_withCleared_binSLOW];
    trls.fast2.correct = [trls.fast2.correct ; fast_correct_made_dead_withCleared_binMED];
    trls.fast3.correct = [trls.fast3.correct ; fast_correct_made_dead_withCleared_binFAST];
    
    trls.fast1.errors = [trls.fast1.errors ; fast_errors_made_dead_withCleared_binSLOW];
    trls.fast2.errors = [trls.fast2.errors ; fast_errors_made_dead_withCleared_binMED];
    trls.fast3.errors = [trls.fast3.errors ; fast_errors_made_dead_withCleared_binFAST];
    
    if include_med
        trls.med1.correct = [trls.med1.correct ; med_correct_binSLOW];
        trls.med2.correct = [trls.med2.correct ; med_correct_binMED];
        trls.med3.correct = [trls.med3.correct ; med_correct_binFAST];
        
        trls.med1.errors = [trls.med1.errors ; med_errors_binSLOW];
        trls.med2.errors = [trls.med2.errors ; med_errors_binMED];
        trls.med3.errors = [trls.med3.errors ; med_errors_binFAST];
    end
    
    
    nts = [10 ; 30 ; 50 ; 70 ; 90 ; 100]; %last ntile (100) is just for plotting; is the max value
    all_ntiles.slow_correct_made_dead_binSLOW(file,:) = prctile(SRT(slow_correct_made_dead_binSLOW,1),nts);
    all_ntiles.slow_correct_made_dead_binMED(file,:) = prctile(SRT(slow_correct_made_dead_binMED,1),nts);
    all_ntiles.slow_correct_made_dead_binFAST(file,:) = prctile(SRT(slow_correct_made_dead_binFAST,1),nts);
    
    all_ntiles.slow_errors_made_dead_binSLOW(file,:) = prctile(SRT(slow_errors_made_dead_binSLOW,1),nts);
    all_ntiles.slow_errors_made_dead_binMED(file,:) = prctile(SRT(slow_errors_made_dead_binMED,1),nts);
    all_ntiles.slow_errors_made_dead_binFAST(file,:) = prctile(SRT(slow_errors_made_dead_binFAST,1),nts);
    
    
    all_ntiles.fast_correct_made_dead_withCleared_binSLOW(file,:) = prctile(SRT(fast_correct_made_dead_withCleared_binSLOW,1),nts);
    all_ntiles.fast_correct_made_dead_withCleared_binMED(file,:) = prctile(SRT(fast_correct_made_dead_withCleared_binMED,1),nts);
    all_ntiles.fast_correct_made_dead_withCleared_binFAST(file,:) = prctile(SRT(fast_correct_made_dead_withCleared_binFAST,1),nts);
    
    all_ntiles.fast_errors_made_dead_withCleared_binSLOW(file,:) = prctile(SRT(fast_errors_made_dead_withCleared_binSLOW,1),nts);
    all_ntiles.fast_errors_made_dead_withCleared_binMED(file,:) = prctile(SRT(fast_errors_made_dead_withCleared_binMED,1),nts);
    all_ntiles.fast_errors_made_dead_withCleared_binFAST(file,:) = prctile(SRT(fast_errors_made_dead_withCleared_binFAST,1),nts);
    
    if include_med
        all_ntiles.med_correct_binSLOW(file,:) = prctile(SRT(med_correct_binSLOW,1),nts);
        all_ntiles.med_correct_binMED(file,:) = prctile(SRT(med_correct_binMED,1),nts);
        all_ntiles.med_correct_binFAST(file,:) = prctile(SRT(med_correct_binFAST,1),nts);
        
        all_ntiles.med_errors_binSLOW(file,:) = prctile(SRT(med_errors_binSLOW,1),nts);
        all_ntiles.med_errors_binMED(file,:) = prctile(SRT(med_errors_binMED,1),nts);
        all_ntiles.med_errors_binFAST(file,:) = prctile(SRT(med_errors_binFAST,1),nts);
    end
    
    %     clear slow_correct_made_dead slow_errors_made_dead med_correct med_errors ...
    %         fast_correct_made_dead_withCleared fast_errors_made_dead_withCleared
    
    keep filename include_med file all_ntiles trls truncate_IQR truncval fr fx plotFlag mean_deadline sd_deadline all_highcut all_lowcut
    
end

%VINCENT AVERAGE
ntiles.slow1.correct = nanmean(all_ntiles.slow_correct_made_dead_binSLOW)';
ntiles.slow2.correct = nanmean(all_ntiles.slow_correct_made_dead_binMED)';
ntiles.slow3.correct = nanmean(all_ntiles.slow_correct_made_dead_binFAST)';

ntiles.slow1.errors = nanmean(all_ntiles.slow_errors_made_dead_binSLOW)';
ntiles.slow2.errors = nanmean(all_ntiles.slow_errors_made_dead_binMED)';
ntiles.slow3.errors = nanmean(all_ntiles.slow_errors_made_dead_binFAST)';

ntiles.fast1.correct = nanmean(all_ntiles.fast_correct_made_dead_withCleared_binSLOW)';
ntiles.fast2.correct = nanmean(all_ntiles.fast_correct_made_dead_withCleared_binMED)';
ntiles.fast3.correct = nanmean(all_ntiles.fast_correct_made_dead_withCleared_binFAST)';

ntiles.fast1.errors = nanmean(all_ntiles.fast_errors_made_dead_withCleared_binSLOW)';
ntiles.fast2.errors = nanmean(all_ntiles.fast_errors_made_dead_withCleared_binMED)';
ntiles.fast3.errors = nanmean(all_ntiles.fast_errors_made_dead_withCleared_binFAST)';

if include_med
    ntiles.med1.correct = nanmean(all_ntiles.med_correct_binSLOW)';
    ntiles.med2.correct = nanmean(all_ntiles.med_correct_binMED)';
    ntiles.med3.correct = nanmean(all_ntiles.med_correct_binFAST)';
    
    ntiles.med1.errors = nanmean(all_ntiles.med_errors_binSLOW)';
    ntiles.med2.errors = nanmean(all_ntiles.med_errors_binMED)';
    ntiles.med3.errors = nanmean(all_ntiles.med_errors_binFAST)';
end

clear all_ntiles

nl = .1 * length(trls.slow1.correct);
nh = .2 * length(trls.slow1.correct);
obs_freq.slow1.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.slow2.correct);
nh = .2 * length(trls.slow2.correct);
obs_freq.slow2.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.slow3.correct);
nh = .2 * length(trls.slow3.correct);
obs_freq.slow3.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.slow1.errors);
nh = .2 * length(trls.slow1.errors);
obs_freq.slow1.errors = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.slow2.errors);
nh = .2 * length(trls.slow2.errors);
obs_freq.slow2.errors = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.slow3.errors);
nh = .2 * length(trls.slow3.errors);
obs_freq.slow3.errors = [nl nh nh nh nh nl];
clear nl nh


nl = .1 * length(trls.fast1.correct);
nh = .2 * length(trls.fast1.correct);
obs_freq.fast1.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.fast2.correct);
nh = .2 * length(trls.fast2.correct);
obs_freq.fast2.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.fast3.correct);
nh = .2 * length(trls.fast3.correct);
obs_freq.fast3.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.fast1.errors);
nh = .2 * length(trls.fast1.errors);
obs_freq.fast1.errors = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.fast2.errors);
nh = .2 * length(trls.fast2.errors);
obs_freq.fast2.errors = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(trls.fast3.errors);
nh = .2 * length(trls.fast3.errors);
obs_freq.fast3.errors = [nl nh nh nh nh nl];
clear nl nh


if include_med
    nl = .1 * length(trls.med1.correct);
    nh = .2 * length(trls.med1.correct);
    obs_freq.med1.correct = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(trls.med2.correct);
    nh = .2 * length(trls.med2.correct);
    obs_freq.med2.correct = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(trls.med3.correct);
    nh = .2 * length(trls.med3.correct);
    obs_freq.med3.correct = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(trls.med1.errors);
    nh = .2 * length(trls.med1.errors);
    obs_freq.med1.errors = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(trls.med2.errors);
    nh = .2 * length(trls.med2.errors);
    obs_freq.med2.errors = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(trls.med3.errors);
    nh = .2 * length(trls.med3.errors);
    obs_freq.med3.errors = [nl nh nh nh nh nl];
    clear nl nh
end

clear truncate_IQR truncval include_med file filename