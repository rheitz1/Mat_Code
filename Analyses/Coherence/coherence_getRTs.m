%sub for various uses; iterates through all search files

cd /Volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_shuff_allTL/nooverlap/DifferentElectrode/

batch_list = dir('Q*mat');

for sess = 1:length(batch_list)
    
    batch_list(sess).name
    fname = batch_list(sess).name(1:20);
    
    load(fname,'Target_','Correct_','SRT')
    
    cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
   
    RTs.correct(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.err(sess,1) = nanmean(SRT(find(Correct_(:,2) == 0 & Target_(:,2) ~= 255),1));
    RTs.ss2(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.ss4(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.ss8(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.fast(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) > 50 & SRT(:,1) < cMed),1));
    RTs.slow(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) >= cMed),1));
    
    
    nCorrect.all = length(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50));
    nCorrect.ss2 = length(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50));
    nCorrect.ss4 = length(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50));
    nCorrect.ss8 = length(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50));
    nCorrect.fast = length(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) > 50 & SRT(:,1) < cMed));
    nCorrect.slow = length(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) >= cMed));
    
    n.all = length(find(Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50));    
    n.ss2 = length(find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50));
    n.ss4 = length(find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50));
    n.ss8 = length(find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50));
    n.fast = length(find(Target_(:,2) ~= 255 & SRT(:,1) > 50 & SRT(:,1) < cMed));
    n.slow = length(find(Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) >= cMed));
    
    
    acc.overall(sess,1) = nCorrect.all / n.all;
    acc.ss2(sess,1) = nCorrect.ss2 / n.ss2;
    acc.ss4(sess,1) = nCorrect.ss4 / n.ss4;
    acc.ss8(sess,1) = nCorrect.ss8 / n.ss8;
    acc.fast(sess,1) = nCorrect.fast / n.fast;
    acc.slow(sess,1) = nCorrect.slow / n.slow;
    
    clear fname Target_ Correct_ SRT cMed n nCorrect
    
end
