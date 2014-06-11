function [Chi] = integrate_targ_to_thresh_RTs_calcX2(param,in,out,SDF,SRT)


plotFlag = 1;

% SDF = evalin('caller','SDF'); %hard-coded to span 0:1200 ms relative to target onset
% SRT = evalin('caller','SRT');

decay = param(1);
thresh = param(2);

%convert decay constant into leakage value
leakage = decay / 1000;

%create observed RT distribution.  Because we are linking with neuron behavior, limit only to same trials
%used with neurons (in/out).

[observedRT.slow_correct_made_dead(:,1) observedRT.slow_correct_made_dead(:,2)] = getCDF(SRT(in.slow_correct_made_dead,1));
[observedRT.med_correct(:,1) observedRT.med_correct(:,2)] = getCDF(SRT(in.med_correct,1));
[observedRT.fast_correct_made_dead_withCleared(:,1) observedRT.fast_correct_made_dead_withCleared(:,2)] = getCDF(SRT(in.fast_correct_made_dead_withCleared,1));

% remove min and max from CDF for more stable estimation
observedRT.slow_correct_made_dead(1,:) = [];
observedRT.slow_correct_made_dead(end,:) = [];
observedRT.med_correct(1,:) = [];
observedRT.med_correct(end,:) = [];
observedRT.fast_correct_made_dead_withCleared(1,:) = [];
observedRT.fast_correct_made_dead_withCleared(end,:) = [];

%convert to N's for Chi-Square


observedN.slow_correct_made_dead(1) = length(find(SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(1)));
observedN.slow_correct_made_dead(2) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(1) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(2)));
observedN.slow_correct_made_dead(3) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(2) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(3)));
observedN.slow_correct_made_dead(4) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(3) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(4)));
observedN.slow_correct_made_dead(5) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(4) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(5)));
observedN.slow_correct_made_dead(6) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(5) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(6)));
observedN.slow_correct_made_dead(7) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(6) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(7)));
observedN.slow_correct_made_dead(8) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(7) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(8)));
observedN.slow_correct_made_dead(9) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(8) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(9)));
observedN.slow_correct_made_dead(10) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(9)));


observedN.med_correct(1) = length(find(SRT(in.med_correct,1) <= observedRT.med_correct(1)));
observedN.med_correct(2) = length(find(SRT(in.med_correct,1) > observedRT.med_correct(1) & SRT(in.med_correct,1) <= observedRT.med_correct(2)));
observedN.med_correct(3) = length(find(SRT(in.med_correct,1) > observedRT.med_correct(2) & SRT(in.med_correct,1) <= observedRT.med_correct(3)));
observedN.med_correct(4) = length(find(SRT(in.med_correct,1) > observedRT.med_correct(3) & SRT(in.med_correct,1) <= observedRT.med_correct(4)));
observedN.med_correct(5) = length(find(SRT(in.med_correct,1) > observedRT.med_correct(4) & SRT(in.med_correct,1) <= observedRT.med_correct(5)));
observedN.med_correct(6) = length(find(SRT(in.med_correct,1) > observedRT.med_correct(5) & SRT(in.med_correct,1) <= observedRT.med_correct(6)));
observedN.med_correct(7) = length(find(SRT(in.med_correct,1) > observedRT.med_correct(6) & SRT(in.med_correct,1) <= observedRT.med_correct(7)));
observedN.med_correct(8) = length(find(SRT(in.med_correct,1) > observedRT.med_correct(7) & SRT(in.med_correct,1) <= observedRT.med_correct(8)));
observedN.med_correct(9) = length(find(SRT(in.med_correct,1) > observedRT.med_correct(8) & SRT(in.med_correct,1) <= observedRT.med_correct(9)));
observedN.med_correct(10) = length(find(SRT(in.med_correct,1) > observedRT.med_correct(9)));

observedN.fast_correct_made_dead_withCleared(1) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(1)));
observedN.fast_correct_made_dead_withCleared(2) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(1) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(2)));
observedN.fast_correct_made_dead_withCleared(3) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(2) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(3)));
observedN.fast_correct_made_dead_withCleared(4) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(3) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(4)));
observedN.fast_correct_made_dead_withCleared(5) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(4) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(5)));
observedN.fast_correct_made_dead_withCleared(6) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(5) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(6)));
observedN.fast_correct_made_dead_withCleared(7) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(6) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(7)));
observedN.fast_correct_made_dead_withCleared(8) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(7) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(8)));
observedN.fast_correct_made_dead_withCleared(9) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(8) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(9)));
observedN.fast_correct_made_dead_withCleared(10) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(9)));

% observedN.slow_correct_made_dead(1) = length(find(SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(1)));
% observedN.slow_correct_made_dead(2) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(1) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(2)));
% observedN.slow_correct_made_dead(3) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(2) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(3)));
% observedN.slow_correct_made_dead(4) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(3) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(4)));
% observedN.slow_correct_made_dead(5) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(4) & SRT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(5)));
% observedN.slow_correct_made_dead(6) = length(find(SRT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(5)));
%
% observedN.fast_correct_made_dead_withCleared(1) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(1)));
% observedN.fast_correct_made_dead_withCleared(2) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(1) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(2)));
% observedN.fast_correct_made_dead_withCleared(3) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(2) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(3)));
% observedN.fast_correct_made_dead_withCleared(4) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(3) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(4)));
% observedN.fast_correct_made_dead_withCleared(5) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(4) & SRT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(5)));
% observedN.fast_correct_made_dead_withCleared(6) = length(find(SRT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(5)));


integ(1:size(SDF,1),1:1201) = 0;
internal_drive = exp(linspace(0,3,1201));

%create integrated, target-aligned activity
for trl = 1:size(SDF,1)
    for tm = 2:1201
        integ(trl,tm) = integ(trl,tm-1) + SDF(trl,tm) - (integ(trl,tm-1) .* leakage);
        integ_drive(trl,tm) = integ(trl,tm-1) + SDF(trl,tm) - (integ(trl,tm-1) .* leakage) + internal_drive(tm);
    end
end

% find predicted RT distribution by locating time at which integrator crosses current threshold value
allPred_RT = [];
for trl = 1:size(SDF,1)
    predicted = find(integ(trl,:) > thresh,1);
    predicted_drive = find(integ_drive(trl,:) > thresh,1);
    if ~isempty(predicted)
        allPred_RT(trl,1) = predicted;
    else
        allPred_RT(trl,1) = NaN;
    end
    
    if ~isempty(predicted_drive)
        allPred_RT_drive(trl,1) = predicted_drive;
    else
        allPred_RT_drive(trl,1) = NaN;
    end
end

%Clean up predicted RT distribution.  neural variability is high, so we want to be sure to chop off
%extremes
iqr_val = 1000;
pred_slow = allPred_RT(in.slow_correct_made_dead);
pred_med = allPred_RT(in.med_correct);
pred_fast = allPred_RT(in.fast_correct_made_dead_withCleared);

highcut_slow = nanmedian(pred_slow) + iqr_val * iqr(pred_slow);
lowcut_slow = nanmedian(pred_slow) - iqr_val * iqr(pred_slow);

highcut_med = nanmedian(pred_med) + iqr_val * iqr(pred_med);
lowcut_med = nanmedian(pred_med) - iqr_val * iqr(pred_med);

highcut_fast = nanmedian(pred_fast) + iqr_val * iqr(pred_fast);
lowcut_fast = nanmedian(pred_fast) - iqr_val * iqr(pred_fast);

pred_slow = pred_slow(find(pred_slow > lowcut_slow & pred_slow < highcut_slow));
pred_med = pred_med(find(pred_med > lowcut_med & pred_med < highcut_med));
pred_fast = pred_fast(find(pred_fast > lowcut_fast & pred_fast < highcut_fast));

predictedRT.slow_correct_made_dead = [];
predictedRT.med_correct = [];
predictedRT.fast_correct_made_dead_withCleared = [];
[predictedRT.slow_correct_made_dead(:,1) predictedRT.slow_correct_made_dead(:,2)] = getCDF(pred_slow);
[predictedRT.med_correct(:,1) predictedRT.med_correct(:,2)] = getCDF(pred_med);
[predictedRT.fast_correct_made_dead_withCleared(:,1) predictedRT.fast_correct_made_dead_withCleared(:,2)] = getCDF(pred_fast);

% again remove extremes
predictedRT.slow_correct_made_dead(1,:) = [];
predictedRT.slow_correct_made_dead(end,:) = [];
predictedRT.med_correct(1,:) = [];
predictedRT.med_correct(end,:) = [];
predictedRT.fast_correct_made_dead_withCleared(1,:) = [];
predictedRT.fast_correct_made_dead_withCleared(end,:) = [];

predictedN.slow_correct_made_dead(1) = length(find(allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(1)));
predictedN.slow_correct_made_dead(2) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(1) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(2)));
predictedN.slow_correct_made_dead(3) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(2) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(3)));
predictedN.slow_correct_made_dead(4) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(3) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(4)));
predictedN.slow_correct_made_dead(5) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(4) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(5)));
predictedN.slow_correct_made_dead(6) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(5) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(6)));
predictedN.slow_correct_made_dead(7) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(6) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(7)));
predictedN.slow_correct_made_dead(8) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(7) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(8)));
predictedN.slow_correct_made_dead(9) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(8) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(9)));
predictedN.slow_correct_made_dead(10) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(9)));

predictedN.med_correct(1) = length(find(allPred_RT(in.med_correct,1) <= observedRT.med_correct(1)));
predictedN.med_correct(2) = length(find(allPred_RT(in.med_correct,1) > observedRT.med_correct(1) & allPred_RT(in.med_correct,1) <= observedRT.med_correct(2)));
predictedN.med_correct(3) = length(find(allPred_RT(in.med_correct,1) > observedRT.med_correct(2) & allPred_RT(in.med_correct,1) <= observedRT.med_correct(3)));
predictedN.med_correct(4) = length(find(allPred_RT(in.med_correct,1) > observedRT.med_correct(3) & allPred_RT(in.med_correct,1) <= observedRT.med_correct(4)));
predictedN.med_correct(5) = length(find(allPred_RT(in.med_correct,1) > observedRT.med_correct(4) & allPred_RT(in.med_correct,1) <= observedRT.med_correct(5)));
predictedN.med_correct(6) = length(find(allPred_RT(in.med_correct,1) > observedRT.med_correct(5) & allPred_RT(in.med_correct,1) <= observedRT.med_correct(6)));
predictedN.med_correct(7) = length(find(allPred_RT(in.med_correct,1) > observedRT.med_correct(6) & allPred_RT(in.med_correct,1) <= observedRT.med_correct(7)));
predictedN.med_correct(8) = length(find(allPred_RT(in.med_correct,1) > observedRT.med_correct(7) & allPred_RT(in.med_correct,1) <= observedRT.med_correct(8)));
predictedN.med_correct(9) = length(find(allPred_RT(in.med_correct,1) > observedRT.med_correct(8) & allPred_RT(in.med_correct,1) <= observedRT.med_correct(9)));
predictedN.med_correct(10) = length(find(allPred_RT(in.med_correct,1) > observedRT.med_correct(9)));

predictedN.fast_correct_made_dead_withCleared(1) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(1)));
predictedN.fast_correct_made_dead_withCleared(2) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(1) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(2)));
predictedN.fast_correct_made_dead_withCleared(3) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(2) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(3)));
predictedN.fast_correct_made_dead_withCleared(4) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(3) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(4)));
predictedN.fast_correct_made_dead_withCleared(5) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(4) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(5)));
predictedN.fast_correct_made_dead_withCleared(6) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(5) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(6)));
predictedN.fast_correct_made_dead_withCleared(7) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(6) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(7)));
predictedN.fast_correct_made_dead_withCleared(8) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(7) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(8)));
predictedN.fast_correct_made_dead_withCleared(9) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(8) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(9)));
predictedN.fast_correct_made_dead_withCleared(10) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(9)));

% predictedN.slow_correct_made_dead(1) = length(find(allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(1)));
% predictedN.slow_correct_made_dead(2) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(1) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(2)));
% predictedN.slow_correct_made_dead(3) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(2) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(3)));
% predictedN.slow_correct_made_dead(4) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(3) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(4)));
% predictedN.slow_correct_made_dead(5) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(4) & allPred_RT(in.slow_correct_made_dead,1) <= observedRT.slow_correct_made_dead(5)));
% predictedN.slow_correct_made_dead(6) = length(find(allPred_RT(in.slow_correct_made_dead,1) > observedRT.slow_correct_made_dead(5)));
%
% predictedN.fast_correct_made_dead_withCleared(1) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(1)));
% predictedN.fast_correct_made_dead_withCleared(2) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(1) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(2)));
% predictedN.fast_correct_made_dead_withCleared(3) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(2) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(3)));
% predictedN.fast_correct_made_dead_withCleared(4) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(3) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(4)));
% predictedN.fast_correct_made_dead_withCleared(5) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(4) & allPred_RT(in.fast_correct_made_dead_withCleared,1) <= observedRT.fast_correct_made_dead_withCleared(5)));
% predictedN.fast_correct_made_dead_withCleared(6) = length(find(allPred_RT(in.fast_correct_made_dead_withCleared,1) > observedRT.fast_correct_made_dead_withCleared(5)));


% if plotFlag
%     plot(observedRT.slow_correct_made_dead(:,1),observedRT.slow_correct_made_dead(:,2),'or', ...
%         observedRT.med_correct(:,1),observedRT.med_correct(:,2),'ok', ...
%         observedRT.fast_correct_made_dead(:,1),observedRT.fast_correct_made_dead(:,2),'og')
%     hold on
%     plot(predictedRT.slow_correct_made_dead(:,1),predictedRT.slow_correct_made_dead(:,2),'r', ...
%         predictedRT.med_correct(:,1),predictedRT.med_correct(:,2),'k', ...
%         predictedRT.fast_correct_made_dead(:,1),predictedRT.fast_correct_made_dead(:,2),'g')
% end
allN = [observedN.slow_correct_made_dead(:) predictedN.slow_correct_made_dead(:) ; ...
    observedN.med_correct(:) predictedN.med_correct(:) ; ...
    observedN.fast_correct_made_dead_withCleared(:) predictedN.fast_correct_made_dead_withCleared(:)];
%note: chi square numerator is observed - expected.  Here, expected is actually the observed (real) data
Chi = sum(  (allN(:,2) - allN(:,1)).^2 ./ allN(:,1)  );

if plotFlag
    plot(observedRT.slow_correct_made_dead(:,1),observedRT.slow_correct_made_dead(:,2),'or', ...
        observedRT.med_correct(:,1),observedRT.med_correct(:,2),'ok', ...
        observedRT.fast_correct_made_dead_withCleared(:,1),observedRT.fast_correct_made_dead_withCleared(:,2),'og')
    hold on
    plot(predictedRT.slow_correct_made_dead(:,1),predictedRT.slow_correct_made_dead(:,2),'r', ...
        predictedRT.med_correct(:,1),predictedRT.med_correct(:,2),'k', ...
        predictedRT.fast_correct_made_dead_withCleared(:,1),predictedRT.fast_correct_made_dead_withCleared(:,2),'g')
    title(['Decay = ' mat2str(round(decay*100)/100) ' Thresh = ' mat2str(round(thresh*100)/100) ' Chi-Square = ' mat2str(round(Chi*100)/100)])
    xlim([0 1000])
    ylim([0 1])
    pause(.001)
    cla
end