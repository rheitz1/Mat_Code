function X2 = LBA_sim_calc_X2(params,ntiles,trls,obs_freq)
rand('seed',5150);
randn('seed',5150);
normrnd('seed',5150);

plotFlag = 1;
%parameter space:
%A = maximum of uniform start point distribution
%b = threshold
%v = drift rate
%T0 = nondecision time
%sd of rate is fixed


sd_rate = evalin('caller','sd_rate');
nTrials = evalin('caller','nTrials');

slow_correct_made_dead = trls.slow.correct;
slow_errors_made_dead = trls.slow.errors;
fast_correct_made_dead_withCleared = trls.fast.correct;
fast_errors_made_dead_withCleared = trls.fast.errors;
med_correct = trls.med.correct;
med_errors = trls.med.errors;

[A.slow A.med A.fast b.slow b.med b.fast v.slow v.med v.fast T0.slow T0.med T0.fast] = disperse(params);


correct.slow(1:nTrials,1) = NaN;
correct.fast(1:nTrials,1) = NaN;
correct.med(1:nTrials,1) = NaN;

rt.slow(1:nTrials,1) = NaN;
rt.fast(1:nTrials,1) = NaN;
rt.med(1:nTrials,1) = NaN;



%% ACCURACY CONDITION
start1 = unifrnd(0,A.slow,nTrials,1);
start2 = unifrnd(0,A.slow,nTrials,1);

rate1 = normrnd(v.slow,sd_rate,nTrials,1);
%rate1(find(rate1 >= 1)) = .999;

%rate2 = normrnd(1-v.slow,sd_rate,nTrials,1);
rate2 = 1-rate1;

rtA = b.slow./rate1 - start1./rate1 + 1;
rtB = b.slow./rate2 - start2./rate2 + 1;

%If negative drift rate occurrs, negative RT will occur. Set them to impossibly large number so it never
%wins the comparison
rtA(find(rtA < 0)) = 9999999;
rtB(find(rtB < 0)) = 9999999;

rts = round(min([rtA rtB],[],2));
cor = rtA <= rtB;

correct.slow = cor;
rt.slow = rts;
clear cor rts rtA rtB

%% FAST CONDITION
start1 = unifrnd(0,A.fast,nTrials,1);
start2 = unifrnd(0,A.fast,nTrials,1);

rate1 = normrnd(v.fast,sd_rate,nTrials,1);
%rate1(find(rate1 >= 1)) = .999;

%rate2 = normrnd(1-v.fast,sd_rate,nTrials,1);
rate2 = 1-rate1;

rtA = b.fast./rate1 - start1./rate1 + 1;
rtB = b.fast./rate2 - start2./rate2 + 1;
rtA(find(rtA < 0)) = 9999999;
rtB(find(rtB < 0)) = 9999999;
rts = round(min([rtA rtB],[],2));
cor = rtA <= rtB;

correct.fast = cor;
rt.fast = rts;
clear cor rts rtA rtB

%% NEUTRAL CONDITION
start1 = unifrnd(0,A.med,nTrials,1);
start2 = unifrnd(0,A.med,nTrials,1);

rate1 = normrnd(v.med,sd_rate,nTrials,1);
%rate1(find(rate1 >= 1)) = .999;

%rate2 = normrnd(1-v.med,sd_rate,nTrials,1);
rate2 = 1-rate1;

rtA = b.med./rate1 - start1./rate1 + 1;
rtB = b.med./rate2 - start2./rate2 + 1;
rtA(find(rtA < 0)) = 9999999;
rtB(find(rtB < 0)) = 9999999;
rts = round(min([rtA rtB],[],2));
cor = rtA <= rtB;

correct.med = cor;
rt.med = rts;
clear cor rts rtA rtB


%to get total decision time, add decision time rt + nondecision time T0
rt.slow = rt.slow + T0.slow;
rt.fast = rt.fast + T0.fast;
rt.med = rt.med + T0.med;

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


simN.slow.all = length(simTrls.slow.correct) + length(simTrls.slow.errors);
simN.med.all = length(simTrls.med.correct) + length(simTrls.med.errors);
simN.fast.all = length(simTrls.fast.correct) + length(simTrls.fast.errors);

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


obs_prop_correct.slow = N.slow.correct / N.slow.all;
obs_prop_errors.slow = 1-obs_prop_correct.slow;

obs_prop_correct.med = N.med.correct / N.med.all;
obs_prop_errors.med = 1-obs_prop_correct.med;

obs_prop_correct.fast = N.fast.correct / N.fast.all;
obs_prop_errors.fast = 1-obs_prop_correct.fast;

pred_prop_correct.slow = length(simTrls.slow.correct) / simN.slow.all;
pred_prop_errors.slow = 1-pred_prop_correct.slow;

pred_prop_correct.med = length(simTrls.med.correct) / simN.med.all;
pred_prop_errors.med = 1-pred_prop_correct.med;

pred_prop_correct.fast = length(simTrls.fast.correct) / simN.fast.all;
pred_prop_errors.fast = 1-pred_prop_correct.fast;


all_obs = [obs_freq.slow.correct' ; obs_freq.slow.errors' ; obs_freq.med.correct' ; obs_freq.med.errors' ;  obs_freq.fast.correct' ; obs_freq.fast.errors'];
all_pred = [pred_freq.slow.correct' ; pred_freq.slow.errors' ; pred_freq.med.correct' ; pred_freq.med.errors' ; pred_freq.fast.correct' ; pred_freq.fast.errors'];



X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );



% disp('--------------')
% disp(mat2str(quant(params(1:3),.001)))
% disp(mat2str(quant(params(4:6),.001)))
% disp(mat2str(quant(params(7:9),.001)))
% disp(mat2str(quant(params(10:12),.001)))
% disp('--------------')


if plotFlag
    subplot(1,3,1)
    hold on
    plot([ntiles.slow.correct],(cumsum(obs_freq.slow.correct)./N.slow.correct)*obs_prop_correct.slow,'ok',[ntiles.slow.errors],(cumsum(obs_freq.slow.errors)./N.slow.errors)*obs_prop_errors.slow,'or')
    plot([ntiles.slow.correct],(cumsum(pred_freq.slow.correct)./N.slow.correct)*pred_prop_correct.slow,'-xk',[ntiles.slow.errors],(cumsum(pred_freq.slow.errors)./N.slow.errors)*pred_prop_errors.slow,'-xr')
    % plot([ntiles.slow.correct],(cumsum(obs_freq.slow.correct)./N.slow.correct),'ok',[ntiles.slow.errors],(cumsum(obs_freq.slow.errors)./N.slow.errors),'or')
    % plot([ntiles.slow.correct],(cumsum(pred_freq.slow.correct)./N.slow.correct),'-xk',[ntiles.slow.errors],(cumsum(pred_freq.slow.errors)./N.slow.errors),'-xr')
    xlim([400 1000])
    ylim([0 1])
    
    subplot(1,3,3)
    hold on
    plot([ntiles.fast.correct],(cumsum(obs_freq.fast.correct)./N.fast.correct)*obs_prop_correct.fast,'ok',[ntiles.fast.errors],(cumsum(obs_freq.fast.errors)./N.fast.errors)*obs_prop_errors.fast,'or')
    plot([ntiles.fast.correct],(cumsum(pred_freq.fast.correct)./N.fast.correct)*pred_prop_correct.fast,'-xk',[ntiles.fast.errors],(cumsum(pred_freq.fast.errors)./N.fast.errors)*pred_prop_errors.fast,'-xr')
    %plot([ntiles.fast.correct],(cumsum(obs_freq.fast.correct)./N.fast.correct),'ok',[ntiles.fast.errors],(cumsum(obs_freq.fast.errors)./N.fast.errors),'or')
    %plot([ntiles.fast.correct],(cumsum(pred_freq.fast.correct)./N.fast.correct),'-xk',[ntiles.fast.errors],(cumsum(pred_freq.fast.errors)./N.fast.errors),'-xr')
    xlim([0 600])
    ylim([0 1])
    
    subplot(1,3,2)
    hold on
    plot([ntiles.med.correct],(cumsum(obs_freq.med.correct)./N.med.correct)*obs_prop_correct.med,'ok',[ntiles.med.errors],(cumsum(obs_freq.med.errors)./N.med.errors)*obs_prop_errors.med,'or')
    plot([ntiles.med.correct],(cumsum(pred_freq.med.correct)./N.med.correct)*pred_prop_correct.med,'-xk',[ntiles.med.errors],(cumsum(pred_freq.med.errors)./N.med.errors)*pred_prop_errors.med,'-xr')
    %plot([ntiles.med.correct],(cumsum(obs_freq.med.correct)./N.med.correct),'ok',[ntiles.med.errors],(cumsum(obs_freq.med.errors)./N.med.errors),'or')
    %plot([ntiles.med.correct],(cumsum(pred_freq.med.correct)./N.med.correct),'-xk',[ntiles.med.errors],(cumsum(pred_freq.med.errors)./N.med.errors),'-xr')
    xlim([0 600])
    ylim([0 1])
    
    pause(.001)
    subplot(1,3,1)
    cla
    
    subplot(1,3,2)
    cla
    
    subplot(1,3,3)
    cla
end