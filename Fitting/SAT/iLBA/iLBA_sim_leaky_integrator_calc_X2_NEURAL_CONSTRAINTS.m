function X2 = iLBA_sim_leaky_integrator_calc_X2_NEURAL_CONSTRAINTS(params,ntiles,trls,obs_freq,seed,simBound)
plotFlag = 1;

rand('seed',seed);
randn('seed',seed);
normrnd('seed',seed);

%parameter space:
%A = maximum of uniform start point distribution
%b = threshold
%v = drift rate
%T0 = nondecision time
%sd of rate is fixed

nTrials = evalin('caller','nTrials');
truncSim = evalin('caller','truncSim');
sd_rate = evalin('caller','sd_rate');


slow_correct_made_dead = trls.slow.correct;
slow_errors_made_dead = trls.slow.errors;
fast_correct_made_dead_withCleared = trls.fast.correct;
fast_errors_made_dead_withCleared = trls.fast.errors;
med_correct = trls.med.correct;
med_errors = trls.med.errors;



[A.slow A.med A.fast b v.slow v.med v.fast T0.slow T0.med T0.fast leakage] = disperse(params);
b = b * 100;


correct.slow(1:nTrials,1) = NaN;
correct.fast(1:nTrials,1) = NaN;
correct.med(1:nTrials,1) = NaN;

rt.slow(1:nTrials,1) = NaN;
rt.fast(1:nTrials,1) = NaN;
rt.med(1:nTrials,1) = NaN;



%================
% INTEGRATION
%=====================
    % INTEGRATION
    start1.slow = unifrnd(0,A.slow,nTrials,1);
    start1.med = unifrnd(0,A.med,nTrials,1);
    start1.fast = unifrnd(0,A.fast,nTrials,1);
    
    start2.slow = unifrnd(0,A.slow,nTrials,1);
    start2.med = unifrnd(0,A.med,nTrials,1);
    start2.fast = unifrnd(0,A.fast,nTrials,1);
    
    %use absolute value just in case negative drift rate is selected
    rate1.slow = abs(normrnd(v.slow,sd_rate,nTrials,1));
    rate1.med = abs(normrnd(v.med,sd_rate,nTrials,1));
    rate1.fast = abs(normrnd(v.fast,sd_rate,nTrials,1));
    
    rate1.slow(find(rate1.slow > 1)) = .9999;
    rate1.med(find(rate1.med > 1)) = .9999;
    rate1.fast(find(rate1.fast > 1)) = .9999;
    
    rate2.slow = abs(normrnd(1-v.slow,sd_rate,nTrials,1));
    rate2.med = abs(normrnd(1-v.med,sd_rate,nTrials,1));
    rate2.fast = abs(normrnd(1-v.fast,sd_rate,nTrials,1));
    
    %============
    % C++ CODE
    act1.slow = leaky_integrate2(rate1.slow',start1.slow,leakage)';
    act1.med = leaky_integrate2(rate1.med',start1.med,leakage)';
    act1.fast = leaky_integrate2(rate1.fast',start1.fast,leakage)';
    
    act2.slow = leaky_integrate2(rate2.slow',start2.slow,leakage)';
    act2.med = leaky_integrate2(rate2.med',start2.med,leakage)';
    act2.fast = leaky_integrate2(rate2.fast',start2.fast,leakage)';
    
    
    
    cross1.slow = diff(act1.slow > b,1,2);
    cross1.med = diff(act1.med > b,1,2);
    cross1.fast = diff(act1.fast > b,1,2);
    
    cross2.slow = diff(act2.slow > b,1,2);
    cross2.med = diff(act2.med > b,1,2);
    cross2.fast = diff(act2.fast > b,1,2);
    
    %If threshold never reached for BOTH correct and error accumulator, set to NaN
    missing1.slow = find(~any(cross1.slow,2));
    missing1.med = find(~any(cross1.med,2));
    missing1.fast = find(~any(cross1.fast,2));
    
    missing2.slow = find(~any(cross2.slow,2));
    missing2.med = find(~any(cross2.med,2));
    missing2.fast = find(~any(cross2.fast,2));
    
    force.slow = intersect(missing1.slow,missing2.slow);
    force.med = intersect(missing1.med,missing2.med);
    force.fast = intersect(missing1.fast,missing2.fast);

    cross1.slow(force.slow,:) = NaN;
    cross1.med(force.med,:) = NaN;
    cross1.fast(force.fast,:) = NaN;
    
    cross2.slow(force.slow,:) = NaN;
    cross2.med(force.med,:) = NaN;
    cross2.fast(force.fast,:) = NaN;
    
    
%     force1.slow = find(~any(cross1.slow,2));
%     force1.med = find(~any(cross1.med,2));
%     force1.fast = find(~any(cross1.fast,2));
%     
%     force2.slow = find(~any(cross2.slow,2));
%     force2.med = find(~any(cross2.med,2));
%     force2.fast = find(~any(cross2.fast,2));
%     
%     cross1.slow(force1.slow,size(cross1.slow,2)) = 1;
%     cross1.med(force1.med,size(cross1.med,2)) = 1;
%     cross1.fast(force1.fast,size(cross1.fast,2)) = 1;
%     
%     cross2.slow(force2.slow,size(cross2.slow,2)) = 1;
%     cross2.med(force2.med,size(cross2.med,2)) = 1;
%     cross2.fast(force2.fast,size(cross2.fast,2)) = 1;
    
    %multiple logical cross1 and cross2 by sequence of column numbers to convert into real time values
    mult_mat = repmat(linspace(1,size(cross1.slow,2),size(cross1.slow,2)),nTrials,1);
    
    cross1.slow = sum(cross1.slow .* mult_mat,2);
    cross1.med = sum(cross1.med .* mult_mat,2);
    cross1.fast = sum(cross1.fast .* mult_mat,2);
    
    cross2.slow = sum(cross2.slow .* mult_mat,2);
    cross2.med = sum(cross2.med .* mult_mat,2);
    cross2.fast = sum(cross2.fast .* mult_mat,2);
    
    
    %Remove stray 0's from those accumulators that never reach boundary.  Just set them to arbitrarily
    %large number
    cross1.slow(find(cross1.slow == 0)) = 99999;
    cross1.med(find(cross1.med == 0)) = 99999;
    cross1.fast(find(cross1.fast == 0)) = 99999;
    
    cross2.slow(find(cross2.slow == 0)) = 99999;
    cross2.med(find(cross2.med == 0)) = 99999;
    cross2.fast(find(cross2.fast == 0)) = 99999;
    
    rt.slow = min([cross1.slow cross2.slow],[],2);
    rt.med = min([cross1.med cross2.med],[],2);
    rt.fast = min([cross1.fast cross2.fast],[],2);
    
    
    
    correct.slow = +(cross1.slow < cross2.slow);
    correct.med = +(cross1.med < cross2.med);
    correct.fast = +(cross1.fast < cross2.fast);
    
    %remember to remove NaNs
    correct.slow(force.slow) = NaN;
    correct.med(force.med) = NaN;
    correct.fast(force.fast) = NaN;



% REMOVE RTs OUTSIDE OF BOUNDS (EQUIVALENT TO RESPONSE DEADLINES)
if truncSim
%     correct.slow(find(rt.slow+T0.slow < simBound.slow)) = NaN;
%     correct.med(find(rt.med+T0.med > simBound.med)) = NaN;
%     correct.fast(find(rt.fast+T0.fast > simBound.fast)) = NaN;
%     
%     rt.slow(find(rt.slow+T0.slow < simBound.slow)) = NaN;
%     rt.med(find(rt.med+T0.med > simBound.med)) = NaN;
%     rt.fast(find(rt.fast+T0.fast > simBound.fast)) = NaN;

    correct.slow(find(rt.slow+T0.slow < simBound.slow(1))) = NaN;
    correct.slow(find(rt.slow+T0.slow > simBound.slow(2))) = NaN;
    correct.med(find(rt.med+T0.med < simBound.med(1))) = NaN;
    correct.med(find(rt.med+T0.med > simBound.med(2))) = NaN;
    correct.fast(find(rt.fast+T0.fast < simBound.fast(1))) = NaN;
    correct.fast(find(rt.fast+T0.fast > simBound.fast(2))) = NaN;
    
    rt.slow(find(rt.slow+T0.slow < simBound.slow(1))) = NaN;
    rt.slow(find(rt.slow+T0.slow > simBound.slow(2))) = NaN;
    rt.med(find(rt.med+T0.med < simBound.med(1))) = NaN;
    rt.med(find(rt.med+T0.med > simBound.med(2))) = NaN;
    rt.fast(find(rt.fast+T0.fast < simBound.fast(1))) = NaN;
    rt.fast(find(rt.fast+T0.fast > simBound.fast(2))) = NaN;
end
%========================================
% END INTEGRATION




%to get total decision time, add decision time rt + nondecision time T0
rt.slow = rt.slow + T0.slow + 1;  %correct for diff operation earlier;
rt.fast = rt.fast + T0.fast + 1;
rt.med = rt.med + T0.med + 1;


simTrls.slow.correct = find(correct.slow == 1);
simTrls.slow.errors = find(correct.slow == 0);
simTrls.fast.correct = find(correct.fast == 1);
simTrls.fast.errors = find(correct.fast == 0);
simTrls.med.correct = find(correct.med == 1);
simTrls.med.errors = find(correct.med == 0);


N.slow.correct = length(slow_correct_made_dead);
N.slow.errors = length(slow_errors_made_dead);
N.slow.all = N.slow.correct + N.slow.errors;
N.fast.correct = length(fast_correct_made_dead_withCleared);
N.fast.errors = length(fast_errors_made_dead_withCleared);
N.fast.all = N.fast.correct + N.fast.errors;
N.med.correct = length(med_correct);
N.med.errors = length(med_errors);
N.med.all = length(med_correct) + length(med_errors);

simN.slow.correct = length(simTrls.slow.correct);
simN.slow.errors = length(simTrls.slow.errors);
simN.slow.all = simN.slow.correct + simN.slow.errors;
simN.fast.correct = length(simTrls.fast.correct);
simN.fast.errors = length(simTrls.fast.errors);
simN.fast.all = simN.fast.correct + simN.fast.errors;
simN.med.correct = length(simTrls.med.correct);
simN.med.errors = length(simTrls.med.errors);
simN.med.all = simN.med.correct + simN.med.errors;


pred_prop.slow.correct(1) = length(find(rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(1))) / simN.slow.all;
pred_prop.slow.correct(2) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(1) & rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(2))) / simN.slow.all;
pred_prop.slow.correct(3) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(2) & rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(3))) / simN.slow.all;
pred_prop.slow.correct(4) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(3) & rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(4))) / simN.slow.all;
pred_prop.slow.correct(5) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(4) & rt.slow(simTrls.slow.correct) <= ntiles.slow.correct(5))) / simN.slow.all;
pred_prop.slow.correct(6) = length(find(rt.slow(simTrls.slow.correct) > ntiles.slow.correct(5))) / simN.slow.all;

pred_prop.slow.errors(1) = length(find(rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(1))) / simN.slow.all;
pred_prop.slow.errors(2) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(1) & rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(2))) / simN.slow.all;
pred_prop.slow.errors(3) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(2) & rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(3))) / simN.slow.all;
pred_prop.slow.errors(4) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(3) & rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(4))) / simN.slow.all;
pred_prop.slow.errors(5) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(4) & rt.slow(simTrls.slow.errors) <= ntiles.slow.errors(5))) / simN.slow.all;
pred_prop.slow.errors(6) = length(find(rt.slow(simTrls.slow.errors) > ntiles.slow.errors(5))) / simN.slow.all;

pred_prop.fast.correct(1) = length(find(rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(1))) / simN.fast.all;
pred_prop.fast.correct(2) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(1) & rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(2))) / simN.fast.all;
pred_prop.fast.correct(3) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(2) & rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(3))) / simN.fast.all;
pred_prop.fast.correct(4) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(3) & rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(4))) / simN.fast.all;
pred_prop.fast.correct(5) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(4) & rt.fast(simTrls.fast.correct) <= ntiles.fast.correct(5))) / simN.fast.all;
pred_prop.fast.correct(6) = length(find(rt.fast(simTrls.fast.correct) > ntiles.fast.correct(5))) / simN.fast.all;

pred_prop.fast.errors(1) = length(find(rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(1))) / simN.fast.all;
pred_prop.fast.errors(2) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(1) & rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(2))) / simN.fast.all;
pred_prop.fast.errors(3) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(2) & rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(3))) / simN.fast.all;
pred_prop.fast.errors(4) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(3) & rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(4))) / simN.fast.all;
pred_prop.fast.errors(5) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(4) & rt.fast(simTrls.fast.errors) <= ntiles.fast.errors(5))) / simN.fast.all;
pred_prop.fast.errors(6) = length(find(rt.fast(simTrls.fast.errors) > ntiles.fast.errors(5))) / simN.fast.all;

pred_prop.med.correct(1) = length(find(rt.med(simTrls.med.correct) <= ntiles.med.correct(1))) / simN.med.all;
pred_prop.med.correct(2) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(1) & rt.med(simTrls.med.correct) <= ntiles.med.correct(2))) / simN.med.all;
pred_prop.med.correct(3) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(2) & rt.med(simTrls.med.correct) <= ntiles.med.correct(3))) / simN.med.all;
pred_prop.med.correct(4) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(3) & rt.med(simTrls.med.correct) <= ntiles.med.correct(4))) / simN.med.all;
pred_prop.med.correct(5) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(4) & rt.med(simTrls.med.correct) <= ntiles.med.correct(5))) / simN.med.all;
pred_prop.med.correct(6) = length(find(rt.med(simTrls.med.correct) > ntiles.med.correct(5))) / simN.med.all;

pred_prop.med.errors(1) = length(find(rt.med(simTrls.med.errors) <= ntiles.med.errors(1))) / simN.med.all;
pred_prop.med.errors(2) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(1) & rt.med(simTrls.med.errors) <= ntiles.med.errors(2))) / simN.med.all;
pred_prop.med.errors(3) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(2) & rt.med(simTrls.med.errors) <= ntiles.med.errors(3))) / simN.med.all;
pred_prop.med.errors(4) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(3) & rt.med(simTrls.med.errors) <= ntiles.med.errors(4))) / simN.med.all;
pred_prop.med.errors(5) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(4) & rt.med(simTrls.med.errors) <= ntiles.med.errors(5))) / simN.med.all;
pred_prop.med.errors(6) = length(find(rt.med(simTrls.med.errors) > ntiles.med.errors(5))) / simN.med.all;


pred_freq.slow.correct = pred_prop.slow.correct .* N.slow.all;
pred_freq.slow.errors = pred_prop.slow.errors .* N.slow.all;
pred_freq.fast.correct = pred_prop.fast.correct .* N.fast.all;
pred_freq.fast.errors = pred_prop.fast.errors .* N.fast.all;
pred_freq.med.correct = pred_prop.med.correct .* N.med.all;
pred_freq.med.errors = pred_prop.med.errors .* N.med.all;


all_obs = [obs_freq.slow.correct' ; obs_freq.slow.errors' ; obs_freq.med.correct' ; obs_freq.med.errors' ;  obs_freq.fast.correct' ; obs_freq.fast.errors'];
all_pred = [pred_freq.slow.correct' ; pred_freq.slow.errors' ; pred_freq.med.correct' ; pred_freq.med.errors' ; pred_freq.fast.correct' ; pred_freq.fast.errors'];



all_pred(find(isnan(all_pred))) = 0;


%X2 = sum( (all_obs - all_pred).^2 ./ (all_pred) ) + .00001;
X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );


obs_prop_correct.slow = N.slow.correct / N.slow.all;
obs_prop_errors.slow = 1-obs_prop_correct.slow;

obs_prop_correct.fast = N.fast.correct / N.fast.all;
obs_prop_errors.fast = 1-obs_prop_correct.fast;

obs_prop_correct.med = N.med.correct / N.med.all;
obs_prop_errors.med = 1-obs_prop_correct.med;

pred_prop_correct.slow = length(simTrls.slow.correct) / (length(simTrls.slow.correct) + length(simTrls.slow.errors));
pred_prop_errors.slow = 1-pred_prop_correct.slow;

pred_prop_correct.fast = length(simTrls.fast.correct) / (length(simTrls.fast.correct) + length(simTrls.fast.errors));
pred_prop_errors.fast = 1-pred_prop_correct.fast;

pred_prop_correct.med = length(simTrls.med.correct) / (length(simTrls.med.correct) + length(simTrls.med.errors));
pred_prop_errors.med = 1-pred_prop_correct.med;



if plotFlag
    subplot(1,3,1)
    hold on
    plot([ntiles.slow.correct],(cumsum(obs_freq.slow.correct)./N.slow.correct)*obs_prop_correct.slow,'ok',[ntiles.slow.errors],(cumsum(obs_freq.slow.errors)./N.slow.errors)*obs_prop_errors.slow,'or')
    plot([ntiles.slow.correct],(cumsum(pred_freq.slow.correct)./N.slow.correct)*pred_prop_correct.slow,'-xk',[ntiles.slow.errors],(cumsum(pred_freq.slow.errors)./N.slow.errors)*pred_prop_errors.slow,'-xr')
    xlim([300 900])
    ylim([0 1])
    
    subplot(1,3,3)
    hold on
    plot([ntiles.fast.correct],(cumsum(obs_freq.fast.correct)./N.fast.correct)*obs_prop_correct.fast,'ok',[ntiles.fast.errors],(cumsum(obs_freq.fast.errors)./N.fast.errors)*obs_prop_errors.fast,'or')
    plot([ntiles.fast.correct],(cumsum(pred_freq.fast.correct)./N.fast.correct)*pred_prop_correct.fast,'-xk',[ntiles.fast.errors],(cumsum(pred_freq.fast.errors)./N.fast.errors)*pred_prop_errors.fast,'-xr')
    xlim([100 600])
    ylim([0 1])
    
    subplot(1,3,2)
    hold on
    plot([ntiles.med.correct],(cumsum(obs_freq.med.correct)./N.med.correct)*obs_prop_correct.med,'ok',[ntiles.med.errors],(cumsum(obs_freq.med.errors)./N.med.errors)*obs_prop_errors.med,'or')
    plot([ntiles.med.correct],(cumsum(pred_freq.med.correct)./N.med.correct)*pred_prop_correct.med,'-xk',[ntiles.med.errors],(cumsum(pred_freq.med.errors)./N.med.errors)*pred_prop_errors.med,'-xr')
    xlim([100 600])
    ylim([0 1])
    
    %     disp('--------------')
    %     disp(mat2str(quant(params(1:3),.001)))
    %     disp(mat2str(quant(params(4),.001)))
    %     disp(mat2str(quant(params(5:7),.001)))
    %     disp(mat2str(quant(params(8:10),.001)))
    %     disp('--------------')
    
    pause(.001)
    subplot(1,3,1)
    cla
    
    subplot(1,3,2)
    cla
    
    subplot(1,3,3)
    cla
end