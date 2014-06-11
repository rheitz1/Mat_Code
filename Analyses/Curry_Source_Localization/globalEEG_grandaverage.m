%make grand average of all sessions, Left - Right for CURRY source
%localization project

cd '/volumes/Dump/Search_Data/'

batch_list = dir('S*SEARCH.mat');
totalSig = 0;


for sess = 1:length(batch_list)
    
    batch_list(sess).name
    load(batch_list(sess).name,'Correct_','Target_','SRT')
    ChanStruct = loadChan(batch_list(sess).name,'EEG');
    decodeChanStruct
    clear ChanStruct
    
    trls.left = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    trls.right = find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    if length(trls.left) < 100 || length(trls.right) < 100
        disp('Too few trials, moving on...')
        keep batch_list sess *_av_* totalSig
        continue
    else
        totalSig = totalSig + 1;
        
        if exist('AD01')
            AD01 = fixClipped(AD01);
            AD01 = baseline_correct(AD01,[400 500]);
            AD01_av_left(totalSig,1:3001) = nanmean(AD01(trls.left,:));
            AD01_av_right(totalSig,1:3001) = nanmean(AD01(trls.right,:));
            AD01_av_diff(totalSig,1:3001) = (nanmean(AD01(trls.left,:))) - (nanmean(AD01(trls.right,:)));
        end
        
        if exist('AD02')
            AD02 = fixClipped(AD02);
            AD02 = baseline_correct(AD02,[400 500]);
            AD02_av_left(totalSig,1:3001) = nanmean(AD02(trls.left,:));
            AD02_av_right(totalSig,1:3001) = nanmean(AD02(trls.right,:));
            AD02_av_diff(totalSig,1:3001) = (nanmean(AD02(trls.left,:))) - (nanmean(AD02(trls.right,:)));
        end
        
        if exist('AD03')
            AD03 = fixClipped(AD03);
            AD03 = baseline_correct(AD03,[400 500]);
            AD03_av_left(totalSig,1:3001) = nanmean(AD03(trls.left,:));
            AD03_av_right(totalSig,1:3001) = nanmean(AD03(trls.right,:));
            AD03_av_diff(totalSig,1:3001) = (nanmean(AD03(trls.left,:))) - (nanmean(AD03(trls.right,:)));
        end
        
        if exist('AD04')
            AD04 = fixClipped(AD04);
            AD04 = baseline_correct(AD04,[400 500]);
            AD04_av_left(totalSig,1:3001) = nanmean(AD04(trls.left,:));
            AD04_av_right(totalSig,1:3001) = nanmean(AD04(trls.right,:));
            AD04_av_diff(totalSig,1:3001) = (nanmean(AD04(trls.left,:))) - (nanmean(AD04(trls.right,:)));
        end
        
        if exist('AD05')
            AD05 = fixClipped(AD05);
            AD05 = baseline_correct(AD05,[400 500]);
            AD05_av_left(totalSig,1:3001) = nanmean(AD05(trls.left,:));
            AD05_av_right(totalSig,1:3001) = nanmean(AD05(trls.right,:));
            AD05_av_diff(totalSig,1:3001) = (nanmean(AD05(trls.left,:))) - (nanmean(AD05(trls.right,:)));
        end
        
        if exist('AD06')
            AD06 = fixClipped(AD06);
            AD06 = baseline_correct(AD06,[400 500]);
            AD06_av_left(totalSig,1:3001) = nanmean(AD06(trls.left,:));
            AD06_av_right(totalSig,1:3001) = nanmean(AD06(trls.right,:));
            AD06_av_diff(totalSig,1:3001) = (nanmean(AD06(trls.left,:))) - (nanmean(AD06(trls.right,:)));
        end
        
        if exist('AD07')
            AD07 = fixClipped(AD07);
            AD07 = baseline_correct(AD07,[400 500]);
            AD07_av_left(totalSig,1:3001) = nanmean(AD07(trls.left,:));
            AD07_av_right(totalSig,1:3001) = nanmean(AD07(trls.right,:));
            AD07_av_diff(totalSig,1:3001) = (nanmean(AD07(trls.left,:))) - (nanmean(AD07(trls.right,:)));
        end
        
    end
    
    keep batch_list sess *_av_* totalSig
    
end


AD01_grandav_left = nanmean(AD01_av_left);
AD01_grandav_right = nanmean(AD01_av_right);
AD01_grandav_diff = nanmean(AD01_av_diff);

AD02_grandav_left = nanmean(AD02_av_left);
AD02_grandav_right = nanmean(AD02_av_right);
AD02_grandav_diff = nanmean(AD02_av_diff);

AD03_grandav_left = nanmean(AD03_av_left);
AD03_grandav_right = nanmean(AD03_av_right);
AD03_grandav_diff = nanmean(AD03_av_diff);

AD04_grandav_left = nanmean(AD04_av_left);
AD04_grandav_right = nanmean(AD04_av_right);
AD04_grandav_diff = nanmean(AD04_av_diff);

AD05_grandav_left = nanmean(AD05_av_left);
AD05_grandav_right = nanmean(AD05_av_right);
AD05_grandav_diff = nanmean(AD05_av_diff);

AD06_grandav_left = nanmean(AD06_av_left);
AD06_grandav_right = nanmean(AD06_av_right);
AD06_grandav_diff = nanmean(AD06_av_diff);

AD07_grandav_left = nanmean(AD07_av_left);
AD07_grandav_right = nanmean(AD07_av_right);
AD07_grandav_diff = nanmean(AD07_av_diff);
