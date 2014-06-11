%get sem's
plotSEM = 1;

%calculate standard error of the mean
if plotSEM == 1
    sem.Spike_correct_in(1,:) = nanmean(wf_all.Spike_correct.in) + (nanstd(wf_all.Spike_correct.in)) / sqrt(length(keeper_SP));
    sem.Spike_correct_in(2,:) = nanmean(wf_all.Spike_correct.in) - (nanstd(wf_all.Spike_correct.in)) / sqrt(length(keeper_SP));
    
    sem.Spike_correct_out(1,:) = nanmean(wf_all.Spike_correct.out) + (nanstd(wf_all.Spike_correct.out)) / sqrt(length(keeper_SP));
    sem.Spike_correct_out(2,:) = nanmean(wf_all.Spike_correct.out) - (nanstd(wf_all.Spike_correct.out)) / sqrt(length(keeper_SP));
    
    sem.Spike_errors_in(1,:) = nanmean(wf_all.Spike_errors.in) + (nanstd(wf_all.Spike_errors.in)) / sqrt(length(keeper_SP));
    sem.Spike_errors_in(2,:) = nanmean(wf_all.Spike_errors.in) - (nanstd(wf_all.Spike_errors.in)) / sqrt(length(keeper_SP));
    
    sem.Spike_errors_out(1,:) = nanmean(wf_all.Spike_errors.out) + (nanstd(wf_all.Spike_errors.out)) / sqrt(length(keeper_SP));
    sem.Spike_errors_out(2,:) = nanmean(wf_all.Spike_errors.out) - (nanstd(wf_all.Spike_errors.out)) / sqrt(length(keeper_SP));
    
    
    sem.LFP_correct_in(1,:) = nanmean(wf_all.LFP_correct.in) + (nanstd(wf_all.LFP_correct.in)) / sqrt(length(keeper_SP));
    sem.LFP_correct_in(2,:) = nanmean(wf_all.LFP_correct.in) - (nanstd(wf_all.LFP_correct.in)) / sqrt(length(keeper_SP));
    
    sem.LFP_correct_out(1,:) = nanmean(wf_all.LFP_correct.out) + (nanstd(wf_all.LFP_correct.out)) / sqrt(length(keeper_SP));
    sem.LFP_correct_out(2,:) = nanmean(wf_all.LFP_correct.out) - (nanstd(wf_all.LFP_correct.out)) / sqrt(length(keeper_SP));
    
    sem.LFP_errors_in(1,:) = nanmean(wf_all.LFP_errors.in) + (nanstd(wf_all.LFP_errors.in)) / sqrt(length(keeper_SP));
    sem.LFP_errors_in(2,:) = nanmean(wf_all.LFP_errors.in) - (nanstd(wf_all.LFP_errors.in)) / sqrt(length(keeper_SP));
    
    sem.LFP_errors_out(1,:) = nanmean(wf_all.LFP_errors.out) + (nanstd(wf_all.LFP_errors.out)) / sqrt(length(keeper_SP));
    sem.LFP_errors_out(2,:) = nanmean(wf_all.LFP_errors.out) - (nanstd(wf_all.LFP_errors.out)) / sqrt(length(keeper_SP));
    
    
    sem.OL_correct_contra(1,:) = nanmean(wf_all.OL_correct.contra) + (nanstd(wf_all.OL_correct.contra)) / sqrt(length(keeper_SP));
    sem.OL_correct_contra(2,:) = nanmean(wf_all.OL_correct.contra) - (nanstd(wf_all.OL_correct.contra)) / sqrt(length(keeper_SP));
    
    sem.OL_correct_ipsi(1,:) = nanmean(wf_all.OL_correct.ipsi) + (nanstd(wf_all.OL_correct.ipsi)) / sqrt(length(keeper_SP));
    sem.OL_correct_ipsi(2,:) = nanmean(wf_all.OL_correct.ipsi) - (nanstd(wf_all.OL_correct.ipsi)) / sqrt(length(keeper_SP));
    
    sem.OL_errors_contra(1,:) = nanmean(wf_all.OL_errors.contra) + (nanstd(wf_all.OL_errors.contra)) / sqrt(length(keeper_SP));
    sem.OL_errors_contra(2,:) = nanmean(wf_all.OL_errors.contra) - (nanstd(wf_all.OL_errors.contra)) / sqrt(length(keeper_SP));
    
    sem.OL_errors_ipsi(1,:) = nanmean(wf_all.OL_errors.ipsi) + (nanstd(wf_all.OL_errors.ipsi)) / sqrt(length(keeper_SP));
    sem.OL_errors_ipsi(2,:) = nanmean(wf_all.OL_errors.ipsi) - (nanstd(wf_all.OL_errors.ipsi)) / sqrt(length(keeper_SP));
    
    
    sem.OR_correct_contra(1,:) = nanmean(wf_all.OR_correct.contra) + (nanstd(wf_all.OR_correct.contra)) / sqrt(length(keeper_SP));
    sem.OR_correct_contra(2,:) = nanmean(wf_all.OR_correct.contra) - (nanstd(wf_all.OR_correct.contra)) / sqrt(length(keeper_SP));
    
    sem.OR_correct_ipsi(1,:) = nanmean(wf_all.OR_correct.ipsi) + (nanstd(wf_all.OR_correct.ipsi)) / sqrt(length(keeper_SP));
    sem.OR_correct_ipsi(2,:) = nanmean(wf_all.OR_correct.ipsi) - (nanstd(wf_all.OR_correct.ipsi)) / sqrt(length(keeper_SP));
    
    sem.OR_errors_contra(1,:) = nanmean(wf_all.OR_errors.contra) + (nanstd(wf_all.OR_errors.contra)) / sqrt(length(keeper_SP));
    sem.OR_errors_contra(2,:) = nanmean(wf_all.OR_errors.contra) - (nanstd(wf_all.OR_errors.contra)) / sqrt(length(keeper_SP));
    
    sem.OR_errors_ipsi(1,:) = nanmean(wf_all.OR_errors.ipsi) + (nanstd(wf_all.OR_errors.ipsi)) / sqrt(length(keeper_SP));
    sem.OR_errors_ipsi(2,:) = nanmean(wf_all.OR_errors.ipsi) - (nanstd(wf_all.OR_errors.ipsi)) / sqrt(length(keeper_SP));
end

%plot
if plotSEM == 1
    
    figure
    subplot(2,1,1)
    hold
    shadedplot(-100:500,nanmean(wf_all.Spike_correct.in),sem.Spike_correct_in(1,:),'g')
    shadedplot(-100:500,nanmean(wf_all.Spike_correct.in),sem.Spike_correct_in(2,:),'g')
    shadedplot(-100:500,nanmean(wf_all.Spike_correct.out),sem.Spike_correct_out(1,:),'r')
    shadedplot(-100:500,nanmean(wf_all.Spike_correct.out),sem.Spike_correct_out(2,:),'r')
    xlim([-50 300])
    fon
    title('Spike Correct')
    
    subplot(2,1,2)
    shadedplot(-100:500,nanmean(wf_all.Spike_errors.in),sem.Spike_errors_in(1,:),'g')
    shadedplot(-100:500,nanmean(wf_all.Spike_errors.in),sem.Spike_errors_in(2,:),'g')
    shadedplot(-100:500,nanmean(wf_all.Spike_errors.out),sem.Spike_errors_out(1,:),'r')
    shadedplot(-100:500,nanmean(wf_all.Spike_errors.out),sem.Spike_errors_out(2,:),'r')
    
    xlim([-50 300])
    fon
    title('Spike Errors')
    
    
    %====
    figure
    subplot(2,1,1)
    hold
    shadedplot(-500:2500,nanmean(wf_all.LFP_correct.in),sem.LFP_correct_in(1,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.LFP_correct.in),sem.LFP_correct_in(2,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.LFP_correct.out),sem.LFP_correct_out(1,:),'r')
    shadedplot(-500:2500,nanmean(wf_all.LFP_correct.out),sem.LFP_correct_out(2,:),'r')
    xlim([-50 300])
    axis ij
    fon
    title('LFP Correct')
    
    subplot(2,1,2)
    hold
    shadedplot(-500:2500,nanmean(wf_all.LFP_errors.in),sem.LFP_errors_in(1,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.LFP_errors.in),sem.LFP_errors_in(2,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.LFP_errors.out),sem.LFP_errors_out(1,:),'r')
    shadedplot(-500:2500,nanmean(wf_all.LFP_errors.out),sem.LFP_errors_out(2,:),'r')
    xlim([-50 300])
    axis ij
    fon
    title('LFP Errors')
    
    
    %======
    figure
    subplot(2,1,1)
    hold
    shadedplot(-500:2500,nanmean(wf_all.OL_correct.contra),sem.OL_correct_contra(1,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.OL_correct.contra),sem.OL_correct_contra(2,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.OL_correct.ipsi),sem.OL_correct_ipsi(1,:),'r')
    shadedplot(-500:2500,nanmean(wf_all.OL_correct.ipsi),sem.OL_correct_ipsi(2,:),'r')
    xlim([-50 300])
    axis ij
    fon
    title('OL Correct')
    
    subplot(2,1,2)
    hold
    shadedplot(-500:2500,nanmean(wf_all.OL_errors.contra),sem.OL_errors_contra(1,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.OL_errors.contra),sem.OL_errors_contra(2,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.OL_errors.ipsi),sem.OL_errors_ipsi(1,:),'r')
    shadedplot(-500:2500,nanmean(wf_all.OL_errors.ipsi),sem.OL_errors_ipsi(2,:),'r')
    xlim([-50 300])
    axis ij
    fon
    title('OL Errors')
    
    
    %=====
    figure
    subplot(2,1,1)
    hold
    shadedplot(-500:2500,nanmean(wf_all.OR_correct.contra),sem.OR_correct_contra(1,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.OR_correct.contra),sem.OR_correct_contra(2,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.OR_correct.ipsi),sem.OR_correct_ipsi(1,:),'r')
    shadedplot(-500:2500,nanmean(wf_all.OR_correct.ipsi),sem.OR_correct_ipsi(2,:),'r')
    xlim([-50 300])
    axis ij
    fon
    title('OR Correct')
    
    subplot(2,1,2)
    hold
    shadedplot(-500:2500,nanmean(wf_all.OR_errors.contra),sem.OR_errors_contra(1,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.OR_errors.contra),sem.OR_errors_contra(2,:),'g')
    shadedplot(-500:2500,nanmean(wf_all.OR_errors.ipsi),sem.OR_errors_ipsi(1,:),'r')
    shadedplot(-500:2500,nanmean(wf_all.OR_errors.ipsi),sem.OR_errors_ipsi(2,:),'r')
    xlim([-50 300])
    axis ij
    fon
    title('OR Errors')
    
else
    
    figure
    plot(-100:500,nanmean(wf_all.Spike_correct.in),'b',-100:500,nanmean(wf_all.Spike_correct.out),'--b',-100:500,nanmean(wf_all.Spike_errors.in),'r',-100:500,nanmean(wf_all.Spike_errors.out),'--r')
    xlim([-50 300])
    fon
    title('Spike')
    
    figure
    plot(-500:2500,nanmean(wf_all.LFP_correct.in),'b',-500:2500,nanmean(wf_all.LFP_correct.out),'--b',-500:2500,nanmean(wf_all.LFP_errors.in),'r',-500:2500,nanmean(wf_all.LFP_errors.out),'--r')
    axis ij
    xlim([-50 300])
    fon
    title('LFP')
    
    figure
    plot(-500:2500,nanmean(wf_all.OL_correct.contra),'b',-500:2500,nanmean(wf_all.OL_correct.ipsi),'--b',-500:2500,nanmean(wf_all.OL_errors.contra),'r',-500:2500,nanmean(wf_all.OL_errors.ipsi),'--r')
    axis ij
    xlim([-50 300])
    fon
    title('OL')
    
    figure
    plot(-500:2500,nanmean(wf_all.OR_correct.contra),'b',-500:2500,nanmean(wf_all.OR_correct.ipsi),'--b',-500:2500,nanmean(wf_all.OR_errors.contra),'r',-500:2500,nanmean(wf_all.OR_errors.ipsi),'--r')
    axis ij
    xlim([-50 300])
    fon
    title('OR')
end