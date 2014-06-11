% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
% cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_SAT/nooverlap/DifferentElectrode
cd /Volumes/Dump2/Coherence/SPK-LFP/SAT/overlap/
file_list = dir('*.mat');


plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    tout_shuff = between_cond_shuff.all.wintimes;
    
    RTs.slow(sess,1) = RT.slow_correct_made_dead;
    RTs.med(sess,1) = RT.med_correct;
    RTs.fast(sess,1) = RT.fast_correct_made_dead;

    %MATLAB having trouble saving full 200 Hz-range 3-d matrices; therefore
    %going to split it into 0-100 and 101-200
    
    Pcoh_all.in.slow(1:281,1:104,sess) = Pcoh.in.slow;
    Pcoh_all.in.med(1:281,1:104,sess) = Pcoh.in.med;
    Pcoh_all.in.fast(1:281,1:104,sess) = Pcoh.in.fast;
    
    Pcoh_all.out.slow(1:281,1:104,sess) = Pcoh.out.slow;
    Pcoh_all.out.med(1:281,1:104,sess) = Pcoh.out.med;
    Pcoh_all.out.fast(1:281,1:104,sess) = Pcoh.out.fast;
    
    %========================
    shuff_all.in.slow(1:281,1:41,sess) = between_cond_shuff.all.TrType1.Pcoh;
    shuff_all.out.slow(1:281,1:41,sess) = between_cond_shuff.all.TrType2.Pcoh;
    shuff_all.in_v_out.slow.Pos(1:61,1:41,sess) = between_cond_shuff.all.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.slow.Neg(1:61,1:41,sess) = between_cond_shuff.all.Coh.Neg.SigClusAssign;
    
    %=========================
    
    
    n_all.in.slow(sess,1) = n.in.slow_correct_made_dead;
    n_all.in.med(sess,1) = n.in.med_correct;
    n_all.in.fast(sess,1) = n.in.fast_correct_made_dead;
    n_all.out.slow(sess,1) = n.out.slow_correct_made_dead;
    n_all.out.med(sess,1) = n.out.med_correct;
    n_all.out.fast(sess,1) = n.out.fast_correct_made_dead;
    
   
    
    
    TDT_all.LFP.slow(sess,1) = TDT.AD.slow_correct_made_dead;
    TDT_all.LFP.med(sess,1) = TDT.AD.med_correct;
    TDT_all.LFP.fast(sess,1) = TDT.AD.fast_correct_made_dead;
    TDT_all.SPK.slow(sess,1) = TDT.SPK.slow_correct_made_dead;
    TDT_all.SPK.med(sess,1) = TDT.SPK.med_correct;
    TDT_all.SPK.fast(sess,1) = TDT.SPK.fast_correct_made_dead;
    
    wf_all.LFP_bc.in.slow(sess,1:3001) = wf.sig1_bc.in.slow_correct_made_dead;
    wf_all.LFP_bc.in.med(sess,1:3001) = wf.sig1_bc.in.med_correct;
    wf_all.LFP_bc.in.fast(sess,1:3001) = wf.sig1_bc.in.fast_correct_made_dead;
    wf_all.LFP_bc.out.slow(sess,1:3001) = wf.sig1_bc.out.slow_correct_made_dead;
    wf_all.LFP_bc.out.med(sess,1:3001) = wf.sig1_bc.out.med_correct;
    wf_all.LFP_bc.out.fast(sess,1:3001) = wf.sig1_bc.out.fast_correct_made_dead;
    
    
    wf_all.LFP.in.slow(sess,1:3001) = wf.sig1.in.slow_correct_made_dead;
    wf_all.LFP.in.med(sess,1:3001) = wf.sig1.in.med_correct;
    wf_all.LFP.in.fast(sess,1:3001) = wf.sig1.in.fast_correct_made_dead;
    wf_all.LFP.out.slow(sess,1:3001) = wf.sig1.out.slow_correct_made_dead;
    wf_all.LFP.out.med(sess,1:3001) = wf.sig1.out.med_correct;
    wf_all.LFP.out.fast(sess,1:3001) = wf.sig1.out.fast_correct_made_dead;
    
    wf_all.SPK.in.slow(sess,1:3001) = wf.sig2.in.slow_correct_made_dead;
    wf_all.SPK.in.med(sess,1:3001) = wf.sig2.in.med_correct;
    wf_all.SPK.in.fast(sess,1:3001) = wf.sig2.in.fast_correct_made_dead;
    wf_all.SPK.out.slow(sess,1:3001) = wf.sig2.out.slow_correct_made_dead;
    wf_all.SPK.out.med(sess,1:3001) = wf.sig2.out.med_correct;
    wf_all.SPK.out.fast(sess,1:3001) = wf.sig2.out.fast_correct_made_dead;

   
    keep RTs tout tout_shuff f f_shuff  Pcoh_all shuff_all n TDT_all wf_all file_list sess plotFlag
    
end


% 
% if plotFlag == 1
%     
%     figure
%     subplot(2,2,1)
%     imagesc(tout,f,nanmean(abs(Pcoh_all.in),3)')
%     axis xy
%     xlim([-50 500])
%     colorbar
%     title('In')
%     z = get(gca,'clim');
%     
%     subplot(2,2,2)
%     imagesc(tout,f,nanmean(abs(Pcoh_all.out),3)')
%     axis xy
%     xlim([-50 500])
%     colorbar
%     title('Out')
%     set(gca,'clim',z)
%     
%     
%     
%     diff = nanmean(abs(Pcoh_all.in),3)' - nanmean(abs(Pcoh_all.out),3)';
%     
%     subplot(2,2,3)
%     imagesc(tout,f,diff)
%     axis xy
%     xlim([-50 500])
%     colorbar
%     title('Diff')
%     
%     subplot(2,2,4)
%     plot(-500:2500,nanmean(wf_all.sig1.in),'b',-500:2500,nanmean(wf_all.sig1.out),'--b')
%     axis ij
%     xlim([-50 500])
%     
%     newax
%     plot(-500:2500,nanmean(wf_all.sig2.in),'r',-500:2500,nanmean(wf_all.sig2.out),'--r')
%     %axis ij %sig1 is spikes: do not flip
%     xlim([-50 500])
%     
% end

clear plotFlag sess