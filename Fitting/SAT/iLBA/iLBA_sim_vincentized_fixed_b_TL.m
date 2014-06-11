%This runs the integrated LBA (iLBA) on vincentized data with SOME PARAMETERS SHARED
% 12/16/11
% RPH

function [solution minval] = iLBA_sim_vincentized_fixed_b_TL(file,PopN,GenLim,nTrials,seed,sd_rate,start_param,minimizer)

save_output = 0;
minimize = 1;
plotFlag = 1;
truncSim = 1;

if matlabpool('size') < 12; matlabpool(12); end

%outdir = '/volumes/Dump/Analyses/SAT/Models/iLBA_X2/fixed_b/';
%outdir = '//scratch/heitzrp/Output/iLBA/fixed_b/';

if nargin < 8; minimizer = 'ga'; end
if nargin < 6; sd_rate = .25; end
if nargin < 5; seed = 100; end
if nargin < 4; nTrials = 500; end
if nargin < 3; GenLim = 500; end
if nargin < 2; PopN = 5; end
if nargin < 1; file = 'Q_Med'; end

rand('seed',seed);
randn('seed',seed);
normrnd('seed',seed);

load('/volumes/Dump/S_vincentized_TL.mat')

%Boundaries for simulated RTs based on the deadlines used.  Note that we are fitting MADE deadlines here,
%so we want the model to exclude RTs outside of this range.



%NOTE: THIS SEEMED TO MAKE MORE SENSE FOR THE QS COMBINED DATA SET!!!
if truncSim
    simBound.ss2 = 800;
    simBound.ss4 = 800;
    simBound.ss8 = 800;
end



%=============
% BOUNDS
%=============
lb.A = [5 5 5];
lb.b = [20];
lb.v = [.51 .51 .51];
lb.T0 = [5 5 5];
lb.leakage = [.005];
%lb.sd_rate = .1;

ub.A = [500 500 500];
ub.b = [400];
ub.v = [.95 .95 .95];
ub.T0 = [600 600 600];
ub.leakage = [.05];
%ub.sd_rate = .4;

sd_rate = .25;

if nargin < 7
    A.ss2 = 200;
    A.ss4 = 200;
    A.ss8 = 200;
    
    b = 100;
    
    v.ss2 = .8;
    v.ss4 = .8;
    v.ss8 = .8;
    
    T0.ss2 = 80;
    T0.ss4 = 80;
    T0.ss8 = 80;
    
    leakage = .015;
    
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
    [A.ss2 A.ss4 A.ss8 b v.ss2 v.ss4 v.ss8 T0.ss2 T0.ss4 T0.ss8 leakage] = disperse(start_param);
    
    %=======================================
    % INITIAL RANGE (for genetic algorithm)
    %=======================================
    init.A = [A.ss2-10 A.ss4-10 A.ss8-10 ; A.ss2+10 A.ss4+10 A.ss8+10];
    init.b = [b-10 ; b+10];
    init.v = [v.ss2-.01 v.ss4-.01 v.ss8-.01 ; v.ss2+.01 v.ss4+.01 v.ss8+.01];
    init.T0 = [T0.ss2-10 T0.ss4-10 T0.ss8-10 ; T0.ss2+10 T0.ss4+10 T0.ss8+10];
    init.leakage = [leakage-.05 ; leakage+.05];
    %init.sd_rate = [sd_rate-.05 ; sd_rate+.05];
end


initRange = [init.A init.b init.v init.T0 init.leakage];


param = [A.ss2 A.ss4 A.ss8 b v.ss2 v.ss4 v.ss8 T0.ss2 T0.ss4 T0.ss8 leakage];
lower = [lb.A lb.b lb.v lb.T0 lb.leakage];
upper = [ub.A ub.b ub.v ub.T0 ub.leakage];

start_param = param;


if minimize
    
    if strmatch(minimizer,'simplex')
        options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
        %[solution minval exitflag output] = fminsearch(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_TL(param,ntiles,trls,obs_freq,seed,simBound),param,options);
        [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_TL(param,ntiles,trls,obs_freq,seed,simBound),param,lower,upper,options);
        
        %options = optimset('MaxIter',100000,'MaxFunEvals',100000,'TolFun',1e-20,'TolCon',1e-20);
        %[solution minval exitflag output] = fmincon(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_TL(param,ntiles,trls,obs_freq,seed,simBound),param,[],[],[],[],lower,upper,@nonlcon,options);
        
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
        
        [solution minval exitflag output] = ga(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_TL(param,ntiles,trls,obs_freq,seed,simBound),numel(param),[],[],[],[],lower,upper,[],options);
        
        param = solution;
        options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
        [solution minval exitflag output] = fminsearchbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_TL(param,ntiles,trls,obs_freq,seed,simBound),param,lower,upper,options);
    elseif strmatch(minimizer,'sa')
        options = saoptimset;
        
        [solution minval exitflag output] = simulannealbnd(@(param) iLBA_sim_leaky_integrator_calc_X2_fixed_b_TL(param,ntiles,trls,obs_freq,seed,simBound),param,lower,upper,options);
        
    end
    
else
    solution = param;
end


if plotFlag
     figure
    
    rand('seed',seed);
    randn('seed',seed);
    normrnd('seed',seed);
    
    ss2.correct = trls.ss2.correct;
    ss2.errors = trls.ss2.errors;
    ss4.correct = trls.ss4.correct;
    ss4.errors = trls.ss4.errors;
    ss8.correct = trls.ss8.correct;
    ss8.errors = trls.ss8.errors;
    
    [A.ss2 A.ss4 A.ss8 b v.ss2 v.ss4 v.ss8 T0.ss2 T0.ss4 T0.ss8 leakage] = disperse(solution);
    b = b * 100;
    
    
    
    correct.ss2(1:nTrials,1) = NaN;
    correct.ss4(1:nTrials,1) = NaN;
    correct.ss8(1:nTrials,1) = NaN;
    
    rt.ss2(1:nTrials,1) = NaN;
    rt.ss4(1:nTrials,1) = NaN;
    rt.ss8(1:nTrials,1) = NaN;
    
    
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

%     
%     % REMOVE RTs OUTSIDE OF BOUNDS (EQUIVALENT TO RESPONSE DEADLINES)
    if truncSim
        disp(['Removing ' mat2str(length(find(rt.ss2+T0.ss2 > simBound.ss2))) ' SLOW trials']);
        disp(['Removing ' mat2str(length(find(rt.ss4+T0.ss4 > simBound.ss4))) ' MED trials']);
        disp(['Removing ' mat2str(length(find(rt.ss8+T0.ss8 > simBound.ss8))) ' FAST trials']);
        
        correct.slow(find(rt.ss2+T0.ss2 > simBound.ss2)) = NaN;
        correct.med(find(rt.ss4+T0.ss4 > simBound.ss4)) = NaN;
        correct.fast(find(rt.ss8+T0.ss8 > simBound.ss8)) = NaN;
        
        
        rt.ss2(find(rt.ss2+T0.ss2 > simBound.ss2)) = NaN;
        rt.ss4(find(rt.ss4+T0.ss4 > simBound.ss4)) = NaN;
        rt.ss8(find(rt.ss8+T0.ss8 > simBound.ss8)) = NaN;
    end
    
    
    %to get total decision time, add decision time rt + nondecision time T0
    rt.ss2 = rt.ss2 + T0.ss2 + 1; %correct for diff operation earlier;
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
    
    subplot(2,2,1)
    hold on
    plot([ntiles.ss2.correct],(cumsum(obs_freq.ss2.correct)./N.ss2.correct)*obs_prop_correct.ss2,'ok',[ntiles.ss2.errors],(cumsum(obs_freq.ss2.errors)./N.ss2.errors)*obs_prop_errors.ss2,'or','markersize',8)
    plot([ntiles.ss2.correct],(cumsum(pred_freq.ss2.correct)./N.ss2.correct)*pred_prop_correct.ss2,'-xk',[ntiles.ss2.errors],(cumsum(pred_freq.ss2.errors)./N.ss2.errors)*pred_prop_errors.ss2,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([100 600])
    ylim([0 1])
    
    subplot(2,2,3)
    hold on
    plot([ntiles.ss8.correct],(cumsum(obs_freq.ss8.correct)./N.ss8.correct)*obs_prop_correct.ss8,'ok',[ntiles.ss8.errors],(cumsum(obs_freq.ss8.errors)./N.ss8.errors)*obs_prop_errors.ss8,'or','markersize',8)
    plot([ntiles.ss8.correct],(cumsum(pred_freq.ss8.correct)./N.ss8.correct)*pred_prop_correct.ss8,'-xk',[ntiles.ss8.errors],(cumsum(pred_freq.ss8.errors)./N.ss8.errors)*pred_prop_errors.ss8,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([100 600])
    ylim([0 1])
    
    subplot(2,2,2)
    hold on
    plot([ntiles.ss4.correct],(cumsum(obs_freq.ss4.correct)./N.ss4.correct)*obs_prop_correct.ss4,'ok',[ntiles.ss4.errors],(cumsum(obs_freq.ss4.errors)./N.ss4.errors)*obs_prop_errors.ss4,'or','markersize',8)
    plot([ntiles.ss4.correct],(cumsum(pred_freq.ss4.correct)./N.ss4.correct)*pred_prop_correct.ss4,'-xk',[ntiles.ss4.errors],(cumsum(pred_freq.ss4.errors)./N.ss4.errors)*pred_prop_errors.ss4,'-xr','markersize',10)
    set(gca,'xminortick','on')
    xlim([100 600])
    ylim([0 1])
    
    
    if save_output
        %eval(['print -dpdf ' outdir file '_P' mat2str(PopN) 'G' mat2str(GenLim) 'St' mat2str(StallLim) 'N' mat2str(nTrials) '.pdf'])
    end
end
 
end
 
%=================================
% Nonlinear constraints
function [c,ceq] = nonlcon(params)
 
[A.ss2 A.ss4 A.ss8 b v.ss2 v.ss4 v.ss8 T0.ss2 T0.ss4 T0.ss8 leakage] = disperse(params);
 
c(1) = A.ss2 - A.ss4;
c(2) = A.ss4 - A.ss8;
c(3) = v.ss2 - v.ss4;
c(4) = v.ss4 - v.ss8;
% c(5) = T0.ss2 - T0.ss4;
% c(6) = T0.ss4 - T0.ss8;
 
ceq = [];
 
end
%=================================
