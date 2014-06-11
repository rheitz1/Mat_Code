function X2 = iLBA_sim_leaky_integrator_calc_X2_fixed_b_TL(params,ntiles,trls,obs_freq,seed,simBound)
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
 
 
ss2.correct = trls.ss2.correct;
ss2.errors = trls.ss2.errors;
ss4.correct = trls.ss4.correct;
ss4.errors = trls.ss4.errors;
ss8.correct = trls.ss8.correct;
ss8.errors = trls.ss8.errors;
 
 
[A.ss2 A.ss4 A.ss8 b v.ss2 v.ss4 v.ss8 T0.ss2 T0.ss4 T0.ss8 leakage] = disperse(params);
b = b * 100;
 
 
correct.ss2(1:nTrials,1) = NaN;
correct.ss8(1:nTrials,1) = NaN;
correct.ss4(1:nTrials,1) = NaN;
 
rt.ss2(1:nTrials,1) = NaN;
rt.ss8(1:nTrials,1) = NaN;
rt.ss4(1:nTrials,1) = NaN;
 
 
 
%================
% INTEGRATION
%=====================
    % INTEGRATION
    start1.ss2 = unifrnd(0,A.ss2,nTrials,1);
    start1.ss4 = unifrnd(0,A.ss4,nTrials,1);
    start1.ss8 = unifrnd(0,A.ss8,nTrials,1);
    
    start2.ss2 = unifrnd(0,A.ss2,nTrials,1);
    start2.ss4 = unifrnd(0,A.ss4,nTrials,1);
    start2.ss8 = unifrnd(0,A.ss8,nTrials,1);
    
    %use absolute value just in case negative drift rate is selected
    rate1.ss2 = abs(normrnd(v.ss2,sd_rate,nTrials,1));
    rate1.ss4 = abs(normrnd(v.ss4,sd_rate,nTrials,1));
    rate1.ss8 = abs(normrnd(v.ss8,sd_rate,nTrials,1));
    
    rate1.ss2(find(rate1.ss2 > 1)) = .9999;
    rate1.ss4(find(rate1.ss4 > 1)) = .9999;
    rate1.ss8(find(rate1.ss8 > 1)) = .9999;
    
    rate2.ss2 = abs(normrnd(1-v.ss2,sd_rate,nTrials,1));
    rate2.ss4 = abs(normrnd(1-v.ss4,sd_rate,nTrials,1));
    rate2.ss8 = abs(normrnd(1-v.ss8,sd_rate,nTrials,1));
    
    %============
    % C++ CODE
    act1.ss2 = leaky_integrate2(rate1.ss2',start1.ss2,leakage)';
    act1.ss4 = leaky_integrate2(rate1.ss4',start1.ss4,leakage)';
    act1.ss8 = leaky_integrate2(rate1.ss8',start1.ss8,leakage)';
    
    act2.ss2 = leaky_integrate2(rate2.ss2',start2.ss2,leakage)';
    act2.ss4 = leaky_integrate2(rate2.ss4',start2.ss4,leakage)';
    act2.ss8 = leaky_integrate2(rate2.ss8',start2.ss8,leakage)';
    
    
    
    cross1.ss2 = diff(act1.ss2 > b,1,2);
    cross1.ss4 = diff(act1.ss4 > b,1,2);
    cross1.ss8 = diff(act1.ss8 > b,1,2);
    
    cross2.ss2 = diff(act2.ss2 > b,1,2);
    cross2.ss4 = diff(act2.ss4 > b,1,2);
    cross2.ss8 = diff(act2.ss8 > b,1,2);
    
    %If threshold never reached for BOTH correct and error accumulator, set to NaN
    missing1.ss2 = find(~any(cross1.ss2,2));
    missing1.ss4 = find(~any(cross1.ss4,2));
    missing1.ss8 = find(~any(cross1.ss8,2));
    
    missing2.ss2 = find(~any(cross2.ss2,2));
    missing2.ss4 = find(~any(cross2.ss4,2));
    missing2.ss8 = find(~any(cross2.ss8,2));
    
    force.ss2 = intersect(missing1.ss2,missing2.ss2);
    force.ss4 = intersect(missing1.ss4,missing2.ss4);
    force.ss8 = intersect(missing1.ss8,missing2.ss8);
 
    cross1.ss2(force.ss2,:) = NaN;
    cross1.ss4(force.ss4,:) = NaN;
    cross1.ss8(force.ss8,:) = NaN;
    
    cross2.ss2(force.ss2,:) = NaN;
    cross2.ss4(force.ss4,:) = NaN;
    cross2.ss8(force.ss8,:) = NaN;
    
    
%     force1.ss2 = find(~any(cross1.ss2,2));
%     force1.ss4 = find(~any(cross1.ss4,2));
%     force1.ss8 = find(~any(cross1.ss8,2));
%     
%     force2.ss2 = find(~any(cross2.ss2,2));
%     force2.ss4 = find(~any(cross2.ss4,2));
%     force2.ss8 = find(~any(cross2.ss8,2));
%     
%     cross1.ss2(force1.ss2,size(cross1.ss2,2)) = 1;
%     cross1.ss4(force1.ss4,size(cross1.ss4,2)) = 1;
%     cross1.ss8(force1.ss8,size(cross1.ss8,2)) = 1;
%     
%     cross2.ss2(force2.ss2,size(cross2.ss2,2)) = 1;
%     cross2.ss4(force2.ss4,size(cross2.ss4,2)) = 1;
%     cross2.ss8(force2.ss8,size(cross2.ss8,2)) = 1;
    
    %multiple logical cross1 and cross2 by sequence of column numbers to convert into real time values
    mult_mat = repmat(linspace(1,size(cross1.ss2,2),size(cross1.ss2,2)),nTrials,1);
    
    cross1.ss2 = sum(cross1.ss2 .* mult_mat,2);
    cross1.ss4 = sum(cross1.ss4 .* mult_mat,2);
    cross1.ss8 = sum(cross1.ss8 .* mult_mat,2);
    
    cross2.ss2 = sum(cross2.ss2 .* mult_mat,2);
    cross2.ss4 = sum(cross2.ss4 .* mult_mat,2);
    cross2.ss8 = sum(cross2.ss8 .* mult_mat,2);
    
    
    %Remove stray 0's from those accumulators that never reach boundary.  Just set them to arbitrarily
    %large number
    cross1.ss2(find(cross1.ss2 == 0)) = 99999;
    cross1.ss4(find(cross1.ss4 == 0)) = 99999;
    cross1.ss8(find(cross1.ss8 == 0)) = 99999;
    
    cross2.ss2(find(cross2.ss2 == 0)) = 99999;
    cross2.ss4(find(cross2.ss4 == 0)) = 99999;
    cross2.ss8(find(cross2.ss8 == 0)) = 99999;
    
    rt.ss2 = min([cross1.ss2 cross2.ss2],[],2);
    rt.ss4 = min([cross1.ss4 cross2.ss4],[],2);
    rt.ss8 = min([cross1.ss8 cross2.ss8],[],2);
    
    
    
    correct.ss2 = +(cross1.ss2 < cross2.ss2);
    correct.ss4 = +(cross1.ss4 < cross2.ss4);
    correct.ss8 = +(cross1.ss8 < cross2.ss8);
    
    %remember to remove NaNs
    correct.ss2(force.ss2) = NaN;
    correct.ss4(force.ss4) = NaN;
    correct.ss8(force.ss8) = NaN;
 
 
 
% REMOVE RTs OUTSIDE OF BOUNDS (EQUIVALENT TO RESPONSE DEADLINES)
if truncSim
    correct.ss2(find(rt.ss2+T0.ss2 > simBound.ss2)) = NaN;
    correct.ss4(find(rt.ss4+T0.ss4 > simBound.ss4)) = NaN;
    correct.ss8(find(rt.ss8+T0.ss8 > simBound.ss8)) = NaN;
    
    rt.ss2(find(rt.ss2+T0.ss2 > simBound.ss2)) = NaN;
    rt.ss4(find(rt.ss4+T0.ss4 > simBound.ss4)) = NaN;
    rt.ss8(find(rt.ss8+T0.ss8 > simBound.ss8)) = NaN;
end
 
%========================================
% END INTEGRATION
 
 
 
 
%to get total decision time, add decision time rt + nondecision time T0
rt.ss2 = rt.ss2 + T0.ss2 + 1;  %correct for diff operation earlier;
rt.ss8 = rt.ss8 + T0.ss8 + 1;
rt.ss4 = rt.ss4 + T0.ss4 + 1;
 
 
simTrls.ss2.correct = find(correct.ss2 == 1);
simTrls.ss2.errors = find(correct.ss2 == 0);
simTrls.ss8.correct = find(correct.ss8 == 1);
simTrls.ss8.errors = find(correct.ss8 == 0);
simTrls.ss4.correct = find(correct.ss4 == 1);
simTrls.ss4.errors = find(correct.ss4 == 0);
 
 
N.ss2.correct = length(ss2.correct);
N.ss2.errors = length(ss2.errors);
N.ss2.all = N.ss2.correct + N.ss2.errors;
N.ss8.correct = length(ss8.correct);
N.ss8.errors = length(ss8.errors);
N.ss8.all = N.ss8.correct + N.ss8.errors;
N.ss4.correct = length(ss4.correct);
N.ss4.errors = length(ss4.errors);
N.ss4.all = length(ss4.correct) + length(ss4.errors);
 
simN.ss2.correct = length(simTrls.ss2.correct);
simN.ss2.errors = length(simTrls.ss2.errors);
simN.ss2.all = simN.ss2.correct + simN.ss2.errors;
simN.ss8.correct = length(simTrls.ss8.correct);
simN.ss8.errors = length(simTrls.ss8.errors);
simN.ss8.all = simN.ss8.correct + simN.ss8.errors;
simN.ss4.correct = length(simTrls.ss4.correct);
simN.ss4.errors = length(simTrls.ss4.errors);
simN.ss4.all = simN.ss4.correct + simN.ss4.errors;
 
 
pred_prop.ss2.correct(1) = length(find(rt.ss2(simTrls.ss2.correct) <= ntiles.ss2.correct(1))) / simN.ss2.all;
pred_prop.ss2.correct(2) = length(find(rt.ss2(simTrls.ss2.correct) > ntiles.ss2.correct(1) & rt.ss2(simTrls.ss2.correct) <= ntiles.ss2.correct(2))) / simN.ss2.all;
pred_prop.ss2.correct(3) = length(find(rt.ss2(simTrls.ss2.correct) > ntiles.ss2.correct(2) & rt.ss2(simTrls.ss2.correct) <= ntiles.ss2.correct(3))) / simN.ss2.all;
pred_prop.ss2.correct(4) = length(find(rt.ss2(simTrls.ss2.correct) > ntiles.ss2.correct(3) & rt.ss2(simTrls.ss2.correct) <= ntiles.ss2.correct(4))) / simN.ss2.all;
pred_prop.ss2.correct(5) = length(find(rt.ss2(simTrls.ss2.correct) > ntiles.ss2.correct(4) & rt.ss2(simTrls.ss2.correct) <= ntiles.ss2.correct(5))) / simN.ss2.all;
pred_prop.ss2.correct(6) = length(find(rt.ss2(simTrls.ss2.correct) > ntiles.ss2.correct(5))) / simN.ss2.all;
 
pred_prop.ss2.errors(1) = length(find(rt.ss2(simTrls.ss2.errors) <= ntiles.ss2.errors(1))) / simN.ss2.all;
pred_prop.ss2.errors(2) = length(find(rt.ss2(simTrls.ss2.errors) > ntiles.ss2.errors(1) & rt.ss2(simTrls.ss2.errors) <= ntiles.ss2.errors(2))) / simN.ss2.all;
pred_prop.ss2.errors(3) = length(find(rt.ss2(simTrls.ss2.errors) > ntiles.ss2.errors(2) & rt.ss2(simTrls.ss2.errors) <= ntiles.ss2.errors(3))) / simN.ss2.all;
pred_prop.ss2.errors(4) = length(find(rt.ss2(simTrls.ss2.errors) > ntiles.ss2.errors(3) & rt.ss2(simTrls.ss2.errors) <= ntiles.ss2.errors(4))) / simN.ss2.all;
pred_prop.ss2.errors(5) = length(find(rt.ss2(simTrls.ss2.errors) > ntiles.ss2.errors(4) & rt.ss2(simTrls.ss2.errors) <= ntiles.ss2.errors(5))) / simN.ss2.all;
pred_prop.ss2.errors(6) = length(find(rt.ss2(simTrls.ss2.errors) > ntiles.ss2.errors(5))) / simN.ss2.all;
 
pred_prop.ss8.correct(1) = length(find(rt.ss8(simTrls.ss8.correct) <= ntiles.ss8.correct(1))) / simN.ss8.all;
pred_prop.ss8.correct(2) = length(find(rt.ss8(simTrls.ss8.correct) > ntiles.ss8.correct(1) & rt.ss8(simTrls.ss8.correct) <= ntiles.ss8.correct(2))) / simN.ss8.all;
pred_prop.ss8.correct(3) = length(find(rt.ss8(simTrls.ss8.correct) > ntiles.ss8.correct(2) & rt.ss8(simTrls.ss8.correct) <= ntiles.ss8.correct(3))) / simN.ss8.all;
pred_prop.ss8.correct(4) = length(find(rt.ss8(simTrls.ss8.correct) > ntiles.ss8.correct(3) & rt.ss8(simTrls.ss8.correct) <= ntiles.ss8.correct(4))) / simN.ss8.all;
pred_prop.ss8.correct(5) = length(find(rt.ss8(simTrls.ss8.correct) > ntiles.ss8.correct(4) & rt.ss8(simTrls.ss8.correct) <= ntiles.ss8.correct(5))) / simN.ss8.all;
pred_prop.ss8.correct(6) = length(find(rt.ss8(simTrls.ss8.correct) > ntiles.ss8.correct(5))) / simN.ss8.all;
 
pred_prop.ss8.errors(1) = length(find(rt.ss8(simTrls.ss8.errors) <= ntiles.ss8.errors(1))) / simN.ss8.all;
pred_prop.ss8.errors(2) = length(find(rt.ss8(simTrls.ss8.errors) > ntiles.ss8.errors(1) & rt.ss8(simTrls.ss8.errors) <= ntiles.ss8.errors(2))) / simN.ss8.all;
pred_prop.ss8.errors(3) = length(find(rt.ss8(simTrls.ss8.errors) > ntiles.ss8.errors(2) & rt.ss8(simTrls.ss8.errors) <= ntiles.ss8.errors(3))) / simN.ss8.all;
pred_prop.ss8.errors(4) = length(find(rt.ss8(simTrls.ss8.errors) > ntiles.ss8.errors(3) & rt.ss8(simTrls.ss8.errors) <= ntiles.ss8.errors(4))) / simN.ss8.all;
pred_prop.ss8.errors(5) = length(find(rt.ss8(simTrls.ss8.errors) > ntiles.ss8.errors(4) & rt.ss8(simTrls.ss8.errors) <= ntiles.ss8.errors(5))) / simN.ss8.all;
pred_prop.ss8.errors(6) = length(find(rt.ss8(simTrls.ss8.errors) > ntiles.ss8.errors(5))) / simN.ss8.all;
 
pred_prop.ss4.correct(1) = length(find(rt.ss4(simTrls.ss4.correct) <= ntiles.ss4.correct(1))) / simN.ss4.all;
pred_prop.ss4.correct(2) = length(find(rt.ss4(simTrls.ss4.correct) > ntiles.ss4.correct(1) & rt.ss4(simTrls.ss4.correct) <= ntiles.ss4.correct(2))) / simN.ss4.all;
pred_prop.ss4.correct(3) = length(find(rt.ss4(simTrls.ss4.correct) > ntiles.ss4.correct(2) & rt.ss4(simTrls.ss4.correct) <= ntiles.ss4.correct(3))) / simN.ss4.all;
pred_prop.ss4.correct(4) = length(find(rt.ss4(simTrls.ss4.correct) > ntiles.ss4.correct(3) & rt.ss4(simTrls.ss4.correct) <= ntiles.ss4.correct(4))) / simN.ss4.all;
pred_prop.ss4.correct(5) = length(find(rt.ss4(simTrls.ss4.correct) > ntiles.ss4.correct(4) & rt.ss4(simTrls.ss4.correct) <= ntiles.ss4.correct(5))) / simN.ss4.all;
pred_prop.ss4.correct(6) = length(find(rt.ss4(simTrls.ss4.correct) > ntiles.ss4.correct(5))) / simN.ss4.all;
 
pred_prop.ss4.errors(1) = length(find(rt.ss4(simTrls.ss4.errors) <= ntiles.ss4.errors(1))) / simN.ss4.all;
pred_prop.ss4.errors(2) = length(find(rt.ss4(simTrls.ss4.errors) > ntiles.ss4.errors(1) & rt.ss4(simTrls.ss4.errors) <= ntiles.ss4.errors(2))) / simN.ss4.all;
pred_prop.ss4.errors(3) = length(find(rt.ss4(simTrls.ss4.errors) > ntiles.ss4.errors(2) & rt.ss4(simTrls.ss4.errors) <= ntiles.ss4.errors(3))) / simN.ss4.all;
pred_prop.ss4.errors(4) = length(find(rt.ss4(simTrls.ss4.errors) > ntiles.ss4.errors(3) & rt.ss4(simTrls.ss4.errors) <= ntiles.ss4.errors(4))) / simN.ss4.all;
pred_prop.ss4.errors(5) = length(find(rt.ss4(simTrls.ss4.errors) > ntiles.ss4.errors(4) & rt.ss4(simTrls.ss4.errors) <= ntiles.ss4.errors(5))) / simN.ss4.all;
pred_prop.ss4.errors(6) = length(find(rt.ss4(simTrls.ss4.errors) > ntiles.ss4.errors(5))) / simN.ss4.all;
 
 
pred_freq.ss2.correct = pred_prop.ss2.correct .* N.ss2.all;
pred_freq.ss2.errors = pred_prop.ss2.errors .* N.ss2.all;
pred_freq.ss8.correct = pred_prop.ss8.correct .* N.ss8.all;
pred_freq.ss8.errors = pred_prop.ss8.errors .* N.ss8.all;
pred_freq.ss4.correct = pred_prop.ss4.correct .* N.ss4.all;
pred_freq.ss4.errors = pred_prop.ss4.errors .* N.ss4.all;
 
 
all_obs = [obs_freq.ss2.correct' ; obs_freq.ss2.errors' ; obs_freq.ss4.correct' ; obs_freq.ss4.errors' ;  obs_freq.ss8.correct' ; obs_freq.ss8.errors'];
all_pred = [pred_freq.ss2.correct' ; pred_freq.ss2.errors' ; pred_freq.ss4.correct' ; pred_freq.ss4.errors' ; pred_freq.ss8.correct' ; pred_freq.ss8.errors'];
 
 
 
all_pred(find(isnan(all_pred))) = 0;
 
 
%X2 = sum( (all_obs - all_pred).^2 ./ (all_pred) ) + .00001;
X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );
 
 
obs_prop_correct.ss2 = N.ss2.correct / N.ss2.all;
obs_prop_errors.ss2 = 1-obs_prop_correct.ss2;
 
obs_prop_correct.ss8 = N.ss8.correct / N.ss8.all;
obs_prop_errors.ss8 = 1-obs_prop_correct.ss8;
 
obs_prop_correct.ss4 = N.ss4.correct / N.ss4.all;
obs_prop_errors.ss4 = 1-obs_prop_correct.ss4;
 
pred_prop_correct.ss2 = length(simTrls.ss2.correct) / (length(simTrls.ss2.correct) + length(simTrls.ss2.errors));
pred_prop_errors.ss2 = 1-pred_prop_correct.ss2;
 
pred_prop_correct.ss8 = length(simTrls.ss8.correct) / (length(simTrls.ss8.correct) + length(simTrls.ss8.errors));
pred_prop_errors.ss8 = 1-pred_prop_correct.ss8;
 
pred_prop_correct.ss4 = length(simTrls.ss4.correct) / (length(simTrls.ss4.correct) + length(simTrls.ss4.errors));
pred_prop_errors.ss4 = 1-pred_prop_correct.ss4;
 
 
 
if plotFlag
    subplot(1,3,1)
    hold on
    plot([ntiles.ss2.correct],(cumsum(obs_freq.ss2.correct)./N.ss2.correct)*obs_prop_correct.ss2,'ok',[ntiles.ss2.errors],(cumsum(obs_freq.ss2.errors)./N.ss2.errors)*obs_prop_errors.ss2,'or')
    plot([ntiles.ss2.correct],(cumsum(pred_freq.ss2.correct)./N.ss2.correct)*pred_prop_correct.ss2,'-xk',[ntiles.ss2.errors],(cumsum(pred_freq.ss2.errors)./N.ss2.errors)*pred_prop_errors.ss2,'-xr')
    xlim([100 600])
    ylim([0 1])
    
    subplot(1,3,3)
    hold on
    plot([ntiles.ss8.correct],(cumsum(obs_freq.ss8.correct)./N.ss8.correct)*obs_prop_correct.ss8,'ok',[ntiles.ss8.errors],(cumsum(obs_freq.ss8.errors)./N.ss8.errors)*obs_prop_errors.ss8,'or')
    plot([ntiles.ss8.correct],(cumsum(pred_freq.ss8.correct)./N.ss8.correct)*pred_prop_correct.ss8,'-xk',[ntiles.ss8.errors],(cumsum(pred_freq.ss8.errors)./N.ss8.errors)*pred_prop_errors.ss8,'-xr')
    xlim([100 600])
    ylim([0 1])
    
    subplot(1,3,2)
    hold on
    plot([ntiles.ss4.correct],(cumsum(obs_freq.ss4.correct)./N.ss4.correct)*obs_prop_correct.ss4,'ok',[ntiles.ss4.errors],(cumsum(obs_freq.ss4.errors)./N.ss4.errors)*obs_prop_errors.ss4,'or')
    plot([ntiles.ss4.correct],(cumsum(pred_freq.ss4.correct)./N.ss4.correct)*pred_prop_correct.ss4,'-xk',[ntiles.ss4.errors],(cumsum(pred_freq.ss4.errors)./N.ss4.errors)*pred_prop_errors.ss4,'-xr')
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
