Spike = DSP09a;
SDF = sSDF(Spike,Target_(:,1),[-100 500]);

RF = RFs.DSP09a;
antiRF = mod((RF+4),8);

in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);

a.in = in_correct(find(in_correct <= 400));
a.out = out_correct(find(out_correct <= 400));
a.RT = nanmean(SRT([a.in; a.out]),1);

b.in = in_correct(find(in_correct > 400 & in_correct<= 800));
b.out = out_correct(find(out_correct > 400 & out_correct<= 800));
b.RT = nanmean(SRT([b.in; b.out]),1);

c.in = in_correct(find(in_correct > 800 & in_correct<= 1200));
c.out = out_correct(find(out_correct > 800 &  out_correct<= 1200));
c.RT = nanmean(SRT([b.in; b.out]),1);

d.in = in_correct(find(in_correct > 1200 & in_correct<= 1600));
d.out = out_correct(find(out_correct > 1200 & out_correct<= 1600));
d.RT = nanmean(SRT([c.in; c.out]),1);

e.in = in_correct(find(in_correct > 1600 &  in_correct<= 2000));
e.out = out_correct(find(out_correct > 1600 & out_correct<= 2000));
e.RT = nanmean(SRT([d.in; d.out]),1);

f.in = in_correct(find(in_correct > 2000 &  in_correct<= 2400));
f.out = out_correct(find(out_correct > 2000 & out_correct <= 2400));
f.RT = nanmean(SRT([e.in; e.out]),1);

g.in = in_correct(find(in_correct > 2400 &  in_correct<= 2800));
g.out = out_correct(find(out_correct > 2400 & out_correct <= 2800));
g.RT = nanmean(SRT([f.in; f.out]),1);

z.in = in_correct(find(in_correct > 3400 &  in_correct<= 3800));
z.out = out_correct(find(out_correct > 3400 & out_correct <= 3800));
z.RT = nanmean(SRT([z.in; z.out]),1);


SDF.a.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],a.in,TrialStart_);
SDF.a.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],a.out,TrialStart_);

SDF.b.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],b.in,TrialStart_);
SDF.b.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],b.out,TrialStart_);

SDF.c.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],c.in,TrialStart_);
SDF.c.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],c.out,TrialStart_);

SDF.d.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],d.in,TrialStart_);
SDF.d.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],d.out,TrialStart_);

SDF.e.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],e.in,TrialStart_);
SDF.e.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],e.out,TrialStart_);

SDF.f.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],f.in,TrialStart_);
SDF.f.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],f.out,TrialStart_);

SDF.g.in = spikedensityfunct(Spike,Target_(:,1),[-100 500],g.in,TrialStart_);
SDF.g.out = spikedensityfunct(Spike,Target_(:,1),[-100 500],g.out,TrialStart_);


% SDF.z.in = spikedensityfunct(DSP09a,Target_(:,1),[-100 500],z.in,TrialStart_);
% SDF.z.out = spikedensityfunct(DSP09a,Target_(:,1),[-100 500],z.out,TrialStart_);

% ROC.a = getROC(Spike,a.in,a.out);
% ROC.b = getROC(Spike,b.in,b.out);
% ROC.c = getROC(Spike,c.in,c.out);
% ROC.d = getROC(Spike,d.in,d.out);
% ROC.e = getROC(Spike,e.in,e.out);
% ROC.f = getROC(Spike,f.in,f.out);
% ROC.g = getROC(Spike,g.in,g.out);
% ROC.z = getROC(Spike,z.in,z.out);

figure

plot(-100:500,SDF.a.in,'k',-100:500,SDF.a.out,'--k', ...
    -100:500,SDF.b.in,'b',-100:500,SDF.b.out,'--b', ...
    -100:500,SDF.c.in,'r',-100:500,SDF.c.out,'--r', ...
    -100:500,SDF.e.in,'g',-100:500,SDF.e.out,'--g', ...
    -100:500,SDF.f.in,'m',-100:500,SDF.f.out,'--m', ...
    -100:500,SDF.g.in,'c',-100:500,SDF.g.out,'--c')%, ...
    %-100:500,SDF.z.in,'y',-100:500,SDF.z.out,'--y')