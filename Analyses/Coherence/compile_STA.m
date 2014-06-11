%copile spike-triggered averages for spike-LFP coherence
% RPH

cd /Volumes/Dump2/Coherence/Uber/SPK-LFP_nooverlap_STA/

file_list = dir('Q*.mat');
plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    
    STA_all.in.all(sess,1:201) = nanmean(STA.in.all);
    STA_all.in.ss2(sess,1:201) = nanmean(STA.in.ss2);
    STA_all.in.ss4(sess,1:201) = nanmean(STA.in.ss4);
    STA_all.in.ss8(sess,1:201) = nanmean(STA.in.ss8);
    STA_all.in.fast(sess,1:201) = nanmean(STA.in.fast);
    STA_all.in.slow(sess,1:201) = nanmean(STA.in.slow);
    STA_all.in.err(sess,1:201) = nanmean(STA.in.err);
    
    STA_all.out.all(sess,1:201) = nanmean(STA.out.all);
    STA_all.out.ss2(sess,1:201) = nanmean(STA.out.ss2);
    STA_all.out.ss4(sess,1:201) = nanmean(STA.out.ss4);
    STA_all.out.ss8(sess,1:201) = nanmean(STA.out.ss8);
    STA_all.out.fast(sess,1:201) = nanmean(STA.out.fast);
    STA_all.out.slow(sess,1:201) = nanmean(STA.out.slow);
    STA_all.out.err(sess,1:201) = nanmean(STA.out.err);
    
    keep file_list sess STA_all

end