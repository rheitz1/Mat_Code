% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
cd /volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_shuff_allTL_corrected_widetapers/overlap/SameElectrode/

file_list = dir('*.mat');
plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    tout_shuff = between_cond_shuff.all.wintimes;
    
    Pcoh_all.in.all_sub(1:251,1:206,sess) = Pcoh.in.all_sub;
    Pcoh_all.in.all(1:251,1:206,sess) = Pcoh.in.all;
    Pcoh_all.in.ss2(1:251,1:206,sess) = Pcoh.in.ss2;
    Pcoh_all.in.ss4(1:251,1:206,sess) = Pcoh.in.ss4;
    Pcoh_all.in.ss8(1:251,1:206,sess) = Pcoh.in.ss8;
    Pcoh_all.in.fast(1:251,1:206,sess) = Pcoh.in.fast;
    Pcoh_all.in.slow(1:251,1:206,sess) = Pcoh.in.slow;
    Pcoh_all.in.err(1:251,1:206,sess) = Pcoh.in.err;
    
    Pcoh_all.out.all_sub(1:251,1:206,sess) = Pcoh.out.all_sub;
    Pcoh_all.out.all(1:251,1:206,sess) = Pcoh.out.all;
    Pcoh_all.out.ss2(1:251,1:206,sess) = Pcoh.out.ss2;
    Pcoh_all.out.ss4(1:251,1:206,sess) = Pcoh.out.ss4;
    Pcoh_all.out.ss8(1:251,1:206,sess) = Pcoh.out.ss8;
    Pcoh_all.out.fast(1:251,1:206,sess) = Pcoh.out.fast;
    Pcoh_all.out.slow(1:251,1:206,sess) = Pcoh.out.slow;
    Pcoh_all.out.err(1:251,1:206,sess) = Pcoh.out.err;
    
    
    %========================
    shuff_all.in.all.Pcoh(1:251,1:51,sess) = between_cond_shuff.all.TrType1.Pcoh;
    shuff_all.out.all.Pcoh(1:251,1:51,sess) = between_cond_shuff.all.TrType2.Pcoh;
    shuff_all.in_v_out.all.Pos(1:31,1:51,sess) = between_cond_shuff.all.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.all.Neg(1:31,1:51,sess) = between_cond_shuff.all.Coh.Neg.SigClusAssign;
    shuff_all.in_v_out.all.Pos_TFCens(1:size(between_cond_shuff.all.Coh.Pos.SigClusTFCens,1),1:size(between_cond_shuff.all.Coh.Pos.SigClusTFCens,2),sess) = between_cond_shuff.all.Coh.Pos.SigClusTFCens;
    shuff_all.in_v_out.all.Neg_TFCens(1:size(between_cond_shuff.all.Coh.Neg.SigClusTFCens,1),1:size(between_cond_shuff.all.Coh.Neg.SigClusTFCens,2),sess) = between_cond_shuff.all.Coh.Neg.SigClusTFCens;
%     
%     shuff_all.base_v_act.in.all.Pos(1:31,1:51,sess) = within_cond_shuff.in.all.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.in.all.Neg(1:31,1:51,sess) = within_cond_shuff.in.all.Coh.Neg.SigClusAssign;
%     shuff_all.base_v_act.out.all.Pos(1:31,1:51,sess) = within_cond_shuff.out.all.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.out.all.Neg(1:31,1:51,sess) = within_cond_shuff.out.all.Coh.Neg.SigClusAssign;
%     
%     shuff_all.base_v_act.in.all.Pos_TFCens(1:size(within_cond_shuff.in.all.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.in.all.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.in.all.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.in.all.Neg_TFCens(1:size(within_cond_shuff.in.all.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.in.all.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.in.all.Coh.Neg.SigClusTFCens;
%     shuff_all.base_v_act.out.all.Pos_TFCens(1:size(within_cond_shuff.out.all.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.out.all.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.out.all.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.out.all.Neg_TFCens(1:size(within_cond_shuff.out.all.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.out.all.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.out.all.Coh.Neg.SigClusTFCens;
    %=========================
    
    
    
    
    %=========================
    shuff_all.in.ss2.Pcoh(1:251,1:51,sess) = between_cond_shuff.ss2.TrType1.Pcoh;
    shuff_all.out.ss2.Pcoh(1:251,1:51,sess) = between_cond_shuff.ss2.TrType2.Pcoh;
    shuff_all.in_v_out.ss2.Pos(1:31,1:51,sess) = between_cond_shuff.ss2.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.ss2.Neg(1:31,1:51,sess) = between_cond_shuff.ss2.Coh.Neg.SigClusAssign;
    shuff_all.in_v_out.ss2.Pos_TFCens(1:size(between_cond_shuff.ss2.Coh.Pos.SigClusTFCens,1),1:size(between_cond_shuff.ss2.Coh.Pos.SigClusTFCens,2),sess) = between_cond_shuff.ss2.Coh.Pos.SigClusTFCens;
    shuff_all.in_v_out.ss2.Neg_TFCens(1:size(between_cond_shuff.ss2.Coh.Neg.SigClusTFCens,1),1:size(between_cond_shuff.ss2.Coh.Neg.SigClusTFCens,2),sess) = between_cond_shuff.ss2.Coh.Neg.SigClusTFCens;
%     
%     shuff_all.base_v_act.in.ss2.Pos(1:31,1:51,sess) = within_cond_shuff.in.ss2.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.in.ss2.Neg(1:31,1:51,sess) = within_cond_shuff.in.ss2.Coh.Neg.SigClusAssign;
%     shuff_all.base_v_act.out.ss2.Pos(1:31,1:51,sess) = within_cond_shuff.out.ss2.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.out.ss2.Neg(1:31,1:51,sess) = within_cond_shuff.out.ss2.Coh.Neg.SigClusAssign;
%     
%     shuff_all.base_v_act.in.ss2.Pos_TFCens(1:size(within_cond_shuff.in.ss2.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.in.ss2.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.in.ss2.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.in.ss2.Neg_TFCens(1:size(within_cond_shuff.in.ss2.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.in.ss2.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.in.ss2.Coh.Neg.SigClusTFCens;
%     shuff_all.base_v_act.out.ss2.Pos_TFCens(1:size(within_cond_shuff.out.ss2.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.out.ss2.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.out.ss2.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.out.ss2.Neg_TFCens(1:size(within_cond_shuff.out.ss2.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.out.ss2.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.out.ss2.Coh.Neg.SigClusTFCens;
    %==========================
    
    
    %==========================
    shuff_all.in.ss4.Pcoh(1:251,1:51,sess) = between_cond_shuff.ss4.TrType1.Pcoh;
    shuff_all.out.ss4.Pcoh(1:251,1:51,sess) = between_cond_shuff.ss4.TrType2.Pcoh;
    shuff_all.in_v_out.ss4.Pos(1:31,1:51,sess) = between_cond_shuff.ss4.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.ss4.Neg(1:31,1:51,sess) = between_cond_shuff.ss4.Coh.Neg.SigClusAssign;
    shuff_all.in_v_out.ss4.Pos_TFCens(1:size(between_cond_shuff.ss4.Coh.Pos.SigClusTFCens,1),1:size(between_cond_shuff.ss4.Coh.Pos.SigClusTFCens,2),sess) = between_cond_shuff.ss4.Coh.Pos.SigClusTFCens;
    shuff_all.in_v_out.ss4.Neg_TFCens(1:size(between_cond_shuff.ss4.Coh.Neg.SigClusTFCens,1),1:size(between_cond_shuff.ss4.Coh.Neg.SigClusTFCens,2),sess) = between_cond_shuff.ss4.Coh.Neg.SigClusTFCens;
%     
%     shuff_all.base_v_act.in.ss4.Pos(1:31,1:51,sess) = within_cond_shuff.in.ss4.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.in.ss4.Neg(1:31,1:51,sess) = within_cond_shuff.in.ss4.Coh.Neg.SigClusAssign;
%     shuff_all.base_v_act.out.ss4.Pos(1:31,1:51,sess) = within_cond_shuff.out.ss4.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.out.ss4.Neg(1:31,1:51,sess) = within_cond_shuff.out.ss4.Coh.Neg.SigClusAssign;
%     
%     shuff_all.base_v_act.in.ss4.Pos_TFCens(1:size(within_cond_shuff.in.ss4.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.in.ss4.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.in.ss4.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.in.ss4.Neg_TFCens(1:size(within_cond_shuff.in.ss4.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.in.ss4.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.in.ss4.Coh.Neg.SigClusTFCens;
%     shuff_all.base_v_act.out.ss4.Pos_TFCens(1:size(within_cond_shuff.out.ss4.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.out.ss4.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.out.ss4.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.out.ss4.Neg_TFCens(1:size(within_cond_shuff.out.ss4.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.out.ss4.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.out.ss4.Coh.Neg.SigClusTFCens;
    %===========================
    
    
    %===========================
    shuff_all.in.ss8.Pcoh(1:251,1:51,sess) = between_cond_shuff.ss8.TrType1.Pcoh;
    shuff_all.out.ss8.Pcoh(1:251,1:51,sess) = between_cond_shuff.ss8.TrType2.Pcoh;
    shuff_all.in_v_out.ss8.Pos(1:31,1:51,sess) = between_cond_shuff.ss8.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.ss8.Neg(1:31,1:51,sess) = between_cond_shuff.ss8.Coh.Neg.SigClusAssign;
    shuff_all.in_v_out.ss8.Pos_TFCens(1:size(between_cond_shuff.ss8.Coh.Pos.SigClusTFCens,1),1:size(between_cond_shuff.ss8.Coh.Pos.SigClusTFCens,2),sess) = between_cond_shuff.ss8.Coh.Pos.SigClusTFCens;
    shuff_all.in_v_out.ss8.Neg_TFCens(1:size(between_cond_shuff.ss8.Coh.Neg.SigClusTFCens,1),1:size(between_cond_shuff.ss8.Coh.Neg.SigClusTFCens,2),sess) = between_cond_shuff.ss8.Coh.Neg.SigClusTFCens;
    
%     
%     shuff_all.base_v_act.in.ss8.Pos(1:31,1:51,sess) = within_cond_shuff.in.ss8.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.in.ss8.Neg(1:31,1:51,sess) = within_cond_shuff.in.ss8.Coh.Neg.SigClusAssign;
%     shuff_all.base_v_act.out.ss8.Pos(1:31,1:51,sess) = within_cond_shuff.out.ss8.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.out.ss8.Neg(1:31,1:51,sess) = within_cond_shuff.out.ss8.Coh.Neg.SigClusAssign;
%     
%     shuff_all.base_v_act.in.ss8.Pos_TFCens(1:size(within_cond_shuff.in.ss8.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.in.ss8.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.in.ss8.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.in.ss8.Neg_TFCens(1:size(within_cond_shuff.in.ss8.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.in.ss8.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.in.ss8.Coh.Neg.SigClusTFCens;
%     shuff_all.base_v_act.out.ss8.Pos_TFCens(1:size(within_cond_shuff.out.ss8.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.out.ss8.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.out.ss8.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.out.ss8.Neg_TFCens(1:size(within_cond_shuff.out.ss8.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.out.ss8.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.out.ss8.Coh.Neg.SigClusTFCens;
    %===========================
    
    
    %===========================
    shuff_all.in.fast.Pcoh(1:251,1:51,sess) = between_cond_shuff.fast.TrType1.Pcoh;
    shuff_all.out.fast.Pcoh(1:251,1:51,sess) = between_cond_shuff.fast.TrType2.Pcoh;
    shuff_all.in_v_out.fast.Pos(1:31,1:51,sess) = between_cond_shuff.fast.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.fast.Neg(1:31,1:51,sess) = between_cond_shuff.fast.Coh.Neg.SigClusAssign;
    shuff_all.in_v_out.fast.Pos_TFCens(1:size(between_cond_shuff.fast.Coh.Pos.SigClusTFCens,1),1:size(between_cond_shuff.fast.Coh.Pos.SigClusTFCens,2),sess) = between_cond_shuff.fast.Coh.Pos.SigClusTFCens;
    shuff_all.in_v_out.fast.Neg_TFCens(1:size(between_cond_shuff.fast.Coh.Neg.SigClusTFCens,1),1:size(between_cond_shuff.fast.Coh.Neg.SigClusTFCens,2),sess) = between_cond_shuff.fast.Coh.Neg.SigClusTFCens;
    
    
    
%     shuff_all.base_v_act.in.fast.Pos(1:31,1:51,sess) = within_cond_shuff.in.fast.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.in.fast.Neg(1:31,1:51,sess) = within_cond_shuff.in.fast.Coh.Neg.SigClusAssign;
%     shuff_all.base_v_act.out.fast.Pos(1:31,1:51,sess) = within_cond_shuff.out.fast.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.out.fast.Neg(1:31,1:51,sess) = within_cond_shuff.out.fast.Coh.Neg.SigClusAssign;
%     
%     shuff_all.base_v_act.in.fast.Pos_TFCens(1:size(within_cond_shuff.in.fast.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.in.fast.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.in.fast.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.in.fast.Neg_TFCens(1:size(within_cond_shuff.in.fast.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.in.fast.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.in.fast.Coh.Neg.SigClusTFCens;
%     shuff_all.base_v_act.out.fast.Pos_TFCens(1:size(within_cond_shuff.out.fast.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.out.fast.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.out.fast.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.out.fast.Neg_TFCens(1:size(within_cond_shuff.out.fast.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.out.fast.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.out.fast.Coh.Neg.SigClusTFCens;
    %===========================
    
    
    
    %===========================
    shuff_all.in.slow.Pcoh(1:251,1:51,sess) = between_cond_shuff.slow.TrType1.Pcoh;
    shuff_all.out.slow.Pcoh(1:251,1:51,sess) = between_cond_shuff.slow.TrType2.Pcoh;
    shuff_all.in_v_out.slow.Pos(1:31,1:51,sess) = between_cond_shuff.slow.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.slow.Neg(1:31,1:51,sess) = between_cond_shuff.slow.Coh.Neg.SigClusAssign;
    shuff_all.in_v_out.slow.Pos_TFCens(1:size(between_cond_shuff.slow.Coh.Pos.SigClusTFCens,1),1:size(between_cond_shuff.slow.Coh.Pos.SigClusTFCens,2),sess) = between_cond_shuff.slow.Coh.Pos.SigClusTFCens;
    shuff_all.in_v_out.slow.Neg_TFCens(1:size(between_cond_shuff.slow.Coh.Neg.SigClusTFCens,1),1:size(between_cond_shuff.slow.Coh.Neg.SigClusTFCens,2),sess) = between_cond_shuff.slow.Coh.Neg.SigClusTFCens;
    
%     shuff_all.base_v_act.in.slow.Pos(1:31,1:51,sess) = within_cond_shuff.in.slow.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.in.slow.Neg(1:31,1:51,sess) = within_cond_shuff.in.slow.Coh.Neg.SigClusAssign;
%     shuff_all.base_v_act.out.slow.Pos(1:31,1:51,sess) = within_cond_shuff.out.slow.Coh.Pos.SigClusAssign;
%     shuff_all.base_v_act.out.slow.Neg(1:31,1:51,sess) = within_cond_shuff.out.slow.Coh.Neg.SigClusAssign;
%     
%     shuff_all.base_v_act.in.slow.Pos_TFCens(1:size(within_cond_shuff.in.slow.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.in.slow.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.in.slow.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.in.slow.Neg_TFCens(1:size(within_cond_shuff.in.slow.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.in.slow.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.in.slow.Coh.Neg.SigClusTFCens;
%     shuff_all.base_v_act.out.slow.Pos_TFCens(1:size(within_cond_shuff.out.slow.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.out.slow.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.out.slow.Coh.Pos.SigClusTFCens;
%     shuff_all.base_v_act.out.slow.Neg_TFCens(1:size(within_cond_shuff.out.slow.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.out.slow.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.out.slow.Coh.Neg.SigClusTFCens;
    %============================
    
    try
        shuff_all.in.err.Pcoh(1:251,1:51,sess) = between_cond_shuff.err.TrType1.Pcoh;
        shuff_all.out.err.Pcoh(1:251,1:51,sess) = between_cond_shuff.err.TrType2.Pcoh;
        shuff_all.in_v_out.err.Pos(1:31,1:51,sess) = between_cond_shuff.err.Coh.Pos.SigClusAssign;
        shuff_all.in_v_out.err.Neg(1:31,1:51,sess) = between_cond_shuff.err.Coh.Neg.SigClusAssign;
        shuff_all.in_v_out.err.Pos_TFCens(1:size(between_cond_shuff.err.Coh.Pos.SigClusTFCens,1),1:size(between_cond_shuff.err.Coh.Pos.SigClusTFCens,2),sess) = between_cond_shuff.err.Coh.Pos.SigClusTFCens;
        shuff_all.in_v_out.err.Neg_TFCens(1:size(between_cond_shuff.err.Coh.Neg.SigClusTFCens,1),1:size(between_cond_shuff.err.Coh.Neg.SigClusTFCens,2),sess) = between_cond_shuff.err.Coh.Neg.SigClusTFCens;
        
%         
%         shuff_all.base_v_act.in.err.Pos(1:31,1:51,sess) = within_cond_shuff.in.err.Coh.Pos.SigClusAssign;
%         shuff_all.base_v_act.in.err.Neg(1:31,1:51,sess) = within_cond_shuff.in.err.Coh.Neg.SigClusAssign;
%         shuff_all.base_v_act.out.err.Pos(1:31,1:51,sess) = within_cond_shuff.out.err.Coh.Pos.SigClusAssign;
%         shuff_all.base_v_act.out.err.Neg(1:31,1:51,sess) = within_cond_shuff.out.err.Coh.Neg.SigClusAssign;
%         
%         shuff_all.base_v_act.in.err.Pos_TFCens(1:size(within_cond_shuff.in.err.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.in.err.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.in.err.Coh.Pos.SigClusTFCens;
%         shuff_all.base_v_act.in.err.Neg_TFCens(1:size(within_cond_shuff.in.err.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.in.err.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.in.err.Coh.Neg.SigClusTFCens;
%         shuff_all.base_v_act.out.err.Pos_TFCens(1:size(within_cond_shuff.out.err.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.out.err.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.out.err.Coh.Pos.SigClusTFCens;
%         shuff_all.base_v_act.out.err.Neg_TFCens(1:size(within_cond_shuff.out.err.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.out.err.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.out.err.Coh.Neg.SigClusTFCens;
%         
        
        shuff_all.in_v_in.corr_err.Pos(1:31,1:51,sess) = between_cond_shuff.corr_err.Coh.Pos.SigClusAssign;
        shuff_all.in_v_in.corr_err.Neg(1:31,1:51,sess) = between_cond_shuff.corr_err.Coh.Neg.SigClusAssign;
        
    catch
        shuff_all.in.err.Pcoh(1:251,1:51,sess) = NaN;
        shuff_all.out.err.Pcoh(1:251,1:51,sess) = NaN;
        shuff_all.in_v_out.err.Pos(1:31,1:51,sess) = NaN;
        shuff_all.in_v_out.err.Neg(1:31,1:51,sess) = NaN;
        shuff_all.in_v_out.err.Pos_TFCens(1,1:2,sess) = NaN;
        shuff_all.in_v_out.err.Neg_TFCens(1,1:2,sess) = NaN;
        
        
%         shuff_all.base_v_act.in.err.Pos(1:31,1:51,sess) = NaN;
%         shuff_all.base_v_act.in.err.Neg(1:31,1:51,sess) = NaN;
%         shuff_all.base_v_act.out.err.Pos(1:31,1:51,sess) = NaN;
%         shuff_all.base_v_act.out.err.Neg(1:31,1:51,sess) = NaN;
%         shuff_all.base_v_act.in.err.Pos_TFCens(1,1:2,sess) = NaN;
%         shuff_all.base_v_act.in.err.Neg_TFCens(1,1:2,sess) = NaN;
%         shuff_all.base_v_act.out.err.Pos_TFCens(1,1:2,sess) = NaN;
%         shuff_all.base_v_act.out.err.Neg_TFCens(1,1:2,sess) = NaN;
        
        
        
        shuff_all.in_v_in.corr_err.Pos(1:31,1:51,sess) = NaN;
        shuff_all.in_v_in.corr_err.Neg(1:31,1:51,sess) = NaN;
        
    end
    
    
    shuff_all.in_v_in.fast_slow.Pos(1:31,1:51,sess) = between_cond_shuff.fast_slow.Coh.Pos.SigClusAssign;
    shuff_all.in_v_in.fast_slow.Neg(1:31,1:51,sess) = between_cond_shuff.fast_slow.Coh.Neg.SigClusAssign;
    
    
    
    %====================================
    
    
    
    try
        n_all.in.all(sess,1) = n.in.all;
        n_all.in.ss2(sess,1) = n.in.ss2;
        n_all.in.ss4(sess,1) = n.in.ss4;
        n_all.in.ss8(sess,1) = n.in.ss8;
        n_all.in.fast(sess,1) = n.in.fast;
        n_all.in.slow(sess,1) = n.in.slow;
        n_all.in.err(sess,1) = n.in.err;
        
        n_all.out.all(sess,1) = n.out.all;
        n_all.out.ss2(sess,1) = n.out.ss2;
        n_all.out.ss4(sess,1) = n.out.ss4;
        n_all.out.ss8(sess,1) = n.out.ss8;
        n_all.out.fast(sess,1) = n.out.fast;
        n_all.out.slow(sess,1) = n.out.slow;
        n_all.out.err(sess,1) = n.out.err;
    end
    
    
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
    
    
    keep tout_shuff normshuff_all shuff_all n tout f Pcoh_all coh_all TDT_all Sx_all Sy_all ...
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