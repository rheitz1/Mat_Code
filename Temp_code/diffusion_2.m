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
rw = [];
SRT = [];
SRT_sim = [];
ACC = [];


%%% SET OPTIONS %%%
%%%%%%%%%%%%%%%%%%%
criterion = 150;

SimPlotOption = 1;
nSims =100 ; %number of simulations to run
nDraw =10; %number of neurons to randomly draw and pool when calculating the SDF

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

    temp_in = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, rand_in_trials, TrialStart_);
    temp_out = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, rand_out_trials, TrialStart_);

    %send T_in and D_in (all relevant trials) to obtain overall SDFs
    temp_in_total = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, T_in, TrialStart_);
    temp_out_total = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, D_in, TrialStart_);


    SDF_in_total(n,1:length(temp_in)) = temp_in_total;
    SDF_out_total(n,1:length(temp_in)) = temp_out_total;
    SDF_in(n,1:length(temp_in)) = temp_in;
    SDF_out(n,1:length(temp_out)) = temp_out;

    SDF_diff(n,1:length(temp_in)) = temp_in - temp_out;

    %Integrate difference after 0

    %pad beginning of matrix up to 500 ms (target onset) with 0's
    integrator(n,1:length(SDF_in)) = zeros;
    rw(n,1:length(SDF_in)) = zeros;
    index = 1;


    criterion_cross = 0;
    iter = 1;
    
    for t = 501:size(SDF_in,2)
        %start integration at 0 (500 ms after TrialStart) but set
        %first cell to 1
        integrator(n,index + 500) = integrator(n,index+500-1) + (SDF_in(n,t) - SDF_out(n,t));
        
        if criterion_cross == 0
            if abs(integrator(n,index+500)) >= criterion
                SRT_sim(n) = index;
                criterion_cross = 1;

                %check if error or correct
                if integrator(n,index+500) < 0
                    ACC(n) = 0;
                else
                    ACC(n) = 1;
                end
            end
            
        end
        
        
        %Update random walk
        if SDF_in(n,t) > SDF_out(n,t)
            rw(n,index+500) = rw(n,index+500-1) + 1;
        elseif SDF_in(n,t) < SDF_out(n,t)
            rw(n,index+500) = rw(n,index+500-1) - 1;
        else
            %if tie, keep same value
            rw(n,index+500) = rw(n,index+500-1);
        end
        index = index + 1;
    end
    n
end


[rts_sim,bins_sim] = hist(SRT_sim,50);
CDF_sim = (cumsum(rts_sim)) / length(SRT_sim) * 100;


%set axes properties

subplot(6,1,1)
if nSims > 1
    plot(Plot_Time(1):Plot_Time(2),mean(SDF_in_total),Plot_Time(1):Plot_Time(2),mean(SDF_out_total))
    legend('Target in','Distractor in','Location','NorthEast')
    title(['Average SDFs for cell'])
    xlim([-500 1000])
else
    plot(Plot_Time(1):Plot_Time(2),SDF_in_total,Plot_Time(1):Plot_Time(2),SDF_out_total)
    legend('Target in','Distractor in','Location','NorthEast')
    title(['Average SDFs for cell'])
    xlim([-500 1000])
end


%PLOT OVERALL SDFs on secondary axis
ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'XAxisLocation','top','YAxisLocation','right','Color','none');
[RTs_total,bins_total] = hist(SRT(T_in),50);
CDF_total = (cumsum(RTs_total))/length(SRT(T_in))*100 ;
hold on
plot(bins_total,CDF_total,'Parent',ax2,'Color','r')
plot(bins_sim,CDF_sim,'Parent',ax2,'Color','g')
axis([-500 1000 0 100])
set(gca,'XTickLabel','')
set(gca,'TickLength',[0 0])



%PLOT AVERAGE INTEGRATOR
subplot(6,1,2)
if nSims > 1
    plot(Plot_Time(1):Plot_Time(2),mean(integrator),'Color','b')
    title(['Accumulated differences over ' mat2str(nDraw) ' trials run ' mat2str(nSims) ' times'])
    ylim([-(max(abs(mean(integrator(:,500:1000))))) max(abs(mean(integrator(:,500:1000))))])
    xlim([-500 1000])
else
    plot(Plot_Time(1):Plot_Time(2),integrator,'Color','b')
    title(['Accumulated differences over ' mat2str(nDraw) ' trials run ' mat2str(nSims) ' times'])
    ylim([-(max(abs(integrator(:,500:1000)))) max(abs(integrator(:,500:1000)))])
    xlim([-500 1000])
end

%PLOT AVERAGE RANDOM WALK
subplot(6,1,3)
if nSims > 1
    plot(Plot_Time(1):Plot_Time(2),mean(rw),'Color','b')
    title(['Accumulated Random Walk values over ' mat2str(nDraw) ' trials run ' mat2str(nSims) ' times'])
    ylim([-(max(abs(mean(rw(:,500:1000))))) max(abs(mean(rw(:,500:1000))))])
    xlim([-500 1000])
else
    plot(Plot_Time(1):Plot_Time(2),rw,'Color','b')
    title(['Accumulated Random Walk values over ' mat2str(nDraw) ' trials run ' mat2str(nSims) ' times'])
    ylim([-(max(abs(rw(:,500:1000)))) max(abs(rw(:,500:1000)))])
    xlim([-500 1000])
end



if SimPlotOption == 1 && nSims > 1

    for index = 1:nSims
        %Plot current simulation SDFs
        subplot(6,1,4)
        plot(Plot_Time(1):Plot_Time(2),SDF_in(index,:),Plot_Time(1):Plot_Time(2),SDF_out(index,:))
        legend('Target in','Distractor in','Location','NorthEast')
        title(['Subset SDFs...Simulation # ' mat2str(index)])
        xlim([-500 1000])

        %Plot current simulation integrator
        subplot(6,1,5)
        plot(Plot_Time(1):Plot_Time(2),integrator(index,:))
        title(['Subset Accumulated differences...Simulation # ' mat2str(index)])
        ylim([-(max(abs(integrator(index,500:1000)))) max(abs(integrator(index,500:1000)))])
        xlim([-500 1000])

        %Plot current simulation random walk
        subplot(6,1,6)
        plot(Plot_Time(1):Plot_Time(2),rw(index,:))
        title(['Subset Random Walk model...Simulation # ' mat2str(index)])
        ylim([-(max(abs(rw(index,500:1000)))) max(abs(rw(index,500:1000)))])
        xlim([-500 1000])

%         pause
    end


end

if criterion_cross == 1
    figure
    hist(SRT_sim,50)
end
