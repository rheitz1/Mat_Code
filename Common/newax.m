% Quickly creates secondary axis
% RPH

ax1 = gca;
ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
hold on