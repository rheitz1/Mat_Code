% script to go through all files in a directory and aggregate the behavioral
% data using the getBEH function
% RPH

cd '/volumes/Dump/Search_Data_longBase/'

batch_list = dir('Q*SEARCH.mat');

for sess = 1:length(batch_list)
    
    batch_list(sess).name
    
    load(batch_list(sess).name,'Target_','Correct_','Errors_','SRT')
    
    if size(Target_,1) < 500
        disp('skipping file')
        
        all_correct.ss2(sess,1) = NaN;
        all_correct.ss4(sess,1) = NaN;
        all_correct.ss8(sess,1) = NaN;
        
        all_errors.ss2(sess,1) = NaN;
        all_errors.ss4(sess,1) = NaN;
        all_errors.ss8(sess,1) = NaN;
        
        
        all_acc.ss2(sess,1) = NaN;
        all_acc.ss4(sess,1) = NaN;
        all_acc.ss8(sess,1) = NaN;
        
        continue
    end
    
    
    getBEH
    
    all_correct.ss2(sess,1) = BEH(1,3);
    all_correct.ss4(sess,1) = BEH(1,4);
    all_correct.ss8(sess,1) = BEH(1,5);
    
    all_errors.ss2(sess,1) = BEH(2,3);
    all_errors.ss4(sess,1) = BEH(2,4);
    all_errors.ss8(sess,1) = BEH(2,5);
    
    all_acc.ss2(sess,1) = BEH(3,3);
    all_acc.ss4(sess,1) = BEH(3,4);
    all_acc.ss8(sess,1) = BEH(3,5);
    
    keep all_acc all_correct all_errors batch_list sess
    
end

[bins.correct.ss2 cdf.correct.ss2] = getCDF(all_correct.ss2,90);
[bins.correct.ss4 cdf.correct.ss4] = getCDF(all_correct.ss4,90);
[bins.correct.ss8 cdf.correct.ss8] = getCDF(all_correct.ss8,90);

[bins.errors.ss2 cdf.errors.ss2] = getCDF(all_errors.ss2,90);
[bins.errors.ss4 cdf.errors.ss4] = getCDF(all_errors.ss4,90);
[bins.errors.ss8 cdf.errors.ss8] = getCDF(all_errors.ss8,90);

figure
plot(bins.correct.ss2,cdf.correct.ss2,'k', ...
    bins.correct.ss4,cdf.correct.ss4,'b', ...
    bins.correct.ss8,cdf.correct.ss8,'r', ...
    bins.errors.ss2,cdf.errors.ss2,'--k', ...
    bins.errors.ss4,cdf.errors.ss4,'--b', ...
    bins.errors.ss8,cdf.errors.ss8,'--r')

sem.ss2 = nanstd(all_acc.ss2) / sqrt(sum(~isnan(all_acc.ss2)));
sem.ss4 = nanstd(all_acc.ss4) / sqrt(sum(~isnan(all_acc.ss4)));
sem.ss8 = nanstd(all_acc.ss8) / sqrt(sum(~isnan(all_acc.ss8)));

figure
errorbar(1:3,[1-nanmean(all_acc.ss2) 1-nanmean(all_acc.ss4) 1-nanmean(all_acc.ss8)],[sem.ss2 sem.ss4 sem.ss8])
