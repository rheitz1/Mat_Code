function X2 = iLBA_sim_leaky_integrator_calc_X2_fixed_b_nTiles(params,ntiles,trls,obs_freq,seed,simBound)
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
    leakage] = disperse(params);
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



%================
% INTEGRATION
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
    
    
    % %generate starting point
    % act1.slow = start1.slow;
    % act1.med = start1.med;
    % act1.fast = start1.fast;
    %
    % act2.slow = start2.slow;
    % act2.med = start2.med;
    % act2.fast = start2.fast;
    %
    %
    % linear1.slow = cumsum([zeros(nTrials,1) repmat(rate1.slow,1,1000)],2) + repmat(start1.slow,1,1001);
    % linear1.med = cumsum([zeros(nTrials,1) repmat(rate1.med,1,1000)],2) + repmat(start1.med,1,1001);
    % linear1.fast = cumsum([zeros(nTrials,1) repmat(rate1.fast,1,1000)],2) + repmat(start1.fast,1,1001);
    %
    % linear2.slow = cumsum([zeros(nTrials,1) repmat(rate2.slow,1,1000)],2) + repmat(start2.slow,1,1001);
    % linear2.med = cumsum([zeros(nTrials,1) repmat(rate2.med,1,1000)],2) + repmat(start2.med,1,1001);
    % linear2.fast = cumsum([zeros(nTrials,1) repmat(rate2.fast,1,1000)],2) + repmat(start2.fast,1,1001);
    %
    %
    % for t = 2:1000
    %     act1.slow(:,t) = act1.slow(:,t-1) + linear1.slow(:,t) - ( leakage .* act1.slow(:,t-1));
    %     act1.med(:,t) = act1.med(:,t-1) + linear1.med(:,t) - ( leakage .* act1.med(:,t-1));
    %     act1.fast(:,t) = act1.fast(:,t-1) + linear1.fast(:,t) - ( leakage .* act1.fast(:,t-1));
    %
    %     act2.slow(:,t) = act2.slow(:,t-1) + linear2.slow(:,t) - ( leakage .* act2.slow(:,t-1));
    %     act2.med(:,t) = act2.med(:,t-1) + linear2.med(:,t) - ( leakage .* act2.med(:,t-1));
    %     act2.fast(:,t) = act2.fast(:,t-1) + linear2.fast(:,t) - ( leakage .* act2.fast(:,t-1));
    % end
    

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
%     correct.slow(find(rt.slow+T0.slow < simBound.slow)) = NaN;
%     correct.med(find(rt.med+T0.med > simBound.med)) = NaN;
%     correct.fast(find(rt.fast+T0.fast > simBound.fast)) = NaN;
%     
%     rt.slow(find(rt.slow+T0.slow < simBound.slow)) = NaN;
%     rt.med(find(rt.med+T0.med > simBound.med)) = NaN;
%     rt.fast(find(rt.fast+T0.fast > simBound.fast)) = NaN;

%     lRemove.slow = length(find(rt.slow+T0.slow < simBound.slow(1))) + length(find(rt.slow+T0.slow > simBound.slow(2)));
%     lRemove.med = length(find(rt.med+T0.med < simBound.med(1))) + length(find(rt.med+T0.med > simBound.med(2)));
%     lRemove.fast = length(find(rt.fast+T0.fast < simBound.fast(1))) + length(find(rt.fast+T0.fast > simBound.fast(2)));
%     disp(['Removing ' mat2str(lRemove.slow) ' ACCURATE trials ' mat2str(lRemove.slow / nTrials) '%'])
%     disp(['Removing ' mat2str(lRemove.med) ' NEUTRAL trials ' mat2str(lRemove.med / nTrials) '%'])
%     disp(['Removing ' mat2str(lRemove.fast) ' FAST trials ' mat2str(lRemove.fast / nTrials) '%'])
%     disp(['--------------------------------'])

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
%========================================
% END INTEGRATION




%to get total decision time, add decision time rt + nondecision time T0
rt.slow1 = rt.slow1 + T0.slow1 + 1;  %correct for diff operation earlier;
rt.slow2 = rt.slow2 + T0.slow2 + 1;  %correct for diff operation earlier;
rt.slow3 = rt.slow3 + T0.slow3 + 1;  %correct for diff operation earlier;

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



pred_pred_prop.slow1.correct(1) = length(find(rt.slow1(simTrls.slow1.correct) <= ntiles.slow1.correct(1))) / simN.slow1.all;
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


all_pred(find(isnan(all_pred))) = 0;


%X2 = sum( (all_obs - all_pred).^2 ./ (all_pred) ) + .00001;
X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );


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


if plotFlag
    subplot(3,3,1)
    hold on
    plot([ntiles.slow1.correct],(cumsum(obs_freq.slow1.correct)./N.slow1.correct)*obs_prop_correct.slow1,'ok',[ntiles.slow1.errors],(cumsum(obs_freq.slow1.errors)./N.slow1.errors)*obs_prop_errors.slow1,'or')
    plot([ntiles.slow1.correct],(cumsum(pred_freq.slow1.correct)./N.slow1.correct)*pred_prop_correct.slow1,'-xk',[ntiles.slow1.errors],(cumsum(pred_freq.slow1.errors)./N.slow1.errors)*pred_prop_errors.slow1,'-xr')
    xlim([400 900])
    ylim([0 1])
    
    subplot(3,3,2)
    hold on
    plot([ntiles.slow2.correct],(cumsum(obs_freq.slow2.correct)./N.slow2.correct)*obs_prop_correct.slow2,'ok',[ntiles.slow2.errors],(cumsum(obs_freq.slow2.errors)./N.slow2.errors)*obs_prop_errors.slow2,'or')
    plot([ntiles.slow2.correct],(cumsum(pred_freq.slow2.correct)./N.slow2.correct)*pred_prop_correct.slow2,'-xk',[ntiles.slow2.errors],(cumsum(pred_freq.slow2.errors)./N.slow2.errors)*pred_prop_errors.slow2,'-xr')
    xlim([400 700])
    ylim([0 1])
    
    subplot(3,3,3)
    hold on
    plot([ntiles.slow3.correct],(cumsum(obs_freq.slow3.correct)./N.slow3.correct)*obs_prop_correct.slow3,'ok',[ntiles.slow3.errors],(cumsum(obs_freq.slow3.errors)./N.slow3.errors)*obs_prop_errors.slow3,'or')
    plot([ntiles.slow3.correct],(cumsum(pred_freq.slow3.correct)./N.slow3.correct)*pred_prop_correct.slow3,'-xk',[ntiles.slow3.errors],(cumsum(pred_freq.slow3.errors)./N.slow3.errors)*pred_prop_errors.slow3,'-xr')
    xlim([400 700])
    ylim([0 1])
    
    subplot(3,3,7)
    hold on
    plot([ntiles.fast1.correct],(cumsum(obs_freq.fast1.correct)./N.fast1.correct)*obs_prop_correct.fast1,'ok',[ntiles.fast1.errors],(cumsum(obs_freq.fast1.errors)./N.fast1.errors)*obs_prop_errors.fast1,'or')
    plot([ntiles.fast1.correct],(cumsum(pred_freq.fast1.correct)./N.fast1.correct)*pred_prop_correct.fast1,'-xk',[ntiles.fast1.errors],(cumsum(pred_freq.fast1.errors)./N.fast1.errors)*pred_prop_errors.fast1,'-xr')
    xlim([200 400])
    ylim([0 1])
    
    subplot(3,3,8)
    hold on
    plot([ntiles.fast2.correct],(cumsum(obs_freq.fast2.correct)./N.fast2.correct)*obs_prop_correct.fast2,'ok',[ntiles.fast2.errors],(cumsum(obs_freq.fast2.errors)./N.fast2.errors)*obs_prop_errors.fast2,'or')
    plot([ntiles.fast2.correct],(cumsum(pred_freq.fast2.correct)./N.fast2.correct)*pred_prop_correct.fast2,'-xk',[ntiles.fast2.errors],(cumsum(pred_freq.fast2.errors)./N.fast2.errors)*pred_prop_errors.fast2,'-xr')
    xlim([200 400])
    ylim([0 1])
    
    subplot(3,3,9)
    hold on
    plot([ntiles.fast3.correct],(cumsum(obs_freq.fast3.correct)./N.fast3.correct)*obs_prop_correct.fast3,'ok',[ntiles.fast3.errors],(cumsum(obs_freq.fast3.errors)./N.fast3.errors)*obs_prop_errors.fast3,'or')
    plot([ntiles.fast3.correct],(cumsum(pred_freq.fast3.correct)./N.fast3.correct)*pred_prop_correct.fast3,'-xk',[ntiles.fast3.errors],(cumsum(pred_freq.fast3.errors)./N.fast3.errors)*pred_prop_errors.fast3,'-xr')
    xlim([200 400])
    ylim([0 1])
    
    
    subplot(3,3,4)
    hold on
    plot([ntiles.med1.correct],(cumsum(obs_freq.med1.correct)./N.med1.correct)*obs_prop_correct.med1,'ok',[ntiles.med1.errors],(cumsum(obs_freq.med1.errors)./N.med1.errors)*obs_prop_errors.med1,'or')
    plot([ntiles.med1.correct],(cumsum(pred_freq.med1.correct)./N.med1.correct)*pred_prop_correct.med1,'-xk',[ntiles.med1.errors],(cumsum(pred_freq.med1.errors)./N.med1.errors)*pred_prop_errors.med1,'-xr')
    xlim([200 600])
    ylim([0 1])
    
    
    subplot(3,3,5)
    hold on
    plot([ntiles.med2.correct],(cumsum(obs_freq.med2.correct)./N.med2.correct)*obs_prop_correct.med2,'ok',[ntiles.med2.errors],(cumsum(obs_freq.med2.errors)./N.med2.errors)*obs_prop_errors.med2,'or')
    plot([ntiles.med2.correct],(cumsum(pred_freq.med2.correct)./N.med2.correct)*pred_prop_correct.med2,'-xk',[ntiles.med2.errors],(cumsum(pred_freq.med2.errors)./N.med2.errors)*pred_prop_errors.med2,'-xr')
    xlim([200 400])
    ylim([0 1])
    
    
    subplot(3,3,6)
    hold on
    plot([ntiles.med3.correct],(cumsum(obs_freq.med3.correct)./N.med3.correct)*obs_prop_correct.med3,'ok',[ntiles.med3.errors],(cumsum(obs_freq.med3.errors)./N.med3.errors)*obs_prop_errors.med3,'or')
    plot([ntiles.med3.correct],(cumsum(pred_freq.med3.correct)./N.med3.correct)*pred_prop_correct.med3,'-xk',[ntiles.med3.errors],(cumsum(pred_freq.med3.errors)./N.med3.errors)*pred_prop_errors.med3,'-xr')
    xlim([200 400])
    ylim([0 1])

    %     disp('--------------')
    %     disp(mat2str(quant(params(1:3),.001)))
    %     disp(mat2str(quant(params(4),.001)))
    %     disp(mat2str(quant(params(5:7),.001)))
    %     disp(mat2str(quant(params(8:10),.001)))
    %     disp('--------------')
    
    pause(.001)
    subplot(3,3,1)
    cla
    
    subplot(3,3,2)
    cla
    
    subplot(3,3,3)
    cla
    
    subplot(3,3,4)
    cla
    
    subplot(335)
    cla
    
    subplot(336)
    cla
    
    subplot(337)
    cla
    
    subplot(338)
    cla
    
    subplot(339)
    cla
end