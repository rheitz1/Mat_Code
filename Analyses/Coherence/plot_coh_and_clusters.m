for sess = 1:size(Pcoh_all.in.all,3)
    subplot(2,3,1)
    imagesc(tout,f,abs(Pcoh_all.in.all(:,:,sess)'));
    axis xy
    xlim([100 700])
    colorbar
    title('in coh')
    
    subplot(2,3,2)
    imagesc(err_all.wintimes,f,err_all.in.all.PosClus(:,:,sess)');
    axis xy
    title('in Pos Clus')
    
    subplot(2,3,3)
    imagesc(err_all.wintimes,f,err_all.in.all.NegClus(:,:,sess)');
    axis xy
    title('in Neg Clus')
    
    subplot(2,3,4)
    imagesc(tout,f,abs(Pcoh_all.out.all(:,:,sess)'));
    axis xy
    xlim([100 700])
    colorbar
    title('out Coh')
    
    subplot(2,3,5)
    imagesc(err_all.wintimes,f,err_all.out.all.PosClus(:,:,sess)');
    axis xy
    title('Out Pos Clus')
    
    subplot(2,3,6)
    imagesc(err_all.wintimes,f,err_all.out.all.NegClus(:,:,sess)');
    axis xy
    title('Out Neg Clus')
    
    pause
end