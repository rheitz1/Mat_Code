function X2 = LBA_sim_calc_X2(params,ntiles,trls,obs_freq)
plotFlag = 1;
%parameter space:
%A = maximum of uniform start point distribution
%b = threshold
%v = drift rate
%T0 = nondecision time
%sd of rate is fixed
%SRT = evalin('caller','SRT');
slow_correct_made_dead = trls.slow_correct_made_dead;
slow_errors_made_dead = trls.slow_errors_made_dead;

A = params(1);
b = params(2);
v = params(3);
T0 = params(4);
sd_rate = .1;
disp(mat2str(quant([A b v T0 sd_rate],.001)))
%
% top_start1 = 50;
% top_start2 = 50;
%
% mean_rate1 = .8;
% mean_rate2 = .7;
%
% sd_rate = .01;
%
% thresh1 = 200;
% thresh2 = 200;

nTrials = 10000;

act1 = zeros(nTrials,10000);
act2 = act1;

correct(1:nTrials,1) = 0;
rt(1:nTrials,1) = NaN;

parfor n = 1:nTrials
    start1 = unifrnd(0,A);
    start2 = unifrnd(0,A);
    
    rate1 = normrnd(v,sd_rate);
    rate2 = normrnd(1-v,sd_rate);
    
    
    act1 = start1:rate1:b;
    act2 = start2:rate2:b;
    
    
    
    %    act1 = unifrnd(0,A):normrnd(v,sd_rate):b;
    %    act2 = unifrnd(0,A):normrnd(1-v,sd_rate):b;
    
    %find which unit won first
    if find(act1,1,'last') < find(act2,1,'last')
        correct(n,1) = 1;
        rt(n,1) = find(act1,1,'last');
    elseif find(act1,1,'last') == find(act2,1,'last')
        if rand <= .5
            correct(n,1) = 1;
        else
            correct(n,1) = 0;
        end
        rt(n,1) = find(act1,1,'last'); %will be the same either way
    elseif find(act1,1,'last') > find(act2,1,'last')
        rt(n,1) = find(act2,1,'last');
        correct(n,1) = 0;
    else
        rt(n,1) = NaN;
    end
    
    %         all_act1(n,1:length(act1)) = act1;
    %         all_act2(n,1:length(act2)) = act2;
    %        disp('hi')
end


%to get total decision time, add decision time rt + nondecision time T0
rt = rt + T0;
%
% all_act1(find(all_act1 == 0)) = NaN;
% all_act2(find(all_act2 == 0)) = NaN;


trls.correct = find(correct == 1);
trls.errors = find(correct == 0);
nT = length(trls.correct) + length(trls.errors);
%
% %get predicted quantiles
% nts = [10 ; 30 ; 50 ; 70 ; 90];
%
%
% ntiles.correct = prctile(SRT(slow_correct_made_dead,1),nts);
% ntiles.errors = prctile(SRT(slow_errors_made_dead,1),nts);
% N.correct = length(slow_correct_made_dead);
% N.errors = length(slow_errors_made_dead);
% N.all = N.correct + N.errors;
%
% nl = .1 * N.correct;
% nh = .2 * N.correct;
% obs_freq.correct = [nl nh nh nh nh nl];
% clear nl nh
%
% nl = .1 * N.errors;
% nh = .2 * N.errors;
% obs_freq.errors = [nl nh nh nh nh nl];
% clear nl nh


N.correct = length(slow_correct_made_dead);
N.errors = length(slow_errors_made_dead);
N.all = N.correct + N.errors;

pred_prop.correct(1) = length(find(rt(trls.correct) <= ntiles.correct(1))) / length(trls.correct);
pred_prop.correct(2) = length(find(rt(trls.correct) > ntiles.correct(1) & rt(trls.correct) <= ntiles.correct(2))) / length(trls.correct);
pred_prop.correct(3) = length(find(rt(trls.correct) > ntiles.correct(2) & rt(trls.correct) <= ntiles.correct(3))) / length(trls.correct);
pred_prop.correct(4) = length(find(rt(trls.correct) > ntiles.correct(3) & rt(trls.correct) <= ntiles.correct(4))) / length(trls.correct);
pred_prop.correct(5) = length(find(rt(trls.correct) > ntiles.correct(4) & rt(trls.correct) <= ntiles.correct(5))) / length(trls.correct);
pred_prop.correct(6) = length(find(rt(trls.correct) > ntiles.correct(5))) / length(trls.correct);
%sum(pred_prop.correct)

pred_prop.errors(1) = length(find(rt(trls.errors) <= ntiles.errors(1))) / length(trls.errors);
pred_prop.errors(2) = length(find(rt(trls.errors) > ntiles.errors(1) & rt(trls.errors) <= ntiles.errors(2))) / length(trls.errors);
pred_prop.errors(3) = length(find(rt(trls.errors) > ntiles.errors(2) & rt(trls.errors) <= ntiles.errors(3))) / length(trls.errors);
pred_prop.errors(4) = length(find(rt(trls.errors) > ntiles.errors(3) & rt(trls.errors) <= ntiles.errors(4))) / length(trls.errors);
pred_prop.errors(5) = length(find(rt(trls.errors) > ntiles.errors(4) & rt(trls.errors) <= ntiles.errors(5))) / length(trls.errors);
pred_prop.errors(6) = length(find(rt(trls.errors) > ntiles.errors(5))) / length(trls.errors);

pred_freq.correct = pred_prop.correct .* N.correct;
pred_freq.errors = pred_prop.errors .* N.errors;


all_obs = [obs_freq.correct' ; obs_freq.errors'];
all_pred = [pred_freq.correct' ; pred_freq.errors'];

%sum(all_obs)
%sum(all_pred)

X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );
disp([all_obs all_pred])

%Strange case handling
if isnan(X2); X2 = 9e90; end

%for cases where predicted frequences are negative
if any(all_pred < 0); X2 = 9e90; end


X2

if plotFlag
    hold on
    plot([ntiles.correct ; inf],cumsum(obs_freq.correct)./N.all,'or',[ntiles.errors ; inf],cumsum(obs_freq.errors)./N.all,'ok')
    plot([ntiles.correct ; inf],cumsum(pred_freq.correct)./N.all,'-xr',[ntiles.errors ; inf],cumsum(pred_freq.errors)./N.all,'-xk')
    xlim([0 1000])
    ylim([0 1])
    pause(.001)
    cla
end

% plot(all_act1','g')
% hold on
% plot(all_act2','r')
% plot(mean(all_act1)','k')
% plot(mean(all_act2)','--k')