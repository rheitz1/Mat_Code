%plots AD channel by screen location
%outputs one plot for target aligned and another for response aligned.
%
% RPH

function [] = AD_SL(AD,flag)

if nargin < 2
    flag = 0; %flag == 1 if want to plot mean, fast, and slow for each screen pos
end

Target_ = evalin('caller','Target_');
SRT = evalin('caller','SRT');
Correct_ = evalin('caller','Correct_');


%baseline correct
AD = baseline_correct(AD,[400 500]);

%Median SRT of correct trials
cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255)),1);

pos0 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),0) == 1);
pos0_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),0) == 1);
pos0_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),0) == 1);

pos1 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),1) == 1);
pos1_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),1) == 1);
pos1_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),1) == 1);

pos2 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),2) == 1);
pos2_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),2) == 1);
pos2_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),2) == 1);

pos3 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),3) == 1);
pos3_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),3) == 1);
pos3_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),3) == 1);

pos4 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),4) == 1);
pos4_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),4) == 1);
pos4_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),4) == 1);

pos5 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),5) == 1);
pos5_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),5) == 1);
pos5_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),5) == 1);

pos6 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),6) == 1);
pos6_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),6) == 1);
pos6_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),6) == 1);

pos7 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),7) == 1);
pos7_fast = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < cMed & ismember(Target_(:,2),7) == 1);
pos7_slow = find(Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) < 2000 & ismember(Target_(:,2),7) == 1);

%response align, DO truncate at 2nd saccade
AD_resp = response_align(AD,SRT,[-400 200],1);

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
            trls_fast = pos0_fast;
            trls_slow = pos0_slow;
            screenloc = 6;
        case 1
            trls = pos1;
            trls_fast = pos1_fast;
            trls_slow = pos1_slow;
            screenloc = 3;
        case 2
            trls = pos2;
            trls_fast = pos2_fast;
            trls_slow = pos2_slow;
            screenloc = 2;
        case 3
            trls = pos3;
            trls_fast = pos3_fast;
            trls_slow = pos3_slow;
            screenloc = 1;
        case 4
            trls = pos4;
            trls_fast = pos4_fast;
            trls_slow = pos4_slow;
            screenloc = 4;
        case 5
            trls = pos5;
            trls_fast = pos5_fast;
            trls_slow = pos5_slow;
            screenloc = 7;
        case 6
            trls = pos6;
            trls_fast = pos6_fast;
            trls_slow = pos6_slow;
            screenloc = 8;
        case 7
            trls = pos7;
            trls_fast = pos7_fast;
            trls_slow = pos7_slow;
            screenloc = 9;
    end
    
    
    figure(t)
    subplot(3,3,screenloc)
    
    if flag == 0 %just plot mean
        plot(-500:2500,nanmean(AD(trls,:)),'k','linewidth',1)
        axis ij
        title(['n = ' mat2str(length(trls))],'fontsize',12,'fontweight','bold')
    else
        plot(-500:2500,nanmean(AD(trls,:)),'k','linewidth',1)
        hold
        plot(-500:2500,nanmean(AD(trls_fast,:)),'r',-500:2500,nanmean(AD(trls_slow,:)),'b')
        axis ij
        title(['nAll = ' mat2str(length(trls)) ' nFast = ' mat2str(length(trls_fast)) ' nSlow = ' mat2str(length(trls_slow))],'fontsize',12,'fontweight','bold')
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
            trls_fast = pos0_fast;
            trls_slow = pos0_slow;
            screenloc = 6;
        case 1
            trls = pos1;
            trls_fast = pos1_fast;
            trls_slow = pos1_slow;
            screenloc = 3;
        case 2
            trls = pos2;
            trls_fast = pos2_fast;
            trls_slow = pos2_slow;
            screenloc = 2;
        case 3
            trls = pos3;
            trls_fast = pos3_fast;
            trls_slow = pos3_slow;
            screenloc = 1;
        case 4
            trls = pos4;
            trls_fast = pos4_fast;
            trls_slow = pos4_slow;
            screenloc = 4;
        case 5
            trls = pos5;
            trls_fast = pos5_fast;
            trls_slow = pos5_slow;
            screenloc = 7;
        case 6
            trls = pos6;
            trls_fast = pos6_fast;
            trls_slow = pos6_slow;
            screenloc = 8;
        case 7
            trls = pos7;
            trls_fast = pos7_fast;
            trls_slow = pos7_slow;
            screenloc = 9;
    end
    
    
    figure(r)
    subplot(3,3,screenloc)
    if flag == 0 %just plot mean
        plot(-400:200,nanmean(AD_resp(trls,:)),'k','linewidth',1)
        axis ij
        title(['n = ' mat2str(length(trls))],'fontsize',12,'fontweight','bold')
    else
        plot(-400:200,nanmean(AD_resp(trls,:)),'k','linewidth',1)
        hold
        plot(-400:200,nanmean(AD_resp(trls_fast,:)),'r',-400:200,nanmean(AD_resp(trls_slow,:)),'b')
        axis ij
        title(['nAll = ' mat2str(length(trls)) ' nFast = ' mat2str(length(trls_fast)) ' nSlow = ' mat2str(length(trls_slow))],'fontsize',12,'fontweight','bold')
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