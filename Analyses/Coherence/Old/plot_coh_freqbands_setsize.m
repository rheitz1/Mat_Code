%baseline correct coherence matrices
plotFlag = 0;

for sess = 1:size(coh_targ_all.correct_ss2,3)
    sess

%     ss2 = abs((coh_targ_all.correct_ss2(:,:,sess)'));
%     ss4 = abs((coh_targ_all.correct_ss4(:,:,sess)'));
%     ss8 = abs((coh_targ_all.correct_ss8(:,:,sess)'));
    ss2 = (spec2_targ_all.correct_ss2(:,:,sess)');
    ss4 = (spec2_targ_all.correct_ss4(:,:,sess)');
    ss8 = (spec2_targ_all.correct_ss8(:,:,sess)');
    
    
    %baseline correct coherence matrices using first 4 values
    
    
    base2 = repmat(nanmean(ss2(:,find(tout_targ >= -200 & tout_targ <= 0)),2),1,size(ss2,2));
    base4 = repmat(nanmean(ss4(:,find(tout_targ >= -200 & tout_targ <= 0)),2),1,size(ss4,2));
    base8 = repmat(nanmean(ss8(:,find(tout_targ >= -200 & tout_targ <= 0)),2),1,size(ss8,2));
    
    ss2 = ss2 - base2;
    ss4 = ss4 - base4;
    ss8 = ss8 - base8;
    
    %keep track of corrected matrices
    coh_base_ss2(1:206,1:281,sess) = ss2;
    coh_base_ss4(1:206,1:281,sess) = ss4;
    coh_base_ss8(1:206,1:281,sess) = ss8;
    
    
    s2_1_20(sess,1:281) = nanmean(ss2(find(f_targ > 0 & f_targ <= 20),:));
    s4_1_20(sess,1:281) = nanmean(ss4(find(f_targ > 0 & f_targ <= 20),:));
    s8_1_20(sess,1:281) = nanmean(ss8(find(f_targ > 0 & f_targ <= 20),:));
    
    s2_20_45(sess,1:281) = nanmean(ss2(find(f_targ > 20 & f_targ <= 45),:));
    s4_20_45(sess,1:281) = nanmean(ss4(find(f_targ > 20 & f_targ <= 45),:));
    s8_20_45(sess,1:281) = nanmean(ss8(find(f_targ > 20 & f_targ <= 45),:));
    
    s2_45_100(sess,1:281) = nanmean(ss2(find(f_targ > 45 & f_targ <= 100),:));
    s4_45_100(sess,1:281) = nanmean(ss4(find(f_targ > 45 & f_targ <= 100),:));
    s8_45_100(sess,1:281) = nanmean(ss8(find(f_targ > 45 & f_targ <= 100),:));
    
    clear ss2 ss4 ss8
end


if plotFlag == 1
    figure
    set(gcf,'color','white')
    orient landscape
    
    subplot(3,1,1)
    plot(tout_targ,mean(s2_1_20),'b',tout_targ,mean(s4_1_20),'r',tout_targ,mean(s8_1_20),'k','linewidth',2)
    legend('Set Size 2','Set Size 4','Set Size 8')
    title('1 - 20 Hz','fontsize',14,'fontweight','bold')
    xlim([-200 800])
    
    subplot(3,1,2)
    plot(tout_targ,mean(s2_20_45),'b',tout_targ,mean(s4_20_45),'r',tout_targ,mean(s8_20_45),'k','linewidth',2)
    title('20 - 45 Hz','fontsize',14,'fontweight','bold')
    xlim([-200 800])
    
    subplot(3,1,3)
    plot(tout_targ,mean(s2_45_100),'b',tout_targ,mean(s4_45_100),'r',tout_targ,mean(s8_45_100),'k','linewidth',2)
    title('45 - 100 Hz','fontsize',14,'fontweight','bold')
    xlim([-200 800])
end
