sig = DSP16a;

fixed = sig;
fixed(find(fixed == 0)) = NaN;


%do not eliminate spikes yet because of filter problems.  make the SDF first, then truncate at target
%onset

SDF = sSDF(sig,3500-FixTime_Jit_,[-100 3000]);

for trl = 1:size(SDF,1)
    SDF(trl,FixTime_Jit_(trl)+100:end) = NaN;
end


fig

subplot(1,2,1)
plot(-100:3000,nanmean(SDF(slow_correct_made_dead,:)),'r',-100:3000,nanmean(SDF(fast_correct_made_dead_withCleared,:)),'g')

xlim([-100 3000]);

SDF = sSDF(sig,Target_(:,1),[-3500 2500]);

subplot(1,2,2)
plot(-3500:2500,nanmean(SDF(slow_correct_made_dead,:)),'r',-3500:2500,nanmean(SDF(fast_correct_made_dead_withCleared,:)),'g')
xlim([-3500 2500])