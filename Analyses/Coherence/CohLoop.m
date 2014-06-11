cd ~/desktop/Mat_Code/Analyses/Coherence/
[file_name sig1_name sig2_name] = textread('SAT_Coherence_overlap.txt', '%s %s %s');


longBase
for file = 211:length(file_name)
    file_name{file}
    pCOH_SAT_SPKLFP_alltrls_shuff(file_name{file},sig1_name{file},sig2_name{file});
end