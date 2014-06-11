%illustrates effects of random sampling on SDFs


nSamps = 100;
nReps = 100;


file = 'Q092607001-JC_SEARCH';

load(file,'DSP09a','RFs','Correct_','Errors_','Target_','TrialStart_','SRT')

RF = RFs.DSP09a;
antiRF = mod((RF + 4),8);

inTrials_full = shake(find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50));
outTrials_full = shake(find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50));

SDF_in_full = spikedensityfunct(DSP09a,Target_(:,1),[-100 500],inTrials_full,TrialStart_);
SDF_out_full = spikedensityfunct(DSP09a,Target_(:,1),[-100 500],outTrials_full,TrialStart_);

TDT_full = getTDT_SP(DSP09a,inTrials_full,outTrials_full);

figure
set(gcf,'color','white')

subplot(1,2,1)
plot(-100:500,SDF_in_full,'b',-100:500,SDF_out_full,'b','linewidth',2)
xlabel(['nIn = ' mat2str(length(inTrials_full)) ' nOut = ' mat2str(length(outTrials_full))],'fontsize',14,'fontweight','bold')
xlim([-100 500])
vline(TDT_full)
title(['TDT = ' mat2str(TDT_full)],'fontsize',14,'fontweight','bold')


for rep = 1:nReps
    rep
    %re-randomize
    inTrials_full = shake(inTrials_full);
    outTrials_full = shake(outTrials_full);
    
    %sub-sample
    inTrials_sub = inTrials_full(randperm(nSamps));
    outTrials_sub = outTrials_full(randperm(nSamps));
    
    SDF_in_sub = spikedensityfunct(DSP09a,Target_(:,1),[-100 500],inTrials_sub,TrialStart_);
    SDF_out_sub = spikedensityfunct(DSP09a,Target_(:,1),[-100 500],outTrials_sub,TrialStart_);
    
    TDT_sub(rep,1) = getTDT_SP(DSP09a,inTrials_sub,outTrials_sub);
%     
%     subplot(1,2,2)
%     plot(-100:500,SDF_in_sub,'r',-100:500,SDF_out_sub,'--r','linewidth',2)
%     xlim([-100 500])
%     xlabel(['nIn = ' mat2str(length(inTrials_sub)) ' nOut = ' mat2str(length(outTrials_sub))],'fontsize',14,'fontweight','bold')
%     vline(TDT_sub(rep,1))
%     title(['TDT = ' mat2str(TDT_sub(rep,1))],'fontsize',14,'fontweight','bold')
%     pause
%     cla
end