%This runs the integrated LBA (iLBA) on vincentized data with ALL PARAMETERS FREE
% 12/16/11
% RPH

function [solution minval] = iLBA_sim_vincentized_all_free(file,PopN,GenLim,nTrials,seed,start_param,minimizer)

save_output = 0;
minimize = 1;
plotFlag = 1;

if matlabpool('size') < 12; matlabpool(12); end

%cd /scratch/heitzrp/ALLDATA/Vincent_distributions/
%outdir = '//scratch/heitzrp/Output/iLBA/free_b/';

cd /volumes/Dump/Analyses/SAT/Vincent_distributions/
outdir = '/volumes/Dump/Analyses/SAT/Models/iLBA_X2/all_free/';

if nargin < 7; minimizer = 'ga'; end
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
lb.b = [80 80 80];
lb.v = [.51 .51 .51];
lb.T0 = [5 5 5];
lb.leakage = [.005 .005 .005];
lb.sd_rate = [.1 .1 .1];

ub.A = [500 500 500];
ub.b = [400 400 400];
ub.v = [.99 .99 .99];
ub.T0 = [600 600 600];
ub.leakage = [.05 .05 .05];
ub.sd_rate = [.4 .4 .4];



if nargin < 6
    A.slow = 191.7098;
    A.med = 108.8963;
    A.fast = 93.4152;
    
    b.slow = 385.1441;
    b.med = 86.0398;
    b.fast = 106.9048;
    
    v.slow = .9889;
    v.med = .6366;
    v.fast = .6646;
    
    T0.slow = 272.6321;
    T0.med = 91.0971;
    T0.fast = 103.2656;
    
    leakage.slow = .0071;
    leakage.med = .0154;
    leakage.fast = .0053;
    
    sd_rate.slow = .3674;
    sd_rate.med = .2072;
    sd_rate.fast = .2785;
    
    
    
    %=======================================
    % INITIAL RANGE (for genetic algorithm)
    %=======================================
    init.A = [lb.A ; ub.A];
    init.b = [lb.b ; ub.b];
    init.v = [lb.v ; ub.v];
    init.T0 = [lb.T0 ; ub.T0];
    init.leakage = [lb.leakage ; ub.leakage];
    init.sd_rate = [lb.sd_rate ; ub.sd_rate];
    
else
    [A.slow A.med A.fast b.slow b.med b.fast v.slow v.med v.fast T0.slow T0.med T0.fast leakage.slow leakage.med leakage.fast sd_rate.slow sd_rate.med sd_rate.fast] = disperse(start_param);
    
    %=======================================
    % INITIAL RANGE (for genetic algorithm)
    %=======================================
    init.A = [A.slow-10 A.med-10 A.fast-10 ; A.slow+10 A.med+10 A.fast+10];
    init.b = [b.slow-10 b.med-10 b.fast-10 ; b.slow+10 b.med+10 b.fast+10];
    init.v = [v.slow-.01 v.med-.01 v.fast-.01 ; v.slow+.01 v.med+.01 v.fast+.01];
    init.T0 = [T0.slow-10 T0.med-10 T0.fast-10 ; T0.slow+10 T0.med+10 T0.fast+10];
    init.leakage = [leakage.slow-.05 leakage.med-.05 leakage.fast-.05 ; leakage.slow+.05 leakage.med+.05 leakage.fast+.05];
    init.sd_rate = [sd_rate.slow-.05 sd_rate.med-.05 sd_rate.fast-.05 ; sd_rate.slow+.05 sd_rate.med+.05 sd_rate.fast+.05];
end


initRange = [init.A init.b init.v init.T0 init.leakage init.sd_rate];


param = [A.slow A.med A.fast b.slow b.med b.fast v.slow v.med v.fast T0.slow T0.med T0.fast leakage.slow leakage.med leakage.fast sd_rate.slow sd_rate.med sd_rate.fast];
start_param = param;

lower = [lb.A lb.b lb.v lb.T0 lb.leakage lb.sd_rate];
upper = [ub.A ub.b ub.v ub.T0 ub.leakage ub.sd_rate];

if minimize
    
    if strmatch(minimizer,'simplex')
    %options = optimset;
    options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    %[solution minval exitflag output] = fminsearch(@(param) iLBA_sim_leaky_integrator_calc_X2(param,ntiles,trls,obs_freq),param,options);
    [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_all_free(param,ntiles,trls,obs_freq,seed),param,lower,upper,options);
    
    elseif strmatch(minimizer,'ga')
    options = gaoptimset('PopulationSize',[ones(1,PopN)*30],...
        'Generations',GenLim,...
        'PopInitRange',initRange,...
        'Display','iter', ...
        'UseParallel','always', ...
        'MutationFcn',{@mutationgaussian,1,1}, ...
        'CrossoverFraction',.7);

    [solution minval exitflag output] = ga(@(param) iLBA_sim_leaky_integrator_calc_X2_all_free(param,ntiles,trls,obs_freq,seed),numel(param),[],[],[],[],lower,upper,[],options);
    
    param = solution;
    options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_all_free(param,ntiles,trls,obs_freq,seed),param,lower,upper,options);
    
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
    
    
    [A.slow A.med A.fast b.slow b.med b.fast v.slow v.med v.fast T0.slow T0.med T0.fast leakage.slow leakage.med leakage.fast sd_rate.slow sd_rate.med sd_rate.fast] = disperse(solution);
    b.slow = b.slow * 100;
    b.med = b.med * 100;
    b.fast = b.fast * 100;
    
    
    correct.slow(1:nTrials,1) = NaN;
    correct.fast(1:nTrials,1) = NaN;
    correct.med(1:nTrials,1) = NaN;
    
    rt.slow(1:nTrials,1) = NaN;
    rt.fast(1:nTrials,1) = NaN;
    rt.med(1:nTrials,1) = NaN;
    
    
    %============================
    % INTEGRATION
    start1.slow = unifrnd(0,A.slow,nTrials,1);
    start1.med = unifrnd(0,A.med,nTrials,1);
    start1.fast = unifrnd(0,A.fast,nTrials,1);
    
    start2.slow = unifrnd(0,A.slow,nTrials,1);
    start2.med = unifrnd(0,A.med,nTrials,1);
    start2.fast = unifrnd(0,A.fast,nTrials,1);
    
    %use absolute value just in case negative drift rate is selected
    rate1.slow = abs(normrnd(v.slow,sd_rate.slow,nTrials,1));
    rate1.med = abs(normrnd(v.med,sd_rate.med,nTrials,1));
    rate1.fast = abs(normrnd(v.fast,sd_rate.fast,nTrials,1));
    
    rate1.slow(find(rate1.slow > 1)) = .9999;
    rate1.med(find(rate1.med > 1)) = .9999;
    rate1.fast(find(rate1.fast > 1)) = .9999;
    
    rate2.slow = abs(normrnd(1-v.slow,sd_rate.slow,nTrials,1));
    rate2.med = abs(normrnd(1-v.med,sd_rate.med,nTrials,1));
    rate2.fast = abs(normrnd(1-v.fast,sd_rate.fast,nTrials,1));
    
    
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
    %     for t = 2:2000
    %         act1.slow(:,t) = act1.slow(:,t-1) + linear1.slow(:,t) - ( leakage .* act1.slow(:,t-1));
    %         act1.med(:,t) = act1.med(:,t-1) + linear1.med(:,t) - ( leakage .* act1.med(:,t-1));
    %         act1.fast(:,t) = act1.fast(:,t-1) + linear1.fast(:,t) - ( leakage .* act1.fast(:,t-1));
    %
    %         act2.slow(:,t) = act2.slow(:,t-1) + linear2.slow(:,t) - ( leakage .* act2.slow(:,t-1));
    %         act2.med(:,t) = act2.med(:,t-1) + linear2.med(:,t) - ( leakage .* act2.med(:,t-1));
    %         act2.fast(:,t) = act2.fast(:,t-1) + linear2.fast(:,t) - ( leakage .* act2.fast(:,t-1));
    %
    %     end
    
    %============
    % C++ CODE
    act1.slow = leaky_integrate2(rate1.slow',start1.slow,leakage.slow)';
    act1.med = leaky_integrate2(rate1.med',start1.med,leakage.med)';
    act1.fast = leaky_integrate2(rate1.fast',start1.fast,leakage.fast)';
    
    act2.slow = leaky_integrate2(rate2.slow',start2.slow,leakage.slow)';
    act2.med = leaky_integrate2(rate2.med',start2.med,leakage.med)';
    act2.fast = leaky_integrate2(rate2.fast',start2.fast,leakage.fast)';
    
    %
    %     r1.slow = repmat(rate1.slow,1,1999);
    %     loss1.slow = repmat(1 - (1:1999) .* leakage.slow,nTrials,1); %establish new rates subject to loss by leakage
    %     loss1.slow(find(loss1.slow < 0)) = eps;
    %     a1.slow = cumsum(cumsum([zeros(nTrials,1) rate1.slow(:,1) r1.slow.*loss1.slow],2),2);
    %
    
    
    
    cross1.slow = diff(act1.slow > b.slow,1,2);
    cross1.med = diff(act1.med > b.med,1,2);
    cross1.fast = diff(act1.fast > b.fast,1,2);
    
    cross2.slow = diff(act2.slow > b.slow,1,2);
    cross2.med = diff(act2.med > b.med,1,2);
    cross2.fast = diff(act2.fast > b.fast,1,2);
    
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
    
    correct.slow = cross1.slow < cross2.slow;
    correct.med = cross1.med < cross2.med;
    correct.fast = cross1.fast < cross2.fast;
    %==============================
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
    
    
    all_pred(find(isnan(all_pred))) = 0;
    disp([obs_freq.fast.correct' pred_freq.fast.correct' ; obs_freq.fast.errors' pred_freq.fast.errors'])
    
    X2 = sum( (all_obs - all_pred).^2 ./ (all_pred +.00001) )
    
    if save_output
        eval(['fid = fopen(' '''' outdir file '_P' mat2str(PopN) 'G' mat2str(GenLim) 'St' mat2str(StallLim) 'N' mat2str(nTrials) '.txt' '''' ',' '''' 'a' '''' ');'])
        fprintf(fid, '\n--------------------\n');
        fprintf(fid, 'X2 = %f\n',X2);
        fprintf(fid, 'Populations: %f\n',PopN);
        fprintf(fid, 'Generations: %f\n',GenLim);
        fprintf(fid, 'Stall Limit: %f\n',StallLim);
        fprintf(fid, 'Number of Simulations: %f\n',nTrials);
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
    end
    
    if save_output
        %eval(['print -dpdf ' outdir file '_P' mat2str(PopN) 'G' mat2str(GenLim) 'St' mat2str(StallLim) 'N' mat2str(nTrials) '.pdf'])
    end
end

%matlabpool close