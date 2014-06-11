% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
cd /volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_shuff_MG/overlap/SameElectrode/

file_list = dir('*.mat');
plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    if exist('tout_shuff') == 0
        tout_shuff = between_cond_shuff.all.wintimes;
    end
    
    Pcoh_all.in.all(1:281,1:104,sess) = Pcoh.in.all;
    Pcoh_all.in.fast(1:281,1:104,sess) = Pcoh.in.fast;
    Pcoh_all.in.slow(1:281,1:104,sess) = Pcoh.in.slow;
    
    
    Pcoh_all.out.all(1:281,1:104,sess) = Pcoh.out.all;
    Pcoh_all.out.fast(1:281,1:104,sess) = Pcoh.out.fast;
    Pcoh_all.out.slow(1:281,1:104,sess) = Pcoh.out.slow;
    
    
    %========================
    shuff_all.in.all.Pcoh(1:281,1:21,sess) = between_cond_shuff.all.TrType1.Pcoh;
    shuff_all.out.all.Pcoh(1:281,1:21,sess) = between_cond_shuff.all.TrType2.Pcoh;
    shuff_all.in_v_out.all.Pos(1:61,1:21,sess) = between_cond_shuff.all.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.all.Neg(1:61,1:21,sess) = between_cond_shuff.all.Coh.Neg.SigClusAssign;
    %shuff_all.in_v_out.all.Pos_TFCens(1:size(between_cond_shuff.all.Coh.Pos.SigClusTFCens,1),1:size(between_cond_shuff.all.Coh.Pos.SigClusTFCens,2),sess) = between_cond_shuff.all.Coh.Pos.SigClusTFCens;
    %shuff_all.in_v_out.all.Neg_TFCens(1:size(between_cond_shuff.all.Coh.Neg.SigClusTFCens,1),1:size(between_cond_shuff.all.Coh.Neg.SigClusTFCens,2),sess) = between_cond_shuff.all.Coh.Neg.SigClusTFCens;
    
    %shuff_all.base_v_act.in.all.Pos(1:61,1:21,sess) = within_cond_shuff.in.all.Coh.Pos.SigClusAssign;
    %shuff_all.base_v_act.in.all.Neg(1:61,1:21,sess) = within_cond_shuff.in.all.Coh.Neg.SigClusAssign;
    %shuff_all.base_v_act.out.all.Pos(1:61,1:21,sess) = within_cond_shuff.out.all.Coh.Pos.SigClusAssign;
    %shuff_all.base_v_act.out.all.Neg(1:61,1:21,sess) = within_cond_shuff.out.all.Coh.Neg.SigClusAssign;
    
    %shuff_all.base_v_act.in.all.Pos_TFCens(1:size(within_cond_shuff.in.all.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.in.all.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.in.all.Coh.Pos.SigClusTFCens;
    %shuff_all.base_v_act.in.all.Neg_TFCens(1:size(within_cond_shuff.in.all.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.in.all.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.in.all.Coh.Neg.SigClusTFCens;
    %shuff_all.base_v_act.out.all.Pos_TFCens(1:size(within_cond_shuff.out.all.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.out.all.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.out.all.Coh.Pos.SigClusTFCens;
    %shuff_all.base_v_act.out.all.Neg_TFCens(1:size(within_cond_shuff.out.all.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.out.all.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.out.all.Coh.Neg.SigClusTFCens;
    %=========================
    
    RT_all.all(sess,1) = RT.all;
    RT_all.fast(sess,1) = RT.fast;
    RT_all.slow(sess,1) = RT.slow;
    
    keep tout_shuff shuff_all tout f RT_all Pcoh_all file_list sess plotFlag
    
    
    
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