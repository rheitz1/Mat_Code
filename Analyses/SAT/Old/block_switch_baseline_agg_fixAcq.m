cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
[filename2 unit2] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_Vis_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_VisMove_NoMed_S.txt','%s %s');

filename = [filename1 ; filename2 ; filename3 ; filename4];
unit = [unit1 ; unit2 ; unit3 ; unit4];


cd /volumes/Dump/Search_Data_SAT_longbase

for file = 1:length(filename)
    
    load(filename{file},unit{file},'Target_','SRT','SAT_','Correct_','Errors_','newfile','EyeX_','EyeY_')
    filename{file}
    
    fixAcq = getFixAcquire(EyeX_,EyeY_);
    
    %SDF = block_switch(unit{file},0);
    SDF = block_switch_fixAcq(unit{file},0);
    
    slow_to_fast(file,:) = SDF.slow_to_fast;
    fast_to_slow(file,:) = SDF.fast_to_slow;
    
    
    keep filename file unit slow_to_fast fast_to_slow
end
    
    
figure

sem.fast_to_slow = nanstd(fast_to_slow,[],1) ./ sqrt(size(fast_to_slow,1));
sem.slow_to_fast = nanstd(slow_to_fast,[],1) ./ sqrt(size(slow_to_fast,1));

plot(-2:2,nanmean(slow_to_fast),'g',-2:2,nanmean(slow_to_fast)-sem.slow_to_fast,'--g',-2:2,nanmean(slow_to_fast)+sem.slow_to_fast,'--g', ...
    -2:2,nanmean(fast_to_slow),'r',-2:2,nanmean(fast_to_slow)-sem.fast_to_slow,'--r',-2:2,nanmean(fast_to_slow)+sem.fast_to_slow,'--r')

box off

%ylim([200 1000])

% correction = mean([fast_to_slow slow_to_fast],2);
% cfast_to_slow = fast_to_slow - repmat(correction,1,5);
% cslow_to_fast = slow_to_fast - repmat(correction,1,5);
% 
% 
% figure
% plot(-2:2,cslow_to_fast,'g',-2:2,cfast_to_slow,'r')