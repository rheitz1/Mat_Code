%plots AD channel by screen location
%outputs one plot for target aligned and another for response aligned.
function [] = ADSL_mStim(AD,Bundle)

%turn on flag 
flag = 1;


%extract from Bundle
Target_ = Bundle.Target_;
SRT = Bundle.SRT;
Correct_ = Bundle.Correct_;
MStim_ = Bundle.MStim_;

%remove clipped trials
AD = fixClipped(AD);

%baseline correct
AD = baseline_correct(AD,[400 500]);

%Median SRT of correct trials
%cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255)),1);

pos0 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),0) == 1);
% pos0_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),0) == 1);
% pos0_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),0) == 1);
pos0_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ~isnan(MStim_(:,3)) & ismember(Target_(:,2),0));
pos0_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & isnan(MStim_(:,3)) & ismember(Target_(:,2),0));

pos1 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),1) == 1);
% pos1_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),1) == 1);
% pos1_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),1) == 1);
pos1_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ~isnan(MStim_(:,3)) & ismember(Target_(:,2),1));
pos1_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & isnan(MStim_(:,3)) & ismember(Target_(:,2),1));

pos2 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),2) == 1);
% pos2_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),2) == 1);
% pos2_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),2) == 1);
pos2_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ~isnan(MStim_(:,3)) & ismember(Target_(:,2),2));
pos2_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & isnan(MStim_(:,3)) & ismember(Target_(:,2),2));


pos3 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),3) == 1);
% pos3_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),3) == 1);
% pos3_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),3) == 1);
pos3_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ~isnan(MStim_(:,3)) & ismember(Target_(:,2),3));
pos3_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & isnan(MStim_(:,3)) & ismember(Target_(:,2),3));

pos4 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),4) == 1);
% pos4_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),4) == 1);
% pos4_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),4) == 1);
pos4_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ~isnan(MStim_(:,3)) & ismember(Target_(:,2),4));
pos4_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & isnan(MStim_(:,3)) & ismember(Target_(:,2),4));


pos5 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),5) == 1);
% pos5_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),5) == 1);
% pos5_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),5) == 1);
pos5_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ~isnan(MStim_(:,3)) & ismember(Target_(:,2),5));
pos5_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & isnan(MStim_(:,3)) & ismember(Target_(:,2),5));


pos6 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),6) == 1);
% pos6_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),6) == 1);
% pos6_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),6) == 1);
pos6_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ~isnan(MStim_(:,3)) & ismember(Target_(:,2),6));
pos6_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & isnan(MStim_(:,3)) & ismember(Target_(:,2),6));


pos7 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),7) == 1);
% pos7_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),7) == 1);
% pos7_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),7) == 1);
pos7_stim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ~isnan(MStim_(:,3)) & ismember(Target_(:,2),7));
pos7_nostim = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & isnan(MStim_(:,3)) & ismember(Target_(:,2),7));


%response align, DO truncate at 2nd saccade
AD_resp = response_align(AD,SRT,[-400 200],1);

%baseline correction
AD_resp = baseline_correct(AD_resp,[1 100]);


t = figure;
orient landscape
set(gcf,'color','white')

r = figure;
orient landscape
set(gcf,'color','white')

%step through target screen positions and convert to subplot coordinates
for j = 0:7
    switch j
        case 0
            trls = pos0;
%             trls_fast = pos0_fast;
%             trls_slow = pos0_slow;
            trls_stim = pos0_stim;
            trls_nostim = pos0_nostim;
            screenloc = 6;
        case 1
            trls = pos1;
%             trls_fast = pos1_fast;
%             trls_slow = pos1_slow;
            trls_stim = pos1_stim;
            trls_nostim = pos1_nostim;
            screenloc = 3;
        case 2
            trls = pos2;
%             trls_fast = pos2_fast;
%             trls_slow = pos2_slow;
            trls_stim = pos2_stim;
            trls_nostim = pos2_nostim;
            screenloc = 2;
        case 3
            trls = pos3;
%             trls_fast = pos3_fast;
%             trls_slow = pos3_slow;
            trls_stim = pos3_stim;
            trls_nostim = pos3_nostim;
            screenloc = 1;
        case 4
            trls = pos4;
%             trls_fast = pos4_fast;
%             trls_slow = pos4_slow;
            trls_stim = pos4_stim;
            trls_nostim = pos4_nostim;
            screenloc = 4;
        case 5
            trls = pos5;
%             trls_fast = pos5_fast;
%             trls_slow = pos5_slow;
            trls_stim = pos5_stim;
            trls_nostim = pos5_nostim;
            screenloc = 7;
        case 6
            trls = pos6;
%             trls_fast = pos6_fast;
%             trls_slow = pos6_slow;
            trls_stim = pos6_stim;
            trls_nostim = pos6_nostim;
            screenloc = 8;
        case 7
            trls = pos7;
%             trls_fast = pos7_fast;
%             trls_slow = pos7_slow;
            trls_stim = pos7_stim;
            trls_nostim = pos7_nostim;
            screenloc = 9;
    end
    
    
    figure(t)
    subplot(3,3,screenloc)
    
    if flag == 0 %just plot mean
        plot(-500:2500,nanmean(AD(trls,:)),'k','linewidth',2)
        axis ij
        title(['n = ' mat2str(length(trls))],'fontsize',12,'fontweight','bold')
    else
        %plot(-500:2500,nanmean(AD(trls,:)),'k','linewidth',2)
       % hold
        plot(-500:2500,nanmean(AD(trls_stim,:)),'r',-500:2500,nanmean(AD(trls_nostim,:)),'b')
        axis ij
        title(['nAll = ' mat2str(length(trls)) ' nStim = ' mat2str(length(trls_stim)) ' nNoStim = ' mat2str(length(trls_nostim))],'fontsize',12,'fontweight','bold')
    end
    xlim([-100 500]);
    vline(0,'k')
    set(gca,'fontsize',12)
    
    
    
end




%step through target screen positions and convert to subplot coordinates
for j = 0:7
    switch j
        case 0
            trls = pos0;
%             trls_fast = pos0_fast;
%             trls_slow = pos0_slow;
            trls_stim = pos0_stim;
            trls_nostim = pos0_nostim;
            screenloc = 6;
        case 1
            trls = pos1;
%             trls_fast = pos1_fast;
%             trls_slow = pos1_slow;
            trls_stim = pos1_stim;
            trls_nostim = pos1_nostim;
            screenloc = 3;
        case 2
            trls = pos2;
%             trls_fast = pos2_fast;
%             trls_slow = pos2_slow;
            trls_stim = pos2_stim;
            trls_nostim = pos2_nostim;
            screenloc = 2;
        case 3
            trls = pos3;
%             trls_fast = pos3_fast;
%             trls_slow = pos3_slow;
            trls_stim = pos3_stim;
            trls_nostim = pos3_nostim;
            screenloc = 1;
        case 4
            trls = pos4;
%             trls_fast = pos4_fast;
%             trls_slow = pos4_slow;
            trls_stim = pos4_stim;
            trls_nostim = pos4_nostim;
            screenloc = 4;
        case 5
            trls = pos5;
%             trls_fast = pos5_fast;
%             trls_slow = pos5_slow;
            trls_stim = pos5_stim;
            trls_nostim = pos5_nostim;
            screenloc = 7;
        case 6
            trls = pos6;
%             trls_fast = pos6_fast;
%             trls_slow = pos6_slow;
            trls_stim = pos6_stim;
            trls_nostim = pos6_nostim;
            screenloc = 8;
        case 7
            trls = pos7;
%             trls_fast = pos7_fast;
%             trls_slow = pos7_slow;
            trls_stim = pos7_stim;
            trls_nostim = pos7_nostim;
            screenloc = 9;
    end
    
    
    figure(r)
    subplot(3,3,screenloc)
    if flag == 0 %just plot mean
        plot(-400:200,nanmean(AD_resp(trls,:)),'k','linewidth',2)
        axis ij
        title(['n = ' mat2str(length(trls))],'fontsize',12,'fontweight','bold')
    else
       % plot(-400:200,nanmean(AD_resp(trls,:)),'k','linewidth',2)
       % hold
        plot(-400:200,nanmean(AD_resp(trls_stim,:)),'r',-400:200,nanmean(AD_resp(trls_nostim,:)),'b')
        axis ij
        title(['nAll = ' mat2str(length(trls)) ' nStim = ' mat2str(length(trls_stim)) ' nNoStim = ' mat2str(length(trls_nostim))],'fontsize',12,'fontweight','bold')
    end
    xlim([-400 200])
    vline(0,'k')
    set(gca,'fontsize',12)
    
end


figure(t)
[ax,h1] = suplabel('Time from Target');
set(h1,'fontsize',14,'fontweight','bold')
[ax,h1] = suplabel('mV','y');
set(h1,'fontsize',14,'fontweight','bold')

figure(r)
[ax,h1] = suplabel('Time from Saccade');
set(h1,'fontsize',14,'fontweight','bold')
[ax,h1] = suplabel('mV','y');
set(h1,'fontsize',14,'fontweight','bold')