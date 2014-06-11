% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
% cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_SAT/nooverlap/DifferentElectrode
cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_nointerp/overlap/SameElectrode
list1 = dir('S*.mat');

cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_nointerp/overlap/DifferentElectrode
list2 = dir('S*.mat');

path(path,'/Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_nointerp/overlap/SameElectrode');
path(path,'/Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_nointerp/overlap/DifferentElectrode');


%file_list = dir('*.mat');
file_list = [list1 ; list2];

plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    tout_shuff = between_cond_shuff.all.wintimes;
    
    %limit to bottom frequencies (calculated up to 200 Hz)
    SpikeSpec_all.in.all.partial(1:281,1:104,sess) = PSx.in.all(:,1:104);
    LFPSpec_all.in.all.partial(1:281,1:104,sess) = PSy.in.all(:,1:104);
    
    SpikeSpec_all.in.all.reg(1:281,1:104,sess) = Sx.in.all(:,1:104);
    LFPSpec_all.in.all.reg(1:281,1:104,sess) = Sy.in.all(:,1:104);
    
    SpikeSpec_all.out.all.partial(1:281,1:104,sess) = PSx.out.all(:,1:104);
    LFPSpec_all.out.all.partial(1:281,1:104,sess) = PSy.out.all(:,1:104);
    
    SpikeSpec_all.out.all.reg(1:281,1:104,sess) = Sx.out.all(:,1:104);
    LFPSpec_all.out.all.reg(1:281,1:104,sess) = Sy.out.all(:,1:104);
    
    keep tout_shuff SpikeSpec_all LFPSpec_all file_list sess plotFlag
    
end

clear plotFlag sess