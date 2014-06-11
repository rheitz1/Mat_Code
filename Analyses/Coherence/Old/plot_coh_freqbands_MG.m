%baseline correct coherence matrices
plotFlag = 1;

for sess = 1:size(coh_correct_all,3)
    sess
    coh = abs(coh_correct_all(:,:,sess)');
        
    %baseline correct coherence matrices using first 4 values
    base = repmat(nanmean(coh(:,1:20),2),1,size(coh,2));
    
    cohmat_base = coh - base;

    
    coh_base_all(1:206,1:281,sess) = cohmat_base;
    
    
    coh_1_20(sess,1:281) = nanmean(cohmat_base(1:20,:));
    
    coh_25_45(sess,1:281) = nanmean(cohmat_base(25:45,:));
    
    coh_40_100(sess,1:281) = nanmean(cohmat_base(40:100,:));
    
    clear coh base cohmat_base
end


if plotFlag == 1
    figure
    set(gcf,'color','white')
    orient landscape
    
    subplot(3,1,1)
    plot(1:size(coh_1_20,2),mean(coh_1_20),'b','linewidth',2)
    axhand = gca;
    set(axhand,'XTickLabel',tvals_targ)
    set(axhand,'XTick',tind_targ)
    title('1 - 20 Hz','fontsize',14,'fontweight','bold')
    
    subplot(3,1,2)
    plot(1:size(coh_25_45,2),mean(coh_25_45),'b','linewidth',2)
    axhand = gca;
    set(axhand,'XTickLabel',tvals_targ)
    set(axhand,'XTick',tind_targ)
    title('25 - 45 Hz','fontsize',14,'fontweight','bold')
    
    subplot(3,1,3)
    plot(1:size(coh_40_100,2),mean(coh_40_100),'b','linewidth',2)
    axhand = gca;
    set(axhand,'XTickLabel',tvals_targ)
    set(axhand,'XTick',tind_targ)
    title('40 - 100 Hz','fontsize',14,'fontweight','bold')
end
