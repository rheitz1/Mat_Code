cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
%[filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
%[filename2 unit2] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
% [filename3 unit3] = textread('SAT_Vis_NoMed_S.txt','%s %s');
% [filename4 unit4] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
%[filename5 unit5] = textread('SAT_Vis_Med_Q.txt','%s %s');
%[filename6 unit6] = textread('SAT_VisMove_Med_Q.txt','%s %s');
% [filename7 unit7] = textread('SAT_Vis_Med_S.txt','%s %s');
% [filename8 unit8] = textread('SAT_VisMove_Med_S.txt','%s %s');
% filename = [filename3 ; filename4 ; filename7 ; filename8];
% unit = [unit3 ; unit4 ; unit7 ; unit8];

[filename1 unit1] = textread('SAT2_FEF_Vis_Med_Q.txt','%s %s');
[filename2 unit2] = textread('SAT2_FEF_VisMove_Med_Q.txt','%s %s');

filename = [filename1 ; filename2];
unit = [unit1 ; unit2];


for file = 1:length(filename)
    
    load(filename{file},unit{file},'Target_','SRT','SAT_','Correct_','Errors_')
    filename{file}
    
    
    %lag_window = -2:2;
    lag_window = -10:1;
    
    [SDF] = block_switch(unit{file},lag_window,0);
    
   
    slow_to_fast(file,:) = SDF.slow_to_fast;
    fast_to_slow(file,:) = SDF.fast_to_slow;
    
    
    keep filename file unit slow_to_fast fast_to_slow lag_window
end

%NOTE: Make sure file loading is the same here as in the saved data file!!
% % cd /volumes/Dump/Analyses/SAT/Separate_Monkey/
% % load('S_compileSAT_baseline_vis_visMove_Med_NoMed.mat','sigpos')


figure

sem.fast_to_slow = nanstd(fast_to_slow(sigpos,:),[],1) ./ sqrt(size(fast_to_slow(sigpos,:),1));
sem.slow_to_fast = nanstd(slow_to_fast(sigpos,:),[],1) ./ sqrt(size(slow_to_fast(sigpos,:),1));

plot(lag_window,nanmean(slow_to_fast(sigpos,:)),'g',lag_window,nanmean(slow_to_fast(sigpos,:))-sem.slow_to_fast,'--g',lag_window,nanmean(slow_to_fast(sigpos,:))+sem.slow_to_fast,'--g', ...
    lag_window,nanmean(fast_to_slow(sigpos,:)),'r',lag_window,nanmean(fast_to_slow(sigpos,:))-sem.fast_to_slow,'--r',lag_window,nanmean(fast_to_slow(sigpos,:))+sem.fast_to_slow,'--r')

box off

%ylim([200 1000])

% correction = mean([fast_to_slow slow_to_fast],2);
% cfast_to_slow = fast_to_slow - repmat(correction,1,5);
% cslow_to_fast = slow_to_fast - repmat(correction,1,5);
% 
% 
% figure
% plot(-2:2,cslow_to_fast,'g',-2:2,cfast_to_slow,'r')