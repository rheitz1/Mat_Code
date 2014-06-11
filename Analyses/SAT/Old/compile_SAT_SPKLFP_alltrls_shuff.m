% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
% cd /Volumes/Dump2/Coherence/SPK-LFP/Uber_Tune_NeuronRF_intersection_shuff_SAT/nooverlap/DifferentElectrode
%cd /Volumes/Dump2/Coherence/SPK-LFP/SAT/alltrls/
cd ~/desktop/m/
file_list = dir('*.mat');



plotFlag = 0;
loop_through_plotFlag_Pcoh = 0;
loop_through_plotFlag_coh = 0;


for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    %tout_shuff = between_cond_shuff.wintimes;
    
    RTs.slow_correct_made_dead(sess,1) = RT.slow_correct_made_dead;
    RTs.med_correct(sess,1) = RT.med_correct;
    RTs.fast_correct_made_dead(sess,1) = RT.fast_correct_made_dead;
    

    
    Pcoh_all.slow(1:281,1:104,sess) = Pcoh.slow;
    Pcoh_all.med(1:281,1:104,sess) = Pcoh.med;
    Pcoh_all.fast(1:281,1:104,sess) = Pcoh.fast;
    
    coh_all.slow(1:281,1:104,sess) = coh.slow;
    coh_all.med(1:281,1:104,sess) = coh.med;
    coh_all.fast(1:281,1:104,sess) = coh.fast;
    
    
    %========================
    shuff_all.slow(1:281,1:41,sess) = between_cond_shuff.TrType1.Pcoh;
    shuff_all.fast(1:281,1:41,sess) = between_cond_shuff.TrType2.Pcoh;
    shuff_all.slow_vs_fast.Pos(1:101,1:41,sess) = between_cond_shuff.Coh.Pos.SigClusAssign;
    shuff_all.slow_vs_fast.Neg(1:101,1:41,sess) = between_cond_shuff.Coh.Neg.SigClusAssign;
    
    %=========================
    
    
    n_all.slow(sess,1) = n.slow_correct_made_dead;
    n_all.med(sess,1) = n.med_correct;
    n_all.fast(sess,1) = n.fast_correct_made_dead;
       
    
    
    wf_all.LFP.slow(sess,1:3001) = wf.LFP.slow_correct_made_dead;
    wf_all.LFP.med(sess,1:3001) = wf.LFP.med_correct;
    wf_all.LFP.fast(sess,1:3001) = wf.LFP.fast_correct_made_dead;
    
%     wf_all.SPK.slow(sess,1:3001) = wf.SPK.slow_correct_made_dead;
%     wf_all.SPK.med(sess,1:3001) = wf.SPK.med_correct;
%     wf_all.SPK.fast(sess,1:3001) = wf.SPK.fast_correct_made_dead;
    
    tout_shuff = between_cond_shuff.wintimes;
    
    keep RTs tout tout_shuff f f_shuff coh_all Pcoh_all shuff_all n_all wf_all file_list sess ...
        loop_through_plotFlag_Pcoh loop_through_plotFlag_coh
    
end

~any(any(shuff_all.base_v_act.in.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))

% find significant coherence slow - fast in baseline period
~any(any(shuff_all.base_v_act.in.all.Pos(:,find(f_shuff>=sigOnly_freqrange(1) & f_shuff <= sigOnly_freqrange(2)),sess)))
sigOnly_freqrange = [35 100];
sigOnly_timerange = [-400 0];

targFreq = find(f>=sigOnly_freqrange(1) & f<=sigOnly_freqrange(2));
targTime = find(tout>=sigOnly_timerange(1) & tout<=sigOnly_timerange(2));

targFreq_shuff = find(f_shuff>=sigOnly_freqrange(1) & f_shuff<=sigOnly_freqrange(2));
targTime_shuff = find(tout_shuff>=sigOnly_timerange(1) & tout_shuff<=sigOnly_timerange(2));

for sess = 1:size(shuff_all.slow,3)
%     if any(any(shuff_all.slow_vs_fast.Neg(find(tout_shuff < 0),:,sess)))
%         base_effect(sess,1) = 1;
%     else
%         base_effect(sess,1) = 0;
%     end
        if any(any(shuff_all.slow_vs_fast.Neg(targTime_shuff,targFreq_shuff,sess)))
            base_effect(sess,1) = 1;
        else
            base_effect(sess,1) = 0;
        end

end


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


if loop_through_plotFlag_Pcoh
    fig
    for sess = 1:size(shuff_all.slow,3)
        subplot(2,3,3)
        imagesc(tout,f,abs(Pcoh_all.fast(:,:,sess)'))
        axis xy
        xlim([-400 800])
        colorbar
        title('Fast')
        x = get(gca,'clim');
        
        subplot(2,3,2)
        imagesc(tout,f,abs(Pcoh_all.med(:,:,sess)'))
        axis xy
        xlim([-400 800])
        colorbar
        title('Medium')
        set(gca,'clim',x)
        
        subplot(2,3,1)
        imagesc(tout,f,abs(Pcoh_all.slow(:,:,sess)'))
        axis xy
        xlim([-400 800])
        colorbar
        title('Slow')
        set(gca,'clim',x)
        
        subplot(2,3,4)
        imagesc(tout_shuff,f_shuff,shuff_all.slow_vs_fast.Pos(:,:,sess)')
        axis xy
        colorbar
        title('Positive')
        
        subplot(2,3,5)
        imagesc(tout_shuff,f_shuff,shuff_all.slow_vs_fast.Neg(:,:,sess)')
        axis xy
        colorbar
        title('Negative')
        
        pause
        
        cla_all
    end
end
        


if loop_through_plotFlag_coh
    fig
    for sess = 1:size(shuff_all.slow,3)
        subplot(2,3,3)
        imagesc(tout,f,abs(coh_all.fast(:,:,sess)'))
        axis xy
        xlim([-400 800])
        colorbar
        title('Fast')
        x = get(gca,'clim');
        
        subplot(2,3,2)
        imagesc(tout,f,abs(coh_all.med(:,:,sess)'))
        axis xy
        xlim([-400 800])
        colorbar
        title('Medium')
        set(gca,'clim',x)
        
        subplot(2,3,1)
        imagesc(tout,f,abs(coh_all.slow(:,:,sess)'))
        axis xy
        xlim([-400 800])
        colorbar
        title('Slow')
        set(gca,'clim',x)
        
        subplot(2,3,4)
        imagesc(tout_shuff,f_shuff,shuff_all.slow_vs_fast.Pos(:,:,sess)')
        axis xy
        colorbar
        title('Positive')
        
        subplot(2,3,5)
        imagesc(tout_shuff,f_shuff,shuff_all.slow_vs_fast.Neg(:,:,sess)')
        axis xy
        colorbar
        title('Negative')
        
        pause
        
        cla_all
    end
end
        