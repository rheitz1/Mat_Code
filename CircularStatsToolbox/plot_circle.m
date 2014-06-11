% Plot a perfect circle using relationship of circle to sin and cosine with optional radius.  Unit circle
% when rad = 1.

rad = 100;
x = linspace(0,2*pi,100);

figure
set(gcf,'color','white')
box off

plot(sin(x)*rad,cos(x)*rad,'r','linewidth',2)
hold on
plot(0,0,'ok','markerfacecolor','k')
xlim([-rad - rad rad + rad])
ylim([-rad - rad rad + rad])
line([0 rad],[0 0],'color','k','linewidth',2)

set(gca,'fontsize',12,'fontweight','bold')
title(['Circle with radius = ' mat2str(rad)])