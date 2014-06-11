% Fits a theoretical distribution to an empirical distribution using maximum likelihood estimation
% First input is always vector of observed data
% Last input is always the name of the theoretical distribution
% Middle inputs are initial guesses for the parameters of the model being fit,
% the number of which depends on the model being fit.
%
% example1: solution = fitModel(RT_vector,guess_mean,guess_std,guess_tau,'exGauss')
% example2: solution = fitModel(RT_vector,guess_mean,guess_std,'norm')
%
% RPH

function [solution minval AIC BIC predicted_PDF] = fitModel(varargin)

plotFlag = 1;

data = varargin{1};

if ~isvector(data); error('RT distribution should be a vector'); end

%make sure there are no NaN's
data(find(isnan(data))) = [];


model_name = varargin{length(varargin)};

%disp(['Fitting ' model_name ' Distribution'])

for var = 2:length(varargin)-1
    param(var-1,1)= varargin{var};
end


%use fminsearch to minimize -LL (because we actually want to maximize LL)

options = optimset('MaxIter', 100000,'MaxFunEvals', 100000);
[solution minval] = fminsearch(@(param) fitModel_calcLL(param,data,model_name),[param],[options]);

% options = gaoptimset('Generations',1000,'StallGenLimit',1000,'TolFun',1e-10);
% options = gaoptimset(options,'HybridFcn', {  @fminsearch [] });
% options = gaoptimset(options,'PopulationSize',[ones(1,numel(param))*30],'Display','iter','useparallel','always');
%
% lower = [0 0 0];
% upper = [1000 1000 1000];
% [solution minval] = ga(@(param) fitModel_calcLL(param,data,model_name),numel(param),[],[],[],[],lower,upper,[],[],options);
%
%

%convert back to positive number for LL
LL = -minval;

n_free = numel(param);
n_obs = size(data,1);
LL = -minval; %reset back to positive number, since we minimized the negative to maximize the positive
[AIC BIC] = aicbic(LL,n_free,n_obs);



%create observed cdf
d = sort(data);
indices = ceil((.1:.1:.9) .* length(d));
bins = d(indices);

%get the predicted PDF & CDFs based on output from fminsearch
if strmatch('norm',model_name,'exact')
    predicted_CDF = normcdf(data,solution(1),solution(2));
    predicted_PDF = normpdf(d,solution(1),solution(2));
elseif strmatch('weib',model_name,'exact')
    predicted_CDF = wblcdf(data,solution(1),solution(2));
    predicted_PDF = wblpdf(d,solution(1),solution(2));
elseif strmatch('exp',model_name,'exact')
    predicted_CDF = expcdf(data,solution(1));
    predicted_PDF = exppdf(d,solution(1));
elseif strmatch('exGauss',model_name,'exact')
    predicted_CDF = exGaussCDF(data,solution(1),solution(2),solution(3));
    predicted_PDF = exGaussPDF(d,solution(1),solution(2),solution(3));
elseif strmatch('Poisson',model_name,'exact')
    predicted_CDF = poisscdf(data,solution);
    predicted_PDF = poisspdf(d,solution);
end

if plotFlag == 1
    figure
    set(gcf,'color','white')
    
    subplot(1,2,1)
    plot(bins,.1:.1:.9,'bo','markersize',10,'linewidth',2)
    title(['N = ' mat2str(length(data))])
    ylim([0 1])
    
    hold on
    plot(d,sort(predicted_CDF),'r','linewidth',2)
    box off
    
    xlabel('Reaction Time (ms)','fontsize',15,'fontweight','bold')
    ylabel('Cumulative Distribution Function','fontsize',15,'fontweight','bold')
    
    
    % now plot empirical density function using histogram.  Requires
    % normalization to both class width and number of total observations
    subplot(1,2,2)
    [cnts,bns] = hist(data,15);
    interval = diff(bns);
    interval = interval(1); %what is the interval size in ms?
    
    rescaled = (cnts ./ interval) ./ length(data);
    bar(bns,rescaled,'barwidth',1,'facecolor','b')
    
    hold on
    plot(d,predicted_PDF,'r','linewidth',2)
    
    ylabel('Probability Density','fontsize',15,'fontweight','bold')
    xlabel('Reaction Time (ms)','fontsize',15,'fontweight','bold')
    title(['LL = ' mat2str(  round(LL*100) / 100)])
    box off
    
    %stretch for viewing
    set(gcf,'position',[619 700 1093 425])
end