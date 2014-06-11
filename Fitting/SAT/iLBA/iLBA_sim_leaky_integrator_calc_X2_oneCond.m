function X2 = iLBA_sim_leaky_integrator_calc_X2_oneCond(params,ntiles,trls,obs_freq,cond,simBound)
plotFlag = 1;
rand('seed',5150);
randn('seed',5150);
normrnd('seed',5150);

%parameter space:
%A = maximum of uniform start point distribution
%b = threshold
%v = drift rate
%T0 = nondecision time
%sd of rate is fixed

nTrials = evalin('caller','nTrials');
truncSim = evalin('caller','truncSim');

if cond == 1
    realTrls.correct = trls.slow.correct;
    realTrls.errors = trls.slow.errors;
    ntiles.correct = ntiles.slow.correct;
    ntiles.errors = ntiles.slow.errors;
elseif cond == 2
    realTrls.correct = trls.med.correct;
    realTrls.errors = trls.med.errors;
    ntiles.correct = ntiles.med.correct;
    ntiles.errors = ntiles.med.errors;
elseif cond == 3
    realTrls.correct = trls.fast.correct;
    realTrls.errors = trls.fast.errors;
    ntiles.correct = ntiles.fast.correct;
    ntiles.errors = ntiles.fast.errors;
end

[A b v T0 leakage sd_rate] = disperse(params);
b = b * 100;

correct(1:nTrials,1) = NaN;
rt(1:nTrials,1) = NaN;


%=========================
% INTEGRATION
start1 = unifrnd(0,A,nTrials,1);
start2 = unifrnd(0,A,nTrials,1);

%use absolute value just in case negative drift rate is selected
rate1 = abs(normrnd(v,sd_rate,nTrials,1));
rate1(find(rate1 > 1)) = .9999;

rate2 = abs(normrnd(1-v,sd_rate,nTrials,1));

%generate starting point
% act1 = start1;
% act2 = start2;
%
% linear1 = cumsum([zeros(nTrials,1) repmat(rate1,1,1000)],2) + repmat(start1,1,1001);
% linear2 = cumsum([zeros(nTrials,1) repmat(rate2,1,1000)],2) + repmat(start2,1,1001);
%

% for t = 2:1000
%     act1(:,t) = act1(:,t-1) + linear1(:,t) - ( leakage .* act1(:,t-1));
%     act2(:,t) = act2(:,t-1) + linear2(:,t) - ( leakage .* act2(:,t-1));
% end

%============
% C++ CODE
act1 = leaky_integrate2(rate1',start1,leakage)';
act2 = leaky_integrate2(rate2',start2,leakage)';

cross1 = diff(act1 > b,1,2);
cross2 = diff(act2 > b,1,2);

%force threshold crossing at latest point if never found
force1 = find(~any(cross1,2));
force2 = find(~any(cross2,2));

cross1(force1,size(cross1,2)) = 1;
cross2(force2,size(cross2,2)) = 1;

%multiple logical cross1 and cross2 by sequence of column numbers to convert into real time values
mult_mat = repmat(linspace(1,size(cross1,2),size(cross1,2)),nTrials,1);

cross1 = sum(cross1 .* mult_mat,2) + 1; % +1 to correct for diff operation earlier
cross2 = sum(cross2 .* mult_mat,2) + 1; % +1 to correct for diff operation earlier

rt = min([cross1 cross2],[],2);
correct = +(cross1 < cross2);
%=================================
% END INTEGRATION


% REMOVE RTs OUTSIDE OF BOUNDS (EQUIVALENT TO RESPONSE DEADLINES)
if truncSim
    if cond == 1
        correct(find(rt+T0 < simBound.slow)) = NaN;
        rt(find(rt+T0 < simBound.slow)) = NaN;
    elseif cond == 3
        correct(find(rt+T0 > simBound.fast)) = NaN;
        rt(find(rt+T0 > simBound.fast)) = NaN;
    end
end


rt = rt + T0;

simTrls.correct = find(correct == 1);
simTrls.errors = find(correct == 0);

N.correct = length(realTrls.correct);
N.errors = length(realTrls.errors);
N.all = N.correct + N.errors;

simN.correct = length(simTrls.correct);
simN.errors = length(simTrls.errors);
simN.all = simN.correct + simN.errors;

pred_prop.correct(1) = length(find(rt(simTrls.correct) <= ntiles.correct(1))) / simN.all;
pred_prop.correct(2) = length(find(rt(simTrls.correct) > ntiles.correct(1) & rt(simTrls.correct) <= ntiles.correct(2))) / simN.all;
pred_prop.correct(3) = length(find(rt(simTrls.correct) > ntiles.correct(2) & rt(simTrls.correct) <= ntiles.correct(3))) / simN.all;
pred_prop.correct(4) = length(find(rt(simTrls.correct) > ntiles.correct(3) & rt(simTrls.correct) <= ntiles.correct(4))) / simN.all;
pred_prop.correct(5) = length(find(rt(simTrls.correct) > ntiles.correct(4) & rt(simTrls.correct) <= ntiles.correct(5))) / simN.all;
pred_prop.correct(6) = length(find(rt(simTrls.correct) > ntiles.correct(5))) / simN.all;

pred_prop.errors(1) = length(find(rt(simTrls.errors) <= ntiles.errors(1))) / simN.all;
pred_prop.errors(2) = length(find(rt(simTrls.errors) > ntiles.errors(1) & rt(simTrls.errors) <= ntiles.errors(2))) / simN.all;
pred_prop.errors(3) = length(find(rt(simTrls.errors) > ntiles.errors(2) & rt(simTrls.errors) <= ntiles.errors(3))) / simN.all;
pred_prop.errors(4) = length(find(rt(simTrls.errors) > ntiles.errors(3) & rt(simTrls.errors) <= ntiles.errors(4))) / simN.all;
pred_prop.errors(5) = length(find(rt(simTrls.errors) > ntiles.errors(4) & rt(simTrls.errors) <= ntiles.errors(5))) / simN.all;
pred_prop.errors(6) = length(find(rt(simTrls.errors) > ntiles.errors(5))) / simN.all;


pred_freq.correct = pred_prop.correct .* N.all;
pred_freq.errors = pred_prop.errors .* N.all;


all_obs = [obs_freq.correct' ; obs_freq.errors'];
all_pred = [pred_freq.correct' ; pred_freq.errors'];

all_pred(find(isnan(all_pred))) = 0;


%X2 = sum( (all_obs - all_pred).^2 ./ (all_pred) ) + .00001;
X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );


obs_prop_correct = N.correct / N.all;
obs_prop_errors = 1-obs_prop_correct;

pred_prop_correct = length(simTrls.correct) / (length(simTrls.correct) + length(simTrls.errors));
pred_prop_errors = 1-pred_prop_correct;


if plotFlag
    hold on
    plot([ntiles.correct],(cumsum(obs_freq.correct)./N.correct)*obs_prop_correct,'ok',[ntiles.errors],(cumsum(obs_freq.errors)./N.errors)*obs_prop_errors,'or')
    plot([ntiles.correct],(cumsum(pred_freq.correct)./N.correct)*pred_prop_correct,'-xk',[ntiles.errors],(cumsum(pred_freq.errors)./N.errors)*pred_prop_errors,'-xr')
    %plot([ntiles.correct],(cumsum(obs_freq.correct)./N.correct),'ok',[ntiles.errors],(cumsum(obs_freq.errors)./N.errors),'or')
    %plot([ntiles.correct],(cumsum(pred_freq.correct)./N.correct),'-xk',[ntiles.errors],(cumsum(pred_freq.errors)./N.errors),'-xr')
    xlim([100 1200])
    ylim([0 1.1])
    
    pause(.001)
    
    cla
end