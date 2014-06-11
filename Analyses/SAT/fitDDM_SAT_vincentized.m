%Fit DDM

function [solution,X2,CDF] = fitDDM_SAT_vincentized(FreeFix,plotFlag)

rand('seed',5150);
randn('seed',5150);
normrnd('seed',5150);

trls = evalin('caller','trls');
obs_freq = evalin('caller','obs_freq');
ntiles = evalin('caller','ntiles');
include_med = 1;
% Correct_ = evalin('caller','Correct_');
% Errors_ = evalin('caller','Errors_');
% Target_ = evalin('caller','Target_');
% SAT_ = evalin('caller','SAT_');
% SRT = evalin('caller','SRT');

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
% truncate_IQR = 1;
% truncval = 1.5;


%CHECK THIS SCRIPT FOR CONSISTENCY WITH NEW FITDDM_SAT!~!



ntiles.slow.correct = ntiles.slow.correct ./ 1000;
ntiles.slow.errors = ntiles.slow.errors ./ 1000;
ntiles.med.correct = ntiles.med.correct ./ 1000;
ntiles.med.errors = ntiles.med.errors ./ 1000;
ntiles.fast.correct = ntiles.fast.correct ./ 1000;
ntiles.fast.errors = ntiles.fast.errors ./ 1000;


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



%starting parameters
if FreeFix(1) == 3
    a(1) = .0853; a(2) = .0547; a(3) = .029;
elseif FreeFix(1) == 2
    a(1) = .0853; a(2) = .029;
else
    a(1:FreeFix(1)) = .0853;
end

if FreeFix(2) == 3
    Ter(1) = .5303; Ter(2) = .2181; Ter(3) = .2254;
elseif FreeFix(2) == 2
    Ter(1) = .5303; Ter(2) = .2254;
else
    Ter(1:FreeFix(2)) = .5303;
end

if FreeFix(3) == 3
    eta(1) = .0646; eta(2) = .0058; eta(3) = .0377;
elseif FreeFix(3) == 2
    eta(1) = .0646; eta(2) = .0377;
else
    eta(1:FreeFix(3)) = .0646;
end

if FreeFix(4) == 3
    z(1) = .0562; z(2) = .0330; z(3) = .0204;
elseif FreeFix(4) == 2
    z(1) = .0562; z(2) = .0204;
else
    z(1:FreeFix(4)) = .0562;
end

if FreeFix(5) == 3
    sZ(1) = .001; sZ(2) = .0423; sZ(3) = .0056;
elseif FreeFix(5) == 2
    sZ(1) = .001; sZ(2) = .0056;
else
    sZ(1:FreeFix(5)) = .03;
end

if FreeFix(6) == 3
    st(1) = .1520; st(2) = .0447; st(3) = .0578;
elseif FreeFix(6) == 2
    st(1) = .1520; st(2) = .0578;
else
    st(1:FreeFix(6)) = .1520;
end

if FreeFix(7) == 3
    v(1) = .2114; v(2) = .2727; v(3) = .1405;
elseif FreeFix(7) == 2
    v(1) = .2114; v(2) = .1405;
else
    v(1:FreeFix(7)) = .2114;
end






lb.a(1:FreeFix(1)) = .0001;
lb.Ter(1:FreeFix(2)) = .05;
lb.eta(1:FreeFix(3)) = .0001;
lb.z(1:FreeFix(4)) = .0001;
lb.sZ(1:FreeFix(5)) = .0001;
lb.st(1:FreeFix(6)) = .0001;
lb.v(1:FreeFix(7)) = .0001;

ub.a(1:FreeFix(1)) = 1;
ub.Ter(1:FreeFix(2)) = .7;
ub.eta(1:FreeFix(3)) = 1;
ub.z(1:FreeFix(4)) = 1;
ub.sZ(1:FreeFix(5)) = 1;
ub.st(1:FreeFix(6)) = 1;
ub.v(1:FreeFix(7)) = 1;


initRange.a = [a-.01 ; a+.01];
initRange.Ter = [Ter-10 ; Ter+10];
initRange.eta = [eta-.01 ; eta+.01];
initRange.z = [z-.01 ; z+.01];
initRange.sZ = [sZ-.01 ; sZ+.01];
initRange.st = [st-.01 ; st+.01];
initRange.v = [v-.01 ; v+.01];

initRange = [initRange.a initRange.Ter initRange.eta initRange.z initRange.sZ initRange.st initRange.v];


param = [a,Ter,eta,z,sZ,st,v];

lower = [lb.a,lb.Ter,lb.eta,lb.z,lb.sZ,lb.st,lb.v];
upper = [ub.a,ub.Ter,ub.eta,ub.z,ub.sZ,ub.st,ub.v];

if minimize
    
    %options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    %options = optimset('MaxIter', 100000,'MaxFunEvals', 100000);
    
    if use_X2
        %[solution minval exitflag output] = fminsearch(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),param,options);
       %[solution minval exitflag output] = fminsearchbnd(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),param,lower,upper,options);
        
        
        
        options = gaoptimset('PopulationSize',[ones(1,10)*30],...
            'Generations',100,...
            'PopInitRange',initRange,...
            'Display','iter', ...
            'UseParallel','always');
            %'StallGenLimit',50,'TolFun',.0001, ...
            %'MutationFcn',{@mutationgaussian,1,1},...
            %'HybridFcn',@fminsearch);
        
        [solution minval] = ga(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),numel(param),[],[],[],[],lower,upper,[],options);
        
        options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
        param = solution;
        
        [solution minval] = fminsearchbnd(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),param,lower,upper,options);
    elseif use_MLE
        options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
        
        %[solution minval exitflag output] = fminsearch(@(param) fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq),param,options);
        [solution minval exitflag output] = fminsearchbnd(@(param) fitDDM_SAT_calcLL(param,srt,trls),param,lower,upper,options);
    end
    
else
    disp('NOT MINIMIZING: USING STARTING VALUES TO FIT')
    
    %BEST FITTING PARAMETERS FOR MODEL: solution = fitDDM_SAT_vincentized([3 3 3 1 3 3 1],1)
    a = [.0721 .0805 .0698];
    Ter = [.5413 .2608 .2739];
    eta = [.2390 .4199 .2720];
    z = [.0467];
    sZ = [.0658 .1041 .1168];
    st = [.1597 .0812 .1170];
    v = [.3905];
    
    param = [a,Ter,eta,z,sZ,st,v];
    %param = [0.0780066218129638,0.0965223549969652,0.0868214112963471,0.578357008951804,0.196439477058399,0.206073376061123,0.366409484121728,0.0486396845150924,0.0698688999197088,0.174752872401470,0.0660879946146569,0.0123415506577879,0.225964161929486;];
    
    %     if use_X2
    %         minval = fitDDM_SAT_calcX2(param,ntiles,trls,obs_freq);
    %     elseif use_MLE
    %         minval = fitDDM_SAT_calcLL(param,srt,trls);
    %     end
    
    solution = param; %since we are not minimizing, take starting values as solution.
end


%Final Parameters
a = solution(1:length(a));
Ter = solution(length(a)+1:length(a)+length(Ter));
eta = solution(length(a)+length(Ter)+1:length(a)+length(Ter)+length(eta));
z = solution(length(a)+length(Ter)+length(eta)+1:length(a)+length(Ter)+length(eta)+length(z));
sZ = solution(length(a)+length(Ter)+length(eta)+length(z)+1:length(a)+length(Ter)+length(eta)+length(z)+length(sZ));
st = solution(length(a)+length(Ter)+length(eta)+length(z)+length(sZ)+1:length(a)+length(Ter)+length(eta)+length(z)+length(sZ)+length(st));
v = solution(length(a)+length(Ter)+length(eta)+length(z)+length(sZ)+length(st)+1:length(solution));







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


pred_freq.slow.correct(1) = N.slow.all * CDFDif(ntiles.slow.correct(1),1,params.slow);
pred_freq.slow.correct(2) = N.slow.all * (CDFDif(ntiles.slow.correct(2),1,params.slow) - CDFDif(ntiles.slow.correct(1),1,params.slow));
pred_freq.slow.correct(3) = N.slow.all * (CDFDif(ntiles.slow.correct(3),1,params.slow) - CDFDif(ntiles.slow.correct(2),1,params.slow));
pred_freq.slow.correct(4) = N.slow.all * (CDFDif(ntiles.slow.correct(4),1,params.slow) - CDFDif(ntiles.slow.correct(3),1,params.slow));
pred_freq.slow.correct(5) = N.slow.all * (CDFDif(ntiles.slow.correct(5),1,params.slow) - CDFDif(ntiles.slow.correct(4),1,params.slow));
pred_freq.slow.correct(6) = N.slow.all * (CDFDif(ntiles.slow.correct(6),1,params.slow) - CDFDif(ntiles.slow.correct(5),1,params.slow));


pred_freq.slow.errors(1) = N.slow.all * CDFDif(ntiles.slow.errors(1),0,params.slow);
pred_freq.slow.errors(2) = N.slow.all * (CDFDif(ntiles.slow.errors(2),0,params.slow) - CDFDif(ntiles.slow.errors(1),0,params.slow));
pred_freq.slow.errors(3) = N.slow.all * (CDFDif(ntiles.slow.errors(3),0,params.slow) - CDFDif(ntiles.slow.errors(2),0,params.slow));
pred_freq.slow.errors(4) = N.slow.all * (CDFDif(ntiles.slow.errors(4),0,params.slow) - CDFDif(ntiles.slow.errors(3),0,params.slow));
pred_freq.slow.errors(5) = N.slow.all * (CDFDif(ntiles.slow.errors(5),0,params.slow) - CDFDif(ntiles.slow.errors(4),0,params.slow));
pred_freq.slow.errors(6) = N.slow.all * (CDFDif(ntiles.slow.errors(6),0,params.slow) - CDFDif(ntiles.slow.errors(5),0,params.slow));


if include_med
    pred_freq.med.correct(1) = N.med.all * CDFDif(ntiles.med.correct(1),1,params.med);
    pred_freq.med.correct(2) = N.med.all * (CDFDif(ntiles.med.correct(2),1,params.med) - CDFDif(ntiles.med.correct(1),1,params.med));
    pred_freq.med.correct(3) = N.med.all * (CDFDif(ntiles.med.correct(3),1,params.med) - CDFDif(ntiles.med.correct(2),1,params.med));
    pred_freq.med.correct(4) = N.med.all * (CDFDif(ntiles.med.correct(4),1,params.med) - CDFDif(ntiles.med.correct(3),1,params.med));
    pred_freq.med.correct(5) = N.med.all * (CDFDif(ntiles.med.correct(5),1,params.med) - CDFDif(ntiles.med.correct(4),1,params.med));
    pred_freq.med.correct(6) = N.med.all * (CDFDif(ntiles.med.correct(6),1,params.med) - CDFDif(ntiles.med.correct(5),1,params.med));
    
    
    
    pred_freq.med.errors(1) = N.med.all * CDFDif(ntiles.med.errors(1),0,params.med);
    pred_freq.med.errors(2) = N.med.all * (CDFDif(ntiles.med.errors(2),0,params.med) - CDFDif(ntiles.med.errors(1),0,params.med));
    pred_freq.med.errors(3) = N.med.all * (CDFDif(ntiles.med.errors(3),0,params.med) - CDFDif(ntiles.med.errors(2),0,params.med));
    pred_freq.med.errors(4) = N.med.all * (CDFDif(ntiles.med.errors(4),0,params.med) - CDFDif(ntiles.med.errors(3),0,params.med));
    pred_freq.med.errors(5) = N.med.all * (CDFDif(ntiles.med.errors(5),0,params.med) - CDFDif(ntiles.med.errors(4),0,params.med));
    pred_freq.med.errors(6) = N.med.all * (CDFDif(ntiles.med.errors(6),0,params.med) - CDFDif(ntiles.med.errors(5),0,params.med));
end


pred_freq.fast.correct(1) = N.fast.all * CDFDif(ntiles.fast.correct(1),1,params.fast);
pred_freq.fast.correct(2) = N.fast.all * (CDFDif(ntiles.fast.correct(2),1,params.fast) - CDFDif(ntiles.fast.correct(1),1,params.fast));
pred_freq.fast.correct(3) = N.fast.all * (CDFDif(ntiles.fast.correct(3),1,params.fast) - CDFDif(ntiles.fast.correct(2),1,params.fast));
pred_freq.fast.correct(4) = N.fast.all * (CDFDif(ntiles.fast.correct(4),1,params.fast) - CDFDif(ntiles.fast.correct(3),1,params.fast));
pred_freq.fast.correct(5) = N.fast.all * (CDFDif(ntiles.fast.correct(5),1,params.fast) - CDFDif(ntiles.fast.correct(4),1,params.fast));
pred_freq.fast.correct(6) = N.fast.all * (CDFDif(ntiles.fast.correct(6),1,params.fast) - CDFDif(ntiles.fast.correct(5),1,params.fast));



pred_freq.fast.errors(1) = N.fast.all * CDFDif(ntiles.fast.errors(1),0,params.fast);
pred_freq.fast.errors(2) = N.fast.all * (CDFDif(ntiles.fast.errors(2),0,params.fast) - CDFDif(ntiles.fast.errors(1),0,params.fast));
pred_freq.fast.errors(3) = N.fast.all * (CDFDif(ntiles.fast.errors(3),0,params.fast) - CDFDif(ntiles.fast.errors(2),0,params.fast));
pred_freq.fast.errors(4) = N.fast.all * (CDFDif(ntiles.fast.errors(4),0,params.fast) - CDFDif(ntiles.fast.errors(3),0,params.fast));
pred_freq.fast.errors(5) = N.fast.all * (CDFDif(ntiles.fast.errors(5),0,params.fast) - CDFDif(ntiles.fast.errors(4),0,params.fast));
pred_freq.fast.errors(6) = N.fast.all * (CDFDif(ntiles.fast.errors(6),0,params.fast) - CDFDif(ntiles.fast.errors(5),0,params.fast));




if include_med
    all_obs = [obs_freq.slow.correct' ; obs_freq.slow.errors' ; ...
        obs_freq.med.correct' ; obs_freq.med.errors' ; ...
        obs_freq.fast.correct' ; obs_freq.fast.errors'];
    
    all_pred = [pred_freq.slow.correct' ; pred_freq.slow.errors' ; ...
        pred_freq.med.correct' ; pred_freq.med.errors' ; ...
        pred_freq.fast.correct' ; pred_freq.fast.errors'];
else
    
    all_obs = [obs_freq.slow.correct' ; obs_freq.slow.errors' ; ...
        obs_freq.fast.correct' ; obs_freq.fast.errors'];
    
    all_pred = [pred_freq.slow.correct' ; pred_freq.slow.errors' ; ...
        pred_freq.fast.correct' ; pred_freq.fast.errors'];
end

X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );
%disp([all_obs all_pred])

%Strange case handling
if isnan(X2); X2 = 9e90; end

%for cases where predicted frequences are negative
if any(all_pred < 0); X2 = 9e90; end


% if include_med
%     disp([params.slow' params.med' params.fast'])
% else
%     disp([params.slow' NaN(7,1) params.fast'])
% end



% Note: only have to change CDF into defective CDF for observed data; predicated data are already
% returned as defective CDFs
obs_prop_correct.slow = N.slow.correct / N.slow.all;
obs_prop_correct.med = N.med.correct / N.med.all;
obs_prop_correct.fast = N.fast.correct / N.fast.all;

if plotFlag
    
    subplot(1,3,1)
    plot([ntiles.slow.correct],(cumsum(obs_freq.slow.correct)./N.slow.correct).*obs_prop_correct.slow,'ok','markersize',8)
    hold on
    plot([ntiles.slow.correct],cumsum(pred_freq.slow.correct)./N.slow.all,'-xk','markersize',8)
    plot([ntiles.slow.errors],(cumsum(obs_freq.slow.errors)./N.slow.errors).*(1-obs_prop_correct.slow),'or','markersize',8)
    plot([ntiles.slow.errors],cumsum(pred_freq.slow.errors)./N.slow.all,'-xr','markersize',8)
    xlim([0 1])
    ylim([0 1])
    box off
    
    if include_med
        subplot(1,3,2)
        plot([ntiles.med.correct],(cumsum(obs_freq.med.correct)./N.med.correct).*obs_prop_correct.med,'ok','markersize',8)
        hold on
        plot([ntiles.med.correct],cumsum(pred_freq.med.correct)./N.med.all,'-xk','markersize',8)
        plot([ntiles.med.errors],(cumsum(obs_freq.med.errors)./N.med.errors).*(1-obs_prop_correct.med),'or','markersize',8)
        plot([ntiles.med.errors],cumsum(pred_freq.med.errors)./N.med.all,'-xr','markersize',8)
        xlim([0 1])
        ylim([0 1])
        box off
    end
    
    subplot(1,3,3)
    plot([ntiles.fast.correct],(cumsum(obs_freq.fast.correct)./N.fast.correct).*obs_prop_correct.fast,'ok','markersize',8)
    hold on
    plot([ntiles.fast.correct],cumsum(pred_freq.fast.correct)./N.fast.all,'-xk','markersize',8)
    plot([ntiles.fast.errors],(cumsum(obs_freq.fast.errors)./N.fast.errors).*(1-obs_prop_correct.fast),'or','markersize',8)
    plot([ntiles.fast.errors],cumsum(pred_freq.fast.errors)./N.fast.all,'-xr','markersize',8)
    xlim([0 1])
    ylim([0 1])
    box off
    
end