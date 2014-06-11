%compile GT Sternberg data
cd /volumes/Dump/GT_EEG_Data/
files = dir('*.mat');

for sess = 1:length(files)
    files(sess).name
    load(files(sess).name,'-mat')
    
    VEP_Oz_all(sess,1:801) = nanmean(VEP_Oz);
    SS1_Oz_all(sess,1:801) = nanmean(SS1_Oz);
    SS2_Oz_all(sess,1:801) = nanmean(SS2_Oz);
    SS3_Oz_all(sess,1:801) = nanmean(SS3_Oz);
    SS4_Oz_all(sess,1:801) = nanmean(SS4_Oz);
    SS5_Oz_all(sess,1:801) = nanmean(SS5_Oz);
    SS6_Oz_all(sess,1:801) = nanmean(SS6_Oz);
    SS7_Oz_all(sess,1:801) = nanmean(SS7_Oz);
    
    VEP_O1_all(sess,1:801) = nanmean(VEP_O1);
    SS1_O1_all(sess,1:801) = nanmean(SS1_O1);
    SS2_O1_all(sess,1:801) = nanmean(SS2_O1);
    SS3_O1_all(sess,1:801) = nanmean(SS3_O1);
    SS4_O1_all(sess,1:801) = nanmean(SS4_O1);
    SS5_O1_all(sess,1:801) = nanmean(SS5_O1);
    SS6_O1_all(sess,1:801) = nanmean(SS6_O1);
    SS7_O1_all(sess,1:801) = nanmean(SS7_O1);
    
    VEP_O2_all(sess,1:801) = nanmean(VEP_O2);
    SS1_O2_all(sess,1:801) = nanmean(SS1_O2);
    SS2_O2_all(sess,1:801) = nanmean(SS2_O2);
    SS3_O2_all(sess,1:801) = nanmean(SS3_O2);
    SS4_O2_all(sess,1:801) = nanmean(SS4_O2);
    SS5_O2_all(sess,1:801) = nanmean(SS5_O2);
    SS6_O2_all(sess,1:801) = nanmean(SS6_O2);
    SS7_O2_all(sess,1:801) = nanmean(SS7_O2);
    
    
    keep *_all sess files
end

keep *_all
plottime = -600:2:1000;