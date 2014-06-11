

%at each time bin, find proportion t_in greater than criterion & proportion
%d_in greater than criterion, then incrememnt criterion from 0 to maxFiring
%rate
Align_Time = Target_(:,1);
SDFPlot_Time = [-200 2000];
Plot_Time = [-200 2000];
%initiate SDF_all
if exist('SDF_all') == 0
    SDF_all(1:size(DSP10b,1),1:(abs(SDFPlot_Time(1)) + abs(SDFPlot_Time(2)))) = 0;
    %calculate SDF matrix, trial-by-trial
    for n = 1:size(DSP10b,1)
        curr_SDF = spikeDensityfunction_singletrial(DSP10b(n,:),Align_Time(n,1),Plot_Time);
        SDF_all(n,1:length(curr_SDF)) = curr_SDF;
    end
end
%Vector of Target_in and Distractor_in trials
%NOTE: currently, using ALL distractor locations.  Should limit later.


inTrials = find(ismember(Target_(:,2),RF) == 1);
outTrials = find(~ismember(Target_(:,2),RF) == 1);


%find maxFiring rate

maxFire = max(max(SDF_all));


%Smooth SDF in 5 ms bins

for z = 1:size(SDF_all,1)
index = 1;
    for zz = 3:5:size(SDF_all,2)-3
        SDF_all_sm(z,index) = mean(SDF_all(z,zz-2:zz+2));
        index = index + 1;
    end
end

for ms = 1:size(SDF_all_sm,2)
    for criterion = 0:maxFire
        num_Tin_greater(criterion + 1,ms) = length(find(SDF_all_sm(inTrials,ms) > criterion)) / length(find(SDF_all_sm(inTrials,ms)));
        num_Din_greater(criterion + 1,ms) = length(find(SDF_all_sm(outTrials,ms) > criterion)) / length(find(SDF_all_sm(outTrials,ms)));
    end
    ROCarea(ms) = polyarea([num_Din_greater(:,ms)' 1],[num_Tin_greater(:,ms)' 0]);
end


% for ms = 1:size(SDF_all,2)
%     for criterion = 0:maxFire
%         num_Tin_greater(criterion + 1,ms) = length(find(nonzeros(SDF_all(inTrials,ms) > criterion))) / length(find(nonzeros(SDF_all(inTrials,ms))));
%         num_Din_greater(criterion + 1,ms) = length(find(nonzeros(SDF_all(outTrials,ms) > criterion))) / length(find(nonzeros(SDF_all(outTrials,ms))));
%     end
%     ROCarea(ms) = polyarea([num_Din_greater(:,ms)' 1],[num_Tin_greater(:,ms)' 0]);
% end

% plot(num_Din_greater,num_Tin_greater)
% plot(num_Din_greater,num_Tin_greater)
figure
hold
SDF_in = mean(SDF_all(inTrials,:));
SDF_out = mean(SDF_all(outTrials,:));
plot(Plot_Time(1):Plot_Time(2),SDF_in,Plot_Time(1):Plot_Time(2),SDF_out)
legend('In','out')

figure
plot(1:2201,ROCarea)
title('ROC area')

figure
hold on
for n = 1:size(num_Din_greater,2)
    plot(num_Din_greater(:,n),num_Tin_greater(:,n))
end
title('Trial-by-Trial ROC curves')
