freqwin = [35 100];
%freqwin = [.01 10];

basewin = [-50 50];

allGrandaverage = 0;
sigOnly = 1; %only use sessions that had some number of significant clusters

basecorrect_coh = 1; %do you want to baseline correct the coherence matrices (only works for raw)?
propFlag = 0; %do you want to plot Tin / Din or Tin - Din.  Set to 1 for former

if sigOnly == 1
    for sess = 1:size(Pcoh_all.in.fast.ss2,3)
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
            Pcoh_all.in.fast.ss2(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss2(:,:,sess) = NaN;
            Pcoh_all.in.slow.ss2(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss2(:,:,sess) = NaN;
            
            Pcoh_all.in.fast.ss4(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss4(:,:,sess) = NaN;
            Pcoh_all.in.slow.ss4(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss4(:,:,sess) = NaN;

            Pcoh_all.in.fast.ss8(:,:,sess) = NaN;
            Pcoh_all.out.fast.ss8(:,:,sess) = NaN;
            Pcoh_all.in.slow.ss8(:,:,sess) = NaN;
            Pcoh_all.out.slow.ss8(:,:,sess) = NaN;

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


%NOTE: I HAVE NOT CHANGED THE VARIABLE NAMES BUT THEY ARE NO LONGER DIFFERENCE SCORES BUT T-IN ONLY!!
dif.fast.ss2 = abs(Pcoh_all.in.fast.ss2);
dif.fast.ss4 = abs(Pcoh_all.in.fast.ss4);
dif.fast.ss8 = abs(Pcoh_all.in.fast.ss8);

dif.slow.ss2 = abs(Pcoh_all.in.slow.ss2);
dif.slow.ss4 = abs(Pcoh_all.in.slow.ss4);
dif.slow.ss8 = abs(Pcoh_all.in.slow.ss8);


%baseline corrected version
dif.fast.ss2_bc = baseline_correct(transpose3(dif.fast.ss2),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.fast.ss4_bc = baseline_correct(transpose3(dif.fast.ss4),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.fast.ss8_bc = baseline_correct(transpose3(dif.fast.ss8),[find(tout == basewin(1)) find(tout == basewin(2))]);

dif.slow.ss2_bc = baseline_correct(transpose3(dif.slow.ss2),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.slow.ss4_bc = baseline_correct(transpose3(dif.slow.ss4),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.slow.ss8_bc = baseline_correct(transpose3(dif.slow.ss8),[find(tout == basewin(1)) find(tout == basewin(2))]);



dif.fast.ss2_bc = squeeze(nanmean(dif.fast.ss2_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.fast.ss4_bc = squeeze(nanmean(dif.fast.ss4_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.fast.ss8_bc = squeeze(nanmean(dif.fast.ss8_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));

dif.slow.ss2_bc = squeeze(nanmean(dif.slow.ss2_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.slow.ss4_bc = squeeze(nanmean(dif.slow.ss4_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.slow.ss8_bc = squeeze(nanmean(dif.slow.ss8_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));



%no baseline correction version

dif.fast.ss2 = transpose3(dif.fast.ss2);
dif.fast.ss4 = transpose3(dif.fast.ss4);
dif.fast.ss8 = transpose3(dif.fast.ss8);

dif.slow.ss2 = transpose3(dif.slow.ss2);
dif.slow.ss4 = transpose3(dif.slow.ss4);
dif.slow.ss8 = transpose3(dif.slow.ss8);

dif.fast.ss2 = squeeze(nanmean(dif.fast.ss2(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.fast.ss4 = squeeze(nanmean(dif.fast.ss4(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.fast.ss8 = squeeze(nanmean(dif.fast.ss8(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));

dif.slow.ss2 = squeeze(nanmean(dif.slow.ss2(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.slow.ss4 = squeeze(nanmean(dif.slow.ss4(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.slow.ss8 = squeeze(nanmean(dif.slow.ss8(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));


%no baseline correction plots
% figure
% plot(tout,nanmean(dif.fast.ss2,2),'b',tout,nanmean(dif.slow.ss2,2),'--b', ...
%     tout,nanmean(dif.fast.ss4,2),'r',tout,nanmean(dif.slow.ss4,2),'--r', ...
%     tout,nanmean(dif.fast.ss8,2),'g',tout,nanmean(dif.slow.ss8,2),'--g')
% xlim([-200 500])
% title('No Baseline Correction')

%baseline corrected plots
figure
plot(tout,nanmean(dif.fast.ss2_bc,2),'b',tout,nanmean(dif.slow.ss2_bc,2),'--b', ...
    tout,nanmean(dif.fast.ss4_bc,2),'r',tout,nanmean(dif.slow.ss4_bc,2),'--r', ...
    tout,nanmean(dif.fast.ss8_bc,2),'g',tout,nanmean(dif.slow.ss8_bc,2),'--g')
xlim([-200 500])
title('Baseline Corrected')