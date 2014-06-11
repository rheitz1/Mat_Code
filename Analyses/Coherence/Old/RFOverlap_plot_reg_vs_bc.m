figure
set(gcf,'color','white')
orient landscape
hold

for sess = 1:size(coh_targ_all.correct_in,3)
    subplot(2,2,1)
    imagesc(tout,f_targ,abs(coh_targ_all.correct_in(:,:,sess)'))
    colorbar
    axis xy
    xlim([-200 900])
    col(1,1:2) = get(gca,'CLim');

    subplot(2,2,2)
    imagesc(tout,f_targ,abs(coh_targ_all.correct_out(:,:,sess)'))
    colorbar
    axis xy
    xlim([-200 900])
    col(2,1:2) = get(gca,'CLim');
% 
%     newcol = [min(col(:,1)) max(col(:,2))];
%     subplot(2,2,1)
%     set(gca,'CLim',newcol)
%     subplot(2,2,2)
%     set(gca,'CLim',newcol)

    subplot(2,2,3)
    imagesc(tout,f_targ,coh_targ_all_bc.correct_in(:,:,sess))
    colorbar
    axis xy
    xlim([-200 900])
    col(1,1:2) = get(gca,'CLim');

    subplot(2,2,4)
    imagesc(tout,f_targ,coh_targ_all_bc.correct_out(:,:,sess))
    colorbar
    axis xy
    xlim([-200 900])
    col(2,1:2) = get(gca,'CLim');

%     newcol = [min(col(:,1)) max(col(:,2))];
%     subplot(2,2,3)
%     set(gca,'CLim',newcol)
%     subplot(2,2,4)
%     set(gca,'CLim',newcol)

    pause
%     subplot(2,2,1)
%     cla
%     subplot(2,2,2)
%     cla
%     subplot(2,2,3)
%     cla
%     subplot(2,2,4)
%     cla
end