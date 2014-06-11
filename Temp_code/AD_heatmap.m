function [] = AD_heatmap(AD,SRT,Plot_Time)
%Create heat map of AD channels
%AD == AD channel to be analyzed
%SRT = SRT values, will be sorted in function

if size(AD,1) ~= size(SRT,1)
    disp('Error - SRT and AD not the same lengths')
    return
end

%put AD in ascending order relative to SRT
temp = [AD SRT(:,1)];
temp = sortrows(temp,size(temp,2));
sortedAD = temp(1:size(temp,1),1:size(temp,2)-1);

% sortedERP is the matrix of single trial ERPs
figure
set(gcf,'color','white')
orient landscape

%imagesc(Plot_Time(1):Plot_Time(2),[min(min(sortedAD)) max(max(sortedAD))],sortedAD)
imagesc(Plot_Time(1):Plot_Time(2),[-.1 .1],sortedAD)
axis xy
colorbar
%set(gca,'ytick',[])
hold
plot(Plot_Time(1):Plot_Time(2),mean(sortedAD),'k','linewidth',2)    

ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            set(gca,'xtick',[])
            set(gca,'ytick',[])
hold on
% [CDF bins] = getCDF(SRT(:,1),30);
% plot(bins,CDF,'r','linewidth',2)
%         
