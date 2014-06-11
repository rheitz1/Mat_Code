%Compile Fano Factor analyses computed on ACCRE
%
% 'shortest','middle', and 'longest' refer to length of fixation hold times

cd /volumes/Dump/Analyses/Baseline/Fano/SAT/

%file_list = dir('S*.mat');

file_list1 = dir('D*SEARCH*.mat');
file_list2 = dir('E*SEARCH*.mat');
file_list3 = dir('S*SEARCH*.mat');
file_list4 = dir('Q*SEARCH*.mat');
file_list = [file_list1 ; file_list2 ; file_list3 ; file_list4];


plotFlag = 0;

for sess = 1:length(file_list);
    file_list(sess).name
    load(file_list(sess).name)
    
    
    
    %All files have these
    
    allACCs.all(sess,1) = allACC.all;
    allACCs.all_shortest(sess,1) = allACC.all_shortest;
    allACCs.all_middle(sess,1) = allACC.all_middle;
    allACCs.all_longest(sess,1) = allACC.all_longest;
    
    allRTs.all(sess,1) = allRT.all;
    allRTs.all_shortest(sess,1) = allRT.all_shortest;
    allRTs.all_middle(sess,1) = allRT.all_middle;
    allRTs.all_longest(sess,1) = allRT.all_longest;
    
    allSDFs_targ.all(sess,:) = allSDF_targ.all;
    allSDFs_targ.all_shortest(sess,:) = allSDF_targ.all_shortest;
    allSDFs_targ.all_middle(sess,:) = allSDF_targ.all_middle;
    allSDFs_targ.all_longest(sess,:) = allSDF_targ.all_longest;
    
    allSDFs_fix.all(sess,:) = allSDF_fix.all;
    allSDFs_fix.all_shortest(sess,:) = allSDF_fix.all_shortest;
    allSDFs_fix.all_middle(sess,:) = allSDF_fix.all_middle;
    allSDFs_fix.all_longest(sess,:) = allSDF_fix.all_longest;
    
    allFano_targ.all(sess,:) = Fano_targ.all;
    allFano_targ.all_shortest(sess,:) = Fano_targ.all_shortest;
    allFano_targ.all_middle(sess,:) = Fano_targ.all_middle;
    allFano_targ.all_longest(sess,:) = Fano_targ.all_longest;
    
    allFano_fix.all(sess,:) = Fano_fix.all;
    allFano_fix.all_shortest(sess,:) = Fano_fix.all_shortest;
    allFano_fix.all_middle(sess,:) = Fano_fix.all_middle;
    allFano_fix.all_longest(sess,:) = Fano_fix.all_longest;
    
    
    % ERROR TRIALS: ADDED LATER. GROUP TOGETHER FOR EASIER COMMENTING-OUT
    if exist('allSDFs_targ.err')
        allSDFs_targ.err(sess,:) = allSDF_targ.err;
        allSDFs_fix.err(sess,:) = allSDF_fix.err;
        allFano_targ.err(sess,:) = Fano_targ.err;
        allFano_fix.err(sess,:) = Fano_fix.err;
    else
        allSDFs_targ.err(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allSDFs_fix.err(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allFano_targ.err(sess,1:length(real_time_targ)) = NaN;
        allFano_fix.err(sess,1:length(real_time_fix)) = NaN;
    end
    
    
    
    % For sessions with Tempo-estimated fixation acquire time
    if exist('Fano_fixAcq')
        allSDFs_fixAcq.all(sess,:) = allSDF_fixAcq.all;
        allSDFs_fixAcq.all_shortest(sess,:) = allSDF_fixAcq.all_shortest;
        allSDFs_fixAcq.all_middle(sess,:) = allSDF_fixAcq.all_middle;
        allSDFs_fixAcq.all_longest(sess,:) = allSDF_fixAcq.all_longest;
        
        allFano_fixAcq.all(sess,:) = Fano_fixAcq.all;
        allFano_fixAcq.all_shortest(sess,:) = Fano_fixAcq.all_shortest;
        allFano_fixAcq.all_middle(sess,:) = Fano_fixAcq.all_middle;
        allFano_fixAcq.all_longest(sess,:) = Fano_fixAcq.all_longest;
    else
        allSDFs_fixAcq.all(sess,1:size(allSDFs_fix.all,2)) = NaN;
        allSDFs_fixAcq.all_shortest(sess,1:size(allSDFs_fix.all,2)) = NaN;
        allSDFs_fixAcq.all_middle(sess,1:size(allSDFs_fix.all,2)) = NaN;
        allSDFs_fixAcq.all_longest(sess,1:size(allSDFs_fix.all,2)) = NaN;
        
        allFano_fixAcq.all(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq.all_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq.all_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq.all_longest(sess,1:length(real_time_fix)) = NaN;
    end
    
    if exist('allACC_RTntile')
        allACCs_RTntile.fastest(sess,1) = allACC_RTntile.fastest;
        allACCs_RTntile.middle(sess,1) = allACC_RTntile.middle;
        allACCs_RTntile.slowest(sess,1) = allACC_RTntile.slowest;
        
        allFano_by_RT_targ.fastest(sess,:) = Fano_by_RT_targ.fastest;
        allFano_by_RT_targ.middle(sess,:) = Fano_by_RT_targ.middle;
        allFano_by_RT_targ.slowest(sess,:) = Fano_by_RT_targ.slowest;
        
        
        allFano_by_RT_fix.fastest(sess,:) = Fano_by_RT_fix.fastest;
        allFano_by_RT_fix.middle(sess,:) = Fano_by_RT_fix.middle;
        allFano_by_RT_fix.slowest(sess,:) = Fano_by_RT_fix.slowest;
        
        allSDFs_by_RT_fix.fastest(sess,:) = allSDF_by_RT_fix.fastest;
        allSDFs_by_RT_fix.middle(sess,:) = allSDF_by_RT_fix.middle;
        allSDFs_by_RT_fix.slowest(sess,:) = allSDF_by_RT_fix.slowest;
        
        allSDFs_by_RT_targ.fastest(sess,:) = allSDF_by_RT_targ.fastest;
        allSDFs_by_RT_targ.middle(sess,:) = allSDF_by_RT_targ.middle;
        allSDFs_by_RT_targ.slowest(sess,:) = allSDF_by_RT_targ.slowest;
        
    else
        allACCs_RTntile.fastest(sess,1) = NaN;
        allACCs_RTntile.middle(sess,1) = NaN;
        allACCs_RTntile.slowest(sess,1) = NaN;
        
        allFano_by_RT_targ.fastest(sess,1:length(real_time_targ)) = NaN;
        allFano_by_RT_targ.middle(sess,1:length(real_time_targ)) = NaN;
        allFano_by_RT_targ.slowest(sess,1:length(real_time_targ)) = NaN;
        
        allFano_by_RT_fix.fastest(sess,1:length(real_time_fix)) = NaN;
        allFano_by_RT_fix.middle(sess,1:length(real_time_fix)) = NaN;
        allFano_by_RT_fix.slowest(sess,1:length(real_time_fix)) = NaN;
        
        
        allSDFs_by_RT_fix.fastest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allSDFs_by_RT_fix.middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allSDFs_by_RT_fix.slowest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allSDFs_by_RT_targ.fastest(sess,length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allSDFs_by_RT_targ.middle(sess,length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allSDFs_by_RT_targ.slowest(sess,length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
    end
    
    
    %For SAT sessions
    if exist('Fano_targ_made_dead')
        allRTs.slow_shortest(sess,1) = allRT.slow_shortest;
        allRTs.slow_middle(sess,1) = allRT.slow_middle;
        allRTs.slow_longest(sess,1) = allRT.slow_longest;
        
        allRTs.fast_shortest(sess,1) = allRT.fast_shortest;
        allRTs.fast_middle(sess,1) = allRT.fast_middle;
        allRTs.fast_longest(sess,1) = allRT.fast_longest;
        
        allACCs.slow_shortest(sess,1) = allACC.slow_shortest;
        allACCs.slow_middle(sess,1) = allACC.slow_middle;
        allACCs.slow_longest(sess,1) = allACC.slow_longest;
        
        allACCs.fast_shortest(sess,1) = allACC.fast_shortest;
        allACCs.fast_middle(sess,1) = allACC.fast_middle;
        allACCs.fast_longest(sess,1) = allACC.fast_longest;
        
        allSDFs_targ_made_dead.all(sess,:) = allSDF_targ_made_dead.all;
        allSDFs_targ_made_dead.all_shortest(sess,:) = allSDF_targ_made_dead.all_shortest;
        allSDFs_targ_made_dead.all_middle(sess,:) = allSDF_targ_made_dead.all_middle;
        allSDFs_targ_made_dead.all_longest(sess,:) = allSDF_targ_made_dead.all_longest;
        
        allSDFs_targ_made_dead.slow(sess,:) = allSDF_targ_made_dead.slow;
        allSDFs_targ_made_dead.slow_shortest(sess,:) = allSDF_targ_made_dead.slow_shortest;
        allSDFs_targ_made_dead.slow_middle(sess,:) = allSDF_targ_made_dead.slow_middle;
        allSDFs_targ_made_dead.slow_longest(sess,:) = allSDF_targ_made_dead.slow_longest;
        
        allSDFs_targ_made_dead.fast(sess,:) = allSDF_targ_made_dead.fast;
        allSDFs_targ_made_dead.fast_shortest(sess,:) = allSDF_targ_made_dead.fast_shortest;
        allSDFs_targ_made_dead.fast_middle(sess,:) = allSDF_targ_made_dead.fast_middle;
        allSDFs_targ_made_dead.fast_longest(sess,:) = allSDF_targ_made_dead.fast_longest;
        
        allSDFs_fix_made_dead.all(sess,:) = allSDF_fix_made_dead.all;
        allSDFs_fix_made_dead.all_shortest(sess,:) = allSDF_fix_made_dead.shortest;
        allSDFs_fix_made_dead.all_middle(sess,:) = allSDF_fix_made_dead.middle;
        allSDFs_fix_made_dead.all_longest(sess,:) = allSDF_fix_made_dead.longest;
        
        allSDFs_fix_made_dead.slow(sess,:) = allSDF_fix_made_dead.slow;
        allSDFs_fix_made_dead.slow_shortest(sess,:) = allSDF_fix_made_dead.slow_shortest;
        allSDFs_fix_made_dead.slow_middle(sess,:) = allSDF_fix_made_dead.slow_middle;
        allSDFs_fix_made_dead.slow_longest(sess,:) = allSDF_fix_made_dead.slow_longest;
        
        allSDFs_fix_made_dead.fast(sess,:) = allSDF_fix_made_dead.fast;
        allSDFs_fix_made_dead.fast_shortest(sess,:) = allSDF_fix_made_dead.fast_shortest;
        allSDFs_fix_made_dead.fast_middle(sess,:) = allSDF_fix_made_dead.fast_middle;
        allSDFs_fix_made_dead.fast_longest(sess,:) = allSDF_fix_made_dead.fast_longest;
        
        
        allFano_fix_made_dead.all(sess,:) = Fano_fix_made_dead.all;
        allFano_fix_made_dead.all_shortest(sess,:) = Fano_fix_made_dead.all_shortest;
        allFano_fix_made_dead.all_middle(sess,:) = Fano_fix_made_dead.all_middle;
        allFano_fix_made_dead.all_longest(sess,:) = Fano_fix_made_dead.all_longest;
        
        allFano_fix_made_dead.slow(sess,:) = Fano_fix_made_dead.slow;
        allFano_fix_made_dead.slow_shortest(sess,:) = Fano_fix_made_dead.slow_shortest;
        allFano_fix_made_dead.slow_middle(sess,:) = Fano_fix_made_dead.slow_middle;
        allFano_fix_made_dead.slow_longest(sess,:) = Fano_fix_made_dead.slow_longest;
        
        allFano_fix_made_dead.fast(sess,:) = Fano_fix_made_dead.fast;
        allFano_fix_made_dead.fast_shortest(sess,:) = Fano_fix_made_dead.fast_shortest;
        allFano_fix_made_dead.fast_middle(sess,:) = Fano_fix_made_dead.fast_middle;
        allFano_fix_made_dead.fast_longest(sess,:) = Fano_fix_made_dead.fast_longest;
        
        
        allFano_targ_made_dead.all(sess,:) = Fano_targ_made_dead.all;
        allFano_targ_made_dead.all_shortest(sess,:) = Fano_targ_made_dead.all_shortest;
        allFano_targ_made_dead.all_middle(sess,:) = Fano_targ_made_dead.all_middle;
        allFano_targ_made_dead.all_longest(sess,:) = Fano_targ_made_dead.all_longest;
        
        allFano_targ_made_dead.slow(sess,:) = Fano_targ_made_dead.slow;
        allFano_targ_made_dead.slow_shortest(sess,:) = Fano_targ_made_dead.slow_shortest;
        allFano_targ_made_dead.slow_middle(sess,:) = Fano_targ_made_dead.slow_middle;
        allFano_targ_made_dead.slow_longest(sess,:) = Fano_targ_made_dead.slow_longest;
        
        allFano_targ_made_dead.fast(sess,:) = Fano_targ_made_dead.fast;
        allFano_targ_made_dead.fast_shortest(sess,:) = Fano_targ_made_dead.fast_shortest;
        allFano_targ_made_dead.fast_middle(sess,:) = Fano_targ_made_dead.fast_middle;
        allFano_targ_made_dead.fast_longest(sess,:) = Fano_targ_made_dead.fast_longest;
        
        
    else
        
        allRTs.slow_shortest(sess,1) = NaN;
        allRTs.slow_middle(sess,1) = NaN;
        allRTs.slow_longest(sess,1) = NaN;
        
        allRTs.fast_shortest(sess,1) = NaN;
        allRTs.fast_middle(sess,1) = NaN;
        allRTs.fast_longest(sess,1) = NaN;
        
        allACCs.slow_shortest(sess,1) = NaN;
        allACCs.slow_middle(sess,1) = NaN;
        allACCs.slow_longest(sess,1) = NaN;
        
        allACCs.fast_shortest(sess,1) = NaN;
        allACCs.fast_middle(sess,1) = NaN;
        allACCs.fast_longest(sess,1) = NaN;
        
        
        allSDFs_targ_made_dead.all(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_made_dead.all_shortest(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_made_dead.all_middle(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_made_dead.all_longest(sess,1:size(allSDF_targ.all,2)) = NaN;
        
        allSDFs_targ_made_dead.slow(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_made_dead.slow_shortest(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_made_dead.slow_middle(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_made_dead.slow_longest(sess,1:size(allSDF_targ.all,2)) = NaN;
        
        allSDFs_targ_made_dead.fast(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_made_dead.fast_shortest(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_made_dead.fast_middle(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_made_dead.fast_longest(sess,1:size(allSDF_targ.all,2)) = NaN;
        
        
        allSDFs_fix_made_dead.all(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_made_dead.all_shortest(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_made_dead.all_middle(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_made_dead.all_longest(sess,1:size(allSDF_fix.all,2)) = NaN;
        
        allSDFs_fix_made_dead.slow(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_made_dead.slow_shortest(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_made_dead.slow_middle(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_made_dead.slow_longest(sess,1:size(allSDF_fix.all,2)) = NaN;
        
        allSDFs_fix_made_dead.fast(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_made_dead.fast_shortest(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_made_dead.fast_middle(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_made_dead.fast_longest(sess,1:size(allSDF_fix.all,2)) = NaN;
        
        
        
        
        allFano_fix_made_dead.all(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_made_dead.all_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_made_dead.all_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_made_dead.all_longest(sess,1:length(real_time_fix)) = NaN;
        
        allFano_fix_made_dead.slow(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_made_dead.slow_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_made_dead.slow_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_made_dead.slow_longest(sess,1:length(real_time_fix)) = NaN;
        
        allFano_fix_made_dead.fast(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_made_dead.fast_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_made_dead.fast_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_made_dead.fast_longest(sess,1:length(real_time_fix)) = NaN;
        
        
        allFano_targ_made_dead.all(sess,1:length(real_time_targ)) = NaN;
        allFano_targ_made_dead.all_shortest(sess,1:length(real_time_targ)) = NaN;
        allFano_targ_made_dead.all_middle(sess,1:length(real_time_targ)) = NaN;
        allFano_targ_made_dead.all_longest(sess,1:length(real_time_targ)) = NaN;
        
        allFano_targ_made_dead.slow(sess,1:length(real_time_targ)) = NaN;
        allFano_targ_made_dead.slow_shortest(sess,1:length(real_time_targ)) = NaN;
        allFano_targ_made_dead.slow_middle(sess,1:length(real_time_targ)) = NaN;
        allFano_targ_made_dead.slow_longest(sess,1:length(real_time_targ)) = NaN;
        
        allFano_targ_made_dead.fast(sess,1:length(real_time_targ)) = NaN;
        allFano_targ_made_dead.fast_shortest(sess,1:length(real_time_targ)) = NaN;
        allFano_targ_made_dead.fast_middle(sess,1:length(real_time_targ)) = NaN;
        allFano_targ_made_dead.fast_longest(sess,1:length(real_time_targ)) = NaN;
        
    end
    
    
    %For SAT sessions with Tempo-estimated fixation acquire time
    if exist('Fano_fixAcq_made_dead')
        
        allSDFs_fixAcq_made_dead.all(sess,:) = allSDF_fixAcq_made_dead.all;
        allSDFs_fixAcq_made_dead.all_shortest(sess,:) = allSDF_fixAcq_made_dead.shortest;
        allSDFs_fixAcq_made_dead.all_middle(sess,:) = allSDF_fixAcq_made_dead.middle;
        allSDFs_fixAcq_made_dead.all_longest(sess,:) = allSDF_fixAcq_made_dead.longest;
        
        allSDFs_fixAcq_made_dead.slow(sess,:) = allSDF_fixAcq_made_dead.slow;
        allSDFs_fixAcq_made_dead.slow_shortest(sess,:) = allSDF_fixAcq_made_dead.slow_shortest;
        allSDFs_fixAcq_made_dead.slow_middle(sess,:) = allSDF_fixAcq_made_dead.slow_middle;
        allSDFs_fixAcq_made_dead.slow_longest(sess,:) = allSDF_fixAcq_made_dead.slow_longest;
        
        allSDFs_fixAcq_made_dead.fast(sess,:) = allSDF_fixAcq_made_dead.fast;
        allSDFs_fixAcq_made_dead.fast_shortest(sess,:) = allSDF_fixAcq_made_dead.fast_shortest;
        allSDFs_fixAcq_made_dead.fast_middle(sess,:) = allSDF_fixAcq_made_dead.fast_middle;
        allSDFs_fixAcq_made_dead.fast_longest(sess,:) = allSDF_fixAcq_made_dead.fast_longest;
        
        
        
        
        allFano_fixAcq_made_dead.all(sess,:) = Fano_fixAcq_made_dead.all;
        allFano_fixAcq_made_dead.all_shortest(sess,:) = Fano_fixAcq_made_dead.all_shortest;
        allFano_fixAcq_made_dead.all_middle(sess,:) = Fano_fixAcq_made_dead.all_middle;
        allFano_fixAcq_made_dead.all_longest(sess,:) = Fano_fixAcq_made_dead.all_longest;
        
        allFano_fixAcq_made_dead.slow(sess,:) = Fano_fixAcq_made_dead.slow;
        allFano_fixAcq_made_dead.slow_shortest(sess,:) = Fano_fixAcq_made_dead.slow_shortest;
        allFano_fixAcq_made_dead.slow_middle(sess,:) = Fano_fixAcq_made_dead.slow_middle;
        allFano_fixAcq_made_dead.slow_longest(sess,:) = Fano_fixAcq_made_dead.slow_longest;
        
        allFano_fixAcq_made_dead.fast(sess,:) = Fano_fixAcq_made_dead.fast;
        allFano_fixAcq_made_dead.fast_shortest(sess,:) = Fano_fixAcq_made_dead.fast_shortest;
        allFano_fixAcq_made_dead.fast_middle(sess,:) = Fano_fixAcq_made_dead.fast_middle;
        allFano_fixAcq_made_dead.fast_longest(sess,:) = Fano_fixAcq_made_dead.fast_longest;
        
    elseif exist('Fano_targ_made_dead')
        
        allSDFs_fixAcq_made_dead.all(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        allSDFs_fixAcq_made_dead.all_shortest(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        allSDFs_fixAcq_made_dead.all_middle(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        allSDFs_fixAcq_made_dead.all_longest(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        
        allSDFs_fixAcq_made_dead.slow(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        allSDFs_fixAcq_made_dead.slow_shortest(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        allSDFs_fixAcq_made_dead.slow_middle(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        allSDFs_fixAcq_made_dead.slow_longest(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        
        allSDFs_fixAcq_made_dead.fast(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        allSDFs_fixAcq_made_dead.fast_shortest(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        allSDFs_fixAcq_made_dead.fast_middle(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        allSDFs_fixAcq_made_dead.fast_longest(sess,1:size(allSDF_fix_made_dead.all,2)) = NaN;
        
        allFano_fixAcq_made_dead.all(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_made_dead.all_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_made_dead.all_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_made_dead.all_longest(sess,1:length(real_time_fix)) = NaN;
        
        allFano_fixAcq_made_dead.slow(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_made_dead.slow_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_made_dead.slow_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_made_dead.slow_longest(sess,1:length(real_time_fix)) = NaN;
        
        allFano_fixAcq_made_dead.fast(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_made_dead.fast_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_made_dead.fast_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_made_dead.fast_longest(sess,1:length(real_time_fix)) = NaN;
        
    end
    
    
    
    %For SAT sessions
    if exist('Fano_targ_missed_dead')
        allRTs.slow_shortest(sess,1) = allRT.slow_shortest;
        allRTs.slow_middle(sess,1) = allRT.slow_middle;
        allRTs.slow_longest(sess,1) = allRT.slow_longest;
        
        allRTs.fast_shortest(sess,1) = allRT.fast_shortest;
        allRTs.fast_middle(sess,1) = allRT.fast_middle;
        allRTs.fast_longest(sess,1) = allRT.fast_longest;
        
        allACCs.slow_shortest(sess,1) = allACC.slow_shortest;
        allACCs.slow_middle(sess,1) = allACC.slow_middle;
        allACCs.slow_longest(sess,1) = allACC.slow_longest;
        
        allACCs.fast_shortest(sess,1) = allACC.fast_shortest;
        allACCs.fast_middle(sess,1) = allACC.fast_middle;
        allACCs.fast_longest(sess,1) = allACC.fast_longest;
        
        allSDFs_targ_missed_dead.all(sess,:) = allSDF_targ_missed_dead.all;
        allSDFs_targ_missed_dead.all_shortest(sess,:) = allSDF_targ_missed_dead.all_shortest;
        allSDFs_targ_missed_dead.all_middle(sess,:) = allSDF_targ_missed_dead.all_middle;
        allSDFs_targ_missed_dead.all_longest(sess,:) = allSDF_targ_missed_dead.all_longest;
        
        allSDFs_targ_missed_dead.slow(sess,:) = allSDF_targ_missed_dead.slow;
        allSDFs_targ_missed_dead.slow_shortest(sess,:) = allSDF_targ_missed_dead.slow_shortest;
        allSDFs_targ_missed_dead.slow_middle(sess,:) = allSDF_targ_missed_dead.slow_middle;
        allSDFs_targ_missed_dead.slow_longest(sess,:) = allSDF_targ_missed_dead.slow_longest;
        
        allSDFs_targ_missed_dead.fast(sess,:) = allSDF_targ_missed_dead.fast;
        allSDFs_targ_missed_dead.fast_shortest(sess,:) = allSDF_targ_missed_dead.fast_shortest;
        allSDFs_targ_missed_dead.fast_middle(sess,:) = allSDF_targ_missed_dead.fast_middle;
        allSDFs_targ_missed_dead.fast_longest(sess,:) = allSDF_targ_missed_dead.fast_longest;
        
        allSDFs_fix_missed_dead.all(sess,:) = allSDF_fix_missed_dead.all;
        allSDFs_fix_missed_dead.all_shortest(sess,:) = allSDF_fix_missed_dead.shortest;
        allSDFs_fix_missed_dead.all_middle(sess,:) = allSDF_fix_missed_dead.middle;
        allSDFs_fix_missed_dead.all_longest(sess,:) = allSDF_fix_missed_dead.longest;
        
        allSDFs_fix_missed_dead.slow(sess,:) = allSDF_fix_missed_dead.slow;
        allSDFs_fix_missed_dead.slow_shortest(sess,:) = allSDF_fix_missed_dead.slow_shortest;
        allSDFs_fix_missed_dead.slow_middle(sess,:) = allSDF_fix_missed_dead.slow_middle;
        allSDFs_fix_missed_dead.slow_longest(sess,:) = allSDF_fix_missed_dead.slow_longest;
        
        allSDFs_fix_missed_dead.fast(sess,:) = allSDF_fix_missed_dead.fast;
        allSDFs_fix_missed_dead.fast_shortest(sess,:) = allSDF_fix_missed_dead.fast_shortest;
        allSDFs_fix_missed_dead.fast_middle(sess,:) = allSDF_fix_missed_dead.fast_middle;
        allSDFs_fix_missed_dead.fast_longest(sess,:) = allSDF_fix_missed_dead.fast_longest;
        
        
        allFano_fix_missed_dead.all(sess,:) = Fano_fix_missed_dead.all;
        allFano_fix_missed_dead.all_shortest(sess,:) = Fano_fix_missed_dead.all_shortest;
        allFano_fix_missed_dead.all_middle(sess,:) = Fano_fix_missed_dead.all_middle;
        allFano_fix_missed_dead.all_longest(sess,:) = Fano_fix_missed_dead.all_longest;
        
        allFano_fix_missed_dead.slow(sess,:) = Fano_fix_missed_dead.slow;
        allFano_fix_missed_dead.slow_shortest(sess,:) = Fano_fix_missed_dead.slow_shortest;
        allFano_fix_missed_dead.slow_middle(sess,:) = Fano_fix_missed_dead.slow_middle;
        allFano_fix_missed_dead.slow_longest(sess,:) = Fano_fix_missed_dead.slow_longest;
        
        allFano_fix_missed_dead.fast(sess,:) = Fano_fix_missed_dead.fast;
        allFano_fix_missed_dead.fast_shortest(sess,:) = Fano_fix_missed_dead.fast_shortest;
        allFano_fix_missed_dead.fast_middle(sess,:) = Fano_fix_missed_dead.fast_middle;
        allFano_fix_missed_dead.fast_longest(sess,:) = Fano_fix_missed_dead.fast_longest;
        
    else
        
        allRTs.slow_shortest(sess,1) = NaN;
        allRTs.slow_middle(sess,1) = NaN;
        allRTs.slow_longest(sess,1) = NaN;
        
        allRTs.fast_shortest(sess,1) = NaN;
        allRTs.fast_middle(sess,1) = NaN;
        allRTs.fast_longest(sess,1) = NaN;
        
        allACCs.slow_shortest(sess,1) = NaN;
        allACCs.slow_middle(sess,1) = NaN;
        allACCs.slow_longest(sess,1) = NaN;
        
        allACCs.fast_shortest(sess,1) = NaN;
        allACCs.fast_middle(sess,1) = NaN;
        allACCs.fast_longest(sess,1) = NaN;
        
        
        allSDFs_targ_missed_dead.all(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_missed_dead.all_shortest(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_missed_dead.all_middle(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_missed_dead.all_longest(sess,1:size(allSDF_targ.all,2)) = NaN;
        
        allSDFs_targ_missed_dead.slow(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_missed_dead.slow_shortest(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_missed_dead.slow_middle(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_missed_dead.slow_longest(sess,1:size(allSDF_targ.all,2)) = NaN;
        
        allSDFs_targ_missed_dead.fast(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_missed_dead.fast_shortest(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_missed_dead.fast_middle(sess,1:size(allSDF_targ.all,2)) = NaN;
        allSDFs_targ_missed_dead.fast_longest(sess,1:size(allSDF_targ.all,2)) = NaN;
        
        
        allSDFs_fix_missed_dead.all(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_missed_dead.all_shortest(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_missed_dead.all_middle(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_missed_dead.all_longest(sess,1:size(allSDF_fix.all,2)) = NaN;
        
        allSDFs_fix_missed_dead.slow(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_missed_dead.slow_shortest(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_missed_dead.slow_middle(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_missed_dead.slow_longest(sess,1:size(allSDF_fix.all,2)) = NaN;
        
        allSDFs_fix_missed_dead.fast(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_missed_dead.fast_shortest(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_missed_dead.fast_middle(sess,1:size(allSDF_fix.all,2)) = NaN;
        allSDFs_fix_missed_dead.fast_longest(sess,1:size(allSDF_fix.all,2)) = NaN;
        
        
        
        
        allFano_fix_missed_dead.all(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_missed_dead.all_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_missed_dead.all_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_missed_dead.all_longest(sess,1:length(real_time_fix)) = NaN;
        
        allFano_fix_missed_dead.slow(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_missed_dead.slow_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_missed_dead.slow_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_missed_dead.slow_longest(sess,1:length(real_time_fix)) = NaN;
        
        allFano_fix_missed_dead.fast(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_missed_dead.fast_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_missed_dead.fast_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fix_missed_dead.fast_longest(sess,1:length(real_time_fix)) = NaN;
        
    end
    
    
    %For SAT sessions with Tempo-estimated fixation acquire time
    if exist('Fano_fixAcq_missed_dead')
        
        allSDFs_fixAcq_missed_dead.all(sess,:) = allSDF_fixAcq_missed_dead.all;
        allSDFs_fixAcq_missed_dead.all_shortest(sess,:) = allSDF_fixAcq_missed_dead.shortest;
        allSDFs_fixAcq_missed_dead.all_middle(sess,:) = allSDF_fixAcq_missed_dead.middle;
        allSDFs_fixAcq_missed_dead.all_longest(sess,:) = allSDF_fixAcq_missed_dead.longest;
        
        allSDFs_fixAcq_missed_dead.slow(sess,:) = allSDF_fixAcq_missed_dead.slow;
        allSDFs_fixAcq_missed_dead.slow_shortest(sess,:) = allSDF_fixAcq_missed_dead.slow_shortest;
        allSDFs_fixAcq_missed_dead.slow_middle(sess,:) = allSDF_fixAcq_missed_dead.slow_middle;
        allSDFs_fixAcq_missed_dead.slow_longest(sess,:) = allSDF_fixAcq_missed_dead.slow_longest;
        
        allSDFs_fixAcq_missed_dead.fast(sess,:) = allSDF_fixAcq_missed_dead.fast;
        allSDFs_fixAcq_missed_dead.fast_shortest(sess,:) = allSDF_fixAcq_missed_dead.fast_shortest;
        allSDFs_fixAcq_missed_dead.fast_middle(sess,:) = allSDF_fixAcq_missed_dead.fast_middle;
        allSDFs_fixAcq_missed_dead.fast_longest(sess,:) = allSDF_fixAcq_missed_dead.fast_longest;
        
        
        
        
        allFano_fixAcq_missed_dead.all(sess,:) = Fano_fixAcq_missed_dead.all;
        allFano_fixAcq_missed_dead.all_shortest(sess,:) = Fano_fixAcq_missed_dead.all_shortest;
        allFano_fixAcq_missed_dead.all_middle(sess,:) = Fano_fixAcq_missed_dead.all_middle;
        allFano_fixAcq_missed_dead.all_longest(sess,:) = Fano_fixAcq_missed_dead.all_longest;
        
        allFano_fixAcq_missed_dead.slow(sess,:) = Fano_fixAcq_missed_dead.slow;
        allFano_fixAcq_missed_dead.slow_shortest(sess,:) = Fano_fixAcq_missed_dead.slow_shortest;
        allFano_fixAcq_missed_dead.slow_middle(sess,:) = Fano_fixAcq_missed_dead.slow_middle;
        allFano_fixAcq_missed_dead.slow_longest(sess,:) = Fano_fixAcq_missed_dead.slow_longest;
        
        allFano_fixAcq_missed_dead.fast(sess,:) = Fano_fixAcq_missed_dead.fast;
        allFano_fixAcq_missed_dead.fast_shortest(sess,:) = Fano_fixAcq_missed_dead.fast_shortest;
        allFano_fixAcq_missed_dead.fast_middle(sess,:) = Fano_fixAcq_missed_dead.fast_middle;
        allFano_fixAcq_missed_dead.fast_longest(sess,:) = Fano_fixAcq_missed_dead.fast_longest;
        
    elseif exist('Fano_targ_made_dead')
        
        allSDFs_fixAcq_missed_dead.all(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        allSDFs_fixAcq_missed_dead.all_shortest(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        allSDFs_fixAcq_missed_dead.all_middle(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        allSDFs_fixAcq_missed_dead.all_longest(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        
        allSDFs_fixAcq_missed_dead.slow(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        allSDFs_fixAcq_missed_dead.slow_shortest(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        allSDFs_fixAcq_missed_dead.slow_middle(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        allSDFs_fixAcq_missed_dead.slow_longest(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        
        allSDFs_fixAcq_missed_dead.fast(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        allSDFs_fixAcq_missed_dead.fast_shortest(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        allSDFs_fixAcq_missed_dead.fast_middle(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        allSDFs_fixAcq_missed_dead.fast_longest(sess,1:size(allSDF_fix_missed_dead.all,2)) = NaN;
        
        allFano_fixAcq_missed_dead.all(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_missed_dead.all_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_missed_dead.all_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_missed_dead.all_longest(sess,1:length(real_time_fix)) = NaN;
        
        allFano_fixAcq_missed_dead.slow(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_missed_dead.slow_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_missed_dead.slow_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_missed_dead.slow_longest(sess,1:length(real_time_fix)) = NaN;
        
        allFano_fixAcq_missed_dead.fast(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_missed_dead.fast_shortest(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_missed_dead.fast_middle(sess,1:length(real_time_fix)) = NaN;
        allFano_fixAcq_missed_dead.fast_longest(sess,1:length(real_time_fix)) = NaN;
        
    end
    
    
    if exist('allPupil_targ_made_dead')
        allPupils_targ_made_dead.slow(sess,:) = allPupil_targ_made_dead.slow;
        allPupils_targ_made_dead.slow_shortest(sess,:) = allPupil_targ_made_dead.slow_shortest;
        allPupils_targ_made_dead.slow_middle(sess,:) = allPupil_targ_made_dead.slow_middle;
        allPupils_targ_made_dead.slow_longest(sess,:) = allPupil_targ_made_dead.slow_longest;
        
        allPupils_targ_made_dead.fast(sess,:) = allPupil_targ_made_dead.fast;
        allPupils_targ_made_dead.fast_shortest(sess,:) = allPupil_targ_made_dead.fast_shortest;
        allPupils_targ_made_dead.fast_middle(sess,:) = allPupil_targ_made_dead.fast_middle;
        allPupils_targ_made_dead.fast_longest(sess,:) = allPupil_targ_made_dead.fast_longest;
        
        allPupils_targ_missed_dead.slow(sess,:) = allPupil_targ_missed_dead.slow;
        allPupils_targ_missed_dead.slow_shortest(sess,:) = allPupil_targ_missed_dead.slow_shortest;
        allPupils_targ_missed_dead.slow_middle(sess,:) = allPupil_targ_missed_dead.slow_middle;
        allPupils_targ_missed_dead.slow_longest(sess,:) = allPupil_targ_missed_dead.slow_longest;
        
        allPupils_targ_missed_dead.fast(sess,:) = allPupil_targ_missed_dead.fast;
        allPupils_targ_missed_dead.fast_shortest(sess,:) = allPupil_targ_missed_dead.fast_shortest;
        allPupils_targ_missed_dead.fast_middle(sess,:) = allPupil_targ_missed_dead.fast_middle;
        allPupils_targ_missed_dead.fast_longest(sess,:) = allPupil_targ_missed_dead.fast_longest;
        
        allPupils_targ_bc_made_dead.slow(sess,:) = allPupil_targ_bc_made_dead.slow;
        allPupils_targ_bc_made_dead.slow_shortest(sess,:) = allPupil_targ_bc_made_dead.slow_shortest;
        allPupils_targ_bc_made_dead.slow_middle(sess,:) = allPupil_targ_bc_made_dead.slow_middle;
        allPupils_targ_bc_made_dead.slow_longest(sess,:) = allPupil_targ_bc_made_dead.slow_longest;
        
        allPupils_targ_bc_made_dead.fast(sess,:) = allPupil_targ_bc_made_dead.fast;
        allPupils_targ_bc_made_dead.fast_shortest(sess,:) = allPupil_targ_bc_made_dead.fast_shortest;
        allPupils_targ_bc_made_dead.fast_middle(sess,:) = allPupil_targ_bc_made_dead.fast_middle;
        allPupils_targ_bc_made_dead.fast_longest(sess,:) = allPupil_targ_bc_made_dead.fast_longest;
        
        allPupils_targ_bc_missed_dead.slow(sess,:) = allPupil_targ_bc_missed_dead.slow;
        allPupils_targ_bc_missed_dead.slow_shortest(sess,:) = allPupil_targ_bc_missed_dead.slow_shortest;
        allPupils_targ_bc_missed_dead.slow_middle(sess,:) = allPupil_targ_bc_missed_dead.slow_middle;
        allPupils_targ_bc_missed_dead.slow_longest(sess,:) = allPupil_targ_bc_missed_dead.slow_longest;
        
        allPupils_targ_bc_missed_dead.fast(sess,:) = allPupil_targ_bc_missed_dead.fast;
        allPupils_targ_bc_missed_dead.fast_shortest(sess,:) = allPupil_targ_bc_missed_dead.fast_shortest;
        allPupils_targ_bc_missed_dead.fast_middle(sess,:) = allPupil_targ_bc_missed_dead.fast_middle;
        allPupils_targ_bc_missed_dead.fast_longest(sess,:) = allPupil_targ_bc_missed_dead.fast_longest;
        
        
        allPupils_fix_made_dead.slow(sess,:) = allPupil_fix_made_dead.slow;
        allPupils_fix_made_dead.slow_shortest(sess,:) = allPupil_fix_made_dead.slow_shortest;
        allPupils_fix_made_dead.slow_middle(sess,:) = allPupil_fix_made_dead.slow_middle;
        allPupils_fix_made_dead.slow_longest(sess,:) = allPupil_fix_made_dead.slow_longest;
        
        allPupils_fix_made_dead.fast(sess,:) = allPupil_fix_made_dead.fast;
        allPupils_fix_made_dead.fast_shortest(sess,:) = allPupil_fix_made_dead.fast_shortest;
        allPupils_fix_made_dead.fast_middle(sess,:) = allPupil_fix_made_dead.fast_middle;
        allPupils_fix_made_dead.fast_longest(sess,:) = allPupil_fix_made_dead.fast_longest;
        
        allPupils_fix_missed_dead.slow(sess,:) = allPupil_fix_missed_dead.slow;
        allPupils_fix_missed_dead.slow_shortest(sess,:) = allPupil_fix_missed_dead.slow_shortest;
        allPupils_fix_missed_dead.slow_middle(sess,:) = allPupil_fix_missed_dead.slow_middle;
        allPupils_fix_missed_dead.slow_longest(sess,:) = allPupil_fix_missed_dead.slow_longest;
        
        allPupils_fix_missed_dead.fast(sess,:) = allPupil_fix_missed_dead.fast;
        allPupils_fix_missed_dead.fast_shortest(sess,:) = allPupil_fix_missed_dead.fast_shortest;
        allPupils_fix_missed_dead.fast_middle(sess,:) = allPupil_fix_missed_dead.fast_middle;
        allPupils_fix_missed_dead.fast_longest(sess,:) = allPupil_fix_missed_dead.fast_longest;
        
        allPupils_fix_bc_made_dead.slow(sess,:) = allPupil_fix_bc_made_dead.slow;
        allPupils_fix_bc_made_dead.slow_shortest(sess,:) = allPupil_fix_bc_made_dead.slow_shortest;
        allPupils_fix_bc_made_dead.slow_middle(sess,:) = allPupil_fix_bc_made_dead.slow_middle;
        allPupils_fix_bc_made_dead.slow_longest(sess,:) = allPupil_fix_bc_made_dead.slow_longest;
        
        allPupils_fix_bc_made_dead.fast(sess,:) = allPupil_fix_bc_made_dead.fast;
        allPupils_fix_bc_made_dead.fast_shortest(sess,:) = allPupil_fix_bc_made_dead.fast_shortest;
        allPupils_fix_bc_made_dead.fast_middle(sess,:) = allPupil_fix_bc_made_dead.fast_middle;
        allPupils_fix_bc_made_dead.fast_longest(sess,:) = allPupil_fix_bc_made_dead.fast_longest;
        
        allPupils_fix_bc_missed_dead.slow(sess,:) = allPupil_fix_bc_missed_dead.slow;
        allPupils_fix_bc_missed_dead.slow_shortest(sess,:) = allPupil_fix_bc_missed_dead.slow_shortest;
        allPupils_fix_bc_missed_dead.slow_middle(sess,:) = allPupil_fix_bc_missed_dead.slow_middle;
        allPupils_fix_bc_missed_dead.slow_longest(sess,:) = allPupil_fix_bc_missed_dead.slow_longest;
        
        allPupils_fix_bc_missed_dead.fast(sess,:) = allPupil_fix_bc_missed_dead.fast;
        allPupils_fix_bc_missed_dead.fast_shortest(sess,:) = allPupil_fix_bc_missed_dead.fast_shortest;
        allPupils_fix_bc_missed_dead.fast_middle(sess,:) = allPupil_fix_bc_missed_dead.fast_middle;
        allPupils_fix_bc_missed_dead.fast_longest(sess,:) = allPupil_fix_bc_missed_dead.fast_longest;
        
        if exist('allPupil_fixAcq_made_dead')
            allPupils_fixAcq_made_dead.slow(sess,:) = allPupil_fixAcq_made_dead.slow;
            allPupils_fixAcq_made_dead.slow_shortest(sess,:) = allPupil_fixAcq_made_dead.slow_shortest;
            allPupils_fixAcq_made_dead.slow_middle(sess,:) = allPupil_fixAcq_made_dead.slow_middle;
            allPupils_fixAcq_made_dead.slow_longest(sess,:) = allPupil_fixAcq_made_dead.slow_longest;
            
            allPupils_fixAcq_made_dead.fast(sess,:) = allPupil_fixAcq_made_dead.fast;
            allPupils_fixAcq_made_dead.fast_shortest(sess,:) = allPupil_fixAcq_made_dead.fast_shortest;
            allPupils_fixAcq_made_dead.fast_middle(sess,:) = allPupil_fixAcq_made_dead.fast_middle;
            allPupils_fixAcq_made_dead.fast_longest(sess,:) = allPupil_fixAcq_made_dead.fast_longest;
            
            allPupils_fixAcq_missed_dead.slow(sess,:) = allPupil_fixAcq_missed_dead.slow;
            allPupils_fixAcq_missed_dead.slow_shortest(sess,:) = allPupil_fixAcq_missed_dead.slow_shortest;
            allPupils_fixAcq_missed_dead.slow_middle(sess,:) = allPupil_fixAcq_missed_dead.slow_middle;
            allPupils_fixAcq_missed_dead.slow_longest(sess,:) = allPupil_fixAcq_missed_dead.slow_longest;
            
            allPupils_fixAcq_missed_dead.fast(sess,:) = allPupil_fixAcq_missed_dead.fast;
            allPupils_fixAcq_missed_dead.fast_shortest(sess,:) = allPupil_fixAcq_missed_dead.fast_shortest;
            allPupils_fixAcq_missed_dead.fast_middle(sess,:) = allPupil_fixAcq_missed_dead.fast_middle;
            allPupils_fixAcq_missed_dead.fast_longest(sess,:) = allPupil_fixAcq_missed_dead.fast_longest;
            
            allPupils_fixAcq_bc_made_dead.slow(sess,:) = allPupil_fixAcq_bc_made_dead.slow;
            allPupils_fixAcq_bc_made_dead.slow_shortest(sess,:) = allPupil_fixAcq_bc_made_dead.slow_shortest;
            allPupils_fixAcq_bc_made_dead.slow_middle(sess,:) = allPupil_fixAcq_bc_made_dead.slow_middle;
            allPupils_fixAcq_bc_made_dead.slow_longest(sess,:) = allPupil_fixAcq_bc_made_dead.slow_longest;
            
            allPupils_fixAcq_bc_made_dead.fast(sess,:) = allPupil_fixAcq_bc_made_dead.fast;
            allPupils_fixAcq_bc_made_dead.fast_shortest(sess,:) = allPupil_fixAcq_bc_made_dead.fast_shortest;
            allPupils_fixAcq_bc_made_dead.fast_middle(sess,:) = allPupil_fixAcq_bc_made_dead.fast_middle;
            allPupils_fixAcq_bc_made_dead.fast_longest(sess,:) = allPupil_fixAcq_bc_made_dead.fast_longest;
            
            allPupils_fixAcq_bc_missed_dead.slow(sess,:) = allPupil_fixAcq_bc_missed_dead.slow;
            allPupils_fixAcq_bc_missed_dead.slow_shortest(sess,:) = allPupil_fixAcq_bc_missed_dead.slow_shortest;
            allPupils_fixAcq_bc_missed_dead.slow_middle(sess,:) = allPupil_fixAcq_bc_missed_dead.slow_middle;
            allPupils_fixAcq_bc_missed_dead.slow_longest(sess,:) = allPupil_fixAcq_bc_missed_dead.slow_longest;
            
            allPupils_fixAcq_bc_missed_dead.fast(sess,:) = allPupil_fixAcq_bc_missed_dead.fast;
            allPupils_fixAcq_bc_missed_dead.fast_shortest(sess,:) = allPupil_fixAcq_bc_missed_dead.fast_shortest;
            allPupils_fixAcq_bc_missed_dead.fast_middle(sess,:) = allPupil_fixAcq_bc_missed_dead.fast_middle;
            allPupils_fixAcq_bc_missed_dead.fast_longest(sess,:) = allPupil_fixAcq_bc_missed_dead.fast_longest;
        end
    else
        allPupils_targ_made_dead.slow(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_made_dead.slow_shortest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_made_dead.slow_middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_made_dead.slow_longest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allPupils_targ_made_dead.fast(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_made_dead.fast_shortest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_made_dead.fast_middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_made_dead.fast_longest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allPupils_targ_missed_dead.slow(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_missed_dead.slow_shortest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_missed_dead.slow_middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_missed_dead.slow_longest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allPupils_targ_missed_dead.fast(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_missed_dead.fast_shortest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_missed_dead.fast_middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_missed_dead.fast_longest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allPupils_targ_bc_made_dead.slow(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_made_dead.slow_shortest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_made_dead.slow_middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_made_dead.slow_longest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allPupils_targ_bc_made_dead.fast(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_made_dead.fast_shortest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_made_dead.fast_middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_made_dead.fast_longest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allPupils_targ_bc_missed_dead.slow(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_missed_dead.slow_shortest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_missed_dead.slow_middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_missed_dead.slow_longest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allPupils_targ_bc_missed_dead.fast(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_missed_dead.fast_shortest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_missed_dead.fast_middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_targ_bc_missed_dead.fast_longest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allPupils_fix_made_dead.slow(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_made_dead.slow_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_made_dead.slow_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_made_dead.slow_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fix_made_dead.fast(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_made_dead.fast_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_made_dead.fast_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_made_dead.fast_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fix_missed_dead.slow(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_missed_dead.slow_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_missed_dead.slow_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_missed_dead.slow_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fix_missed_dead.fast(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_missed_dead.fast_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_missed_dead.fast_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_missed_dead.fast_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fix_bc_made_dead.slow(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_made_dead.slow_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_made_dead.slow_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_made_dead.slow_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fix_bc_made_dead.fast(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_made_dead.fast_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_made_dead.fast_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_made_dead.fast_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fix_bc_missed_dead.slow(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_missed_dead.slow_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_missed_dead.slow_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_missed_dead.slow_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fix_bc_missed_dead.fast(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_missed_dead.fast_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_missed_dead.fast_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fix_bc_missed_dead.fast_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fixAcq_made_dead.slow(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_made_dead.slow_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_made_dead.slow_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_made_dead.slow_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fixAcq_made_dead.fast(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_made_dead.fast_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_made_dead.fast_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_made_dead.fast_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fixAcq_missed_dead.slow(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_missed_dead.slow_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_missed_dead.slow_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_missed_dead.slow_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fixAcq_missed_dead.fast(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_missed_dead.fast_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_missed_dead.fast_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_missed_dead.fast_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fixAcq_bc_made_dead.slow(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_made_dead.slow_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_made_dead.slow_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_made_dead.slow_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fixAcq_bc_made_dead.fast(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_made_dead.fast_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_made_dead.fast_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_made_dead.fast_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fixAcq_bc_missed_dead.slow(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_missed_dead.slow_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_missed_dead.slow_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_missed_dead.slow_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_fixAcq_bc_missed_dead.fast(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_missed_dead.fast_shortest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_missed_dead.fast_middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_fixAcq_bc_missed_dead.fast_longest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
    end
    
    
    if exist('allSDF_by_RT_fix_ACC')
        allSDFs_by_RT_fix_ACC.fastest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allSDF_by_RT_fix_ACC.fastest;
        allSDFs_by_RT_fix_ACC.middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allSDF_by_RT_fix_ACC.middle;
        allSDFs_by_RT_fix_ACC.slowest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allSDF_by_RT_fix_ACC.slowest;
        
        allSDFs_by_RT_fix_FAST.fastest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allSDF_by_RT_fix_FAST.fastest;
        allSDFs_by_RT_fix_FAST.middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allSDF_by_RT_fix_FAST.middle;
        allSDFs_by_RT_fix_FAST.slowest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allSDF_by_RT_fix_FAST.slowest;
        
        allSDFs_by_RT_targ_ACC.fastest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allSDF_by_RT_targ_ACC.fastest;
        allSDFs_by_RT_targ_ACC.middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allSDF_by_RT_targ_ACC.middle;
        allSDFs_by_RT_targ_ACC.slowest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allSDF_by_RT_targ_ACC.slowest;
        
        allSDFs_by_RT_targ_FAST.fastest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allSDF_by_RT_targ_FAST.fastest;
        allSDFs_by_RT_targ_FAST.middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allSDF_by_RT_targ_FAST.middle;
        allSDFs_by_RT_targ_FAST.slowest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allSDF_by_RT_targ_FAST.slowest;
        
        
        allFano_by_RT_fix_ACC.fastest(sess,1:length(real_time_fix)) = Fano_by_RT_fix_ACC.fastest;
        allFano_by_RT_fix_ACC.middle(sess,1:length(real_time_fix)) = Fano_by_RT_fix_ACC.middle;
        allFano_by_RT_fix_ACC.slowest(sess,1:length(real_time_fix)) = Fano_by_RT_fix_ACC.slowest;
        
        allFano_by_RT_fix_FAST.fastest(sess,1:length(real_time_fix)) = Fano_by_RT_fix_FAST.fastest;
        allFano_by_RT_fix_FAST.middle(sess,1:length(real_time_fix)) = Fano_by_RT_fix_FAST.middle;
        allFano_by_RT_fix_FAST.slowest(sess,1:length(real_time_fix)) = Fano_by_RT_fix_FAST.slowest;
        
        
        allFano_by_RT_targ_ACC.fastest(sess,1:length(real_time_targ)) = Fano_by_RT_targ_ACC.fastest;
        allFano_by_RT_targ_ACC.middle(sess,1:length(real_time_targ)) = Fano_by_RT_targ_ACC.middle;
        allFano_by_RT_targ_ACC.slowest(sess,1:length(real_time_targ)) = Fano_by_RT_targ_ACC.slowest;
        
        allFano_by_RT_targ_FAST.fastest(sess,1:length(real_time_targ)) = Fano_by_RT_targ_FAST.fastest;
        allFano_by_RT_targ_FAST.middle(sess,1:length(real_time_targ)) = Fano_by_RT_targ_FAST.middle;
        allFano_by_RT_targ_FAST.slowest(sess,1:length(real_time_targ)) = Fano_by_RT_targ_FAST.slowest;
        
    else
        allSDFs_by_RT_fix_ACC.fastest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allSDFs_by_RT_fix_ACC.middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allSDFs_by_RT_fix_ACC.slowest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allSDFs_by_RT_fix_FAST.fastest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allSDFs_by_RT_fix_FAST.middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allSDFs_by_RT_fix_FAST.slowest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allSDFs_by_RT_targ_ACC.fastest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allSDFs_by_RT_targ_ACC.middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allSDFs_by_RT_targ_ACC.slowest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allSDFs_by_RT_targ_FAST.fastest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allSDFs_by_RT_targ_FAST.middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allSDFs_by_RT_targ_FAST.slowest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        
        allFano_by_RT_fix_ACC.fastest(sess,1:length(real_time_fix)) = NaN;
        allFano_by_RT_fix_ACC.middle(sess,1:length(real_time_fix)) = NaN;
        allFano_by_RT_fix_ACC.slowest(sess,1:length(real_time_fix)) = NaN;
        
        allFano_by_RT_fix_FAST.fastest(sess,1:length(real_time_fix)) = NaN;
        allFano_by_RT_fix_FAST.middle(sess,1:length(real_time_fix)) = NaN;
        allFano_by_RT_fix_FAST.slowest(sess,1:length(real_time_fix)) = NaN;
        
        
        allFano_by_RT_targ_ACC.fastest(sess,1:length(real_time_targ)) = NaN;
        allFano_by_RT_targ_ACC.middle(sess,1:length(real_time_targ)) = NaN;
        allFano_by_RT_targ_ACC.slowest(sess,1:length(real_time_targ)) = NaN;
        
        allFano_by_RT_targ_FAST.fastest(sess,1:length(real_time_targ)) = NaN;
        allFano_by_RT_targ_FAST.middle(sess,1:length(real_time_targ)) = NaN;
        allFano_by_RT_targ_FAST.slowest(sess,1:length(real_time_targ)) = NaN;
        
    end
    
    
    if exist('allPupil_by_RT_fix_ACC_bc')
        allPupils_by_RT_fix_ACC.fastest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allPupil_by_RT_fix_ACC_bc.fastest;
        allPupils_by_RT_fix_ACC.middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allPupil_by_RT_fix_ACC_bc.middle;
        allPupils_by_RT_fix_ACC.slowest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allPupil_by_RT_fix_ACC_bc.slowest;
        
        allPupils_by_RT_fix_FAST.fastest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allPupil_by_RT_fix_FAST_bc.fastest;
        allPupils_by_RT_fix_FAST.middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allPupil_by_RT_fix_FAST_bc.middle;
        allPupils_by_RT_fix_FAST.slowest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = allPupil_by_RT_fix_FAST_bc.slowest;
        
        allPupils_by_RT_targ_ACC.fastest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allPupil_by_RT_targ_ACC_bc.fastest;
        allPupils_by_RT_targ_ACC.middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allPupil_by_RT_targ_ACC_bc.middle;
        allPupils_by_RT_targ_ACC.slowest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allPupil_by_RT_targ_ACC_bc.slowest;
        
        allPupils_by_RT_targ_FAST.fastest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allPupil_by_RT_targ_FAST_bc.fastest;
        allPupils_by_RT_targ_FAST.middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allPupil_by_RT_targ_FAST_bc.middle;
        allPupils_by_RT_targ_FAST.slowest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = allPupil_by_RT_targ_FAST_bc.slowest;
    else
        allPupils_by_RT_fix_ACC.fastest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_by_RT_fix_ACC.middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_by_RT_fix_ACC.slowest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_by_RT_fix_FAST.fastest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_by_RT_fix_FAST.middle(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        allPupils_by_RT_fix_FAST.slowest(sess,1:length(Plot_Time_Fix(1):Plot_Time_Fix(2))) = NaN;
        
        allPupils_by_RT_targ_ACC.fastest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_by_RT_targ_ACC.middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_by_RT_targ_ACC.slowest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        
        allPupils_by_RT_targ_FAST.fastest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_by_RT_targ_FAST.middle(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
        allPupils_by_RT_targ_FAST.slowest(sess,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = NaN;
    end
    
    keep allRTs allACCs allSDFs* allFano* allPupils* real_time_targ real_time_fix filename unit sess ...
        file_list plotFlag Plot_Time*
    
end



if plotFlag == 1
    
end

clear plotFlag sess