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




function [solution] = linearballisticPDF(SRT,trls_correct,trls_err)
%linearballisticPDF(1:.01:100,.01,20,.4,1)
%%
plotFlag = 1;
A = .01;
b = 6;
v = .04;
s = .10;
% T0 = 100;
global T
T = 1;

SRT_correct = sort(SRT(trls_correct,1));
SRT_err = sort(SRT(trls_err,1));

%remove NaNs
SRT_correct(find(isnan(SRT_correct))) = [];
SRT_err(find(isnan(SRT_err))) = [];


defectiveCDF_observed = getDefectiveCDF(trls_correct,trls_err);

% param = [A b v s T0]; %s and T0 hard coded.  The rest are simply first guesses and will be estimated.
param = [A b v]; %s hard coded.  The rest are simply first guesses and will be estimated.

%use fminsearch to minimize -LL (because we actually want to maximize LL)
options = optimset('MaxIter', 1000000,'MaxFunEvals', 1000000);
[solution minval] = fminsearch(@(param) calcChi(param,SRT,trls_correct,trls_err, ...
    defectiveCDF_observed),[param],[options]);


A = solution(1);
b = solution(2);
v = solution(3);

f_correct(1:length(SRT_correct),1) = (1/A) .* (-v .* normcdf( (b-A-(SRT_correct.*v) ) ./ (SRT_correct.*s)  ) + s .* normpdf( (b-A-(SRT_correct.*v)) ./ (SRT_correct.*s)  ) ...
    + v * normcdf( (b-(SRT_correct.*v)) ./ (SRT_correct.*s)  ) - s .* normpdf( (b-(SRT_correct.*v)) ./ (SRT_correct.*s)  ));

f_err(1:length(SRT_err),1) = (1/A) .* (-v .* normcdf( (b-A-(SRT_err.*v) ) ./ (SRT_err.*s)  ) + s .* normpdf( (b-A-(SRT_err.*v)) ./ (SRT_err.*s)  ) ...
    + v * normcdf( (b-(SRT_err.*v)) ./ (SRT_err.*s)  ) - s .* normpdf( (b-(SRT_err.*v)) ./ (SRT_err.*s)  ));


F_correct(1:length(SRT_correct),1) = 1 ...
    + ( (b-A-(SRT_correct.*v)) ./ A ) .* (normcdf( (b-A-(SRT_correct.*v)) ./ (SRT_correct.*s) )) ...
    - ( (b-(SRT_correct.*v)) ./ A ) .* (normcdf( (b-(SRT_correct.*v)) ./ (SRT_correct.*s) )) ...
    + ( (SRT_correct.*s) ./ A ) .* (normpdf( (b-A-(SRT_correct.*v)) ./ (SRT_correct.*s) )) ...
    - ( (SRT_correct.*s) ./ A ) .* (normpdf( (b-(SRT_correct.*v)) ./ (SRT_correct.*s) ));

F_err(1:length(SRT_err),1) = 1 ...
    + ( (b-A-(SRT_err.*v)) ./ A ) .* (normcdf( (b-A-(SRT_err.*v)) ./ (SRT_err.*s) )) ...
    - ( (b-(SRT_err.*v)) ./ A ) .* (normcdf( (b-(SRT_err.*v)) ./ (SRT_err.*s) )) ...
    + ( (SRT_err.*s) ./ A ) .* (normpdf( (b-A-(SRT_err.*v)) ./ (SRT_err.*s) )) ...
    - ( (SRT_err.*s) ./ A ) .* (normpdf( (b-(SRT_err.*v)) ./ (SRT_err.*s) ));

defectivePDF_correct_predicted(1:length(SRT_correct),1) = f_correct .* (1-F_correct);
defectiveCDF_correct_predicted(1:length(SRT_correct),1) = cumsum(defectivePDF_correct_predicted);

defectivePDF_err_predicted(1:length(SRT_err),1) = f_err .* (1-F_err);
defectiveCDF_err_predicted(1:length(SRT_err),1) = cumsum(defectivePDF_err_predicted);

if plotFlag
    figure
    plot(defectiveCDF_observed.correct(:,1),defectiveCDF_observed.correct(:,2),'ok', ...
        defectiveCDF_observed.err(:,1),defectiveCDF_observed.err(:,2),'ok')
    hold on
    plot(SRT_correct,defectiveCDF_correct_predicted,'k',SRT_err,defectiveCDF_err_predicted,'k')
end

function [Chisq] = calcChi(param,SRT,trls_correct,trls_err,defectiveCDF_observed)
global T

A = param(1);
b = param(2);
v = param(3);
s = .10;
% T0 = param(5);

SRT_correct = sort(SRT(trls_correct,1));
SRT_err = sort(SRT(trls_err,1));

%remove NaNs
SRT_correct(find(isnan(SRT_correct))) = [];
SRT_err(find(isnan(SRT_err))) = [];

% A = rand * A;
% drift1 = normrnd(v,s);
% drift2 = normrnd(v,s);
drift1 = v;
drift2 = v;

%PDF
f_correct(1:length(SRT_correct),1) = (1/A) .* (-drift1 .* normcdf( (b-A-(SRT_correct.*drift1) ) ./ (SRT_correct.*s)  ) + s .* normpdf( (b-A-(SRT_correct.*drift1)) ./ (SRT_correct.*s)  ) ...
    + drift1 * normcdf( (b-(SRT_correct.*drift1)) ./ (SRT_correct.*s)  ) - s .* normpdf( (b-(SRT_correct.*drift1)) ./ (SRT_correct.*s)  ));

f_err(1:length(SRT_err),1) = (1/A) .* (-drift2 .* normcdf( (b-A-(SRT_err.*drift2) ) ./ (SRT_err.*s)  ) + s .* normpdf( (b-A-(SRT_err.*drift2)) ./ (SRT_err.*s)  ) ...
    + drift2 * normcdf( (b-(SRT_err.*drift2)) ./ (SRT_err.*s)  ) - s .* normpdf( (b-(SRT_err.*drift2)) ./ (SRT_err.*s)  ));

%CDF
F_correct(1:length(SRT_correct),1) = 1 ...
    + ( (b-A-(SRT_correct.*drift1)) ./ A ) .* (normcdf( (b-A-(SRT_correct.*drift1)) ./ (SRT_correct.*s) )) ...
    - ( (b-(SRT_correct.*drift1)) ./ A ) .* (normcdf( (b-(SRT_correct.*drift1)) ./ (SRT_correct.*s) )) ...
    + ( (SRT_correct.*s) ./ A ) .* (normpdf( (b-A-(SRT_correct.*drift1)) ./ (SRT_correct.*s) )) ...
    - ( (SRT_correct.*s) ./ A ) .* (normpdf( (b-(SRT_correct.*drift1)) ./ (SRT_correct.*s) ));

F_err(1:length(SRT_err),1) = 1 ...
    + ( (b-A-(SRT_err.*drift2)) ./ A ) .* (normcdf( (b-A-(SRT_err.*drift2)) ./ (SRT_err.*s) )) ...
    - ( (b-(SRT_err.*drift2)) ./ A ) .* (normcdf( (b-(SRT_err.*drift2)) ./ (SRT_err.*s) )) ...
    + ( (SRT_err.*s) ./ A ) .* (normpdf( (b-A-(SRT_err.*drift2)) ./ (SRT_err.*s) )) ...
    - ( (SRT_err.*s) ./ A ) .* (normpdf( (b-(SRT_err.*drift2)) ./ (SRT_err.*s) ));



%calculate predicted defective CDFs

%only 2 units, no product necessary
defectivePDF_correct_predicted(1:length(SRT_correct),1) = f_correct .* (1-F_correct);
defectiveCDF_correct_predicted(1:length(SRT_correct),1) = cumsum(defectivePDF_correct_predicted);

defectivePDF_err_predicted(1:length(SRT_err),1) = f_err .* (1-F_err);
defectiveCDF_err_predicted(1:length(SRT_err),1) = cumsum(defectivePDF_err_predicted);


indices_correct = ceil((.1:.1:.9) .* length(SRT_correct));
indices_err = ceil((.1:.1:.9) .* length(SRT_err));

bins_correct = SRT_correct(indices_correct);
bins_err = SRT_err(indices_err);


% Accuracy rates are normalized to response probability

y_axis_correct = defectiveCDF_correct_predicted(indices_correct);
y_axis_err = defectiveCDF_err_predicted(indices_err);

% Calculate Chi-Square
X1 = sum((defectiveCDF_observed.correct(:,2) - y_axis_correct).^2 ./ y_axis_correct);
X2 = sum((defectiveCDF_observed.err(:,2) - y_axis_err).^2 ./ y_axis_err);
Chisq = X1+X2;
T = T + 1;
% if mod(T,10) == 0
% plot(defectiveCDF_observed.correct(:,1),defectiveCDF_observed.correct(:,2),'ok',defectiveCDF_observed.err(:,1),defectiveCDF_observed.err(:,2),'ok',bins_correct,y_axis_correct,'k',bins_err,y_axis_err,'k')
% pause
% end