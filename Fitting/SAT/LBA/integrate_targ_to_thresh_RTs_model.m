cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_VisMove_Med_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_VisMove_Med_S.txt','%s %s');
[filename5 unit5] = textread('SAT_Move_NoMed_Q.txt','%s %s');
[filename6 unit6] = textread('SAT_Move_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Move_NoMed_S.txt','%s %s');
[filename8 unit8] = textread('SAT_Move_Med_S.txt','%s %s');


filename = [filename1 ; filename2 ; filename3 ; filename4 ; ...
filename5 ; filename6 ; filename7 ; filename8];
unit = [unit1 ; unit2 ; unit3 ; unit4 ; unit5 ; unit6 ; unit7 ; unit8];
plotFlag = 1;

include_med = 0;
for file = 1:length(filename)
    
    load(filename{file},unit{file},'saccLoc','Correct_','Target_','SRT','SAT_','Errors_','EyeX_','EyeY_','RFs','MFs','newfile')
    filename{file}
    
    sig = eval(unit{file});
    
    MF = MFs.(unit{file});
    
    antiMF = mod((MF+4),8);
    
    normalize = 1;
    
    trunc_RT = 2000;
    plotBaselineBlocks = 0;
    separate_cleared_nocleared = 0;
    within_condition_RT_bins = 1; % Do you want to plot fast/med/slow bins within each FAST and SLOW condition?
    match_variability = 0;
    plot_integrals = 0;
    
    
    %============
    % FIND TRIALS
    %===================================================================
    
    getTrials_SAT

    inMF = find(ismember(Target_(:,2),MF));
    outMF = find(ismember(Target_(:,2),antiMF));
    inMF_err = find(ismember(Target_(:,2),MF) & ismember(saccLoc,antiMF));
    outMF_err = find(ismember(Target_(:,2),antiMF) & ismember(saccLoc,MF));
    
    
    in.slow_correct_made_dead = intersect(inMF,slow_correct_made_dead);
    out.slow_correct_made_dead = intersect(outMF,slow_correct_made_dead);
    
    if include_med
    in.med_correct = intersect(inMF,med_correct);
    out.med_correct = intersect(outMF,med_correct);
    end
    
    in.fast_correct_made_dead_withCleared = intersect(inMF,fast_correct_made_dead_withCleared);
    out.fast_correct_made_dead_withCleared = intersect(outMF,fast_correct_made_dead_withCleared);
    
    
    
    %=============================
    
    
    
    
    SDF_r = sSDF(sig,SRT(:,1)+500,[-1000 200]);
    SDF = sSDF(sig,Target_(:,1),[0 1200]);
    
    if normalize == 1
        SDF_r = normalize_SP(SDF_r);
        SDF = normalize_SP(SDF);
    end
    
    decay = 5;
    thresh_prct = 70;
    drive = 0;
    
    lb.decay = 0;
    lb.thresh_prct = 20;
    lb.drive = 0;
    
    ub.decay = 100;
    ub.thresh_prct = 300;
    ub.drive = 30;
    
    param = [decay,thresh_prct,drive];
    lower = [lb.decay,lb.thresh_prct,lb.drive];
    upper = [ub.decay,ub.thresh_prct,ub.drive];
    
    options = optimset('MaxIter', 100000,'MaxFunEvals', 100000);
    [solution minval exitflag output] = fminsearchbnd(@(param) integrate_targ_to_thresh_RTs_calcLL(param,in,out,SDF,SRT,include_med),param,lower,upper,options);
%     
    
    
    %==============================================
    %plot solution
%     decay = solution(1);
%     thresh = solution(2);

f1 = figure;
f2 = figure;
%%

    %DEBUGGING%%%%%%%%%%%%%%%%
    
    decay = 1;
    thresh_prct = 200;
    drive = 3.5;
    leakage = decay / 1000;
    
    
    iqr_val = 1;
%create observed RT distribution.  Because we are linking with neuron behavior, limit only to same trials
%used with neurons (in/out).

obsRT_slow = SRT(in.slow_correct_made_dead);
if include_med; obsRT_med = SRT(in.med_correct); end
obsRT_fast = SRT(in.fast_correct_made_dead_withCleared);

obsRT_slow = removeNaN(obsRT_slow);
if include_med; obsRT_med = removeNaN(obsRT_med); end
obsRT_fast = removeNaN(obsRT_fast);

highcut_slow = nanmedian(obsRT_slow) + iqr_val * iqr(obsRT_slow);
lowcut_slow = nanmedian(obsRT_slow) - iqr_val * iqr(obsRT_slow);

if include_med
    highcut_med = nanmedian(obsRT_med) + iqr_val * iqr(obsRT_med);
    lowcut_med = nanmedian(obsRT_med) - iqr_val * iqr(obsRT_med);
end

highcut_fast = nanmedian(obsRT_fast) + iqr_val * iqr(obsRT_fast);
lowcut_fast = nanmedian(obsRT_fast) - iqr_val * iqr(obsRT_fast);

obsRT_slow = obsRT_slow(find(obsRT_slow > lowcut_slow & obsRT_slow < highcut_slow));
if include_med; obsRT_med = obsRT_med(find(obsRT_med > lowcut_med & obsRT_med < highcut_med)); end
obsRT_fast = obsRT_fast(find(obsRT_fast > lowcut_fast & obsRT_fast < highcut_fast));

clear observedRT
[observedRT.slow_correct_made_dead(:,1) observedRT.slow_correct_made_dead(:,2)] = getCDF(obsRT_slow);
if include_med; [observedRT.med_correct(:,1) observedRT.med_correct(:,2)] = getCDF(obsRT_med); end
[observedRT.fast_correct_made_dead_withCleared(:,1) observedRT.fast_correct_made_dead_withCleared(:,2)] = getCDF(obsRT_fast);



% remove min and max from CDF for more stable estimation
observedRT.slow_correct_made_dead(1,:) = [];
observedRT.slow_correct_made_dead(end,:) = [];
if include_med
    observedRT.med_correct(1,:) = [];
    observedRT.med_correct(end,:) = [];
end
observedRT.fast_correct_made_dead_withCleared(1,:) = [];
observedRT.fast_correct_made_dead_withCleared(end,:) = [];


integ(1:size(SDF,1),1:1201) = 0;
internal_drive = exp(linspace(0,drive,1201));

%create integrated, target-aligned activity
for trl = 1:size(SDF,1)
    for tm = 2:1201
        % integ(trl,tm) = integ(trl,tm-1) + SDF(trl,tm) - (integ(trl,tm-1) .* leakage);
        integ(trl,tm) = integ(trl,tm-1) + SDF(trl,tm) - (integ(trl,tm-1) .* leakage) .* internal_drive(tm);
    end
end

%implement Threshold as a percentage of integrator at max val
integ_at_eye(1) = nanmean(integ(in.slow_correct_made_dead,round(nanmean(obsRT_slow))));
if include_med; integ_at_eye(2) = nanmean(integ(in.med_correct,round(nanmean(obsRT_med)))); end
integ_at_eye(3) = nanmean(integ(in.fast_correct_made_dead_withCleared,round(nanmean(obsRT_fast))));
thresh = (thresh_prct/100) .* nanmean(integ_at_eye);

% find predicted RT distribution by locating time at which integrator crosses current threshold value
allPred_RT = [];
for trl = 1:size(SDF,1)
    predicted = find(integ(trl,:) > thresh,1);
    %    predicted_drive = find(integ_drive(trl,:) > thresh,1);
    if ~isempty(predicted)
        allPred_RT(trl,1) = predicted;
    else
        allPred_RT(trl,1) = NaN;
    end
    
    %     if ~isempty(predicted_drive)
    %         allPred_RT_drive(trl,1) = predicted_drive;
    %     else
    %         allPred_RT_drive(trl,1) = NaN;
    %     end
end

%Clean up predicted RT distribution.  neural variability is high, so we want to be sure to chop off
%extremes

pred_slow = allPred_RT(in.slow_correct_made_dead);
if include_med; pred_med = allPred_RT(in.med_correct); end
pred_fast = allPred_RT(in.fast_correct_made_dead_withCleared);

highcut_slow = nanmedian(pred_slow) + iqr_val * iqr(pred_slow);
lowcut_slow = nanmedian(pred_slow) - iqr_val * iqr(pred_slow);

if include_med
    highcut_med = nanmedian(pred_med) + iqr_val * iqr(pred_med);
    lowcut_med = nanmedian(pred_med) - iqr_val * iqr(pred_med);
end

highcut_fast = nanmedian(pred_fast) + iqr_val * iqr(pred_fast);
lowcut_fast = nanmedian(pred_fast) - iqr_val * iqr(pred_fast);

pred_slow = pred_slow(find(pred_slow > lowcut_slow & pred_slow < highcut_slow));
if include_med; pred_med = pred_med(find(pred_med > lowcut_med & pred_med < highcut_med)); end
pred_fast = pred_fast(find(pred_fast > lowcut_fast & pred_fast < highcut_fast));

predictedRT.slow_correct_made_dead = [];
if include_med; predictedRT.med_correct = []; end
predictedRT.fast_correct_made_dead_withCleared = [];
[predictedRT.slow_correct_made_dead(:,1) predictedRT.slow_correct_made_dead(:,2)] = getCDF(pred_slow);
if include_med; [predictedRT.med_correct(:,1) predictedRT.med_correct(:,2)] = getCDF(pred_med); end
[predictedRT.fast_correct_made_dead_withCleared(:,1) predictedRT.fast_correct_made_dead_withCleared(:,2)] = getCDF(pred_fast);

% again remove extremes
predictedRT.slow_correct_made_dead(1,:) = [];
predictedRT.slow_correct_made_dead(end,:) = [];
if include_med
    predictedRT.med_correct(1,:) = [];
    predictedRT.med_correct(end,:) = [];
end
predictedRT.fast_correct_made_dead_withCleared(1,:) = [];
predictedRT.fast_correct_made_dead_withCleared(end,:) = [];


%Fit the ex-Gaussian to each condition.  This will give us the distribution we are trying to fit to.
solution_slow = fitModel(obsRT_slow,nanmean(obsRT_slow),nanstd(obsRT_slow),nanstd(obsRT_slow),'exGauss');
if include_med; solution_med = fitModel(obsRT_med,nanmean(obsRT_med),nanstd(obsRT_med),nanstd(obsRT_med),'exGauss'); end
solution_fast = fitModel(obsRT_fast,nanmean(obsRT_fast),nanstd(obsRT_fast),nanstd(obsRT_fast),'exGauss');

%now find LL associated with predicted RT distribution
predRT_slow = removeNaN(pred_slow);
if include_med; predRT_med = removeNaN(pred_med); end
predRT_fast = removeNaN(pred_fast);

if length(predRT_slow)<50 | length(predRT_fast)<50 %NOTE: REMOVED MED FROM HERE.
    LL = 9999999;
else
    
    LL_slow = nansum(log(exGaussPDF(predRT_slow,solution_slow(1),solution_slow(2),solution_slow(3))));
    if include_med; LL_med = nansum(log(exGaussPDF(predRT_med,solution_med(1),solution_med(2),solution_med(3)))); end
    LL_fast = nansum(log(exGaussPDF(predRT_fast,solution_fast(1),solution_fast(2),solution_fast(3))));
    
    if include_med
        LL = -1 * (LL_slow + LL_med + LL_fast);
    else
        LL = -1 * (LL_slow + LL_fast);
    end
end

[CDF.obs_slow(:,1) CDF.obs_slow(:,2)] = getCDF(obsRT_slow);
if include_med; [CDF.obs_med(:,1) CDF.obs_med(:,2)] = getCDF(obsRT_med); end
[CDF.obs_fast(:,1) CDF.obs_fast(:,2)] = getCDF(obsRT_fast);

%predicted CDF
[CDF.pred_slow(:,1) CDF.pred_slow(:,2)] = getCDF(predRT_slow);
if include_med; [CDF.pred_med(:,1) CDF.pred_med(:,2)] = getCDF(predRT_med); end
[CDF.pred_fast(:,1) CDF.pred_fast(:,2)] = getCDF(predRT_fast);

if plotFlag
    if include_med
        plot(CDF.obs_slow(:,1),CDF.obs_slow(:,2),'or', ...
            CDF.obs_med(:,1),CDF.obs_med(:,2),'ok', ...
            CDF.obs_fast(:,1),CDF.obs_fast(:,2),'og', ...
            CDF.pred_slow(:,1),CDF.pred_slow(:,2),'r', ...
            CDF.pred_med(:,1),CDF.pred_med(:,2),'k', ...
            CDF.pred_fast(:,1),CDF.pred_fast(:,2),'g')
    else
        plot(CDF.obs_slow(:,1),CDF.obs_slow(:,2),'or', ...
            CDF.obs_fast(:,1),CDF.obs_fast(:,2),'og', ...
            CDF.pred_slow(:,1),CDF.pred_slow(:,2),'r', ...
            CDF.pred_fast(:,1),CDF.pred_fast(:,2),'g')
    end
    xlim([0 1000])
    ylim([0 1])
    box off
    if include_med
        title(['Ns  = ' mat2str([length(predRT_slow) length(predRT_med) length(predRT_fast)]) ...
            ' Thresh = ' mat2str(round(thresh_prct*100)/100) '% Decay = ' mat2str(round(decay*100)/100) ...
            ' Drive = ' mat2str(round(drive*100)/100) ' LL = ' mat2str(round(LL*100)/100)])
    else
        title(['Ns  = ' mat2str([length(predRT_slow) length(predRT_fast)]) ...
            ' Thresh = ' mat2str(round(thresh_prct*100)/100) '% Decay = ' mat2str(round(decay*100)/100) ...
            ' Drive = ' mat2str(round(drive*100)/100) ' LL = ' mat2str(round(LL*100)/100)])
    end

end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%     
%     observedRT.slow_correct_made_dead = [];
%     observedRT.med_correct = [];
%     observedRT.fast_correct_made_dead_withCleared = [];
%     [observedRT.slow_correct_made_dead(:,1) observedRT.slow_correct_made_dead(:,2)] = getCDF(SRT(in.slow_correct_made_dead,1));
%     [observedRT.med_correct(:,1) observedRT.med_correct(:,2)] = getCDF(SRT(in.med_correct,1));
%     [observedRT.fast_correct_made_dead_withCleared(:,1) observedRT.fast_correct_made_dead_withCleared(:,2)] = getCDF(SRT(in.fast_correct_made_dead_withCleared,1));
%     
%     % remove min and max from CDF for more stable estimation
%     observedRT.slow_correct_made_dead(1,:) = [];
%     observedRT.slow_correct_made_dead(end,:) = [];
%     observedRT.med_correct(1,:) = [];
%     observedRT.med_correct(end,:) = [];
%     observedRT.fast_correct_made_dead_withCleared(1,:) = [];
%     observedRT.fast_correct_made_dead_withCleared(end,:) = [];
%     
%     
%     
%     integ(1:size(SDF,1),1:1201) = 0;
%     
%     internal_drive = exp(linspace(0,3,1201));
%     
%     %create integrated, target-aligned activity
%     for trl = 1:size(SDF,1)
%         for tm = 2:1201
%             integ(trl,tm) = integ(trl,tm-1) + SDF(trl,tm) - (integ(trl,tm-1) .* leakage);
%             integ_drive(trl,tm) = integ(trl,tm-1) + SDF(trl,tm) - (integ(trl,tm-1) .* leakage) + internal_drive(tm);
%         end
%     end
%     
%     % find predicted RT distribution by locating time at which integrator crosses current threshold value
%     allPred_RT = [];
%     for trl = 1:size(SDF,1)
%         predicted = find(integ(trl,:) > thresh,1);
%         predicted_drive = find(integ_drive(trl,:) > thresh,1);
%        
%         if ~isempty(predicted)
%             allPred_RT(trl,1) = predicted;
%         else
%             allPred_RT(trl,1) = NaN;
%         end
%         
%         if ~isempty(predicted_drive)
%             allPred_RT_drive(trl,1) = predicted_drive;
%         else
%             allPred_RT_drive(trl,1) = NaN;
%         end
%     end
%     
%     
%     %Clean up predicted RT distribution.  neural variability is high, so we want to be sure to chop off
%     %extremes
%     
%     iqr_val = 1000;
%     pred_slow = allPred_RT(in.slow_correct_made_dead);
%     pred_med = allPred_RT(in.med_correct);
%     pred_fast = allPred_RT(in.fast_correct_made_dead_withCleared);
%     
%     highcut_slow = nanmedian(pred_slow) + iqr_val * iqr(pred_slow);
%     lowcut_slow = nanmedian(pred_slow) - iqr_val * iqr(pred_slow);
%     
%     highcut_med = nanmedian(pred_med) + iqr_val * iqr(pred_med);
%     lowcut_med = nanmedian(pred_med) - iqr_val * iqr(pred_med);
%     
%     highcut_fast = nanmedian(pred_fast) + iqr_val * iqr(pred_fast);
%     lowcut_fast = nanmedian(pred_fast) - iqr_val * iqr(pred_fast);
%     
%     pred_slow_trunc = pred_slow(find(pred_slow > lowcut_slow & pred_slow < highcut_slow));
%     pred_med_trunc = pred_med(find(pred_med > lowcut_med & pred_med < highcut_med));
%     pred_fast_trunc = pred_fast(find(pred_fast > lowcut_fast & pred_fast < highcut_fast));
%     
%     predictedRT.slow_correct_made_dead = [];
%     predictedRT.med_correct = [];
%     predictedRT.fast_correct_made_dead_withCleared = [];
%     [predictedRT.slow_correct_made_dead(:,1) predictedRT.slow_correct_made_dead(:,2)] = getCDF(pred_slow_trunc);
%     [predictedRT.med_correct(:,1) predictedRT.med_correct(:,2)] = getCDF(pred_med_trunc);
%     [predictedRT.fast_correct_made_dead_withCleared(:,1) predictedRT.fast_correct_made_dead_withCleared(:,2)] = getCDF(pred_fast_trunc);
%     
%     % again remove extremes
%     predictedRT.slow_correct_made_dead(1,:) = [];
%     predictedRT.slow_correct_made_dead(end,:) = [];
%     predictedRT.med_correct(1,:) = [];
%     predictedRT.med_correct(end,:) = [];
%     predictedRT.fast_correct_made_dead_withCleared(1,:) = [];
%     predictedRT.fast_correct_made_dead_withCleared(end,:) = [];
%     
%     figure(f1)
%     cla
%     plot(observedRT.slow_correct_made_dead(:,1),observedRT.slow_correct_made_dead(:,2),'or', ...
%         observedRT.med_correct(:,1),observedRT.med_correct(:,2),'ok', ...
%         observedRT.fast_correct_made_dead_withCleared(:,1),observedRT.fast_correct_made_dead_withCleared(:,2),'og')
%     hold on
%     plot(predictedRT.slow_correct_made_dead(:,1),predictedRT.slow_correct_made_dead(:,2),'r', ...
%         predictedRT.med_correct(:,1),predictedRT.med_correct(:,2),'k', ...
%         predictedRT.fast_correct_made_dead_withCleared(:,1),predictedRT.fast_correct_made_dead_withCleared(:,2),'g')
%     %title(['Decay = ' mat2str(round(decay*100)/100) ' Thresh = ' mat2str(round(thresh*100)/100) ' Chi-Square = ' mat2str(round(Chi*100)/100)])
%     xlim([0 1000])
%     ylim([0 1])
%     
%     
%     iqr_val = 1000;
%     pred_slow = allPred_RT_drive(in.slow_correct_made_dead);
%     pred_med = allPred_RT_drive(in.med_correct);
%     pred_fast = allPred_RT_drive(in.fast_correct_made_dead_withCleared);
%     
%     highcut_slow = nanmedian(pred_slow) + iqr_val * iqr(pred_slow);
%     lowcut_slow = nanmedian(pred_slow) - iqr_val * iqr(pred_slow);
%     
%     highcut_med = nanmedian(pred_med) + iqr_val * iqr(pred_med);
%     lowcut_med = nanmedian(pred_med) - iqr_val * iqr(pred_med);
%     
%     highcut_fast = nanmedian(pred_fast) + iqr_val * iqr(pred_fast);
%     lowcut_fast = nanmedian(pred_fast) - iqr_val * iqr(pred_fast);
%     
%     pred_slow_trunc = pred_slow(find(pred_slow > lowcut_slow & pred_slow < highcut_slow));
%     pred_med_trunc = pred_med(find(pred_med > lowcut_med & pred_med < highcut_med));
%     pred_fast_trunc = pred_fast(find(pred_fast > lowcut_fast & pred_fast < highcut_fast));
%     
%     predictedRT.slow_correct_made_dead = [];
%     predictedRT.med_correct = [];
%     predictedRT.fast_correct_made_dead_withCleared = [];
%     [predictedRT.slow_correct_made_dead(:,1) predictedRT.slow_correct_made_dead(:,2)] = getCDF(pred_slow_trunc);
%     [predictedRT.med_correct(:,1) predictedRT.med_correct(:,2)] = getCDF(pred_med_trunc);
%     [predictedRT.fast_correct_made_dead_withCleared(:,1) predictedRT.fast_correct_made_dead_withCleared(:,2)] = getCDF(pred_fast_trunc);
%     
%     % again remove extremes
%     predictedRT.slow_correct_made_dead(1,:) = [];
%     predictedRT.slow_correct_made_dead(end,:) = [];
%     predictedRT.med_correct(1,:) = [];
%     predictedRT.med_correct(end,:) = [];
%     predictedRT.fast_correct_made_dead_withCleared(1,:) = [];
%     predictedRT.fast_correct_made_dead_withCleared(end,:) = [];
%     
%     figure(f2)
%     cla
%     plot(observedRT.slow_correct_made_dead(:,1),observedRT.slow_correct_made_dead(:,2),'or', ...
%         observedRT.med_correct(:,1),observedRT.med_correct(:,2),'ok', ...
%         observedRT.fast_correct_made_dead_withCleared(:,1),observedRT.fast_correct_made_dead_withCleared(:,2),'og')
%     hold on
%     plot(predictedRT.slow_correct_made_dead(:,1),predictedRT.slow_correct_made_dead(:,2),'r', ...
%         predictedRT.med_correct(:,1),predictedRT.med_correct(:,2),'k', ...
%         predictedRT.fast_correct_made_dead_withCleared(:,1),predictedRT.fast_correct_made_dead_withCleared(:,2),'g')
%     %title(['Decay = ' mat2str(round(decay*100)/100) ' Thresh = ' mat2str(round(thresh*100)/100) ' Chi-Square = ' mat2str(round(Chi*100)/100)])
%     xlim([0 1000])
%     ylim([0 1])
    
end


