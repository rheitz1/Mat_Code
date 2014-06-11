Unit = 'DSP04a';

Spike = eval(Unit);

[SRT saccLoc] = getSRT(EyeX_,EyeY_);
RF = RFs.(Unit);
antiRF = mod((RF+4),8);

in = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF));
out = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF));

catch_err = find(Correct_(:,2) == 0 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
catch_late_resp = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & ismember(saccLoc,RF) & ~isnan(SRT(:,1)));
catch_noresp = find(Correct_(:,2) == 1 & Target_(:,2) == 255 & isnan(SRT(:,1)));


SDF.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],in,TrialStart_);
SDF.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],out,TrialStart_);
SDF.catch_err = spikedensityfunct(Spike,Target_(:,1),[-100 500],catch_err,TrialStart_);
SDF.catch_late_resp = spikedensityfunct(Spike,Target_(:,1),[-100 500],catch_late_resp,TrialStart_);
SDF.catch_noresp = spikedensityfunct(Spike,Target_(:,1),[-100 500],catch_noresp,TrialStart_);

SDF_resp.in = spikedensityfunct(Spike,SRT(:,1)+500,[-200 300],in,TrialStart_);
SDF_resp.out = spikedensityfunct(Spike,SRT(:,1)+500,[-200 300],out,TrialStart_);
SDF_resp.catch_err = spikedensityfunct(Spike,SRT(:,1)+500,[-200 300],catch_err,TrialStart_);
SDF_resp.catch_late_resp = spikedensityfunct(Spike,SRT(:,1)+500,[-200 300],catch_late_resp,TrialStart_);
SDF_resp.catch_noresp = spikedensityfunct(Spike,SRT(:,1)+500,[-200 300],catch_noresp,TrialStart_);

figure
set(gcf,'color','white')

subplot(1,2,1)
plot(-100:500,SDF.in,'k',-100:500,SDF.out,'--k',-100:500,SDF.catch_err,'r', ...
    -100:500,SDF.catch_late_resp,'b',-100:500,SDF.catch_noresp,'g')
xlim([-100 500])


subplot(1,2,2)
plot(-200:300,SDF_resp.in,'k',-200:300,SDF_resp.out,'--k',-200:300,SDF_resp.catch_err,'r', ...
    -200:300,SDF_resp.catch_late_resp,'b',-200:300,SDF_resp.catch_noresp,'g')
xlim([-200 300])