% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
% cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_SAT/nooverlap/DifferentElectrode
cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_interp/overlap/SameElectrode
list1 = dir('Q*.mat');

cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_interp/overlap/DifferentElectrode
list2 = dir('Q*.mat');

path(path,'/Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_interp/overlap/SameElectrode');
path(path,'/Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_allTL_interp/overlap/DifferentElectrode');


%file_list = dir('*.mat');
file_list = [list1 ; list2];

plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    tout_shuff = between_cond_shuff.all.wintimes;
    
    
    %MATLAB having trouble saving full 200 Hz-range 3-d matrices; therefore
    %going to split it into 0-100 and 101-200
    
    Pcoh_all.in.all_sub(1:281,1:104,sess) = Pcoh.in.all_sub(:,find(f < 101));
    Pcoh_all.in.all(1:281,1:104,sess) = Pcoh.in.all(:,find(f < 101));
    Pcoh_all.in.ss2(1:281,1:104,sess) = Pcoh.in.ss2(:,find(f < 101));
    Pcoh_all.in.ss4(1:281,1:104,sess) = Pcoh.in.ss4(:,find(f < 101));
    Pcoh_all.in.ss8(1:281,1:104,sess) = Pcoh.in.ss8(:,find(f < 101));
    Pcoh_all.in.fast.ss2(1:281,1:104,sess) = Pcoh.in.fast.ss2(:,find(f < 101));
    Pcoh_all.in.fast.ss4(1:281,1:104,sess) = Pcoh.in.fast.ss4(:,find(f < 101));
    Pcoh_all.in.fast.ss8(1:281,1:104,sess) = Pcoh.in.fast.ss8(:,find(f < 101));
    Pcoh_all.in.slow.ss2(1:281,1:104,sess) = Pcoh.in.slow.ss2(:,find(f < 101));
    Pcoh_all.in.slow.ss4(1:281,1:104,sess) = Pcoh.in.slow.ss4(:,find(f < 101));
    Pcoh_all.in.slow.ss8(1:281,1:104,sess) = Pcoh.in.slow.ss8(:,find(f < 101));
    Pcoh_all.in.fast.all(1:281,1:104,sess) = Pcoh.in.fast.all(:,find(f < 101));
    Pcoh_all.in.slow.all(1:281,1:104,sess) = Pcoh.in.slow.all(:,find(f < 101));
    Pcoh_all.in.err(1:281,1:104,sess) = Pcoh.in.err(:,find(f < 101));
    
    
    Pcoh_all.out.all_sub(1:281,1:104,sess) = Pcoh.out.all_sub(:,find(f < 101));
    Pcoh_all.out.all(1:281,1:104,sess) = Pcoh.out.all(:,find(f < 101));
    Pcoh_all.out.ss2(1:281,1:104,sess) = Pcoh.out.ss2(:,find(f < 101));
    Pcoh_all.out.ss4(1:281,1:104,sess) = Pcoh.out.ss4(:,find(f < 101));
    Pcoh_all.out.ss8(1:281,1:104,sess) = Pcoh.out.ss8(:,find(f < 101));
    Pcoh_all.out.fast.ss2(1:281,1:104,sess) = Pcoh.out.fast.ss2(:,find(f < 101));
    Pcoh_all.out.fast.ss4(1:281,1:104,sess) = Pcoh.out.fast.ss4(:,find(f < 101));
    Pcoh_all.out.fast.ss8(1:281,1:104,sess) = Pcoh.out.fast.ss8(:,find(f < 101));
    Pcoh_all.out.slow.ss2(1:281,1:104,sess) = Pcoh.out.slow.ss2(:,find(f < 101));
    Pcoh_all.out.slow.ss4(1:281,1:104,sess) = Pcoh.out.slow.ss4(:,find(f < 101));
    Pcoh_all.out.slow.ss8(1:281,1:104,sess) = Pcoh.out.slow.ss8(:,find(f < 101));
    Pcoh_all.out.fast.all(1:281,1:104,sess) = Pcoh.out.fast.all(:,find(f < 101));
    Pcoh_all.out.slow.all(1:281,1:104,sess) = Pcoh.out.slow.all(:,find(f < 101));
    Pcoh_all.out.err(1:281,1:104,sess) = Pcoh.out.err(:,find(f < 101));
    
    Pcoh_all_101_200.in.all_sub(1:281,1:102,sess) = Pcoh.in.all_sub(:,find(f >= 101));
    Pcoh_all_101_200.in.all(1:281,1:102,sess) = Pcoh.in.all(:,find(f >= 101));
    Pcoh_all_101_200.in.ss2(1:281,1:102,sess) = Pcoh.in.ss2(:,find(f >= 101));
    Pcoh_all_101_200.in.ss4(1:281,1:102,sess) = Pcoh.in.ss4(:,find(f >= 101));
    Pcoh_all_101_200.in.ss8(1:281,1:102,sess) = Pcoh.in.ss8(:,find(f >= 101));
    Pcoh_all_101_200.in.fast.ss2(1:281,1:102,sess) = Pcoh.in.fast.ss2(:,find(f >= 101));
    Pcoh_all_101_200.in.fast.ss4(1:281,1:102,sess) = Pcoh.in.fast.ss4(:,find(f >= 101));
    Pcoh_all_101_200.in.fast.ss8(1:281,1:102,sess) = Pcoh.in.fast.ss8(:,find(f >= 101));
    Pcoh_all_101_200.in.fast.all(1:281,1:102,sess) = Pcoh.in.fast.all(:,find(f >= 101));
    Pcoh_all_101_200.in.slow.ss2(1:281,1:102,sess) = Pcoh.in.slow.ss2(:,find(f >= 101));
    Pcoh_all_101_200.in.slow.ss4(1:281,1:102,sess) = Pcoh.in.slow.ss4(:,find(f >= 101));
    Pcoh_all_101_200.in.slow.ss8(1:281,1:102,sess) = Pcoh.in.slow.ss8(:,find(f >= 101));
    Pcoh_all_101_200.in.slow.all(1:281,1:102,sess) = Pcoh.in.slow.all(:,find(f >= 101));
    Pcoh_all_101_200.in.err(1:281,1:102,sess) = Pcoh.in.err(:,find(f >= 101));
    
    
    Pcoh_all_101_200.out.all_sub(1:281,1:102,sess) = Pcoh.out.all_sub(:,find(f >= 101));
    Pcoh_all_101_200.out.all(1:281,1:102,sess) = Pcoh.out.all(:,find(f >= 101));
    Pcoh_all_101_200.out.ss2(1:281,1:102,sess) = Pcoh.out.ss2(:,find(f >= 101));
    Pcoh_all_101_200.out.ss4(1:281,1:102,sess) = Pcoh.out.ss4(:,find(f >= 101));
    Pcoh_all_101_200.out.ss8(1:281,1:102,sess) = Pcoh.out.ss8(:,find(f >= 101));
    Pcoh_all_101_200.out.fast.ss2(1:281,1:102,sess) = Pcoh.out.fast.ss2(:,find(f >= 101));
    Pcoh_all_101_200.out.fast.ss4(1:281,1:102,sess) = Pcoh.out.fast.ss4(:,find(f >= 101));
    Pcoh_all_101_200.out.fast.ss8(1:281,1:102,sess) = Pcoh.out.fast.ss8(:,find(f >= 101));
    Pcoh_all_101_200.out.slow.ss2(1:281,1:102,sess) = Pcoh.out.slow.ss2(:,find(f >= 101));
    Pcoh_all_101_200.out.slow.ss4(1:281,1:102,sess) = Pcoh.out.slow.ss4(:,find(f >= 101));
    Pcoh_all_101_200.out.slow.ss8(1:281,1:102,sess) = Pcoh.out.slow.ss8(:,find(f >= 101));
    Pcoh_all_101_200.out.fast.all(1:281,1:102,sess) = Pcoh.out.fast.all(:,find(f >= 101));
    Pcoh_all_101_200.out.slow.all(1:281,1:102,sess) = Pcoh.out.slow.all(:,find(f >= 101));
    Pcoh_all_101_200.out.err(1:281,1:102,sess) = Pcoh.out.err(:,find(f >= 101));
    
    
    
    %========================
    shuff_all.in.all.Pcoh(1:281,1:41,sess) = between_cond_shuff.all.TrType1.Pcoh;
    shuff_all.out.all.Pcoh(1:281,1:41,sess) = between_cond_shuff.all.TrType2.Pcoh;
    shuff_all.in_v_out.all.Pos(1:61,1:41,sess) = between_cond_shuff.all.Coh.Pos.SigClusAssign;
    shuff_all.in_v_out.all.Neg(1:61,1:41,sess) = between_cond_shuff.all.Coh.Neg.SigClusAssign;
    shuff_all.in_v_out.all.Pos_TFCens(1:size(between_cond_shuff.all.Coh.Pos.SigClusTFCens,1),1:size(between_cond_shuff.all.Coh.Pos.SigClusTFCens,2),sess) = between_cond_shuff.all.Coh.Pos.SigClusTFCens;
    shuff_all.in_v_out.all.Neg_TFCens(1:size(between_cond_shuff.all.Coh.Neg.SigClusTFCens,1),1:size(between_cond_shuff.all.Coh.Neg.SigClusTFCens,2),sess) = between_cond_shuff.all.Coh.Neg.SigClusTFCens;
    
    shuff_all.base_v_act.in.all.Pos(1:61,1:41,sess) = within_cond_shuff.in.all.Coh.Pos.SigClusAssign;
    shuff_all.base_v_act.in.all.Neg(1:61,1:41,sess) = within_cond_shuff.in.all.Coh.Neg.SigClusAssign;
    shuff_all.base_v_act.out.all.Pos(1:61,1:41,sess) = within_cond_shuff.out.all.Coh.Pos.SigClusAssign;
    shuff_all.base_v_act.out.all.Neg(1:61,1:41,sess) = within_cond_shuff.out.all.Coh.Neg.SigClusAssign;
    
    shuff_all.base_v_act.in.all.Pos_TFCens(1:size(within_cond_shuff.in.all.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.in.all.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.in.all.Coh.Pos.SigClusTFCens;
    shuff_all.base_v_act.in.all.Neg_TFCens(1:size(within_cond_shuff.in.all.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.in.all.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.in.all.Coh.Neg.SigClusTFCens;
    shuff_all.base_v_act.out.all.Pos_TFCens(1:size(within_cond_shuff.out.all.Coh.Pos.SigClusTFCens,1),1:size(within_cond_shuff.out.all.Coh.Pos.SigClusTFCens,2),sess) = within_cond_shuff.out.all.Coh.Pos.SigClusTFCens;
    shuff_all.base_v_act.out.all.Neg_TFCens(1:size(within_cond_shuff.out.all.Coh.Neg.SigClusTFCens,1),1:size(within_cond_shuff.out.all.Coh.Neg.SigClusTFCens,2),sess) = within_cond_shuff.out.all.Coh.Neg.SigClusTFCens;
    %=========================
    
    
    n_all.in.all(sess,1) = n.in.all;
    n_all.in.ss2(sess,1) = n.in.ss2;
    n_all.in.ss4(sess,1) = n.in.ss4;
    n_all.in.ss8(sess,1) = n.in.ss8;
    n_all.in.fast.ss2(sess,1) = n.in.fast.ss2;
    n_all.in.fast.ss4(sess,1) = n.in.fast.ss4;
    n_all.in.fast.ss8(sess,1) = n.in.fast.ss8;
    n_all.in.slow.ss2(sess,1) = n.in.slow.ss2;
    n_all.in.slow.ss4(sess,1) = n.in.slow.ss4;
    n_all.in.slow.ss8(sess,1) = n.in.slow.ss8;
    n_all.in.fast.all(sess,1) = n.in.fast.all;
    n_all.in.slow.all(sess,1) = n.in.slow.all;
    n_all.in.err(sess,1) = n.in.err;
    
    n_all.out.all(sess,1) = n.out.all;
    n_all.out.ss2(sess,1) = n.out.ss2;
    n_all.out.ss4(sess,1) = n.out.ss4;
    n_all.out.ss8(sess,1) = n.out.ss8;
    n_all.out.fast.ss2(sess,1) = n.out.fast.ss2;
    n_all.out.fast.ss4(sess,1) = n.out.fast.ss4;
    n_all.out.fast.ss8(sess,1) = n.out.fast.ss8;
    n_all.out.slow.ss2(sess,1) = n.out.slow.ss2;
    n_all.out.slow.ss4(sess,1) = n.out.slow.ss4;
    n_all.out.slow.ss8(sess,1) = n.out.slow.ss8;
    n_all.out.fast.all(sess,1) = n.out.fast.all;
    n_all.out.slow.all(sess,1) = n.out.slow.all;
    n_all.out.err(sess,1) = n.out.err;
    
    
    
    TDT_all.sig1.all(sess,1) = TDT.sig1.all;
    TDT_all.sig1.ss2(sess,1) = TDT.sig1.ss2;
    TDT_all.sig1.ss4(sess,1) = TDT.sig1.ss4;
    TDT_all.sig1.ss8(sess,1) = TDT.sig1.ss8;
    TDT_all.sig1.fast.ss2(sess,1) = TDT.sig1.fast.ss2;
    TDT_all.sig1.fast.ss4(sess,1) = TDT.sig1.fast.ss4;
    TDT_all.sig1.fast.ss8(sess,1) = TDT.sig1.fast.ss8;
    TDT_all.sig1.slow.ss2(sess,1) = TDT.sig1.slow.ss2;
    TDT_all.sig1.slow.ss4(sess,1) = TDT.sig1.slow.ss4;
    TDT_all.sig1.slow.ss8(sess,1) = TDT.sig1.slow.ss8;
    TDT_all.sig1.fast.all(sess,1) = TDT.sig1.fast.all;
    TDT_all.sig1.slow.all(sess,1) = TDT.sig1.slow.all;
    TDT_all.sig1.err(sess,1) = TDT.sig1.err;
    
    
    TDT_all.sig2.all(sess,1) = TDT.sig2.all;
    TDT_all.sig2.ss2(sess,1) = TDT.sig2.ss2;
    TDT_all.sig2.ss4(sess,1) = TDT.sig2.ss4;
    TDT_all.sig2.ss8(sess,1) = TDT.sig2.ss8;
    TDT_all.sig2.fast.ss2(sess,1) = TDT.sig2.fast.ss2;
    TDT_all.sig2.fast.ss4(sess,1) = TDT.sig2.fast.ss4;
    TDT_all.sig2.fast.ss8(sess,1) = TDT.sig2.fast.ss8;
    TDT_all.sig2.slow.ss2(sess,1) = TDT.sig2.slow.ss2;
    TDT_all.sig2.slow.ss4(sess,1) = TDT.sig2.slow.ss4;
    TDT_all.sig2.slow.ss8(sess,1) = TDT.sig2.slow.ss8;
    TDT_all.sig2.fast.all(sess,1) = TDT.sig2.fast.all;
    TDT_all.sig2.slow.all(sess,1) = TDT.sig2.slow.all;
    TDT_all.sig2.err(sess,1) = TDT.sig2.err;
    
    
    
    wf_all.sig1.in.all(sess,1:3001) = wf.sig1.in.all;
    wf_all.sig1.in.ss2(sess,1:3001) = wf.sig1.in.ss2;
    wf_all.sig1.in.ss4(sess,1:3001) = wf.sig1.in.ss4;
    wf_all.sig1.in.ss8(sess,1:3001) = wf.sig1.in.ss8;
    wf_all.sig1.in.fast.ss2(sess,1:3001) = wf.sig1.in.fast.ss2;
    wf_all.sig1.in.fast.ss4(sess,1:3001) = wf.sig1.in.fast.ss4;
    wf_all.sig1.in.fast.ss8(sess,1:3001) = wf.sig1.in.fast.ss8;
    wf_all.sig1.in.slow.ss2(sess,1:3001) = wf.sig1.in.slow.ss2;
    wf_all.sig1.in.slow.ss4(sess,1:3001) = wf.sig1.in.slow.ss4;
    wf_all.sig1.in.slow.ss8(sess,1:3001) = wf.sig1.in.slow.ss8;
    wf_all.sig1.in.fast.all(sess,1:3001) = wf.sig1.in.fast.all;
    wf_all.sig1.in.slow.all(sess,1:3001) = wf.sig1.in.slow.all;
    wf_all.sig1.in.err(sess,1:3001) = wf.sig1.in.err;
    
    wf_all.sig1.out.all(sess,1:3001) = wf.sig1.out.all;
    wf_all.sig1.out.ss2(sess,1:3001) = wf.sig1.out.ss2;
    wf_all.sig1.out.ss4(sess,1:3001) = wf.sig1.out.ss4;
    wf_all.sig1.out.ss8(sess,1:3001) = wf.sig1.out.ss8;
    wf_all.sig1.out.fast.ss2(sess,1:3001) = wf.sig1.out.fast.ss2;
    wf_all.sig1.out.fast.ss4(sess,1:3001) = wf.sig1.out.fast.ss4;
    wf_all.sig1.out.fast.ss8(sess,1:3001) = wf.sig1.out.fast.ss8;
    wf_all.sig1.out.slow.ss2(sess,1:3001) = wf.sig1.out.slow.ss2;
    wf_all.sig1.out.slow.ss4(sess,1:3001) = wf.sig1.out.slow.ss4;
    wf_all.sig1.out.slow.ss8(sess,1:3001) = wf.sig1.out.slow.ss8;
    wf_all.sig1.out.fast.all(sess,1:3001) = wf.sig1.out.fast.all;
    wf_all.sig1.out.slow.all(sess,1:3001) = wf.sig1.out.slow.all;
    wf_all.sig1.out.err(sess,1:3001) = wf.sig1.out.err;
    
    
    wf_all.sig2.in.all(sess,1:3001) = wf.sig2.in.all;
    wf_all.sig2.in.ss2(sess,1:3001) = wf.sig2.in.ss2;
    wf_all.sig2.in.ss4(sess,1:3001) = wf.sig2.in.ss4;
    wf_all.sig2.in.ss8(sess,1:3001) = wf.sig2.in.ss8;
    wf_all.sig2.in.fast.ss2(sess,1:3001) = wf.sig2.in.fast.ss2;
    wf_all.sig2.in.fast.ss4(sess,1:3001) = wf.sig2.in.fast.ss4;
    wf_all.sig2.in.fast.ss8(sess,1:3001) = wf.sig2.in.fast.ss8;
    wf_all.sig2.in.slow.ss2(sess,1:3001) = wf.sig2.in.slow.ss2;
    wf_all.sig2.in.slow.ss4(sess,1:3001) = wf.sig2.in.slow.ss4;
    wf_all.sig2.in.slow.ss8(sess,1:3001) = wf.sig2.in.slow.ss8;
    wf_all.sig2.in.fast.all(sess,1:3001) = wf.sig2.in.fast.all;
    wf_all.sig2.in.slow.all(sess,1:3001) = wf.sig2.in.slow.all;
    wf_all.sig2.in.err(sess,1:3001) = wf.sig2.in.err;
    
    wf_all.sig2.out.all(sess,1:3001) = wf.sig2.out.all;
    wf_all.sig2.out.ss2(sess,1:3001) = wf.sig2.out.ss2;
    wf_all.sig2.out.ss4(sess,1:3001) = wf.sig2.out.ss4;
    wf_all.sig2.out.ss8(sess,1:3001) = wf.sig2.out.ss8;
    wf_all.sig2.out.fast.ss2(sess,1:3001) = wf.sig2.out.fast.ss2;
    wf_all.sig2.out.fast.ss4(sess,1:3001) = wf.sig2.out.fast.ss4;
    wf_all.sig2.out.fast.ss8(sess,1:3001) = wf.sig2.out.fast.ss8;
    wf_all.sig2.out.slow.ss2(sess,1:3001) = wf.sig2.out.slow.ss2;
    wf_all.sig2.out.slow.ss4(sess,1:3001) = wf.sig2.out.slow.ss4;
    wf_all.sig2.out.slow.ss8(sess,1:3001) = wf.sig2.out.slow.ss8;
    wf_all.sig2.out.fast.all(sess,1:3001) = wf.sig2.out.fast.all;
    wf_all.sig2.out.slow.all(sess,1:3001) = wf.sig2.out.slow.all;
    wf_all.sig2.out.err(sess,1:3001) = wf.sig2.out.err;
    
    f_top = f(find(f >= 101));
    f = f(find(f < 101));
    
    keep tout tout_shuff f f_shuff f_top Pcoh_all Pcoh_all_101_200 shuff_all n TDT_all wf_all file_list sess plotFlag
    
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
    
end

clear plotFlag sess