% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
cd /volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_shuff_allTL_corrected/overlap/SameElectrode/

file_list = dir('cQ*.mat');
plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    tout_shuff = between_cond_shuff.all.wintimes;
    
    SpikeSpec_all.in.all.partial(1:281,1:104,sess) = PSx.in.all;
    LFPSpec_all.in.all.partial(1:281,1:104,sess) = PSy.in.all;
    
    SpikeSpec_all.in.all.reg(1:281,1:104,sess) = Sx.in.all;
    LFPSpec_all.in.all.reg(1:281,1:104,sess) = Sy.in.all;
    
    SpikeSpec_all.out.all.partial(1:281,1:104,sess) = PSx.out.all;
    LFPSpec_all.out.all.partial(1:281,1:104,sess) = PSy.out.all;
    
    SpikeSpec_all.out.all.reg(1:281,1:104,sess) = Sx.out.all;
    LFPSpec_all.out.all.reg(1:281,1:104,sess) = Sy.out.all;
    
    keep tout_shuff SpikeSpec_all LFPSpec_all file_list sess plotFlag
    
end

clear plotFlag sess