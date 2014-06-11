%Returns and saves burst start times using Poisson burst detector for each
%neuron with a defined RF

function [] = saveBursts_vamp_PopOutSEF(file)
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/PopOutFEF')
path(path,'//scratch/heitzrp/ALLDATA/PopOutSEF')
path(path,'//scratch/heitzrp/ALLDATA/TL')

load(file)

varlist = who;
NeuronList = varlist(strmatch('DSP',varlist));

for neuron = 1:length(NeuronList)
    
    sig = eval(NeuronList{neuron});
    disp(['Running burst detection for ' mat2str(NeuronList{neuron})])
    [~,~,~,BurstStartTimes.(NeuronList{neuron})] = getBurst(sig);
end

disp('Saving...')

save(['//scratch/heitzrp/Output/BurstStartFiles/PopOutSEF/' file '_bursts.mat'])



