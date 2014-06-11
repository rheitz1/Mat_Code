%caluclates and plots n2pc (or, p2pc for monkeys)
%Should use channels AD02 and AD03 which for Quincy are
%respectively T6 and T5 and for Seymour, OR and OL
cd /volumes/Dump/Search_Data/
batch_list = dir('*SEARCH.mat');

for i = 1:length(batch_list)
    batch_list(i).name
    
    load(batch_list(i).name,'AD02','AD03','Correct_','Target_','SRT')
    
    
    trunc_at_saccade = 1;
    
    
    OL = AD03;
    OR = AD02;
    
    %baseline correct
    OL = baseline_correct(OL,[400 500]);
    OR = baseline_correct(OR,[400 500]);
    
    %truncate 5 ms before saccade
    if trunc_at_saccade == 1
        OL = truncateAD_targ(OL,SRT,20);
        OR = truncateAD_targ(OR,SRT,20);
    end
    
    plotFlag = 1;
    contraCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    OLcontra = OL(contraCorrectOL,:);
    OLipsi = OL(ipsiCorrectOL,:);
    ORcontra = OR(contraCorrectOR,:);
    ORipsi = OR(ipsiCorrectOR,:);
    
    
    N2pc_TDT_OL = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL);
    N2pc_TDT_OR = getTDT_AD(OR,contraCorrectOR,ipsiCorrectOR);
    
    if N2pc_TDT_OL > nanmean(SRT(find(Correct_(:,2) == 1),1))
        disp('N2pc too late...writing NaN')
        N2pc_TDT_OL = NaN;
    end
    
    if N2pc_TDT_OR > nanmean(SRT(find(Correct_(:,2) == 1),1))
        disp('N2pc too late...writing NaN')
        N2pc_TDT_OR = NaN;
    end
    
    N2pc_TDT_OL_all.trunc(i,1) = N2pc_TDT_OL;
    N2pc_TDT_OR_all.trunc(i,1) = N2pc_TDT_OR;
    
    if plotFlag == 1
        figure
        orient landscape
        set(gcf,'color','white')
        
        subplot(1,2,1)
        plot(-500:2500,nanmean(OLipsi),'b',-500:2500,nanmean(OLcontra),'r')
        axis ij
        xlim([-100 500])
        leg = legend('Ipsi','Contra','location','northwest');
        set(leg,'fontsize',12,'fontweight','bold')
        title(['OL   TDT = ' mat2str(N2pc_TDT_OL_all.trunc(i,1))],'fontsize',12,'fontweight','bold')
        ylabel('mV','fontsize',12,'fontweight','bold')
        xlabel('Time from Target','fontsize',12,'fontweight','bold')
        vline(N2pc_TDT_OL_all.trunc(i,1),'k')
        
        subplot(1,2,2)
        plot(-500:2500,nanmean(ORipsi),'b',-500:2500,nanmean(ORcontra),'r')
        axis ij
        xlim([-100 500])
        %leg = legend('Ipsi','Contra');
        set(leg,'fontsize',12,'fontweight','bold')
        xlabel('Time from Target','fontsize',12,'fontweight','bold')
        title(['OR   TDT = ' mat2str(N2pc_TDT_OR_all.trunc(i,1))],'fontsize',12,'fontweight','bold')
        vline(N2pc_TDT_OR_all.trunc(i,1),'k')
        
    end
    
    
    
    
    
    
    
    
    
    trunc_at_saccade = 0;
    
    
    OL = AD03;
    OR = AD02;
    
    %baseline correct
    OL = baseline_correct(OL,[400 500]);
    OR = baseline_correct(OR,[400 500]);
    
    %truncate 5 ms before saccade
    if trunc_at_saccade == 1
        OL = truncateAD_targ(OL,SRT,20);
        OR = truncateAD_targ(OR,SRT,20);
    end
    
    plotFlag = 1;
    contraCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    OLcontra = OL(contraCorrectOL,:);
    OLipsi = OL(ipsiCorrectOL,:);
    ORcontra = OR(contraCorrectOR,:);
    ORipsi = OR(ipsiCorrectOR,:);
    
    
    N2pc_TDT_OL = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL);
    N2pc_TDT_OR = getTDT_AD(OR,contraCorrectOR,ipsiCorrectOR);
    
    if N2pc_TDT_OL > nanmean(SRT(find(Correct_(:,2) == 1),1))
        disp('N2pc too late...writing NaN')
        N2pc_TDT_OL = NaN;
    end
    
    if N2pc_TDT_OR > nanmean(SRT(find(Correct_(:,2) == 1),1))
        disp('N2pc too late...writing NaN')
        N2pc_TDT_OR = NaN;
    end
    
    
    N2pc_TDT_OL_all.notrunc(i,1) = N2pc_TDT_OL;
    N2pc_TDT_OR_all.notrunc(i,1) = N2pc_TDT_OR;
    
    if plotFlag == 1
        figure
        orient landscape
        set(gcf,'color','white')
        
        subplot(1,2,1)
        plot(-500:2500,nanmean(OLipsi),'b',-500:2500,nanmean(OLcontra),'r')
        axis ij
        xlim([-100 500])
        leg = legend('Ipsi','Contra','location','northwest');
        set(leg,'fontsize',12,'fontweight','bold')
        title(['OL   TDT = ' mat2str(N2pc_TDT_OL_all.notrunc(i,1))],'fontsize',12,'fontweight','bold')
        ylabel('mV','fontsize',12,'fontweight','bold')
        xlabel('Time from Target','fontsize',12,'fontweight','bold')
        vline(N2pc_TDT_OL_all.notrunc(i,1),'k')
        
        subplot(1,2,2)
        plot(-500:2500,nanmean(ORipsi),'b',-500:2500,nanmean(ORcontra),'r')
        axis ij
        xlim([-100 500])
        %leg = legend('Ipsi','Contra');
        set(leg,'fontsize',12,'fontweight','bold')
        xlabel('Time from Target','fontsize',12,'fontweight','bold')
        title(['OR   TDT = ' mat2str(N2pc_TDT_OR_all.notrunc(i,1))],'fontsize',12,'fontweight','bold')
        vline(N2pc_TDT_OR_all.notrunc(i,1),'k')
        
    end
    
    
    figs2subplots([figure(1) figure(2)],[2 2]);
    subplot(2,2,1)
    legend('off')
    xlim([-50 300])
    
    subplot(2,2,2)
    xlim([-50 300])
    
    subplot(2,2,3)
    xlim([-50 300])
    legend('off')
    
    subplot(2,2,4)
    xlim([-50 300])
    
    eval(['print -dpdf /volumes/Dump/Analyses/n2pc_truncate/PDF/' batch_list(i).name '.pdf'])
    
    clear OL OR *contra* *ipsi* Wilcoxon* plotFlag leg i N2pc_TDT_OL N2pc_TDT_OR
    close all
    
end

save('/volumes/Dump/Analyses/n2pc_truncate/TDT.mat','N2pc_TDT_OL_all','N2pc_TDT_OR_all','-mat')