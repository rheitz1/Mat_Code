%DOING SEPARATELY FOR EACH MONKEY SO I CAN MANUALLY SET Y VALUES OF LINES

%MONKEY S

Spike_correct_in = allwf.neuron.in_correct(find(keeper.reg.neuron),:);
Spike_correct_out = allwf.neuron.out_correct(find(keeper.reg.neuron),:);
Spike_errors_in = allwf.neuron.in_errors(find(keeper.reg.neuron),:);
Spike_errors_out = allwf.neuron.out_errors(find(keeper.reg.neuron),:);

for t = 1:size(Spike_correct_in,2)
    [h_cor(t),p_cor(t)] = ttest(Spike_correct_in(:,t),Spike_correct_out(:,t));
end

for t = 1:size(Spike_correct_in,2)
    [h_err(t),p_err(t)] = ttest(Spike_errors_in(:,t),Spike_errors_out(:,t));
end

figure
plot(-100:500,nanmean(Spike_correct_in),'k',-100:500,nanmean(Spike_correct_out),'--k',-100:500,nanmean(Spike_errors_in),'r',-100:500,nanmean(Spike_errors_out),'--r')

xlim([-100 300])

hold on
h_cor = h_cor * 60;
plot(-100:500,h_cor,'k')


h_err = h_err * 50;
plot(-100:500,h_err,'r')

clear h_cor p_cor h_err c_err



LFP_correct_in = allwf.LFP.Hemi.in_correct(find(keeper.reg.LFP),:);
LFP_correct_out = allwf.LFP.Hemi.out_correct(find(keeper.reg.LFP),:);
LFP_errors_in = allwf.LFP.Hemi.in_errors(find(keeper.reg.LFP),:);
LFP_errors_out = allwf.LFP.Hemi.out_errors(find(keeper.reg.LFP),:);


for t = 1:size(LFP_correct_in,2)
    [h_cor(t),p_cor(t)] = ttest(LFP_correct_in(:,t),LFP_correct_out(:,t));
end

for t = 1:size(LFP_correct_in,2)
    [h_err(t),p_err(t)] = ttest(LFP_errors_in(:,t),LFP_errors_out(:,t));
end

figure
plot(-500:2500,nanmean(LFP_correct_in),'k',-500:2500,nanmean(LFP_correct_out),'--k',-500:2500,nanmean(LFP_errors_in),'r',-500:2500,nanmean(LFP_errors_out),'--r')
axis ij
xlim([-100 300])

hold on
h_cor = h_cor * -.02;
plot(-500:2500,h_cor,'k')


h_err = h_err * -.01;
plot(-500:2500,h_err,'r')

clear h_cor p_cor h_err c_err





OR_correct_contra = allwf.OR.in_correct(find(keeper.reg.OR),:);
OR_correct_ipsi = allwf.OR.out_correct(find(keeper.reg.OR),:);
OR_errors_contra = allwf.OR.in_errors(find(keeper.reg.OR),:);
OR_errors_ipsi = allwf.OR.out_errors(find(keeper.reg.OR),:);


for t = 1:size(OR_correct_contra,2)
    [h_cor(t),p_cor(t)] = ttest(OR_correct_contra(:,t),OR_correct_ipsi(:,t));
end

for t = 1:size(OR_correct_contra,2)
    [h_err(t),p_err(t)] = ttest(OR_errors_contra(:,t),OR_errors_ipsi(:,t));
end

figure
plot(-500:2500,nanmean(OR_correct_contra),'k',-500:2500,nanmean(OR_correct_ipsi),'--k',-500:2500,nanmean(OR_errors_contra),'r',-500:2500,nanmean(OR_errors_ipsi),'--r')
axis ij
xlim([-100 300])

hold on
h_cor = h_cor * -.007;
plot(-500:2500,h_cor,'k')


h_err = h_err * -.006;
plot(-500:2500,h_err,'r')

clear h_cor p_cor h_err c_err