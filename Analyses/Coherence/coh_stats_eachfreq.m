%computes vector of p values within some time window, for each frequency

pcoh_d = abs(Pcoh_all.in) - abs(Pcoh_all.out);

twin = find(tout >= 200 & tout <= 300);
compare_twin = find(tout >= -100 & tout <= 0);


for currfreq = 1:length(f)
    coh_val = nanmean(pcoh_d(twin,currfreq,:),1);
    coh_comp = nanmean(pcoh_d(compare_twin,currfreq,:),1);
    [h(currfreq,1) pval(currfreq,1)] = ttest(coh_val,coh_comp);
end

fwin.gamma = find(f >= 30 & f <= 80);
fwin.beta = find(f > 12 & f < 30);
fwin.dta = find(f >= 0 & f <= 12);





pcoh_diff.gamma = pcoh_d(twin,fwin.gamma,:);
pcoh_diff.beta = pcoh_d(twin,fwin.beta,:);
pcoh_diff.dta = pcoh_d(twin,fwin.dta,:);

pcoh_compare.gamma = pcoh_d(compare_twin,fwin.gamma,:);
pcoh_compare.beta = pcoh_d(compare_twin,fwin.beta,:);
pcoh_compare.dta = pcoh_d(compare_twin,fwin.dta,:);