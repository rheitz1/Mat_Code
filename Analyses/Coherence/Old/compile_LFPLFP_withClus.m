%compile partial coherence poster analyses for SPK-LFP

%LFPLFP
cd /Volumes/Dump2/Coherence/Uber/withClustering/LFP-LFP/
%cd ~/desktop/Poster/SPK-LFP/

file_list = dir('S*.mat');
plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)

    %note: smaller matrices because clustering resets padding to 1
    Pcoh_all.in.all(1:281,1:21,sess) = Pcoh.in.all;
    Pcoh_all.in.ss2(1:281,1:21,sess) = Pcoh.in.ss2;
    Pcoh_all.in.ss4(1:281,1:21,sess) = Pcoh.in.ss4;
    Pcoh_all.in.ss8(1:281,1:21,sess) = Pcoh.in.ss8;
    Pcoh_all.in.fast(1:281,1:21,sess) = Pcoh.in.fast;
    Pcoh_all.in.slow(1:281,1:21,sess) = Pcoh.in.slow;
    Pcoh_all.in.err(1:281,1:21,sess) = Pcoh.in.err;
    
    
    Pcoh_all.out.all(1:281,1:21,sess) = Pcoh.out.all;
    Pcoh_all.out.ss2(1:281,1:21,sess) = Pcoh.out.ss2;
    Pcoh_all.out.ss4(1:281,1:21,sess) = Pcoh.out.ss4;
    Pcoh_all.out.ss8(1:281,1:21,sess) = Pcoh.out.ss8;
    Pcoh_all.out.fast(1:281,1:21,sess) = Pcoh.out.fast;
    Pcoh_all.out.slow(1:281,1:21,sess) = Pcoh.out.slow;
    Pcoh_all.out.err(1:281,1:21,sess) = Pcoh.out.err;
    
 
    
    
    TDT_all.sig1.all(sess,1) = TDT.sig1.all;
    TDT_all.sig1.ss2(sess,1) = TDT.sig1.ss2;
    TDT_all.sig1.ss4(sess,1) = TDT.sig1.ss4;
    TDT_all.sig1.ss8(sess,1) = TDT.sig1.ss8;
    TDT_all.sig1.fast(sess,1) = TDT.sig1.fast;
    TDT_all.sig1.slow(sess,1) = TDT.sig1.slow;
    TDT_all.sig1.err(sess,1) = TDT.sig1.err;
    
    
    TDT_all.sig2.all(sess,1) = TDT.sig2.all;
    TDT_all.sig2.ss2(sess,1) = TDT.sig2.ss2;
    TDT_all.sig2.ss4(sess,1) = TDT.sig2.ss4;
    TDT_all.sig2.ss8(sess,1) = TDT.sig2.ss8;
    TDT_all.sig2.fast(sess,1) = TDT.sig2.fast;
    TDT_all.sig2.slow(sess,1) = TDT.sig2.slow;
    TDT_all.sig2.err(sess,1) = TDT.sig2.err;
    
    PSx_noz_all.in.all(1:281,1:104,sess) = PSx_noz.in.all;
    PSx_noz_all.in.ss2(1:281,1:104,sess) = PSx_noz.in.ss2;
    PSx_noz_all.in.ss4(1:281,1:104,sess) = PSx_noz.in.ss4;
    PSx_noz_all.in.ss8(1:281,1:104,sess) = PSx_noz.in.ss8;
    PSx_noz_all.in.fast(1:281,1:104,sess) = PSx_noz.in.fast;
    PSx_noz_all.in.slow(1:281,1:104,sess) = PSx_noz.in.slow;
    PSx_noz_all.in.err(1:281,1:104,sess) = PSx_noz.in.err;
    
    
    PSx_noz_all.out.all(1:281,1:104,sess) = PSx_noz.out.all;
    PSx_noz_all.out.ss2(1:281,1:104,sess) = PSx_noz.out.ss2;
    PSx_noz_all.out.ss4(1:281,1:104,sess) = PSx_noz.out.ss4;
    PSx_noz_all.out.ss8(1:281,1:104,sess) = PSx_noz.out.ss8;
    PSx_noz_all.out.fast(1:281,1:104,sess) = PSx_noz.out.fast;
    PSx_noz_all.out.slow(1:281,1:104,sess) = PSx_noz.out.slow;
    PSx_noz_all.out.err(1:281,1:104,sess) = PSx_noz.out.err;
    
    
    PSy_noz_all.in.all(1:281,1:104,sess) = PSy_noz.in.all;
    PSy_noz_all.in.ss2(1:281,1:104,sess) = PSy_noz.in.ss2;
    PSy_noz_all.in.ss4(1:281,1:104,sess) = PSy_noz.in.ss4;
    PSy_noz_all.in.ss8(1:281,1:104,sess) = PSy_noz.in.ss8;
    PSy_noz_all.in.fast(1:281,1:104,sess) = PSy_noz.in.fast;
    PSy_noz_all.in.slow(1:281,1:104,sess) = PSy_noz.in.slow;
    PSy_noz_all.in.err(1:281,1:104,sess) = PSy_noz.in.err;
    
    
    PSy_noz_all.out.all(1:281,1:104,sess) = PSy_noz.out.all;
    PSy_noz_all.out.ss2(1:281,1:104,sess) = PSy_noz.out.ss2;
    PSy_noz_all.out.ss4(1:281,1:104,sess) = PSy_noz.out.ss4;
    PSy_noz_all.out.ss8(1:281,1:104,sess) = PSy_noz.out.ss8;
    PSy_noz_all.out.fast(1:281,1:104,sess) = PSy_noz.out.fast;
    PSy_noz_all.out.slow(1:281,1:104,sess) = PSy_noz.out.slow;
    PSy_noz_all.out.err(1:281,1:104,sess) = PSy_noz.out.err;
    
    err_all.wintimes = err.in.all.wintimes;
    err_all.in.all.PosClus(1:61,1:21,sess) = err.in.all.Coh.Pos.SigClusAssign;
    err_all.in.ss2.PosClus(1:61,1:21,sess) = err.in.ss2.Coh.Pos.SigClusAssign;
    err_all.in.ss4.PosClus(1:61,1:21,sess) = err.in.ss4.Coh.Pos.SigClusAssign;
    err_all.in.ss8.PosClus(1:61,1:21,sess) = err.in.ss8.Coh.Pos.SigClusAssign;
    err_all.in.fast.PosClus(1:61,1:21,sess) = err.in.fast.Coh.Pos.SigClusAssign;
    err_all.in.slow.PosClus(1:61,1:21,sess) = err.in.slow.Coh.Pos.SigClusAssign;
    err_all.in.err.PosClus(1:61,1:21,sess) = err.in.err.Coh.Pos.SigClusAssign;
    err_all.out.all.PosClus(1:61,1:21,sess) = err.out.all.Coh.Pos.SigClusAssign;
    err_all.out.ss2.PosClus(1:61,1:21,sess) = err.out.ss2.Coh.Pos.SigClusAssign;
    err_all.out.ss4.PosClus(1:61,1:21,sess) = err.out.ss4.Coh.Pos.SigClusAssign;
    err_all.out.ss8.PosClus(1:61,1:21,sess) = err.out.ss8.Coh.Pos.SigClusAssign;
    err_all.out.fast.PosClus(1:61,1:21,sess) = err.out.fast.Coh.Pos.SigClusAssign;
    err_all.out.slow.PosClus(1:61,1:21,sess) = err.out.slow.Coh.Pos.SigClusAssign;
    err_all.out.err.PosClus(1:61,1:21,sess) = err.out.err.Coh.Pos.SigClusAssign;
    
    err_all.in.all.NegClus(1:61,1:21,sess) = err.in.all.Coh.Neg.SigClusAssign;
    err_all.in.ss2.NegClus(1:61,1:21,sess) = err.in.ss2.Coh.Neg.SigClusAssign;
    err_all.in.ss4.NegClus(1:61,1:21,sess) = err.in.ss4.Coh.Neg.SigClusAssign;
    err_all.in.ss8.NegClus(1:61,1:21,sess) = err.in.ss8.Coh.Neg.SigClusAssign;
    err_all.in.fast.NegClus(1:61,1:21,sess) = err.in.fast.Coh.Neg.SigClusAssign;
    err_all.in.slow.NegClus(1:61,1:21,sess) = err.in.slow.Coh.Neg.SigClusAssign;
    err_all.in.err.NegClus(1:61,1:21,sess) = err.in.err.Coh.Neg.SigClusAssign;
    err_all.out.all.NegClus(1:61,1:21,sess) = err.out.all.Coh.Neg.SigClusAssign;
    err_all.out.ss2.NegClus(1:61,1:21,sess) = err.out.ss2.Coh.Neg.SigClusAssign;
    err_all.out.ss4.NegClus(1:61,1:21,sess) = err.out.ss4.Coh.Neg.SigClusAssign;
    err_all.out.ss8.NegClus(1:61,1:21,sess) = err.out.ss8.Coh.Neg.SigClusAssign;
    err_all.out.fast.NegClus(1:61,1:21,sess) = err.out.fast.Coh.Neg.SigClusAssign;
    err_all.out.slow.NegClus(1:61,1:21,sess) = err.out.slow.Coh.Neg.SigClusAssign;
    err_all.out.err.NegClus(1:61,1:21,sess) = err.out.err.Coh.Neg.SigClusAssign;

    
    
    wf_all.sig1.in.all(sess,1:3001) = wf.sig1.in.all;
    wf_all.sig1.in.ss2(sess,1:3001) = wf.sig1.in.ss2;
    wf_all.sig1.in.ss4(sess,1:3001) = wf.sig1.in.ss4;
    wf_all.sig1.in.ss8(sess,1:3001) = wf.sig1.in.ss8;
    wf_all.sig1.in.fast(sess,1:3001) = wf.sig1.in.fast;
    wf_all.sig1.in.slow(sess,1:3001) = wf.sig1.in.slow;
    wf_all.sig1.in.err(sess,1:3001) = wf.sig1.in.err;
    
    wf_all.sig1.out.all(sess,1:3001) = wf.sig1.out.all;
    wf_all.sig1.out.ss2(sess,1:3001) = wf.sig1.out.ss2;
    wf_all.sig1.out.ss4(sess,1:3001) = wf.sig1.out.ss4;
    wf_all.sig1.out.ss8(sess,1:3001) = wf.sig1.out.ss8;
    wf_all.sig1.out.fast(sess,1:3001) = wf.sig1.out.fast;
    wf_all.sig1.out.slow(sess,1:3001) = wf.sig1.out.slow;
    wf_all.sig1.out.err(sess,1:3001) = wf.sig1.out.err;
    
    
    
    wf_all.sig2.in.all(sess,1:3001) = wf.sig2.in.all;
    wf_all.sig2.in.ss2(sess,1:3001) = wf.sig2.in.ss2;
    wf_all.sig2.in.ss4(sess,1:3001) = wf.sig2.in.ss4;
    wf_all.sig2.in.ss8(sess,1:3001) = wf.sig2.in.ss8;
    wf_all.sig2.in.fast(sess,1:3001) = wf.sig2.in.fast;
    wf_all.sig2.in.slow(sess,1:3001) = wf.sig2.in.slow;
    wf_all.sig2.in.err(sess,1:3001) = wf.sig2.in.err;
    
    wf_all.sig2.out.all(sess,1:3001) = wf.sig2.out.all;
    wf_all.sig2.out.ss2(sess,1:3001) = wf.sig2.out.ss2;
    wf_all.sig2.out.ss4(sess,1:3001) = wf.sig2.out.ss4;
    wf_all.sig2.out.ss8(sess,1:3001) = wf.sig2.out.ss8;
    wf_all.sig2.out.fast(sess,1:3001) = wf.sig2.out.fast;
    wf_all.sig2.out.slow(sess,1:3001) = wf.sig2.out.slow;
    wf_all.sig2.out.err(sess,1:3001) = wf.sig2.out.err;
    
    
    keep err_all tout f Pcoh_all coh_all TDT_all Sx_all Sy_all ...
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