%caluclates and plots n2pc (or, p2pc for monkeys)
%Should use channels AD02 and AD03 which for Quincy are
%respectively T6 and T5 and for Seymour, OR and OL

OL = AD03;
OR = AD02;

OL = fixClipped(OL,[Target_(1,1)-500 Target_(1,1)+500],50);
OR = fixClipped(OR,[Target_(1,1)-500 Target_(1,1)+500],50);

%baseline correct
OL = baseline_correct(OL,[Target_(1,1)-100 Target_(1,1)]);
OR = baseline_correct(OR,[Target_(1,1)-100 Target_(1,1)]);

%truncate 20 ms before saccade
OL_trunc = truncateAD_targ(OL,SRT,20);
OR_trunc = truncateAD_targ(OR,SRT,20);


plotFlag = 1;
contraCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
ipsiCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);

contraCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
ipsiCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);


getTrials_SAT

slow_in_OL = intersect(slow_correct_made_dead,contraCorrectOL);
slow_out_OL = intersect(slow_correct_made_dead,ipsiCorrectOL);
slow_in_OR = intersect(slow_correct_made_dead,contraCorrectOR);
slow_out_OR = intersect(slow_correct_made_dead,ipsiCorrectOR);

fast_in_OL = intersect(fast_correct_made_dead_withCleared,contraCorrectOL);
fast_out_OL = intersect(fast_correct_made_dead_withCleared,ipsiCorrectOL);
fast_in_OR = intersect(fast_correct_made_dead_withCleared,contraCorrectOR);
fast_out_OR = intersect(fast_correct_made_dead_withCleared,ipsiCorrectOR);

wf.in.slow_OR = nanmean(OR_trunc(slow_in_OR,:));
wf.out.slow_OR = nanmean(OR_trunc(slow_out_OR,:));
wf.in.slow_OL = nanmean(OL_trunc(slow_in_OL,:));
wf.out.slow_OL = nanmean(OL_trunc(slow_out_OL,:));

wf.in.fast_OR = nanmean(OR_trunc(fast_in_OR,:));
wf.out.fast_OR = nanmean(OR_trunc(fast_out_OR,:));
wf.in.fast_OL = nanmean(OL_trunc(fast_in_OL,:));
wf.out.fast_OL = nanmean(OL_trunc(fast_out_OL,:));



N2pc_TDT.OL = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL);
N2pc_TDT.OR = getTDT_AD(OR,contraCorrectOR,ipsiCorrectOR);
N2pc_TDT.OL_trunc = getTDT_AD(OL_trunc,contraCorrectOL,ipsiCorrectOL);
N2pc_TDT.OR_trunc = getTDT_AD(OR_trunc,contraCorrectOR,ipsiCorrectOR);

% %find onset time but look between 100 after Target onset and 500 ms for
% %speed
% for time = 600:1000%size(AD02,2);
%     [WilcoxonOL_p(time) WilcoxonOL_h(time)] = ranksum(OLcontra(:,time),OLipsi(:,time),'alpha',.01);
%     [WilcoxonOR_p(time) WilcoxonOR_h(time)] = ranksum(ORcontra(:,time),ORipsi(:,time),'alpha',.01);
% end
% 
% %find miminum time of 10 consecutive significant bins; begin looking 100 ms
% %after target onset (which is column 600)
% N2pc_TDT_OL = min(findRuns(WilcoxonOL_h,10)) - 500;
% N2pc_TDT_OR = min(findRuns(WilcoxonOR_h,10)) - 500;

if plotFlag == 1
    figure
    orient landscape
    set(gcf,'color','white')
    
    subplot(2,2,1)
    plot(-Target_(1,1):2500,nanmean(OLipsi),'--k',-Target_(1,1):2500,nanmean(OLcontra),'k')
    axis ij
    xlim([-100 500])
    leg = legend('Ipsi','Contra','location','northwest');
    set(leg,'fontsize',12,'fontweight','bold')
    title(['OL   TDT = ' mat2str(N2pc_TDT.OL)],'fontsize',12,'fontweight','bold')
    ylabel('mV','fontsize',12,'fontweight','bold')
    %xlabel('Time from Target','fontsize',12,'fontweight','bold')
    vline(N2pc_TDT.OL,'k')
    OL_y = get(gca,'ylim');
    
    subplot(2,2,2)
    plot(-Target_(1,1):2500,nanmean(ORipsi),'--k',-Target_(1,1):2500,nanmean(ORcontra),'k')
    axis ij
    xlim([-100 500])
    %leg = legend('Ipsi','Contra');
    set(leg,'fontsize',12,'fontweight','bold')
    %xlabel('Time from Target','fontsize',12,'fontweight','bold')
    title(['OR   TDT = ' mat2str(N2pc_TDT.OR)],'fontsize',12,'fontweight','bold')
    vline(N2pc_TDT.OR,'k')
    OR_y = get(gca,'ylim');
    
    subplot(2,2,3)
    plot(-Target_(1,1):2500,nanmean(OLipsi_trunc),'--k',-Target_(1,1):2500,nanmean(OLcontra_trunc),'k')
    axis ij
    xlim([-100 500])
    xlabel('Time from Target','fontsize',12,'fontweight','bold')
    title(['OL   TDT = ' mat2str(N2pc_TDT.OL_trunc)],'fontsize',12,'fontweight','bold')
    vline(N2pc_TDT.OL_trunc,'k')
    set(gca,'ylim',OL_y)
    
    subplot(2,2,4)
    plot(-Target_(1,1):2500,nanmean(ORipsi_trunc),'--k',-Target_(1,1):2500,nanmean(ORcontra_trunc),'k')
    axis ij
    xlim([-100 500])
    xlabel('Time from Target','fontsize',12,'fontweight','bold')
    title(['OR    TDT = ' mat2str(N2pc_TDT.OR_trunc)],'fontsize',12,'fontweight','bold')
    vline(N2pc_TDT.OR_trunc,'k')
    set(gca,'ylim',OR_y)
end

clear OL* OR* *contra* *ipsi* Wilcoxon* plotFlag leg