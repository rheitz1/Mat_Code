%timing scatter plot for fast vs slow coherence.  Criterion = > 2*std

crit.fast = nanmean(fsdif,1) + nanstd(fsdif,1,1) .* 2;
crit.slow = nanmean(sldif,1) + nanstd(sldif,1,1) .* 2;
crit.fast_bc = nanstd(fsdif_bc,1,1) .* 2;
crit.slow_bc = nanstd(sldif_bc,1,1) .* 2;

for sess = 1:size(fsdif,2) %note we are moving in the 2nd dimension; we did not transpose
    try
        temp = tout(find(fsdif(:,sess) > crit.fast(sess)));
        time.fast(sess,1) = temp(find(temp >= 100,1));
        clear temp
    catch
        time.fast(sess,1) = NaN;
    end
    
    try
        temp = tout(find(sldif(:,sess) > crit.slow(sess),1));
        time.slow(sess,1) = temp(find(temp >= 100,1));
        clear temp
    catch
        time.slow(sess,1) = NaN;
    end
    
    try
        temp = tout(find(fsdif_bc(:,sess) > crit.fast_bc(sess),1));
        time.fast_bc(sess,1) = temp(find(temp >= 100,1));
        clear temp
    catch
        time.fast_bc(sess,1) = NaN;
    end
    
    try
        temp = tout(find(sldif_bc(:,sess) > crit.slow_bc(sess),1));
        time.slow_bc(sess,1) = temp(find(temp >= 100,1));
        clear temp
    catch
        time.slow_bc(sess,1) = NaN;
    end
end

figure
scatter(time.fast_bc,time.slow_bc)
dline

x = [time.fast_bc time.slow_bc];
x = removeNaN(x)
[a b] = ttest(x(:,1),x(:,2))

