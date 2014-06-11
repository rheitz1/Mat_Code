%Returns Reward rate as # rewards per MINUTE
%
% RPH

function [meanRR meanOptimalRR] = getRewardRate_SAT

SAT_ = evalin('caller','SAT_');
TrialStart_ = evalin('caller','TrialStart_');
Correct_ = evalin('caller','Correct_');

blk_switch = find(abs(diff(SAT_(:,1))) ~= 0) + 1;

%find corresponding conditions
fast_to_slow = blk_switch(find(SAT_(blk_switch-1,1) == 3 & SAT_(blk_switch,1) == 1));
slow_to_fast = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 3));


blk_switch = [1 ; blk_switch];

meanRR = [NaN NaN NaN];

for cur_blk = 1:length(blk_switch)-1
    trls = blk_switch(cur_blk):blk_switch(cur_blk+1)-1;
    num_rwds = length(find(Correct_(trls,2)));
    
        
    real_time = (TrialStart_(blk_switch(cur_blk+1)-1) - TrialStart_(blk_switch(cur_blk))) / 1000;
    
    %calculate # of rewards/second and multiply by 60 to get number of rewards per minute
    RR(cur_blk,1) = (num_rwds ./ real_time) * 60;
    RR(cur_blk,2) = SAT_(blk_switch(cur_blk),1);
    
    OptimalRR(cur_blk,1) = (length(trls) ./ real_time) * 60;
    OptimalRR(cur_blk,2) = SAT_(blk_switch(cur_blk),1);
end

RR(find(isinf(RR(:,1))),1) = NaN;
OptimalRR(find(isinf(OptimalRR(:,1))),1) = NaN;

meanRR(1) = nanmean(RR(find(RR(:,2) == 1),1));
meanRR(2) = nanmean(RR(find(RR(:,2) == 2),1));
meanRR(3) = nanmean(RR(find(RR(:,2) == 3),1));

meanOptimalRR(1) = nanmean(OptimalRR(find(OptimalRR(:,2) == 1),1));
meanOptimalRR(2) = nanmean(OptimalRR(find(OptimalRR(:,2) == 2),1));
meanOptimalRR(3) = nanmean(OptimalRR(find(OptimalRR(:,2) == 3),1));