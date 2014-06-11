function [LL] = integrate_targ_to_thresh_RTs_calcLL(param,in,out,SDF,SRT,include_med)


plotFlag = 1;

% SDF = evalin('caller','SDF'); %hard-coded to span 0:1200 ms relative to target onset
% SRT = evalin('caller','SRT');

decay = param(1);
thresh_prct = param(2);
drive = param(3);
%convert decay constant into leakage value
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
    pause(.01)
    cla
end