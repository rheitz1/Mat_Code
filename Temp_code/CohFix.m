%fixes axes labels for coherence plots
axis xy
axhand = gca;
set(axhand,'XTickLabel',tvals_targ)
set(axhand,'XTick',tind_targ)
set(axhand,'YTickLabel',freqvals_targ)
set(axhand,'YTick',freqind_targ)
colorbar