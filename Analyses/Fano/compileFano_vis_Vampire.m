%calculate Fano factor across all databases
%
% Note: "shortest","middle", and "longest" refer to fixation hold times, not RTs
%
% RPH

function [] = compileFano_vis_Vampire(filename,path)

%=============
% OPTIONS
normSDF = 0; %normalize SDFs?

Plot_Time_Targ = [-3500 2500];
Plot_Time_Fix = [-100 3300];

if nargin < 2; path = '~/desktop/m/'; end

%=============


load(filename)

%Does this file contain the Tempo-created FixAcqTime?
if exist('FixAcqTime_')
    FixAcqPresent = 1;
else
    FixAcqPresent = 0;
end

varlist = who;
NeuronList = strmatch('DSP',varlist);

if exist('SAT_') & length(find(isnan(SAT_(:,1)))) < 30 & ~all(SAT_(:,1) == 4)%a few PopOut_FEF data files have random numbers in SAT_ variable, probably due to strobe overloading
    isSAT = 1;
else
    isSAT = 0;
end


%If there are uStim trials, remove them
nR = find(~isnan(MStim_(:,1)));
shorten_file


disp(['Total of ' mat2str(length(NeuronList)) ' neurons detected'])

for neuron = 1:length(NeuronList)
    disp(['Analyzing neuron ' mat2str(neuron) ' out of ' mat2str(length(NeuronList))])
    
    unit{neuron} = varlist{NeuronList(neuron)};
    
    sig = eval(varlist{NeuronList(neuron)});
    
    
    SDF = sSDF(sig,Target_(:,1),[Plot_Time_Targ(1) Plot_Time_Targ(2)]);
    SDF_Fix = sSDF(sig,Target_(:,1)-FixTime_Jit_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    
    if FixAcqPresent
        SDF_FixAcq = sSDF(sig,Target_(:,1) + FixAcqTime_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    end
    
    
    
    
    %Make sure the overall neural firing rate isn't too low
    if max(nanmean(SDF)) < 10
        disp('Skipping due to low firing rate...')
        continue
    end
    
    
    
    %======================
    
    if normSDF
        SDF = normalize_SP(SDF);
        SDF_Fix = normalize_SP(SDF_Fix);
        
        if FixAcqPresent
            SDF_FixAcq = normalize_SP(SDF_FixAcq);
        end
    end
    
    
    
    
    
    %============
    % CALC FANO
    %============
    
    %calculate real_time only on the first instance because of a problem file. Don't want to remove the
    %problem file from the main file list for reproduction purposes...
    
    winsize = 50;
    time_step = 10;
    
    
    %========================================
    %Break apart by length of Fixation period
    ntiles = prctile(FixTime_Jit_,[33 66]);
    
    shortest = find(FixTime_Jit_ <= ntiles(1));
    middle = find(FixTime_Jit_ > ntiles(1) & FixTime_Jit_ <= ntiles(2));
    longest = find(FixTime_Jit_ > ntiles(2));
    
    
    allTrls = 1:size(Target_,1);
    errTrls = find(Correct_(:,2) == 0);
    
    allTrls_shortest = intersect(allTrls,shortest);
    allTrls_middle = intersect(allTrls,middle);
    allTrls_longest = intersect(allTrls,longest);
    
    allACC.all = nanmean(Correct_(allTrls,2));
    allACC.all_shortest = nanmean(Correct_(allTrls_shortest,2));
    allACC.all_middle = nanmean(Correct_(allTrls_middle,2));
    allACC.all_longest = nanmean(Correct_(allTrls_longest,2));
    
    allRT.all = nanmean(SRT(allTrls,1));
    allRT.all_shortest = nanmean(SRT(allTrls_shortest,1));
    allRT.all_middle = nanmean(SRT(allTrls_middle,1));
    allRT.all_longest = nanmean(SRT(allTrls_longest,1));
    
    
    %==============================================================
    
    
    
    
    %====================================
    % For all task types, compute over-all Fano Factors, split by hold time length and aligned by
    % fixation and target
    
    [Fano_targ.err] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],errTrls);
    [Fano_targ.all real_time_targ allCV2_targ.all] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls);
    [Fano_targ.all_shortest ,~, allCV2_targ.all_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls_shortest);
    [Fano_targ.all_middle ,~, allCV2_targ.all_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls_middle);
    [Fano_targ.all_longest ,~, allCV2_targ.all_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],allTrls_longest);
    
    [Fano_fix.err] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],errTrls);
    [Fano_fix.all real_time_fix allCV2_fix.all] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls);
    [Fano_fix.all_shortest ,~, allCV2_fix.all_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_shortest);
    [Fano_fix.all_middle ,~, allCV2_fix.all_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_middle);
    [Fano_fix.all_longest ,~, allCV2_fix.all_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_longest);
    
    if FixAcqPresent
        [Fano_fixAcq.all ,~, allCV2_fixAcq.all] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls);
        [Fano_fixAcq.all_shortest ,~, allCV2_fixAcq.all_shortest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_shortest);
        [Fano_fixAcq.all_middle ,~, allCV2_fixAcq.all_middle] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_middle);
        [Fano_fixAcq.all_longest ,~, allCV2_fixAcq.all_longest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],allTrls_longest);
    end
    
    SDF_targ = sSDF(sig,Target_(:,1),[Plot_Time_Targ(1) Plot_Time_Targ(2)]);
    SDF_fix = sSDF(sig,Target_(:,1)-FixTime_Jit_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    

    if exist('Pupil_')
        Pupil_fix = fix_align(Pupil_,-FixTime_Jit_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
        Pupil_bc = baseline_correct(Pupil_,[2750 2760]);
        Pupil_fix_bc = baseline_correct(Pupil_fix,[abs(Plot_Time_Fix(1))-10 abs(Plot_Time_Fix(1))]);
        
        if FixAcqPresent
            Pupil_fixAcq = fix_align(Pupil_,FixAcqTime_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
            Pupil_fixAcq_bc = baseline_correct(Pupil_fixAcq,[abs(Plot_Time_Fix(1))-10 abs(Plot_Time_Fix(1))]);
        end
    end
    
    
    if FixAcqPresent
        SDF_fixAcq = sSDF(sig,Target_(:,1) + FixAcqTime_,[Plot_Time_Fix(1) Plot_Time_Fix(2)]);
    end
    
    if normSDF
        SDF_targ = normalize_SP(SDF_targ);
        SDF_fix = normalize_SP(SDF_fix);
        
        if FixAcqPresent
            SDF_fixAcq = normalize_SP(SDF_fixAcq);
        end
    end
    
    
    allSDF_targ.err = nanmean(SDF_targ(errTrls,:));
    allSDF_targ.all = nanmean(SDF_targ);
    allSDF_targ.all_shortest = nanmean(SDF_targ(allTrls_shortest,:));
    allSDF_targ.all_middle = nanmean(SDF_targ(allTrls_middle,:));
    allSDF_targ.all_longest = nanmean(SDF_targ(allTrls_longest,:));
    
    allSDF_fix.err = nanmean(SDF_fix(errTrls,:));
    allSDF_fix.all = nanmean(SDF_fix);
    allSDF_fix.all_shortest = nanmean(SDF_fix(allTrls_shortest,:));
    allSDF_fix.all_middle = nanmean(SDF_fix(allTrls_middle,:));
    allSDF_fix.all_longest = nanmean(SDF_fix(allTrls_longest,:));
    
    
    if FixAcqPresent
        allSDF_fixAcq.all = nanmean(SDF_fixAcq);
        allSDF_fixAcq.all_shortest = nanmean(SDF_fixAcq(allTrls_shortest,:));
        allSDF_fixAcq.all_middle = nanmean(SDF_fixAcq(allTrls_middle,:));
        allSDF_fixAcq.all_longest = nanmean(SDF_fixAcq(allTrls_longest,:));
    end
    
    %==============================================================
    
    
    
    
    %===============================================================
    %calculate the fastest, middle, and longest CORRECT SRTs to see if those metrics correlate with Fano
    %have to do separately for SAT and non-SAT sessions
    if ~isSAT
        %compute across all correct/error trials so we can also estimate the % correct
        SRT_ntiles = prctile(SRT(:,1),[33 66]);
        
        fastest_RT = find(SRT(:,1) <= SRT_ntiles(1));
        middle_RT = find(SRT(:,1) > SRT_ntiles(1) & SRT(:,1) <= SRT_ntiles(2));
        slowest_RT = find(SRT(:,1) > SRT_ntiles(2));
        
        allACC_RTntile.fastest = nanmean(Correct_(fastest_RT,2));
        allACC_RTntile.middle = nanmean(Correct_(middle_RT,2));
        allACC_RTntile.slowest = nanmean(Correct_(slowest_RT,2));
        
        allSDF_by_RT_targ.fastest = nanmean(SDF_targ(fastest_RT,:));
        allSDF_by_RT_targ.middle = nanmean(SDF_targ(middle_RT,:));
        allSDF_by_RT_targ.slowest = nanmean(SDF_targ(slowest_RT,:));
        
        allSDF_by_RT_fix.fastest = nanmean(SDF_fix(fastest_RT,:));
        allSDF_by_RT_fix.middle = nanmean(SDF_fix(middle_RT,:));
        allSDF_by_RT_fix.slowest = nanmean(SDF_fix(slowest_RT,:));
        
        [Fano_by_RT_targ.fastest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],fastest_RT);
        [Fano_by_RT_targ.middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],middle_RT);
        [Fano_by_RT_targ.slowest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],slowest_RT);
        
        [Fano_by_RT_fix.fastest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fastest_RT);
        [Fano_by_RT_fix.middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],middle_RT);
        [Fano_by_RT_fix.slowest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slowest_RT);
    else
        %have to split up SAT conditions
        SRT_ntiles_ACC = prctile(SRT(find(SAT_(:,1) == 1),1),[33 66]);
        SRT_ntiles_FAST = prctile(SRT(find(SAT_(:,1) == 3),1),[33 66]);
        
        fastest_RT_ACC = find(SRT(:,1) <= SRT_ntiles_ACC(1) & SAT_(:,1) == 1);
        middle_RT_ACC = find(SRT(:,1) > SRT_ntiles_ACC(1) & SRT(:,1) <= SRT_ntiles_ACC(2) & SAT_(:,1) == 1);
        slowest_RT_ACC = find(SRT(:,1) > SRT_ntiles_ACC(2) & SAT_(:,1) == 1);
        
        fastest_RT_FAST = find(SRT(:,1) <= SRT_ntiles_FAST(1) & SAT_(:,1) == 3);
        middle_RT_FAST = find(SRT(:,1) > SRT_ntiles_FAST(1) & SRT(:,1) <= SRT_ntiles_FAST(2) & SAT_(:,1) == 3);
        slowest_RT_FAST = find(SRT(:,1) > SRT_ntiles_FAST(2) & SAT_(:,1) == 3);
        
                
        allACC_RTntile_ACC.fastest = Correct_(fastest_RT_ACC,2);
        allACC_RTntile_ACC.middle = Correct_(middle_RT_ACC,2);
        allACC_RTntile_ACC.slowest = Correct_(slowest_RT_ACC,2);
        
        allACC_RTntile_FAST.fastest = Correct_(fastest_RT_FAST,2);
        allACC_RTntile_FAST.middle = Correct_(middle_RT_FAST,2);
        allACC_RTntile_FAST.slowest = Correct_(slowest_RT_FAST,2);
        
        
        allSDF_by_RT_targ_ACC.fastest = nanmean(SDF_targ(fastest_RT_ACC,:));
        allSDF_by_RT_targ_ACC.middle = nanmean(SDF_targ(middle_RT_ACC,:));
        allSDF_by_RT_targ_ACC.slowest = nanmean(SDF_targ(slowest_RT_ACC,:));
        
        allSDF_by_RT_fix_ACC.fastest = nanmean(SDF_fix(fastest_RT_ACC,:));
        allSDF_by_RT_fix_ACC.middle = nanmean(SDF_fix(middle_RT_ACC,:));
        allSDF_by_RT_fix_ACC.slowest = nanmean(SDF_fix(slowest_RT_ACC,:));    
        
        
        allSDF_by_RT_targ_FAST.fastest = nanmean(SDF_targ(fastest_RT_FAST,:));
        allSDF_by_RT_targ_FAST.middle = nanmean(SDF_targ(middle_RT_FAST,:));
        allSDF_by_RT_targ_FAST.slowest = nanmean(SDF_targ(slowest_RT_FAST,:));
        
        allSDF_by_RT_fix_FAST.fastest = nanmean(SDF_fix(fastest_RT_FAST,:));
        allSDF_by_RT_fix_FAST.middle = nanmean(SDF_fix(middle_RT_FAST,:));
        allSDF_by_RT_fix_FAST.slowest = nanmean(SDF_fix(slowest_RT_FAST,:));        

        
        Fano_by_RT_targ_ACC.fastest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],fastest_RT_ACC);
        Fano_by_RT_targ_ACC.middle = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],middle_RT_ACC);
        Fano_by_RT_targ_ACC.slowest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],slowest_RT_ACC);
        
        Fano_by_RT_targ_FAST.fastest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],fastest_RT_FAST);
        Fano_by_RT_targ_FAST.middle = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],middle_RT_FAST);
        Fano_by_RT_targ_FAST.slowest = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],slowest_RT_FAST);
        
        
        Fano_by_RT_fix_ACC.fastest = getFano_targ(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fastest_RT_ACC);
        Fano_by_RT_fix_ACC.middle = getFano_targ(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],middle_RT_ACC);
        Fano_by_RT_fix_ACC.slowest = getFano_targ(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slowest_RT_ACC);
        
        Fano_by_RT_fix_FAST.fastest = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fastest_RT_FAST);
        Fano_by_RT_fix_FAST.middle = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],middle_RT_FAST);
        Fano_by_RT_fix_FAST.slowest = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slowest_RT_FAST);        
        
        
        if exist('Pupil_')
            
            allPupil_by_RT_targ_ACC_bc.fastest = nanmean(Pupil_bc(fastest_RT_ACC,:));
            allPupil_by_RT_targ_ACC_bc.middle = nanmean(Pupil_bc(middle_RT_ACC,:));
            allPupil_by_RT_targ_ACC_bc.slowest = nanmean(Pupil_bc(slowest_RT_ACC,:));
            
            allPupil_by_RT_targ_FAST_bc.fastest = nanmean(Pupil_bc(fastest_RT_FAST,:));
            allPupil_by_RT_targ_FAST_bc.middle = nanmean(Pupil_bc(middle_RT_FAST,:));
            allPupil_by_RT_targ_FAST_bc.slowest = nanmean(Pupil_bc(slowest_RT_FAST,:));
        
            allPupil_by_RT_fix_ACC_bc.fastest = nanmean(Pupil_fix_bc(fastest_RT_ACC,:));
            allPupil_by_RT_fix_ACC_bc.middle = nanmean(Pupil_fix_bc(middle_RT_ACC,:));
            allPupil_by_RT_fix_ACC_bc.slowest = nanmean(Pupil_fix_bc(slowest_RT_ACC,:));
            
            allPupil_by_RT_fix_FAST_bc.fastest = nanmean(Pupil_fix_bc(fastest_RT_FAST,:));
            allPupil_by_RT_fix_FAST_bc.middle = nanmean(Pupil_fix_bc(middle_RT_FAST,:));
            allPupil_by_RT_fix_FAST_bc.slowest = nanmean(Pupil_fix_bc(slowest_RT_FAST,:));

        end
        
    end %for isSAT
    
    
    
    
    
    %============================================
    % Compute the following only for SAT sessions
    
    if isSAT
        getTrials_SAT
        
        
        slowTrls_shortest = intersect(slow_all_made_dead,shortest);
        slowTrls_middle = intersect(slow_all_made_dead,middle);
        slowTrls_longest = intersect(slow_all_made_dead,longest);
        
        fastTrls_shortest = intersect(fast_all_made_dead_withCleared,shortest);
        fastTrls_middle = intersect(fast_all_made_dead_withCleared,middle);
        fastTrls_longest = intersect(fast_all_made_dead_withCleared,longest);
        
        allACC.all_shortest = nanmean(Correct_(allTrls_shortest,2));
        allACC.all_middle = nanmean(Correct_(allTrls_middle,2));
        allACC.all_longest = nanmean(Correct_(allTrls_longest,2));
        
        allACC.slow_shortest = nanmean(Correct_(slowTrls_shortest,2));
        allACC.slow_middle = nanmean(Correct_(slowTrls_middle,2));
        allACC.slow_longest = nanmean(Correct_(slowTrls_longest,2));
        
        allACC.fast_shortest = nanmean(Correct_(fastTrls_shortest,2));
        allACC.fast_middle = nanmean(Correct_(fastTrls_middle,2));
        allACC.fast_longest = nanmean(Correct_(fastTrls_longest,2));
        
        
        allRT.all_shortest = nanmean(SRT(allTrls_shortest,1));
        allRT.all_middle = nanmean(SRT(allTrls_middle,1));
        allRT.all_longest = nanmean(SRT(allTrls_longest,1));
        
        allRT.slow_shortest = nanmean(SRT(slowTrls_shortest,1));
        allRT.slow_middle = nanmean(SRT(slowTrls_middle,1));
        allRT.slow_longest = nanmean(SRT(slowTrls_longest,1));
        
        allRT.fast_shortest = nanmean(SRT(fastTrls_shortest,1));
        allRT.fast_middle = nanmean(SRT(fastTrls_middle,1));
        allRT.fast_longest = nanmean(SRT(fastTrls_longest,1));
        
        
        %
        %=============================================
        %=============================================
        % MADE DEADLINES
        %=============================================
        %=============================================
        
        
        % Aligned to Target onset
        [Fano_targ_made_dead.all,~,CV2_targ_made_dead.all] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],[slow_all_made_dead ; fast_all_made_dead_withCleared]);
        [Fano_targ_made_dead.all_shortest,~,CV2_targ_made_dead.all_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
        [Fano_targ_made_dead.all_middle,~,CV2_targ_made_dead.all_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
        [Fano_targ_made_dead.all_longest,~,CV2_targ_made_dead.all_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
        
        [Fano_targ_made_dead.slow,~,CV2_targ_made_dead.slow] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],slow_all_made_dead);
        [Fano_targ_made_dead.slow_shortest,~,CV2_targ_made_dead.slow_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,slow_all_made_dead));
        [Fano_targ_made_dead.slow_middle,~,CV2_targ_made_dead.slow_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,slow_all_made_dead));
        [Fano_targ_made_dead.slow_longest,~,CV2_targ_made_dead.slow_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,slow_all_made_dead));
        
        %Fano_targ_made_dead.med = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],med_all);
        [Fano_targ_made_dead.fast,~,CV2_targ_made_dead.fast] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],fast_all_made_dead_withCleared);
        [Fano_targ_made_dead.fast_shortest,~,CV2_targ_made_dead.fast_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,fast_all_made_dead_withCleared));
        [Fano_targ_made_dead.fast_middle,~,CV2_targ_made_dead.fast_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,fast_all_made_dead_withCleared));
        [Fano_targ_made_dead.fast_longest,~,CV2_targ_made_dead.fast_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,fast_all_made_dead_withCleared));
        
        
        % Aligned to fixation hold time
        [Fano_fix_made_dead.all,~,CV2_fix_made_dead.all] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],[slow_all_made_dead ; fast_all_made_dead_withCleared]);
        [Fano_fix_made_dead.all_shortest,~,CV2_fix_made_dead.all_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(shortest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
        [Fano_fix_made_dead.all_middle,~,CV2_fix_made_dead.all_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(middle,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
        [Fano_fix_made_dead.all_longest,~,CV2_fix_made_dead.all_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(longest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
        
        
        [Fano_fix_made_dead.slow,~,CV2_fix_made_dead.slow] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slow_all_made_dead);
        [Fano_fix_made_dead.slow_shortest,~,CV2_fix_made_dead.slow_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,shortest));
        [Fano_fix_made_dead.slow_middle,~,CV2_fix_made_dead.slow_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,middle));
        [Fano_fix_made_dead.slow_longest,~,CV2_fix_made_dead.slow_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,longest));
        
        [Fano_fix_made_dead.fast,~,CV2_fix_made_dead.fast] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fast_all_made_dead_withCleared);
        [Fano_fix_made_dead.fast_shortest,~,CV2_fix_made_dead.fast_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,shortest));
        [Fano_fix_made_dead.fast_middle,~,CV2_fix_made_dead.fast_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,middle));
        [Fano_fix_made_dead.fast_longest,~,CV2_fix_made_dead.fast_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,longest));
        
        
        if FixAcqPresent
            [Fano_fixAcq_made_dead.all,~,CV2_fixAcq_made_dead.all] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],[slow_all_made_dead ; fast_all_made_dead_withCleared]);
            [Fano_fixAcq_made_dead.all_shortest,~,CV2_fixAcq_made_dead.all_shortest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(shortest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
            [Fano_fixAcq_made_dead.all_middle,~,CV2_fixAcq_made_dead.all_middle] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(middle,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
            [Fano_fixAcq_made_dead.all_longest,~,CV2_fixAcq_made_dead.all_longest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(longest,[slow_all_made_dead ; fast_all_made_dead_withCleared]));
            
            
            [Fano_fixAcq_made_dead.slow,~,CV2_fixAcq_made_dead.slow] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slow_all_made_dead);
            [Fano_fixAcq_made_dead.slow_shortest,~,CV2_fixAcq_made_dead.slow_shortest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,shortest));
            [Fano_fixAcq_made_dead.slow_middle,~,CV2_fixAcq_made_dead.slow_middle] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,middle));
            [Fano_fixAcq_made_dead.slow_longest,~,CV2_fixAcq_made_dead.slow_longest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_made_dead,longest));
            
            [Fano_fixAcq_made_dead.fast,~,CV2_fixAcq_made_dead.fast] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fast_all_made_dead_withCleared);
            [Fano_fixAcq_made_dead.fast_shortest,~,CV2_fixAcq_made_dead.fast_shortest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,shortest));
            [Fano_fixAcq_made_dead.fast_middle,~,CV2_fixAcq_made_dead.fast_middle] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,middle));
            [Fano_fixAcq_made_dead.fast_longest,~,CV2_fixAcq_made_dead.fast_longest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_made_dead_withCleared,longest));
        end
        
        
        
        %===================
        % KEEP RECORD OF SDF
        %===================
        
        
        allSDF_targ_made_dead.all = nanmean(SDF);
        allSDF_targ_made_dead.all_shortest = nanmean(SDF(shortest,:));
        allSDF_targ_made_dead.all_middle = nanmean(SDF(middle,:));
        allSDF_targ_made_dead.all_longest = nanmean(SDF(longest,:));
        
        allSDF_targ_made_dead.slow = nanmean(SDF(slow_all_made_dead,:));
        allSDF_targ_made_dead.slow_shortest = nanmean(SDF(intersect(shortest,slow_all_made_dead),:));
        allSDF_targ_made_dead.slow_middle = nanmean(SDF(intersect(middle,slow_all_made_dead),:));
        allSDF_targ_made_dead.slow_longest = nanmean(SDF(intersect(longest,slow_all_made_dead),:));
        
        %SDF_targ_made_dead.med(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(med_all,:));
        allSDF_targ_made_dead.fast = nanmean(SDF(fast_all_made_dead_withCleared,:));
        allSDF_targ_made_dead.fast_shortest = nanmean(SDF(intersect(shortest,fast_all_made_dead_withCleared),:));
        allSDF_targ_made_dead.fast_middle = nanmean(SDF(intersect(middle,fast_all_made_dead_withCleared),:));
        allSDF_targ_made_dead.fast_longest = nanmean(SDF(intersect(longest,fast_all_made_dead_withCleared),:));
        %
        %     %also break SDFs by length of Fixation Period
        allSDF_fix_made_dead.all = nanmean(SDF_Fix);
        allSDF_fix_made_dead.shortest = nanmean(SDF_Fix(shortest,:));
        allSDF_fix_made_dead.middle = nanmean(SDF_Fix(middle,:));
        allSDF_fix_made_dead.longest = nanmean(SDF_Fix(longest,:));
        
        allSDF_fix_made_dead.slow = nanmean(SDF_Fix(slow_all_made_dead,:));
        allSDF_fix_made_dead.slow_shortest = nanmean(SDF_Fix(intersect(slow_all_made_dead,shortest),:));
        allSDF_fix_made_dead.slow_middle = nanmean(SDF_Fix(intersect(slow_all_made_dead,middle),:));
        allSDF_fix_made_dead.slow_longest = nanmean(SDF_Fix(intersect(slow_all_made_dead,longest),:));
        
        allSDF_fix_made_dead.fast = nanmean(SDF_Fix(fast_all_made_dead_withCleared,:));
        allSDF_fix_made_dead.fast_shortest = nanmean(SDF_Fix(intersect(fast_all_made_dead_withCleared,shortest),:));
        allSDF_fix_made_dead.fast_middle = nanmean(SDF_Fix(intersect(fast_all_made_dead_withCleared,middle),:));
        allSDF_fix_made_dead.fast_longest = nanmean(SDF_Fix(intersect(fast_all_made_dead_withCleared,longest),:));
        
        
        %=====================================
        % KEEP RECORD OF Pupil size
        %=====================================
        
        if exist('Pupil_')
            allPupil_targ_made_dead.slow = nanmean(Pupil_(slow_all_made_dead,:));
            allPupil_targ_made_dead.slow_shortest = nanmean(Pupil_(intersect(shortest,slow_all_made_dead),:));
            allPupil_targ_made_dead.slow_middle = nanmean(Pupil_(intersect(middle,slow_all_made_dead),:));
            allPupil_targ_made_dead.slow_longest = nanmean(Pupil_(intersect(longest,slow_all_made_dead),:));
            
            allPupil_targ_bc_made_dead.slow = nanmean(Pupil_bc(slow_all_made_dead,:));
            allPupil_targ_bc_made_dead.slow_shortest = nanmean(Pupil_bc(intersect(shortest,slow_all_made_dead),:));
            allPupil_targ_bc_made_dead.slow_middle = nanmean(Pupil_bc(intersect(middle,slow_all_made_dead),:));
            allPupil_targ_bc_made_dead.slow_longest = nanmean(Pupil_bc(intersect(longest,slow_all_made_dead),:));
            
            
            allPupil_fix_made_dead.slow = nanmean(Pupil_fix(slow_all_made_dead,:));
            allPupil_fix_made_dead.slow_shortest = nanmean(Pupil_fix(intersect(shortest,slow_all_made_dead),:));
            allPupil_fix_made_dead.slow_middle = nanmean(Pupil_fix(intersect(middle,slow_all_made_dead),:));
            allPupil_fix_made_dead.slow_longest = nanmean(Pupil_fix(intersect(longest,slow_all_made_dead),:));
            
            allPupil_fix_bc_made_dead.slow = nanmean(Pupil_fix_bc(slow_all_made_dead,:));
            allPupil_fix_bc_made_dead.slow_shortest = nanmean(Pupil_fix_bc(intersect(shortest,slow_all_made_dead),:));
            allPupil_fix_bc_made_dead.slow_middle = nanmean(Pupil_fix_bc(intersect(middle,slow_all_made_dead),:));
            allPupil_fix_bc_made_dead.slow_longest = nanmean(Pupil_fix_bc(intersect(longest,slow_all_made_dead),:));
            
            
            
            allPupil_targ_made_dead.fast = nanmean(Pupil_(fast_all_made_dead_withCleared,:));
            allPupil_targ_made_dead.fast_shortest = nanmean(Pupil_(intersect(shortest,fast_all_made_dead_withCleared),:));
            allPupil_targ_made_dead.fast_middle = nanmean(Pupil_(intersect(middle,fast_all_made_dead_withCleared),:));
            allPupil_targ_made_dead.fast_longest = nanmean(Pupil_(intersect(longest,fast_all_made_dead_withCleared),:));
            
            allPupil_targ_bc_made_dead.fast = nanmean(Pupil_bc(fast_all_made_dead_withCleared,:));
            allPupil_targ_bc_made_dead.fast_shortest = nanmean(Pupil_bc(intersect(shortest,fast_all_made_dead_withCleared),:));
            allPupil_targ_bc_made_dead.fast_middle = nanmean(Pupil_bc(intersect(middle,fast_all_made_dead_withCleared),:));
            allPupil_targ_bc_made_dead.fast_longest = nanmean(Pupil_bc(intersect(longest,fast_all_made_dead_withCleared),:));
            
            
            allPupil_fix_made_dead.fast = nanmean(Pupil_fix(fast_all_made_dead_withCleared,:));
            allPupil_fix_made_dead.fast_shortest = nanmean(Pupil_fix(intersect(shortest,fast_all_made_dead_withCleared),:));
            allPupil_fix_made_dead.fast_middle = nanmean(Pupil_fix(intersect(middle,fast_all_made_dead_withCleared),:));
            allPupil_fix_made_dead.fast_longest = nanmean(Pupil_fix(intersect(longest,fast_all_made_dead_withCleared),:));
            
            allPupil_fix_bc_made_dead.fast = nanmean(Pupil_fix_bc(fast_all_made_dead_withCleared,:));
            allPupil_fix_bc_made_dead.fast_shortest = nanmean(Pupil_fix_bc(intersect(shortest,fast_all_made_dead_withCleared),:));
            allPupil_fix_bc_made_dead.fast_middle = nanmean(Pupil_fix_bc(intersect(middle,fast_all_made_dead_withCleared),:));
            allPupil_fix_bc_made_dead.fast_longest = nanmean(Pupil_fix_bc(intersect(longest,fast_all_made_dead_withCleared),:));
            
        end
        
        
        if FixAcqPresent
            allSDF_fixAcq_made_dead.all = nanmean(SDF_FixAcq);
            allSDF_fixAcq_made_dead.shortest = nanmean(SDF_FixAcq(shortest,:));
            allSDF_fixAcq_made_dead.middle = nanmean(SDF_FixAcq(middle,:));
            allSDF_fixAcq_made_dead.longest = nanmean(SDF_FixAcq(longest,:));
            
            allSDF_fixAcq_made_dead.slow = nanmean(SDF_FixAcq(slow_all_made_dead,:));
            allSDF_fixAcq_made_dead.slow_shortest = nanmean(SDF_FixAcq(intersect(slow_all_made_dead,shortest),:));
            allSDF_fixAcq_made_dead.slow_middle = nanmean(SDF_FixAcq(intersect(slow_all_made_dead,middle),:));
            allSDF_fixAcq_made_dead.slow_longest= nanmean(SDF_FixAcq(intersect(slow_all_made_dead,longest),:));
            
            allSDF_fixAcq_made_dead.fast = nanmean(SDF_FixAcq(fast_all_made_dead_withCleared,:));
            allSDF_fixAcq_made_dead.fast_shortest = nanmean(SDF_FixAcq(intersect(fast_all_made_dead_withCleared,shortest),:));
            allSDF_fixAcq_made_dead.fast_middle = nanmean(SDF_FixAcq(intersect(fast_all_made_dead_withCleared,middle),:));
            allSDF_fixAcq_made_dead.fast_longest = nanmean(SDF_FixAcq(intersect(fast_all_made_dead_withCleared,longest),:));
            
            if exist('Pupil_')
                allPupil_fixAcq_made_dead.slow = nanmean(Pupil_fixAcq(slow_all_made_dead,:));
                allPupil_fixAcq_made_dead.slow_shortest = nanmean(Pupil_fixAcq(intersect(shortest,slow_all_made_dead),:));
                allPupil_fixAcq_made_dead.slow_middle = nanmean(Pupil_fixAcq(intersect(middle,slow_all_made_dead),:));
                allPupil_fixAcq_made_dead.slow_longest = nanmean(Pupil_fixAcq(intersect(longest,slow_all_made_dead),:));
                
                allPupil_fixAcq_bc_made_dead.slow = nanmean(Pupil_fixAcq_bc(slow_all_made_dead,:));
                allPupil_fixAcq_bc_made_dead.slow_shortest = nanmean(Pupil_fixAcq_bc(intersect(shortest,slow_all_made_dead),:));
                allPupil_fixAcq_bc_made_dead.slow_middle = nanmean(Pupil_fixAcq_bc(intersect(middle,slow_all_made_dead),:));
                allPupil_fixAcq_bc_made_dead.slow_longest = nanmean(Pupil_fixAcq_bc(intersect(longest,slow_all_made_dead),:));
                
                
                allPupil_fixAcq_made_dead.fast = nanmean(Pupil_fixAcq(fast_all_made_dead_withCleared,:));
                allPupil_fixAcq_made_dead.fast_shortest = nanmean(Pupil_fixAcq(intersect(shortest,fast_all_made_dead_withCleared),:));
                allPupil_fixAcq_made_dead.fast_middle = nanmean(Pupil_fixAcq(intersect(middle,fast_all_made_dead_withCleared),:));
                allPupil_fixAcq_made_dead.fast_longest = nanmean(Pupil_fixAcq(intersect(longest,fast_all_made_dead_withCleared),:));
                
                allPupil_fixAcq_bc_made_dead.fast = nanmean(Pupil_fixAcq_bc(fast_all_made_dead_withCleared,:));
                allPupil_fixAcq_bc_made_dead.fast_shortest = nanmean(Pupil_fixAcq_bc(intersect(shortest,fast_all_made_dead_withCleared),:));
                allPupil_fixAcq_bc_made_dead.fast_middle = nanmean(Pupil_fixAcq_bc(intersect(middle,fast_all_made_dead_withCleared),:));
                allPupil_fixAcq_bc_made_dead.fast_longest = nanmean(Pupil_fixAcq_bc(intersect(longest,fast_all_made_dead_withCleared),:));
                
            end
            
        end
        
        
        
        
        
        
        %
        %=============================================
        %=============================================
        % MISSED DEADLINES
        %=============================================
        %=============================================
        
        
        % Aligned to Target onset
        [Fano_targ_missed_dead.all,~,CV2_targ_missed_dead.all] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],[slow_all_missed_dead ; fast_all_missed_dead_withCleared]);
        [Fano_targ_missed_dead.all_shortest,~,CV2_targ_missed_dead.all_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
        [Fano_targ_missed_dead.all_middle,~,CV2_targ_missed_dead.all_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
        [Fano_targ_missed_dead.all_longest,~,CV2_targ_missed_dead.all_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
        
        [Fano_targ_missed_dead.slow,~,CV2_targ_missed_dead.slow] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],slow_all_missed_dead);
        [Fano_targ_missed_dead.slow_shortest,~,CV2_targ_missed_dead.slow_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,slow_all_missed_dead));
        [Fano_targ_missed_dead.slow_middle,~,CV2_targ_missed_dead.slow_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,slow_all_missed_dead));
        [Fano_targ_missed_dead.slow_longest,~,CV2_targ_missed_dead.slow_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,slow_all_missed_dead));
        
        %Fano_targ_missed_dead.med = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],med_all);
        [Fano_targ_missed_dead.fast,~,CV2_targ_missed_dead.fast] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],fast_all_missed_dead_withCleared);
        [Fano_targ_missed_dead.fast_shortest,~,CV2_targ_missed_dead.fast_shortest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(shortest,fast_all_missed_dead_withCleared));
        [Fano_targ_missed_dead.fast_middle,~,CV2_targ_missed_dead.fast_middle] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(middle,fast_all_missed_dead_withCleared));
        [Fano_targ_missed_dead.fast_longest,~,CV2_targ_missed_dead.fast_longest] = getFano_targ(sig,winsize,time_step,[Plot_Time_Targ(1) Plot_Time_Targ(2)],intersect(longest,fast_all_missed_dead_withCleared));
        
        
        % Aligned to fixation hold time
        [Fano_fix_missed_dead.all,~,CV2_fix_missed_dead.all] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],[slow_all_missed_dead ; fast_all_missed_dead_withCleared]);
        [Fano_fix_missed_dead.all_shortest,~,CV2_fix_missed_dead.all_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(shortest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
        [Fano_fix_missed_dead.all_middle,~,CV2_fix_missed_dead.all_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(middle,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
        [Fano_fix_missed_dead.all_longest,~,CV2_fix_missed_dead.all_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(longest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
        
        
        [Fano_fix_missed_dead.slow,~,CV2_fix_missed_dead.slow] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slow_all_missed_dead);
        [Fano_fix_missed_dead.slow_shortest,~,CV2_fix_missed_dead.slow_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_missed_dead,shortest));
        [Fano_fix_missed_dead.slow_middle,~,CV2_fix_missed_dead.slow_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_missed_dead,middle));
        [Fano_fix_missed_dead.slow_longest,~,CV2_fix_missed_dead.slow_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_missed_dead,longest));
        
        [Fano_fix_missed_dead.fast,~,CV2_fix_missed_dead.fast] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fast_all_missed_dead_withCleared);
        [Fano_fix_missed_dead.fast_shortest,~,CV2_fix_missed_dead.fast_shortest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_missed_dead_withCleared,shortest));
        [Fano_fix_missed_dead.fast_middle,~,CV2_fix_missed_dead.fast_middle] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_missed_dead_withCleared,middle));
        [Fano_fix_missed_dead.fast_longest,~,CV2_fix_missed_dead.fast_longest] = getFano_fix(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_missed_dead_withCleared,longest));
        
        
        if FixAcqPresent
            [Fano_fixAcq_missed_dead.all,~,CV2_fixAcq_missed_dead.all] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],[slow_all_missed_dead ; fast_all_missed_dead_withCleared]);
            [Fano_fixAcq_missed_dead.all_shortest,~,CV2_fixAcq_missed_dead.all_shortest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(shortest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
            [Fano_fixAcq_missed_dead.all_middle,~,CV2_fixAcq_missed_dead.all_middle] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(middle,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
            [Fano_fixAcq_missed_dead.all_longest,~,CV2_fixAcq_missed_dead.all_longest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(longest,[slow_all_missed_dead ; fast_all_missed_dead_withCleared]));
            
            
            [Fano_fixAcq_missed_dead.slow,~,CV2_fixAcq_missed_dead.slow] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],slow_all_missed_dead);
            [Fano_fixAcq_missed_dead.slow_shortest,~,CV2_fixAcq_missed_dead.slow_shortest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_missed_dead,shortest));
            [Fano_fixAcq_missed_dead.slow_middle,~,CV2_fixAcq_missed_dead.slow_middle] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_missed_dead,middle));
            [Fano_fixAcq_missed_dead.slow_longest,~,CV2_fixAcq_missed_dead.slow_longest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(slow_all_missed_dead,longest));
            
            [Fano_fixAcq_missed_dead.fast,~,CV2_fixAcq_missed_dead.fast] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],fast_all_missed_dead_withCleared);
            [Fano_fixAcq_missed_dead.fast_shortest,~,CV2_fixAcq_missed_dead.fast_shortest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_missed_dead_withCleared,shortest));
            [Fano_fixAcq_missed_dead.fast_middle,~,CV2_fixAcq_missed_dead.fast_middle] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_missed_dead_withCleared,middle));
            [Fano_fixAcq_missed_dead.fast_longest,~,CV2_fixAcq_missed_dead.fast_longest] = getFano_fix_acq(sig,winsize,time_step,[Plot_Time_Fix(1) Plot_Time_Fix(2)],intersect(fast_all_missed_dead_withCleared,longest));
        end
        
        
        
        %===================
        % KEEP RECORD OF SDF
        %===================
        
        
        allSDF_targ_missed_dead.all = nanmean(SDF);
        allSDF_targ_missed_dead.all_shortest = nanmean(SDF(shortest,:));
        allSDF_targ_missed_dead.all_middle = nanmean(SDF(middle,:));
        allSDF_targ_missed_dead.all_longest = nanmean(SDF(longest,:));
        
        allSDF_targ_missed_dead.slow = nanmean(SDF(slow_all_missed_dead,:));
        allSDF_targ_missed_dead.slow_shortest = nanmean(SDF(intersect(shortest,slow_all_missed_dead),:));
        allSDF_targ_missed_dead.slow_middle = nanmean(SDF(intersect(middle,slow_all_missed_dead),:));
        allSDF_targ_missed_dead.slow_longest = nanmean(SDF(intersect(longest,slow_all_missed_dead),:));
        
        %SDF_targ_missed_dead.med(file,1:length(Plot_Time_Targ(1):Plot_Time_Targ(2))) = nanmean(SDF(med_all,:));
        allSDF_targ_missed_dead.fast = nanmean(SDF(fast_all_missed_dead_withCleared,:));
        allSDF_targ_missed_dead.fast_shortest = nanmean(SDF(intersect(shortest,fast_all_missed_dead_withCleared),:));
        allSDF_targ_missed_dead.fast_middle = nanmean(SDF(intersect(middle,fast_all_missed_dead_withCleared),:));
        allSDF_targ_missed_dead.fast_longest = nanmean(SDF(intersect(longest,fast_all_missed_dead_withCleared),:));
        %
        %     %also break SDFs by length of Fixation Period
        allSDF_fix_missed_dead.all = nanmean(SDF_Fix);
        allSDF_fix_missed_dead.shortest = nanmean(SDF_Fix(shortest,:));
        allSDF_fix_missed_dead.middle = nanmean(SDF_Fix(middle,:));
        allSDF_fix_missed_dead.longest = nanmean(SDF_Fix(longest,:));
        
        allSDF_fix_missed_dead.slow = nanmean(SDF_Fix(slow_all_missed_dead,:));
        allSDF_fix_missed_dead.slow_shortest = nanmean(SDF_Fix(intersect(slow_all_missed_dead,shortest),:));
        allSDF_fix_missed_dead.slow_middle = nanmean(SDF_Fix(intersect(slow_all_missed_dead,middle),:));
        allSDF_fix_missed_dead.slow_longest = nanmean(SDF_Fix(intersect(slow_all_missed_dead,longest),:));
        
        allSDF_fix_missed_dead.fast = nanmean(SDF_Fix(fast_all_missed_dead_withCleared,:));
        allSDF_fix_missed_dead.fast_shortest = nanmean(SDF_Fix(intersect(fast_all_missed_dead_withCleared,shortest),:));
        allSDF_fix_missed_dead.fast_middle = nanmean(SDF_Fix(intersect(fast_all_missed_dead_withCleared,middle),:));
        allSDF_fix_missed_dead.fast_longest = nanmean(SDF_Fix(intersect(fast_all_missed_dead_withCleared,longest),:));
        
        
        %=====================================
        % KEEP RECORD OF Pupil size
        %=====================================
        
        if exist('Pupil_')
            allPupil_targ_missed_dead.slow = nanmean(Pupil_(slow_all_missed_dead,:));
            allPupil_targ_missed_dead.slow_shortest = nanmean(Pupil_(intersect(shortest,slow_all_missed_dead),:));
            allPupil_targ_missed_dead.slow_middle = nanmean(Pupil_(intersect(middle,slow_all_missed_dead),:));
            allPupil_targ_missed_dead.slow_longest = nanmean(Pupil_(intersect(longest,slow_all_missed_dead),:));
            
            allPupil_targ_bc_missed_dead.slow = nanmean(Pupil_bc(slow_all_missed_dead,:));
            allPupil_targ_bc_missed_dead.slow_shortest = nanmean(Pupil_bc(intersect(shortest,slow_all_missed_dead),:));
            allPupil_targ_bc_missed_dead.slow_middle = nanmean(Pupil_bc(intersect(middle,slow_all_missed_dead),:));
            allPupil_targ_bc_missed_dead.slow_longest = nanmean(Pupil_bc(intersect(longest,slow_all_missed_dead),:));
            
            
            allPupil_fix_missed_dead.slow = nanmean(Pupil_fix(slow_all_missed_dead,:));
            allPupil_fix_missed_dead.slow_shortest = nanmean(Pupil_fix(intersect(shortest,slow_all_missed_dead),:));
            allPupil_fix_missed_dead.slow_middle = nanmean(Pupil_fix(intersect(middle,slow_all_missed_dead),:));
            allPupil_fix_missed_dead.slow_longest = nanmean(Pupil_fix(intersect(longest,slow_all_missed_dead),:));
            
            allPupil_fix_bc_missed_dead.slow = nanmean(Pupil_fix_bc(slow_all_missed_dead,:));
            allPupil_fix_bc_missed_dead.slow_shortest = nanmean(Pupil_fix_bc(intersect(shortest,slow_all_missed_dead),:));
            allPupil_fix_bc_missed_dead.slow_middle = nanmean(Pupil_fix_bc(intersect(middle,slow_all_missed_dead),:));
            allPupil_fix_bc_missed_dead.slow_longest = nanmean(Pupil_fix_bc(intersect(longest,slow_all_missed_dead),:));
            
            
            allPupil_targ_missed_dead.fast = nanmean(Pupil_(fast_all_missed_dead_withCleared,:));
            allPupil_targ_missed_dead.fast_shortest = nanmean(Pupil_(intersect(shortest,fast_all_missed_dead_withCleared),:));
            allPupil_targ_missed_dead.fast_middle = nanmean(Pupil_(intersect(middle,fast_all_missed_dead_withCleared),:));
            allPupil_targ_missed_dead.fast_longest = nanmean(Pupil_(intersect(longest,fast_all_missed_dead_withCleared),:));
            
            allPupil_targ_bc_missed_dead.fast = nanmean(Pupil_bc(fast_all_missed_dead_withCleared,:));
            allPupil_targ_bc_missed_dead.fast_shortest = nanmean(Pupil_bc(intersect(shortest,fast_all_missed_dead_withCleared),:));
            allPupil_targ_bc_missed_dead.fast_middle = nanmean(Pupil_bc(intersect(middle,fast_all_missed_dead_withCleared),:));
            allPupil_targ_bc_missed_dead.fast_longest = nanmean(Pupil_bc(intersect(longest,fast_all_missed_dead_withCleared),:));
            
            
            allPupil_fix_missed_dead.fast = nanmean(Pupil_fix(fast_all_missed_dead_withCleared,:));
            allPupil_fix_missed_dead.fast_shortest = nanmean(Pupil_fix(intersect(shortest,fast_all_missed_dead_withCleared),:));
            allPupil_fix_missed_dead.fast_middle = nanmean(Pupil_fix(intersect(middle,fast_all_missed_dead_withCleared),:));
            allPupil_fix_missed_dead.fast_longest = nanmean(Pupil_fix(intersect(longest,fast_all_missed_dead_withCleared),:));
            
            allPupil_fix_bc_missed_dead.fast = nanmean(Pupil_fix_bc(fast_all_missed_dead_withCleared,:));
            allPupil_fix_bc_missed_dead.fast_shortest = nanmean(Pupil_fix_bc(intersect(shortest,fast_all_missed_dead_withCleared),:));
            allPupil_fix_bc_missed_dead.fast_middle = nanmean(Pupil_fix_bc(intersect(middle,fast_all_missed_dead_withCleared),:));
            allPupil_fix_bc_missed_dead.fast_longest = nanmean(Pupil_fix_bc(intersect(longest,fast_all_missed_dead_withCleared),:));
            
        end
        
        
        if FixAcqPresent
            allSDF_fixAcq_missed_dead.all = nanmean(SDF_FixAcq);
            allSDF_fixAcq_missed_dead.shortest = nanmean(SDF_FixAcq(shortest,:));
            allSDF_fixAcq_missed_dead.middle = nanmean(SDF_FixAcq(middle,:));
            allSDF_fixAcq_missed_dead.longest = nanmean(SDF_FixAcq(longest,:));
            
            allSDF_fixAcq_missed_dead.slow = nanmean(SDF_FixAcq(slow_all_missed_dead,:));
            allSDF_fixAcq_missed_dead.slow_shortest = nanmean(SDF_FixAcq(intersect(slow_all_missed_dead,shortest),:));
            allSDF_fixAcq_missed_dead.slow_middle = nanmean(SDF_FixAcq(intersect(slow_all_missed_dead,middle),:));
            allSDF_fixAcq_missed_dead.slow_longest= nanmean(SDF_FixAcq(intersect(slow_all_missed_dead,longest),:));
            
            allSDF_fixAcq_missed_dead.fast = nanmean(SDF_FixAcq(fast_all_missed_dead_withCleared,:));
            allSDF_fixAcq_missed_dead.fast_shortest = nanmean(SDF_FixAcq(intersect(fast_all_missed_dead_withCleared,shortest),:));
            allSDF_fixAcq_missed_dead.fast_middle = nanmean(SDF_FixAcq(intersect(fast_all_missed_dead_withCleared,middle),:));
            allSDF_fixAcq_missed_dead.fast_longest = nanmean(SDF_FixAcq(intersect(fast_all_missed_dead_withCleared,longest),:));
            
            if exist('Pupil_')
                allPupil_fixAcq_missed_dead.slow = nanmean(Pupil_fixAcq(slow_all_missed_dead,:));
                allPupil_fixAcq_missed_dead.slow_shortest = nanmean(Pupil_fixAcq(intersect(shortest,slow_all_missed_dead),:));
                allPupil_fixAcq_missed_dead.slow_middle = nanmean(Pupil_fixAcq(intersect(middle,slow_all_missed_dead),:));
                allPupil_fixAcq_missed_dead.slow_longest = nanmean(Pupil_fixAcq(intersect(longest,slow_all_missed_dead),:));
                
                allPupil_fixAcq_bc_missed_dead.slow = nanmean(Pupil_fixAcq_bc(slow_all_missed_dead,:));
                allPupil_fixAcq_bc_missed_dead.slow_shortest = nanmean(Pupil_fixAcq_bc(intersect(shortest,slow_all_missed_dead),:));
                allPupil_fixAcq_bc_missed_dead.slow_middle = nanmean(Pupil_fixAcq_bc(intersect(middle,slow_all_missed_dead),:));
                allPupil_fixAcq_bc_missed_dead.slow_longest = nanmean(Pupil_fixAcq_bc(intersect(longest,slow_all_missed_dead),:));
                
                allPupil_fixAcq_missed_dead.fast = nanmean(Pupil_fixAcq(fast_all_missed_dead_withCleared,:));
                allPupil_fixAcq_missed_dead.fast_shortest = nanmean(Pupil_fixAcq(intersect(shortest,fast_all_missed_dead_withCleared),:));
                allPupil_fixAcq_missed_dead.fast_middle = nanmean(Pupil_fixAcq(intersect(middle,fast_all_missed_dead_withCleared),:));
                allPupil_fixAcq_missed_dead.fast_longest = nanmean(Pupil_fixAcq(intersect(longest,fast_all_missed_dead_withCleared),:));
                
                allPupil_fixAcq_bc_missed_dead.fast = nanmean(Pupil_fixAcq_bc(fast_all_missed_dead_withCleared,:));
                allPupil_fixAcq_bc_missed_dead.fast_shortest = nanmean(Pupil_fixAcq_bc(intersect(shortest,fast_all_missed_dead_withCleared),:));
                allPupil_fixAcq_bc_missed_dead.fast_middle = nanmean(Pupil_fixAcq_bc(intersect(middle,fast_all_missed_dead_withCleared),:));
                allPupil_fixAcq_bc_missed_dead.fast_longest = nanmean(Pupil_fixAcq_bc(intersect(longest,fast_all_missed_dead_withCleared),:));
                
            end
            
        end
        
        
        
        
        
        
    end %for SAT
    
    
    
    
    %     %all files have these
    %     save([path filename '_' varlist{NeuronList(neuron)} '.mat'], ...
    %         'allACC','allRT','Fano_targ','Fano_fix','allSDF_targ','allSDF_fix','real_time_targ','real_time_fix', ...
    %         'filename','Plot_Time_Targ','Plot_Time_Fix','-mat')
    %
    %     %session/task specific variables
    %     if FixAcqPresent
    %         save([path filename '_' varlist{NeuronList(neuron)} '.mat'], ...
    %             'Fano_fixAcq','allSDF_fixAcq','-append','-mat')
    %     end
    %
    %     if ~isSAT
    %         save([path filename '_' varlist{NeuronList(neuron)} '.mat'], ...
    %         'allSDF_by_RT_targ','allSDF_by_RT_fix','allACC_RTntile','Fano_by_RT_targ','Fano_by_RT_fix','-append','-mat')
    %     end
    %
    %     if isSAT
    %         save([path filename '_' varlist{NeuronList(neuron)} '.mat'], ...
    %             'Fano_targ_made_dead','Fano_fix_made_dead','allSDF_targ_made_dead','allSDF_fix_made_dead','-append','-mat')
    %     end
    %
    %     if isSAT & FixAcqPresent %Will also then contain Pupil_ variable
    %         save([path filename '_' varlist{NeuronList(neuron)} '.mat'], ...
    %             'Fano_fixAcq_made_dead','allSDF_fixAcq_made_dead', ...
    %             'allPupil*','-append','-mat')
    %     end
    
    
    save([path filename '_' varlist{NeuronList(neuron)} '.mat'], ...
        'allACC*','allRT*','Fano*','allSDF*','real_time_targ','real_time_fix', ...
        'filename','Plot_Time_Targ','Plot_Time_Fix','-mat')
    
    if exist('Pupil_')
        save([path filename '_' varlist{NeuronList(neuron)} '.mat'], ...
            'allPupil*','-append','-mat')
    end
    
end %for neuron
