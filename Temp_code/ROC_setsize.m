function [ROCarea, TDT] = ROC(Spike,RF,Target_,Correct_,TrialStart_)

%at each time bin, find proportion t_in greater than criterion & proportion
%d_in greater than criterion, then incrememnt criterion from 0 to maxFiring
%rate
plotFlag = 1;

Align_Time = Target_(:,1);
Plot_Time = [-200 2000];

%initiate SDF_all
SDF_all(1:size(Spike,1),1:(abs(Plot_Time(1)) + abs(Plot_Time(2)))) = 0;
%calculate SDF matrix, trial-by-trial

disp('Creating trial-by-trial SDFs...')
for n = 1:size(Spike,1)
    curr_SDF = spikeDensityfunction_singletrial(Spike(n,:),Align_Time(n,1),Plot_Time);
    SDF_all(n,1:length(curr_SDF)) = curr_SDF;
end


%Vector of Target_in and Distractor_in trials
%NOTE: currently, using ALL distractor locations.  Should limit later.


% inTrials = find(ismember(Target_(:,2),RF) == 1);
% outTrials = find(~ismember(Target_(:,2),RF) == 1);

%find T_in and T_out trials for each set size

inTrials_2 = find(ismember(Target_(:,2),RF) == 1 & Target_(:,5) == 2 & Correct_(:,2) == 1);
inTrials_4 = find(ismember(Target_(:,2),RF) == 1 & Target_(:,5) == 4 & Correct_(:,2) == 1);
inTrials_8 = find(ismember(Target_(:,2),RF) == 1 & Target_(:,5) == 8 & Correct_(:,2) == 1);

outTrials_2 = find(~ismember(Target_(:,2),RF) == 1 & Target_(:,5) ~= 2 & Correct_(:,2) == 1);
outTrials_4 = find(~ismember(Target_(:,2),RF) == 1 & Target_(:,5) ~= 4 & Correct_(:,2) == 1);
outTrials_8 = find(~ismember(Target_(:,2),RF) == 1 & Target_(:,5) ~= 8 & Correct_(:,2) == 1);

SDF_in_2 = spikedensityfunct_lgn_old(Spike, Align_Time, Plot_Time, inTrials_2, TrialStart_);
SDF_in_4 = spikedensityfunct_lgn_old(Spike, Align_Time, Plot_Time, inTrials_4, TrialStart_);
SDF_in_8 = spikedensityfunct_lgn_old(Spike, Align_Time, Plot_Time, inTrials_8, TrialStart_);

SDF_out_2 = spikedensityfunct_lgn_old(Spike, Align_Time, Plot_Time, outTrials_2, TrialStart_);
SDF_out_4 = spikedensityfunct_lgn_old(Spike, Align_Time, Plot_Time, outTrials_4, TrialStart_);
SDF_out_8 = spikedensityfunct_lgn_old(Spike, Align_Time, Plot_Time, outTrials_8, TrialStart_);

%find maxFiring rate

maxFire = max(max(SDF_all));


disp('Calculating ROC area...')
setsz_index = 1;
for setsz = [2 4 8]
    disp(['Set size ' mat2str(setsz)])
    for ms = 1:size(SDF_all,2)
        ms
        for criterion = 0:maxFire
            % [ms criterion]
            num_Tin_greater(criterion + 1,ms) = length(find(SDF_all(eval(['inTrials_' mat2str(setsz)]),ms) >= criterion)) / length(eval(['inTrials_' mat2str(setsz)]));
            %num_Din_greater(criterion + 1,ms) = length(find(SDF_all(outTrials_2,ms) >= criterion)) / length(outTrials_2);
            num_Din_greater(criterion + 1,ms) = length(find(SDF_all(eval(['outTrials_' mat2str(setsz)]),ms) >= criterion)) / length(eval(['outTrials_' mat2str(setsz)]));
        end
        ROCarea(ms,setsz_index) = polyarea([1 num_Din_greater(:,ms)'],[0 num_Tin_greater(:,ms)']);
    end
    setsz_index = setsz_index + 1;
end



%TDT will be time of half-width between max ROC area value, and the min
%falling prior to the max value
for setsz_grp = 1:3
        
    [maxArea, maxIndex] = max(ROCarea(:,setsz_grp));
    %Note: (maxIndex - 200) = time stamp of maximum value.  Correction is -200
    %beause we send a 200 ms baseline to the SDF function

    %search for minimum value falling before maxIndex, but AFTER 0 (which is actually 200
    %b/c there is a 200 ms beaseline; this will help prevent finding a
    %negative TDT)
    minArea_total = min(ROCarea(1:maxIndex,setsz_grp));
    %minArea = min(ROCarea(200:maxIndex,setsz_grp));

    %scale ROCarea by minimum value
    %ROCarea_corrected = ROCarea(:,setsz_grp) - minArea_total;

    %ROC_criterion = .75*(maxArea - minArea) + minArea;
    ROC_criterion = .75;

    %find where half width occurs, and correct for 200 ms baseline.  Search
    %from 0 (200 ms) only up until the max value occurs
    %Note: no need to compute 200 ms correction because we start the search
    %at 0 (i.e., 200 ms) and we are using the "find" command, which will
    %index at 1 beginning with cell 200.
    
    if ~isempty(find(ROCarea(:,setsz_grp) >= ROC_criterion,1)) - 200;
        TDT(setsz_grp) = (find(ROCarea(:,setsz_grp) >= ROC_criterion,1))- 200;
    else
        TDT(setsz_grp) = 0;
    end
    % plot(num_Din_greater,num_Tin_greater)
end



if plotFlag == 1
    figure
    orient landscape
    set(gcf,'Color','white')
    subplot(2,3,1)
    plot(Plot_Time(1):Plot_Time(2),SDF_in_2,'-b',Plot_Time(1):Plot_Time(2),SDF_out_2,'--b')
    AX = legend('T\_in Set Size 2', 'D\_in Set Size 2');
    LEG = findobj(AX,'type','text');
    set(LEG,'FontSize',6)
    hold on
    line([TDT(1) TDT(1)],[0 max(SDF_in_2)],'Color','green')
    title(['Set Size 2 ' '   TDT = ' mat2str(TDT(1))])
    xlim([-200 700])
    
    subplot(2,3,2)
    plot(Plot_Time(1):Plot_Time(2),SDF_in_4,'-r',Plot_Time(1):Plot_Time(2),SDF_out_4,'--r')
    AX = legend('T\_in Set Size 4', 'D\_in Set Size 4');
    LEG = findobj(AX,'type','text');
    set(LEG,'FontSize',6)
    hold on
    line([TDT(2) TDT(2)],[0 max(SDF_in_4)],'Color','green')
    xlim([-200 700])
    title(['Set Size 4 ' '   TDT = ' mat2str(TDT(2))])
    
    subplot(2,3,3)
    plot(Plot_Time(1):Plot_Time(2),SDF_in_8,'-k',Plot_Time(1):Plot_Time(2),SDF_out_8,'--k')
    AX = legend('T\_in Set Size 8', 'D\_in Set Size 8');
    LEG = findobj(AX,'type','text');
    set(LEG,'FontSize',6)
    hold on
    line([TDT(3) TDT(3)],[0 max(SDF_in_8)],'Color','green')
    xlim([-200 700])
    title(['Set Size 8 ' '   TDT = ' mat2str(TDT(3))])
    
    subplot(2,3,4)
    hold on
    plot(Plot_Time(1):Plot_Time(2),ROCarea(:,1),'b',Plot_Time(1):Plot_Time(2),ROCarea(:,2),'r',Plot_Time(1):Plot_Time(2),ROCarea(:,3),'k')
    title('ROC area')
    AX = legend('Set Size 2','Set Size 4','Set Size 8');
    LEG = findobj(AX,'type','text');
    set(LEG,'FontSize',8)
    xlim([-200 1000])
    
    subplot(2,3,5)
    plot(TDT,'-o','MarkerFaceColor','b','MarkerEdgeColor','b')
    title('TDT')
    set(gca,'Xtick',1:1:3)
    set(gca,'XTickLabel',[2 4 8])
    ylabel('TDT (ms)')
    xlabel('Set Size')
    xlim([.8 3.2])
end
% 
% if plotFlag == 1
%     figure
%     hold
%     SDF_in = mean(SDF_all(inTrials,:));
%     SDF_out = mean(SDF_all(outTrials,:));
%     plot(Plot_Time(1):Plot_Time(2),SDF_in,Plot_Time(1):Plot_Time(2),SDF_out)
%     xlim([-200 2000])
%     hold on
%     line([TDT,TDT],[0 max(SDF_in)])
%     legend('In','out')
% 
%     figure
%     plot(ROCarea)
%     %plot(1:2201,ROCarea)
%     title('ROC area')
% 
%     figure
%     hold on
%     for n = 1:size(num_Din_greater,2)
%         plot(num_Din_greater(:,n),num_Tin_greater(:,n))
%     end
%     title('Trial-by-Trial ROC curves')
% end
