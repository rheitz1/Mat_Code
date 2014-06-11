% This fits the integrated LBA model (iLBA) to a single condition with all parameters free
% 12/16/11
% RPH
function [solution minval] = iLBA_sim_vincentized_oneCond()
rand('seed',5150);
randn('seed',5150);
normrnd('seed',5150);


cd /volumes/Dump/Analyses/SAT/Vincent_distributions/
%cd /Analyses/SAT/Vincent_distributions/
load S_Med_Made_Missed.mat
%load Q_Med_made_missed_SmallTrunc

minimize = 1;
plotFlag = 1;
truncSim = 1;


cond = 3;


%Boundaries for simulated RTs based on the deadlines used.  Note that we are fitting MADE deadlines here,
%so we want the model to exclude RTs outside of this range.
simBound.slow = floor(nanmean(mean_deadline.slow));
simBound.fast = ceil(nanmean(mean_deadline.fast));


%SLOW
%==========
A.slow = 100.377;
b.slow = 150;
v.slow = .75;
T0.slow = 220.853;
%==========

%NEUTRAL
%==========
A.med = 180;
b.med = 150;
v.med = .7;
T0.med = 90;
%==========

%FAST
%==========
%PERFECT FIT FOR Q_Med_Made_Missed_SmallTrunc.mat
A.fast = 93.4152;
b.fast = 106.9048;
v.fast = .6646;
T0.fast = 103.2656;
%==========

%SHARED
%============
leakage = .0053;
sd_rate = .2785;



%BOUNDS
%==========
lb.A = [50];
lb.b = 80;
lb.v = [.51];
lb.T0 = [5];
lb.leakage = [.005];
lb.sd_rate = .1;

ub.A = [500];
ub.b = 400;
ub.v = [.99];
ub.T0 = [600];
ub.leakage = [.05];
ub.sd_rate = .4;
%==========


nTrials = 2500;


if cond == 1
    param = [A.slow b.slow v.slow T0.slow leakage sd_rate];
    obs_freq.correct = obs_freq.slow.correct;
    obs_freq.errors = obs_freq.slow.errors;
elseif cond == 2
    param = [A.med b.med v.med T0.med leakage sd_rate];
    obs_freq.correct = obs_freq.med.correct;
    obs_freq.errors = obs_freq.med.errors;
elseif cond == 3
    param = [A.fast b.fast v.fast T0.fast leakage sd_rate];
    obs_freq.correct = obs_freq.fast.correct;
    obs_freq.errors = obs_freq.fast.errors;
end

lower = [lb.A lb.b lb.v lb.T0 lb.leakage lb.sd_rate];
upper = [ub.A ub.b ub.v ub.T0 ub.leakage ub.sd_rate];

initRange = [lb.A lb.b lb.v lb.T0 lb.leakage lb.sd_rate ; ub.A ub.b ub.v ub.T0 ub.leakage ub.sd_rate];

if minimize
    
    %options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    %[solution minval exitflag output] = fminsearch(@(param) iLBA_sim_leaky_integrator_calc_X2_oneCond(param,ntiles,trls,obs_freq,cond),param,options);
    %[solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_oneCond(param,ntiles,trls,obs_freq,cond),param,lower,upper,options);
    
    options = gaoptimset('PopulationSize',[ones(1,5)*30],...
        'Generations',1000,...
        'PopInitRange',initRange,...
        'Display','iter', ...
        'UseParallel','always');
    %'MutationFcn',{@mutationgaussian,1,1},...
    %'HybridFcn',@fminsearch,...
    %'StallGenLimit',100,'TolFun',.0001, ...
    
    [solution minval exitflag output] = ga(@(param) iLBA_sim_leaky_integrator_calc_X2_oneCond(param,ntiles,trls,obs_freq,cond,simBound),numel(param),[],[],[],[],lower,upper,[],options);
    
    param = solution;
    options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_oneCond(param,ntiles,trls,obs_freq,simBound),param,lower,upper,options);
    
else
    solution = param;
end


if plotFlag
    figure
    
    rand('seed',5150);
    randn('seed',5150);
    normrnd('seed',5150);
    
    [A b v T0 leakage sd_rate] = disperse(solution);
    b = b * 100;
    
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
    
    
    
    correct(1:nTrials,1) = NaN;
    rt(1:nTrials,1) = NaN;
    
    
    
    %======================
    %Integration
    start1 = unifrnd(0,A,nTrials,1);
    start2 = unifrnd(0,A,nTrials,1);
    
    %use absolute value just in case negative drift rate is selected
    rate1 = abs(normrnd(v,sd_rate,nTrials,1));
    rate1(find(rate1 > 1)) = .9999;
    
    rate2 = abs(normrnd(1-v,sd_rate,nTrials,1));
    
    %generate starting point
    %act1 = start1;
    %act2 = start2;
    
    %linear1 = cumsum([zeros(nTrials,1) repmat(rate1,1,1000)],2) + repmat(start1,1,1001);
    %linear2 = cumsum([zeros(nTrials,1) repmat(rate2,1,1000)],2) + repmat(start2,1,1001);
    
    
    %     for t = 2:1000
    %         act1(:,t) = act1(:,t-1) + linear1(:,t) - ( leakage .* act1(:,t-1));
    %         act2(:,t) = act2(:,t-1) + linear2(:,t) - ( leakage .* act2(:,t-1));
    %     end
    
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
    %====================
    
    % REMOVE RTs OUTSIDE OF BOUNDS (EQUIVALENT TO RESPONSE DEADLINES)
    if truncSim
        if cond == 1
            disp(['Removing ' mat2str(length(find(rt+T0 < simBound.slow))) ' SLOW trials']);
            
            correct(find(rt+T0 < simBound.slow)) = NaN;
            rt(find(rt+T0 < simBound.slow)) = NaN;
            
        elseif cond == 3
            disp(['Removing ' mat2str(length(find(rt+T0 > simBound.fast))) ' FAST trials']);
            
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
    disp([all_obs all_pred])
    
    %X2 = sum( (all_obs - all_pred).^2 ./ (all_pred) ) + .00001;
    X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) )
    
    
    obs_prop_correct = N.correct / N.all;
    obs_prop_errors = 1-obs_prop_correct;
    
    pred_prop_correct = length(simTrls.correct) / (length(simTrls.correct) + length(simTrls.errors));
    pred_prop_errors = 1-pred_prop_correct;
    
    
    
    if plotFlag
        hold on
        plot([ntiles.correct],(cumsum(obs_freq.correct)./N.correct)*obs_prop_correct,'ok',[ntiles.errors],(cumsum(obs_freq.errors)./N.errors)*obs_prop_errors,'or','markersize',8)
        plot([ntiles.correct],(cumsum(pred_freq.correct)./N.correct)*pred_prop_correct,'-xk',[ntiles.errors],(cumsum(pred_freq.errors)./N.errors)*pred_prop_errors,'-xr','markersize',10)
        %plot([ntiles.correct],(cumsum(obs_freq.correct)./N.correct),'ok',[ntiles.errors],(cumsum(obs_freq.errors)./N.errors),'or')
        %plot([ntiles.correct],(cumsum(pred_freq.correct)./N.correct),'-xk',[ntiles.errors],(cumsum(pred_freq.errors)./N.errors),'-xr')
        xlim([100 1200])
        ylim([0 1.1])
        
        %         disp('--------------')
        %         disp(mat2str(quant(param(1),.001)))
        %         disp(mat2str(quant(param(2),.001)))
        %         disp(mat2str(quant(param(3),.001)))
        %         disp(mat2str(quant(param(4),.001)))
        %         disp('--------------')
    end
end

