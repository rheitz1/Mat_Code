cd /Users/richardheitz/Desktop/Mat_Code/Analyses/Coherence/
[file_name_SRCH sig1_name sig2_name] = textread('S_SPKLFP_overlap_allTL.txt', '%s %s %s');

for file = 1:length(file_name_SRCH)
    file_name_SRCH{file}
    [integ_corr_in(file,1) integ_corr_out(file,1) integ_corr_in_fast(file,1) integ_corr_out_fast(file,1) integ_corr_in_slow(file,1) integ_corr_out_slow(file,1)] = SDF_LFP_corr_overlap(file_name_SRCH{file},sig1_name{file},sig2_name{file});
end