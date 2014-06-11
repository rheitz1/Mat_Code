% compile partial coherence analyses for SPK-LFP
%
% NOTE: FOR THESE NTILE ANALYSES, DID NOT USE 'CORRECTED' DATABASE
% RPH

%cd /Volumes/Dump2/Coherence/Uber/Normalized/SPK-LFP/
cd /volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_shuff_allTL_ntile/overlap/SameElectrode_fastslow/

file_list = dir('*.mat');

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    
    Pcoh_all.all.in(1:281,1:104,sess) = Pcoh.all.in;
    Pcoh_all.all.out(1:281,1:104,sess) = Pcoh.all.out;
    
    %=============
    % Quartiles
    Pcoh_all.ss2.in.bin1(1:281,1:104,sess) = Pcoh.ss2.in.bin1;
    Pcoh_all.ss2.in.bin2(1:281,1:104,sess) = Pcoh.ss2.in.bin2;
    Pcoh_all.ss2.in.bin3(1:281,1:104,sess) = Pcoh.ss2.in.bin3;
    Pcoh_all.ss2.in.bin4(1:281,1:104,sess) = Pcoh.ss2.in.bin4;
    
    Pcoh_all.ss2.out.bin1(1:281,1:104,sess) = Pcoh.ss2.out.bin1;
    Pcoh_all.ss2.out.bin2(1:281,1:104,sess) = Pcoh.ss2.out.bin2;
    Pcoh_all.ss2.out.bin3(1:281,1:104,sess) = Pcoh.ss2.out.bin3;
    Pcoh_all.ss2.out.bin4(1:281,1:104,sess) = Pcoh.ss2.out.bin4;
    
    Pcoh_all.ss4.in.bin1(1:281,1:104,sess) = Pcoh.ss4.in.bin1;
    Pcoh_all.ss4.in.bin2(1:281,1:104,sess) = Pcoh.ss4.in.bin2;
    Pcoh_all.ss4.in.bin3(1:281,1:104,sess) = Pcoh.ss4.in.bin3;
    Pcoh_all.ss4.in.bin4(1:281,1:104,sess) = Pcoh.ss4.in.bin4;
    
    Pcoh_all.ss4.out.bin1(1:281,1:104,sess) = Pcoh.ss4.out.bin1;
    Pcoh_all.ss4.out.bin2(1:281,1:104,sess) = Pcoh.ss4.out.bin2;
    Pcoh_all.ss4.out.bin3(1:281,1:104,sess) = Pcoh.ss4.out.bin3;
    Pcoh_all.ss4.out.bin4(1:281,1:104,sess) = Pcoh.ss4.out.bin4;
    
    Pcoh_all.ss8.in.bin1(1:281,1:104,sess) = Pcoh.ss8.in.bin1;
    Pcoh_all.ss8.in.bin2(1:281,1:104,sess) = Pcoh.ss8.in.bin2;
    Pcoh_all.ss8.in.bin3(1:281,1:104,sess) = Pcoh.ss8.in.bin3;
    Pcoh_all.ss8.in.bin4(1:281,1:104,sess) = Pcoh.ss8.in.bin4;
    
    Pcoh_all.ss8.out.bin1(1:281,1:104,sess) = Pcoh.ss8.out.bin1;
    Pcoh_all.ss8.out.bin2(1:281,1:104,sess) = Pcoh.ss8.out.bin2;
    Pcoh_all.ss8.out.bin3(1:281,1:104,sess) = Pcoh.ss8.out.bin3;
    Pcoh_all.ss8.out.bin4(1:281,1:104,sess) = Pcoh.ss8.out.bin4;
    
        
    RT_all.ss2.bin1(sess,1) = RT.ss2.bin1;
    RT_all.ss2.bin2(sess,1) = RT.ss2.bin2;
    RT_all.ss2.bin3(sess,1) = RT.ss2.bin3;
    RT_all.ss2.bin4(sess,1) = RT.ss2.bin4;
    
    RT_all.ss4.bin1(sess,1) = RT.ss4.bin1;
    RT_all.ss4.bin2(sess,1) = RT.ss4.bin2;
    RT_all.ss4.bin3(sess,1) = RT.ss4.bin3;
    RT_all.ss4.bin4(sess,1) = RT.ss4.bin4;
    
    RT_all.ss8.bin1(sess,1) = RT.ss8.bin1;
    RT_all.ss8.bin2(sess,1) = RT.ss8.bin2;
    RT_all.ss8.bin3(sess,1) = RT.ss8.bin3;
    RT_all.ss8.bin4(sess,1) = RT.ss8.bin4;
    
    
    %================
    % Median Split
    Pcoh_all.ss2.in.bin12(1:281,1:104,sess) = Pcoh.ss2.in.bin12;
    Pcoh_all.ss2.in.bin34(1:281,1:104,sess) = Pcoh.ss2.in.bin34;
    
    Pcoh_all.ss4.in.bin12(1:281,1:104,sess) = Pcoh.ss4.in.bin12;
    Pcoh_all.ss4.in.bin34(1:281,1:104,sess) = Pcoh.ss4.in.bin34;
    
    Pcoh_all.ss8.in.bin12(1:281,1:104,sess) = Pcoh.ss8.in.bin12;
    Pcoh_all.ss8.in.bin34(1:281,1:104,sess) = Pcoh.ss8.in.bin34;
    
    Pcoh_all.ss2.out.bin12(1:281,1:104,sess) = Pcoh.ss2.out.bin12;
    Pcoh_all.ss2.out.bin34(1:281,1:104,sess) = Pcoh.ss2.out.bin34;
    
    Pcoh_all.ss4.out.bin12(1:281,1:104,sess) = Pcoh.ss4.out.bin12;
    Pcoh_all.ss4.out.bin34(1:281,1:104,sess) = Pcoh.ss4.out.bin34;
    
    Pcoh_all.ss8.out.bin12(1:281,1:104,sess) = Pcoh.ss8.out.bin12;
    Pcoh_all.ss8.out.bin34(1:281,1:104,sess) = Pcoh.ss8.out.bin34;

    RT_all.ss2.bin12(sess,1) = RT.ss2.bin12;
    RT_all.ss4.bin12(sess,1) = RT.ss4.bin12;
    RT_all.ss8.bin12(sess,1) = RT.ss8.bin12;

    RT_all.ss2.bin34(sess,1) = RT.ss2.bin34;
    RT_all.ss4.bin34(sess,1) = RT.ss4.bin34;
    RT_all.ss8.bin34(sess,1) = RT.ss8.bin34;
   
    %NOTE: this is the within-session between condition (Tin vs Din)
    %shuffle tests for all data (i.e., not split by bin or by set size).
    %These data are available in the files, but I do not see any use for
    %them right now.
    shuff_all(1:61,1:21,sess) = between_cond_shuff.all.Coh.Pos.SigClusAssign;
   
    tout_shuff = between_cond_shuff.all.wintimes;
    
    keep file_list tout f tout_shuff f_shuff Pcoh_all RT_all sess shuff_all
    
end

