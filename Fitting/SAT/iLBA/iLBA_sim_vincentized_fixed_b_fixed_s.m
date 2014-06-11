%This runs the integrated LBA (iLBA) on vincentized data with SOME PARAMETERS SHARED
% 12/16/11
% RPH

function [solution minval] = iLBA_sim_vincentized_fixed_b_fixed_s(file,PopN,GenLim,nTrials,seed,sd_rate,start_param,minimizer)

save_output = 0;
minimize = 1;
plotFlag = 1;

if matlabpool('size') < 12; matlabpool(12); end

outdir = '/volumes/Dump/Analyses/SAT/Models/iLBA_X2/fixed_b/';
%outdir = '//scratch/heitzrp/Output/iLBA/fixed_b/';

if nargin < 8; minimizer = 'ga'; end
if nargin < 5; seed = 5150; end
if nargin < 4; nTrials = 500; end
if nargin < 3; GenLim = 500; end
if nargin < 2; PopN = 5; end
if nargin < 1; file = 'Q_Med'; end

rand('seed',seed);
randn('seed',seed);
normrnd('seed',seed);

load(file)


%=============
% BOUNDS
%=============
lb.A = [50 50 50];
lb.b = [80];
lb.v = [.51 .51 .51];
lb.T0 = [5 5 5];
lb.leakage = [.005];

ub.A = [500 500 500];
ub.b = [400];
ub.v = [.99 .99 .99];
ub.T0 = [600 600 600];
ub.leakage = [.05];

    
if nargin < 7
    A.slow = 200;
    A.med = 200;
    A.fast = 200;
    
    b = 152.033;
    
    v.slow = .65;
    v.med = .65;
    v.fast = .65;
    
    T0.slow = 150;
    T0.med = 150;
    T0.fast = 150;
    
    leakage = .015;

    
    %=======================================
    % INITIAL RANGE (for genetic algorithm)
    %=======================================
    init.A = [lb.A ; ub.A];
    init.b = [lb.b ; ub.b];
    init.v = [lb.v ; ub.v];
    init.T0 = [lb.T0 ; ub.T0];
    init.leakage = [lb.leakage ; ub.leakage];

else
    [A.slow A.med A.fast b v.slow v.med v.fast T0.slow T0.med T0.fast leakage] = disperse(start_param);
    
    %=======================================
    % INITIAL RANGE (for genetic algorithm)
    %=======================================
    init.A = [A.slow-10 A.med-10 A.fast-10 ; A.slow+10 A.med+10 A.fast+10];
    init.b = [b-10 ; b+10];
    init.v = [v.slow-.01 v.med-.01 v.fast-.01 ; v.slow+.01 v.med+.01 v.fast+.01];
    init.T0 = [T0.slow-10 T0.med-10 T0.fast-10 ; T0.slow+10 T0.med+10 T0.fast+10];
    init.leakage = [leakage-.05 ; leakage+.05];
end


initRange = [init.A init.b init.v init.T0 init.leakage];


param = [A.slow A.med A.fast b v.slow v.med v.fast T0.slow T0.med T0.fast leakage];
lower = [lb.A lb.b lb.v lb.T0 lb.leakage];
upper = [ub.A ub.b ub.v ub.T0 ub.leakage];

start_param = param;

if minimize
    
    if strmatch(minimizer,'simplex')
        options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000,'useparallel','always');
        %[solution minval exitflag output] = fminsearch(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b(param,ntiles,trls,obs_freq),param,options);
        [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_fixed_s(param,ntiles,trls,obs_freq,seed),param,lower,upper,options);
        
    elseif strmatch(minimizer,'ga')
        options = gaoptimset('PopulationSize',[ones(1,PopN)*30],...
            'Generations',GenLim,...
            'PopInitRange',initRange,...
            'Display','iter', ...
            'UseParallel','always', ...
            'CrossoverFraction',.7);
        %'MutationFcn',{@mutationgaussian,1,1}, ...
        
        [solution minval exitflag output] = ga(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_fixed_s(param,ntiles,trls,obs_freq,seed),numel(param),[],[],[],[],lower,upper,[],options);
        
        param = solution;
        options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
        [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_fixed_s(param,ntiles,trls,obs_freq,seed),param,lower,upper,options);
    elseif strmatch(minimizer,'sa')
        options = saoptimset;
        
        [solution minval exitflag output] = simulannealbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_fixed_s(param,ntiles,trls,obs_freq,seed),param,lower,upper,options);
        
    end
    
else
    solution = param;
end


if plotFlag
    figure
    
    rand('seed',seed);
    randn('seed',seed);
    normrnd('seed',seed);
    
    slow_correct_made_dead = trls.slow.correct;
    slow_errors_made_dead = trls.slow.errors;
    fast_correct_made_dead_withCleared = trls.fast.correct;
    fast_errors_made_dead_withCleared = trls.fast.errors;
    
    med_correct = trls.med.correct;
    med_errors = trls.med.errors;
    
    [A.slow A.med A.fast b v.slow v.med v.fast T0.slow T0.med T0.fast leakage] = disperse(solution);
    b = b * 100;
    
    
    
    correct.slow(1:nTrials,1) = NaN;
    correct.fast(1:nTrials,1) = NaN;
    correct.med(1:nTrials,1) = NaN;
    
    rt.slow(1:nTrials,1) = NaN;
    rt.fast(1:nTrials,1) = NaN;
    rt.med(1:nTrials,1) = NaN;
    
    
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
    
    
    %     %generate starting point
    %     act1.slow = start1.slow;
    %     act1.med = start1.med;
    %     act1.fast = start1.fast;
    %
    %     act2.slow = start2.slow;
    %     act2.med = start2.med;
    %     act2.fast = start2.fast;
    %
    %     linear1.slow = cumsum([zeros(nTrials,1) repmat(rate1.slow,1,1000)],2) + repmat(start1.slow,1,1001);
    %     linear1.med = cumsum([zeros(nTrials,1) repmat(rate1.med,1,1000)],2) + repmat(start1.med,1,1001);
    %     linear1.fast = cumsum([zeros(nTrials,1) repmat(rate1.fast,1,1000)],2) + repmat(start1.fast,1,1001);
    %
    %     linear2.slow = cumsum([zeros(nTrials,1) repmat(rate2.slow,1,1000)],2) + repmat(start2.slow,1,1001);
    %     linear2.med = cumsum([zeros(nTrials,1) repmat(rate2.med,1,1000)],2) + repmat(start2.med,1,1001);
    %     linear2.fast = cumsum([zeros(nTrials,1) repmat(rate2.fast,1,1000)],2) + repmat(start2.fast,1,1001);
    %
    %
    %     for t = 2:1000
    %         act1.slow(:,t) = act1.slow(:,t-1) + linear1.slow(:,t) - ( leakage .* act1.slow(:,t-1));
    %         act1.med(:,t) = act1.med(:,t-1) + linear1.med(:,t) - ( leakage .* act1.med(:,t-1));
    %         act1.fast(:,t) = act1.fast(:,t-1) + linear1.fast(:,t) - ( leakage .* act1.fast(:,t-1));
    %
    %         act2.slow(:,t) = act2.slow(:,t-1) + linear2.slow(:,t) - ( leakage .* act2.slow(:,t-1));
    %         act2.med(:,t) = act2.med(:,t-1) + linear2.med(:,t) - ( leakage .* act2.med(:,t-1));
    %         act2.fast(:,t) = act2.fast(:,t-1) + linear2.fast(:,t) - ( leakage .* act2.fast(:,t-1));
    %     end
    
    
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
    
    %force threshold crossing at latest point if never found
    force1.slow = find(~any(cross1.slow,2));
    force1.med = find(~any(cross1.med,2));
    force1.fast = find(~any(cross1.fast,2));
    
    force2.slow = find(~any(cross2.slow,2));
    force2.med = find(~any(cross2.med,2));
    force2.fast = find(~any(cross2.fast,2));
    
    cross1.slow(force1.slow,size(cross1.slow,2)) = 1;
    cross1.med(force1.med,size(cross1.med,2)) = 1;
    cross1.fast(force1.fast,size(cross1.fast,2)) = 1;
    
    cross2.slow(force2.slow,size(cross2.slow,2)) = 1;
    cross2.med(force2.med,size(cross2.med,2)) = 1;
    cross2.fast(force2.fast,size(cross2.fast,2)) = 1;
    
    %multiple logical cross1 and cross2 by sequence of column numbers to convert into real time values
    mult_mat = repmat(linspace(1,size(cross1.slow,2),size(cross1.slow,2)),nTrials,1);
    
    cross1.slow = sum(cross1.slow .* mult_mat,2) + 1; % +1 to correct for diff operation earlier
    cross1.med = sum(cross1.med .* mult_mat,2) + 1;
    cross1.fast = sum(cross1.fast .* mult_mat,2) + 1;
    
    cross2.slow = sum(cross2.slow .* mult_mat,2) + 1; % +1 to correct for diff operation earlier
    cross2.med = sum(cross2.med .* mult_mat,2) + 1;
    cross2.fast = sum(cross2.fast .* mult_mat,2) + 1;
    
    rt.slow = min([cross1.slow cross2.slow],[],2);
    rt.med = min([cross1.med cross2.med],[],2);
    rt.fast = min([cross1.fast cross2.fast],[],2);
    
    
    
    correct.slow = +(cross1.slow < cross2.slow);
    correct.med = +(cross1.med < cross2.med);
    correct.fast = +(cross1.fast < cross2.fast);
    
    
    %remove out-of-bound simulated RTs
%     correct.slow(find(rt.slow+T0.slow < 500)) = NaN;
%     correct.fast(find(rt.fast+T0.fast > 350)) = NaN;
%     
%     rt.slow(find(rt.slow < 500+T0.slow)) = NaN;
%     rt.fast(find(rt.fast > 350+T0.fast)) = NaN;
%     
% truncval = 1.5;
% highcut_slow = nanmedian(rt.slow) + truncval * iqr(rt.slow);
% lowcut_slow = nanmedian(rt.slow) - truncval * iqr(rt.slow);
% highcut_fast = nanmedian(rt.fast) + truncval * iqr(rt.fast);
% lowcut_fast = nanmedian(rt.fast) - truncval * iqr(rt.fast);
% highcut_med = nanmedian(rt.med) + truncval * iqr(rt.med);
% lowcut_med = nanmedian(rt.med) - truncval * iqr(rt.med);
%         
% remove_slow = find(rt.slow < lowcut_slow | rt.slow > highcut_slow);
% remove_med = find(rt.med < lowcut_med | rt.med > highcut_med);
% remove_fast = find(rt.fast < lowcut_fast | rt.fast > highcut_fast);
% 
% rt.slow(remove_slow) = NaN;
% correct.slow(remove_slow) = NaN;
% 
% rt.med(remove_med) = NaN;
% correct.med(remove_med) = NaN;
% 
% rt.fast(remove_fast) = NaN;
% correct.fast(remove_fast) = NaN;
%     
    %==========================
    % END INTEGRATION
    
    
    
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
    
    
    %Now compute predicted quantiles for Q-Q plot
%     nts = [10 ; 30 ; 50 ; 70 ; 90 ; 100];
%     pred_ntiles.slow.correct = prctile(rt.slow(simTrls.slow.correct),nts);
%     pred_ntiles.slow.errors = prctile(rt.slow(simTrls.slow.errors),nts);
%     pred_ntiles.med.correct = prctile(rt.med(simTrls.med.correct),nts);
%     pred_ntiles.med.errors = prctile(rt.med(simTrls.med.errors),nts);
%     pred_ntiles.fast.correct = prctile(rt.fast(simTrls.fast.correct),nts);
%     pred_ntiles.fast.errors = prctile(rt.fast(simTrls.fast.errors),nts);
    

    
    all_pred(find(isnan(all_pred))) = 0;
    %disp([all_obs all_pred])
    
    %X2 = sum( (all_obs - all_pred).^2 ./ (all_pred) ) + .00001
    X2 = sum( (all_obs - all_pred).^2 ./ (all_pred) )
    
    if save_output
        eval(['fid = fopen(' '''' outdir file '_P' mat2str(PopN) 'G' mat2str(GenLim) 'N' mat2str(nTrials) '.txt' '''' ',' '''' 'a' '''' ');'])
        fprintf(fid, '\n--------------------\n');
        fprintf(fid, 'X2 = %f\n',X2);
        fprintf(fid, 'Populations: %f\n',PopN);
        fprintf(fid, 'Generations: %f\n',GenLim);
        fprintf(fid, 'Number of Simulations: %f\n',nTrials);
        fprintf(fid, 'Seed: %f\n',seed);
        fprintf(fid, '\n');
        fprintf(fid, 'Starting Params: \n');
        fprintf(fid, '%f\n',start_param);
        fprintf(fid, '\n');
        fprintf(fid, 'Solution: \n');
        fprintf(fid, '%f\n',solution);
        fclose(fid);
    end
    
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
    
    
    
%     fig
%     subplot(2,2,1)
%     plot(ntiles.slow.correct,pred_ntiles.slow.correct,'or',ntiles.slow.errors,pred_ntiles.slow.errors,'ob')
%     xlim([400 700])
%     ylim([400 700])
%     dline
%     
%     subplot(2,2,2)
%     plot(ntiles.med.correct,pred_ntiles.med.correct,'or',ntiles.med.errors,pred_ntiles.med.errors,'ob')
%     xlim([200 400])
%     ylim([200 400])
%     dline
%     
%     subplot(2,2,3)
%     plot(ntiles.fast.correct,pred_ntiles.fast.correct,'or',ntiles.fast.errors,pred_ntiles.fast.errors,'ob')
%     xlim([200 400])
%     ylim([200 400])
%     dline
%     
%     subplot(2,2,4)
%     plot(1:3,[obs_prop_correct.slow obs_prop_correct.med obs_prop_correct.fast],'sk')
%     hold
%     plot(1:3,[pred_prop_correct.slow pred_prop_correct.med pred_prop_correct.fast],'-xk')
%     ylim([0 1])
%     xlim([.8 3.2])
    
    
    
    if plotFlag
        figure
        
        subplot(2,2,1)
        hold on
        plot([ntiles.slow.correct],(cumsum(obs_freq.slow.correct)./N.slow.correct)*obs_prop_correct.slow,'ok',[ntiles.slow.errors],(cumsum(obs_freq.slow.errors)./N.slow.errors)*obs_prop_errors.slow,'or','markersize',8)
        plot([ntiles.slow.correct],(cumsum(pred_freq.slow.correct)./N.slow.correct)*pred_prop_correct.slow,'-xk',[ntiles.slow.errors],(cumsum(pred_freq.slow.errors)./N.slow.errors)*pred_prop_errors.slow,'-xr','markersize',10)
        set(gca,'xminortick','on')
        xlim([400 800])
        ylim([0 1])
        
        subplot(2,2,3)
        hold on
        plot([ntiles.fast.correct],(cumsum(obs_freq.fast.correct)./N.fast.correct)*obs_prop_correct.fast,'ok',[ntiles.fast.errors],(cumsum(obs_freq.fast.errors)./N.fast.errors)*obs_prop_errors.fast,'or','markersize',8)
        plot([ntiles.fast.correct],(cumsum(pred_freq.fast.correct)./N.fast.correct)*pred_prop_correct.fast,'-xk',[ntiles.fast.errors],(cumsum(pred_freq.fast.errors)./N.fast.errors)*pred_prop_errors.fast,'-xr','markersize',10)
        set(gca,'xminortick','on')
        xlim([100 400])
        ylim([0 1])
        
        subplot(2,2,2)
        hold on
        plot([ntiles.med.correct],(cumsum(obs_freq.med.correct)./N.med.correct)*obs_prop_correct.med,'ok',[ntiles.med.errors],(cumsum(obs_freq.med.errors)./N.med.errors)*obs_prop_errors.med,'or','markersize',8)
        plot([ntiles.med.correct],(cumsum(pred_freq.med.correct)./N.med.correct)*pred_prop_correct.med,'-xk',[ntiles.med.errors],(cumsum(pred_freq.med.errors)./N.med.errors)*pred_prop_errors.med,'-xr','markersize',10)
        set(gca,'xminortick','on')
        xlim([100 400])
        ylim([0 1])
    end
    
    if save_output
        %eval(['print -dpdf ' outdir file '_P' mat2str(PopN) 'G' mat2str(GenLim) 'St' mat2str(StallLim) 'N' mat2str(nTrials) '.pdf'])
    end
end
