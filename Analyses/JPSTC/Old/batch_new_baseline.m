%new baseline script to compare

%plot all mean (within session) JPSTCs to see if usable/not usable

%criteria: must have noticable structure in JPSTC and must not be totally
%corrupted by noise (verify with surface plot and frequency spectra

%USING REG TO DETERMINE...SHOULD BE SAME FOR BASE_CORRECT

batch_list = dir('y:\final\JPSTC_matrices\baseline500\*.mat');




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
load(batch_list(i).name,'JPSTC_correct_ss2','JPSTC_correct_ss2_baseline','JPSTC_correct_ss4','JPSTC_correct_ss4_baseline','JPSTC_correct_ss8','JPSTC_correct_ss8_baseline','JPSTC_correct','JPSTC_correct_baseline','JPSTC_errors','JPSTC_errors_baseline')
batch_list(i).name
pause
% 
% JP_ss2 = JPSTC_correct_ss2 - JPSTC_correct_ss2_baseline;
% JP_ss4 = JPSTC_correct_ss4 - JPSTC_correct_ss4_baseline;
% JP_ss8 = JPSTC_correct_ss8 - JPSTC_correct_ss8_baseline;
% 
% JPSTC_max(1) = nanmax(nanmax(JPSTC_correct_ss2));
% JPSTC_max(2) = nanmax(nanmax(JPSTC_correct_ss4));
% JPSTC_max(3) = nanmax(nanmax(JPSTC_correct_ss8));
% JPSTC_max = nanmax(JPSTC_max);
% JPSTC_min(1) = nanmin(nanmin(JPSTC_correct_ss2));
% JPSTC_min(2) = nanmin(nanmin(JPSTC_correct_ss4));
% JPSTC_min(3) = nanmin(nanmin(JPSTC_correct_ss8));
% JPSTC_min = nanmin(JPSTC_min);
% 
% 
% JP_max(1) = nanmax(nanmax(JPSTC_correct_ss2));
% JP_max(2) = nanmax(nanmax(JPSTC_correct_ss4));
% JP_max(3) = nanmax(nanmax(JPSTC_correct_ss8));
% JP_max = nanmax(JPSTC_max);
% JP_min(1) = nanmin(nanmin(JP_ss2));
% JP_min(2) = nanmin(nanmin(JP_ss4));
% JP_min(3) = nanmin(nanmin(JP_ss8));
% JP_min = nanmin(JP_min);
% 
% 
% ax1 = subplot(3,2,1);
% surface(JPSTC_correct_ss2,'edgecolor','none')
% axis([0 450 0 450])
% colorbar
% set(ax1,'CLim',[JPSTC_min JPSTC_max])
% title('SS2')
% 
% ax3 = subplot(3,2,3);
% surface(JPSTC_correct_ss4,'edgecolor','none')
% axis([0 450 0 450])
% colorbar
% set(ax3,'CLim',[JPSTC_min JPSTC_max])
% title('SS4')
% 
% 
% ax2 = subplot(3,2,5);
% surface(JPSTC_correct_ss8,'edgecolor','none')
% axis([0 450 0 450])
% colorbar
% set(ax2,'CLim',[JPSTC_min JPSTC_max])
% title('SS8')
% 
% 
% ax4 = subplot(3,2,2);
% surface(JP_ss2,'edgecolor','none')
% axis([0 450 0 450])
% colorbar
% set(ax4,'CLim',[JP_min JP_max])
% title('SS2 corrected')
% 
% 
% ax5 = subplot(3,2,4);
% surface(JP_ss4,'edgecolor','none')
% axis([0 450 0 450])
% colorbar
% 
% set(ax5,'CLim',[JP_min JP_max])
% title('SS4 Corrected')
% 
% ax6 = subplot(3,2,6);
% surface(JP_ss8,'edgecolor','none')
% axis([0 450 0 450])
% colorbar
% set(ax6,'CLim',[JP_min JP_max])
% title('SS8 Corrected')
% 
% 
% [x,y] = suplabel(batch_list(i).name,'t');
% set(y,'FontSize',20)
% pause
% 
% subplot(3,2,1)
% cla
% subplot(3,2,2)
% cla
% subplot(3,2,3)
% cla
% subplot(3,2,4)
% cla
% subplot(3,2,5)
% cla
% subplot(3,2,6)
% cla
% 
% 


    
    
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

