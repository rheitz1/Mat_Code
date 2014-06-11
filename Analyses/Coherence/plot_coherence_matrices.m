%plots coherence matrices

figure
imagesc(tout,f,nanmean(abs(Pcoh_all.in.all),3)')
axis xy
xlim([-200 600])
colorbar
fon
title('in')


figure
imagesc(tout,f,nanmean(abs(Pcoh_all.out.all),3)')
axis xy
xlim([-200 600])
colorbar
fon
title('out')

d = nanmean(abs(Pcoh_all.in.all),3) - nanmean(abs(Pcoh_all.out.all),3);

figure
imagesc(tout,f,d')
axis xy
xlim([-200 600])
colorbar
fon
title('diff')


figure
imagesc(tout_shuff,f,err.Raw.Pos.SigClusAssign')
axis xy
xlim([-200 600])
colorbar
fon
