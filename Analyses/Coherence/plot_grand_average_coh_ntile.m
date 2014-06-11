%make grand average coherence plots
% RPH

% frequency windows to average over

% NOTE: The below will create temporal coherence functions averaging across
% some frequency window.  If sigOnly is set to 1, only sessions with
% significant coherence in that region will be included (as it is set, it
% includes all time periods).  Keep in mind that when changing to, say, a
% lower frequency window, different sessions may thus be included as
% compared to a higher frequency window.


%freqwin = [35 100];
freqwin = [.01 10];

basewin = [-200 -100];

allGrandaverage = 0;
sigOnly = 1; %only use sessions that had some number of significant clusters

basecorrect_coh = 1; %do you want to baseline correct the coherence matrices (only works for raw)?
propFlag = 0; %do you want to plot Tin / Din or Tin - Din.  Set to 1 for former


if sigOnly == 1
    for sess = 1:size(Pcoh_all.all.in,3)
        if ~any(any(shuff_all(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
            Pcoh_all.all.in(:,:,sess) = NaN;
            Pcoh_all.all.out(:,:,sess) = NaN;
            
            %===========
            % Quartiles
            Pcoh_all.ss2.in.bin1(:,:,sess) = NaN;
            Pcoh_all.ss2.in.bin2(:,:,sess) = NaN;
            Pcoh_all.ss2.in.bin3(:,:,sess) = NaN;
            Pcoh_all.ss2.in.bin4(:,:,sess) = NaN;
            
            Pcoh_all.ss2.out.bin1(:,:,sess) = NaN;
            Pcoh_all.ss2.out.bin2(:,:,sess) = NaN;
            Pcoh_all.ss2.out.bin3(:,:,sess) = NaN;
            Pcoh_all.ss2.out.bin4(:,:,sess) = NaN;
            
            Pcoh_all.ss4.in.bin1(:,:,sess) = NaN;
            Pcoh_all.ss4.in.bin2(:,:,sess) = NaN;
            Pcoh_all.ss4.in.bin3(:,:,sess) = NaN;
            Pcoh_all.ss4.in.bin4(:,:,sess) = NaN;
            
            Pcoh_all.ss4.out.bin1(:,:,sess) = NaN;
            Pcoh_all.ss4.out.bin2(:,:,sess) = NaN;
            Pcoh_all.ss4.out.bin(:,:,sess) = NaN;
            Pcoh_all.ss4.out.bin4(:,:,sess) = NaN;
            
            
            Pcoh_all.ss8.in.bin1(:,:,sess) = NaN;
            Pcoh_all.ss8.in.bin2(:,:,sess) = NaN;
            Pcoh_all.ss8.in.bin3(:,:,sess) = NaN;
            Pcoh_all.ss8.in.bin4(:,:,sess) = NaN;
            
            Pcoh_all.ss8.out.bin1(:,:,sess) = NaN;
            Pcoh_all.ss8.out.bin2(:,:,sess) = NaN;
            Pcoh_all.ss8.out.bin3(:,:,sess) = NaN;
            Pcoh_all.ss8.out.bin4(:,:,sess) = NaN;
            
            %===================
            % Median Split
            Pcoh_all.ss2.in.bin12(:,:,sess) = NaN;
            Pcoh_all.ss2.in.bin34(:,:,sess) = NaN;
            Pcoh_all.ss2.out.bin12(:,:,sess) = NaN;
            Pcoh_all.ss2.out.bin34(:,:,sess) = NaN;
            
            Pcoh_all.ss4.in.bin12(:,:,sess) = NaN;
            Pcoh_all.ss4.in.bin34(:,:,sess) = NaN;
            Pcoh_all.ss4.out.bin12(:,:,sess) = NaN;
            Pcoh_all.ss4.out.bin34(:,:,sess) = NaN;

            Pcoh_all.ss8.in.bin12(:,:,sess) = NaN;
            Pcoh_all.ss8.in.bin34(:,:,sess) = NaN;
            Pcoh_all.ss8.out.bin12(:,:,sess) = NaN;
            Pcoh_all.ss8.out.bin34(:,:,sess) = NaN;

            
            nsig.all(sess,1) = 0;
        else
            nsig.all(sess,1) = 1;
        end
        
        
    end
else
    nsig.all = size(Pcoh_all.all.in,3);
end


dif.all = abs(Pcoh_all.all.in) - abs(Pcoh_all.all.out);

dif.ss2.bin1 = abs(Pcoh_all.ss2.in.bin1) - abs(Pcoh_all.ss2.out.bin1);
dif.ss2.bin2 = abs(Pcoh_all.ss2.in.bin2) - abs(Pcoh_all.ss2.out.bin2);
dif.ss2.bin3 = abs(Pcoh_all.ss2.in.bin3) - abs(Pcoh_all.ss2.out.bin3);
dif.ss2.bin4 = abs(Pcoh_all.ss2.in.bin4) - abs(Pcoh_all.ss2.out.bin4);

dif.ss4.bin1 = abs(Pcoh_all.ss4.in.bin1) - abs(Pcoh_all.ss4.out.bin1);
dif.ss4.bin2 = abs(Pcoh_all.ss4.in.bin2) - abs(Pcoh_all.ss4.out.bin2);
dif.ss4.bin3 = abs(Pcoh_all.ss4.in.bin3) - abs(Pcoh_all.ss4.out.bin3);
dif.ss4.bin4 = abs(Pcoh_all.ss4.in.bin4) - abs(Pcoh_all.ss4.out.bin4);

dif.ss8.bin1 = abs(Pcoh_all.ss8.in.bin1) - abs(Pcoh_all.ss8.out.bin1);
dif.ss8.bin2 = abs(Pcoh_all.ss8.in.bin2) - abs(Pcoh_all.ss8.out.bin2);
dif.ss8.bin3 = abs(Pcoh_all.ss8.in.bin3) - abs(Pcoh_all.ss8.out.bin3);
dif.ss8.bin4 = abs(Pcoh_all.ss8.in.bin4) - abs(Pcoh_all.ss8.out.bin4);

dif.ss2.bin12 = abs(Pcoh_all.ss2.in.bin12) - abs(Pcoh_all.ss2.out.bin12);
dif.ss2.bin34 = abs(Pcoh_all.ss2.in.bin34) - abs(Pcoh_all.ss2.out.bin34);

dif.ss4.bin12 = abs(Pcoh_all.ss4.in.bin12) - abs(Pcoh_all.ss4.out.bin12);
dif.ss4.bin34 = abs(Pcoh_all.ss4.in.bin34) - abs(Pcoh_all.ss4.out.bin34);

dif.ss8.bin12 = abs(Pcoh_all.ss8.in.bin12) - abs(Pcoh_all.ss8.out.bin12);
dif.ss8.bin34 = abs(Pcoh_all.ss8.in.bin34) - abs(Pcoh_all.ss8.out.bin34);


%======
% Baseline corrected versions

dif.all_bc = baseline_correct(transpose3(dif.all),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss2.bin1_bc = baseline_correct(transpose3(dif.ss2.bin1),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss2.bin2_bc = baseline_correct(transpose3(dif.ss2.bin2),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss2.bin3_bc = baseline_correct(transpose3(dif.ss2.bin3),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss2.bin4_bc = baseline_correct(transpose3(dif.ss2.bin4),[find(tout == basewin(1)) find(tout == basewin(2))]);

dif.ss2.bin12_bc = baseline_correct(transpose3(dif.ss2.bin12),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss2.bin12_bc = baseline_correct(transpose3(dif.ss2.bin12),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss2.bin34_bc = baseline_correct(transpose3(dif.ss2.bin34),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss2.bin34_bc = baseline_correct(transpose3(dif.ss2.bin34),[find(tout == basewin(1)) find(tout == basewin(2))]);

dif.ss4.bin1_bc = baseline_correct(transpose3(dif.ss4.bin1),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss4.bin2_bc = baseline_correct(transpose3(dif.ss4.bin2),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss4.bin3_bc = baseline_correct(transpose3(dif.ss4.bin3),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss4.bin4_bc = baseline_correct(transpose3(dif.ss4.bin4),[find(tout == basewin(1)) find(tout == basewin(2))]);

dif.ss4.bin12_bc = baseline_correct(transpose3(dif.ss4.bin12),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss4.bin12_bc = baseline_correct(transpose3(dif.ss4.bin12),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss4.bin34_bc = baseline_correct(transpose3(dif.ss4.bin34),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss4.bin34_bc = baseline_correct(transpose3(dif.ss4.bin34),[find(tout == basewin(1)) find(tout == basewin(2))]);


dif.ss8.bin1_bc = baseline_correct(transpose3(dif.ss8.bin1),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss8.bin2_bc = baseline_correct(transpose3(dif.ss8.bin2),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss8.bin3_bc = baseline_correct(transpose3(dif.ss8.bin3),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss8.bin4_bc = baseline_correct(transpose3(dif.ss8.bin4),[find(tout == basewin(1)) find(tout == basewin(2))]);

dif.ss8.bin12_bc = baseline_correct(transpose3(dif.ss8.bin12),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss8.bin12_bc = baseline_correct(transpose3(dif.ss8.bin12),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss8.bin34_bc = baseline_correct(transpose3(dif.ss8.bin34),[find(tout == basewin(1)) find(tout == basewin(2))]);
dif.ss8.bin34_bc = baseline_correct(transpose3(dif.ss8.bin34),[find(tout == basewin(1)) find(tout == basewin(2))]);



%===================
% get mean for baseline corrected versions
dif.all_bc = squeeze(nanmean(dif.all_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin1_bc = squeeze(nanmean(dif.ss2.bin1_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin2_bc = squeeze(nanmean(dif.ss2.bin2_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin3_bc = squeeze(nanmean(dif.ss2.bin3_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin4_bc = squeeze(nanmean(dif.ss2.bin4_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin12_bc = squeeze(nanmean(dif.ss2.bin12_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin34_bc = squeeze(nanmean(dif.ss2.bin34_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));

dif.ss4.bin1_bc = squeeze(nanmean(dif.ss4.bin1_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin2_bc = squeeze(nanmean(dif.ss4.bin2_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin3_bc = squeeze(nanmean(dif.ss4.bin3_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin4_bc = squeeze(nanmean(dif.ss4.bin4_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin12_bc = squeeze(nanmean(dif.ss4.bin12_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin34_bc = squeeze(nanmean(dif.ss4.bin34_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));


dif.ss8.bin1_bc = squeeze(nanmean(dif.ss8.bin1_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin2_bc = squeeze(nanmean(dif.ss8.bin2_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin3_bc = squeeze(nanmean(dif.ss8.bin3_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin4_bc = squeeze(nanmean(dif.ss8.bin4_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin12_bc = squeeze(nanmean(dif.ss8.bin12_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin34_bc = squeeze(nanmean(dif.ss8.bin34_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));


%===========
% No baseline correction version
dif.all = transpose3(dif.all);
dif.ss2.bin1 = transpose3(dif.ss2.bin1);
dif.ss2.bin2 = transpose3(dif.ss2.bin2);
dif.ss2.bin3 = transpose3(dif.ss2.bin3);
dif.ss2.bin4 = transpose3(dif.ss2.bin4);
dif.ss2.bin12 = transpose3(dif.ss2.bin12);
dif.ss2.bin34 = transpose3(dif.ss2.bin34);

dif.ss4.bin1 = transpose3(dif.ss4.bin1);
dif.ss4.bin2 = transpose3(dif.ss4.bin2);
dif.ss4.bin3 = transpose3(dif.ss4.bin3);
dif.ss4.bin4 = transpose3(dif.ss4.bin4);
dif.ss4.bin12 = transpose3(dif.ss4.bin12);
dif.ss4.bin34 = transpose3(dif.ss4.bin34);

dif.ss8.bin1 = transpose3(dif.ss8.bin1);
dif.ss8.bin2 = transpose3(dif.ss8.bin2);
dif.ss8.bin3 = transpose3(dif.ss8.bin3);
dif.ss8.bin4 = transpose3(dif.ss8.bin4);
dif.ss8.bin12 = transpose3(dif.ss8.bin12);
dif.ss8.bin34 = transpose3(dif.ss8.bin34);



dif.all = squeeze(nanmean(dif.all(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin1 = squeeze(nanmean(dif.ss2.bin1(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin2 = squeeze(nanmean(dif.ss2.bin2(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin3 = squeeze(nanmean(dif.ss2.bin3(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin4 = squeeze(nanmean(dif.ss2.bin4(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin12 = squeeze(nanmean(dif.ss2.bin12(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss2.bin34 = squeeze(nanmean(dif.ss2.bin34(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));

dif.ss4.bin1 = squeeze(nanmean(dif.ss4.bin1(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin2 = squeeze(nanmean(dif.ss4.bin2(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin3 = squeeze(nanmean(dif.ss4.bin3(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin4 = squeeze(nanmean(dif.ss4.bin4(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin12 = squeeze(nanmean(dif.ss4.bin12(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss4.bin34 = squeeze(nanmean(dif.ss4.bin34(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));

dif.ss8.bin1 = squeeze(nanmean(dif.ss8.bin1(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin2 = squeeze(nanmean(dif.ss8.bin2(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin3 = squeeze(nanmean(dif.ss8.bin3(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin4 = squeeze(nanmean(dif.ss8.bin4(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin12 = squeeze(nanmean(dif.ss8.bin12(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
dif.ss8.bin34 = squeeze(nanmean(dif.ss8.bin34(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));




figure
hold on
plot(tout,nanmean(dif.ss2.bin1_bc,2),'b',tout,nanmean(dif.ss4.bin1_bc,2),'r',tout,nanmean(dif.ss8.bin1_bc,2),'g','linewidth',8)
plot(tout,nanmean(dif.ss2.bin2_bc,2),'b',tout,nanmean(dif.ss4.bin2_bc,2),'r',tout,nanmean(dif.ss8.bin2_bc,2),'g','linewidth',5)
plot(tout,nanmean(dif.ss2.bin3_bc,2),'b',tout,nanmean(dif.ss4.bin3_bc,2),'r',tout,nanmean(dif.ss8.bin3_bc,2),'g','linewidth',3)
plot(tout,nanmean(dif.ss2.bin4_bc,2),'b',tout,nanmean(dif.ss4.bin4_bc,2),'r',tout,nanmean(dif.ss8.bin4_bc,2),'g','linewidth',1)
xlim([-50 500])
hline(0,'k')
title('Baseline Corrected')

figure
hold on
plot(tout,nanmean(dif.ss2.bin1,2),'b',tout,nanmean(dif.ss4.bin1,2),'r',tout,nanmean(dif.ss8.bin1,2),'g','linewidth',8)
plot(tout,nanmean(dif.ss2.bin2,2),'b',tout,nanmean(dif.ss4.bin2,2),'r',tout,nanmean(dif.ss8.bin2,2),'g','linewidth',5)
plot(tout,nanmean(dif.ss2.bin3,2),'b',tout,nanmean(dif.ss4.bin3,2),'r',tout,nanmean(dif.ss8.bin3,2),'g','linewidth',3)
plot(tout,nanmean(dif.ss2.bin4,2),'b',tout,nanmean(dif.ss4.bin4,2),'r',tout,nanmean(dif.ss8.bin4,2),'g','linewidth',1)
xlim([-50 500])
hline(0,'k')
title('Not Baseline Corrected')

%calculate SEM
sem.ss2.bin12_bc = nanstd(dif.ss2.bin12_bc,1,2) / sqrt(sum(~isnan(dif.ss2.bin12_bc(1,:))));
sem.ss2.bin34_bc = nanstd(dif.ss2.bin34_bc,1,2) / sqrt(sum(~isnan(dif.ss2.bin34_bc(1,:))));
sem.ss4.bin12_bc = nanstd(dif.ss4.bin12_bc,1,2) / sqrt(sum(~isnan(dif.ss4.bin12_bc(1,:))));
sem.ss4.bin34_bc = nanstd(dif.ss4.bin34_bc,1,2) / sqrt(sum(~isnan(dif.ss4.bin34_bc(1,:))));
sem.ss8.bin12_bc = nanstd(dif.ss8.bin12_bc,1,2) / sqrt(sum(~isnan(dif.ss8.bin12_bc(1,:))));
sem.ss8.bin34_bc = nanstd(dif.ss8.bin34_bc,1,2) / sqrt(sum(~isnan(dif.ss8.bin34_bc(1,:))));

sempos.ss2.bin12_bc = nanmean(dif.ss2.bin12_bc,2) + sem.ss2.bin12_bc;
sempos.ss2.bin34_bc = nanmean(dif.ss2.bin34_bc,2) + sem.ss2.bin34_bc;
sempos.ss4.bin12_bc = nanmean(dif.ss4.bin12_bc,2) + sem.ss4.bin12_bc;
sempos.ss4.bin34_bc = nanmean(dif.ss4.bin34_bc,2) + sem.ss4.bin34_bc;
sempos.ss8.bin12_bc = nanmean(dif.ss8.bin12_bc,2) + sem.ss8.bin12_bc;
sempos.ss8.bin34_bc = nanmean(dif.ss8.bin34_bc,2) + sem.ss8.bin34_bc;

semneg.ss2.bin12_bc = nanmean(dif.ss2.bin12_bc,2) - sem.ss2.bin12_bc;
semneg.ss2.bin34_bc = nanmean(dif.ss2.bin34_bc,2) - sem.ss2.bin34_bc;
semneg.ss4.bin12_bc = nanmean(dif.ss4.bin12_bc,2) - sem.ss4.bin12_bc;
semneg.ss4.bin34_bc = nanmean(dif.ss4.bin34_bc,2) - sem.ss4.bin34_bc;
semneg.ss8.bin12_bc = nanmean(dif.ss8.bin12_bc,2) - sem.ss8.bin12_bc;
semneg.ss8.bin34_bc = nanmean(dif.ss8.bin34_bc,2) - sem.ss8.bin34_bc;


figure
hold on
plot(tout,nanmean(dif.ss2.bin12_bc,2),'b',tout,nanmean(dif.ss4.bin12_bc,2),'r',tout,nanmean(dif.ss8.bin12_bc,2),'g','linewidth',3)
plot(tout,nanmean(dif.ss2.bin34_bc,2),'b',tout,nanmean(dif.ss4.bin34_bc,2),'r',tout,nanmean(dif.ss8.bin34_bc,2),'g','linewidth',1)

plot(tout,sempos.ss2.bin12_bc,'--b',tout,sempos.ss4.bin12_bc,'--r',tout,sempos.ss8.bin12_bc,'--g','linewidth',3)
plot(tout,sempos.ss2.bin34_bc,'--b',tout,sempos.ss4.bin34_bc,'--r',tout,sempos.ss8.bin34_bc,'--g','linewidth',1)
plot(tout,semneg.ss2.bin12_bc,'--b',tout,semneg.ss4.bin12_bc,'--r',tout,semneg.ss8.bin12_bc,'--g','linewidth',3)
plot(tout,semneg.ss2.bin34_bc,'--b',tout,semneg.ss4.bin34_bc,'--r',tout,semneg.ss8.bin34_bc,'--g','linewidth',1)

xlim([-50 500])
hline(0,'k')
title('baseline corrected median split')