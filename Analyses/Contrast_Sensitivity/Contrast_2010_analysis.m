%contrast analysis

find_keepers.neuron = 1;
find_keepers.LFP = 1;

if find_keepers.neuron == 1
    figure
    
    for sess = 1:size(SDF.low,1)
        plot(-100:500,SDF.high(sess,:),'k',-100:500,SDF.med(sess,:),'b',-100:500,SDF.low(sess,:),'r')
        xlim([-100 500])
        keeper.neuron(sess,1) = input('Keep?');
        cla
    end
end

figure
plot(-100:500,nanmean(SDF.high(find(keeper.neuron),:)),'k', ...
    -100:500,nanmean(SDF.med(find(keeper.neuron),:)),'b', ...
    -100:500,nanmean(SDF.low(find(keeper.neuron),:)),'r')

        
if find_keepers.LFP == 1
    figure
    
    for sess = 1:size(LFP.low,1)
        plot(-500:2500,LFP.high(sess,:),'k',-500:2500,LFP.med(sess,:),'b',-500:2500,LFP.low(sess,:),'r')
        xlim([-100 500])
        axis ij
        keeper.LFP(sess,1) = input('Keep?');
        cla
    end
end

figure
plot(-500:2500,nanmean(LFP.high(find(keeper.LFP),:)),'k', ...
    -500:2500,nanmean(LFP.med(find(keeper.LFP),:)),'b', ...
    -500:2500,nanmean(LFP.low(find(keeper.LFP),:)),'r')
axis ij
xlim([-100 500])



figure
subplot(3,2,1)
plot(-100:500,nanmean(SDF.low),'r',-100:500,nanmean(SDF.med),'b',-100:500,nanmean(SDF.high),'k')
xlim([-100 500])
vline(nanmean(Bursts.low.median),'r')
vline(nanmean(Bursts.med.median),'b')
vline(nanmean(Bursts.high.median),'k')

subplot(3,2,2)
graylines(11)
plot(-100:500,nanmean(SDF.bin11),-100:500,nanmean(SDF.bin10),-100:500,nanmean(SDF.bin9), ...
    -100:500,nanmean(SDF.bin8), -100:500,nanmean(SDF.bin7),-100:500,nanmean(SDF.bin6), ...
    -100:500,nanmean(SDF.bin5), -100:500,nanmean(SDF.bin4),-100:500,nanmean(SDF.bin3), ...
    -100:500,nanmean(SDF.bin2), -100:500,nanmean(SDF.bin1))
xlim([-100 500])


subplot(3,2,4)
plot([1:11],[nanmean(Bursts.bin1.median) nanmean(Bursts.bin2.median) nanmean(Bursts.bin3.median) ...
    nanmean(Bursts.bin4.median) nanmean(Bursts.bin5.median) nanmean(Bursts.bin6.median) ...
    nanmean(Bursts.bin7.median) nanmean(Bursts.bin8.median) nanmean(Bursts.bin9.median) ...
    nanmean(Bursts.bin10.median) nanmean(Bursts.bin11.median)])