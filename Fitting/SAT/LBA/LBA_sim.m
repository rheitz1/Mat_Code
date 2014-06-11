%This will fit the standard LBA model to a sample session of data or to the vincentized data.
%It will match quite closely to fits using the closed-form solutions.
% 12/16/11
% RPH

function [solution minval] = LBA_sim()
rand('seed',5150);
randn('seed',5150);
normrnd('seed',5150);


minimize = 0;
plotFlag = 1;
truncate_IQR = 1;
truncval = 1.5;


fit_Vincent = 0;

if fit_Vincent
    cd /Volumes/Dump/Analyses/SAT/Vincent_distributions/Med_only/
    load QS_Med
    
else
    %load('Q110910001-RH_SEARCH','Target_','Correct_','SAT_','Errors_','SRT')
    load('S052011001-RH_SEARCH','Target_','Correct_','SAT_','Errors_','SRT')
    
    made_missed = 0;
    include_med = 1;
    
%     Correct_ = evalin('caller','Correct_');
%     Errors_ = evalin('caller','Errors_');
%     SAT_ = evalin('caller','SAT_');
%     SRT = evalin('caller','SRT');
%     Target_ = evalin('caller','Target_');
    
    getTrials_SAT
    
    if ~made_missed
        
        if truncate_IQR
            disp(['Truncating ' mat2str(truncval) ' * IQR'])
            highcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) + truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
            lowcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) - truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
            highcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) + truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
            lowcut_fast = nanmedian(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared],1));
            
            
            %All correct trials w/ made deadlines
            slow_correct_made_dead = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
            fast_correct_made_dead_withCleared = intersect(fast_correct_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
            slow_errors_made_dead = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
            fast_errors_made_dead_withCleared = intersect(fast_errors_made_dead_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
            
            %keep track of total N for calculating AIC/BIC for MLE models
            N.all = numel([slow_correct_made_dead ; slow_errors_made_dead ; fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared]);
            if include_med
                highcut_med = nanmedian(SRT([med_correct ; med_errors],1)) + truncval * iqr(SRT([med_correct ; med_errors],1));
                lowcut_med = nanmedian(SRT([med_correct ; med_errors],1)) - truncval * iqr(SRT([med_correct ; med_errors],1));
                
                med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
                med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
                
                N.all = N.all + numel([med_correct ; med_errors]);
                
            end
        end
    else
        
        if truncate_IQR
            disp(['Truncating ' mat2str(truncval) ' * IQR'])
            highcut_slow = nanmedian(SRT([slow_correct_made_missed ; slow_errors_made_missed],1)) + truncval * iqr(SRT([slow_correct_made_missed ; slow_errors_made_missed],1));
            lowcut_slow = nanmedian(SRT([slow_correct_made_missed ; slow_errors_made_missed],1)) - truncval * iqr(SRT([slow_correct_made_missed ; slow_errors_made_missed],1));
            highcut_fast = nanmedian(SRT([fast_correct_made_missed_withCleared ; fast_errors_made_missed_withCleared],1)) + truncval * iqr(SRT([fast_correct_made_missed_withCleared ; fast_errors_made_missed_withCleared],1));
            lowcut_fast = nanmedian(SRT([fast_correct_made_missed_withCleared ; fast_errors_made_missed_withCleared],1)) - truncval * iqr(SRT([fast_correct_made_missed_withCleared ; fast_errors_made_missed_withCleared],1));
            
            
            %All correct trials w/ made deadlines
            slow_correct_made_dead = intersect(slow_correct_made_missed,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
            fast_correct_made_dead_withCleared = intersect(fast_correct_made_missed_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
            slow_errors_made_dead = intersect(slow_errors_made_missed,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
            fast_errors_made_dead_withCleared = intersect(fast_errors_made_missed_withCleared,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
            
            %keep track of total N for calculating AIC/BIC for MLE models
            N.all = numel([slow_correct_made_dead ; slow_errors_made_dead ; fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared]);
            if include_med
                highcut_med = nanmedian(SRT([med_correct ; med_errors],1)) + truncval * iqr(SRT([med_correct ; med_errors],1));
                lowcut_med = nanmedian(SRT([med_correct ; med_errors],1)) - truncval * iqr(SRT([med_correct ; med_errors],1));
                
                med_correct = intersect(med_correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
                med_errors = intersect(med_errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
                
                N.all = N.all + numel([med_correct ; med_errors]);
                
            end
        else
            slow_correct_made_dead = slow_correct_made_missed;
            slow_errors_made_dead = slow_errors_made_missed;
            fast_correct_made_dead_withCleared = fast_correct_made_missed_withCleared;
            fast_errors_made_dead_withCleared = fast_errors_made_missed_withCleared;
        end
    end
    
    
    trls.slow.correct = slow_correct_made_dead;
    trls.slow.errors = slow_errors_made_dead;
    trls.fast.correct = fast_correct_made_dead_withCleared;
    trls.fast.errors = fast_errors_made_dead_withCleared;
    
    if include_med
        trls.med.correct = med_correct;
        trls.med.errors = med_errors;
    end
    
    nts = [10 ; 30 ; 50 ; 70 ; 90 ; 100];
    
    
    ntiles.slow.correct = prctile(SRT(slow_correct_made_dead,1),nts);
    ntiles.slow.errors = prctile(SRT(slow_errors_made_dead,1),nts);
    ntiles.fast.correct = prctile(SRT(fast_correct_made_dead_withCleared,1),nts);
    ntiles.fast.errors = prctile(SRT(fast_errors_made_dead_withCleared,1),nts);
    
    if include_med
        ntiles.med.correct = prctile(SRT(med_correct,1),nts);
        ntiles.med.errors = prctile(SRT(med_errors,1),nts);
    end
    
    
    N.slow.correct = length(slow_correct_made_dead);
    N.slow.errors = length(slow_errors_made_dead);
    N.fast.correct = length(fast_correct_made_dead_withCleared);
    N.fast.errors = length(fast_errors_made_dead_withCleared);
    
    if include_med
        N.med.correct = length(med_correct);
        N.med.errors = length(med_errors);
    end
    
    
    nl = .1 * N.slow.correct;
    nh = .2 * N.slow.correct;
    obs_freq.slow.correct = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * N.slow.errors;
    nh = .2 * N.slow.errors;
    obs_freq.slow.errors = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * N.fast.correct;
    nh = .2 * N.fast.correct;
    obs_freq.fast.correct = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * N.fast.errors;
    nh = .2 * N.fast.errors;
    obs_freq.fast.errors = [nl nh nh nh nh nl];
    clear nl nh
    
    if include_med
        nl = .1 * N.med.correct;
        nh = .2 * N.med.correct;
        obs_freq.med.correct = [nl nh nh nh nh nl];
        clear nl nh
        
        nl = .1 * N.med.errors;
        nh = .2 * N.med.errors;
        obs_freq.med.errors = [nl nh nh nh nh nl];
        clear nl nh
    end
end


% X2 solution for the Vincentized data set
% A.slow = 98.0609;
% A.med = 85.8349;
% A.fast = 57.7991;
% 
% b.slow = 269.1780;
% b.med = 171.0823;
% b.fast = 97.3322;
% 
% v.slow = .5778;
% v.med = .5590;
% v.fast = .5583;
% 
% T0.slow = 211.7134;
% T0.med = 69.1139;
% T0.fast = 147.4472;
% 
% sd_rate = .1;
% nTrials = 5000;


% MLE solution parameters for example file: S052011001-RH_SEARCH
A.slow = 154.33;
A.med = 61.78;
A.fast = 57.67;

b.slow = 351.08;
b.med = 154.01;
b.fast = 135.38;

v.slow = .56;
v.med = .54;
v.fast = .53;


T0.slow = 55.41;
T0.med = 75.14;
T0.fast = 92.85;

sd_rate = .1;
nTrials = 5000;



% Random parameters for debugging
% A.slow = 133.2995;
% A.med = 109.8796;
% A.fast = 66.7031;
% 
% b.slow = 292.4083;
% b.med = 183.4705;
% b.fast = 114.8246;
% 
% v.slow = .63;
% v.med = .5826;
% v.fast = .5655;
% 
% T0.slow = 220;
% T0.med = 84.9465;
% T0.fast = 130.1262;
% 
% sd_rate = .1;
% nTrials = 5000;




%=============
% BOUNDS
%=============
lb.A = [0 0 0];
lb.b = [0 0 0];
lb.v = [.5 .5 .5];
lb.T0 = [50 50 50];
%lb.sd_rate = [.01];

ub.A = [500 500 500];
ub.b = [500 500 500];
ub.v = [1 1 1];
ub.T0 = [800 800 800];
%ub.sd_rate = [.5];

%=============
% Initial Range (for genetic algorithm)
% init.A = [A.slow-10 A.med-10 A.fast-10 ; A.slow+10 A.med+10 A.fast+10];
% init.b = [b.slow-10 b.med-10 b.fast-10 ; b.slow+10 b.med+10 b.fast+10];
% init.v = [v.slow-.01 v.med-.01 v.fast-.01 ; v.slow+.01 v.med+.01 v.fast+.01];
% init.T0 = [T0.slow-10 T0.med-10 T0.fast-10 ; T0.slow+10 T0.med+10 T0.fast+10];
% initRange = [init.A init.b init.v init.T0];

init.A = [lb.A ; ub.A];
init.b = [lb.b ; ub.b];
init.v = [lb.v ; ub.v];
init.T0 = [lb.T0 ; ub.T0];
%init.sd_rate = [lb.sd_rate ; ub.sd_rate];

initRange = [init.A init.b init.v init.T0 ];

param = [A.slow A.med A.fast b.slow b.med b.fast v.slow v.med v.fast T0.slow T0.med T0.fast];
lower = [lb.A lb.b lb.v lb.T0];
upper = [ub.A ub.b ub.v ub.T0];


if minimize
    
    options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    [solution minval exitflag output] = fminsearchbnd(@(param) LBA_sim_calc_X2(param,ntiles,trls,obs_freq),param,lower,upper,options);
    %[solution minval exitflag output] = fminsearch(@(param) LBA_sim_calc_X2(param,ntiles,trls,obs_freq),param,options);
    
%     
%     options = gaoptimset('PopulationSize',[ones(1,30)*30],...
%         'Generations',100,...
%         'PopInitRange',initRange,...
%         'Display','iter', ...
%         'UseParallel','always');
%         %'MutationFcn',{@mutationgaussian,1,1},...
%         %'HybridFcn',@fminsearch,...
%         %'CrossoverFraction',.1);
%     
%     [solution minval exitflag output] = ga(@(param) LBA_sim_calc_X2(param,ntiles,trls,obs_freq),numel(param),[],[],[],[],lower,upper,[],options);
%     
    [A.slow A.med A.fast b.slow b.med b.fast v.slow v.med v.fast T0.slow T0.med T0.fast] = disperse(solution);
else
    [A.slow A.med A.fast b.slow b.med b.fast v.slow v.med v.fast T0.slow T0.med T0.fast] = disperse(param);
end

if plotFlag
    figure
    rand('seed',5150);
    randn('seed',5150);
    normrnd('seed',5150);
    
    correct.slow(1:nTrials,1) = NaN;
    correct.fast(1:nTrials,1) = NaN;
    correct.med(1:nTrials,1) = NaN;
    
    rt.slow(1:nTrials,1) = NaN;
    rt.fast(1:nTrials,1) = NaN;
    rt.med(1:nTrials,1) = NaN;
    
    
    %% ACCURACY CONDITION
    
    
    %parfor n = 1:nTrials
    start1 = unifrnd(0,A.slow,nTrials,1);
    start2 = unifrnd(0,A.slow,nTrials,1);
    
    rate1 = normrnd(v.slow,sd_rate,nTrials,1);
    %rate1(find(rate1 >= 1)) = .999;
    
    %rate2 = normrnd(1-v.slow,sd_rate,nTrials,1);
    rate2 = 1-rate1;
    
    %rtA = b.slow./rate1 - start1./rate1 + 1;
    %rtB = b.slow./rate2 - start2./rate2 + 1;
    rtA = (b.slow - start1) ./rate1 + 1;
    rtB = (b.slow - start2) ./rate2 + 1;
    rtA(find(rtA < 0)) = 9999999;
    rtB(find(rtB < 0)) = 9999999;
    rts = min([rtA rtB],[],2);
    disp(['Removing ' mat2str(length(find([rtA ; rtB] == 9999999))) ' negative RTs'])
    cor = rtA < rtB;
    
    
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
    
    
    %rtA = b.fast./rate1 - start1./rate1 + 1;
    %rtB = b.fast./rate2 - start2./rate2 + 1;
    rtA = (b.fast - start1) ./rate1 + 1;
    rtB = (b.fast - start2) ./rate2 + 1;
    rtA(find(rtA < 0)) = 9999999;
    rtB(find(rtB < 0)) = 9999999;
    rts = min([rtA rtB],[],2);
    disp(['Removing ' mat2str(length(find([rtA ; rtB] == 9999999))) ' negative RTs'])
    cor = rtA < rtB;
    
    
    
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
    
    
    %rtA = b.med./rate1 - start1./rate1 + 1;
    %rtB = b.med./rate2 - start2./rate2 + 1;
    rtA = (b.med - start1) ./rate1 + 1;
    rtB = (b.med - start2) ./rate2 + 1;
    rtA(find(rtA < 0)) = 9999999;
    rtB(find(rtB < 0)) = 9999999;
    rts = min([rtA rtB],[],2);
    disp(['Removing ' mat2str(length(find([rtA ; rtB] == 9999999))) ' negative RTs'])
    cor = rtA < rtB;
    
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
    
    
    N.slow.correct = length(trls.slow.correct);
    N.slow.errors = length(trls.slow.errors);
    N.slow.all = N.slow.correct + N.slow.errors;
    N.fast.correct = length(trls.fast.correct);
    N.fast.errors = length(trls.fast.errors);
    N.fast.all = N.fast.correct + N.fast.errors;
    N.med.correct = length(trls.med.correct);
    N.med.errors = length(trls.med.errors);
    N.med.all = N.med.correct + N.med.errors;
    
    
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
    
    
    
    %X2 = sum( (all_obs - all_pred).^2 ./ (all_pred) ) + .00001;
    X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) )
    
    
    %
    %     disp('--------------')
    %     disp(mat2str(quant(param(1:3),.001)))
    %     disp(mat2str(quant(param(4:6),.001)))
    %     disp(mat2str(quant(param(7:9),.001)))
    %     disp(mat2str(quant(param(10:12),.001)))
    %     disp('--------------')
    
    
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
    end
end