%presentation demo

load S031909004-RH_SEARCH
out = find(isnan(MStim_(:,1))==1 & Correct_(:,2) == 1 & ismember(Target_(:,2),[4]));
in = find(Correct_(:,2) == 1 & isnan(MStim_(:,1)) == 1 & ismember(Target_(:,2),[0]));

animate_coherence(in,'DSP14a','AD14')


animate_coherence(out,'DSP14a','AD14')