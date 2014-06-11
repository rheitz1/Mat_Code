function [in out PD R NormR p TDT] =  LFPtuning(sig,window,plotFlag)

if nargin < 3; plotFlag = 0; end
if nargin < 2 || isempty(window)
    if size(sig,2) == 3001; window = [650 900]; end
    if size(sig,2) == 6001; window = [3650 3900]; end
end


Correct_ = evalin('caller','Correct_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');


sig = baseline_correct(sig,[Target_(1,1)-100 Target_(1,1)]);

pos0 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),0) == 1);
pos1 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),1) == 1);
pos2 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),2) == 1);
pos3 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),3) == 1);
pos4 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),4) == 1);
pos5 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),5) == 1);
pos6 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),6) == 1);
pos7 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),7) == 1);

admean = nanmean(sig(:,window(1):window(2)),2);

p0 = nanmean(admean(pos0));
p1 = nanmean(admean(pos1));
p2 = nanmean(admean(pos2));
p3 = nanmean(admean(pos3));
p4 = nanmean(admean(pos4));
p5 = nanmean(admean(pos5));
p6 = nanmean(admean(pos6));
p7 = nanmean(admean(pos7));

allAD(1,1:size(sig,2)) = nanmean(sig(pos0,:));
allAD(2,1:size(sig,2)) = nanmean(sig(pos1,:));
allAD(3,1:size(sig,2)) = nanmean(sig(pos2,:));
allAD(4,1:size(sig,2)) = nanmean(sig(pos3,:));
allAD(5,1:size(sig,2)) = nanmean(sig(pos4,:));
allAD(6,1:size(sig,2)) = nanmean(sig(pos5,:));
allAD(7,1:size(sig,2)) = nanmean(sig(pos6,:));
allAD(8,1:size(sig,2)) = nanmean(sig(pos7,:));

[~, ix] = sort([p0 p1 p2 p3 p4 p5 p6 p7]);


in = [ix(1)-1 ix(2)-1 ix(3)-1];
other = [ix(4)-1 ix(5)-1];
out = [ix(6)-1 ix(7)-1 ix(8)-1];

%do Matt's tuning test
% NOTE: MULTIPLYING AD SIGNAL BY -1 SO THAT SELECTION EXPRESSED AS A
% NEGATIVITY!
valid = find(Target_(:,2) ~= 255);
[PD R NormR p] = TuningTest(admean(valid)*-1,Target_(valid,2));


%test to see if there is a significant TDT using RF_in
tmp_out = mod((in+4),8);

intrls = find(Correct_(:,2) == 1 & ismember(Target_(:,2),in));
outtrls = find(Correct_(:,2) == 1 & ismember(Target_(:,2),tmp_out));

[TDT] = getTDT_AD(sig,intrls,outtrls);

disp(['TDT = ' mat2str(TDT)])

if plotFlag == 1
    fig
    subplot(2,2,1)
    %bar(0:7,[p0 p1 p2 p3 p4 p5 p6 p7])
    plot(-Target_(1,1):2500,nanmean(sig(intrls,:)),'k',-Target_(1,1):2500,nanmean(sig(outtrls,:)),'--k')
    axis ij
    xlim([-100 500])
    vline(TDT,'k')
    title(['TDT = ' mat2str(TDT)])
    
    
    subplot(2,2,2)
    circ_plot(deg2rad(PD),'pretty');
    title('Matts Tuning using negativity')
    
    subplot(2,2,3:4)
    hold on
    
    %plot top 3
    plot(-Target_(1,1):2500,allAD(ix(1),:),'r')
    plot(-Target_(1,1):2500,allAD(ix(2),:),'r')
    plot(-Target_(1,1):2500,allAD(ix(3),:),'r')
    
    %plot middle
    plot(-Target_(1,1):2500,allAD(ix(4),:),'k')
    plot(-Target_(1,1):2500,allAD(ix(5),:),'k')
    
    %plot bottom 3
    plot(-Target_(1,1):2500,allAD(ix(6),:),'b')
    plot(-Target_(1,1):2500,allAD(ix(7),:),'b')
    plot(-Target_(1,1):2500,allAD(ix(8),:),'b')
    
    title(['In (red)= ' mat2str([ix(1)-1 ix(2)-1 ix(3)-1]) ' Out (blue) = ' mat2str([ix(6)-1 ix(7)-1 ix(8)-1])])
    
    axis ij
    xlim([-50 500])
end