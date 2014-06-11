qload
getTrials

sig = baseline_correct(AD09,[3400 3500]);
sig = sig(:,3600:3800);
sig = downsample(sig',10)';

%create dataset
dat(:,1) = nanmean(sig(trials.pos0.correct,:));
dat(:,2) = nanmean(sig(trials.pos1.correct,:));
dat(:,3) = nanmean(sig(trials.pos2.correct,:));
dat(:,4) = nanmean(sig(trials.pos3.correct,:));
dat(:,5) = nanmean(sig(trials.pos4.correct,:));
dat(:,6) = nanmean(sig(trials.pos5.correct,:));
dat(:,7) = nanmean(sig(trials.pos6.correct,:));
dat(:,8) = nanmean(sig(trials.pos7.correct,:));

%specify desired target states -- what should neural network output if it
%knows the saccade direction?
T = eye(8);

net = feedforwardnet(50);
net = train(net,dat,T,nnMATLAB);