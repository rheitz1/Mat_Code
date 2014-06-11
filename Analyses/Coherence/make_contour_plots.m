%load Q_overlap_SameInterp_DiffNoInterp_notPartial

newf = f(find(f < 101));
freqs = 1:104;
t = find(tout == -100):find(tout ==500);

in = nanmean(abs(coh_all.in.all),3);
out = nanmean(abs(coh_all.out.all),3);
d = in - out;


fig
contourf(tout(t),newf,in(t,freqs)',9)
colorbar
z = get(gca,'clim');
title('in')


fig
contourf(tout(t),newf,out(t,freqs)',9)
colorbar
set(gca,'clim',z)
title('out')

fig
contourf(tout(t),newf,d(t,freqs)')
colorbar
title('diff')








%=================================
%load Q_overlap_SameInterp_DiffNoInterp_spectra

newf = f(find(f < 101));
freqs = 1:104;
t = find(tout == -100):find(tout ==500);

LFP_in_reg = nanmean(log10(LFPSpec_all.in.all.reg),3);
LFP_out_reg = nanmean(log10(LFPSpec_all.out.all.reg),3);
LFP_diff_reg = LFP_in_reg - LFP_out_reg;

LFP_in_part = nanmean(log10(LFPSpec_all.in.all.partial),3);
LFP_out_part = nanmean(log10(LFPSpec_all.out.all.partial),3);
LFP_diff_part = LFP_in_part - LFP_out_part;

Spike_in_reg = nanmean(SpikeSpec_all.in.all.reg,3);
Spike_out_reg = nanmean(SpikeSpec_all.out.all.reg,3);
Spike_diff_reg = Spike_in_reg - Spike_out_reg;

Spike_in_part = nanmean(SpikeSpec_all.in.all.partial,3);
Spike_out_part = nanmean(SpikeSpec_all.out.all.partial,3);
Spike_diff_part = Spike_in_part - Spike_out_part;

fig
contourf(tout(t),newf,LFP_in_reg(t,freqs)',9);
colorbar
z = get(gca,'clim');
title('LFP in reg')

fig
contourf(tout(t),newf,LFP_out_reg(t,freqs)',9);
colorbar
set(gca,'clim',z)
title('LFP out reg')

fig
contourf(tout(t),newf,LFP_diff_reg(t,freqs)')
colorbar
title('LFP diff reg')

fig
contourf(tout(t),newf,LFP_in_part(t,freqs)',9)
colorbar
z = get(gca,'clim');
title('LFP in partial')

fig
contourf(tout(t),newf,LFP_out_part(t,freqs)',9)
colorbar
set(gca,'clim',z)
title('LFP out partial')

fig
contourf(tout(t),newf,LFP_diff_part(t,freqs)')
colorbar
title('LFP diff partial')

fig
contourf(tout(t),newf,Spike_in_reg(t,freqs)',9)
colorbar
z = get(gca,'clim');
title('Spike in reg')

fig
contourf(tout(t),newf,Spike_out_reg(t,freqs)',9)
colorbar
set(gca,'clim',z)
title('Spike out reg')

fig
contourf(tout(t),newf,Spike_diff_reg(t,freqs)')
colorbar
title('Spike diff reg')

fig
contourf(tout(t),newf,Spike_in_part(t,freqs)',9)
colorbar
z = get(gca,'clim');
title('Spike in partial')

fig
contourf(tout(t),newf,Spike_out_part(t,freqs)',9)
colorbar
set(gca,'clim',z)
title('Spike out partial')

fig
contourf(tout(t),newf,Spike_diff_part(t,freqs)')
colorbar
title('Spike diff partial')