%FREQUENCY TO TEST (NOTE: have to re-load file after each run
disp('DID YOU NORMALIZE???')
disp('DID YOU NORMALIZE???')
disp('DID YOU NORMALIZE???')
disp('DID YOU NORMALIZE???')

freqwin = [35 100];
%freqwin = [.01 10];

basewin = [-200 -100];
%basewin = [-400 -300]

allGrandaverage = 0;
sigOnly = 1; %only use sessions that had some number of significant clusters

basecorrect_coh = 1; %do you want to baseline correct the coherence matrices (only works for raw)?
propFlag = 0; %do you want to plot Tin / Din or Tin - Din.  Set to 1 for former

%first keep only significant sessions (test same things we're plotting in
%time averages.
if sigOnly == 1
    for sess = 1:size(Pcoh_all.in.all,3)
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
            Pcoh_all.in.all(:,:,sess) = NaN;
            Pcoh_all.out.all(:,:,sess) = NaN;
            
            Pcoh_all.in.all_sub(:,:,sess) = NaN;
            Pcoh_all.out.all_sub(:,:,sess) = NaN;
            
            Pcoh_all.in.ss2(:,:,sess) = NaN;
            Pcoh_all.in.ss4(:,:,sess) = NaN;
            Pcoh_all.in.ss8(:,:,sess) = NaN;
            
            Pcoh_all.out.ss2(:,:,sess) = NaN;
            Pcoh_all.out.ss4(:,:,sess) = NaN;
            Pcoh_all.out.ss8(:,:,sess) = NaN;
            
            Pcoh_all.in.fast.all(:,:,sess) = NaN;
            Pcoh_all.in.fast.ss2(:,:,sess) = NaN;
            Pcoh_all.in.fast.ss4(:,:,sess) = NaN;
            Pcoh_all.in.fast.ss8(:,:,sess) = NaN;
            
            Pcoh_all.out.fast.all(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss2(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss4(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss8(:,:,sess) = NaN;
            
            Pcoh_all.in.slow.all(:,:,sess) = NaN;
            Pcoh_all.in.slow.ss2(:,:,sess) = NaN;
            Pcoh_all.in.slow.ss4(:,:,sess) = NaN;
            Pcoh_all.in.slow.ss8(:,:,sess) = NaN;
            
            Pcoh_all.out.slow.all(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss2(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss4(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss8(:,:,sess) = NaN;
            
            Pcoh_all.in.err(:,:,sess) = NaN;
            Pcoh_all.out.err(:,:,sess) = NaN;
            
            nsig.all(sess,1) = 0;
        else
            nsig.all(sess,1) = 1;
        end
        
        
    end
else
    nsig.all = size(Pcoh_all.in.all,3);
    nsig.ss2 = size(Pcoh_all.in.ss2,3);
    nsig.ss4 = size(Pcoh_all.in.ss4,3);
    nsig.ss8 = size(Pcoh_all.in.ss8,3);
    nsig.fast = size(Pcoh_all.in.fast,3);
    nsig.slow = size(Pcoh_all.in.slow,3);
    nsig.err = size(Pcoh_all.in.err,3);
end


%get baseline corrected values
dif.all_sub = abs(Pcoh_all.in.all_sub) - abs(Pcoh_all.out.all_sub);
dif.all = abs(Pcoh_all.in.all) - abs(Pcoh_all.out.all);
dif.ss2 = abs(Pcoh_all.in.ss2) - abs(Pcoh_all.out.ss2);
dif.ss4 = abs(Pcoh_all.in.ss4) - abs(Pcoh_all.out.ss4);
dif.ss8 = abs(Pcoh_all.in.ss8) - abs(Pcoh_all.out.ss8);
dif.fast = abs(Pcoh_all.in.fast.all) - abs(Pcoh_all.out.fast.all);
dif.slow = abs(Pcoh_all.in.slow.all) - abs(Pcoh_all.out.slow.all);
dif.err = abs(Pcoh_all.in.err) - abs(Pcoh_all.out.err);

%======
% Baseline corrected versions
allsubdif_bc = baseline_correct(transpose3(dif.all_sub),[find(tout == basewin(1)) find(tout == basewin(2))]);
alldif_bc = baseline_correct(transpose3(dif.all),[find(tout == basewin(1)) find(tout == basewin(2))]);
s2dif_bc = baseline_correct(transpose3(dif.ss2),[find(tout == basewin(1)) find(tout == basewin(2))]);
s4dif_bc = baseline_correct(transpose3(dif.ss4),[find(tout == basewin(1)) find(tout == basewin(2))]);
s8dif_bc = baseline_correct(transpose3(dif.ss8),[find(tout == basewin(1)) find(tout == basewin(2))]);
fsdif_bc = baseline_correct(transpose3(dif.fast),[find(tout == basewin(1)) find(tout == basewin(2))]);
sldif_bc = baseline_correct(transpose3(dif.slow),[find(tout == basewin(1)) find(tout == basewin(2))]);
errdif_bc = baseline_correct(transpose3(dif.err),[find(tout == basewin(1)) find(tout == basewin(2))]);

allsubdif_bc = squeeze(nanmean(allsubdif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
alldif_bc = squeeze(nanmean(alldif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s2dif_bc = squeeze(nanmean(s2dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s4dif_bc = squeeze(nanmean(s4dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s8dif_bc = squeeze(nanmean(s8dif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fsdif_bc = squeeze(nanmean(fsdif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sldif_bc = squeeze(nanmean(sldif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
errdif_bc = squeeze(nanmean(errdif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));


%===========
% No baseline correction version
allsubdif = transpose3(dif.all_sub);
alldif = transpose3(dif.all);
s2dif = transpose3(dif.ss2);
s4dif = transpose3(dif.ss4);
s8dif = transpose3(dif.ss8);
fsdif = transpose3(dif.fast);
sldif = transpose3(dif.slow);
errdif = transpose3(dif.err);


allsubdif = squeeze(nanmean(allsubdif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
alldif = squeeze(nanmean(alldif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s2dif = squeeze(nanmean(s2dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s4dif = squeeze(nanmean(s4dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
s8dif = squeeze(nanmean(s8dif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
fsdif = squeeze(nanmean(fsdif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
sldif = squeeze(nanmean(sldif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
errdif = squeeze(nanmean(errdif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));








%======================
%  T E S T S with Baseline Correction
% NOTE: VECTORS ARE STILL TRANSPOSED SO TIME IS ALONG 1ST DIMENSION and
% SESSION is along 2nd

testwindow = [250 350];
%testwindow = [350 450];
testtimes = find(tout >= testwindow(1) & tout <= testwindow(2));
%set size 2 vs set size 4. dependent samples t-test
%get means in window
corrav = nanmean(alldif_bc(testtimes,:),1)';
errav = nanmean(errdif_bc(testtimes,:),1)';
s2av = nanmean(s2dif_bc(testtimes,:),1)';
s4av = nanmean(s4dif_bc(testtimes,:),1)';
s8av = nanmean(s8dif_bc(testtimes,:),1)';
fastav = nanmean(fsdif_bc(testtimes,:),1)';
slowav = nanmean(sldif_bc(testtimes,:),1)';

corr_vs_err = removeNaN([corrav errav]);
s2_vs_s4 = removeNaN([s2av s4av]);
s4_vs_s8 = removeNaN([s4av s8av]);
s2_vs_s8 = removeNaN([s2av s8av]);
fast_vs_slow = removeNaN([fastav slowav]);


[h p ci stats] = ttest(corr_vs_err(:,1),corr_vs_err(:,2))
[h p ci stats] = ttest(s2_vs_s4(:,1),s2_vs_s4(:,2))
[h p ci stats] = ttest(s4_vs_s8(:,1),s4_vs_s8(:,2))
[h p ci stats] = ttest(s2_vs_s8(:,1),s2_vs_s8(:,2))
[h p ci stats] = ttest(fast_vs_slow(:,1),fast_vs_slow(:,2))
%=========================




%
% %======================
% %  T E S T S without Baseline Correction
% % NOTE: VECTORS ARE STILL TRANSPOSED SO TIME IS ALONG 1ST DIMENSION and
% % SESSION is along 2nd
%
% testwindow = [200 300];
% testtimes = find(tout >= testwindow(1) & tout <= testwindow(2));
% %set size 2 vs set size 4. dependent samples t-test
% %get means in window
% corrav = nanmean(alldif(testtimes,:),1)';
% errav = nanmean(errdif(testtimes,:),1)';
% s2av = nanmean(s2dif(testtimes,:),1)';
% s4av = nanmean(s4dif(testtimes,:),1)';
% s8av = nanmean(s8dif(testtimes,:),1)';
%
% corr_vs_err = removeNaN([corrav errav]);
% s2_vs_s4 = removeNaN([s2av s4av]);
% s4_vs_s8 = removeNaN([s4av s8av]);
% s2_vs_s8 = removeNaN([s2av s8av]);
%
% [h p ci stats] = ttest(corr_vs_err(:,1),corr_vs_err(:,2))
% [h p ci stats] = ttest(s2_vs_s4(:,1),s2_vs_s4(:,2))
% [h p ci stats] = ttest(s4_vs_s8(:,1),s4_vs_s8(:,2))
% [h p ci stats] = ttest(s2_vs_s8(:,1),s2_vs_s8(:,2))