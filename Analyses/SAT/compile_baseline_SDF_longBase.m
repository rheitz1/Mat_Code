% examine change in SDF on block switch trials across the population
% uses longBase files

cd ~/Desktop/Mat_Code/Analyses/SAT
% [filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
% [filename2 unit2] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
% [filename3 unit3] = textread('SAT_Vis_NoMed_S.txt','%s %s');
% [filename4 unit4] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
% filename = [filename1 ; filename2 ; filename3 ; filename4];
% unit = [unit1 ; unit2 ; unit3 ; unit4];

[filename1 unit1] = textread('SAT2_SEF_Vis_NoMed_D.txt','%s %s');
[filename2 unit2] = textread('SAT2_SEF_VisMove_NoMed_D.txt','%s %s');
[filename3 unit3] = textread('SAT2_SEF_Vis_NoMed_E.txt','%s %s');
[filename4 unit4] = textread('SAT2_SEF_VisMove_NoMed_E.txt','%s %s');
filename = [filename1 ; filename2 ; filename3 ; filename4];
unit = [unit1 ; unit2 ; unit3 ; unit4];

%change to longBase directory
cd /volumes/Dump/Search_Data_SAT_longBase


for file = 1:length(filename)
    
    load(filename{file},unit{file},'Target_','SAT_')
    filename{file}
    
    sig = eval(unit{file});
    
    blk_switch = find(abs(diff(SAT_(:,1))) ~= 0) + 1;
    
    %find corresponding conditions
    fast_to_slow = blk_switch(find(SAT_(blk_switch-1,1) == 3 & SAT_(blk_switch,1) == 1));
    slow_to_fast = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 3));
    
    slow_to_med = blk_switch(find(SAT_(blk_switch-1,1) == 1 & SAT_(blk_switch,1) == 2));
    
    if ~isempty(slow_to_med)
        med_included = 1;
    else
        med_included = 0;
    end
    
    med_to_fast = blk_switch(find(SAT_(blk_switch-1,1) == 2 & SAT_(blk_switch,1) == 3));
    
    
    SDF = sSDF(sig,Target_(:,1)-2000,[-2000 4000]);
    SDF = normalize_SP(SDF); %normalize to max of mean firing rate
    
    
    allSDF.fast_to_slow(file,:) = nanmean(SDF(fast_to_slow,:));
    allSDF.slow_to_fast(file,:) = nanmean(SDF(slow_to_fast,:));
    
    keep filename unit file allSDF
    
end

figure
plot(-2500:2500,nanmean(allSDF.slow_to_fast),'r',-2500:2500,nanmean(allSDF.fast_to_slow),'g')
xlim([-2400 2500])