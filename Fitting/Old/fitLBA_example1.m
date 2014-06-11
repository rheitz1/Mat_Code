% PDF of the linear ballistic accumulator model
% from Brown & Heathcote (2008) p.159
%
% t is vector of x-values
% A is upper limit on starting point of evidence accumulation. Will be
%   drawing from a uniform distribution [0,A]
% b is threshold
% s is standard deviation of the drift rate, set to 0.1
% v is the mean of the normal distribution from which drift rates d are
%   sampled

function [solution] = fitLBA(SRT,trls_correct,trls_err)
%linearballisticPDF(1:.01:100,.01,20,.4,1)
%%
plotFlag = 1;
%decent starting parameters for qload
A = .001;
b = 150;
v1 = .6;
v2 = .45;
s = .10;
T0 = 200;
% 

 global T
T = 1;

SRT_correct = sort(SRT(trls_correct,1));
SRT_err = sort(SRT(trls_err,1));

%remove NaNs
SRT_correct(find(isnan(SRT_correct))) = [];
SRT_err(find(isnan(SRT_err))) = [];


defectiveCDF_observed = getDefectiveCDF(trls_correct,trls_err);



%create linear inequalities:
% A > 0
% b > A
% v1 > 0
% v1 >= v2
% s > .0001
% T0 > 0

param = [A b v1 v2 s T0]; %s hard coded.  The rest are simply first guesses and will be estimated.

% VARIABLE:A v1 v2 v3 b T0 s
linconb = [0 A 0 v2 .0001 0];
linconA = zeros(length(linconb),length(param));

%set constraints
linconA(1,1) = -1;  % -1*A <= 0 is same as 1*A >= 0
linconA(2,2) = -1;  % -1*b <= A is same as 1*b >= A
linconA(3,3) = -1;  % -1*v1 <= 0 is same as 1*v1 >= 0
linconA(4,4) = -1;  % -1*v1 <= v2 is same as 1*v1 >= v2
linconA(5,5) = -1;  % -1*s <= .0001 is same as 1*s >= .0001
linconA(6,6) = -1;  % -1*T0 <= 0 is same as 1*T0 >= 0

 lb = [0;0;0;0;.0001;0];
 ub = [inf;inf;1;1;inf;inf];
 options = optimset('MaxIter', 100000,'MaxFunEvals', 100000,'algorithm','interior-point');
 [solution minval] = fmincon(@(param) calcChi(param,SRT,trls_correct,trls_err,defectiveCDF_observed),param,linconA,linconb,[],[],lb,ub,[],options);
% 


% 


% %use fminsearch to minimize -LL (because we actually want to maximize LL)
% options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
% [solution minval] = fminsearch(@(param) calcChi(param,SRT,trls_correct,trls_err, ...
%     defectiveCDF_observed),[param],[options]);


%debugging
A = .000001;
b = 150;
v1 = .6;
v2 = .45;
s = .10;
T0 = 200;
% 
% A = solution(1);
% b = solution(2);
% v1 = solution(3);
% v2 = solution(4);
% s = solution(5);
% T0 = solution(6);

t = 1:1000;

f_correct(:,1) = linearballisticPDF(t,A,b,v1,s);
f_err(:,1) = linearballisticPDF(t,A,b,v2,s);


%CDF
F_correct(:,1) = linearballisticCDF(t,A,b,v1,s);
F_err(:,1) = linearballisticCDF(t,A,b,v2,s);



defectivePDF_correct_predicted(1:length(t),1) = f_correct .* (1-F_err);
defectiveCDF_correct_predicted(1:length(t),1) = cumsum(defectivePDF_correct_predicted);

defectivePDF_err_predicted(1:length(t),1) = f_err .* (1-F_correct);
defectiveCDF_err_predicted(1:length(t),1) = cumsum(defectivePDF_err_predicted);

if plotFlag
    figure
    plot(defectiveCDF_observed.correct(:,1),defectiveCDF_observed.correct(:,2),'ok', ...
        defectiveCDF_observed.err(:,1),defectiveCDF_observed.err(:,2),'ok')
    hold on
    plot(t,defectiveCDF_correct_predicted,'k',t,defectiveCDF_err_predicted,'k')
end

function [Chisq] = calcChi(param,SRT,trls_correct,trls_err,defectiveCDF_observed)
global T

A = param(1);
b = param(2);
v1 = param(3);
v2 = param(4);
s = param(5);
T0 = param(6);

SRT_correct = sort(SRT(trls_correct,1));
SRT_err = sort(SRT(trls_err,1));

%remove NaNs
SRT_correct(find(isnan(SRT_correct))) = [];
SRT_err(find(isnan(SRT_err))) = [];

SRT_correct = SRT_correct - T0;
SRT_err = SRT_err - T0;

drift1 = v1;
drift2 = v2;


%positive real line will be 1:1000;
t = 1:1000;

%PDF
f_correct(:,1) = linearballisticPDF(t,A,b,drift1,s);
f_err(:,1) = linearballisticPDF(t,A,b,drift2,s);


%CDF
F_correct(:,1) = linearballisticCDF(t,A,b,drift1,s);
F_err(:,1) = linearballisticCDF(t,A,b,drift2,s);


%calculate predicted defective CDFs
%only 2 units, no product necessary
defectivePDF_correct_predicted(1:length(t),1) = f_correct .* (1-F_err);
defectiveCDF_correct_predicted(1:length(t),1) = cumsum(defectivePDF_correct_predicted);

defectivePDF_err_predicted(1:length(t),1) = f_err .* (1-F_correct);
defectiveCDF_err_predicted(1:length(t),1) = cumsum(defectivePDF_err_predicted);


indices_correct = ceil((.1:.1:.9) .* length(t));
indices_err = ceil((.1:.1:.9) .* length(t));

bins_correct = t(indices_correct);
bins_err = t(indices_err);


% Accuracy rates are normalized to response probability

y_axis_correct = defectiveCDF_correct_predicted(indices_correct);
y_axis_err = defectiveCDF_err_predicted(indices_err);

% Calculate Chi-Square
X1 = sum((defectiveCDF_observed.correct(:,2) - y_axis_correct).^2 ./ y_axis_correct);
X2 = sum((defectiveCDF_observed.err(:,2) - y_axis_err).^2 ./ y_axis_err);
Chisq = X1+X2;
T = T + 1;
% if mod(T,100) == 0
% plot(defectiveCDF_observed.correct(:,1),defectiveCDF_observed.correct(:,2),'ok',defectiveCDF_observed.err(:,1),defectiveCDF_observed.err(:,2),'ok',bins_correct,y_axis_correct,'k',bins_err,y_axis_err,'k')
% pause
% end