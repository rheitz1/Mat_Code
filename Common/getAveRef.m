%Re-reference each EEG to average of all EEG electrodes
%Retain trial-by-trial data

getMonk

if monkey == 'S'
    aveRef(1:size(AD01,1),1:size(AD01,2),1:7) = NaN;
    
    aveRef(1:size(AD01,1),1:size(AD01,2),1) = AD01;
    aveRef(1:size(AD02,1),1:size(AD02,2),2) = AD02;
    aveRef(1:size(AD03,1),1:size(AD03,2),3) = AD03;
    aveRef(1:size(AD04,1),1:size(AD04,2),4) = AD04;
    aveRef(1:size(AD05,1),1:size(AD05,2),5) = AD05;
    aveRef(1:size(AD06,1),1:size(AD06,2),6) = AD06;
    aveRef(1:size(AD07,1),1:size(AD07,2),7) = AD07;
    
    ave = nanmean(aveRef,3);
    
    AD01_aveRef = AD01 - ave;
    AD02_aveRef = AD02 - ave;
    AD03_aveRef = AD03 - ave;
    AD04_aveRef = AD04 - ave;
    AD05_aveRef = AD05 - ave;
    AD06_aveRef = AD06 - ave;
    AD07_aveRef = AD07 - ave;
    
elseif monkey == 'Q'
    aveRef(1:size(AD02,1),1:size(AD02,2),1:2) = NaN;
    
    aveRef(1:size(AD02,1),1:size(AD02,2),1) = AD02;
    aveRef(1:size(AD03,1),1:size(AD03,2),2) = AD03;
    
    ave = nanmean(aveRef,3);
    
    AD02_aveRef = AD02 - ave;
    AD03_aveRef = AD03 - ave;
end

clear monkey aveRef ave