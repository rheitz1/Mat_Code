% Plot movement integrators for varying level of leakage k

% sl = squeeze(nanmean(leaky_integrated_in.slow_correct_made_dead,1));
% md = squeeze(nanmean(leaky_integrated_in.med_correct,1));
% fs = squeeze(nanmean(leaky_integrated_in.fast_correct_made_dead,1));
% 


k = leak(:);

% for whichLeak = 1:length(k)
%     
%     
%     plot(-1000:200,sl(:,whichLeak),'r',-1000:200,md(:,whichLeak),'k',-1000:200,fs(:,whichLeak),'g')
%     title(['k = ' mat2str(k(whichLeak))])
%     pause
%     cla
% end





% for whichLeak = 1:length(k)
%     
%     plot(-1000:200,leaky_integrated_in.slow_correct_made_dead(:,:,whichLeak),'r', ...
%         -1000:200,leaky_integrated_in.med_correct(:,:,whichLeak),'k', ...
%         -1000:200,leaky_integrated_in.fast_correct_made_dead(:,:,whichLeak),'g')
%     title(['k = ' mat2str(k(whichLeak))])
%     pause
%     cla
% end

for whichLeak = 1:length(k)
    
    triggerVal.slow(1:76,whichLeak) = nanmean(leaky_integrated_in.slow_correct_made_dead(:,980:990,whichLeak),2);
    triggerVal.med(1:76,whichLeak) = nanmean(leaky_integrated_in.med_correct(:,980:990,whichLeak),2);
    triggerVal.fast(1:76,whichLeak) = nanmean(leaky_integrated_in.fast_correct_made_dead(:,980:990,whichLeak),2);
    
    %[h(whichLeak,1) p(whichLeak,1)] = ttest(triggerVal.slow(1:84,whichLeak),triggerVal.fast(1:84,whichLeak));
end


% for scat = 1:length(k)
%     hold on
%     j(1:84) = scat;
%     scatter(triggerVal.slow(:,scat),triggerVal.fast(:,scat),j','k')
% end
% 
% for scat = 1:length(k)
%     hold on
%     j(1:84) = scat;
%     scatter3(triggerVal.slow(:,scat),triggerVal.fast(:,scat),j','k')
% end
ex_neuron = 10;

figure
subplot(2,2,1)
cf1 = fit(nanmean(triggerVal.fast,1)',nanmean(triggerVal.slow,1)','poly2');
cf2 = fit(nanmean(triggerVal.fast,1)',nanmean(triggerVal.med,1)','poly2');

hold on
% plot(cf1,'fit')
% plot(cf2,'fit')

scatter(nanmean(triggerVal.fast,1),nanmean(triggerVal.slow,1),'r')
scatter(nanmean(triggerVal.fast,1),nanmean(triggerVal.med,1),'k')
xlabel('Movement Trigger Fast')
ylabel('Movement Trigger Accurate / Medium')

xlim([-20 300])
ylim([-20 300])
dline


%put in example point 
mS = nanmean(triggerVal.slow,1);
mM = nanmean(triggerVal.med,1);
mF = nanmean(triggerVal.fast,1);
scatter(mF(ex_neuron),mS(ex_neuron),'m')
scatter(mF(ex_neuron),mM(ex_neuron),'m')


figure
subplot(2,2,1)
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead(:,:,ex_neuron),1),'r', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct(:,:,ex_neuron),1),'k', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead(:,:,ex_neuron),1),'g')
xlim([-1000 0])
box off
set(gca,'xminortick','on')

figure
subplot(2,2,1)
plot(-1000:200,leaky_integrated_in.slow_correct_made_dead(:,:,ex_neuron),'r', ...
    -1000:200,leaky_integrated_in.med_correct(:,:,ex_neuron),'k', ...
    -1000:200,leaky_integrated_in.fast_correct_made_dead(:,:,ex_neuron),'g')
xlim([-1000 0])
box off
set(gca,'xminortick','on')

figure
subplot(2,2,1)
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,:,ex_neuron),1),'g', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,:,ex_neuron),1),'k', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,:,ex_neuron),1),'r')
title('Slow Condition')
xlim([-1000 0])
box off
set(gca,'xminortick','on')

subplot(2,2,2)
plot(-1000:200,nanmean(leaky_integrated_in.med_correct_binFast(:,:,ex_neuron),1),'g', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binMed(:,:,ex_neuron),1),'k', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binSlow(:,:,ex_neuron),1),'r')
title('Medium Condition')
xlim([-1000 0])
box off
set(gca,'xminortick','on')

subplot(2,2,3)
plot(-1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,:,ex_neuron),1),'g', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,:,ex_neuron),1),'k', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,:,ex_neuron),1),'r')
title('Fast Condition')
xlim([-1000 0])
box off
set(gca,'xminortick','on')




figure
subplot(2,2,1)
plot(-1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binFast(:,:,ex_neuron),1),'r', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binMed(:,:,ex_neuron),1),'r', ...
    -1000:200,nanmean(leaky_integrated_in.slow_correct_made_dead_binSlow(:,:,ex_neuron),1),'r')
xlim([-1000 0])
box off
set(gca,'xminortick','on')

hold on

plot(-1000:200,nanmean(leaky_integrated_in.med_correct_binFast(:,:,ex_neuron),1),'k', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binMed(:,:,ex_neuron),1),'k', ...
    -1000:200,nanmean(leaky_integrated_in.med_correct_binSlow(:,:,ex_neuron),1),'k')

plot(-1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binFast(:,:,ex_neuron),1),'g', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binMed(:,:,ex_neuron),1),'g', ...
    -1000:200,nanmean(leaky_integrated_in.fast_correct_made_dead_binSlow(:,:,ex_neuron),1),'g')

set(gca,'yaxislocation','right')
set(gca,'tickdir','out')