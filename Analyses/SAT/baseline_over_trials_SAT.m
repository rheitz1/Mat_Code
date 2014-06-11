% Return/plot baseline firing rate over trials

function [baseline] = baseline_over_trials_SAT(Spike,basewin,plotFlag)

if nargin < 3; plotFlag = 1; end
if nargin < 2; basewin = [-400 0]; end

%variables we'll need
Target_ = evalin('caller','Target_');
SAT_ = evalin('caller','SAT_');

accurate = find(SAT_(:,1) == 1);
neutral = find(SAT_(:,1) == 2);
fast = find(SAT_(:,1) == 3);

SDF = sSDF(Spike,Target_(:,1),[basewin(1) basewin(2)]);

SDF = nanmean(SDF,2);



%Figure out trial sequences
counter = 1;
counter2 = 1;

blockSeq(1,1) = counter2; %keeps track of which block you are in
trialSeq(1,1) = counter; %keeps track of trial numbers within a block
for trl = 2:size(SAT_,1)
    if SAT_(trl,1) == SAT_(trl-1,1)
        trialSeq(trl,1) = counter + 1;
        blockSeq(trl,1) = counter2;
        counter = counter + 1;
    else
        trialSeq(trl,1) = 1;
        blockSeq(trl,1) = counter2+1;
        counter = 1;
        counter2 = counter2 + 1;
    end
end


pos1 = find(trialSeq == 1);
pos2 = find(trialSeq == 2);
pos3 = find(trialSeq == 3);
pos4 = find(trialSeq == 4);
pos5 = find(trialSeq == 5);
pos6 = find(trialSeq == 6);
pos7 = find(trialSeq == 7);
pos8 = find(trialSeq == 8);
pos9 = find(trialSeq == 9);
pos10 = find(trialSeq == 10);
pos11 = find(trialSeq == 11);
pos12 = find(trialSeq == 12);
pos13 = find(trialSeq == 13);
pos14 = find(trialSeq == 14);
pos15 = find(trialSeq == 15);
pos16 = find(trialSeq == 16);
pos17 = find(trialSeq == 17);
pos18 = find(trialSeq == 18);
pos19 = find(trialSeq == 19);
pos20 = find(trialSeq == 20);

ACC.p1 = intersect(accurate,pos1);
ACC.p2 = intersect(accurate,pos2);
ACC.p3 = intersect(accurate,pos3);
ACC.p4 = intersect(accurate,pos4);
ACC.p5 = intersect(accurate,pos5);
ACC.p6 = intersect(accurate,pos6);
ACC.p7 = intersect(accurate,pos7);
ACC.p8 = intersect(accurate,pos8);
ACC.p9 = intersect(accurate,pos9);
ACC.p10 = intersect(accurate,pos10);
ACC.p11 = intersect(accurate,pos11);
ACC.p12 = intersect(accurate,pos12);
ACC.p13 = intersect(accurate,pos13);
ACC.p14 = intersect(accurate,pos14);
ACC.p15 = intersect(accurate,pos15);
ACC.p16 = intersect(accurate,pos16);
ACC.p17 = intersect(accurate,pos17);
ACC.p18 = intersect(accurate,pos18);
ACC.p19 = intersect(accurate,pos19);
ACC.p20 = intersect(accurate,pos20);

FAST.p1 = intersect(fast,pos1);
FAST.p2 = intersect(fast,pos2);
FAST.p3 = intersect(fast,pos3);
FAST.p4 = intersect(fast,pos4);
FAST.p5 = intersect(fast,pos5);
FAST.p6 = intersect(fast,pos6);
FAST.p7 = intersect(fast,pos7);
FAST.p8 = intersect(fast,pos8);
FAST.p9 = intersect(fast,pos9);
FAST.p10 = intersect(fast,pos10);
FAST.p11 = intersect(fast,pos11);
FAST.p12 = intersect(fast,pos12);
FAST.p13 = intersect(fast,pos13);
FAST.p14 = intersect(fast,pos14);
FAST.p15 = intersect(fast,pos15);
FAST.p16 = intersect(fast,pos16);
FAST.p17 = intersect(fast,pos17);
FAST.p18 = intersect(fast,pos18);
FAST.p19 = intersect(fast,pos19);
FAST.p20 = intersect(fast,pos20);

NEUTRAL.p1 = intersect(neutral,pos1);
NEUTRAL.p2 = intersect(neutral,pos2);
NEUTRAL.p3 = intersect(neutral,pos3);
NEUTRAL.p4 = intersect(neutral,pos4);
NEUTRAL.p5 = intersect(neutral,pos5);
NEUTRAL.p6 = intersect(neutral,pos6);
NEUTRAL.p7 = intersect(neutral,pos7);
NEUTRAL.p8 = intersect(neutral,pos8);
NEUTRAL.p9 = intersect(neutral,pos9);
NEUTRAL.p10 = intersect(neutral,pos10);
NEUTRAL.p11 = intersect(neutral,pos11);
NEUTRAL.p12 = intersect(neutral,pos12);
NEUTRAL.p13 = intersect(neutral,pos13);
NEUTRAL.p14 = intersect(neutral,pos14);
NEUTRAL.p15 = intersect(neutral,pos15);
NEUTRAL.p16 = intersect(neutral,pos16);
NEUTRAL.p17 = intersect(neutral,pos17);
NEUTRAL.p18 = intersect(neutral,pos18);
NEUTRAL.p19 = intersect(neutral,pos19);
NEUTRAL.p20 = intersect(neutral,pos20);



% Now calculate the baseline effect over blocks of trials. We don't know
% how many blocks there were, so have to calculate that

for blk = 1:max(blockSeq)
    blkAvg(blk,1) = nanmean(SDF(find(blockSeq == blk)));
    blkAvg(blk,2) = nanmean(SAT_(find(blockSeq == blk),1)); %take nanmean in case there is a stray NaN in SAT_ variable.
end

if plotFlag
    figure
    
    %First plot effect over trials within a block, averaging over blocks
    subplot(121)
    plot(1:22,[nanmean(SDF(ACC.p1)) nanmean(SDF(ACC.p2)) nanmean(SDF(ACC.p3)) nanmean(SDF(ACC.p4)) nanmean(SDF(ACC.p5)) ...
        nanmean(SDF(ACC.p6)) nanmean(SDF(ACC.p7)) nanmean(SDF(ACC.p8)) nanmean(SDF(ACC.p9)) nanmean(SDF(ACC.p10)) ...
        nanmean(SDF(ACC.p11)) nanmean(SDF(ACC.p12)) nanmean(SDF(ACC.p13)) nanmean(SDF(ACC.p14)) nanmean(SDF(ACC.p15)) ...
        nanmean(SDF(ACC.p16)) nanmean(SDF(ACC.p17)) nanmean(SDF(ACC.p18)) nanmean(SDF(ACC.p19)) nanmean(SDF(ACC.p20)) ...
        nanmean(SDF(FAST.p1)) nanmean(SDF(FAST.p2))],'r')
    hold on
    %recolor last two for clarity
    plot(20:22,[nanmean(SDF(ACC.p20)) nanmean(SDF(FAST.p1)) nanmean(SDF(FAST.p2))],'g')
    
    plot(1:22,[nanmean(SDF(FAST.p1)) nanmean(SDF(FAST.p2)) nanmean(SDF(FAST.p3)) nanmean(SDF(FAST.p4)) nanmean(SDF(FAST.p5)) ...
        nanmean(SDF(FAST.p6)) nanmean(SDF(FAST.p7)) nanmean(SDF(FAST.p8)) nanmean(SDF(FAST.p9)) nanmean(SDF(FAST.p10)) ...
        nanmean(SDF(FAST.p11)) nanmean(SDF(FAST.p12)) nanmean(SDF(FAST.p13)) nanmean(SDF(FAST.p14)) nanmean(SDF(FAST.p15)) ...
        nanmean(SDF(FAST.p16)) nanmean(SDF(FAST.p17)) nanmean(SDF(FAST.p18)) nanmean(SDF(FAST.p19)) nanmean(SDF(FAST.p20)) ...
        nanmean(SDF(ACC.p1)) nanmean(SDF(ACC.p2))],'g')
    %recolor last two for clarity
    plot(20:22,[nanmean(SDF(FAST.p20)) nanmean(SDF(ACC.p1)) nanmean(SDF(ACC.p2))],'r')
    
    plot(1:20,[nanmean(SDF(NEUTRAL.p1)) nanmean(SDF(NEUTRAL.p2)) nanmean(SDF(NEUTRAL.p3)) nanmean(SDF(NEUTRAL.p4)) nanmean(SDF(NEUTRAL.p5)) ...
        nanmean(SDF(NEUTRAL.p6)) nanmean(SDF(NEUTRAL.p7)) nanmean(SDF(NEUTRAL.p8)) nanmean(SDF(NEUTRAL.p9)) nanmean(SDF(NEUTRAL.p10)) ...
        nanmean(SDF(NEUTRAL.p11)) nanmean(SDF(NEUTRAL.p12)) nanmean(SDF(NEUTRAL.p13)) nanmean(SDF(NEUTRAL.p14)) nanmean(SDF(NEUTRAL.p15)) ...
        nanmean(SDF(NEUTRAL.p16)) nanmean(SDF(NEUTRAL.p17)) nanmean(SDF(NEUTRAL.p18)) nanmean(SDF(NEUTRAL.p19)) nanmean(SDF(NEUTRAL.p20))],'k')
    title('Baseline effect over trials WITHIN a block')
    xlabel('Trial')
    ylabel('Firing Rate (Hz)')
    box off
    
    %Now plot baseline effect over blocks, averaging over trials within a
    %block
    
    subplot(122)
    plot(blkAvg(find(blkAvg(:,2) == 1),1),'r')
    hold on
    plot(blkAvg(find(blkAvg(:,2) == 2),1),'k')
    plot(blkAvg(find(blkAvg(:,2) == 3),1),'g')
    
    title('Baseline effect over blocks (collapse on trial)')
    xlabel('Block Number')
    ylabel('Firing Rate (Hz)')
    box off
    xlim([0 max(blockSeq)/2+2])

end