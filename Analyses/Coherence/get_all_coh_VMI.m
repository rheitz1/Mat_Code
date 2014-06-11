% Returns VMI histograms for the Spike-Field Coherence analyses

[filename SPKname] = textread('SPKLFP_overlap_allTL_MG.txt','%s %s');


for file = 1:length(filename)
    filename{file}
    load(filename{file});
    
    VMI(file,1) = getVMI(SPKname{file});
    
    keep filename SPKname file VMI
end
