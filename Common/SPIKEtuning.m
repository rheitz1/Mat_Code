function [in out PD R NormR p TDT] =  SPIKEtuning(sig,plotFlag)

if nargin < 2; plotFlag = 0; end


Correct_ = evalin('caller','Correct_');
SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');


SDF = sSDF(sig,Target_(:,1),[-Target_(1,1) 2500]);

pos0 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),0) == 1);
pos1 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),1) == 1);
pos2 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),2) == 1);
pos3 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),3) == 1);
pos4 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),4) == 1);
pos5 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),5) == 1);
pos6 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),6) == 1);
pos7 = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),7) == 1);

%find maximum firing rate on averaged SDF in period 50 to 200 ms post
%target onset
[maxval maxind] = nanmax(nanmean(SDF));

%take mean firing rate 50 ms before max to 150 ms after max
rates_to_test = nanmean(SDF(:,maxind-50:maxind+150),2);

p0 = nanmean(rates_to_test(pos0));
p1 = nanmean(rates_to_test(pos1));
p2 = nanmean(rates_to_test(pos2));
p3 = nanmean(rates_to_test(pos3));
p4 = nanmean(rates_to_test(pos4));
p5 = nanmean(rates_to_test(pos5));
p6 = nanmean(rates_to_test(pos6));
p7 = nanmean(rates_to_test(pos7));

allSDF(1,1:3001) = nanmean(SDF(pos0,:));
allSDF(2,1:3001) = nanmean(SDF(pos1,:));
allSDF(3,1:3001) = nanmean(SDF(pos2,:));
allSDF(4,1:3001) = nanmean(SDF(pos3,:));
allSDF(5,1:3001) = nanmean(SDF(pos4,:));
allSDF(6,1:3001) = nanmean(SDF(pos5,:));
allSDF(7,1:3001) = nanmean(SDF(pos6,:));
allSDF(8,1:3001) = nanmean(SDF(pos7,:));

[~, ix] = sort([p0 p1 p2 p3 p4 p5 p6 p7],2,'descend');


in = [ix(1)-1 ix(2)-1 ix(3)-1];
other = [ix(4)-1 ix(5)-1];
out = [ix(6)-1 ix(7)-1 ix(8)-1];

%do Matt's tuning test
% NOTE: MULTIPLYING AD SIGNAL BY -1 SO THAT SELECTION EXPRESSED AS A
% NEGATIVITY!
valid = find(Target_(:,2) ~= 255);
[PD R NormR p] = TuningTest(rates_to_test(valid),Target_(valid,2));


%test to see if there is a significant TDT using RF_in
tmp_out = mod((in+4),8);

intrls = find(Correct_(:,2) == 1 & ismember(Target_(:,2),in));
outtrls = find(Correct_(:,2) == 1 & ismember(Target_(:,2),tmp_out));

[TDT] = getTDT_SP(sig,intrls,outtrls);

disp(['Current Calculated TDT = ' mat2str(TDT)])

if plotFlag == 1
    figure
    subplot(2,2,1)
    bar(0:7,[p0 p1 p2 p3 p4 p5 p6 p7])
    
    subplot(2,2,2)
    circ_plot(deg2rad(PD),'pretty');
    title('Matts Tuning using positivity')
    
    subplot(2,2,3:4)
    hold on
    
    %plot top 3
    plot(-500:2500,allSDF(ix(1),:),'r')
    plot(-500:2500,allSDF(ix(2),:),'r')
    plot(-500:2500,allSDF(ix(3),:),'r')
    
    %plot middle
    plot(-500:2500,allSDF(ix(4),:),'k')
    plot(-500:2500,allSDF(ix(5),:),'k')
    
    %plot bottom 3
    plot(-500:2500,allSDF(ix(6),:),'b')
    plot(-500:2500,allSDF(ix(7),:),'b')
    plot(-500:2500,allSDF(ix(8),:),'b')
    
    title(['In (red)= ' mat2str([ix(1)-1 ix(2)-1 ix(3)-1]) ' Out (blue) = ' mat2str([ix(6)-1 ix(7)-1 ix(8)-1])])
    
    xlim([-50 500])
end