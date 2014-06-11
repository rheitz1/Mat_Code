%plot all mean (within session) JPSTCs to see if usable/not usable

%criteria: must have noticable structure in JPSTC and must not be totally
%corrupted by noise (verify with surface plot and frequency spectra

%USING REG TO DETERMINE...SHOULD BE SAME FOR BASE_CORRECT

  batch_list1 = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-LFP/BetweenHemi/*.mat');
 batch_list2 = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-LFP/WithinHemi/*.mat');
%  batch_list1 = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-EEG/*.mat');
% batch_list2 = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-EEG/*.mat');

batch_list = cat(1,batch_list1,batch_list2);

figure
orient landscape
set(gcf,'color','white')



% 
% for i = 1:length(batch_list)
% load(batch_list(i).name,'JPSTC_correct_homo','JPSTC_correct_hete')
% 
% z = JPSTC_correct_hete - JPSTC_correct_homo;
% surface(z,'edgecolor','none')
% colorbar
% axis([0 450 0 450])
% pause
% cla











for i = 1:length(batch_list)
load(batch_list(i).name,'JPSTC_correct_ss2','JPSTC_correct_ss4','JPSTC_correct_ss8','JPSTC_correct','JPSTC_errors')

ss2_4 = JPSTC_correct_ss2 - JPSTC_correct_ss4;
ss2_8 = JPSTC_correct_ss2 - JPSTC_correct_ss8;
c_e = JPSTC_correct - JPSTC_errors;

ax1 = subplot(1,3,1);
surface(ss2_4,'edgecolor','none')
axis([0 450 0 450])
colorbar
lim1 = nanmin(min(ss2_4));
lim2 = nanmax(max(ss2_4));
set(ax1,'CLim',[lim1 lim2])
title('SS2 - SS4')

ax2 = subplot(1,3,2);
surface(ss2_8,'edgecolor','none')
axis([0 450 0 450])
colorbar
set(ax2,'CLim',[lim1 lim2])
title('SS2 - SS8')

ax3 = subplot(1,3,3);
surface(c_e,'edgecolor','none')
axis([0 450 0 450])
colorbar
set(ax3,'CLim',[lim1 lim2])
title('Correct - Errors')

[x,y] = suplabel(batch_list(i).name,'t');
set(y,'FontSize',20)
pause

subplot(1,3,1)
cla
subplot(1,3,2)
cla
subplot(1,3,3)
cla
    




    
    
%     load(batch_list(i).name,'JPSTC_correct','wf_sig1_correct','wf_sig2_correct')
%     [freq FFT1] = getFFT(wf_sig1_correct);
%     [freq FFT2] = getFFT(wf_sig2_correct);
% 
% 
%     h = figure;
%     orient landscape
%     set(gcf,'color','white')
%     subplot(2,1,1)
%     surface(JPSTC_correct,'edgecolor','none')
%     axis([0 450 0 450])
%     set(gca,'XTick',0:100:450)
% 
%     set(gca,'YTick',0:100:450)
%     set(gca,'XTickLabel',-50:100:400)
%     set(gca,'YTickLabel',[])
%     title(batch_list(i).name)
% 
%     subplot(2,1,2)
%     plot(freq(5:end),FFT1(5:end),'b','linewidth',1)
%     xlim([10 80])
%     ylabel('Power','fontweight','bold')
%     xlabel('Time','fontweight','bold')
%     set(gca,'ytick',[])
%     ax1 = gca;
%     ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
%     hold;
%     plot(freq(5:end),FFT2(5:end),'r','linewidth',1)
%     xlim([10 80])
%     set(gca,'xtick',[])
%     set(gca,'ytick',[])
%     hold off
% 
%     pause
%     close(h)
end

