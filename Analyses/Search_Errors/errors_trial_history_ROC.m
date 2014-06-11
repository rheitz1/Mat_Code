%Generate ROC curves depicting the difference in selectivity over time for
%different trial history conditions USING AVERAGES

%Neuron
cc.in = allwf.neuron.in_c_c(find(keeper.history.neuron_e_e),:);
cc.out = allwf.neuron.out_c_c(find(keeper.history.neuron_e_e),:);
ec.in = allwf.neuron.in_e_c(find(keeper.history.neuron_e_e),:);
ec.out = allwf.neuron.out_e_c(find(keeper.history.neuron_e_e),:);
ce.in = allwf.neuron.in_c_e(find(keeper.history.neuron_e_e),:);
ce.out = allwf.neuron.out_c_e(find(keeper.history.neuron_e_e),:);
ee.in = allwf.neuron.in_e_e(find(keeper.history.neuron_e_e),:);
ee.out = allwf.neuron.out_e_e(find(keeper.history.neuron_e_e),:);

allcc = [cc.in;cc.out];
allec = [ec.in;ec.out];
allce = [ce.in;ce.out];
allee = [ee.in;ee.out];

intrials = 1:size(cc.in,1);
outtrials = size(cc.in,1)+1:(2*size(cc.in,1));

ccROC = getROC(allcc,intrials,outtrials);
ecROC = getROC(allec,intrials,outtrials);
ceROC = getROC(allce,outtrials,intrials); %invert trials so selectivity always goes positive
eeROC = getROC(allee,outtrials,intrials);

figure
plot(-100:500,ccROC,'k',-100:500,ecROC,'b', ...
    -100:500,ceROC,'r',-100:500,eeROC,'g')
fw
xlim([-50 300])
ccav = nanmean(ccROC(250:400));
ceav = nanmean(ceROC(250:400));
ecav = nanmean(ecROC(250:400));
eeav = nanmean(eeROC(250:400));

figure
plot(1:4,[ccav ecav ceav eeav],'b')
fw
clear allcc allce allec allee cc ccROC ce ceROC ec ecROC ee eeROC


%LFP
cc.in = allwf.LFP.Hemi.in_c_c(find(keeper.history.LFP_e_e),:);
cc.out = allwf.LFP.Hemi.out_c_c(find(keeper.history.LFP_e_e),:);
ec.in = allwf.LFP.Hemi.in_e_c(find(keeper.history.LFP_e_e),:);
ec.out = allwf.LFP.Hemi.out_e_c(find(keeper.history.LFP_e_e),:);
ce.in = allwf.LFP.Hemi.in_c_e(find(keeper.history.LFP_e_e),:);
ce.out = allwf.LFP.Hemi.out_c_e(find(keeper.history.LFP_e_e),:);
ee.in = allwf.LFP.Hemi.in_e_e(find(keeper.history.LFP_e_e),:);
ee.out = allwf.LFP.Hemi.out_e_e(find(keeper.history.LFP_e_e),:);
 
allcc = [cc.in;cc.out];
allec = [ec.in;ec.out];
allce = [ce.in;ce.out];
allee = [ee.in;ee.out];
 
intrials = 1:size(cc.in,1);
outtrials = size(cc.in,1)+1:(2*size(cc.in,1));
 
ccROC = getROC(allcc(:,650:800),outtrials,intrials); %invert out/in trials so selection will go positive (note is inverted a second time because is LFP)
ecROC = getROC(allec(:,650:800),outtrials,intrials);
ceROC = getROC(allce(:,650:800),intrials,outtrials);
eeROC = getROC(allee(:,650:800),intrials,outtrials);
 
figure
plot(150:300,ccROC,'k',150:300,ecROC,'b', ...
    150:300,ceROC,'r',150:300,eeROC,'g')
fw
xlim([150 300])

ccav = nanmean(ccROC(50:150));
ceav = nanmean(ceROC(50:150));
ecav = nanmean(ecROC(50:150));
eeav = nanmean(eeROC(50:150));

figure
plot(1:4,[ccav ecav ceav eeav],'b')
fw
clear allcc allce allec allee cc ccROC ce ceROC ec ecROC ee eeROC




%OR
cc.in = allwf.OR.in_c_c(find(keeper.history.OR_e_e),:);
cc.out = allwf.OR.out_c_c(find(keeper.history.OR_e_e),:);
ec.in = allwf.OR.in_e_c(find(keeper.history.OR_e_e),:);
ec.out = allwf.OR.out_e_c(find(keeper.history.OR_e_e),:);
ce.in = allwf.OR.in_c_e(find(keeper.history.OR_e_e),:);
ce.out = allwf.OR.out_c_e(find(keeper.history.OR_e_e),:);
ee.in = allwf.OR.in_e_e(find(keeper.history.OR_e_e),:);
ee.out = allwf.OR.out_e_e(find(keeper.history.OR_e_e),:);
 
allcc = [cc.in;cc.out];
allec = [ec.in;ec.out];
allce = [ce.in;ce.out];
allee = [ee.in;ee.out];
 
intrials = 1:size(cc.in,1);
outtrials = size(cc.in,1)+1:(2*size(cc.in,1));
 
ccROC = getROC(allcc(:,650:800),intrials,outtrials);
ecROC = getROC(allec(:,650:800),intrials,outtrials);
ceROC = getROC(allce(:,650:800),outtrials,intrials);
eeROC = getROC(allee(:,650:800),outtrials,intrials);
 
figure
plot(150:300,ccROC,'k',150:300,ecROC,'b', ...
    150:300,ceROC,'r',150:300,eeROC,'g')
fw
xlim([150 300])

ccav = nanmean(ccROC(1:50)); %note different time window
ceav = nanmean(ceROC(1:50));
ecav = nanmean(ecROC(1:50));
eeav = nanmean(eeROC(1:50));

figure
plot(1:4,[ccav ecav ceav eeav],'b')
fw
clear allcc allce allec allee cc ccROC ce ceROC ec ecROC ee eeROC ccav ceav ecav eeav

% plot(-100:500,nanmean(cc.in),'k',-100:500,nanmean(cc.out),'--k', ...
%     -100:500,nanmean(ec.in),'b',-100:500,nanmean(ec.out),'--b', ...
%     -100:500,nanmean(ce.in),'r',-100:500,nanmean(ce.out),'--r', ...
%     -100:500,nanmean(ee.in),'g',-100:500,nanmean(ee.out),'--g')