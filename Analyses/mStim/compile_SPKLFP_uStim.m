%compile partial coherence poster analyses for SPK-LFP

%LFPLFP
cd /Volumes/Dump/Analyses/uStim/SPK-LFP/


file_list = dir('S*.mat');
plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    
    
    %=============
    % STIM
    Pcoh_all.in.all_sub.stim(1:281,1:104,sess) = nanmean(Pcoh.in.all_sub.stim,3);
    Pcoh_all.in.all.stim(1:281,1:104,sess) = Pcoh.in.all.stim;
    Pcoh_all.in.ss2.stim(1:281,1:104,sess) = Pcoh.in.ss2.stim;
    Pcoh_all.in.ss4.stim(1:281,1:104,sess) = Pcoh.in.ss4.stim;
    Pcoh_all.in.ss8.stim(1:281,1:104,sess) = Pcoh.in.ss8.stim;
    Pcoh_all.in.fast.stim(1:281,1:104,sess) = Pcoh.in.fast.stim;
    Pcoh_all.in.slow.stim(1:281,1:104,sess) = Pcoh.in.slow.stim;
    %Pcoh_all.in.err.stim(1:281,1:104,sess) = Pcoh.in.err.stim;
    
    Pcoh_all.out.all_sub.stim(1:281,1:104,sess) = nanmean(Pcoh.out.all_sub.stim,3);
    Pcoh_all.out.all.stim(1:281,1:104,sess) = Pcoh.out.all.stim;
    Pcoh_all.out.ss2.stim(1:281,1:104,sess) = Pcoh.out.ss2.stim;
    Pcoh_all.out.ss4.stim(1:281,1:104,sess) = Pcoh.out.ss4.stim;
    Pcoh_all.out.ss8.stim(1:281,1:104,sess) = Pcoh.out.ss8.stim;
    Pcoh_all.out.fast.stim(1:281,1:104,sess) = Pcoh.out.fast.stim;
    Pcoh_all.out.slow.stim(1:281,1:104,sess) = Pcoh.out.slow.stim;
    %Pcoh_all.out.err.stim(1:281,1:104,sess) = Pcoh.out.err.stim;
    
    
    
    TDT_all.sig1.all.stim(sess,1) = TDT.sig1.all.stim;
    TDT_all.sig1.ss2.stim(sess,1) = TDT.sig1.ss2.stim;
    TDT_all.sig1.ss4.stim(sess,1) = TDT.sig1.ss4.stim;
    TDT_all.sig1.ss8.stim(sess,1) = TDT.sig1.ss8.stim;
    TDT_all.sig1.fast.stim(sess,1) = TDT.sig1.fast.stim;
    TDT_all.sig1.slow.stim(sess,1) = TDT.sig1.slow.stim;
    %TDT_all.sig1.err.stim(sess,1) = TDT.sig1.err.stim;
    
    
    TDT_all.sig2.all.stim(sess,1) = TDT.sig2.all.stim;
    TDT_all.sig2.ss2.stim(sess,1) = TDT.sig2.ss2.stim;
    TDT_all.sig2.ss4.stim(sess,1) = TDT.sig2.ss4.stim;
    TDT_all.sig2.ss8.stim(sess,1) = TDT.sig2.ss8.stim;
    TDT_all.sig2.fast.stim(sess,1) = TDT.sig2.fast.stim;
    TDT_all.sig2.slow.stim(sess,1) = TDT.sig2.slow.stim;
   % TDT_all.sig2.err.stim(sess,1) = TDT.sig2.err.stim;
    
    PSx_noz_all.in.all.stim(1:281,1:104,sess) = PSx_noz.in.all.stim;
    PSx_noz_all.in.ss2.stim(1:281,1:104,sess) = PSx_noz.in.ss2.stim;
    PSx_noz_all.in.ss4.stim(1:281,1:104,sess) = PSx_noz.in.ss4.stim;
    PSx_noz_all.in.ss8.stim(1:281,1:104,sess) = PSx_noz.in.ss8.stim;
    PSx_noz_all.in.fast.stim(1:281,1:104,sess) = PSx_noz.in.fast.stim;
    PSx_noz_all.in.slow.stim(1:281,1:104,sess) = PSx_noz.in.slow.stim;
    %PSx_noz_all.in.err.stim(1:281,1:104,sess) = PSx_noz.in.err.stim;
    
    
    PSx_noz_all.out.all.stim(1:281,1:104,sess) = PSx_noz.out.all.stim;
    PSx_noz_all.out.ss2.stim(1:281,1:104,sess) = PSx_noz.out.ss2.stim;
    PSx_noz_all.out.ss4.stim(1:281,1:104,sess) = PSx_noz.out.ss4.stim;
    PSx_noz_all.out.ss8.stim(1:281,1:104,sess) = PSx_noz.out.ss8.stim;
    PSx_noz_all.out.fast.stim(1:281,1:104,sess) = PSx_noz.out.fast.stim;
    PSx_noz_all.out.slow.stim(1:281,1:104,sess) = PSx_noz.out.slow.stim;
    %PSx_noz_all.out.err.stim(1:281,1:104,sess) = PSx_noz.out.err.stim;
    
    
    PSy_noz_all.in.all.stim(1:281,1:104,sess) = PSy_noz.in.all.stim;
    PSy_noz_all.in.ss2.stim(1:281,1:104,sess) = PSy_noz.in.ss2.stim;
    PSy_noz_all.in.ss4.stim(1:281,1:104,sess) = PSy_noz.in.ss4.stim;
    PSy_noz_all.in.ss8.stim(1:281,1:104,sess) = PSy_noz.in.ss8.stim;
    PSy_noz_all.in.fast.stim(1:281,1:104,sess) = PSy_noz.in.fast.stim;
    PSy_noz_all.in.slow.stim(1:281,1:104,sess) = PSy_noz.in.slow.stim;
    %PSy_noz_all.in.err.stim(1:281,1:104,sess) = PSy_noz.in.err.stim;
    
    
    PSy_noz_all.out.all.stim(1:281,1:104,sess) = PSy_noz.out.all.stim;
    PSy_noz_all.out.ss2.stim(1:281,1:104,sess) = PSy_noz.out.ss2.stim;
    PSy_noz_all.out.ss4.stim(1:281,1:104,sess) = PSy_noz.out.ss4.stim;
    PSy_noz_all.out.ss8.stim(1:281,1:104,sess) = PSy_noz.out.ss8.stim;
    PSy_noz_all.out.fast.stim(1:281,1:104,sess) = PSy_noz.out.fast.stim;
    PSy_noz_all.out.slow.stim(1:281,1:104,sess) = PSy_noz.out.slow.stim;
    %PSy_noz_all.out.err.stim(1:281,1:104,sess) = PSy_noz.out.err.stim;
    
    
    
    
    wf_all.sig1.in.all.stim(sess,1:3001) = wf.sig1.in.all.stim;
    wf_all.sig1.in.ss2.stim(sess,1:3001) = wf.sig1.in.ss2.stim;
    wf_all.sig1.in.ss4.stim(sess,1:3001) = wf.sig1.in.ss4.stim;
    wf_all.sig1.in.ss8.stim(sess,1:3001) = wf.sig1.in.ss8.stim;
    wf_all.sig1.in.fast.stim(sess,1:3001) = wf.sig1.in.fast.stim;
    wf_all.sig1.in.slow.stim(sess,1:3001) = wf.sig1.in.slow.stim;
    wf_all.sig1.in.err.stim(sess,1:3001) = wf.sig1.in.err.stim;
    
    wf_all.sig1.out.all.stim(sess,1:3001) = wf.sig1.out.all.stim;
    wf_all.sig1.out.ss2.stim(sess,1:3001) = wf.sig1.out.ss2.stim;
    wf_all.sig1.out.ss4.stim(sess,1:3001) = wf.sig1.out.ss4.stim;
    wf_all.sig1.out.ss8.stim(sess,1:3001) = wf.sig1.out.ss8.stim;
    wf_all.sig1.out.fast.stim(sess,1:3001) = wf.sig1.out.fast.stim;
    wf_all.sig1.out.slow.stim(sess,1:3001) = wf.sig1.out.slow.stim;
    wf_all.sig1.out.err.stim(sess,1:3001) = wf.sig1.out.err.stim;
    
    
    
    wf_all.sig2.in.all.stim(sess,1:3001) = wf.sig2.in.all.stim;
    wf_all.sig2.in.ss2.stim(sess,1:3001) = wf.sig2.in.ss2.stim;
    wf_all.sig2.in.ss4.stim(sess,1:3001) = wf.sig2.in.ss4.stim;
    wf_all.sig2.in.ss8.stim(sess,1:3001) = wf.sig2.in.ss8.stim;
    wf_all.sig2.in.fast.stim(sess,1:3001) = wf.sig2.in.fast.stim;
    wf_all.sig2.in.slow.stim(sess,1:3001) = wf.sig2.in.slow.stim;
    wf_all.sig2.in.err.stim(sess,1:3001) = wf.sig2.in.err.stim;
    
    wf_all.sig2.out.all.stim(sess,1:3001) = wf.sig2.out.all.stim;
    wf_all.sig2.out.ss2.stim(sess,1:3001) = wf.sig2.out.ss2.stim;
    wf_all.sig2.out.ss4.stim(sess,1:3001) = wf.sig2.out.ss4.stim;
    wf_all.sig2.out.ss8.stim(sess,1:3001) = wf.sig2.out.ss8.stim;
    wf_all.sig2.out.fast.stim(sess,1:3001) = wf.sig2.out.fast.stim;
    wf_all.sig2.out.slow.stim(sess,1:3001) = wf.sig2.out.slow.stim;
    wf_all.sig2.out.err.stim(sess,1:3001) = wf.sig2.out.err.stim;
    
    
    
    %=============
    % NO STIM
    
    
    
    Pcoh_all.in.all_sub.nostim(1:281,1:104,sess) = nanmean(Pcoh.in.all_sub.nostim,3);
    Pcoh_all.in.all.nostim(1:281,1:104,sess) = Pcoh.in.all.nostim;
    Pcoh_all.in.ss2.nostim(1:281,1:104,sess) = Pcoh.in.ss2.nostim;
    Pcoh_all.in.ss4.nostim(1:281,1:104,sess) = Pcoh.in.ss4.nostim;
    Pcoh_all.in.ss8.nostim(1:281,1:104,sess) = Pcoh.in.ss8.nostim;
    Pcoh_all.in.fast.nostim(1:281,1:104,sess) = Pcoh.in.fast.nostim;
    Pcoh_all.in.slow.nostim(1:281,1:104,sess) = Pcoh.in.slow.nostim;
   % Pcoh_all.in.err.nostim(1:281,1:104,sess) = Pcoh.in.err.nostim;
    
    Pcoh_all.out.all_sub.nostim(1:281,1:104,sess) = nanmean(Pcoh.out.all_sub.nostim,3);
    Pcoh_all.out.all.nostim(1:281,1:104,sess) = Pcoh.out.all.nostim;
    Pcoh_all.out.ss2.nostim(1:281,1:104,sess) = Pcoh.out.ss2.nostim;
    Pcoh_all.out.ss4.nostim(1:281,1:104,sess) = Pcoh.out.ss4.nostim;
    Pcoh_all.out.ss8.nostim(1:281,1:104,sess) = Pcoh.out.ss8.nostim;
    Pcoh_all.out.fast.nostim(1:281,1:104,sess) = Pcoh.out.fast.nostim;
    Pcoh_all.out.slow.nostim(1:281,1:104,sess) = Pcoh.out.slow.nostim;
   % Pcoh_all.out.err.nostim(1:281,1:104,sess) = Pcoh.out.err.nostim;
    
    
    
    TDT_all.sig1.all.nostim(sess,1) = TDT.sig1.all.nostim;
    TDT_all.sig1.ss2.nostim(sess,1) = TDT.sig1.ss2.nostim;
    TDT_all.sig1.ss4.nostim(sess,1) = TDT.sig1.ss4.nostim;
    TDT_all.sig1.ss8.nostim(sess,1) = TDT.sig1.ss8.nostim;
    TDT_all.sig1.fast.nostim(sess,1) = TDT.sig1.fast.nostim;
    TDT_all.sig1.slow.nostim(sess,1) = TDT.sig1.slow.nostim;
   % TDT_all.sig1.err.nostim(sess,1) = TDT.sig1.err.nostim;
    
    
    TDT_all.sig2.all.nostim(sess,1) = TDT.sig2.all.nostim;
    TDT_all.sig2.ss2.nostim(sess,1) = TDT.sig2.ss2.nostim;
    TDT_all.sig2.ss4.nostim(sess,1) = TDT.sig2.ss4.nostim;
    TDT_all.sig2.ss8.nostim(sess,1) = TDT.sig2.ss8.nostim;
    TDT_all.sig2.fast.nostim(sess,1) = TDT.sig2.fast.nostim;
    TDT_all.sig2.slow.nostim(sess,1) = TDT.sig2.slow.nostim;
   % TDT_all.sig2.err.nostim(sess,1) = TDT.sig2.err.nostim;
    
    PSx_noz_all.in.all.nostim(1:281,1:104,sess) = PSx_noz.in.all.nostim;
    PSx_noz_all.in.ss2.nostim(1:281,1:104,sess) = PSx_noz.in.ss2.nostim;
    PSx_noz_all.in.ss4.nostim(1:281,1:104,sess) = PSx_noz.in.ss4.nostim;
    PSx_noz_all.in.ss8.nostim(1:281,1:104,sess) = PSx_noz.in.ss8.nostim;
    PSx_noz_all.in.fast.nostim(1:281,1:104,sess) = PSx_noz.in.fast.nostim;
    PSx_noz_all.in.slow.nostim(1:281,1:104,sess) = PSx_noz.in.slow.nostim;
   % PSx_noz_all.in.err.nostim(1:281,1:104,sess) = PSx_noz.in.err.nostim;
    
    
    PSx_noz_all.out.all.nostim(1:281,1:104,sess) = PSx_noz.out.all.nostim;
    PSx_noz_all.out.ss2.nostim(1:281,1:104,sess) = PSx_noz.out.ss2.nostim;
    PSx_noz_all.out.ss4.nostim(1:281,1:104,sess) = PSx_noz.out.ss4.nostim;
    PSx_noz_all.out.ss8.nostim(1:281,1:104,sess) = PSx_noz.out.ss8.nostim;
    PSx_noz_all.out.fast.nostim(1:281,1:104,sess) = PSx_noz.out.fast.nostim;
    PSx_noz_all.out.slow.nostim(1:281,1:104,sess) = PSx_noz.out.slow.nostim;
   % PSx_noz_all.out.err.nostim(1:281,1:104,sess) = PSx_noz.out.err.nostim;
    
    
    PSy_noz_all.in.all.nostim(1:281,1:104,sess) = PSy_noz.in.all.nostim;
    PSy_noz_all.in.ss2.nostim(1:281,1:104,sess) = PSy_noz.in.ss2.nostim;
    PSy_noz_all.in.ss4.nostim(1:281,1:104,sess) = PSy_noz.in.ss4.nostim;
    PSy_noz_all.in.ss8.nostim(1:281,1:104,sess) = PSy_noz.in.ss8.nostim;
    PSy_noz_all.in.fast.nostim(1:281,1:104,sess) = PSy_noz.in.fast.nostim;
    PSy_noz_all.in.slow.nostim(1:281,1:104,sess) = PSy_noz.in.slow.nostim;
   % PSy_noz_all.in.err.nostim(1:281,1:104,sess) = PSy_noz.in.err.nostim;
    
    
    PSy_noz_all.out.all.nostim(1:281,1:104,sess) = PSy_noz.out.all.nostim;
    PSy_noz_all.out.ss2.nostim(1:281,1:104,sess) = PSy_noz.out.ss2.nostim;
    PSy_noz_all.out.ss4.nostim(1:281,1:104,sess) = PSy_noz.out.ss4.nostim;
    PSy_noz_all.out.ss8.nostim(1:281,1:104,sess) = PSy_noz.out.ss8.nostim;
    PSy_noz_all.out.fast.nostim(1:281,1:104,sess) = PSy_noz.out.fast.nostim;
    PSy_noz_all.out.slow.nostim(1:281,1:104,sess) = PSy_noz.out.slow.nostim;
    %PSy_noz_all.out.err.nostim(1:281,1:104,sess) = PSy_noz.out.err.nostim;
    
    
    
    
    wf_all.sig1.in.all.nostim(sess,1:3001) = wf.sig1.in.all.nostim;
    wf_all.sig1.in.ss2.nostim(sess,1:3001) = wf.sig1.in.ss2.nostim;
    wf_all.sig1.in.ss4.nostim(sess,1:3001) = wf.sig1.in.ss4.nostim;
    wf_all.sig1.in.ss8.nostim(sess,1:3001) = wf.sig1.in.ss8.nostim;
    wf_all.sig1.in.fast.nostim(sess,1:3001) = wf.sig1.in.fast.nostim;
    wf_all.sig1.in.slow.nostim(sess,1:3001) = wf.sig1.in.slow.nostim;
    wf_all.sig1.in.err.nostim(sess,1:3001) = wf.sig1.in.err.nostim;
    
    wf_all.sig1.out.all.nostim(sess,1:3001) = wf.sig1.out.all.nostim;
    wf_all.sig1.out.ss2.nostim(sess,1:3001) = wf.sig1.out.ss2.nostim;
    wf_all.sig1.out.ss4.nostim(sess,1:3001) = wf.sig1.out.ss4.nostim;
    wf_all.sig1.out.ss8.nostim(sess,1:3001) = wf.sig1.out.ss8.nostim;
    wf_all.sig1.out.fast.nostim(sess,1:3001) = wf.sig1.out.fast.nostim;
    wf_all.sig1.out.slow.nostim(sess,1:3001) = wf.sig1.out.slow.nostim;
    wf_all.sig1.out.err.nostim(sess,1:3001) = wf.sig1.out.err.nostim;
    
    
    
    wf_all.sig2.in.all.nostim(sess,1:3001) = wf.sig2.in.all.nostim;
    wf_all.sig2.in.ss2.nostim(sess,1:3001) = wf.sig2.in.ss2.nostim;
    wf_all.sig2.in.ss4.nostim(sess,1:3001) = wf.sig2.in.ss4.nostim;
    wf_all.sig2.in.ss8.nostim(sess,1:3001) = wf.sig2.in.ss8.nostim;
    wf_all.sig2.in.fast.nostim(sess,1:3001) = wf.sig2.in.fast.nostim;
    wf_all.sig2.in.slow.nostim(sess,1:3001) = wf.sig2.in.slow.nostim;
    wf_all.sig2.in.err.nostim(sess,1:3001) = wf.sig2.in.err.nostim;
    
    wf_all.sig2.out.all.nostim(sess,1:3001) = wf.sig2.out.all.nostim;
    wf_all.sig2.out.ss2.nostim(sess,1:3001) = wf.sig2.out.ss2.nostim;
    wf_all.sig2.out.ss4.nostim(sess,1:3001) = wf.sig2.out.ss4.nostim;
    wf_all.sig2.out.ss8.nostim(sess,1:3001) = wf.sig2.out.ss8.nostim;
    wf_all.sig2.out.fast.nostim(sess,1:3001) = wf.sig2.out.fast.nostim;
    wf_all.sig2.out.slow.nostim(sess,1:3001) = wf.sig2.out.slow.nostim;
    wf_all.sig2.out.err.nostim(sess,1:3001) = wf.sig2.out.err.nostim;
    
    
    
    keep tout f Pcoh_all coh_all TDT_all Sx_all Sy_all ...
        PSx_all PSy_all Sx_noz_all Sy_noz_all PSx_noz_all PSy_noz_all ...
        wf_all file_list sess plotFlag
    
end

if plotFlag == 1
    
    figure
    subplot(2,2,1)
    imagesc(tout,f,nanmean(abs(Pcoh_all.in),3)')
    axis xy
    xlim([-50 500])
    colorbar
    title('In')
    z = get(gca,'clim');
    
    subplot(2,2,2)
    imagesc(tout,f,nanmean(abs(Pcoh_all.out),3)')
    axis xy
    xlim([-50 500])
    colorbar
    title('Out')
    set(gca,'clim',z)
    
    
    
    diff = nanmean(abs(Pcoh_all.in),3)' - nanmean(abs(Pcoh_all.out),3)';
    
    subplot(2,2,3)
    imagesc(tout,f,diff)
    axis xy
    xlim([-50 500])
    colorbar
    title('Diff')
    
    subplot(2,2,4)
    plot(-500:2500,nanmean(wf_all.sig1.in),'b',-500:2500,nanmean(wf_all.sig1.out),'--b')
    axis ij
    xlim([-50 500])
    
    newax
    plot(-500:2500,nanmean(wf_all.sig2.in),'r',-500:2500,nanmean(wf_all.sig2.out),'--r')
    %axis ij %sig1 is spikes: do not flip
    xlim([-50 500])
    
    
    %phase plots
    %-pi and +pi are equivalent, so averages across sessions can be
    %misleading.  to correct, average real and imagininary portions
    %separately, then take angle(imag*i + real)
    
    figure
    subplot(2,2,1)
    re.in = nanmean(real(Pcoh_all.in),3);
    im.in = nanmean(imag(Pcoh_all.in),3);
    
    imagesc(tout,f,angle(re.in+im.in*i)')
    axis xy
    xlim([-50 500])
    colorbar
    title('In')
    set(gca,'clim',[-pi pi]) %set to +/- pi
    
    subplot(2,2,2)
    re.out = nanmean(real(Pcoh_all.out),3);
    im.out = nanmean(imag(Pcoh_all.out),3);
    
    imagesc(tout,f,angle(re.out+im.out*i)')
    axis xy
    xlim([-50 500])
    colorbar
    title('Out')
    set(gca,'clim',[-pi pi])
    
    diff = angle(re.in+im.in*i)' - angle(re.out+im.out*i)';
    
    subplot(2,2,3)
    imagesc(tout,f,diff)
    axis xy
    xlim([-50 500])
    colorbar
    title('Diff')
    set(gca,'clim',[-pi pi])
    
    
    %power spectra (not z-transformed) %FOR SPIKES, NOT LOG POWER
    figure
    subplot(3,2,1)
    imagesc(tout,f,nanmean(PSx_noz_all.in,3)')
    axis xy
    xlim([-50 500])
    colorbar
    title('Sig1 In')
    
    subplot(3,2,2)
    imagesc(tout,f,nanmean(log10(PSy_noz_all.in),3)')
    axis xy
    xlim([-50 500])
    colorbar
    title('Sig2 In')
    
    subplot(3,2,3)
    imagesc(tout,f,nanmean(PSx_noz_all.out,3)')
    axis xy
    xlim([-50 500])
    colorbar
    title('Sig1 Out')
    
    subplot(3,2,4)
    imagesc(tout,f,nanmean(log10(PSy_noz_all.out),3)')
    axis xy
    xlim([-50 500])
    colorbar
    title('Sig2 Out')
    
    
    z1 = nanmean(PSx_noz_all.in,3)' - nanmean(PSx_noz_all.out,3)';
    z2 = nanmean(log10(PSy_noz_all.in),3)' - nanmean(log10(PSy_noz_all.out),3)';
    
    subplot(3,2,5)
    imagesc(tout,f,z1)
    axis xy
    xlim([-50 500])
    colorbar
    title('Sig1 in - out')
    
    subplot(3,2,6)
    imagesc(tout,f,z2)
    axis xy
    xlim([-50 500])
    colorbar
    title('Sig2 in - out')
    
end

clear plotFlag sess