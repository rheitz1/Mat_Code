% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/LFP-LFP/SAT/Raw_Files/
cd /Volumes/Dump2/Coherence/LFP-LFP/SAT/Raw_Files_all_trls_no_shuff_reRef/
file_list = dir('S*.mat');

include_shuff_tests = 0;

plotFlag = 0;
loop_through_plotFlag_Pcoh = 0;
loop_through_plotFlag_coh = 0;


for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    if include_shuff_tests; tout_shuff = between_cond_shuff.wintimes; end
    
    if isfield(RT,'slow_subsamp')
        RTs.slow_all_subsamp(sess,1) = RT.slow_subsamp;
    else
        RTs.slow_all_subsamp(sess,1) = NaN;
    end
    
    RTs.slow_all(sess,1) = RT.slow_all;
    RTs.med_all(sess,1) = RT.med_all;
    RTs.fast_all_withCleared(sess,1) = RT.fast_all_withCleared;
    
    
    Pcoh_all.slow(1:581,1:104,sess) = Pcoh.slow;
    Pcoh_all.med(1:581,1:104,sess) = Pcoh.med;
    Pcoh_all.fast(1:581,1:104,sess) = Pcoh.fast;
    
    ZPcoh_all.slow(1:581,1:104,sess) = ZPcoh.slow;
    ZPcoh_all.med(1:581,1:104,sess) = ZPcoh.med;
    ZPcoh_all.fast(1:581,1:104,sess) = ZPcoh.fast;
    
    coh_all.slow(1:581,1:104,sess) = coh.slow;
    coh_all.med(1:581,1:104,sess) = coh.med;
    coh_all.fast(1:581,1:104,sess) = coh.fast;
    
    Zcoh_all.slow(1:581,1:104,sess) = Zcoh.slow;
    Zcoh_all.med(1:581,1:104,sess) = Zcoh.med;
    Zcoh_all.fast(1:581,1:104,sess) = Zcoh.fast;
    
    if isfield(RT,'slow_subsamp')
        Pcoh_all.slow_subsamp(1:581,1:104,sess) = Pcoh.slow_subsamp;
        ZPcoh_all.slow_subsamp(1:581,1:104,sess) = ZPcoh.slow_subsamp;
        coh_all.slow_subsamp(1:581,1:104,sess) = coh.slow_subsamp;
        Zcoh_all.slow_subsamp(1:581,1:104,sess) = Zcoh.slow_subsamp;
    else
        Pcoh_all.slow_subsamp(1:length(tout),1:length(f),sess) = NaN;
        ZPcoh_all.slow_subsamp(1:length(tout),1:length(f),sess) = NaN;
        coh_all.slow_subsamp(1:length(tout),1:length(f),sess) = NaN;
        Zcoh_all.slow_subsamp(1:length(tout),1:length(f),sess) = NaN;
    end
    
    all_reRef(sess,1) = reRef;
    
    %========================
    if include_shuff_tests
        shuff_all.slow(1:581,1:21,sess) = between_cond_shuff.TrType1.Pcoh;
        shuff_all.fast(1:581,1:21,sess) = between_cond_shuff.TrType2.Pcoh;
        shuff_all.slow_vs_fast.Pos(1:211,1:21,sess) = between_cond_shuff.Coh.Pos.SigClusAssign;
        shuff_all.slow_vs_fast.Neg(1:211,1:21,sess) = between_cond_shuff.Coh.Neg.SigClusAssign;
    end
    %=========================
    
    
    n_all.slow(sess,1) = n.slow_all;
    n_all.med(sess,1) = n.med_all;
    n_all.fast(sess,1) = n.fast_all_withCleared;
    
       
    wf_all.LFP1.slow(sess,1:6001) = wf.LFP1.slow_all;
    wf_all.LFP1.med(sess,1:6001) = wf.LFP1.med_all;
    wf_all.LFP1.fast(sess,1:6001) = wf.LFP1.fast_all_withCleared;
    
    wf_all.LFP2.slow(sess,1:6001) = wf.LFP2.slow_all;
    wf_all.LFP2.med(sess,1:6001) = wf.LFP2.med_all;
    wf_all.LFP2.fast(sess,1:6001) = wf.LFP2.fast_all_withCleared;
    
    if isfield(RT,'slow_subsamp')
        wf_all.LFP1.slow_subsamp(sess,1:6001) = wf.LFP1.slow_subsamp;
        wf_all.LFP2.slow_subsamp(sess,1:6001) = wf.LFP2.slow_subsamp;
    else
        wf_all.LFP1.slow_subsamp(sess,1:6001) = NaN;
        wf_all.LFP2.slow_subsamp(sess,1:6001) = NaN;
    end
    
    all_RF_overlap.logical(sess,1) = ~isempty(RF_Overlap);
    all_RF_overlap.ID{sess,1} = RF_Overlap;
    all_RF_overlap.length(sess,1) = length(RF_Overlap);
    
    all_sameHemi(sess,1) = sameHemi;
    
    keep RTs tout tout_shuff f f_shuff coh_all Zcoh_all Pcoh_all ZPcoh_all shuff_all n_all wf_all ...
        all_RF* all_sameHemi file_list sess loop_through_plotFlag_Pcoh loop_through_plotFlag_coh ...
        include_shuff_tests all_reRef
    
end


if include_shuff_tests
    % find significant negative coherence slow - fast in baseline period
    for sess = 1:size(shuff_all.slow,3)
        if any(any(shuff_all.slow_vs_fast.Neg(find(tout_shuff < 0),find(f_shuff > 10),sess)))
            base_effect_Neg(sess,1) = 1;
        else
            base_effect_Neg(sess,1) = 0;
        end
    end
    
    % find significant negative coherence slow - fast in baseline period
    for sess = 1:size(shuff_all.slow,3)
        if any(any(shuff_all.slow_vs_fast.Pos(find(tout_shuff < 0),find(f_shuff > 10),sess)))
            base_effect_Pos(sess,1) = 1;
        else
            base_effect_Pos(sess,1) = 0;
        end
    end
end

sameHemi = find(all_sameHemi);
diffHemi = find(all_sameHemi == 0);

RF_overlap1 = find(all_RF_overlap.length == 1);
RF_overlap2 = find(all_RF_overlap.length == 2);
RF_overlap3 = find(all_RF_overlap.length == 3);
RF_overlap4 = find(all_RF_overlap.length == 4);
% if plotFlag
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


% if loop_through_plotFlag_Pcoh
%     fig
%     for sess = 1:size(shuff_all.slow,3)
%         subplot(2,3,3)
%         imagesc(tout,f,abs(Pcoh_all.fast(:,:,sess)'))
%         axis xy
%         xlim([-400 800])
%         colorbar
%         title('Fast')
%         x = get(gca,'clim');
%
%         subplot(2,3,2)
%         imagesc(tout,f,abs(Pcoh_all.med(:,:,sess)'))
%         axis xy
%         xlim([-400 800])
%         colorbar
%         title('Medium')
%         set(gca,'clim',x)
%
%         subplot(2,3,1)
%         imagesc(tout,f,abs(Pcoh_all.slow(:,:,sess)'))
%         axis xy
%         xlim([-400 800])
%         colorbar
%         title('Slow')
%         set(gca,'clim',x)
%
%         subplot(2,3,4)
%         imagesc(tout_shuff,f_shuff,shuff_all.slow_vs_fast.Pos(:,:,sess)')
%         axis xy
%         colorbar
%         title('Positive')
%
%         subplot(2,3,5)
%         imagesc(tout_shuff,f_shuff,shuff_all.slow_vs_fast.Neg(:,:,sess)')
%         axis xy
%         colorbar
%         title('Negative')
%
%         pause
%
%         cla_all
%     end
% end
%
%
%
% if loop_through_plotFlag_coh
%     fig
%     for sess = 1:size(shuff_all.slow,3)
%         subplot(2,3,3)
%         imagesc(tout,f,abs(coh_all.fast(:,:,sess)'))
%         axis xy
%         xlim([-400 800])
%         colorbar
%         title('Fast')
%         x = get(gca,'clim');
%
%         subplot(2,3,2)
%         imagesc(tout,f,abs(coh_all.med(:,:,sess)'))
%         axis xy
%         xlim([-400 800])
%         colorbar
%         title('Medium')
%         set(gca,'clim',x)
%
%         subplot(2,3,1)
%         imagesc(tout,f,abs(coh_all.slow(:,:,sess)'))
%         axis xy
%         xlim([-400 800])
%         colorbar
%         title('Slow')
%         set(gca,'clim',x)
%
%         subplot(2,3,4)
%         imagesc(tout_shuff,f_shuff,shuff_all.slow_vs_fast.Pos(:,:,sess)')
%         axis xy
%         colorbar
%         title('Positive')
%
%         subplot(2,3,5)
%         imagesc(tout_shuff,f_shuff,shuff_all.slow_vs_fast.Neg(:,:,sess)')
%         axis xy
%         colorbar
%         title('Negative')
%
%         pause
%
%         cla_all
%     end
% end
%