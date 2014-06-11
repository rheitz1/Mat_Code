% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
cd /volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_optimality_constN/overlap/SameElectrode/

file_list = dir('S*.mat');

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    RTs_all.in(1:length(RTs.in),1,sess) = RTs.in;
    RTs_all.out(1:length(RTs.out),1,sess) = RTs.out;
    
    devFire_all.in(1:length(devFire.in),1,sess) = devFire.in;
    devFire_all.out(1:length(devFire.out),1,sess) = devFire.out;
    
    Pcoh_all.in.optimal(1:281,1:104,sess) = Pcoh.in.optimal;
    Pcoh_all.out.optimal(1:281,1:104,sess) = Pcoh.out.optimal;
    
    Pcoh_all.in.nonoptimal(1:281,1:104,sess) = Pcoh.in.nonoptimal;
    Pcoh_all.out.nonoptimal(1:281,1:104,sess) = Pcoh.out.nonoptimal;
    
    
    
    keep file_list tout f RTs_all devFire_all Pcoh_all dif sess
    
end
%     inOpt_outOpt = abs(Pcoh_all.in.optimal) - abs(Pcoh_all.out.optimal);
%     inNonOpt_outNonOpt = abs(Pcoh_all.in.nonoptimal) - abs(Pcoh_all.out.nonoptimal);
%     
%     inOpt_inNonOpt = abs(Pcoh_all.in.optimal) - abs(Pcoh_all.in.nonoptimal);
    

%Plot time averages
% figure
% 
% b1.in = squeeze(nanmean(abs(Pcoh_all.in.bin1(:,find(f >= 35),:)),2));
% b2.in = squeeze(nanmean(abs(Pcoh_all.in.bin2(:,find(f >= 35),:)),2));
% b3.in = squeeze(nanmean(abs(Pcoh_all.in.bin3(:,find(f >= 35),:)),2));
% b4.in = squeeze(nanmean(abs(Pcoh_all.in.bin4(:,find(f >= 35),:)),2));
% 
% b1.out = squeeze(nanmean(abs(Pcoh_all.out.bin1(:,find(f >= 35),:)),2));
% b2.out = squeeze(nanmean(abs(Pcoh_all.out.bin2(:,find(f >= 35),:)),2));
% b3.out = squeeze(nanmean(abs(Pcoh_all.out.bin3(:,find(f >= 35),:)),2));
% b4.out = squeeze(nanmean(abs(Pcoh_all.out.bin4(:,find(f >= 35),:)),2));
% 
% d1 = squeeze(nanmean(dif.bin1(:,find(f >= 35),:),2));
% d2 = squeeze(nanmean(dif.bin2(:,find(f >= 35),:),2));
% d3 = squeeze(nanmean(dif.bin3(:,find(f >= 35),:),2));
% d4 = squeeze(nanmean(dif.bin4(:,find(f >= 35),:),2));
% 
% %baseline correct differences
% d1_bc = baseline_correct(d1',[find(tout == -200) find(tout == -100)])';
% d2_bc = baseline_correct(d2',[find(tout == -200) find(tout == -100)])';
% d3_bc = baseline_correct(d3',[find(tout == -200) find(tout == -100)])';
% d4_bc = baseline_correct(d4',[find(tout == -200) find(tout == -100)])';
% 
% figure
% 
% subplot(4,1,1)
% plot(tout,nanmean(b1.in,2),'k',tout,nanmean(b2.in,2),'b',tout,nanmean(b3.in,2),'r',tout,nanmean(b4.in,2),'g')
% xlim([-200 500])
% title('Target in')
% 
% subplot(4,1,2)
% plot(tout,nanmean(b1.out,2),'k',tout,nanmean(b2.out,2),'b',tout,nanmean(b3.out,2),'r',tout,nanmean(b4.out,2),'g')
% xlim([-200 500])
% title('Target out')
% 
% 
% subplot(4,1,3)
% plot(tout,nanmean(d1,2),'k',tout,nanmean(d2,2),'b',tout,nanmean(d3,2),'r',tout,nanmean(d4,2),'g')
% xlim([-200 500])
% title('Target in - Target out')
% 
% subplot(4,1,4)
% plot(tout,nanmean(d1_bc,2),'k',tout,nanmean(d2_bc,2),'b',tout,nanmean(d3_bc,2),'r',tout,nanmean(d4_bc,2),'g')
% xlim([-200 500])
% title('Target in - Target out Baseline Corrected')
