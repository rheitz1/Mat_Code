% This runs the integrated LBA (iLBA) on vincentized data with SOME PARAMETERS SHARED
% 12/16/11
%
% RPH

function [solution minval] = iLBA_sim_vincentized_fixed_b_nTiles(file,PopN,GenLim,nTrials,seed,sd_rate,start_param,minimizer)

save_output = 0;
minimize = 1;
plotFlag = 1;
truncSim = 1;


outdir = '/volumes/Dump/Analyses/SAT/Models/iLBA_X2/fixed_b/';
%outdir = '//scratch/heitzrp/Output/iLBA/fixed_b/';

if nargin < 8; minimizer = 'ga'; end
if nargin < 6; sd_rate = .27; end
if nargin < 5; seed = 13; end
if nargin < 4; nTrials = 2500; end
if nargin < 3; GenLim = 200; end
if nargin < 2; PopN = 5; end
if nargin < 1; file = 'QS_Med_nTiles'; end

rand('seed',seed);
randn('seed',seed);
normrnd('seed',seed);

if (matlabpool('size') < 12 & strmatch(minimizer,'ga')); matlabpool(12); end

load(file)

%Boundaries for simulated RTs based on the deadlines used.  Note that we are fitting MADE deadlines here,
%so we want the model to exclude RTs outside of this range.



%NOTE: THIS SEEMED TO MAKE MORE SENSE FOR THE QS COMBINED DATA SET!!!
% if strmatch(file,'QS_Med')
%     simBound.slow = min(mean_deadline.slow);
%     simBound.med = [100 400];
%     simBound.fast = min(mean_deadline.fast);
% else
%     simBound.slow = floor(nanmean(mean_deadline.slow));
%     simBound.med = [100 400];
%     simBound.fast = ceil(nanmean(mean_deadline.fast));
% end

%Bounds based on MEDIAN RT +/- 1.5*IQR of ALL TRIALS AGGREGATED TOGETHER
% simBound.slow = [398.5 791.5];
% simBound.med = [131.5 434.5];
% simBound.fast = [160 364];

%Bounds based on MEDIAN of MEDIAN RT +/- 1.5*IQR across sessions individually
% simBound.slow = [430.25 776.5];
% simBound.med = [153.88 412];
% simBound.fast = [184 328.25];

simBound.slow = [0 2000];
simBound.med = [0 2000];
simBound.fast = [0 2000];
%=============
% BOUNDS
%=============
lb.A = 50 * ones(1,9);
lb.b = [80];
lb.v = .51 * ones(1,9);
lb.T0 = 5 * ones(1,9);
lb.leakage = [.005];
%lb.sd_rate = .1;

ub.A = 500 * ones(1,9);
ub.b = [400];
ub.v = .95 * ones(1,9);
ub.T0 = 600 * ones(1,9);
ub.leakage = [.05];
%ub.sd_rate = .4;


if nargin < 7
    A.slow1 = 149.7801;
    A.slow2 = 120.7801;
    A.slow3 = 149.7801;
    
    A.med1 = 290.4910;
    A.med2 = 290.4910;
    A.med3 = 290.4910;
    
    A.fast1 = 328.6359;
    A.fast2 = 328.6359;
    A.fast3 = 328.6359;
    
    b = 254.0614;
        
    v.slow1 = 0.7351;
    v.slow2 = 0.8;
    v.slow3 = 0.7351;
    
    v.med1 = 0.8294;
    v.med2 = 0.8294;
    v.med3 = 0.8294;
    
    v.fast1 = 0.9172;
    v.fast2 = 0.9572;
    v.fast3 = 0.9572;
    
    T0.slow1 = 390.1744;
    T0.slow2 = 300.1744;
    T0.slow3 = 250.1744;
    
    T0.med1 = 150.3368;
    T0.med2 = 80.3368;
    T0.med3 = 99.3368;
    
    T0.fast1 = 180.2567;
    T0.fast2 = 120.2567;
    T0.fast3 = 112.2567;
    
    leakage = 0.0087;
    
    %=======================================
    % INITIAL RANGE (for genetic algorithm)
    %=======================================
    init.A = [lb.A ; ub.A];
    init.b = [lb.b ; ub.b];
    init.v = [lb.v ; ub.v];
    init.T0 = [lb.T0 ; ub.T0];
    init.leakage = [lb.leakage ; ub.leakage];
    %init.sd_rate = [lb.sd_rate ; ub.sd_rate];
    
else
    [A.slow1 A.slow2 A.slow3 A.med1 A.med2 A.med3 A.fast1 A.fast2 A.fast3 ...
    b ...
    v.slow1 v.slow2 v.slow3 v.med1 v.med2 v.med3 v.fast1 v.fast2 v.fast3 ...
    T0.slow1 T0.slow2 T0.slow3 T0.med1 T0.med2 T0.med3 T0.fast1 T0.fast2 T0.fast3 ...
    leakage] = disperse(start_param);
    
    %=======================================
    % INITIAL RANGE (for genetic algorithm)
    %=======================================
    init.A = [cell2mat(struct2cell(A)) - 10 ; cell2mat(struct2cell(A)) + 10];
    init.b = [b-10 ; b+10];
    init.v = [cell2mat(struct2cell(v)) - .01 ; cell2mat(struct2cell(v)) + .01];
    init.T0 = [cell2mat(struct2cell(T0)) - 10 ; cell2mat(struct2cell(T0)) + 10];
    init.leakage = [leakage-.05 ; leakage+.05];
    %init.sd_rate = [sd_rate-.05 ; sd_rate+.05];
end


initRange = [init.A init.b init.v init.T0 init.leakage];


param = [A.slow1 A.slow2 A.slow3 A.med1 A.med2 A.med3 A.fast1 A.fast2 A.fast3 ...
    b ...
    v.slow1 v.slow2 v.slow3 v.med1 v.med2 v.med3 v.fast1 v.fast2 v.fast3 ...
    T0.slow1 T0.slow2 T0.slow3 T0.med1 T0.med2 T0.med3 T0.fast1 T0.fast2 T0.fast3 ...
    leakage];
lower = [lb.A lb.b lb.v lb.T0 lb.leakage];
upper = [ub.A ub.b ub.v ub.T0 ub.leakage];

start_param = param;

if minimize
    
    if strmatch(minimizer,'simplex')
        options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
        %[solution minval exitflag output] = fminsearch(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b(param,ntiles,trls,obs_freq,seed,simBound),param,options);
        [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_nTiles(param,ntiles,trls,obs_freq,seed,simBound),param,lower,upper,options);
        
        %options = optimset('MaxIter',100000,'MaxFunEvals',100000,'TolFun',1e-20,'TolCon',1e-20);
        %[solution minval exitflag output] = fmincon(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b(param,ntiles,trls,obs_freq,seed,simBound),param,[],[],[],[],lower,upper,@nonlcon,options);
        
    elseif strmatch(minimizer,'ga')
        options = gaoptimset('PopulationSize',[ones(1,PopN)*30],...
            'Generations',GenLim,...
            'PopInitRange',initRange,...
            'Display','iter', ...
            'UseParallel','always');
        %             'StallGenLimit',10, ...
        %             'TolCon',1e-15, ...
        %             'TolFun',1e-15);
        
        %'MutationFcn',{@mutationgaussian,1,1}, ...
        
        disp(['Running ' mat2str(minimizer) ' with: '])
        disp(['Start Params: ' mat2str(param)])
        disp(['Seed: ' mat2str(seed)]);
        disp(['sd_rate: ' mat2str(sd_rate)]);
        
        [solution minval exitflag output] = ga(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_nTiles(param,ntiles,trls,obs_freq,seed,simBound),numel(param),[],[],[],[],lower,upper,[],options);
        
        param = solution;
        options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
        [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_nTiles(param,ntiles,trls,obs_freq,seed,simBound),param,lower,upper,options);
    elseif strmatch(minimizer,'sa')
        options = saoptimset;
        
        [solution minval exitflag output] = simulannealbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_nTiles(param,ntiles,trls,obs_freq,seed,simBound),param,lower,upper,options);
        
    end
    
else
    solution = param;
end


if plotFlag
    figure
    
    rand('seed',seed);
    randn('seed',seed);
    normrnd('seed',seed);
    
    slow_correct_made_dead_binSLOW = trls.slow1.correct;
    slow_correct_made_dead_binMED = trls.slow2.correct;
    slow_correct_made_dead_binFAST = trls.slow3.correct;
    
    slow_errors_made_dead_binSLOW = trls.slow1.errors;
    slow_errors_made_dead_binMED = trls.slow2.errors;
    slow_errors_made_dead_binFAST = trls.slow3.errors;
    
    fast_correct_made_dead_withCleared_binSLOW = trls.fast1.correct;
    fast_correct_made_dead_withCleared_binMED = trls.fast2.correct;
    fast_correct_made_dead_withCleared_binFAST = trls.fast3.correct;
    
    fast_errors_made_dead_withCleared_binSLOW = trls.fast1.errors;
    fast_errors_made_dead_withCleared_binMED = trls.fast2.errors;
    fast_errors_made_dead_withCleared_binFAST = trls.fast3.errors;
    
    med_correct_binSLOW = trls.med1.correct;
    med_correct_binMED = trls.med2.correct;
    med_correct_binFAST = trls.med3.correct;
    
    med_errors_binSLOW = trls.med1.errors;
    med_errors_binMED = trls.med2.errors;
    med_errors_binFAST = trls.med3.errors;
    
    [A.slow1 A.slow2 A.slow3 A.med1 A.med2 A.med3 A.fast1 A.fast2 A.fast3 ...
        b ...
        v.slow1 v.slow2 v.slow3 v.med1 v.med2 v.med3 v.fast1 v.fast2 v.fast3 ...
        T0.slow1 T0.slow2 T0.slow3 T0.med1 T0.med2 T0.med3 T0.fast1 T0.fast2 T0.fast3 ...
        leakage] = disperse(solution);
    b = b * 100;
    
    
    
    correct.slow1(1:nTrials,1) = NaN;
    correct.slow2(1:nTrials,1) = NaN;
    correct.slow3(1:nTrials,1) = NaN;
    
    correct.fast1(1:nTrials,1) = NaN;
    correct.fast2(1:nTrials,1) = NaN;
    correct.fast3(1:nTrials,1) = NaN;
    
    correct.med1(1:nTrials,1) = NaN;
    correct.med2(1:nTrials,1) = NaN;
    correct.med3(1:nTrials,1) = NaN;
    
    rt.slow1(1:nTrials,1) = NaN;
    rt.slow2(1:nTrials,1) = NaN;
    rt.slow3(1:nTrials,1) = NaN;
    
    rt.fast1(1:nTrials,1) = NaN;
    rt.fast2(1:nTrials,1) = NaN;
    rt.fast3(1:nTrials,1) = NaN;
    
    rt.med1(1:nTrials,1) = NaN;
    rt.med2(1:nTrials,1) = NaN;
    rt.med3(1:nTrials,1) = NaN;
    
    
    %=====================
    % INTEGRATION
    start1.slow1 = unifrnd(0,A.slow1,nTrials,1);
    start1.slow2 = unifrnd(0,A.slow2,nTrials,1);
    start1.slow3 = unifrnd(0,A.slow3,nTrials,1);
    
    start1.med1 = unifrnd(0,A.med1,nTrials,1);
    start1.med2 = unifrnd(0,A.med2,nTrials,1);
    start1.med3 = unifrnd(0,A.med3,nTrials,1);
    
    start1.fast1 = unifrnd(0,A.fast1,nTrials,1);
    start1.fast2 = unifrnd(0,A.fast2,nTrials,1);
    start1.fast3 = unifrnd(0,A.fast3,nTrials,1);
    
    start2.slow1 = unifrnd(0,A.slow1,nTrials,1);
    start2.slow2 = unifrnd(0,A.slow2,nTrials,1);
    start2.slow3 = unifrnd(0,A.slow3,nTrials,1);
    
    start2.med1 = unifrnd(0,A.med1,nTrials,1);
    start2.med2 = unifrnd(0,A.med2,nTrials,1);
    start2.med3 = unifrnd(0,A.med3,nTrials,1);
    
    start2.fast1 = unifrnd(0,A.fast1,nTrials,1);
    start2.fast2 = unifrnd(0,A.fast2,nTrials,1);
    start2.fast3 = unifrnd(0,A.fast3,nTrials,1);
    
    %use absolute value just in case negative drift rate is selected
    rate1.slow1 = abs(normrnd(v.slow1,sd_rate,nTrials,1));
    rate1.slow2 = abs(normrnd(v.slow2,sd_rate,nTrials,1));
    rate1.slow3 = abs(normrnd(v.slow3,sd_rate,nTrials,1));
    
    rate1.med1 = abs(normrnd(v.med1,sd_rate,nTrials,1));
    rate1.med2 = abs(normrnd(v.med2,sd_rate,nTrials,1));
    rate1.med3 = abs(normrnd(v.med3,sd_rate,nTrials,1));
    
    rate1.fast1 = abs(normrnd(v.fast1,sd_rate,nTrials,1));
    rate1.fast2 = abs(normrnd(v.fast2,sd_rate,nTrials,1));
    rate1.fast3 = abs(normrnd(v.fast3,sd_rate,nTrials,1));
    
    rate1.slow1(find(rate1.slow1 > 1)) = .9999;
    rate1.slow2(find(rate1.slow2 > 1)) = .9999;
    rate1.slow3(find(rate1.slow3 > 1)) = .9999;
    
    rate1.med1(find(rate1.med1 > 1)) = .9999;
    rate1.med2(find(rate1.med2 > 1)) = .9999;
    rate1.med3(find(rate1.med3 > 1)) = .9999;
    
    rate1.fast1(find(rate1.fast1 > 1)) = .9999;
    rate1.fast2(find(rate1.fast2 > 1)) = .9999;
    rate1.fast3(find(rate1.fast3 > 1)) = .9999;
    
    rate2.slow1 = abs(normrnd(1-v.slow1,sd_rate,nTrials,1));
    rate2.slow2 = abs(normrnd(1-v.slow2,sd_rate,nTrials,1));
    rate2.slow3 = abs(normrnd(1-v.slow3,sd_rate,nTrials,1));
    
    rate2.med1 = abs(normrnd(1-v.med1,sd_rate,nTrials,1));
    rate2.med2 = abs(normrnd(1-v.med2,sd_rate,nTrials,1));
    rate2.med3 = abs(normrnd(1-v.med3,sd_rate,nTrials,1));
    
    rate2.fast1 = abs(normrnd(1-v.fast1,sd_rate,nTrials,1));
    rate2.fast2 = abs(normrnd(1-v.fast2,sd_rate,nTrials,1));
    rate2.fast3 = abs(normrnd(1-v.fast3,sd_rate,nTrials,1));
    
    %============
    % C++ CODE
    act1.slow1 = leaky_integrate2(rate1.slow1',start1.slow1,leakage)';
    act1.slow2 = leaky_integrate2(rate1.slow2',start1.slow2,leakage)';
    act1.slow3 = leaky_integrate2(rate1.slow3',start1.slow3,leakage)';
    
    act1.med1 = leaky_integrate2(rate1.med1',start1.med1,leakage)';
    act1.med2 = leaky_integrate2(rate1.med2',start1.med2,leakage)';
    act1.med3 = leaky_integrate2(rate1.med3',start1.med3,leakage)';
    
    act1.fast1 = leaky_integrate2(rate1.fast1',start1.fast1,leakage)';
    act1.fast2 = leaky_integrate2(rate1.fast2',start1.fast2,leakage)';
    act1.fast3 = leaky_integrate2(rate1.fast3',start1.fast3,leakage)';
    
    act2.slow1 = leaky_integrate2(rate2.slow1',start2.slow1,leakage)';
    act2.slow2 = leaky_integrate2(rate2.slow2',start2.slow2,leakage)';
    act2.slow3 = leaky_integrate2(rate2.slow3',start2.slow3,leakage)';
    
    act2.med1 = leaky_integrate2(rate2.med1',start2.med1,leakage)';
    act2.med2 = leaky_integrate2(rate2.med2',start2.med2,leakage)';
    act2.med3 = leaky_integrate2(rate2.med3',start2.med3,leakage)';
    
    act2.fast1 = leaky_integrate2(rate2.fast1',start2.fast1,leakage)';
    act2.fast2 = leaky_integrate2(rate2.fast2',start2.fast2,leakage)';
    act2.fast3 = leaky_integrate2(rate2.fast3',start2.fast3,leakage)';
    
    
    
    cross1.slow1 = diff(act1.slow1 > b,1,2);
    cross1.slow2 = diff(act1.slow2 > b,1,2);
    cross1.slow3 = diff(act1.slow3 > b,1,2);
    
    cross1.med1 = diff(act1.med1 > b,1,2);
    cross1.med2 = diff(act1.med2 > b,1,2);
    cross1.med3 = diff(act1.med3 > b,1,2);
    
    cross1.fast1 = diff(act1.fast1 > b,1,2);
    cross1.fast2 = diff(act1.fast2 > b,1,2);
    cross1.fast3 = diff(act1.fast3 > b,1,2);
    
    cross2.slow1 = diff(act2.slow1 > b,1,2);
    cross2.slow2 = diff(act2.slow2 > b,1,2);
    cross2.slow3 = diff(act2.slow3 > b,1,2);
    
    cross2.med1 = diff(act2.med1 > b,1,2);
    cross2.med2 = diff(act2.med2 > b,1,2);
    cross2.med3 = diff(act2.med3 > b,1,2);
    
    cross2.fast1 = diff(act2.fast1 > b,1,2);
    cross2.fast2 = diff(act2.fast2 > b,1,2);
    cross2.fast3 = diff(act2.fast3 > b,1,2);
    
    
    %If threshold never reached for BOTH correct and error accumulator, set to NaN
    missing1.slow1 = find(~any(cross1.slow1,2));
    missing1.slow2 = find(~any(cross1.slow2,2));
    missing1.slow3 = find(~any(cross1.slow3,2));
    
    missing1.med1 = find(~any(cross1.med1,2));
    missing1.med2 = find(~any(cross1.med2,2));
    missing1.med3 = find(~any(cross1.med3,2));
    
    missing1.fast1 = find(~any(cross1.fast1,2));
    missing1.fast2 = find(~any(cross1.fast2,2));
    missing1.fast3 = find(~any(cross1.fast3,2));
    
    
    missing2.slow1 = find(~any(cross2.slow1,2));
    missing2.slow2 = find(~any(cross2.slow2,2));
    missing2.slow3 = find(~any(cross2.slow3,2));
    
    missing2.med1 = find(~any(cross2.med1,2));
    missing2.med2 = find(~any(cross2.med2,2));
    missing2.med3 = find(~any(cross2.med3,2));
    
    missing2.fast1 = find(~any(cross2.fast1,2));
    missing2.fast2 = find(~any(cross2.fast2,2));
    missing2.fast3 = find(~any(cross2.fast3,2));
    
    
    force.slow1 = intersect(missing1.slow1,missing2.slow1);
    force.slow2 = intersect(missing1.slow2,missing2.slow2);
    force.slow3 = intersect(missing1.slow3,missing2.slow3);
    
    force.med1 = intersect(missing1.med1,missing2.med1);
    force.med2 = intersect(missing1.med2,missing2.med2);
    force.med3 = intersect(missing1.med3,missing2.med3);
    
    force.fast1 = intersect(missing1.fast1,missing2.fast1);
    force.fast2 = intersect(missing1.fast2,missing2.fast2);
    force.fast3 = intersect(missing1.fast3,missing2.fast3);
    

    cross1.slow1(force.slow1,:) = NaN;
    cross1.slow2(force.slow2,:) = NaN;
    cross1.slow3(force.slow3,:) = NaN;
    
    cross1.med1(force.med1,:) = NaN;
    cross1.med2(force.med2,:) = NaN;
    cross1.med3(force.med3,:) = NaN;
    
    cross1.fast1(force.fast1,:) = NaN;
    cross1.fast2(force.fast2,:) = NaN;
    cross1.fast3(force.fast3,:) = NaN;
    
    
    cross2.slow1(force.slow1,:) = NaN;
    cross2.slow2(force.slow2,:) = NaN;
    cross2.slow3(force.slow3,:) = NaN;
    
    cross2.med1(force.med1,:) = NaN;
    cross2.med2(force.med2,:) = NaN;
    cross2.med3(force.med3,:) = NaN;
    
    cross2.fast1(force.fast1,:) = NaN;
    cross2.fast2(force.fast2,:) = NaN;
    cross2.fast3(force.fast3,:) = NaN;
    
    
    
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
    mult_mat = repmat(linspace(1,size(cross1.slow1,2),size(cross1.slow1,2)),nTrials,1);
    
    cross1.slow1 = sum(cross1.slow1 .* mult_mat,2);
    cross1.slow2 = sum(cross1.slow2 .* mult_mat,2);
    cross1.slow3 = sum(cross1.slow3 .* mult_mat,2);
    
    cross1.med1 = sum(cross1.med1 .* mult_mat,2);
    cross1.med2 = sum(cross1.med2 .* mult_mat,2);
    cross1.med3 = sum(cross1.med3 .* mult_mat,2);
    
    cross1.fast1 = sum(cross1.fast1 .* mult_mat,2);
    cross1.fast2 = sum(cross1.fast2 .* mult_mat,2);
    cross1.fast3 = sum(cross1.fast3 .* mult_mat,2);
    
    cross2.slow1 = sum(cross2.slow1 .* mult_mat,2);
    cross2.slow2 = sum(cross2.slow2 .* mult_mat,2);
    cross2.slow3 = sum(cross2.slow3 .* mult_mat,2);
    
    cross2.med1 = sum(cross2.med1 .* mult_mat,2);
    cross2.med2 = sum(cross2.med2 .* mult_mat,2);
    cross2.med3 = sum(cross2.med3 .* mult_mat,2);
    
    cross2.fast1 = sum(cross2.fast1 .* mult_mat,2);
    cross2.fast2 = sum(cross2.fast2 .* mult_mat,2);
    cross2.fast3 = sum(cross2.fast3 .* mult_mat,2);
    
    
    %Remove stray 0's from those accumulators that never reach boundary.  Just set them to arbitrarily
    %large number
    cross1.slow1(find(cross1.slow1 == 0)) = 99999;
    cross1.slow2(find(cross1.slow2 == 0)) = 99999;
    cross1.slow3(find(cross1.slow3 == 0)) = 99999;
    
    cross1.med1(find(cross1.med1 == 0)) = 99999;
    cross1.med2(find(cross1.med2 == 0)) = 99999;
    cross1.med3(find(cross1.med3 == 0)) = 99999;
    
    cross1.fast1(find(cross1.fast1 == 0)) = 99999;
    cross1.fast2(find(cross1.fast2 == 0)) = 99999;
    cross1.fast3(find(cross1.fast3 == 0)) = 99999;
    
    cross2.slow1(find(cross2.slow1 == 0)) = 99999;
    cross2.slow2(find(cross2.slow2 == 0)) = 99999;
    cross2.slow3(find(cross2.slow3 == 0)) = 99999;
    
    cross2.med1(find(cross2.med1 == 0)) = 99999;
    cross2.med2(find(cross2.med2 == 0)) = 99999;
    cross2.med3(find(cross2.med3 == 0)) = 99999;
    
    cross2.fast1(find(cross2.fast1 == 0)) = 99999;
    cross2.fast2(find(cross2.fast2 == 0)) = 99999;
    cross2.fast3(find(cross2.fast3 == 0)) = 99999;
    
    rt.slow1 = min([cross1.slow1 cross2.slow1],[],2);
    rt.slow2 = min([cross1.slow2 cross2.slow2],[],2);
    rt.slow3 = min([cross1.slow3 cross2.slow3],[],2);
    
    rt.med1 = min([cross1.med1 cross2.med1],[],2);
    rt.med2 = min([cross1.med2 cross2.med2],[],2);
    rt.med3 = min([cross1.med3 cross2.med3],[],2);
    
    rt.fast1 = min([cross1.fast1 cross2.fast1],[],2);
    rt.fast2 = min([cross1.fast2 cross2.fast2],[],2);
    rt.fast3 = min([cross1.fast3 cross2.fast3],[],2);
    
    
    % '+' operator changes logical into a numerical value
    correct.slow1 = +(cross1.slow1 < cross2.slow1);
    correct.slow2 = +(cross1.slow2 < cross2.slow2);
    correct.slow3 = +(cross1.slow3 < cross2.slow3);
    
    correct.med1 = +(cross1.med1 < cross2.med1);
    correct.med2 = +(cross1.med2 < cross2.med2);
    correct.med3 = +(cross1.med3 < cross2.med3);
    
    correct.fast1 = +(cross1.fast1 < cross2.fast1);
    correct.fast2 = +(cross1.fast2 < cross2.fast2);
    correct.fast3 = +(cross1.fast3 < cross2.fast3);
    
    %remember to remove NaNs
    correct.slow1(force.slow1) = NaN;
    correct.slow2(force.slow2) = NaN;
    correct.slow3(force.slow3) = NaN;
    
    correct.med1(force.med1) = NaN;
    correct.med2(force.med2) = NaN;
    correct.med3(force.med3) = NaN;
    
    correct.fast1(force.fast1) = NaN;
    correct.fast2(force.fast2) = NaN;
    correct.fast3(force.fast3) = NaN;
    
    % REMOVE RTs OUTSIDE OF BOUNDS (EQUIVALENT TO RESPONSE DEADLINES)
    if truncSim
        
        lRemove.slow1 = length(find(rt.slow1+T0.slow1 < simBound.slow(1))) + length(find(rt.slow1+T0.slow1 > simBound.slow(2)));
        lRemove.slow2 = length(find(rt.slow2+T0.slow2 < simBound.slow(1))) + length(find(rt.slow2+T0.slow2 > simBound.slow(2)));
        lRemove.slow3 = length(find(rt.slow3+T0.slow3 < simBound.slow(1))) + length(find(rt.slow3+T0.slow3 > simBound.slow(2)));
        
        lRemove.med1 = length(find(rt.med1+T0.med1 < simBound.med(1))) + length(find(rt.med1+T0.med1 > simBound.med(2)));
        lRemove.med2 = length(find(rt.med2+T0.med2 < simBound.med(1))) + length(find(rt.med2+T0.med2 > simBound.med(2)));
        lRemove.med3 = length(find(rt.med3+T0.med3 < simBound.med(1))) + length(find(rt.med3+T0.med3 > simBound.med(2)));
        
        lRemove.fast1 = length(find(rt.fast1+T0.fast1 < simBound.fast(1))) + length(find(rt.fast1+T0.fast1 > simBound.fast(2)));
        lRemove.fast2 = length(find(rt.fast2+T0.fast2 < simBound.fast(1))) + length(find(rt.fast2+T0.fast2 > simBound.fast(2)));
        lRemove.fast3 = length(find(rt.fast3+T0.fast3 < simBound.fast(1))) + length(find(rt.fast3+T0.fast3 > simBound.fast(2)));
        
        disp(['Removing ' mat2str(lRemove.slow1) ' ACCURATE trials ' mat2str(lRemove.slow1 / nTrials) '%'])
        disp(['Removing ' mat2str(lRemove.slow2) ' ACCURATE trials ' mat2str(lRemove.slow2 / nTrials) '%'])
        disp(['Removing ' mat2str(lRemove.slow3) ' ACCURATE trials ' mat2str(lRemove.slow3 / nTrials) '%'])
        
        disp(['Removing ' mat2str(lRemove.med1) ' NEUTRAL trials ' mat2str(lRemove.med1 / nTrials) '%'])
        disp(['Removing ' mat2str(lRemove.med2) ' NEUTRAL trials ' mat2str(lRemove.med2 / nTrials) '%'])
        disp(['Removing ' mat2str(lRemove.med3) ' NEUTRAL trials ' mat2str(lRemove.med3 / nTrials) '%'])
        
        disp(['Removing ' mat2str(lRemove.fast1) ' FAST trials ' mat2str(lRemove.fast1 / nTrials) '%'])
        disp(['Removing ' mat2str(lRemove.fast2) ' FAST trials ' mat2str(lRemove.fast2 / nTrials) '%'])
        disp(['Removing ' mat2str(lRemove.fast3) ' FAST trials ' mat2str(lRemove.fast3 / nTrials) '%'])
        
        
        correct.slow1(find(rt.slow1+T0.slow1 < simBound.slow(1))) = NaN;
        correct.slow1(find(rt.slow1+T0.slow1 > simBound.slow(2))) = NaN;
        correct.slow2(find(rt.slow2+T0.slow2 < simBound.slow(1))) = NaN;
        correct.slow2(find(rt.slow2+T0.slow2 > simBound.slow(2))) = NaN;
        correct.slow3(find(rt.slow3+T0.slow3 < simBound.slow(1))) = NaN;
        correct.slow3(find(rt.slow3+T0.slow3 > simBound.slow(2))) = NaN;
        
        
        correct.med1(find(rt.med1+T0.med1 < simBound.med(1))) = NaN;
        correct.med1(find(rt.med1+T0.med1 > simBound.med(2))) = NaN;
        correct.med2(find(rt.med2+T0.med2 < simBound.med(1))) = NaN;
        correct.med2(find(rt.med2+T0.med2 > simBound.med(2))) = NaN;
        correct.med3(find(rt.med3+T0.med3 < simBound.med(1))) = NaN;
        correct.med3(find(rt.med3+T0.med3 > simBound.med(2))) = NaN;
        
        
        correct.fast1(find(rt.fast1+T0.fast1 < simBound.fast(1))) = NaN;
        correct.fast1(find(rt.fast1+T0.fast1 > simBound.fast(2))) = NaN;
        correct.fast2(find(rt.fast2+T0.fast2 < simBound.fast(1))) = NaN;
        correct.fast2(find(rt.fast2+T0.fast2 > simBound.fast(2))) = NaN;
        correct.fast3(find(rt.fast3+T0.fast3 < simBound.fast(1))) = NaN;
        correct.fast3(find(rt.fast3+T0.fast3 > simBound.fast(2))) = NaN;
        
        
        
        rt.slow1(find(rt.slow1+T0.slow1 < simBound.slow(1))) = NaN;
        rt.slow1(find(rt.slow1+T0.slow1 > simBound.slow(2))) = NaN;
        rt.slow2(find(rt.slow2+T0.slow2 < simBound.slow(1))) = NaN;
        rt.slow2(find(rt.slow2+T0.slow2 > simBound.slow(2))) = NaN;
        rt.slow3(find(rt.slow3+T0.slow3 < simBound.slow(1))) = NaN;
        rt.slow3(find(rt.slow3+T0.slow3 > simBound.slow(2))) = NaN;
        
        rt.med1(find(rt.med1+T0.med1 < simBound.med(1))) = NaN;
        rt.med1(find(rt.med1+T0.med1 > simBound.med(2))) = NaN;
        rt.med2(find(rt.med2+T0.med2 < simBound.med(1))) = NaN;
        rt.med2(find(rt.med2+T0.med2 > simBound.med(2))) = NaN;
        rt.med3(find(rt.med3+T0.med3 < simBound.med(1))) = NaN;
        rt.med3(find(rt.med3+T0.med3 > simBound.med(2))) = NaN;
        
        rt.fast1(find(rt.fast1+T0.fast1 < simBound.fast(1))) = NaN;
        rt.fast1(find(rt.fast1+T0.fast1 > simBound.fast(2))) = NaN;
        rt.fast2(find(rt.fast2+T0.fast2 < simBound.fast(1))) = NaN;
        rt.fast2(find(rt.fast2+T0.fast2 > simBound.fast(2))) = NaN;
        rt.fast3(find(rt.fast3+T0.fast3 < simBound.fast(1))) = NaN;
        rt.fast3(find(rt.fast3+T0.fast3 > simBound.fast(2))) = NaN;
    end
    
    
    %to get total decision time, add decision time rt + nondecision time T0
    rt.slow1 = rt.slow1 + T0.slow1 + 1; %correct for diff operation earlier;
    rt.slow2 = rt.slow2 + T0.slow2 + 1; %correct for diff operation earlier;
    rt.slow3 = rt.slow3 + T0.slow3 + 1; %correct for diff operation earlier;
    
    rt.fast1 = rt.fast1 + T0.fast1 + 1;
    rt.fast2 = rt.fast2 + T0.fast2 + 1;
    rt.fast3 = rt.fast3 + T0.fast3 + 1;
    
    rt.med1 = rt.med1 + T0.med1 + 1;
    rt.med2 = rt.med2 + T0.med2 + 1;
    rt.med3 = rt.med3 + T0.med3 + 1;
    
    simTrls.slow1.correct = find(correct.slow1 == 1);
    simTrls.slow2.correct = find(correct.slow2 == 1);
    simTrls.slow3.correct = find(correct.slow3 == 1);
    
    simTrls.slow1.errors = find(correct.slow1 == 0);
    simTrls.slow2.errors = find(correct.slow2 == 0);
    simTrls.slow3.errors = find(correct.slow3 == 0);
    
    simTrls.fast1.correct = find(correct.fast1 == 1);
    simTrls.fast2.correct = find(correct.fast2 == 1);
    simTrls.fast3.correct = find(correct.fast3 == 1);
    
    simTrls.fast1.errors = find(correct.fast1 == 0);
    simTrls.fast2.errors = find(correct.fast2 == 0);
    simTrls.fast3.errors = find(correct.fast3 == 0);
    
    simTrls.med1.correct = find(correct.med1 == 1);
    simTrls.med2.correct = find(correct.med2 == 1);
    simTrls.med3.correct = find(correct.med3 == 1);
    
    simTrls.med1.errors = find(correct.med1 == 0);
    simTrls.med2.errors = find(correct.med2 == 0);
    simTrls.med3.errors = find(correct.med3 == 0);
    
    
    
    N.slow1.correct = length(slow_correct_made_dead_binSLOW);
    N.slow2.correct = length(slow_correct_made_dead_binMED);
    N.slow3.correct = length(slow_correct_made_dead_binFAST);
    
    N.slow1.errors = length(slow_errors_made_dead_binSLOW);
    N.slow2.errors = length(slow_errors_made_dead_binMED);
    N.slow3.errors = length(slow_errors_made_dead_binFAST);
    
    N.slow1.all = N.slow1.correct + N.slow1.errors;
    N.slow2.all = N.slow2.correct + N.slow2.errors;
    N.slow3.all = N.slow3.correct + N.slow3.errors;
    
    N.fast1.correct = length(fast_correct_made_dead_withCleared_binSLOW);
    N.fast2.correct = length(fast_correct_made_dead_withCleared_binMED);
    N.fast3.correct = length(fast_correct_made_dead_withCleared_binFAST);
    
    N.fast1.errors = length(fast_errors_made_dead_withCleared_binSLOW);
    N.fast2.errors = length(fast_errors_made_dead_withCleared_binMED);
    N.fast3.errors = length(fast_errors_made_dead_withCleared_binFAST);
    
    N.fast1.all = N.fast1.correct + N.fast1.errors;
    N.fast2.all = N.fast2.correct + N.fast2.errors;
    N.fast3.all = N.fast3.correct + N.fast3.errors;
    
    N.med1.correct = length(med_correct_binSLOW);
    N.med2.correct = length(med_correct_binMED);
    N.med3.correct = length(med_correct_binFAST);
    
    N.med1.errors = length(med_errors_binSLOW);
    N.med2.errors = length(med_errors_binMED);
    N.med3.errors = length(med_errors_binFAST);
    
    N.med1.all = N.med1.correct + N.med1.errors;
    N.med2.all = N.med2.correct + N.med2.errors;
    N.med3.all = N.med3.correct + N.med3.errors;
    
    
    simN.slow1.correct = length(simTrls.slow1.correct);
    simN.slow2.correct = length(simTrls.slow2.correct);
    simN.slow3.correct = length(simTrls.slow3.correct);
    
    simN.slow1.errors = length(simTrls.slow1.errors);
    simN.slow2.errors = length(simTrls.slow2.errors);
    simN.slow3.errors = length(simTrls.slow3.errors);
    
    simN.slow1.all = simN.slow1.correct + simN.slow1.errors;
    simN.slow2.all = simN.slow2.correct + simN.slow2.errors;
    simN.slow3.all = simN.slow3.correct + simN.slow3.errors;
    
    simN.fast1.correct = length(simTrls.fast1.correct);
    simN.fast2.correct = length(simTrls.fast2.correct);
    simN.fast3.correct = length(simTrls.fast3.correct);
    
    simN.fast1.errors = length(simTrls.fast1.errors);
    simN.fast2.errors = length(simTrls.fast2.errors);
    simN.fast3.errors = length(simTrls.fast3.errors);
    
    simN.fast1.all = simN.fast1.correct + simN.fast1.errors;
    simN.fast2.all = simN.fast2.correct + simN.fast2.errors;
    simN.fast3.all = simN.fast3.correct + simN.fast3.errors;
    
    simN.med1.correct = length(simTrls.med1.correct);
    simN.med2.correct = length(simTrls.med2.correct);
    simN.med3.correct = length(simTrls.med3.correct);
    
    simN.med1.errors = length(simTrls.med1.errors);
    simN.med2.errors = length(simTrls.med2.errors);
    simN.med3.errors = length(simTrls.med3.errors);
    
    simN.med1.all = simN.med1.correct + simN.med1.errors;
    simN.med2.all = simN.med2.correct + simN.med2.errors;
    simN.med3.all = simN.med3.correct + simN.med3.errors;
    
    
    pred_prop.slow1.correct(1) = length(find(rt.slow1(simTrls.slow1.correct) <= ntiles.slow1.correct(1))) / simN.slow1.all;
    pred_prop.slow1.correct(2) = length(find(rt.slow1(simTrls.slow1.correct) > ntiles.slow1.correct(1) & rt.slow1(simTrls.slow1.correct) <= ntiles.slow1.correct(2))) / simN.slow1.all;
    pred_prop.slow1.correct(3) = length(find(rt.slow1(simTrls.slow1.correct) > ntiles.slow1.correct(2) & rt.slow1(simTrls.slow1.correct) <= ntiles.slow1.correct(3))) / simN.slow1.all;
    pred_prop.slow1.correct(4) = length(find(rt.slow1(simTrls.slow1.correct) > ntiles.slow1.correct(3) & rt.slow1(simTrls.slow1.correct) <= ntiles.slow1.correct(4))) / simN.slow1.all;
    pred_prop.slow1.correct(5) = length(find(rt.slow1(simTrls.slow1.correct) > ntiles.slow1.correct(4) & rt.slow1(simTrls.slow1.correct) <= ntiles.slow1.correct(5))) / simN.slow1.all;
    pred_prop.slow1.correct(6) = length(find(rt.slow1(simTrls.slow1.correct) > ntiles.slow1.correct(5))) / simN.slow1.all;
    
    pred_prop.slow1.errors(1) = length(find(rt.slow1(simTrls.slow1.errors) <= ntiles.slow1.errors(1))) / simN.slow1.all;
    pred_prop.slow1.errors(2) = length(find(rt.slow1(simTrls.slow1.errors) > ntiles.slow1.errors(1) & rt.slow1(simTrls.slow1.errors) <= ntiles.slow1.errors(2))) / simN.slow1.all;
    pred_prop.slow1.errors(3) = length(find(rt.slow1(simTrls.slow1.errors) > ntiles.slow1.errors(2) & rt.slow1(simTrls.slow1.errors) <= ntiles.slow1.errors(3))) / simN.slow1.all;
    pred_prop.slow1.errors(4) = length(find(rt.slow1(simTrls.slow1.errors) > ntiles.slow1.errors(3) & rt.slow1(simTrls.slow1.errors) <= ntiles.slow1.errors(4))) / simN.slow1.all;
    pred_prop.slow1.errors(5) = length(find(rt.slow1(simTrls.slow1.errors) > ntiles.slow1.errors(4) & rt.slow1(simTrls.slow1.errors) <= ntiles.slow1.errors(5))) / simN.slow1.all;
    pred_prop.slow1.errors(6) = length(find(rt.slow1(simTrls.slow1.errors) > ntiles.slow1.errors(5))) / simN.slow1.all;
    
    pred_prop.fast1.correct(1) = length(find(rt.fast1(simTrls.fast1.correct) <= ntiles.fast1.correct(1))) / simN.fast1.all;
    pred_prop.fast1.correct(2) = length(find(rt.fast1(simTrls.fast1.correct) > ntiles.fast1.correct(1) & rt.fast1(simTrls.fast1.correct) <= ntiles.fast1.correct(2))) / simN.fast1.all;
    pred_prop.fast1.correct(3) = length(find(rt.fast1(simTrls.fast1.correct) > ntiles.fast1.correct(2) & rt.fast1(simTrls.fast1.correct) <= ntiles.fast1.correct(3))) / simN.fast1.all;
    pred_prop.fast1.correct(4) = length(find(rt.fast1(simTrls.fast1.correct) > ntiles.fast1.correct(3) & rt.fast1(simTrls.fast1.correct) <= ntiles.fast1.correct(4))) / simN.fast1.all;
    pred_prop.fast1.correct(5) = length(find(rt.fast1(simTrls.fast1.correct) > ntiles.fast1.correct(4) & rt.fast1(simTrls.fast1.correct) <= ntiles.fast1.correct(5))) / simN.fast1.all;
    pred_prop.fast1.correct(6) = length(find(rt.fast1(simTrls.fast1.correct) > ntiles.fast1.correct(5))) / simN.fast1.all;
    
    pred_prop.fast1.errors(1) = length(find(rt.fast1(simTrls.fast1.errors) <= ntiles.fast1.errors(1))) / simN.fast1.all;
    pred_prop.fast1.errors(2) = length(find(rt.fast1(simTrls.fast1.errors) > ntiles.fast1.errors(1) & rt.fast1(simTrls.fast1.errors) <= ntiles.fast1.errors(2))) / simN.fast1.all;
    pred_prop.fast1.errors(3) = length(find(rt.fast1(simTrls.fast1.errors) > ntiles.fast1.errors(2) & rt.fast1(simTrls.fast1.errors) <= ntiles.fast1.errors(3))) / simN.fast1.all;
    pred_prop.fast1.errors(4) = length(find(rt.fast1(simTrls.fast1.errors) > ntiles.fast1.errors(3) & rt.fast1(simTrls.fast1.errors) <= ntiles.fast1.errors(4))) / simN.fast1.all;
    pred_prop.fast1.errors(5) = length(find(rt.fast1(simTrls.fast1.errors) > ntiles.fast1.errors(4) & rt.fast1(simTrls.fast1.errors) <= ntiles.fast1.errors(5))) / simN.fast1.all;
    pred_prop.fast1.errors(6) = length(find(rt.fast1(simTrls.fast1.errors) > ntiles.fast1.errors(5))) / simN.fast1.all;
    
    pred_prop.med1.correct(1) = length(find(rt.med1(simTrls.med1.correct) <= ntiles.med1.correct(1))) / simN.med1.all;
    pred_prop.med1.correct(2) = length(find(rt.med1(simTrls.med1.correct) > ntiles.med1.correct(1) & rt.med1(simTrls.med1.correct) <= ntiles.med1.correct(2))) / simN.med1.all;
    pred_prop.med1.correct(3) = length(find(rt.med1(simTrls.med1.correct) > ntiles.med1.correct(2) & rt.med1(simTrls.med1.correct) <= ntiles.med1.correct(3))) / simN.med1.all;
    pred_prop.med1.correct(4) = length(find(rt.med1(simTrls.med1.correct) > ntiles.med1.correct(3) & rt.med1(simTrls.med1.correct) <= ntiles.med1.correct(4))) / simN.med1.all;
    pred_prop.med1.correct(5) = length(find(rt.med1(simTrls.med1.correct) > ntiles.med1.correct(4) & rt.med1(simTrls.med1.correct) <= ntiles.med1.correct(5))) / simN.med1.all;
    pred_prop.med1.correct(6) = length(find(rt.med1(simTrls.med1.correct) > ntiles.med1.correct(5))) / simN.med1.all;
    
    pred_prop.med1.errors(1) = length(find(rt.med1(simTrls.med1.errors) <= ntiles.med1.errors(1))) / simN.med1.all;
    pred_prop.med1.errors(2) = length(find(rt.med1(simTrls.med1.errors) > ntiles.med1.errors(1) & rt.med1(simTrls.med1.errors) <= ntiles.med1.errors(2))) / simN.med1.all;
    pred_prop.med1.errors(3) = length(find(rt.med1(simTrls.med1.errors) > ntiles.med1.errors(2) & rt.med1(simTrls.med1.errors) <= ntiles.med1.errors(3))) / simN.med1.all;
    pred_prop.med1.errors(4) = length(find(rt.med1(simTrls.med1.errors) > ntiles.med1.errors(3) & rt.med1(simTrls.med1.errors) <= ntiles.med1.errors(4))) / simN.med1.all;
    pred_prop.med1.errors(5) = length(find(rt.med1(simTrls.med1.errors) > ntiles.med1.errors(4) & rt.med1(simTrls.med1.errors) <= ntiles.med1.errors(5))) / simN.med1.all;
    pred_prop.med1.errors(6) = length(find(rt.med1(simTrls.med1.errors) > ntiles.med1.errors(5))) / simN.med1.all;
    

    
    pred_prop.slow2.correct(1) = length(find(rt.slow2(simTrls.slow2.correct) <= ntiles.slow2.correct(1))) / simN.slow2.all;
    pred_prop.slow2.correct(2) = length(find(rt.slow2(simTrls.slow2.correct) > ntiles.slow2.correct(1) & rt.slow2(simTrls.slow2.correct) <= ntiles.slow2.correct(2))) / simN.slow2.all;
    pred_prop.slow2.correct(3) = length(find(rt.slow2(simTrls.slow2.correct) > ntiles.slow2.correct(2) & rt.slow2(simTrls.slow2.correct) <= ntiles.slow2.correct(3))) / simN.slow2.all;
    pred_prop.slow2.correct(4) = length(find(rt.slow2(simTrls.slow2.correct) > ntiles.slow2.correct(3) & rt.slow2(simTrls.slow2.correct) <= ntiles.slow2.correct(4))) / simN.slow2.all;
    pred_prop.slow2.correct(5) = length(find(rt.slow2(simTrls.slow2.correct) > ntiles.slow2.correct(4) & rt.slow2(simTrls.slow2.correct) <= ntiles.slow2.correct(5))) / simN.slow2.all;
    pred_prop.slow2.correct(6) = length(find(rt.slow2(simTrls.slow2.correct) > ntiles.slow2.correct(5))) / simN.slow2.all;
    
    pred_prop.slow2.errors(1) = length(find(rt.slow2(simTrls.slow2.errors) <= ntiles.slow2.errors(1))) / simN.slow2.all;
    pred_prop.slow2.errors(2) = length(find(rt.slow2(simTrls.slow2.errors) > ntiles.slow2.errors(1) & rt.slow2(simTrls.slow2.errors) <= ntiles.slow2.errors(2))) / simN.slow2.all;
    pred_prop.slow2.errors(3) = length(find(rt.slow2(simTrls.slow2.errors) > ntiles.slow2.errors(2) & rt.slow2(simTrls.slow2.errors) <= ntiles.slow2.errors(3))) / simN.slow2.all;
    pred_prop.slow2.errors(4) = length(find(rt.slow2(simTrls.slow2.errors) > ntiles.slow2.errors(3) & rt.slow2(simTrls.slow2.errors) <= ntiles.slow2.errors(4))) / simN.slow2.all;
    pred_prop.slow2.errors(5) = length(find(rt.slow2(simTrls.slow2.errors) > ntiles.slow2.errors(4) & rt.slow2(simTrls.slow2.errors) <= ntiles.slow2.errors(5))) / simN.slow2.all;
    pred_prop.slow2.errors(6) = length(find(rt.slow2(simTrls.slow2.errors) > ntiles.slow2.errors(5))) / simN.slow2.all;
    
    pred_prop.fast2.correct(1) = length(find(rt.fast2(simTrls.fast2.correct) <= ntiles.fast2.correct(1))) / simN.fast2.all;
    pred_prop.fast2.correct(2) = length(find(rt.fast2(simTrls.fast2.correct) > ntiles.fast2.correct(1) & rt.fast2(simTrls.fast2.correct) <= ntiles.fast2.correct(2))) / simN.fast2.all;
    pred_prop.fast2.correct(3) = length(find(rt.fast2(simTrls.fast2.correct) > ntiles.fast2.correct(2) & rt.fast2(simTrls.fast2.correct) <= ntiles.fast2.correct(3))) / simN.fast2.all;
    pred_prop.fast2.correct(4) = length(find(rt.fast2(simTrls.fast2.correct) > ntiles.fast2.correct(3) & rt.fast2(simTrls.fast2.correct) <= ntiles.fast2.correct(4))) / simN.fast2.all;
    pred_prop.fast2.correct(5) = length(find(rt.fast2(simTrls.fast2.correct) > ntiles.fast2.correct(4) & rt.fast2(simTrls.fast2.correct) <= ntiles.fast2.correct(5))) / simN.fast2.all;
    pred_prop.fast2.correct(6) = length(find(rt.fast2(simTrls.fast2.correct) > ntiles.fast2.correct(5))) / simN.fast2.all;
    
    pred_prop.fast2.errors(1) = length(find(rt.fast2(simTrls.fast2.errors) <= ntiles.fast2.errors(1))) / simN.fast2.all;
    pred_prop.fast2.errors(2) = length(find(rt.fast2(simTrls.fast2.errors) > ntiles.fast2.errors(1) & rt.fast2(simTrls.fast2.errors) <= ntiles.fast2.errors(2))) / simN.fast2.all;
    pred_prop.fast2.errors(3) = length(find(rt.fast2(simTrls.fast2.errors) > ntiles.fast2.errors(2) & rt.fast2(simTrls.fast2.errors) <= ntiles.fast2.errors(3))) / simN.fast2.all;
    pred_prop.fast2.errors(4) = length(find(rt.fast2(simTrls.fast2.errors) > ntiles.fast2.errors(3) & rt.fast2(simTrls.fast2.errors) <= ntiles.fast2.errors(4))) / simN.fast2.all;
    pred_prop.fast2.errors(5) = length(find(rt.fast2(simTrls.fast2.errors) > ntiles.fast2.errors(4) & rt.fast2(simTrls.fast2.errors) <= ntiles.fast2.errors(5))) / simN.fast2.all;
    pred_prop.fast2.errors(6) = length(find(rt.fast2(simTrls.fast2.errors) > ntiles.fast2.errors(5))) / simN.fast2.all;
    
    pred_prop.med2.correct(1) = length(find(rt.med2(simTrls.med2.correct) <= ntiles.med2.correct(1))) / simN.med2.all;
    pred_prop.med2.correct(2) = length(find(rt.med2(simTrls.med2.correct) > ntiles.med2.correct(1) & rt.med2(simTrls.med2.correct) <= ntiles.med2.correct(2))) / simN.med2.all;
    pred_prop.med2.correct(3) = length(find(rt.med2(simTrls.med2.correct) > ntiles.med2.correct(2) & rt.med2(simTrls.med2.correct) <= ntiles.med2.correct(3))) / simN.med2.all;
    pred_prop.med2.correct(4) = length(find(rt.med2(simTrls.med2.correct) > ntiles.med2.correct(3) & rt.med2(simTrls.med2.correct) <= ntiles.med2.correct(4))) / simN.med2.all;
    pred_prop.med2.correct(5) = length(find(rt.med2(simTrls.med2.correct) > ntiles.med2.correct(4) & rt.med2(simTrls.med2.correct) <= ntiles.med2.correct(5))) / simN.med2.all;
    pred_prop.med2.correct(6) = length(find(rt.med2(simTrls.med2.correct) > ntiles.med2.correct(5))) / simN.med2.all;
    
    pred_prop.med2.errors(1) = length(find(rt.med2(simTrls.med2.errors) <= ntiles.med2.errors(1))) / simN.med2.all;
    pred_prop.med2.errors(2) = length(find(rt.med2(simTrls.med2.errors) > ntiles.med2.errors(1) & rt.med2(simTrls.med2.errors) <= ntiles.med2.errors(2))) / simN.med2.all;
    pred_prop.med2.errors(3) = length(find(rt.med2(simTrls.med2.errors) > ntiles.med2.errors(2) & rt.med2(simTrls.med2.errors) <= ntiles.med2.errors(3))) / simN.med2.all;
    pred_prop.med2.errors(4) = length(find(rt.med2(simTrls.med2.errors) > ntiles.med2.errors(3) & rt.med2(simTrls.med2.errors) <= ntiles.med2.errors(4))) / simN.med2.all;
    pred_prop.med2.errors(5) = length(find(rt.med2(simTrls.med2.errors) > ntiles.med2.errors(4) & rt.med2(simTrls.med2.errors) <= ntiles.med2.errors(5))) / simN.med2.all;
    pred_prop.med2.errors(6) = length(find(rt.med2(simTrls.med2.errors) > ntiles.med2.errors(5))) / simN.med2.all;
    

        pred_prop.slow3.correct(1) = length(find(rt.slow3(simTrls.slow3.correct) <= ntiles.slow3.correct(1))) / simN.slow3.all;
    pred_prop.slow3.correct(2) = length(find(rt.slow3(simTrls.slow3.correct) > ntiles.slow3.correct(1) & rt.slow3(simTrls.slow3.correct) <= ntiles.slow3.correct(2))) / simN.slow3.all;
    pred_prop.slow3.correct(3) = length(find(rt.slow3(simTrls.slow3.correct) > ntiles.slow3.correct(2) & rt.slow3(simTrls.slow3.correct) <= ntiles.slow3.correct(3))) / simN.slow3.all;
    pred_prop.slow3.correct(4) = length(find(rt.slow3(simTrls.slow3.correct) > ntiles.slow3.correct(3) & rt.slow3(simTrls.slow3.correct) <= ntiles.slow3.correct(4))) / simN.slow3.all;
    pred_prop.slow3.correct(5) = length(find(rt.slow3(simTrls.slow3.correct) > ntiles.slow3.correct(4) & rt.slow3(simTrls.slow3.correct) <= ntiles.slow3.correct(5))) / simN.slow3.all;
    pred_prop.slow3.correct(6) = length(find(rt.slow3(simTrls.slow3.correct) > ntiles.slow3.correct(5))) / simN.slow3.all;
    
    pred_prop.slow3.errors(1) = length(find(rt.slow3(simTrls.slow3.errors) <= ntiles.slow3.errors(1))) / simN.slow3.all;
    pred_prop.slow3.errors(2) = length(find(rt.slow3(simTrls.slow3.errors) > ntiles.slow3.errors(1) & rt.slow3(simTrls.slow3.errors) <= ntiles.slow3.errors(2))) / simN.slow3.all;
    pred_prop.slow3.errors(3) = length(find(rt.slow3(simTrls.slow3.errors) > ntiles.slow3.errors(2) & rt.slow3(simTrls.slow3.errors) <= ntiles.slow3.errors(3))) / simN.slow3.all;
    pred_prop.slow3.errors(4) = length(find(rt.slow3(simTrls.slow3.errors) > ntiles.slow3.errors(3) & rt.slow3(simTrls.slow3.errors) <= ntiles.slow3.errors(4))) / simN.slow3.all;
    pred_prop.slow3.errors(5) = length(find(rt.slow3(simTrls.slow3.errors) > ntiles.slow3.errors(4) & rt.slow3(simTrls.slow3.errors) <= ntiles.slow3.errors(5))) / simN.slow3.all;
    pred_prop.slow3.errors(6) = length(find(rt.slow3(simTrls.slow3.errors) > ntiles.slow3.errors(5))) / simN.slow3.all;
    
    pred_prop.fast3.correct(1) = length(find(rt.fast3(simTrls.fast3.correct) <= ntiles.fast3.correct(1))) / simN.fast3.all;
    pred_prop.fast3.correct(2) = length(find(rt.fast3(simTrls.fast3.correct) > ntiles.fast3.correct(1) & rt.fast3(simTrls.fast3.correct) <= ntiles.fast3.correct(2))) / simN.fast3.all;
    pred_prop.fast3.correct(3) = length(find(rt.fast3(simTrls.fast3.correct) > ntiles.fast3.correct(2) & rt.fast3(simTrls.fast3.correct) <= ntiles.fast3.correct(3))) / simN.fast3.all;
    pred_prop.fast3.correct(4) = length(find(rt.fast3(simTrls.fast3.correct) > ntiles.fast3.correct(3) & rt.fast3(simTrls.fast3.correct) <= ntiles.fast3.correct(4))) / simN.fast3.all;
    pred_prop.fast3.correct(5) = length(find(rt.fast3(simTrls.fast3.correct) > ntiles.fast3.correct(4) & rt.fast3(simTrls.fast3.correct) <= ntiles.fast3.correct(5))) / simN.fast3.all;
    pred_prop.fast3.correct(6) = length(find(rt.fast3(simTrls.fast3.correct) > ntiles.fast3.correct(5))) / simN.fast3.all;
    
    pred_prop.fast3.errors(1) = length(find(rt.fast3(simTrls.fast3.errors) <= ntiles.fast3.errors(1))) / simN.fast3.all;
    pred_prop.fast3.errors(2) = length(find(rt.fast3(simTrls.fast3.errors) > ntiles.fast3.errors(1) & rt.fast3(simTrls.fast3.errors) <= ntiles.fast3.errors(2))) / simN.fast3.all;
    pred_prop.fast3.errors(3) = length(find(rt.fast3(simTrls.fast3.errors) > ntiles.fast3.errors(2) & rt.fast3(simTrls.fast3.errors) <= ntiles.fast3.errors(3))) / simN.fast3.all;
    pred_prop.fast3.errors(4) = length(find(rt.fast3(simTrls.fast3.errors) > ntiles.fast3.errors(3) & rt.fast3(simTrls.fast3.errors) <= ntiles.fast3.errors(4))) / simN.fast3.all;
    pred_prop.fast3.errors(5) = length(find(rt.fast3(simTrls.fast3.errors) > ntiles.fast3.errors(4) & rt.fast3(simTrls.fast3.errors) <= ntiles.fast3.errors(5))) / simN.fast3.all;
    pred_prop.fast3.errors(6) = length(find(rt.fast3(simTrls.fast3.errors) > ntiles.fast3.errors(5))) / simN.fast3.all;
    
    pred_prop.med3.correct(1) = length(find(rt.med3(simTrls.med3.correct) <= ntiles.med3.correct(1))) / simN.med3.all;
    pred_prop.med3.correct(2) = length(find(rt.med3(simTrls.med3.correct) > ntiles.med3.correct(1) & rt.med3(simTrls.med3.correct) <= ntiles.med3.correct(2))) / simN.med3.all;
    pred_prop.med3.correct(3) = length(find(rt.med3(simTrls.med3.correct) > ntiles.med3.correct(2) & rt.med3(simTrls.med3.correct) <= ntiles.med3.correct(3))) / simN.med3.all;
    pred_prop.med3.correct(4) = length(find(rt.med3(simTrls.med3.correct) > ntiles.med3.correct(3) & rt.med3(simTrls.med3.correct) <= ntiles.med3.correct(4))) / simN.med3.all;
    pred_prop.med3.correct(5) = length(find(rt.med3(simTrls.med3.correct) > ntiles.med3.correct(4) & rt.med3(simTrls.med3.correct) <= ntiles.med3.correct(5))) / simN.med3.all;
    pred_prop.med3.correct(6) = length(find(rt.med3(simTrls.med3.correct) > ntiles.med3.correct(5))) / simN.med3.all;
    
    pred_prop.med3.errors(1) = length(find(rt.med3(simTrls.med3.errors) <= ntiles.med3.errors(1))) / simN.med3.all;
    pred_prop.med3.errors(2) = length(find(rt.med3(simTrls.med3.errors) > ntiles.med3.errors(1) & rt.med3(simTrls.med3.errors) <= ntiles.med3.errors(2))) / simN.med3.all;
    pred_prop.med3.errors(3) = length(find(rt.med3(simTrls.med3.errors) > ntiles.med3.errors(2) & rt.med3(simTrls.med3.errors) <= ntiles.med3.errors(3))) / simN.med3.all;
    pred_prop.med3.errors(4) = length(find(rt.med3(simTrls.med3.errors) > ntiles.med3.errors(3) & rt.med3(simTrls.med3.errors) <= ntiles.med3.errors(4))) / simN.med3.all;
    pred_prop.med3.errors(5) = length(find(rt.med3(simTrls.med3.errors) > ntiles.med3.errors(4) & rt.med3(simTrls.med3.errors) <= ntiles.med3.errors(5))) / simN.med3.all;
    pred_prop.med3.errors(6) = length(find(rt.med3(simTrls.med3.errors) > ntiles.med3.errors(5))) / simN.med3.all;
    

    
    pred_freq.slow1.correct = pred_prop.slow1.correct .* N.slow1.all;
    pred_freq.slow2.correct = pred_prop.slow2.correct .* N.slow2.all;
    pred_freq.slow3.correct = pred_prop.slow3.correct .* N.slow3.all;
    
    pred_freq.slow1.errors = pred_prop.slow1.errors .* N.slow1.all;
    pred_freq.slow2.errors = pred_prop.slow2.errors .* N.slow2.all;
    pred_freq.slow3.errors = pred_prop.slow3.errors .* N.slow3.all;
    
    pred_freq.fast1.correct = pred_prop.fast1.correct .* N.fast1.all;
    pred_freq.fast2.correct = pred_prop.fast2.correct .* N.fast2.all;
    pred_freq.fast3.correct = pred_prop.fast3.correct .* N.fast3.all;
    
    pred_freq.fast1.errors = pred_prop.fast1.errors .* N.fast1.all;
    pred_freq.fast2.errors = pred_prop.fast2.errors .* N.fast2.all;
    pred_freq.fast3.errors = pred_prop.fast3.errors .* N.fast3.all;
    
    pred_freq.med1.correct = pred_prop.med1.correct .* N.med1.all;
    pred_freq.med2.correct = pred_prop.med2.correct .* N.med2.all;
    pred_freq.med3.correct = pred_prop.med3.correct .* N.med3.all;
    
    pred_freq.med1.errors = pred_prop.med1.errors .* N.med1.all;
    pred_freq.med2.errors = pred_prop.med2.errors .* N.med2.all;
    pred_freq.med3.errors = pred_prop.med3.errors .* N.med3.all;
    
    
    all_obs = [obs_freq.slow1.correct' ; obs_freq.slow1.errors' ; ...
        obs_freq.slow2.correct' ; obs_freq.slow2.errors' ; ...
        obs_freq.slow3.correct' ; obs_freq.slow3.errors' ; ...
        obs_freq.med1.correct' ; obs_freq.med1.errors' ; ...
        obs_freq.med2.correct' ; obs_freq.med2.errors' ; ...
        obs_freq.med3.correct' ; obs_freq.med3.errors' ; ...
        obs_freq.fast1.correct' ; obs_freq.fast1.errors' ; ...
        obs_freq.fast2.correct' ; obs_freq.fast2.errors' ; ...
        obs_freq.fast3.correct' ; obs_freq.fast3.errors'];
    
    all_pred = [pred_freq.slow1.correct' ; pred_freq.slow1.errors' ; ...
        pred_freq.slow2.correct' ; pred_freq.slow2.errors' ; ...
        pred_freq.slow3.correct' ; pred_freq.slow3.errors' ; ...
        pred_freq.med1.correct' ; pred_freq.med1.errors' ; ...
        pred_freq.med2.correct' ; pred_freq.med2.errors' ; ...
        pred_freq.med3.correct' ; pred_freq.med3.errors' ; ...
        pred_freq.fast1.correct' ; pred_freq.fast1.errors' ; ...
        pred_freq.fast2.correct' ; pred_freq.fast2.errors' ; ...
        pred_freq.fast3.correct' ; pred_freq.fast3.errors'];

    
    
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
        fprintf(fid, 'sd_rate: %f\n',sd_rate);
        fprintf(fid, '\n');
        fprintf(fid, 'Starting Params: \n');
        fprintf(fid, '%f\n',start_param);
        fprintf(fid, '\n');
        fprintf(fid, 'Solution: \n');
        fprintf(fid, '%f\n',solution);
        fclose(fid);
    end
    
    obs_prop_correct.slow1 = N.slow1.correct / N.slow1.all;
    obs_prop_correct.slow2 = N.slow2.correct / N.slow2.all;
    obs_prop_correct.slow3 = N.slow3.correct / N.slow3.all;
    
    obs_prop_errors.slow1 = 1-obs_prop_correct.slow1;
    obs_prop_errors.slow2 = 1-obs_prop_correct.slow2;
    obs_prop_errors.slow3 = 1-obs_prop_correct.slow3;
    
    obs_prop_correct.fast1 = N.fast1.correct / N.fast1.all;
    obs_prop_correct.fast2 = N.fast2.correct / N.fast2.all;
    obs_prop_correct.fast3 = N.fast3.correct / N.fast3.all;
    
    obs_prop_errors.fast1 = 1-obs_prop_correct.fast1;
    obs_prop_errors.fast2 = 1-obs_prop_correct.fast2;
    obs_prop_errors.fast3 = 1-obs_prop_correct.fast3;
    
    obs_prop_correct.med1 = N.med1.correct / N.med1.all;
    obs_prop_correct.med2 = N.med2.correct / N.med2.all;
    obs_prop_correct.med3 = N.med3.correct / N.med3.all;
    
    obs_prop_errors.med1 = 1-obs_prop_correct.med1;
    obs_prop_errors.med2 = 1-obs_prop_correct.med2;
    obs_prop_errors.med3 = 1-obs_prop_correct.med3;
    
    
    pred_prop_correct.slow1 = length(simTrls.slow1.correct) / (length(simTrls.slow1.correct) + length(simTrls.slow1.errors));
    pred_prop_correct.slow2 = length(simTrls.slow2.correct) / (length(simTrls.slow2.correct) + length(simTrls.slow2.errors));
    pred_prop_correct.slow3 = length(simTrls.slow3.correct) / (length(simTrls.slow3.correct) + length(simTrls.slow3.errors));
    
    pred_prop_errors.slow1 = 1-pred_prop_correct.slow1;
    pred_prop_errors.slow2 = 1-pred_prop_correct.slow2;
    pred_prop_errors.slow3 = 1-pred_prop_correct.slow3;
    
    
    pred_prop_correct.fast1 = length(simTrls.fast1.correct) / (length(simTrls.fast1.correct) + length(simTrls.fast1.errors));
    pred_prop_correct.fast2 = length(simTrls.fast2.correct) / (length(simTrls.fast2.correct) + length(simTrls.fast2.errors));
    pred_prop_correct.fast3 = length(simTrls.fast3.correct) / (length(simTrls.fast3.correct) + length(simTrls.fast3.errors));
    
    pred_prop_errors.fast1 = 1-pred_prop_correct.fast1;
    pred_prop_errors.fast2 = 1-pred_prop_correct.fast2;
    pred_prop_errors.fast3 = 1-pred_prop_correct.fast3;
    
    pred_prop_correct.med1 = length(simTrls.med1.correct) / (length(simTrls.med1.correct) + length(simTrls.med1.errors));
    pred_prop_correct.med2 = length(simTrls.med2.correct) / (length(simTrls.med2.correct) + length(simTrls.med2.errors));
    pred_prop_correct.med3 = length(simTrls.med3.correct) / (length(simTrls.med3.correct) + length(simTrls.med3.errors));
    
    pred_prop_errors.med1 = 1-pred_prop_correct.med1;
    pred_prop_errors.med2 = 1-pred_prop_correct.med2;
    pred_prop_errors.med3 = 1-pred_prop_correct.med3;
    
    
    
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
    
    
    
    
    figure
    
    subplot(3,3,1)
    hold on
    plot([ntiles.slow1.correct],(cumsum(obs_freq.slow1.correct)./N.slow1.correct)*obs_prop_correct.slow1,'ok',[ntiles.slow1.errors],(cumsum(obs_freq.slow1.errors)./N.slow1.errors)*obs_prop_errors.slow1,'or','markersize',8)
    plot([ntiles.slow1.correct],(cumsum(pred_freq.slow1.correct)./N.slow1.correct)*pred_prop_correct.slow1,'-xk',[ntiles.slow1.errors],(cumsum(pred_freq.slow1.errors)./N.slow1.errors)*pred_prop_errors.slow1,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([400 900])
    ylim([0 1])
    
    subplot(3,3,2)
    hold on
    plot([ntiles.slow2.correct],(cumsum(obs_freq.slow2.correct)./N.slow2.correct)*obs_prop_correct.slow2,'ok',[ntiles.slow2.errors],(cumsum(obs_freq.slow2.errors)./N.slow2.errors)*obs_prop_errors.slow2,'or','markersize',8)
    plot([ntiles.slow2.correct],(cumsum(pred_freq.slow2.correct)./N.slow2.correct)*pred_prop_correct.slow2,'-xk',[ntiles.slow2.errors],(cumsum(pred_freq.slow2.errors)./N.slow2.errors)*pred_prop_errors.slow2,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([400 700])
    ylim([0 1])
    
    subplot(3,3,3)
    hold on
    plot([ntiles.slow3.correct],(cumsum(obs_freq.slow3.correct)./N.slow3.correct)*obs_prop_correct.slow3,'ok',[ntiles.slow3.errors],(cumsum(obs_freq.slow3.errors)./N.slow3.errors)*obs_prop_errors.slow3,'or','markersize',8)
    plot([ntiles.slow3.correct],(cumsum(pred_freq.slow3.correct)./N.slow3.correct)*pred_prop_correct.slow3,'-xk',[ntiles.slow3.errors],(cumsum(pred_freq.slow3.errors)./N.slow3.errors)*pred_prop_errors.slow3,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([400 700])
    ylim([0 1])
    
    subplot(3,3,7)
    hold on
    plot([ntiles.fast1.correct],(cumsum(obs_freq.fast1.correct)./N.fast1.correct)*obs_prop_correct.fast1,'ok',[ntiles.fast1.errors],(cumsum(obs_freq.fast1.errors)./N.fast1.errors)*obs_prop_errors.fast1,'or','markersize',8)
    plot([ntiles.fast1.correct],(cumsum(pred_freq.fast1.correct)./N.fast1.correct)*pred_prop_correct.fast1,'-xk',[ntiles.fast1.errors],(cumsum(pred_freq.fast1.errors)./N.fast1.errors)*pred_prop_errors.fast1,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([200 400])
    ylim([0 1])
    
    subplot(3,3,8)
    hold on
    plot([ntiles.fast2.correct],(cumsum(obs_freq.fast2.correct)./N.fast2.correct)*obs_prop_correct.fast2,'ok',[ntiles.fast2.errors],(cumsum(obs_freq.fast2.errors)./N.fast2.errors)*obs_prop_errors.fast2,'or','markersize',8)
    plot([ntiles.fast2.correct],(cumsum(pred_freq.fast2.correct)./N.fast2.correct)*pred_prop_correct.fast2,'-xk',[ntiles.fast2.errors],(cumsum(pred_freq.fast2.errors)./N.fast2.errors)*pred_prop_errors.fast2,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([200 400])
    ylim([0 1])
    
    subplot(3,3,9)
    hold on
    plot([ntiles.fast3.correct],(cumsum(obs_freq.fast3.correct)./N.fast3.correct)*obs_prop_correct.fast3,'ok',[ntiles.fast3.errors],(cumsum(obs_freq.fast3.errors)./N.fast3.errors)*obs_prop_errors.fast3,'or','markersize',8)
    plot([ntiles.fast3.correct],(cumsum(pred_freq.fast3.correct)./N.fast3.correct)*pred_prop_correct.fast3,'-xk',[ntiles.fast3.errors],(cumsum(pred_freq.fast3.errors)./N.fast3.errors)*pred_prop_errors.fast3,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([200 400])
    ylim([0 1])
    
    subplot(3,3,4)
    hold on
    plot([ntiles.med1.correct],(cumsum(obs_freq.med1.correct)./N.med1.correct)*obs_prop_correct.med1,'ok',[ntiles.med1.errors],(cumsum(obs_freq.med1.errors)./N.med1.errors)*obs_prop_errors.med1,'or','markersize',8)
    plot([ntiles.med1.correct],(cumsum(pred_freq.med1.correct)./N.med1.correct)*pred_prop_correct.med1,'-xk',[ntiles.med1.errors],(cumsum(pred_freq.med1.errors)./N.med1.errors)*pred_prop_errors.med1,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([200 600])
    ylim([0 1])
    
    subplot(3,3,5)
    hold on
    plot([ntiles.med2.correct],(cumsum(obs_freq.med2.correct)./N.med2.correct)*obs_prop_correct.med2,'ok',[ntiles.med2.errors],(cumsum(obs_freq.med2.errors)./N.med2.errors)*obs_prop_errors.med2,'or','markersize',8)
    plot([ntiles.med2.correct],(cumsum(pred_freq.med2.correct)./N.med2.correct)*pred_prop_correct.med2,'-xk',[ntiles.med2.errors],(cumsum(pred_freq.med2.errors)./N.med2.errors)*pred_prop_errors.med2,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([200 400])
    ylim([0 1])
    
    subplot(3,3,6)
    hold on
    plot([ntiles.med3.correct],(cumsum(obs_freq.med3.correct)./N.med3.correct)*obs_prop_correct.med3,'ok',[ntiles.med3.errors],(cumsum(obs_freq.med3.errors)./N.med3.errors)*obs_prop_errors.med3,'or','markersize',8)
    plot([ntiles.med3.correct],(cumsum(pred_freq.med3.correct)./N.med3.correct)*pred_prop_correct.med3,'-xk',[ntiles.med3.errors],(cumsum(pred_freq.med3.errors)./N.med3.errors)*pred_prop_errors.med3,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([200 400])
    ylim([0 1])

    if save_output
        %eval(['print -dpdf ' outdir file '_P' mat2str(PopN) 'G' mat2str(GenLim) 'St' mat2str(StallLim) 'N' mat2str(nTrials) '.pdf'])
    end
end

end

%=================================
% Nonlinear constraints
% function [c,ceq] = nonlcon(params)
% 
% [A.slow A.med A.fast b v.slow v.med v.fast T0.slow T0.med T0.fast leakage] = disperse(params);
% 
% c(1) = A.slow - A.med;
% c(2) = A.med - A.fast;
% c(3) = v.slow - v.med;
% c(4) = v.med - v.fast;
% % c(5) = T0.slow - T0.med;
% % c(6) = T0.med - T0.fast;
% 
% ceq = [];
% 
% end
%=================================