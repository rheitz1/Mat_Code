%quick script to fix orientation & add color bar to coherence plots
axis xy
colorbar
lim = get(gca,'clim')
ylabel('Frequency (Hz)','fontsize',18','fontweight','bold')
xlabel('Time from array onset (ms)','fontsize',18,'fontweight','bold')
box off

