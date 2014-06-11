% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
% cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_SAT/nooverlap/DifferentElectrode
cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_SameInterp_DiffNoInterp/NormSpec_nooverlap/
list = dir('*.mat');


%file_list = dir('*.mat');
file_list = [list];

plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
        
    %take all frequencies (up to 200 Hz)
    SpikeSpec_all.in.all.partial(1:281,1:206,sess) = pSpec.SPK.in.all;
    LFPSpec_all.in.all.partial(1:281,1:206,sess) = pSpec.LFP.in.all;
    
    SpikeSpec_all.out.all.partial(1:281,1:206,sess) = pSpec.SPK.out.all;
    LFPSpec_all.out.all.partial(1:281,1:206,sess) = pSpec.LFP.out.all;
    
    keep tout f SpikeSpec_all LFPSpec_all file_list sess plotFlag
    
end

clear plotFlag sess