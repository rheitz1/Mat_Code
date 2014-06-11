%use to integrate differences between targ_in and targ_out
close all;
%set parameters
SDF_diff = [];
SDF_in = [];
SDF_out = [];
SDF_in_total = [];
SDF_out_total = [];
rand_in_trials = [];
rand_out_trials = [];
integrator = [];
SRT = [];

SimPlotOption = 1;
nSims =20 ; %number of simulations to run
nDraw =3; %number of neurons to randomly draw and pool when calculating the SDF

SRT = Saccade_(:,1) - Target_(:,1);
    
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

    temp_in = spikedensityfunct_lgn_old(DSP01c, Align_Time_, Plot_Time, rand_in_trials, TrialStart_);
    temp_out = spikedensityfunct_lgn_old(DSP01c, Align_Time_, Plot_Time, rand_out_trials, TrialStart_);
    
    %send T_in and D_in (all relevant trials) to obtain overall SDFs
    temp_in_total = spikedensityfunct_lgn_old(DSP01c, Align_Time_, Plot_Time, T_in, TrialStart_);
    temp_out_total = spikedensityfunct_lgn_old(DSP01c, Align_Time_, Plot_Time, D_in, TrialStart_);
    
    
    SDF_in_total(n,1:length(temp_in)) = temp_in_total;
    SDF_out_total(n,1:length(temp_in)) = temp_out_total;
    SDF_in(n,1:length(temp_in)) = temp_in;
    SDF_out(n,1:length(temp_out)) = temp_out;

    SDF_diff(n,1:length(temp_in)) = temp_in - temp_out;
    
    %Integrate difference after 0
    
    %pad beginning of matrix up to 500 ms (target onset) with 0's
    integrator(n,1:length(SDF_in)) = zeros;
    integrator_index = 1;
    
    for t = 501:size(SDF_in,2)
        %start integration at 0 (500 ms after TrialStart) but set
        %first cell to 1
        integrator(n,integrator_index + 500) = integrator(n,integrator_index+500 - 1) + (SDF_in(n,t) - SDF_out(n,t));
        integrator_index = integrator_index + 1;
    end
     n
end


%set axes properties

subplot(5,1,1)
if nSims > 1
    plot(Plot_Time(1):Plot_Time(2),mean(SDF_in_total),Plot_Time(1):Plot_Time(2),mean(SDF_out_total))
    legend('Target in','Distractor in','Location','NorthEast')
    title(['Average SDFs for cell'])
else
    plot(Plot_Time(1):Plot_Time(2),SDF_in_total,Plot_Time(1):Plot_Time(2),SDF_out_total)
    legend('Target in','Distractor in','Location','NorthEast')
    title(['Average SDFs for cell'])
end


%PLOT OVERALL SDFs on secondary axis
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none');
[RTs_total,bins_total] = hist(SRT(T_in),50);
CDF_total = (cumsum(RTs_total))/length(SRT(T_in))*100 ;
hold on
plot(bins_total,CDF_total,'Parent',ax2,'Color','r')
axis([-500 1000 0 100])
set(gca,'XTickLabels','')
set(gca,'TickLength',[0 0])


%PLOT TOTAL DIFFERENCES between T_in and D_in
subplot(5,1,2)
if nSims > 1
    plot(Plot_Time(1):Plot_Time(2),mean(SDF_diff),'Color','r')
    title(['Average difference between T-in and D-in over ' mat2str(nSims) ' Sims'])
else
    plot(Plot_Time(1):Plot_Time(2),SDF_diff,'Color','r')
    title(['Average difference between T-in and D-in over ' mat2str(nSims) ' Sims'])
end


%PLOT AVERAGE INTEGRATOR
subplot(5,1,3)
if nSims > 1
    plot(Plot_Time(1):Plot_Time(2),mean(integrator),'Color','b')
    title(['Accumulated differences over ' mat2str(nDraw) ' trials run ' mat2str(nSims) ' times'])
else
    plot(Plot_Time(1):Plot_Time(2),integrator,'Color','b')
    title(['Accumulated differences over ' mat2str(nDraw) ' trials run ' mat2str(nSims) ' times'])
end


if SimPlotOption == 1 && nSims > 1
    
    for index = 1:nSims
        %Plot current simulation SDFs
        subplot(5,1,4)
        plot(Plot_Time(1):Plot_Time(2),SDF_in(index,:),Plot_Time(1):Plot_Time(2),SDF_out(index,:))
        legend('Target in','Distractor in','Location','NorthEast')
        title(['Subset SDFs...Simulation # ' mat2str(index)])
        
        %Plot current simulation integrator
        subplot(5,1,5)
        plot(Plot_Time(1):Plot_Time(2),integrator(index,:))
        title(['Subset Accumulated differences...Simulation # ' mat2str(index)])
        pause
    end
    

end
