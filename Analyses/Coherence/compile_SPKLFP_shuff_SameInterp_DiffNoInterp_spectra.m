% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
% cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_SAT/nooverlap/DifferentElectrode
cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_interp/overlap/SameElectrode
list1 = dir('S*.mat');

cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_nointerp/overlap/DifferentElectrode
list2 = dir('S*.mat');

path(path,'/Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_interp/overlap/SameElectrode');
path(path,'/Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_nointerp/overlap/DifferentElectrode');


%file_list = dir('*.mat');
file_list = [list1 ; list2];

plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    tout_shuff = between_cond_shuff.all.wintimes;
    
    
    %take all frequencies (up to 200 Hz)
    SpikeSpec_all.in.all.partial(1:281,1:206,sess) = PSx.in.all;
    LFPSpec_all.in.all.partial(1:281,1:206,sess) = PSy.in.all;
    
    SpikeSpec_all.in.all.reg(1:281,1:206,sess) = Sx.in.all;
    LFPSpec_all.in.all.reg(1:281,1:206,sess) = Sy.in.all;
    
    SpikeSpec_all.out.all.partial(1:281,1:206,sess) = PSx.out.all;
    LFPSpec_all.out.all.partial(1:281,1:206,sess) = PSy.out.all;
    
    SpikeSpec_all.out.all.reg(1:281,1:206,sess) = Sx.out.all;
    LFPSpec_all.out.all.reg(1:281,1:206,sess) = Sy.out.all;
    
    keep tout f tout_shuff SpikeSpec_all LFPSpec_all file_list sess plotFlag
    
end

clear plotFlag sess