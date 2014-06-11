function [best_fit_params,lowest_SSE] = FitGaussian(xdata,ydata,weights,pops)
%   [best_fit_params,lowest_SSE] = FitGaussian(xdata,ydata,weights,pops)
%   
%   Given data which describe points on the x and y axes, FitGaussian uses a
%   genetic algorithm approach to find parameters which minimize sum of 
%   squares error based on the FitGaussian function:
% 
%               ydata=B+R*exp(-0.5*((xdata-Phi)/T).^2);
%
%   where,
%      B=baseline
%      R=max response (B+R=peak)
%      Phi=optimum response (i.e. mean)
%      T=tuning function (i.e. sd)
%
%   Modified from Weibull.m (david.c.godlove@vanderbilt.edu)
%   
%   INPUT:
%       xdata              = points on the x axis. (target location 0-7 or 
%                            angle of target [0 45 90 135 180 215 270 315].
%
%       ydata              = points on the y axis. (FR by target location)
%                            Note: code assumes that data are ordered such
%                            that maximum value is in the center of the
%                            so that Gaussian curve will fit.  A better
%                            methodology would be to use Von Mises
%                            distribution, but this is consistent with 
%                            Schall et al. (1995) J Neurophysiol.
%
%       weights            = the number of observations at each point
% 
%   OPTIONAL INPUT:
%       pops               = two value vector describing the starting
%                            number of individuals in each population and 
%                            the starting number of populations. (see ga.m)
%                            default = [60 3];
%       
%   OUTPUT:
%       best_fit_params    = four value vector containing optimum
%                            coeffecients such that:
%                            B = best_fit_params(1);
%                            R  = best_fit_params(2);
%                            Phi = best_fit_params(3);
%                            T = best_fit_params(4);
%
%       lowest_SSE         = sum of squares error of xdata and ydata at the
%                            best_fit_params value.
% 
%   see also ga and gaoptimset.  Also try searching help for "genetic algorithm options."

if nargin < 4, pops = [5 5 5]; end
if nargin < 3, weights = [];  end

%1) specify initial params.
B = min(ydata);                     %beta: baseline firing rate
R  = 2*(max(ydata)-min(ydata));     %max response (B+R=peak)
Phi = nanmean(xdata);               %Optimum response (i.e. mean of distribution)
T = 10;                              %Tuning function (i.e. sd of distribution)

params=[B R Phi T]; %must be in this format for ga.m

%specify [upper_bound lower_bound] on parameters
B_bounds=[min(ydata)-.1*min(ydata) min(ydata)+.1*min(ydata)];
peak_to_baseline=max(ydata)-min(ydata);
R_bounds=[peak_to_baseline-.1*peak_to_baseline peak_to_baseline+.1*peak_to_baseline];
Phi_bounds=[xdata(ydata==max(ydata))-.2*xdata(ydata==max(ydata)) xdata(ydata==max(ydata))+.2*xdata(ydata==max(ydata))];
T_bounds=[1 360];

lower_bounds = [min(B_bounds) min(R_bounds) min(Phi_bounds) min(T_bounds)];
upper_bounds = [max(B_bounds) max(R_bounds) max(Phi_bounds) max(T_bounds)];

%2) weight Data Points if called for
if ~isempty(weights)
    x_weighted = [];
    y_weighted = [];
    for iSSD=1:size(xdata)
        CurrWeighted_x = repmat(xdata(iSSD),weights(iSSD),1);
        CurrWeighted_y = repmat(ydata(iSSD),weights(iSSD),1);
            x_weighted = [x_weighted; CurrWeighted_x];
            y_weighted = [y_weighted; CurrWeighted_y];
    end
    xdata = x_weighted;
    ydata = y_weighted;
end

%3) set ga options
pop_number = pops(1);%length(pop_options)=number of populations, values = size of populations
pop_size = pops(2);  %more/larger populations means more thorough search of param space, but
                     %also longer run time.  [30 30 30] is probably bare minimum.
pop_options(1:pop_number) = pop_size;

hybrid_options=@fmincon;%run simplex after ga to refine parameters
% ga_options=gaoptimset('PopulationSize',pop_options,'HybridFcn',hybrid_options,'display','off','UseParallel','always');
ga_options=gaoptimset('PopulationSize',pop_options,'HybridFcn',hybrid_options,'display','off');

%4) run GA
%fit model
[best_fit_params,lowest_SSE]=ga(...
    @(params) Gaussian_error(xdata,ydata,params),...
    length(params),...
    [],[],[],[],...
    lower_bounds,...
    upper_bounds,...
    [],...
    ga_options);

%5)Debugging: test-plot
B=best_fit_params(1);
R=best_fit_params(2);
Phi=best_fit_params(3);
T=best_fit_params(4);
ypred=B+R*exp(-0.5*((xdata-Phi)/T).^2);

hold on
plot(xdata,ydata,'marker','o','linestyle','none')
plot(xdata,ypred,'k')

figure 
ydata=-ydata;
R=-R;
B=-B;
ypred=B+R*exp(-0.5*((xdata-Phi)/T).^2);

hold on
plot(xdata,ydata,'marker','o','linestyle','none')
plot(xdata,ypred,'k')

end



function [SSE] = Gaussian_error(xdata,ydata,params)
%This subfuction looks at the current data and parameters and figures out
%the sum of squares error.  The genetic fitting algorithm above tries to
%find params values to minimize SSE.

%get params
B =   params(1);
R  =  params(2);
Phi = params(3);
T =   params(4);

%generate predictions
ypred=B+R*exp(-0.5*((xdata-Phi)/T).^2);

%compute SSE
SSE=sum((ypred-ydata).^2);

end

 
