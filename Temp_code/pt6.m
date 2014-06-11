[file_name_SRCH sig1_name sig2_name] = textread('SPKLFP_sameElect.txt', '%s %s %s');

for file = 46:50
    pCOHERENCE_SPKLFP_Tune_NeurRF_isect_vamp_overlap_ntile(file_name_SRCH{file},sig1_name{file},sig2_name{file})
end