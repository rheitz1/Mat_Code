%Fit DDM to a single condition for testing, debugging, figure creation, etc.

correct = find(dat(:,1) == 1 & dat(:,3) == 700);
errors = find(dat(:,1) == 0 & dat(:,3) == 700);
SRT = dat(:,2);

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


%==
% Starting values taken from Simen et al. 2009. Not sure why it works so well but it does
a = .0558;
Ter = .34547;
eta = .068683;
z = .0029;
sZ = .03;
st = .1;
nu = .17348;

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


if truncate_IQR
    disp(['Truncating ' mat2str(truncval) ' * IQR'])
    highcut_slow = nanmedian(SRT([correct ; errors],1)) + truncval * iqr(SRT([correct ; errors],1));
    lowcut_slow = nanmedian(SRT([correct ; errors],1)) - truncval * iqr(SRT([correct ; errors],1));
    highcut_med = nanmedian(SRT([correct ; errors],1)) + truncval * iqr(SRT([correct ; errors],1));
    lowcut_med = nanmedian(SRT([correct ; errors],1)) - truncval * iqr(SRT([correct ; errors],1));
    highcut_fast = nanmedian(SRT([correct ; errors],1)) + truncval * iqr(SRT([correct ; errors],1));
    lowcut_fast = nanmedian(SRT([correct ; errors],1)) - truncval * iqr(SRT([correct ; errors],1));
    
    
    %Second Pass
    correct = intersect(correct,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
    errors = intersect(errors,find(SRT(:,1) > lowcut_med & SRT(:,1) < highcut_med));
    
    %All correct trials w/ made deadlines
    correct = intersect(correct,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
    correct = intersect(correct,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
    errors = intersect(errors,find(SRT(:,1) > lowcut_slow & SRT(:,1) < highcut_slow));
    errors = intersect(errors,find(SRT(:,1) > lowcut_fast & SRT(:,1) < highcut_fast));
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
param = [a,Ter,eta,z,sZ,st,nu];
lower = [lb.a,lb.Ter,lb.eta,lb.z,lb.sZ,lb.st,lb.nu];
upper = [ub.a,ub.Ter,ub.eta,ub.z,ub.sZ,ub.st,ub.nu];

srt = SRT ./ 1000;



%get quantiles
nts = [10 ; 30 ; 50 ; 70 ; 90];
ntiles.correct = prctile(srt(correct,1),nts);
ntiles.errors = prctile(srt(errors,1),nts);


nl = .1 * length(correct);
nh = .2 * length(correct);
obs_freq.correct = [nl nh nh nh nh nl];
clear nl nh

nl = .1 * length(errors);
nh = .2 * length(errors);
obs_freq.errors = [nl nh nh nh nh nl];
clear nl nh

%save trial vectors to struct for easier passing
trls.correct = correct;
trls.errors = errors;

if minimize
    %   lower = [lb.A,lb.b,lb.v,lb.T0];
    %  upper = [ub.A,ub.b,ub.v,ub.T0];
    %options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
    options = optimset('MaxIter', 100000,'MaxFunEvals', 100000);
    %[solution minval exitflag output] = fminsearchbnd(@(param) fitDDM_singleCond_calcX2(param,ntiles,trls,obs_freq),param,lower,upper,options);
     [solution minval exitflag output] = fminsearchbnd(@(param) fitDDM_singleCond_calcLL(param,srt,trls),param,lower,upper,options);
    
    
    
    
else
    params = param(1:7);
    
    N = length(correct) + length(errors);
    
    
    
    pred_freq.correct(1) = N * CDFDif(ntiles.correct(1),1,params);
    pred_freq.correct(2) = N * (CDFDif(ntiles.correct(2),1,params) - CDFDif(ntiles.correct(1),1,params));
    pred_freq.correct(3) = N * (CDFDif(ntiles.correct(3),1,params) - CDFDif(ntiles.correct(2),1,params));
    pred_freq.correct(4) = N * (CDFDif(ntiles.correct(4),1,params) - CDFDif(ntiles.correct(3),1,params));
    pred_freq.correct(5) = N * (CDFDif(ntiles.correct(5),1,params) - CDFDif(ntiles.correct(4),1,params));
    
    %at infinity, equals marginal probability
    pred_freq.correct(6) = N * (CDFDif(inf,1,params));
    
    pred_freq.errors(1) = N * CDFDif(ntiles.errors(1),0,params);
    pred_freq.errors(2) = N * (CDFDif(ntiles.errors(2),0,params) - CDFDif(ntiles.errors(1),0,params));
    pred_freq.errors(3) = N * (CDFDif(ntiles.errors(3),0,params) - CDFDif(ntiles.errors(2),0,params));
    pred_freq.errors(4) = N * (CDFDif(ntiles.errors(4),0,params) - CDFDif(ntiles.errors(3),0,params));
    pred_freq.errors(5) = N * (CDFDif(ntiles.errors(5),0,params) - CDFDif(ntiles.errors(4),0,params));
    
    %at infinity, equals marginal probability
    pred_freq.errors(6) = N * (CDFDif(inf,0,params));
    
    
    
    all_obs = [obs_freq.correct' ; obs_freq.errors'];
    
    all_pred = [pred_freq.correct' ; pred_freq.errors'];
    
    X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );
    
    disp([param(1:7)']);
    
    figure
    plot([ntiles.correct ; inf],cumsum(obs_freq.correct)./N,'ok')
    hold on
    plot([ntiles.correct ; inf],cumsum(pred_freq.correct)./N,'-xk')
    plot([ntiles.errors ; inf],cumsum(obs_freq.errors)./N,'or')
    plot([ntiles.errors ; inf],cumsum(pred_freq.errors)./N,'-xr')
    xlim([0 1])
    ylim([0 1])
    title(['X2 = ' mat2str(round(X2*100)/100)])
    
end