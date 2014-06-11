%Fit DDM

function [solution,fitStat,CDF] = fitDDM_SAT(FreeFix,plotFlag)


rand('seed',5150);
randn('seed',5150);

Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
Target_ = evalin('caller','Target_');
SAT_ = evalin('caller','SAT_');
SRT = evalin('caller','SRT');

%Starting Values
% a = .16; %boundary separation
% Ter = .1; %mean non-decisional component time
% eta = .08; %standard deviation of normal drift distribution
% z = a/2; %mean starting point
% sZ = .04; %spread of starting point distribution
% st = .04; %spread of non-decisional component time distribution
% v = .2; %mean drift rate

use_X2 = 1;
use_MLE = 0;

minimize = 1;
truncate_IQR = 1;
truncval = 1.5;
include_med = 0; %if set to 0, fits only fast and slow conditions.  Fits will be different when MED included


if include_med
    vmCond = 3;
else
    disp('SKIPPING NEUTRAL CONDITION...')
    vmCond = 2;
end

fr = vmCond;
fx = 1;
%SET PARAMETERS TO FIXED OR FREE, 1 FOR Fixed, fr FOR NUMBER OF CONDITIONS
%FREE TO VARY ACROSS FOR THAT PARAMETER
% FORMAT:   A  b  v T0  %%% s assumed to always be fixed
if nargin < 2; plotFlag = 1; end
if nargin < 1; FreeFix = [fr fr fr fr fr fr fr]; end%set all parameters free


%Set Initial Parameters
if 1 %if statement just for code collapsing
    %starting parameters
    if FreeFix(1) == 3
        a(1) = .0576; a(2) = .0535; a(3) = .0368;
    elseif FreeFix(1) == 2
        a(1) = .0363; a(2) = .029;
    else
        a(1:FreeFix(1)) = .0853;
    end
    
    if FreeFix(2) == 3
        Ter(1) = .5268; Ter(2) = .2204; Ter(3) = .2275;
    elseif FreeFix(2) == 2
        Ter(1) = .5890; Ter(2) = .2254;
    else
        Ter(1:FreeFix(2)) = .5303;
    end
    
    if FreeFix(3) == 3
        eta(1) = .0238; eta(2) = .0402; eta(3) = .0568;
    elseif FreeFix(3) == 2
        eta(1) = .0016; eta(2) = .0377;
    else
        eta(1:FreeFix(3)) = .0646;
    end
    
    if FreeFix(4) == 3
        z(1) = .0272; z(2) = .0302; z(3) = .0218;
    elseif FreeFix(4) == 2
        z(1) = .0293; z(2) = .0204;
    else
        z(1:FreeFix(4)) = .0562;
    end
    
    if FreeFix(5) == 3
        sZ(1) = .0277; sZ(2) = .0018; sZ(3) = .0025;
    elseif FreeFix(5) == 2
        sZ(1) = .0007; sZ(2) = .0056;
    else
        sZ(1:FreeFix(5)) = .03;
    end
    
    if FreeFix(6) == 3
        st(1) = .2301; st(2) = .0950; st(3) = .1035;
    elseif FreeFix(6) == 2
        st(1) = .1887; st(2) = .0578;
    else
        st(1:FreeFix(6)) = .1520;
    end
    
    if FreeFix(7) == 3
        v(1) = .3939; v(2) = .1621; v(3) = .1465;
    elseif FreeFix(7) == 2
        v(1) = .2414; v(2) = .1405;
    else
        v(1:FreeFix(7)) = .2114;
    end
end


lb.a(1:FreeFix(1)) = .001;
lb.Ter(1:FreeFix(2)) = .05;
lb.eta(1:FreeFix(3)) = .001;
lb.z(1:FreeFix(4)) = .001;
lb.sZ(1:FreeFix(5)) = .001;
lb.st(1:FreeFix(6)) = .001;
lb.v(1:FreeFix(7)) = .01;

ub.a(1:FreeFix(1)) = .5;
ub.Ter(1:FreeFix(2)) = .7;
ub.eta(1:FreeFix(3)) = 1;
ub.z(1:FreeFix(4)) = .5;
ub.sZ(1:FreeFix(5)) = .5;
ub.st(1:FreeFix(6)) = .5;
ub.v(1:FreeFix(7)) = .9;

init.a = [a - .01 ; a + .01];
init.Ter = [Ter-0.1 ; Ter+0.1];
init.eta = [eta - 0.01 ; eta + 0.01];
init.z = [z - 0.01 ; z + 0.01];
init.sZ = [sZ - .005 ; sZ + .005];
init.st = [st - .03 ; st + .03];
init.v = [v - .1 ; v + .1];

initRange = [init.a init.Ter init.eta init.z init.sZ init.st init.v];


getTrials_SAT

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



param = [a,Ter,eta,z,sZ,st,v];

lower = [lb.a,lb.Ter,lb.eta,lb.z,lb.sZ,lb.st,lb.v];
upper = [ub.a,ub.Ter,ub.eta,ub.z,ub.sZ,ub.st,ub.v];

srt = SRT ./ 1000;


%get quantiles for X2 fitting
if use_X2
    nts = [10 ; 30 ; 50 ; 70 ; 90 ; 100];
    ntiles.slow.correct = prctile(srt(slow_correct_made_dead,1),nts);
    ntiles.slow.errors = prctile(srt(slow_errors_made_dead,1),nts);
    
    ntiles.fast.correct = prctile(srt(fast_correct_made_dead_withCleared,1),nts);
    ntiles.fast.errors = prctile(srt(fast_errors_made_dead_withCleared,1),nts);
    
    nl = .1 * length(slow_correct_made_dead);
    nh = .2 * length(slow_correct_made_dead);
    obs_freq.slow.correct = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(slow_errors_made_dead);
    nh = .2 * length(slow_errors_made_dead);
    obs_freq.slow.errors = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(fast_correct_made_dead_withCleared);
    nh = .2 * length(fast_correct_made_dead_withCleared);
    obs_freq.fast.correct = [nl nh nh nh nh nl];
    clear nl nh
    
    nl = .1 * length(fast_errors_made_dead_withCleared);
    nh = .2 * length(fast_errors_made_dead_withCleared);
    obs_freq.fast.errors = [nl nh nh nh nh nl];
    clear nl nh
    
    if include_med
        ntiles.med.correct = prctile(srt(med_correct,1),nts);
        ntiles.med.errors = prctile(srt(med_errors,1),nts);
        
        nl = .1 * length(med_correct);
        nh = .2 * length(med_correct);
        obs_freq.med.correct = [nl nh nh nh nh nl];
        clear nl nh
        
        
        nl = .1 * length(med_errors);
        nh = .2 * length(med_errors);
        obs_freq.med.errors = [nl nh nh nh nh nl];
        clear nl nh
    end
    
end

%save trial vectors to struct for easier passing
trls.slow.correct = slow_correct_made_dead;
trls.slow.errors = slow_errors_made_dead;
trls.fast.correct = fast_correct_made_dead_withCleared;
trls.fast.errors = fast_errors_made_dead_withCleared;

if include_med
    trls.med.correct = med_correct;
    trls.med.errors = med_errors;
end


%========
% OR just use the already-vincentized version for X^2:

%load QS_Med
% ntiles.slow.correct = ntiles.slow.correct ./ 1000;
% ntiles.slow.errors = ntiles.slow.errors ./ 1000;
% ntiles.med.correct = ntiles.med.correct ./ 1000;
% ntiles.med.errors = ntiles.med.errors ./ 1000;
% ntiles.fast.correct = ntiles.fast.correct ./ 1000;
% ntiles.fast.errors = ntiles.fast.errors ./ 1000;
%========

initRange = [lb.a lb.Ter lb.eta lb.z lb.sZ lb.st lb.v ; ub.a ub.Ter ub.eta ub.z ub.sZ ub.st ub.v];

if minimize
    
    options = optimset('MaxIter', 10000000,'MaxFunEvals', 10000000);
    
    if use_X2
        %[solution minval exitflag output] = fminsearch(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),param,options);
        [solution minval exitflag output] = fminsearchbnd(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),param,lower,upper,options);
        
%         
%         options = gaoptimset('PopulationSize',[ones(1,10)*30],...
%             'Generations',500,...
%             'PopInitRange',initRange,...
%             'Display','iter', ...
%             'UseParallel','always');
            %    'HybridFcn',@fminsearch);
        %             'StallGenLimit',10, ...
        %             'TolCon',1e-15, ...
        %             'TolFun',1e-15);
        
        %'MutationFcn',{@mutationgaussian,1,1}, ...
        
        
        %[solution minval exitflag output] = ga(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),numel(param),[],[],[],[],lower,upper,[],options);
        
        param = solution;
        
        
        %Now re-run using solution from GA as starting parameters in simplex:
        %options = optimset('MaxIter', 10000000,'MaxFunEvals', 10000000);
        %[solution minval exitflag output] = fminsearchbnd(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),param,lower,upper,options);
% %         
        
    elseif use_MLE
        %[solution minval exitflag output] = fminsearch(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),param,options);
        [solution minval exitflag output] = fminsearchbnd(@(param) fitDDM_SAT_calcLL(param,srt,trls),param,lower,upper,options);
        
        %         options = gaoptimset('PopulationSize',[ones(1,5)*30],...
        %             'Display','iter', ...
        %             'UseParallel','always', ...
        %             'PopInitRange',initRange);
        %         [solution minval exitflag output] = ga(@(param) fitDDM_SAT_calcLL(param,srt,trls),numel(param),[],[],[],[],lower,upper,[],options);
        %
        %
    end
    
else
    disp('NOT MINIMIZING: USING STARTING VALUES TO FIT')
    param = [a,Ter,eta,z,sZ,st,v];
    
    if use_X2
        minval = fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq);
    elseif use_MLE
        minval = fitDDM_SAT_calcLL(param,srt,trls);
    end
    
    solution = param; %since we are not minimizing, take starting values as solution.
end


%Final Parameters
a = solution(1:length(a));
Ter = solution(length(a)+1:length(a)+length(Ter));
eta = solution(length(a)+length(Ter)+1:length(a)+length(Ter)+length(eta));
z = solution(length(a)+length(Ter)+length(eta)+1:length(a)+length(Ter)+length(eta)+length(z));
sZ = solution(length(a)+length(Ter)+length(eta)+length(z)+1:length(a)+length(Ter)+length(eta)+length(z)+length(sZ));
st = solution(length(a)+length(Ter)+length(eta)+length(z)+length(sZ)+1:length(a)+length(Ter)+length(eta)+length(z)+length(sZ)+length(st));
v = solution(length(a)+length(Ter)+length(eta)+length(z)+length(sZ)+length(v)+1:length(solution));


% CDF.slow = getDefectiveCDF(slow_correct_made_dead,slow_errors_made_dead,srt);
% CDF.fast = getDefectiveCDF(fast_correct_made_dead_withCleared,fast_errors_made_dead_withCleared,srt);
%
% if include_med; CDF.med = getDefectiveCDF(med_correct,med_errors,srt); end


if use_MLE
    fitStat = minval
    
    n_free = numel(param);
    n_obs = N.all;
    [AIC BIC] = aicbic(-1*minval,n_free,n_obs);
elseif use_X2
    fitStat = minval
end



%PLOTTING
if plotFlag
    %Set up new param structs based on solution
    if include_med
        if FreeFix(1) == 1
            params.slow(1) = a;
            params.med(1) = a;
            params.fast(1) = a;
        elseif FreeFix(1) == 3
            params.slow(1) = a(1);
            params.med(1) = a(2);
            params.fast(1) = a(3);
        end
        
        if FreeFix(2) == 1
            params.slow(2) = Ter;
            params.med(2) = Ter;
            params.fast(2) = Ter;
        elseif FreeFix(2) == 3
            params.slow(2) = Ter(1);
            params.med(2) = Ter(2);
            params.fast(2) = Ter(3);
        end
        
        if FreeFix(3) == 1
            params.slow(3) = eta;
            params.med(3) = eta;
            params.fast(3) = eta;
        elseif FreeFix(3) == 3
            params.slow(3) = eta(1);
            params.med(3) = eta(2);
            params.fast(3) = eta(3);
        end
        
        if FreeFix(4) == 1
            params.slow(4) = z;
            params.med(4) = z;
            params.fast(4) = z;
        elseif FreeFix(4) == 3
            params.slow(4) = z(1);
            params.med(4) = z(2);
            params.fast(4) = z(3);
        end
        
        if FreeFix(5) == 1
            params.slow(5) = sZ;
            params.med(5) = sZ;
            params.fast(5) = sZ;
        elseif FreeFix(5) == 3
            params.slow(5) = sZ(1);
            params.med(5) = sZ(2);
            params.fast(5) = sZ(3);
        end
        
        if FreeFix(6) == 1
            params.slow(6) = st;
            params.med(6) = st;
            params.fast(6) = st;
        elseif FreeFix(6) == 3
            params.slow(6) = st(1);
            params.med(6) = st(2);
            params.fast(6) = st(3);
        end
        
        if FreeFix(7) == 1
            params.slow(7) = v;
            params.med(7) = v;
            params.fast(7) = v;
        elseif FreeFix(7) == 3
            params.slow(7) = v(1);
            params.med(7) = v(2);
            params.fast(7) = v(3);
        end
        
    else %not include med (Neutral) condition
        if FreeFix(1) == 1
            params.slow(1) = a;
            params.fast(1) = a;
        elseif FreeFix(1) == 2
            params.slow(1) = a(1);
            params.fast(1) = a(2);
        end
        
        if FreeFix(2) == 1
            params.slow(2) = Ter;
            params.fast(2) = Ter;
        elseif FreeFix(2) == 2
            params.slow(2) = Ter(1);
            params.fast(2) = Ter(2);
        end
        
        if FreeFix(3) == 1
            params.slow(3) = eta;
            params.fast(3) = eta;
        elseif FreeFix(3) == 2
            params.slow(3) = eta(1);
            params.fast(3) = eta(2);
        end
        
        if FreeFix(4) == 1
            params.slow(4) = z;
            params.fast(4) = z;
        elseif FreeFix(4) == 2
            params.slow(4) = z(1);
            params.fast(4) = z(2);
        end
        
        if FreeFix(5) == 1
            params.slow(5) = sZ;
            params.fast(5) = sZ;
        elseif FreeFix(5) == 2
            params.slow(5) = sZ(1);
            params.fast(5) = sZ(2);
        end
        
        if FreeFix(6) == 1
            params.slow(6) = st;
            params.fast(6) = st;
        elseif FreeFix(6) == 2
            params.slow(6) = st(1);
            params.fast(6) = st(2);
        end
        
        if FreeFix(7) == 1
            params.slow(7) = v;
            params.fast(7) = v;
        elseif FreeFix(7) == 2
            params.slow(7) = v(1);
            params.fast(7) = v(2);
        end
        
    end
    
    if include_med
        
        if use_X2
            N.slow = sum(obs_freq.slow.correct) + sum(obs_freq.slow.errors);
            N.med = sum(obs_freq.med.correct) + sum(obs_freq.med.errors);
            N.fast = sum(obs_freq.fast.correct) + sum(obs_freq.fast.errors);
            
            
            
            pred_freq.slow.correct(1) = N.slow * CDFDif(ntiles.slow.correct(1),1,params.slow);
            pred_freq.slow.correct(2) = N.slow * (CDFDif(ntiles.slow.correct(2),1,params.slow) - CDFDif(ntiles.slow.correct(1),1,params.slow));
            pred_freq.slow.correct(3) = N.slow * (CDFDif(ntiles.slow.correct(3),1,params.slow) - CDFDif(ntiles.slow.correct(2),1,params.slow));
            pred_freq.slow.correct(4) = N.slow * (CDFDif(ntiles.slow.correct(4),1,params.slow) - CDFDif(ntiles.slow.correct(3),1,params.slow));
            pred_freq.slow.correct(5) = N.slow * (CDFDif(ntiles.slow.correct(5),1,params.slow) - CDFDif(ntiles.slow.correct(4),1,params.slow));
            pred_freq.slow.correct(6) = N.slow * (CDFDif(ntiles.slow.correct(6),1,params.slow) - CDFDif(ntiles.slow.correct(5),1,params.slow));
            
            
            pred_freq.slow.errors(1) = N.slow * CDFDif(ntiles.slow.errors(1),0,params.slow);
            pred_freq.slow.errors(2) = N.slow * (CDFDif(ntiles.slow.errors(2),0,params.slow) - CDFDif(ntiles.slow.errors(1),0,params.slow));
            pred_freq.slow.errors(3) = N.slow * (CDFDif(ntiles.slow.errors(3),0,params.slow) - CDFDif(ntiles.slow.errors(2),0,params.slow));
            pred_freq.slow.errors(4) = N.slow * (CDFDif(ntiles.slow.errors(4),0,params.slow) - CDFDif(ntiles.slow.errors(3),0,params.slow));
            pred_freq.slow.errors(5) = N.slow * (CDFDif(ntiles.slow.errors(5),0,params.slow) - CDFDif(ntiles.slow.errors(4),0,params.slow));
            pred_freq.slow.errors(6) = N.slow * (CDFDif(ntiles.slow.errors(6),0,params.slow) - CDFDif(ntiles.slow.errors(5),0,params.slow));
            
            if include_med
                pred_freq.med.correct(1) = N.med * CDFDif(ntiles.med.correct(1),1,params.med);
                pred_freq.med.correct(2) = N.med * (CDFDif(ntiles.med.correct(2),1,params.med) - CDFDif(ntiles.med.correct(1),1,params.med));
                pred_freq.med.correct(3) = N.med * (CDFDif(ntiles.med.correct(3),1,params.med) - CDFDif(ntiles.med.correct(2),1,params.med));
                pred_freq.med.correct(4) = N.med * (CDFDif(ntiles.med.correct(4),1,params.med) - CDFDif(ntiles.med.correct(3),1,params.med));
                pred_freq.med.correct(5) = N.med * (CDFDif(ntiles.med.correct(5),1,params.med) - CDFDif(ntiles.med.correct(4),1,params.med));
                pred_freq.med.correct(6) = N.med * (CDFDif(ntiles.med.correct(6),1,params.med) - CDFDif(ntiles.med.correct(5),1,params.med));
                
                
                
                pred_freq.med.errors(1) = N.med * CDFDif(ntiles.med.errors(1),0,params.med);
                pred_freq.med.errors(2) = N.med * (CDFDif(ntiles.med.errors(2),0,params.med) - CDFDif(ntiles.med.errors(1),0,params.med));
                pred_freq.med.errors(3) = N.med * (CDFDif(ntiles.med.errors(3),0,params.med) - CDFDif(ntiles.med.errors(2),0,params.med));
                pred_freq.med.errors(4) = N.med * (CDFDif(ntiles.med.errors(4),0,params.med) - CDFDif(ntiles.med.errors(3),0,params.med));
                pred_freq.med.errors(5) = N.med * (CDFDif(ntiles.med.errors(5),0,params.med) - CDFDif(ntiles.med.errors(4),0,params.med));
                pred_freq.med.errors(6) = N.med * (CDFDif(ntiles.med.errors(6),0,params.med) - CDFDif(ntiles.med.errors(5),0,params.med));
                
            end
            
            pred_freq.fast.correct(1) = N.fast * CDFDif(ntiles.fast.correct(1),1,params.fast);
            pred_freq.fast.correct(2) = N.fast * (CDFDif(ntiles.fast.correct(2),1,params.fast) - CDFDif(ntiles.fast.correct(1),1,params.fast));
            pred_freq.fast.correct(3) = N.fast * (CDFDif(ntiles.fast.correct(3),1,params.fast) - CDFDif(ntiles.fast.correct(2),1,params.fast));
            pred_freq.fast.correct(4) = N.fast * (CDFDif(ntiles.fast.correct(4),1,params.fast) - CDFDif(ntiles.fast.correct(3),1,params.fast));
            pred_freq.fast.correct(5) = N.fast * (CDFDif(ntiles.fast.correct(5),1,params.fast) - CDFDif(ntiles.fast.correct(4),1,params.fast));
            pred_freq.fast.correct(6) = N.fast * (CDFDif(ntiles.fast.correct(6),1,params.fast) - CDFDif(ntiles.fast.correct(5),1,params.fast));
            
            
            
            pred_freq.fast.errors(1) = N.fast * CDFDif(ntiles.fast.errors(1),0,params.fast);
            pred_freq.fast.errors(2) = N.fast * (CDFDif(ntiles.fast.errors(2),0,params.fast) - CDFDif(ntiles.fast.errors(1),0,params.fast));
            pred_freq.fast.errors(3) = N.fast * (CDFDif(ntiles.fast.errors(3),0,params.fast) - CDFDif(ntiles.fast.errors(2),0,params.fast));
            pred_freq.fast.errors(4) = N.fast * (CDFDif(ntiles.fast.errors(4),0,params.fast) - CDFDif(ntiles.fast.errors(3),0,params.fast));
            pred_freq.fast.errors(5) = N.fast * (CDFDif(ntiles.fast.errors(5),0,params.fast) - CDFDif(ntiles.fast.errors(4),0,params.fast));
            pred_freq.fast.errors(6) = N.fast * (CDFDif(ntiles.fast.errors(6),0,params.fast) - CDFDif(ntiles.fast.errors(5),0,params.fast));
            
            
            N.slow.correct = length(trls.slow.correct);
            N.slow.errors = length(trls.slow.errors);
            N.slow.all = N.slow.correct + N.slow.errors;
            
            N.fast.correct = length(trls.fast.correct);
            N.fast.errors = length(trls.fast.errors);
            N.fast.all = N.fast.correct + N.fast.errors;
            
            if include_med
                N.med.correct = length(trls.med.correct);
                N.med.errors = length(trls.med.errors);
                N.med.all = N.med.correct + N.med.errors;
            end
            
            obs_prop_correct.slow = N.slow.correct / N.slow.all;
            obs_prop_correct.med = N.med.correct / N.med.all;
            obs_prop_correct.fast = N.fast.correct / N.fast.all;
            
            
            figure
            
            subplot(1,3,1)
            plot([ntiles.slow.correct],(cumsum(obs_freq.slow.correct)./N.slow.correct).*obs_prop_correct.slow,'ok','markersize',8)
            hold on
            plot([ntiles.slow.correct],cumsum(pred_freq.slow.correct)./N.slow.all,'-xk','markersize',8)
            plot([ntiles.slow.errors],(cumsum(obs_freq.slow.errors)./N.slow.errors).*(1-obs_prop_correct.slow),'or','markersize',8)
            plot([ntiles.slow.errors],cumsum(pred_freq.slow.errors)./N.slow.all,'-xr','markersize',8)
            xlim([0 1])
            ylim([0 1])
            box off
            
            subplot(1,3,2)
            plot([ntiles.med.correct],(cumsum(obs_freq.med.correct)./N.med.correct).*obs_prop_correct.med,'ok','markersize',8)
            hold on
            plot([ntiles.med.correct],cumsum(pred_freq.med.correct)./N.med.all,'-xk','markersize',8)
            plot([ntiles.med.errors],(cumsum(obs_freq.med.errors)./N.med.errors).*(1-obs_prop_correct.med),'or','markersize',8)
            plot([ntiles.med.errors],cumsum(pred_freq.med.errors)./N.med.all,'-xr','markersize',8)
            xlim([0 1])
            ylim([0 1])
            box off
            
            subplot(1,3,3)
            plot([ntiles.fast.correct],(cumsum(obs_freq.fast.correct)./N.fast.correct).*obs_prop_correct.fast,'ok','markersize',8)
            hold on
            plot([ntiles.fast.correct],cumsum(pred_freq.fast.correct)./N.fast.all,'-xk','markersize',8)
            plot([ntiles.fast.errors],(cumsum(obs_freq.fast.errors)./N.fast.errors).*(1-obs_prop_correct.fast),'or','markersize',8)
            plot([ntiles.fast.errors],cumsum(pred_freq.fast.errors)./N.fast.all,'-xr','markersize',8)
            xlim([0 1])
            ylim([0 1])
            box off
            
            
            %Re-plot using CDFs
            t = 0:.001:1;
            
            winner.slow = CDFDif(t,1,params.slow);
            loser.slow = CDFDif(t,0,params.slow);
            winner.med = CDFDif(t,1,params.med);
            loser.med = CDFDif(t,0,params.med);
            winner.fast = CDFDif(t,1,params.fast);
            loser.fast = CDFDif(t,0,params.fast);
            
            
            
            
        elseif use_MLE
            
            t = 0:.01:1;
            
            winner.slow = CDFDif(t,1,params.slow);
            loser.slow = CDFDif(t,0,params.slow);
            winner.med = CDFDif(t,1,params.med);
            loser.med = CDFDif(t,0,params.med);
            winner.fast = CDFDif(t,1,params.fast);
            loser.fast = CDFDif(t,0,params.fast);
            
            
            CDF.slow = getDefectiveCDF(slow_correct_made_dead,slow_errors_made_dead,srt);
            CDF.med = getDefectiveCDF(med_correct,med_errors,srt);
            CDF.fast = getDefectiveCDF(fast_correct_made_dead_withCleared,fast_errors_made_dead_withCleared,srt);
            
            subplot(1,3,1)
            plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok','markersize',8);
            hold on
            plot(CDF.slow.err(:,1),CDF.slow.err(:,2),'or','markersize',8)
            plot(0:.01:1,winner.slow,'k')
            plot(0:.01:1,loser.slow,'r')
            xlim([0 1])
            ylim([0 1])
            box off
            
            subplot(1,3,2)
            plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok','markersize',8);
            hold on
            plot(CDF.med.err(:,1),CDF.med.err(:,2),'or','markersize',8)
            plot(0:.01:1,winner.med,'k')
            plot(0:.01:1,loser.med,'r')
            xlim([0 1])
            ylim([0 1])
            box off
            
            subplot(1,3,3)
            plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok','markersize',8);
            hold on
            plot(CDF.fast.err(:,1),CDF.fast.err(:,2),'or','markersize',8)
            plot(0:.01:1,winner.fast,'k')
            plot(0:.01:1,loser.fast,'r')
            xlim([0 1])
            ylim([0 1])
            box off
        end
    else %not including med (Neutral) condition
        if use_X2
            N.slow = length(slow_correct_made_dead) + length(slow_errors_made_dead);
            N.fast = length(fast_correct_made_dead_withCleared) + length(fast_errors_made_dead_withCleared);
            
            pred_freq.slow_correct_made_dead(1) = N.slow * CDFDif(ntiles.slow.correct(1),1,params.slow);
            pred_freq.slow_correct_made_dead(2) = N.slow * (CDFDif(ntiles.slow.correct(2),1,params.slow) - CDFDif(ntiles.slow.correct(1),1,params.slow));
            pred_freq.slow_correct_made_dead(3) = N.slow * (CDFDif(ntiles.slow.correct(3),1,params.slow) - CDFDif(ntiles.slow.correct(2),1,params.slow));
            pred_freq.slow_correct_made_dead(4) = N.slow * (CDFDif(ntiles.slow.correct(4),1,params.slow) - CDFDif(ntiles.slow.correct(3),1,params.slow));
            pred_freq.slow_correct_made_dead(5) = N.slow * (CDFDif(ntiles.slow.correct(5),1,params.slow) - CDFDif(ntiles.slow.correct(4),1,params.slow));
            
            %at infinity, equals marginal probability
            pred_freq.slow_correct_made_dead(6) = N.slow * (CDFDif(inf,1,params.slow));
            
            pred_freq.slow_errors_made_dead(1) = N.slow * CDFDif(ntiles.slow.errors(1),0,params.slow);
            pred_freq.slow_errors_made_dead(2) = N.slow * (CDFDif(ntiles.slow.errors(2),0,params.slow) - CDFDif(ntiles.slow.errors(1),0,params.slow));
            pred_freq.slow_errors_made_dead(3) = N.slow * (CDFDif(ntiles.slow.errors(3),0,params.slow) - CDFDif(ntiles.slow.errors(2),0,params.slow));
            pred_freq.slow_errors_made_dead(4) = N.slow * (CDFDif(ntiles.slow.errors(4),0,params.slow) - CDFDif(ntiles.slow.errors(3),0,params.slow));
            pred_freq.slow_errors_made_dead(5) = N.slow * (CDFDif(ntiles.slow.errors(5),0,params.slow) - CDFDif(ntiles.slow.errors(4),0,params.slow));
            
            %at infinity, equals marginal probability
            pred_freq.slow_errors_made_dead(6) = N.slow * (CDFDif(inf,0,params.slow));
            
            
            pred_freq.fast_correct_made_dead_withCleared(1) = N.fast * CDFDif(ntiles.fast.correct(1),1,params.fast);
            pred_freq.fast_correct_made_dead_withCleared(2) = N.fast * (CDFDif(ntiles.fast.correct(2),1,params.fast) - CDFDif(ntiles.fast.correct(1),1,params.fast));
            pred_freq.fast_correct_made_dead_withCleared(3) = N.fast * (CDFDif(ntiles.fast.correct(3),1,params.fast) - CDFDif(ntiles.fast.correct(2),1,params.fast));
            pred_freq.fast_correct_made_dead_withCleared(4) = N.fast * (CDFDif(ntiles.fast.correct(4),1,params.fast) - CDFDif(ntiles.fast.correct(3),1,params.fast));
            pred_freq.fast_correct_made_dead_withCleared(5) = N.fast * (CDFDif(ntiles.fast.correct(5),1,params.fast) - CDFDif(ntiles.fast.correct(4),1,params.fast));
            
            %at infinity, equals marginal probability
            pred_freq.fast_correct_made_dead_withCleared(6) = N.fast * (CDFDif(inf,1,params.fast));
            
            
            pred_freq.fast_errors_made_dead_withCleared(1) = N.fast * CDFDif(ntiles.fast.errors(1),0,params.fast);
            pred_freq.fast_errors_made_dead_withCleared(2) = N.fast * (CDFDif(ntiles.fast.errors(2),0,params.fast) - CDFDif(ntiles.fast.errors(1),0,params.fast));
            pred_freq.fast_errors_made_dead_withCleared(3) = N.fast * (CDFDif(ntiles.fast.errors(3),0,params.fast) - CDFDif(ntiles.fast.errors(2),0,params.fast));
            pred_freq.fast_errors_made_dead_withCleared(4) = N.fast * (CDFDif(ntiles.fast.errors(4),0,params.fast) - CDFDif(ntiles.fast.errors(3),0,params.fast));
            pred_freq.fast_errors_made_dead_withCleared(5) = N.fast * (CDFDif(ntiles.fast.errors(5),0,params.fast) - CDFDif(ntiles.fast.errors(4),0,params.fast));
            
            %at infinity, equals marginal probability
            pred_freq.fast_errors_made_dead_withCleared(6) = N.fast * (CDFDif(inf,0,params.fast));
            
            
            figure
            
            subplot(1,3,1)
            plot([ntiles.slow.correct ],cumsum(obs_freq.slow.correct)./N.slow,'ok','markersize',8)
            hold on
            plot([ntiles.slow.correct ],cumsum(pred_freq.slow_correct_made_dead)./N.slow,'-xk','markersize',8)
            plot([ntiles.slow.errors ],cumsum(obs_freq.slow.errors)./N.slow,'or','markersize',8)
            plot([ntiles.slow.errors ],cumsum(pred_freq.slow_errors_made_dead)./N.slow,'-xr','markersize',8)
            xlim([0 1])
            ylim([0 1])
            box off
            
            
            subplot(1,3,3)
            plot([ntiles.fast.correct ],cumsum(obs_freq.fast.correct)./N.fast,'ok','markersize',8)
            hold on
            plot([ntiles.fast.correct ],cumsum(pred_freq.fast_correct_made_dead_withCleared)./N.fast,'-xk','markersize',8)
            plot([ntiles.fast.errors ],cumsum(obs_freq.fast.errors)./N.fast,'or','markersize',8)
            plot([ntiles.fast.errors ],cumsum(pred_freq.fast_errors_made_dead_withCleared)./N.fast,'-xr','markersize',8)
            xlim([0 1])
            ylim([0 1])
            box off
            
            
            %Re-plot using CDFs
            t = 0:.001:1;
            
            winner.slow = CDFDif(t,1,params.slow);
            loser.slow = CDFDif(t,0,params.slow);
            winner.fast = CDFDif(t,1,params.fast);
            loser.fast = CDFDif(t,0,params.fast);
            
            CDF.slow = getDefectiveCDF(slow_correct_made_dead,slow_errors_made_dead,SRT./1000);
            CDF.fast = getDefectiveCDF(fast_correct_made_dead_withCleared,fast_errors_made_dead_withCleared,SRT./1000);
            
            subplot(2,3,4)
            plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok',CDF.slow.err(:,1),CDF.slow.err(:,2),'or')
            hold on
            plot(t,winner.slow,'k',t,loser.slow,'r')
            xlim([0 1])
            ylim([0 1])
            box off
            
            subplot(2,3,6)
            plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok',CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
            hold on
            plot(t,winner.fast,'k',t,loser.fast,'r')
            xlim([0 1])
            ylim([0 1])
            box off
            
            
        elseif use_MLE
            
            t = 0:.01:1;
            
            winner.slow = CDFDif(t,1,params.slow);
            loser.slow = CDFDif(t,0,params.slow);
            winner.fast = CDFDif(t,1,params.fast);
            loser.fast = CDFDif(t,0,params.fast);
            
            CDF.slow = getDefectiveCDF(slow_correct_made_dead,slow_errors_made_dead,srt);
            CDF.fast = getDefectiveCDF(fast_correct_made_dead_withCleared,fast_errors_made_dead_withCleared,srt);
            
            subplot(1,3,1)
            plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok','markersize',8);
            hold on
            plot(CDF.slow.err(:,1),CDF.slow.err(:,2),'or','markersize',8)
            plot(0:.01:1,winner.slow,'k')
            plot(0:.01:1,loser.slow,'r')
            xlim([0 1])
            ylim([0 1])
            box off
            
            subplot(1,3,3)
            plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok','markersize',8);
            hold on
            plot(CDF.fast.err(:,1),CDF.fast.err(:,2),'or','markersize',8)
            plot(0:.01:1,winner.fast,'k')
            plot(0:.01:1,loser.fast,'r')
            xlim([0 1])
            ylim([0 1])
            box off
        end
    end
end