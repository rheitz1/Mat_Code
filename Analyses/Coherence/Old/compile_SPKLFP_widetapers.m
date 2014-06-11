% compile partial coherence analyses for SPK-LFP
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
cd /volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_allTL_corrected_widetapers/overlap/SameElectrode/

file_list = dir('*.mat');
plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    Pcoh_all.in.all_sub(1:271,1:206,sess) = Pcoh.in.all_sub;
    Pcoh_all.in.all(1:271,1:206,sess) = Pcoh.in.all;
    Pcoh_all.in.ss2(1:271,1:206,sess) = Pcoh.in.ss2;
    Pcoh_all.in.ss4(1:271,1:206,sess) = Pcoh.in.ss4;
    Pcoh_all.in.ss8(1:271,1:206,sess) = Pcoh.in.ss8;
    Pcoh_all.in.fast(1:271,1:206,sess) = Pcoh.in.fast;
    Pcoh_all.in.slow(1:271,1:206,sess) = Pcoh.in.slow;
    Pcoh_all.in.err(1:271,1:206,sess) = Pcoh.in.err;
    
    Pcoh_all.out.all_sub(1:271,1:206,sess) = Pcoh.out.all_sub;
    Pcoh_all.out.all(1:271,1:206,sess) = Pcoh.out.all;
    Pcoh_all.out.ss2(1:271,1:206,sess) = Pcoh.out.ss2;
    Pcoh_all.out.ss4(1:271,1:206,sess) = Pcoh.out.ss4;
    Pcoh_all.out.ss8(1:271,1:206,sess) = Pcoh.out.ss8;
    Pcoh_all.out.fast(1:271,1:206,sess) = Pcoh.out.fast;
    Pcoh_all.out.slow(1:271,1:206,sess) = Pcoh.out.slow;
    Pcoh_all.out.err(1:271,1:206,sess) = Pcoh.out.err;
    
    
    
    keep tout f Pcoh_all file_list sess plotFlag
    
end



clear plotFlag sess