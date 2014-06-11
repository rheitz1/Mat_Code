c_

minimize = 1;
plotFlag = 1;

load('Q110910001-RH_SEARCH','Target_','Correct_','SAT_','Errors_','SRT')
%load('S032511001-RH_SEARCH','Target_','Correct_','SAT_','Errors_','SRT')
getTrials_SAT


trls.slow_correct_made_dead = slow_correct_made_dead;
trls.slow_errors_made_dead = slow_errors_made_dead;

nts = [10 ; 30 ; 50 ; 70 ; 90];


ntiles.correct = prctile(SRT(slow_correct_made_dead,1),nts);
ntiles.errors = prctile(SRT(slow_errors_made_dead,1),nts);
N.correct = length(slow_correct_made_dead);
N.errors = length(slow_errors_made_dead);

nl = .1 * N.correct;
nh = .2 * N.correct;
obs_freq.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * N.errors;
nh = .2 * N.errors;
obs_freq.errors = [nl nh nh nh nh nl];
clear nl nh


%for v = 0:.1:1
%starting parameters
% A = 190;
% b = 270;
% v = .9;
% T0 = 410;
sd_rate = .1;

A = 169;
b = 174.3;
v = .82;
T0 = 494.11;

param = [A b v T0];
if minimize
    
    options = optimset;
    [solution minval exitflag output] = fminsearch(@(param) LBA_sim_calc_X2_old(param,ntiles,trls,obs_freq),param,options);
else
    solution = param;
    nTrials = 10000;
    
    act1 = zeros(nTrials,10000);
    act2 = act1;
    
    correct(1:nTrials,1) = NaN;
    rt(1:nTrials,1) = NaN;
    
    
    parfor n = 1:nTrials
        start1 = unifrnd(0,param(1));
        start2 = unifrnd(0,param(1));
        
        rate1 = normrnd(param(3),sd_rate);
        rate2 = normrnd(1-param(3),sd_rate);
        
        
        act1 = start1:rate1:param(2);
        act2 = start2:rate2:param(2);
        
        
        
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
    rt = rt + param(4);
    
    %     all_act1(find(all_act1 == 0)) = NaN;
    %     all_act2(find(all_act2 == 0)) = NaN;
    
    
    trls.correct = find(correct == 1);
    trls.errors = find(correct == 0);
    
    nT = length(trls.correct) + length(trls.errors);
    
    N.correct = length(slow_correct_made_dead);
    N.errors = length(slow_errors_made_dead);
    N.all = N.correct + N.errors;
    
    pred_prop.correct(1) = length(find(rt(trls.correct) <= ntiles.correct(1))) / length(trls.correct);
    pred_prop.correct(2) = length(find(rt(trls.correct) > ntiles.correct(1) & rt(trls.correct) <= ntiles.correct(2))) / length(trls.correct);
    pred_prop.correct(3) = length(find(rt(trls.correct) > ntiles.correct(2) & rt(trls.correct) <= ntiles.correct(3))) / length(trls.correct);
    pred_prop.correct(4) = length(find(rt(trls.correct) > ntiles.correct(3) & rt(trls.correct) <= ntiles.correct(4))) / length(trls.correct);
    pred_prop.correct(5) = length(find(rt(trls.correct) > ntiles.correct(4) & rt(trls.correct) <= ntiles.correct(5))) / length(trls.correct);
    pred_prop.correct(6) = length(find(rt(trls.correct) > ntiles.correct(5))) / length(trls.correct);
    
    
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
    
    X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );
    disp([all_obs all_pred])
    
    %Strange case handling
    if isnan(X2); X2 = 9e90; end
    
    %for cases where predicted frequences are negative
    if any(all_pred < 0); X2 = 9e90; end
    
    
    
end

if plotFlag
    hold on
    plot([ntiles.correct ; inf],cumsum(obs_freq.correct)./N.all,'or',[ntiles.errors ; inf],cumsum(obs_freq.errors)./N.all,'ok')
    plot([ntiles.correct ; inf],cumsum(pred_freq.correct)./N.all,'-xr',[ntiles.errors ; inf],cumsum(pred_freq.errors)./N.all,'-xk')
    xlim([0 1000])
    ylim([0 1])
    pause(.001)
end


%end
