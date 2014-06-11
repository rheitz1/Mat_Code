%get reward rate based on Correct/Error and TrialStart_ time.  Need to use
%TrialStart_ to account for time lost due to aborted trials
clear RT RR


%length of experiment, converted to seconds
sess_length = (TrialStart_(end,1) - TrialStart_(1,1)) / 1000;
rewards_per_second = length(find(Correct_(:,2) == 1)) / sess_length;
rewards_per_minute = rewards_per_second * 60;

real_time = (TrialStart_(:,1) - TrialStart_(1,1)) / 1000;


%calculate reward rate every t seconds

t = 60;
currEndTime = 0;
block = 1;
while currEndTime < max(real_time)
    currEndTime = currEndTime + t;
    currTrials = find(real_time >= (currEndTime - t) & real_time < currEndTime);
    numCorrect = sum(Correct_(currTrials,2));
    
    
    try
        block_length = real_time(currTrials(end)) - real_time(currTrials(1));
        RR(block,1) = (numCorrect / block_length) * 60;
        RT(block,1) = nanmean(SRT(currTrials,1));
    catch
        RR(block,1) = NaN;
        RT(block,1) = NaN;
    end
    
    block = block + 1;
end

time = (1:t:max(real_time)) / 60;

figure
subplot(1,2,1)
set(gcf,'color','white')
plot(time,RR)
xlim([1 max(real_time)/60])
xlabel('Time (minute)','fontsize',12,'fontweight','bold')
ylabel('Rewards per Minute','fontsize',12,'fontweight','bold')
title('Reward Rate','fontsize',12,'fontweight','bold')

subplot(1,2,2)
plot(time,RT)
xlim([1 max(real_time)/60])
xlabel('Time (minute)','fontsize',12,'fontweight','bold')
ylabel('SRT (ms)','fontsize',12,'fontweight','bold')
title('Saccadic Reaction Time (Correct & Errors)','fontsize',12,'fontweight','bold')