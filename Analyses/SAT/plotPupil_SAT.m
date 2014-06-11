% Plots pupil effect for SAT
% RPH


Pupil_bc = baseline_correct(Pupil_,[2750 2760]);
%Pupil_bc = baseline_correct(Pupil_,[3000 3100]);
%Pupil_ = sqrt(Pupil_);

Pupil_fix = fix_align(Pupil_,FixAcqTime_,[-50 3000]);
Pupil_fix_bc = baseline_correct(Pupil_fix,[50 100]);

getTrials_SAT

figure
subplot(221)
plot(-3500:2500,nanmean(Pupil_bc(slow_correct_made_dead,:)),'r', ...
    -3500:2500,nanmean(Pupil_bc(fast_correct_made_dead_withCleared,:)),'g')
xlim([-1000 300])
title('Baseline corrected, Targ Aligned')


subplot(223)
plot(-3500:2500,nanmean(Pupil_(slow_correct_made_dead,:)),'r', ...
    -3500:2500,nanmean(Pupil_(fast_correct_made_dead_withCleared,:)),'g')
xlim([-1000 300])
title('Not Baseline corrected, Targ Aligned')


subplot(222)
plot(-50:3000,nanmean(Pupil_fix_bc(slow_correct_made_dead,:)),'r', ...
    -50:3000,nanmean(Pupil_fix_bc(fast_correct_made_dead_withCleared,:)),'g')
xlim([-50 3000])
title('Baseline Corrected, FixAcq Aligned')


subplot(224)
plot(-50:3000,nanmean(Pupil_fix(slow_correct_made_dead,:)),'r', ...
    -50:3000,nanmean(Pupil_fix(fast_correct_made_dead_withCleared,:)),'g')
xlim([-50 3000])
title('Not Baseline Corrected, FixAcq Aligned')


