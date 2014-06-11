
close all;

RTcdf = [];
RTpred = [];
RTpred_hist = [];
RTpred_cdf = [];
RTobs_cdf = [];
RTpred_matrix = [];
SDF_in_average = [];
SDF_out_average = [];
Quant_diff_matrix = [];
Accuracy_vector = [];
RTpred_matrix = [];
SDF_diff_average = [];
SDF_in_average = [];
SDF_out_average = [];
%%%%%%%%%%%%%%%
%Currently you must define the RFs matrix prior to running this code
%The format is [CellNames x RFs], using nans as placeholders
%IMPORTANT: 
%1. nan's always go in last columns, first column should always be
%       the RF if one exists
%2. THE CELL NAMES WILL BE ALPHABETIZED, this is not the case in excel file
%%%%%%%%%%%%%%
%Choose options
%%%%%%%%%%%%%%
easy_hard = 1; % if 1, run all correct trials, if 2 run only easy trials, if 3 run only hard trials
Plot_mean_activity = 1; %0 = plot only nDraw, 1 = plot mean of all simulations
normalize = 0; % if 1, normalize activity (divide SDF by peak firing rate), if 0 use raw data
plots_on = 1; %0 = no plots, 1 = plots
nSims = 100; %number of simulations to run
nDraw = 15; %number of neurons to randomly draw and pool when calculating the SDF
Criterion = 15;%duh
selected_neuron = 2; %pick neuron from trial to plot(alphabetical order)
%%%%%%%%%%%%%%%
%set parameters
%%%%%%%%%%%%%%%
RTpred = zeros(nSims,1);%predicted RT vector
ACC = zeros(nSims,1);%accuracy vector 1 = correct, 0 = incorrect
SRT = Saccade_(:,1) - Target_(:,1);% observed RT vector, includes NaNs
SRT = SRT(~isnan(SRT));%observed RT vector with no NaNs
number_of_quantiles = 10;%number of quantiles
p = 1/number_of_quantiles;
Align_Time_ = Target_(:,1); %aligned on target onset
Plot_Time=[-500 1000];
bins = [Plot_Time(1):Plot_Time(2)];

%%%%%%%%%%%%%%%%%%%%
%get list of neurons
%%%%%%%%%%%%%%%%%%%%
varlist = who;
cellID = varlist(strmatch('DSP',varlist));
%Cut out any string ending in i
m = 1;
for j = 1:length(cellID);
    if isempty(strfind(cell2mat(cellID(j)),'i')>0);
        CellNames(m,1) = cellID(j);
        m = m+1;
    end
end
%result = CellNames vector with list of all DSP... cells in this file

%Initialize variables that were dependent on number of neurons in a session
%i.e. dependent on length(CellNames)
Quant_diff_matrix = zeros(length(CellNames),number_of_quantiles);%saves quantile difference vector as loop cycles through cells
Qvector_obs_matrix = zeros(length(CellNames),number_of_quantiles);
Qvector_pred_matrix = zeros(length(CellNames),number_of_quantiles);
Accuracy_vector = zeros(length(CellNames),1);
RTpred_matrix = zeros(length(CellNames),length(bins));
SDF_diff_average = zeros(length(CellNames),length(bins));
SDF_in_average = zeros(length(CellNames),length(bins));
SDF_out_average = zeros(length(CellNames),length(bins));




%BEGIN: multi cell loop

%%%%%%%%%%%%%%
%Establish RT vector for current neuron
% RFs = matrix(cells x RFvector), where NaN is placeholder
%%%%%%%%%%%%%%
for cell_num = 1:length(CellNames)
    ACC = [];
    skip_cell = 0;%initialize skip_cell command
% if all RFs are NaN (as indicated by first column) then skip this cell
% entirely.  Resulting entries in quantile matrix will just be zeros.
    if isnan(RFs(cell_num,1))
        skip_cell = 1;
    end
if skip_cell == 0
    current_cell = eval(cell2mat(CellNames(cell_num))); %cell spike data = current_cell
        RFs_cell = zeros(1,length(RFs(cell_num,:))); %initialize RF vector
for i = 1:length(RFs(cell_num,:))%define RFs for this cell
    RFs_cell(i) = RFs(cell_num,i);
end
RFs_cell = RFs_cell(~isnan(RFs_cell));%eliminate potential NaNs that may be placeholders

%%%%%%%%%%%%%%%%%%%
%Establish trials where RF is in and RF is out of receptive field
%Establish observed RTs for easy vs. hard
%%%%%%%%%%%%%%%%%%%
SRT = Saccade_(:,1) - Target_(:,1);% return NaNs to vector prior to determining trial number
if easy_hard == 1%select from all correct trials
   T_in = nonzeros(GOCorrect(:,[RFs_cell+1],:));
   D_in = GOCorrect(~ismember(GOCorrect,T_in));
   D_in = nonzeros(D_in);
elseif easy_hard == 2 %select only from easy/correct trials
   T_in = nonzeros(GOCorrect(:,[RFs_cell+1],1));
   D_in = GOCorrect(~ismember(GOCorrect(:,:,1),T_in));
   D_in = nonzeros(D_in);
   easy_trials = [T_in; D_in];
   SRTeasy = zeros(length(easy_trials),1);
   for i = 1:length(easy_trials)
       SRTeasy(i) = SRT(easy_trials(i));
   end
       SRT = SRTeasy;
elseif easy_hard == 3 %select only from hard/correct trials
   T_in = nonzeros(GOCorrect(:,[RFs_cell+1],2));
   D_in = GOCorrect(~ismember(GOCorrect(:,:,2),T_in));
   D_in = nonzeros(D_in);
      hard_trials = [T_in; D_in];
   SRThard = zeros(length(hard_trials),1);
   for i = 1:length(hard_trials);
       SRThard(i) = SRT(hard_trials);
   end
       SRT = SRThard;
end
       SRT = SRT(~isnan(SRT));%observed RT vector with no NaNs

%%%%%%%%%%%%%%%%%
% generate observed RT cdf = RTcdf
% this is the same across the entire session
%%%%%%%%%%%%%%%%%
RThist = hist(SRT,bins);
RTcdf = cumsum(RThist)/length(SRT);
RTobs_cdf = RTcdf; %defined only for consistency with Rtpred_cdf notation
%%%%%%%%%%%%
%NOTE: since this may only need to be calculated once, consider adding an
%if loop that turns off once this has run once(however this would not be
%applicable if running through an easy,hard for loop)
%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%
%3. Random Samples, feed into SDF generating function
%%%%%%%%%%%%%%%%%%%%
%Take a random sample (without replacement) for T_in trials
%Take a random sample (with replacement) for D_in trials
%Get SDF for both
%BEGIN: simulation loop
for n = 1:nSims
   rand_in_trials = randsample(T_in,nDraw,true);%sample with replacement
   rand_out_trials = randsample(D_in,nDraw,true);%sample with replacement

   [SDF_in] = spikedensityfunct_lgn_old(current_cell, Align_Time_, Plot_Time, rand_in_trials, TrialStart_);
   [SDF_out] = spikedensityfunct_lgn_old(current_cell, Align_Time_, Plot_Time, rand_out_trials, TrialStart_);
   
   if normalize == 1
       SDF_total = spikedensityfunct_lgn_old(current_cell, Align_Time_, Plot_Time, 1:length(current_cell(:,1)), TrialStart_);
       SDF_max = max(SDF_total);
       SDF_in = SDF_in/SDF_max;
       SDF_out = SDF_out/SDF_max;
   end
   
   
 SDF_diff(n,1:length(SDF_in)) = SDF_in - SDF_out;
 SDF_in_matrix(n,1:length(SDF_in)) = SDF_in;
 SDF_out_matrix(n,1:length(SDF_out)) = SDF_out;
%%%%%%%%%%%%%%%%%
%For plotting purposes: Save averages of SDF_in, SDF_out, and SDF_diff
%across ALL neurons within the given session
%%%%%%%%%%%%%%%%%
SDF_diff_average(cell_num,:) = mean(SDF_diff);
SDF_in_average(cell_num,:) = mean(SDF_in_matrix);
SDF_out_average(cell_num,:) = mean(SDF_out_matrix);

%n %keeps count

end %END: simulation loop

%%%%%%%%%%%%%%%%%%%%%
%Identify time when criterion is crossed, generate predicted RT vector from
%this information
%%%%%%%%%%%%%%%%%%%%%
SDF_diff_index = [Plot_Time(1):Plot_Time(2)];% vector of time indices
index = 1;
RTpred = zeros(length(SDF_diff(:,1)),1);%vector of length nSim to record time of crit. cross
ACC = zeros(length(SDF_diff(:,1)),1);%vector of length nSim to record accuracy
for j = 1:length(SDF_diff(:,1));% loop through simulations
   for i = 1:length(SDF_diff(1,:)); % loop through time index starting at 1 (500ms before t.o.) or 500 (target onset)
    if abs(SDF_diff(j,i)) >= Criterion;% if absolute value of difference is greater than criterion
        if RTpred(j) == 0;% and if RTpred(j) vector is still zero(i.e. criterion has not been crossed yet)
            RTpred(j) = SDF_diff_index(i);% record index at 
            if SDF_diff(j,i) >= 0
                ACC(j) = 1;
            end
        end
    end
   end
end
%generate RTpred CDF
RTpred_hist = hist(RTpred,bins);
RTpred_cdf = cumsum(RTpred_hist)/length(RTpred);

%%%%%%%%%%%%%%%%
%SAVE predicted CDFs for each cell
%%%%%%%%%%%%%%%%
RTpred_matrix(cell_num,:) = RTpred_cdf;

%%%%%%%%%%%%%%%%%%
%Calculate Quantiles
%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%select window of analysis
SRTsorted = sort(SRT); %new RTcdf
RTpredsorted = sort(RTpred); %new RTpred_cdf
%initialize vectors
Qvector_obs = zeros(length(number_of_quantiles),1);
Qvector_pred = zeros(length(number_of_quantiles),1);
nvector_obs = zeros(length(number_of_quantiles),1);
nvector_pred = zeros(length(number_of_quantiles),1);
%%%%%%%%
%calculate n vector (position of quantile splits)
%%%%%%%%
for i = 1:number_of_quantiles-1;
    nvector_obs(i) = (i*p*length(SRTsorted));%%%according to busemeyer, add .5?
    nvector_pred(i) = (i*p*length(RTpredsorted));%%%see above comment, ask??
end
nvector_obs(number_of_quantiles) = length(SRTsorted);
nvector_pred(number_of_quantiles) = length(RTpredsorted);
%n vectors complete
%define new variables for rounding
U_nvector_obs = ceil(nvector_obs);
L_nvector_obs = floor(nvector_obs);
U_nvector_pred = ceil(nvector_pred);
L_nvector_pred = floor(nvector_pred);
%%%%%%%%
%calcluate Q vector (value which divides quantiles)
%%%%%%%%
for i = 1:number_of_quantiles
    Qvector_obs(i) = SRTsorted(L_nvector_obs(i))+(SRTsorted(U_nvector_obs(i))-SRTsorted(L_nvector_obs(i)))*(nvector_obs(i)-floor(nvector_obs(i)));
    Qvector_pred(i) = RTpredsorted(L_nvector_pred(i))+(RTpredsorted(U_nvector_pred(i))-RTpredsorted(L_nvector_pred(i)))*(nvector_pred(i)-floor(nvector_pred(i)));
end
%calculate quantile differences
Quantile_differences = Qvector_obs - Qvector_pred;
mean_Quantile_difference = mean(Quantile_differences);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Wrap up multi cell loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%save accuracy for all cells in accuracy vector
Accuracy_vector(cell_num) = mean(ACC);
Qvector_obs_matrix(cell_num,:) = Qvector_obs;
Qvector_pred_matrix(cell_num,:) = Qvector_pred;
Quant_diff_matrix(cell_num,:) = Quantile_differences;
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%SELECT OUTPUT TO BE DISPLAYED%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%IMPORTANT: order of neurons in matrix (top to bottom) will be ALPHABETIZED

%Accuracy_vector %accuracy for each neuron in the session

%Qvector_obs_matrix %observed quantiles (each row = cell)

%Qvector_pred_matrix %predicted quantiles (each row = cell)

%Quant_diff_matrix %observed quantiles - predicted quantiles for each cell

% SDF_diff_average %each row = neuron, each column = avg difference in T_in
%                    and D_in activity at a given time across all sims

% SDF_in_average %each row = neuron, each column = avg activity for T_in
%                   across all simulations

% SDF_out_average %each row = neuron, each column = avg activity for D_in
%                   across all simulations

% RTobs_cdf %one vector that applies to all neurons in session, plots CDF
%              for observed RTs

% RTpred_matrix %each row = CDF for predicted RTs for a given neuron

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%UNDER CONSTRUCTION: PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if plots_on == 1
%%%
%1. Plot activity of of T_in (red)and D_in (blue), with obsCDF(green) and
%predCDF (black) overtop
%%%
%for i = 1:length(CellNames)%%%%%%%%%%%%%%%%%%%%%last minute change, under construction


subplot(3,1,1)
cla
hold on
% plot(Plot_Time(1):Plot_Time(2),SDF_in_average(1,:),'Color','r')
% plot(Plot_Time(1):Plot_Time(2),SDF_out_average(1,:),'Color','b')
[AX,H1,H2] = plotyy(Plot_Time(1):Plot_Time(2),SDF_in_average(selected_neuron,:),Plot_Time(1):Plot_Time(2),RTobs_cdf,'plot');
[AX,H3,H4] = plotyy(Plot_Time(1):Plot_Time(2),SDF_out_average(selected_neuron,:),Plot_Time(1):Plot_Time(2),RTpred_matrix(selected_neuron,:),'plot');
% %H1 = SDF_in, H2 = obs_cdf, H3 = SDF_out, H4 = pred_cdf
set(H1,'Color','r');
set(H2,'Color','g');
set(H3,'Color','b');
set(H4,'Color','k');
ylabel([File_ext CellNames(selected_neuron)])
title(Criterion)

subplot(3,1,2)
cla
plot(Plot_Time(1):Plot_Time(2),SDF_diff_average(selected_neuron,:));
%
%%%
%2. Quantile Plots
%%%
% figure


subplot(3,1,3)
scatter(Qvector_obs_matrix(selected_neuron,:),Qvector_pred_matrix(selected_neuron,:))
x = [0:max(SRT+100)];
y = [0:max(SRT+100)];
line(x,y);
xlabel('obs RTs')
ylabel('pred RTs')

figure
scatter([1:number_of_quantiles], Qvector_obs_matrix(selected_neuron,:),'g')
hold on
scatter([1:number_of_quantiles],Qvector_pred_matrix(selected_neuron,:),'k')
xlabel('green = observed, black = predicted')
ylabel('reaction time')
ACC_for_selected_cell = mean(Accuracy_vector(selected_neuron))
title(ACC_for_selected_cell)
end
%%%%%%%%%%%%%%%%%%%
%Dealing with easy hard data
%create one giant for loop to cycle through the two levels of difficulty
% at the very end of that loop, save the data from that difficulty level in
% a data x cell x difficulty_level multidimensional array
% from this, produce comparison across difficult information