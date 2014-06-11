if ndims(leak) < 3; error('Check Leak Variable'); end

leak = squeeze(leak);
leak = leak(:);

pred = (0:2)';


%DO NOT USE LONGBASE FILES!
threshwin = 980:990;
accumulator_time = -1000:200;

for whichLeak = 1:length(leak)
    
    triggerVal_made.correct_slow(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_in.slow_correct_made_dead(:,threshwin,whichLeak),2);
    triggerVal_made.correct_med(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_in.med_correct(:,threshwin,whichLeak),2);
    triggerVal_made.correct_fast(1:size(leaky_integrated_in.slow_correct_made_dead,1),whichLeak) = nanmean(leaky_integrated_in.fast_correct_made_dead(:,threshwin,whichLeak),2);
end




for k = 1:length(leak)
    mat = [triggerVal_made.correct_slow(:,k)' ; triggerVal_made.correct_med(:,k)' ; triggerVal_made.correct_fast(:,k)'];
    
    for n = 1:size(mat,2)
        [m(n) b(n) r(n)] = linreg(mat(:,n),pred,0);
    end

    mean_slope(k) = nanmean(m);
    all_slopes(1:size(mat,2),k) = m';
    
    [h(k) p(k)] = ttest(m,0);
    
    clear m b r mat
    
end
    