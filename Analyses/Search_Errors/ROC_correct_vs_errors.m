corrROC.neuron = allROC.neuron.correct(find(keeper.reg.neuron),:);
corrROC_sub.neuron = allROC_sub.neuron.correct(find(keeper.reg.neuron),:);

errROC.neuron = allROC.neuron.errors(find(keeper.reg.neuron),:);
errROC_sub.neuron = allROC_sub.neuron.errors(find(keeper.reg.neuron),:);


% find onset time of ROC

RTs.correct = allRTs.neuron.correct(find(keeper.reg.neuron));
RTs.errors = allRTs.neuron.errors(find(keeper.reg.neuron));

ROCdiff = peakvals.neuron.correct - peakvals.neuron.errors;
RTdiff = RTs.correct - RTs.errors;