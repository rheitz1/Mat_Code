%use to integrate differences between targ_in and targ_out
close all;
%set parameters
SDF_diff = [];
SDF_in = [];
SDF_out = [];

nSims =1 ; %number of simulations to run
nDraw =6; %number of neurons to randomly draw and pool when calculating the SDF

SRT = Saccade_(:,1) - Target_(:,1);
%get rid of bad trials
for i = 1:length(SRT);
    if isnan(SRT(i));
        SRT(i) = 0;
    end
end
SRT = nonzeros(SRT);
    
%Align_Time_(1:length(Decide_),1) = 500;
%Align_Time_ = Decide_(:,1);
Align_Time_ = Target_(:,1); %aligned on target onset
Plot_Time=[-500 1000];

figure
set(gcf,'Color','white')

%get list of neurons
varlist = who;
cellID = varlist(strmatch('DSP',varlist));

%get targ_in and targ_out trials (include only correct, so reference GOCorrect)
%not sure what "Correct_" variable is doing; not coincident with GOCorrect.
   T_in = nonzeros(GOCorrect(:,[RFs+1],:));
   D_in = GOCorrect(~ismember(GOCorrect,T_in));
   D_in = nonzeros(D_in);


%Take a random sample (without replacement) for T_in trials
%Take a random sample (with replacement) for D_in trials
%Get SDF for both and plot


%for file 'fecfef_m153.mat', best cell is DSP01c.  Limit analysis to this
%for the time being.

%randsample takes random value 1:n (first arg; second arg specifies how many
%numbers you want drawn


for n = 1:nSims
    rand_in_trials = randsample(length(T_in),nDraw,false);
    rand_out_trials = randsample(length(D_in),nDraw,true);

    temp_in = spikedensityfunct_lgn_old(DSP02a, Align_Time_, Plot_Time, rand_in_trials, TrialStart_);
    temp_out = spikedensityfunct_lgn_old(DSP02a, Align_Time_, Plot_Time, rand_out_trials, TrialStart_);

    SDF_in(n,1:length(temp_in)) = temp_in;
    SDF_out(n,1:length(temp_out)) = temp_out;


    SDF_diff(n,1:length(temp_in)) = temp_in - temp_out;
    
    %Integrate difference after 0
    
    %set start point to 0
    integrator = 0;
    integrator_index = 2;
    for t = 501:size(SDF_in,2)
        %start integration at 0 (500 ms after TrialStart) but set
        %first cell to 1
        integrator(integrator_index) = integrator(integrator_index - 1) + (SDF_in(t) - SDF_out(t));
        integrator_index = integrator_index + 1;
    end
    
%      pause
     n
end
%subplot(3,1,3)

subplot(2,1,1)
cla

if nSims > 1
    plot(Plot_Time(1):Plot_Time(2),mean(SDF_in),Plot_Time(1):Plot_Time(2),mean(SDF_out))
    legend('Target in','Distractor in','Location','NorthEast')
else
    plot(Plot_Time(1):Plot_Time(2),SDF_in,Plot_Time(1):Plot_Time(2),SDF_out)
end

%RTcdf
bins = [Plot_Time(1):Plot_Time(2)];
RThist = hist(SRT,bins);
RTcdf = cumsum(RThist)/length(SRT);
hold on
plotyy(1,1,Plot_Time(1):Plot_Time(2),RTcdf)


subplot(2,1,2)
cla

if nSims > 1
    plot(Plot_Time(1):Plot_Time(2),mean(SDF_diff));
elseif nSims == 1
    plot(Plot_Time(1):Plot_Time(2),(SDF_diff));
end

title(['Average difference between T-in and D-in over ' mat2str(nDraw) 'trials run ' mat2str(nSims) 'times'])


