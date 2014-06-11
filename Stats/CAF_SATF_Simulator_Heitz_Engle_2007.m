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


%=========================================================
clear all
cd /volumes/Dump/Flankers_Data_GT/
load Flankers_5050_8020_incompat_only.mat

dat(find(dat(:,2) < 150),2) = NaN;
 
N_obs = 10000;


% Set parameters
%deadline_vector = [225 245 250 275 325]; %values of the deadline conditions
deadline_vector = [200:100:700];

[solution200_correct] = fitModel(dat(find(dat(:,3) == 200 & dat(:,1) == 1),2),nanmean(dat(find(dat(:,3) == 200 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 200 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 200 & dat(:,1) == 1),2)),'exGauss')
[solution300_correct] = fitModel(dat(find(dat(:,3) == 300 & dat(:,1) == 1),2),nanmean(dat(find(dat(:,3) == 300 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 300 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 300 & dat(:,1) == 1),2)),'exGauss')
[solution400_correct] = fitModel(dat(find(dat(:,3) == 400 & dat(:,1) == 1),2),nanmean(dat(find(dat(:,3) == 400 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 400 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 400 & dat(:,1) == 1),2)),'exGauss')
[solution500_correct] = fitModel(dat(find(dat(:,3) == 500 & dat(:,1) == 1),2),nanmean(dat(find(dat(:,3) == 500 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 500 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 500 & dat(:,1) == 1),2)),'exGauss')
[solution600_correct] = fitModel(dat(find(dat(:,3) == 600 & dat(:,1) == 1),2),nanmean(dat(find(dat(:,3) == 600 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 600 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 600 & dat(:,1) == 1),2)),'exGauss')
[solution700_correct] = fitModel(dat(find(dat(:,3) == 700 & dat(:,1) == 1),2),nanmean(dat(find(dat(:,3) == 700 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 700 & dat(:,1) == 1),2)),nanstd(dat(find(dat(:,3) == 700 & dat(:,1) == 1),2)),'exGauss')


[solution200_error] = fitModel(dat(find(dat(:,3) == 200 & dat(:,1) == 0),2),nanmean(dat(find(dat(:,3) == 200 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 200 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 200 & dat(:,1) == 0),2)),'exGauss')
[solution300_error] = fitModel(dat(find(dat(:,3) == 300 & dat(:,1) == 0),2),nanmean(dat(find(dat(:,3) == 300 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 300 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 300 & dat(:,1) == 0),2)),'exGauss')
[solution400_error] = fitModel(dat(find(dat(:,3) == 400 & dat(:,1) == 0),2),nanmean(dat(find(dat(:,3) == 400 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 400 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 400 & dat(:,1) == 0),2)),'exGauss')
[solution500_error] = fitModel(dat(find(dat(:,3) == 500 & dat(:,1) == 0),2),nanmean(dat(find(dat(:,3) == 500 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 500 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 500 & dat(:,1) == 0),2)),'exGauss')
[solution600_error] = fitModel(dat(find(dat(:,3) == 600 & dat(:,1) == 0),2),nanmean(dat(find(dat(:,3) == 600 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 600 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 600 & dat(:,1) == 0),2)),'exGauss')
[solution700_error] = fitModel(dat(find(dat(:,3) == 700 & dat(:,1) == 0),2),nanmean(dat(find(dat(:,3) == 700 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 700 & dat(:,1) == 0),2)),nanstd(dat(find(dat(:,3) == 700 & dat(:,1) == 0),2)),'exGauss')

mean_vector_correct = [solution200_correct(1) solution300_correct(1) solution400_correct(1) solution500_correct(1) solution600_correct(1) solution700_correct(1)];
sd_vector_correct = [solution200_correct(2) solution300_correct(2) solution400_correct(2) solution500_correct(2) solution600_correct(2) solution700_correct(2)];
tau_vector_correct = [solution200_correct(3) solution300_correct(3) solution400_correct(3) solution500_correct(3) solution600_correct(3) solution700_correct(3)];

mean_vector_error = [solution200_error(1) solution300_error(1) solution400_error(1) solution500_error(1) solution600_error(1) solution700_error(1)];
sd_vector_error = [solution200_error(2) solution300_error(2) solution400_error(2) solution500_error(2) solution600_error(2) solution700_error(2)];
tau_vector_error = [solution200_error(3) solution300_error(3) solution400_error(3) solution500_error(3) solution600_error(3) solution700_error(3)];

prc_correct = [nanmean(dat(find(dat(:,3) == 200),1)) ...
    nanmean(dat(find(dat(:,3) == 300),1)) ...
    nanmean(dat(find(dat(:,3) == 400),1)) ...
    nanmean(dat(find(dat(:,3) == 500),1)) ...
    nanmean(dat(find(dat(:,3) == 600),1)) ...
    nanmean(dat(find(dat(:,3) == 700),1))];



%preallocate
RTD.correct = NaN(N_obs,length(deadline_vector));
RTD.error = NaN(N_obs,length(deadline_vector));

% Generate *real* mean RT for CORRECT RT distribution for each deadline. Takes into consideration the
% percentage of deadlines missed.  Note that this will have unpredictable effects relative to
% error_RT_shift.

%Correct_mean_RTs = norminv(prc_missed,deadline_vector,sd_vector);
Correct_mean_RTs = deadline_vector;

for d = 1:length(deadline_vector)
    %generate N_obs * prc_correct (in deadline) correct RTs
    %RTD.correct(1:floor(N_obs*prc_correct(d)),d) = normrnd(Correct_mean_RTs(d),sd_vector(d),floor(N_obs*prc_correct(d)),1);
    RTD.correct(1:floor(N_obs*prc_correct(d)),d) = exgaussrnd(mean_vector_correct(d),sd_vector_correct(d),tau_vector_correct(d),floor(N_obs*prc_correct(d)),1);
                                                   
end

% Generate error RT distributions by shifting the real Correct_mean_RTs after accounting for prc_missed

for d = 1:length(deadline_vector)
    %generate N_obs * 1-prc_correct (in deadline) correct RTs
    RTD.error(1:floor(N_obs*(1-prc_correct(d))),d) = exgaussrnd(mean_vector_error(d),sd_vector_error(d),tau_vector_error(d),floor(N_obs * (1-prc_correct(d))),1);
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
    [dCAF.RT(:,d) dCAF.ACC(:,d) dCAF.ODDS(:,d)] = CAF([RTD.correct(:,d) ; RTD.error(:,d)],[ones(size(RTD.correct(:,d),1),1) ; zeros(size(RTD.error(:,d),1),1)],3);
end


figure
multiHist(50,RTD.correct(:),RTD.error(:))
newax
plot(SATF.RT,SATF.ACC,'-ok','linewidth',2)
hold on
plot(allCAF.RT,allCAF.ACC,'-or','linewidth',2)
plot(dCAF.RT,dCAF.ACC,'-ok')
box off
ylim([.4 1])