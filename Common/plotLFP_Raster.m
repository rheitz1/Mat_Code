%plot LFP with a raster superimposed for a single trial
function [] = plotLFP_Raster(Spike,LFP,trl)

Target_ = evalin('caller','Target_');

LFP = baseline_correct(LFP,[Target_(1,1)-100 Target_(1,1)]);

figure
plot(-Target_(1,1):size(LFP,2)-Target_(1,1)-1,LFP(trl,:),'k')
axis ij
xlim([-1000 0])

vline(Spike(trl,:)-Target_(1,1),'r')
