% Returns a defective CDF
% dCDF normalized not to 1 but to response probability (or, overall error rate)
% Optional second output is normalized to 1.
%
% RPH

function [dCDF,CDF] = getDefectiveCDF(trls_correct,trls_err,SRT,plotFlag,ntiles)

zTrans = 0;

if zTrans; disp('Computing Z-scores'); end

if isempty(trls_correct) || isempty(trls_err)
    CDF.correct = NaN;
    CDF.err = NaN;
    dCDF.correct = NaN;
    dCDF.err = NaN;
    return
end

if nargin < 5; ntiles = .1:.1:.9; end
if nargin < 4; plotFlag = 0; end
if nargin < 3
    SRT = evalin('caller','SRT');
end

if zTrans
    correct_SRT = sort(SRT(trls_correct,1));
    err_SRT = sort(SRT(trls_err,1));
    
    correct_SRT(find(isnan(correct_SRT))) = [];
    err_SRT(find(isnan(err_SRT))) = [];
    
    correct_SRT = zscore(correct_SRT,1);
    err_SRT = zscore(err_SRT,1);
else
    correct_SRT = sort(SRT(trls_correct,1));
    err_SRT = sort(SRT(trls_err,1));
    
    correct_SRT(find(isnan(correct_SRT))) = [];
    err_SRT(find(isnan(err_SRT))) = [];
end
resp_prob_correct = length(trls_correct) / ( length(trls_correct) + length(trls_err) );
resp_prob_err = 1 - resp_prob_correct;


indices_correct = ceil((ntiles) .* length(correct_SRT));
indices_err = ceil((ntiles) .* length(err_SRT));

% indices_correct = [1 ceil((.1:.1:1) .* length(correct_SRT))];
% indices_err = [1 ceil((.1:.1:1) .* length(err_SRT))];

bins_correct = correct_SRT(indices_correct);
bins_err = err_SRT(indices_err);


% Accuracy rates are normalized to response probability

y_axis_correct = (ntiles) .* resp_prob_correct;
y_axis_err = (ntiles) .* resp_prob_err;

% y_axis_correct = [0 (.1:.1:1) .* resp_prob_correct];
% y_axis_err = [0 (.1:.1:1) .* resp_prob_err];


dCDF.correct(:,1) = bins_correct;
dCDF.correct(:,2) = y_axis_correct;
dCDF.err(:,1) = bins_err;
dCDF.err(:,2) = y_axis_err;

CDF.correct(:,1) = bins_correct;
CDF.correct(:,2) = ntiles;
CDF.err(:,1) = bins_err;
CDF.err(:,2) = ntiles;

if plotFlag
    figure
    plot(bins_correct,y_axis_correct,'-ok',bins_err,y_axis_err,'--ok')
    fon
    title('Defective CDF')
end