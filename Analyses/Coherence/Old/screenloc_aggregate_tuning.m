cd /Volumes/Dump2/Coherence/screenloc/Matrices/normalized/LFP-LFP

file_list = dir('*.mat');

for sess = 1:length(file_list)
    sess
    
    load(file_list(sess).name,'tuning');
    
    allTuning(sess,1) = tuning;
    
    clear tuning
end


%create rose plot of preferred directions for each 'signal' (keep in mind
%that signals will repeat...)

for sess = 1:length(allTuning)
    PD.sig1(sess,1) = allTuning(sess).sig1.MN_band3_10.PD;
    PD.sig2(sess,1) = allTuning(sess).sig2.MN_band3_10.PD;
    
    NormR.sig1(sess,1) = allTuning(sess).sig1.MN_band3_10.NormR;
    NormR.sig2(sess,1) = allTuning(sess).sig2.MN_band3_10.NormR;
    
    p.sig1(sess,1) = allTuning(sess).sig1.MN_band3_10.P;
    p.sig2(sess,1) = allTuning(sess).sig2.MN_band3_10.P;
    
end