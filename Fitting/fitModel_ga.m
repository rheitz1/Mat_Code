%
function [solution] = fitModel_ga(varargin)

plotFlag = 1;

data = varargin{1};

%make sure there are no NaN's

data(find(isnan(data))) = [];

model_name = varargin{length(varargin)};

disp(['Fitting ' model_name ' Distribution'])

for var = 2:length(varargin)-1
    param(var-1,1)= varargin{var};
end


%now lets minimize -LL (because we actually want to maximize LL)

% Using genetic algorithm:
% options=gaoptimset('PopulationSize',[ones(1,10)*30],'HybridFcn','fminsearch');
%options=gaoptimset('HybridFcn',@(param) calcLL(param,data,model_name),[param]);
%options = gaoptimset('Generations',1000,'StallGenLimit',1000,...
%   'MigrationDirection','forward','TolFun',1e-10);
%options.PopInitRange = [0 0 0; 100 100 100];
%options = gaoptimset(options,'HybridFcn', {  @fminsearch [] });

options = gaoptimset('PopulationSize',[ones(1,10)],...
    'Generations',10,...
    'Display','iter', ...
    'UseParallel','always');


%solution = ga(@(param) fitModel_calcLL(param,data,model_name),length(param),options);
[solution minval] = ga(@(param) fitModel_calcLL(param,data,model_name),numel(param),[],[],[],[],[],[],[],options);
if plotFlag == 1
    
    %create observed cdf
    d = sort(data);
    indices = ceil((.1:.1:.9) .* length(d));
    bins = d(indices);
    
    %get the predicted CDF
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
    end
end



figure
set(gcf,'color','white')
subplot(1,2,1)
plot(bins,.1:.1:.9,'ko')
ylim([0 1])

hold on
plot(d,sort(predicted_CDF),'k')

ylabel('Cumulative Distribution Function','fontsize',12,'fontweight','bold')
title(['LL = ' mat2str(  round(minval*100) / 100)])

% now plot empirical density function using histogram.  Requires
% normalization to both class width and number of total observations
subplot(1,2,2)
[cnts,bns] = hist(data,30);
interval = diff(bns);
interval = interval(1); %what is the interval size in ms?

rescaled = (cnts ./ interval) ./ length(data);
bar(bns,rescaled)

hold on
plot(d,predicted_PDF,'r','linewidth',2)

ylabel('Probability Density','fontsize',12,'fontweight','bold')


end
