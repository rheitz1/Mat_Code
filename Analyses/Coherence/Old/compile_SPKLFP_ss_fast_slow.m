% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
cd /Volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_ss_fast_slow/overlap/SameElectrode/

file_list = dir('*.mat');
plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    
    
    Pcoh_all.in.fast.ss2(1:281,1:104,sess) = Pcoh.in.fast.ss2;
    Pcoh_all.in.fast.ss4(1:281,1:104,sess) = Pcoh.in.fast.ss4;
    Pcoh_all.in.fast.ss8(1:281,1:104,sess) = Pcoh.in.fast.ss8;
    
    Pcoh_all.in.slow.ss2(1:281,1:104,sess) = Pcoh.in.slow.ss2;
    Pcoh_all.in.slow.ss4(1:281,1:104,sess) = Pcoh.in.slow.ss4;
    Pcoh_all.in.slow.ss8(1:281,1:104,sess) = Pcoh.in.slow.ss8;
    
    Pcoh_all.out.fast.ss2(1:281,1:104,sess) = Pcoh.out.fast.ss2;
    Pcoh_all.out.fast.ss4(1:281,1:104,sess) = Pcoh.out.fast.ss4;
    Pcoh_all.out.fast.ss8(1:281,1:104,sess) = Pcoh.out.fast.ss8;
    
    Pcoh_all.out.slow.ss2(1:281,1:104,sess) = Pcoh.out.slow.ss2;
    Pcoh_all.out.slow.ss4(1:281,1:104,sess) = Pcoh.out.slow.ss4;
    Pcoh_all.out.slow.ss8(1:281,1:104,sess) = Pcoh.out.slow.ss8;
    
    shuff_all.in_v_out.all.Pos(1:61,1:21,sess) = between_cond_shuff.all.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.all.Neg(1:61,1:21,sess) = between_cond_shuff.all.Coh.Neg.SigClusAssign;
    
    shuff_all.in_v_out.fast.ss2.Pos(1:61,1:21,sess) = between_cond_shuff.fast.ss2.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.fast.ss2.Neg(1:61,1:21,sess) = between_cond_shuff.fast.ss2.Coh.Neg.SigClusAssign;
    
    shuff_all.in_v_out.fast.ss4.Pos(1:61,1:21,sess) = between_cond_shuff.fast.ss4.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.fast.ss4.Neg(1:61,1:21,sess) = between_cond_shuff.fast.ss4.Coh.Neg.SigClusAssign;

    shuff_all.in_v_out.fast.ss8.Pos(1:61,1:21,sess) = between_cond_shuff.fast.ss8.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.fast.ss8.Neg(1:61,1:21,sess) = between_cond_shuff.fast.ss8.Coh.Neg.SigClusAssign;

    shuff_all.in_v_out.slow.ss2.Pos(1:61,1:21,sess) = between_cond_shuff.slow.ss2.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.slow.ss2.Neg(1:61,1:21,sess) = between_cond_shuff.slow.ss2.Coh.Neg.SigClusAssign;
    
    shuff_all.in_v_out.slow.ss4.Pos(1:61,1:21,sess) = between_cond_shuff.slow.ss4.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.slow.ss4.Neg(1:61,1:21,sess) = between_cond_shuff.slow.ss4.Coh.Neg.SigClusAssign;
 
    shuff_all.in_v_out.slow.ss8.Pos(1:61,1:21,sess) = between_cond_shuff.slow.ss8.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.slow.ss8.Neg(1:61,1:21,sess) = between_cond_shuff.slow.ss8.Coh.Neg.SigClusAssign;


    keep tout f Pcoh_all file_list sess plotFlag shuff_all
    
end

clear plotFlag sess