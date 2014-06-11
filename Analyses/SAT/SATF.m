%computes the speed-accuracy tradeoff function (SATF)

function [RTbins ACCbins CAF] = SATF()

Correct_ = evalin('caller','Correct_');
SRT = evalin('caller','SRT');
Errors_ = evalin('caller','Errors_');
Target_ = evalin('caller','Target_');
saccLoc = evalin('caller','saccLoc');
SAT_ = evalin('caller','SAT_');

getTrials_SAT

isMed = 0;
if length(find(SAT_(:,1) == 2)) > 0; isMed = 1; end

%Note: can use Correct_ variable to compute accuracy rates only for 'made
%dead' trials.  Otherwise have to use trial counts
if isMed
    RTbins = [nanmean(SRT(slow_all_made_dead,1)) nanmean(SRT(med_all,1)) nanmean(SRT(fast_all_made_dead_withCleared,1))];
    ACCbins = [nanmean(Correct_(slow_all_made_dead,2)) nanmean(Correct_(med_all,2)) nanmean(Correct_(fast_all_made_dead_withCleared,2))];
else
    RTbins = [nanmean(SRT(slow_all_made_dead,1)) nanmean(SRT(fast_all_made_dead_withCleared,1))];
    ACCbins = [nanmean(Correct_(slow_all_made_dead,2)) nanmean(Correct_(fast_all_made_dead_withCleared,2))];
end


[CAF.RTs.slow CAF.ACCs.slow] = CAF_SAT(SRT,5,0,slow_all_made_dead);
[CAF.RTs.med CAF.ACCs.med] = CAF_SAT(SRT,5,0,med_all);
[CAF.RTs.fast CAF.ACCs.fast] = CAF_SAT(SRT,5,0,fast_all_made_dead_withCleared);


figure
plot(RTbins,ACCbins,'-ob')
hold on
plot(CAF.RTs.slow,CAF.ACCs.slow,'-or')
plot(CAF.RTs.med,CAF.ACCs.med,'-ok')
plot(CAF.RTs.fast,CAF.ACCs.fast,'-og')
ylim([.3 1])
x = xlim;
x(1) = 100;
xlim(x);
box off