%Fit DDM

%Starting Values
% a = .16; %boundary separation
% Ter = .1; %mean non-decisional component time
% eta = .08; %standard deviation of normal drift distribution
% z = a/2; %mean starting point
% sZ = .04; %spread of starting point distribution
% st = .04; %spread of non-decisional component time distribution
% nu = .2; %mean drift rate
minimize = 1;
truncate_IQR = 1;
truncval = 1.5;


% a.slow= .06;
% Ter.slow = .31;
% eta.slow = .12;
% z.slow = .04;
% sZ.slow = .03;
% st.slow = .03;
% nu.slow = .27;

a.slow = .0439;
Ter.slow = .58;
eta.slow = .1818;
z.slow = .036;
sZ.slow = .0334;
st.slow = .205;
nu.slow = .3111;

lb.a = .00001;
lb.Ter = .005;
lb.eta = .00001;
lb.z = .00001;
lb.sZ = .00001;
lb.st = .00001;
lb.nu = .00001;

ub.a = 1;
ub.Ter = 1;
ub.eta = 1;
ub.z = 1;
ub.sZ = 1;
ub.st = 1;
ub.nu = 1;

%getTrials_SAT

if truncate_IQR
    disp(['Truncating ' mat2str(truncval) ' * IQR'])
    highcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) + truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
    lowcut_slow = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) - truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
    highcut_med = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) + truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
    lowcut_med = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) - truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
    highcut_fast = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) + truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
    lowcut_fast = nanmedian(SRT([slow_correct_made_dead ; slow_errors_made_dead],1)) - truncval * iqr(SRT([slow_correct_made_dead ; slow_errors_made_dead],1));
    
    
    %Second Pass
    slow_correct_made_dead = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
    slow_errors_made_dead = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
    
    %All correct trials w/ made deadlines
    slow_correct_made_dead = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
    slow_correct_made_dead = intersect(slow_correct_made_dead,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
    slow_errors_made_dead = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
    slow_errors_made_dead = intersect(slow_errors_made_dead,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
end





% lb.a = 0; ub.a = 1;
% lb.Ter = 0 ; ub.Ter = .5;
% lb.eta = 0 ; ub.eta = 1;
% lb.z = 0; ub.z = 1;
% lb.sZ = 0; ub.sZ = 1;
% lb.st = 0; ub.st = 1;
% lb.nu = 0; ub.nu = 1;
%
% lower = [lb.a,lb.Ter,lb.eta,lb.z,lb.sZ,lb.st,lb.nu];
% upper = [ub.a,ub.Ter,ub.eta,ub.z,ub.sZ,ub.st,ub.nu];
param = [a.slow,Ter.slow,eta.slow,z.slow,sZ.slow,st.slow,nu.slow];
lower = [lb.a,lb.Ter,lb.eta,lb.z,lb.sZ,lb.st,lb.nu];
upper = [ub.a,ub.Ter,ub.eta,ub.z,ub.sZ,ub.st,ub.nu];

srt = SRT ./ 1000;



%get quantiles
nts = [10 ; 30 ; 50 ; 70 ; 90];
ntiles.slow_correct = prctile(srt(slow_correct_made_dead,1),nts);
ntiles.slow_errors = prctile(srt(slow_errors_made_dead,1),nts);


nl = .1 * length(slow_correct_made_dead);
nh = .2 * length(slow_correct_made_dead);
obs_freq.slow_correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(slow_errors_made_dead);
nh = .2 * length(slow_errors_made_dead);
obs_freq.slow_errors = [nl nh nh nh nh nl];
clear nl nh

%save trial vectors to struct for easier passing
trls.slow_correct = slow_correct_made_dead;
trls.slow_errors = slow_errors_made_dead;

trls.slow_correct_made_dead = slow_correct_made_dead;
trls.slow_errors_made_dead = slow_errors_made_dead;

if minimize
    %   lower = [lb.A,lb.b,lb.v,lb.T0];
    %  upper = [ub.A,ub.b,ub.v,ub.T0];
    %options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    options = optimset('MaxIter', 100000,'MaxFunEvals', 100000);
     [solution minval exitflag output] = fminsearchbnd(@(param) fitDDM_SAT_calcX2(param,ntiles,slow_correct_made_dead,slow_errors_made_dead,obs_freq),param,lower,upper,options);
    %[solution minval exitflag output] = fminsearch(@(param) fitDDM_SAT_calcX2_singlecond(param,ntiles,trls,obs_freq),param,options);
    % [solution minval exitflag output] = fminsearchbnd(@(param) fitDDM_SAT_calcLL_singlecond(param,srt,trls),param,lower,upper,options);
    %[solution minval exitflag output] = fminsearch(@(param) fitDDM_SAT_calcX2_singlecond(param,ntiles,trls,obs_freq),param,options);
    
    
    
else
    params.slow = param(1:7);
    
    N.slow = length(slow_correct_made_dead) + length(slow_errors_made_dead);
    
%     
%     
%     pred_freq.slow_correct(1) = N.slow * CDFDif(ntiles.slow_correct(1),1,params.slow);
%     pred_freq.slow_correct(2) = N.slow * (CDFDif(ntiles.slow_correct(2),1,params.slow) - CDFDif(ntiles.slow_correct(1),1,params.slow));
%     pred_freq.slow_correct(3) = N.slow * (CDFDif(ntiles.slow_correct(3),1,params.slow) - CDFDif(ntiles.slow_correct(2),1,params.slow));
%     pred_freq.slow_correct(4) = N.slow * (CDFDif(ntiles.slow_correct(4),1,params.slow) - CDFDif(ntiles.slow_correct(3),1,params.slow));
%     pred_freq.slow_correct(5) = N.slow * (CDFDif(ntiles.slow_correct(5),1,params.slow) - CDFDif(ntiles.slow_correct(4),1,params.slow));
%     
%     %at infinity, equals marginal probability
%     pred_freq.slow_correct(6) = N.slow * (CDFDif(inf,1,params.slow));
%     
%     pred_freq.slow_errors(1) = N.slow * CDFDif(ntiles.slow_errors(1),0,params.slow);
%     pred_freq.slow_errors(2) = N.slow * (CDFDif(ntiles.slow_errors(2),0,params.slow) - CDFDif(ntiles.slow_errors(1),0,params.slow));
%     pred_freq.slow_errors(3) = N.slow * (CDFDif(ntiles.slow_errors(3),0,params.slow) - CDFDif(ntiles.slow_errors(2),0,params.slow));
%     pred_freq.slow_errors(4) = N.slow * (CDFDif(ntiles.slow_errors(4),0,params.slow) - CDFDif(ntiles.slow_errors(3),0,params.slow));
%     pred_freq.slow_errors(5) = N.slow * (CDFDif(ntiles.slow_errors(5),0,params.slow) - CDFDif(ntiles.slow_errors(4),0,params.slow));
%     
%     %at infinity, equals marginal probability
%     pred_freq.slow_errors(6) = N.slow * (CDFDif(inf,0,params.slow));
%     
%     
%     
%     figure
%     
%     plot([ntiles.slow_correct ; inf],cumsum(obs_freq.slow_correct)./N.slow,'ok')
%     hold on
%     plot([ntiles.slow_correct ; inf],cumsum(pred_freq.slow_correct)./N.slow,'-xk')
%     plot([ntiles.slow_errors ; inf],cumsum(obs_freq.slow_errors)./N.slow,'or')
%     plot([ntiles.slow_errors ; inf],cumsum(pred_freq.slow_errors)./N.slow,'-xr')
%     xlim([0 1])
%     ylim([0 1])
    
end
% options = gaoptimset('Generations',1000,'StallGenLimit',1000,...
%    'MigrationDirection','forward','TolFun',1e-10);
% %options.PopInitRange = [0 0 0; 100 100 100];
% %options = gaoptimset(options,'HybridFcn', {  @fminsearch [] });
%
% solution = ga(@(param) fitLBA_TL_2AFC_setsize_calcLL(param,Trial_Mat),numel(param),[],[],[],[],lower,upper,[],options);
%
% A = solution(1:length(A));
% b = solution(length(A)+1:length(A)+length(b));
% v = solution(length(A)+length(b)+1:length(A)+length(b)+length(v));
% T0 = solution(length(A)+length(b)+length(v)+1:length(solution));
% s = repmat(s,1,fr);