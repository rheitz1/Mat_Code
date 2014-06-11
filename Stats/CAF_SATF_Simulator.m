%function [] = CAF_SATF_Simulator() 
% Making this a void function just so that I can use a local 'multiHist' function embedded below
% Doing so will eliminate variables from workspace before returning.  Have to comment out the above as 
% well as the local function if want to keep variables in workspace

% CAF & SATF Simulator
% Idea came from Wood & Jennings (1976).
%
% Assumpations:
% 1) SAT was induced by method of response deadlines
% 2) Deadlines were missed at a constant rate of prc_missed. This is not really
%   reasonable and should be modified later to increase in proportion as deadline decreases.
%   Functionally, it specifies the *real* RT mean, by placing it at some z-value. 
% 3) Error rate is unrelated to prc_missed;  That is, "cognitive state" is constant for both made and
%   missed deadlines with a block
% 4) RT distributions are distributed normally (later, change to exGaussian)
% 5) *** there is a flat micro-SAT -- that is, the CAF is flat inside any deadline condition.  This way,
%   I do not need to specify a prior how the errors are distributed with respect to RT within a deadline
%   condition.  However, I can control the PERCENT of errors within each deadline condition overall,
%   which I will assume is always increasing.  That I believe is fair.
% 
% KEY MANIPULATIONS
% A) Vector of effect sizes separating mean RT for each deadline condition
% B) Vector of standard deviations for each deadline condition
% C) Direction of error RT: fast errors or slow errors, and their magnitude
%
% RPH

%=========================================================
%clear all
seed = 5150;

rand('seed',seed);
randn('seed',seed);
normrnd('seed',seed);


N_obs = 10000;


% Set parameters
%deadline_vector = [215 240 260 280 310]; %values of the deadline conditions
deadline_vector = [200 300 400];
sd_vector_correct = 20 * ones(1,length(deadline_vector));%[40 40 40 40 40 40];
sd_vector_error = 20 * ones(1,length(deadline_vector));%[40 40 40 40 40 40];
error_RT_shift = -5* ones(1,length(deadline_vector));%[-25 -25 -25 -25 -25 -25];
prc_missed = .20 * ones(1,length(deadline_vector)) + .001;%[.2 .2 .2 .2 .2 .2] + .001; %proportion of trials that were 'missed deadlines'. +.001 to avoid inf
prc_correct = linspace(.5,.9,length(deadline_vector)); %generate mean DEADLINE accuracy rates as a a linear spacing between 55 & 95% correct

exponential_component = .5; %exponential component of exGauss will be sigma + sigma*x


%preallocate
RTD.correct = NaN(N_obs,length(deadline_vector));
RTD.error = NaN(N_obs,length(deadline_vector));
predPDF.correct = NaN(N_obs,length(deadline_vector));
predPDF.error = NaN(N_obs,length(deadline_vector));
% Generate *real* mean RT for CORRECT RT distribution for each deadline. Takes into consideration the
% percentage of deadlines missed.  Note that this will have unpredictable effects relative to
% error_RT_shift.

Correct_mean_RTs = norminv(prc_missed,deadline_vector,sd_vector_correct);
%Correct_mean_RTs = deadline_vector;

for d = 1:length(deadline_vector)
    %generate N_obs * prc_correct (in deadline) correct RTs
    %RTD.correct(1:floor(N_obs*prc_correct(d)),d) = normrnd(Correct_mean_RTs(d),sd_vector_correct(d),floor(N_obs*prc_correct(d)),1);
    RTD.correct(1:floor(N_obs*prc_correct(d)),d) = exgaussrnd(Correct_mean_RTs(d),sd_vector_correct(d),sd_vector_correct(d) + sd_vector_correct(d)*exponential_component,floor(N_obs*prc_correct(d)),1);
    %[params.correct(1:3,d),~,~,~,predPDF.correct(1:length(find(~isnan(RTD.correct(:,d)))),d)] = fitModel(RTD.correct(:,d),nanmean(RTD.correct(:,d)),nanstd(RTD.correct(:,d)),nanstd(RTD.correct(:,d)),'exGauss');
    %[a b c d e] = fitModel(RTD.correct(:,d),nanmean(RTD.correct(:,d)),nanstd(RTD.correct(:,d)),nanstd(RTD.correct(:,d)),'exGauss');
end

% Generate error RT distributions by shifting the real Correct_mean_RTs after accounting for prc_missed

for d = 1:length(deadline_vector)
    %generate N_obs * 1-prc_correct (in deadline) correct RTs
    %RTD.error(1:floor(N_obs*(1-prc_correct(d))),d) = normrnd(Correct_mean_RTs(d) + error_RT_shift(d),sd_vector_error(d),floor(N_obs * (1-prc_correct(d))),1);
    RTD.error(1:floor(N_obs*(1-prc_correct(d))),d) = exgaussrnd(Correct_mean_RTs(d) + error_RT_shift(d),sd_vector_error(d),sd_vector_error(d) + sd_vector_error(d)*exponential_component,floor(N_obs * (1-prc_correct(d))),1);
    %[params.error(1:3,d),~,~,~,predPDF.error(1:length(find(~isnan(RTD.error(:,d)))),d)] = fitModel(RTD.error(:,d),nanmean(RTD.error(:,d)),nanstd(RTD.error(:,d)),nanstd(RTD.error(:,d)),'exGauss');
end

%=========================
% SATF
SATF.RT = nanmean([RTD.correct ; RTD.error]);
SATF.ACC = sum(~isnan(RTD.correct)) ./ (sum(~isnan(RTD.correct)) + sum(~isnan(RTD.error)));

CAF_Data = [RTD.correct(:) ones(size(RTD.correct(:),1),1) ; RTD.error(:) zeros(size(RTD.error(:),1),1)];

%Remove 0 values from RT variable
CAF_Data(find(CAF_Data(:,1) == 0),1:2) = NaN;
CAF_Data = removeNaN(CAF_Data);

% Correct_ = repmat(CAF_Data(:,2),1,2);
% Errors_ = NaN(size(Correct_,1),8);

%compute overall CAF (LOC)
[allCAF.RT allCAF.ACC allCAF.ODDS] = CAF(CAF_Data(:,1),CAF_Data(:,2),5,0);

%compute micro-CAF
for d = 1:length(deadline_vector)
    [dCAF.RT(:,d) dCAF.ACC(:,d) dCAF.ODDS(:,d)] = CAF([RTD.correct(:,d) ; RTD.error(:,d)],[ones(size(RTD.correct(:,d),1),1) ; zeros(size(RTD.error(:,d),1),1)],5);
end


% figure
multiHist(50,RTD.correct(:),RTD.error(:)) %NOTE THAT THE HISTOGRAMS ARE NOT QUITE SCALED CORRECTLY BUT PATTERN WILL BE THE SAME
xlim([0 600])
%hold on
%plot(sort(RTD.correct),predPDF.correct,'b',sort(RTD.error),predPDF.error,'r')
%newax
subplot(5,1,1:3)
plot(SATF.RT,SATF.ACC,'-ok','linewidth',2)
hold on
plot(allCAF.RT,allCAF.ACC,'-or','linewidth',2)
plot(dCAF.RT,dCAF.ACC,'-ok')
box off
ylim([.3 1])
xlim([0 600])
text(150,.95,['deadlines = ' mat2str(deadline_vector)])
text(150,.90,['sd correct = ' mat2str(sd_vector_correct)])
text(150,.85,['sd error = ' mat2str(sd_vector_error)])
text(150,.80,['err shift = ' mat2str(error_RT_shift)])



%=========================================================================
% Over-loaded function [different format than usual for current purposes]
% % 
% % function [] = multiHist(binsize,varargin)
% % 
% % if nargin < 2; binsize = 30; end
% % 
% % for var = 1:length(varargin)
% %     [n(1:binsize,var) x(1:binsize,var)] = hist(varargin{var},binsize);
% %     %n_rescaled(1:binsize,var) = (n(:,var)./binsize)./numel(varargin{var});
% %     
% %     %edited 1/25/14 RPH: normalize by ALL input observations/conditions
% %     n_rescaled(1:binsize,var) = (n(:,var)./binsize)./sum(cellfun(@numel,varargin)); 
% % end
% % 
% % 
% % color = {'b','r','g','k','m','y','b','r','g','k','m','y'};
% % 
% % figure
% % subplot(5,1,4:5)
% % % % % subplot(121)
% % % % % %superimposed histogram
% % % % % hold on
% % % % % 
% % % % % for var = 1:length(varargin)
% % % % %     bar(x(:,var),n(:,var),color{var})
% % % % % end
% % % % % 
% % % % % 
% % % % % %manually go through and change first histogram to transparent with thicker
% % % % % %edges
% % % % % h = findobj(gca,'Type','patch');
% % % % % set(h(1),'facecolor','none')
% % % % % set(h(1),'edgecolor',color{var})
% % % % % set(h(1),'linewidth',1)
% % % % % ylabel('N')
% % % % % 
% % % % % subplot(122)
% % hold on
% % 
% % for var = 1:length(varargin)
% %     bar(x(:,var),n_rescaled(:,var),color{var})
% % end
% % 
% % 
% % %manually go through and change first histogram to transparent with thicker
% % %edges
% % h = findobj(gca,'Type','patch');
% % set(h(1),'facecolor','none')
% % set(h(1),'edgecolor',color{var})
% % set(h(1),'linewidth',1)
% % ylabel('Proportion')
% % 
% % % %side-by-side histogram
% % % subplot(2,1,2)
% % % bar(x,n)
% % % 
% % % title('Side-by-side Histogram')
% % % xlim([0 1500])
% % % 
% % % %for final graph, loop through and change color manually
% % % h = findobj(gca,'Type','patch');
% % % 
% % % for xh = 1:length(h)
% % %     set(h(xh),'FaceColor',color{xh},'EdgeColor',color{xh})
% % % end