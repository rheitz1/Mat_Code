%use to integrate differences between targ_in and targ_out
close all;
%set parameters

nSims = 1000; %number of simulations to run
nDraw = 10; %number of neurons to randomly draw and pool when calculating the SDF

SRT = Saccade_(:,1) - Target_(:,1);
Align_Time_(1:length(Decide_),1) = 500;
%Align_Time_ = Decide_(:,1);
Plot_Time=[-200 800];


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
    
    [SDF_in] = spikedensityfunct_lgn_old(DSP01c, Align_Time_, Plot_Time, rand_in_trials, TrialStart_);
    [SDF_out] = spikedensityfunct_lgn_old(DSP01c, Align_Time_, Plot_Time, rand_out_trials, TrialStart_);
    
%     subplot(2,1,1)
%     cla
%     plot(Plot_Time(1):Plot_Time(2),SDF_in,'Color','r')
%     hold on
%     plot(Plot_Time(1):Plot_Time(2),SDF_out,'Color','b')
%     
%      subplot(2,1,2)
%      cla

SDF_diff(n,1:length(SDF_in)) = SDF_in - SDF_out;
%      plot(Plot_Time(1):Plot_Time(2),SDF_diff)
%      pause
      n
end
%subplot(3,1,3)
plot(Plot_Time(1):Plot_Time(2),mean(SDF_diff));

