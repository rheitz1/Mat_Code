neuron_index = 1;

cd /Volumes/Dump/Analyses/Task_Engagement/2000_trials/Matrices
batch_list = dir('Q*.mat');

for i = 1:length(batch_list);
    batch_list(i).name
    load(batch_list(i).name)
    
    allfields = fields(TDT);
    
    
    if batch_list(i).name(1) == 'Q'
        monkey(i,1) = 'Q';
    elseif batch_list(i).name(1) == 'S'
        monkey(i,1) = 'S';
    end
    
    
    
    %Neuron TDTs
    neuronlist = allfields(strmatch('DSP',allfields));
    
    
    for f = 1:size(neuronlist,1)
        
        
        allROC.neuron(1:size(ROC.(neuronlist{f}).x,1),1:601,neuron_index) = ROC.(neuronlist{f}).x;
        allRT.neuron(1:size(RT.(neuronlist{f}).x,1),1,neuron_index) = RT.(neuronlist{f}).x;
        allTDT.neuron(1:size(TDT.(neuronlist{f}).x,1),1,neuron_index) = TDT.(neuronlist{f}).x;
        allbinprob.neuron(neuron_index,1:size(binprob.(neuronlist{f}),2)) = binprob.(neuronlist{f});
        allwf.neuron.in(1:size(wf.(neuronlist{f}).in,1),1:601,neuron_index) = wf.(neuronlist{f}).in;
        allwf.neuron.out(1:size(wf.(neuronlist{f}).out,1),1:601,neuron_index) = wf.(neuronlist{f}).out;
        
        neuron_index = neuron_index + 1;
        
    end   %for neuronlist
    
    
    
    
    
    keep allROC allRT allTDT allbinprob allwf neuron_index batch_list i
    
end

clear batch_list i neuron_index

%===========================
% remove 0's
allwf.neuron.in(find(allwf.neuron.in == 0)) = NaN;
allwf.neuron.out(find(allwf.neuron.out == 0)) = NaN;
allRT.neuron(find(allRT.neuron == 0)) = NaN;
allTDT.neuron(find(allTDT.neuron ==0)) = NaN;
allROC.neuron(find(allROC.neuron == 0)) = NaN;


%remove all 0's from binomial probabilities but have to skip first column,
%which can be 0 lawfully
x = allbinprob.neuron(:,2:end);
x(find(x == 0)) = NaN;
allbinprob.neuron = [allbinprob.neuron(:,1) x];
%===========================


f = figure;
hold
graymap = linspace(0,.9,size(allwf.neuron.in,1)); %set dimmest color to be .9 so its always visible
for plt = 1:size(allwf.neuron.in,1)
    plot(-100:500,nanmean(allwf.neuron.in(plt,:,:),3),'-',-100:500,nanmean(allwf.neuron.out(plt,:,:),3),'--','Color',[graymap(plt) graymap(plt) graymap(plt)])
    xlim([-100 500])
end

f = figure;
hold
graymap = linspace(0,.9,size(allROC.neuron,1)); %set dimmest color to be .9 so its always visible
for plt = 1:size(allROC.neuron,1)
    plot(-100:500,nanmean(allROC.neuron(plt,:,:),3),'Color',[graymap(plt) graymap(plt) graymap(plt)])
    xlim([-100 500])
end
title('ROC')

%average ROC areas (on average) 150-300 ms post target onset
f = figure;
fw
plot(nanmean(nanmean(allROC.neuron(:,250:400,:),3),2))
title('Average ROC 150-300 ms')