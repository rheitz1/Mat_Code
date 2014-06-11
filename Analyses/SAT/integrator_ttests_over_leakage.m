%do all paired t-tests and record p values testing binFast versus binSlow across all leakages


for k = 1:length(leak)
    
    slow.slow = nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,980:990,k),2);
    slow.med = nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,980:990,k),2);
    slow.fast = nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,980:990,k),2);
    med.slow = nanmean(leaky_integrated_in.med_correct_binSlow(:,980:990,k),2);
    med.med = nanmean(leaky_integrated_in.med_correct_binMed(:,980:990,k),2);
    med.fast = nanmean(leaky_integrated_in.med_correct_binFast(:,980:990,k),2);
    fast.slow = nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,980:990,k),2);
    fast.med = nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,980:990,k),2);
    fast.fast = nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,980:990,k),2);
    
    slow.slow_miss = nanmean(leaky_integrated_in.slow_correct_missed_dead_binSlow(:,980:990,k),2);
    slow.med_miss = nanmean(leaky_integrated_in.slow_correct_missed_dead_binMed(:,980:990,k),2);
    slow.fast_miss = nanmean(leaky_integrated_in.slow_correct_missed_dead_binFast(:,980:990,k),2);
    fast.slow_miss = nanmean(leaky_integrated_in.fast_correct_missed_dead_binSlow(:,980:990,k),2);
    fast.med_miss = nanmean(leaky_integrated_in.fast_correct_missed_dead_binMed(:,980:990,k),2);
    fast.fast_miss = nanmean(leaky_integrated_in.fast_correct_missed_dead_binFast(:,980:990,k),2);
    
    [p.acc(k,1) h] = ranksum(slow.slow,slow.fast);
    
    z = removeNaN([med.slow med.fast]);
    [p.neut(k,1) h] = ranksum(z(:,1),z(:,2));
    [p.fast(k,1) h] = ranksum(fast.slow,fast.fast);
    [p.acc_miss(k,1) h] = ranksum(slow.slow_miss,slow.fast_miss);
    [p.fast_miss(k,1) h] = ranksum(fast.slow_miss,fast.fast_miss);
end

fig
plot(1./(.001:.001:.1),p.acc,'-or',1./(.001:.001:.1),p.neut,'-ok',1./(.001:.001:.1),p.fast,'-og', ...
    1./(.001:.001:.1),p.acc_miss,'--or',1./(.001:.001:.1),p.fast_miss,'--og')