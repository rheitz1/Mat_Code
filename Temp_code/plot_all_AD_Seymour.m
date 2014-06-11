function [] = plot_all_AD_Seymour(file)

ChanStruct = loadChan(file,'AD');
decodeChanStruct;

load(file,'Target_','Correct_')

left = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1);
right = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1);

figure
set(gcf,'color','white')

subplot(3,3,1)
plot(-500:2500,nanmean(AD01(left,:)),'r',-500:2500,nanmean(AD01(right,:)),'--r')
legend('Left Hemi','Right Hemi')
xlim([0 500])
axis ij
title('Oz','fontweight','bold')

subplot(3,3,2)
plot(-500:2500,nanmean(AD03(left,:)),'r',-500:2500,nanmean(AD03(right,:)),'--r')
xlim([0 500])
axis ij
title('OL','fontweight','bold')

subplot(3,3,3)
plot(-500:2500,nanmean(AD02(left,:)),'r',-500:2500,nanmean(AD02(right,:)),'--r')
xlim([0 500])
axis ij
title('OR','fontweight','bold')

subplot(3,3,4)
plot(-500:2500,nanmean(AD05(left,:)),'r',-500:2500,nanmean(AD05(right,:)),'--r')
xlim([0 500])
axis ij
title('C3','fontweight','bold')

subplot(3,3,5)
plot(-500:2500,nanmean(AD04(left,:)),'r',-500:2500,nanmean(AD04(right,:)),'--r')
xlim([0 500])
axis ij
title('C4','fontweight','bold')

subplot(3,3,6)
plot(-500:2500,nanmean(AD07(left,:)),'r',-500:2500,nanmean(AD07(right,:)),'--r')
xlim([0 500])
axis ij
title('F3','fontweight','bold')

subplot(3,3,7)
plot(-500:2500,nanmean(AD06(left,:)),'r',-500:2500,nanmean(AD06(right,:)),'--r')
xlim([0 500])
axis ij
title('F4','fontweight','bold')

if exist('AD09') == 1
    subplot(3,3,8)
    plot(-500:2500,nanmean(AD09(left,:)),'r',-500:2500,nanmean(AD09(right,:)),'--r')
    xlim([0 500])
    axis ij
    title('LFP Left','fontweight','bold')
end

if exist('AD10') == 1
    subplot(3,3,9)
    plot(-500:2500,nanmean(AD10(left,:)),'r',-500:2500,nanmean(AD10(right,:)),'--r')
    xlim([0 500])
    axis ij
    title('LFP Right','fontweight','bold')
end

[ax,h] = suplabel(file,'t');
set(h,'fontsize',13,'fontweight','bold')
[ax,h]=suplabel(['N = ' mat2str(size(Correct_,1))]);
set(h,'fontsize',13,'fontweight','bold')