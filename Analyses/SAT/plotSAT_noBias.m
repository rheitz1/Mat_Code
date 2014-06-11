% Function to plot SAT means/accuracy rates while **disregarding**
% specific screen positions.  This is useful to gauge whether or 
% not a bias against a particular screen position accounts for
% the mean effects.
%
% removeLoc is a vector of screen positions you wish to disregard
%
% RPH

function [] = plotSAT_noBias(removeLoc)

SRT = evalin('caller','SRT');
Target_ = evalin('caller','Target_');
Correct_ = evalin('caller','Correct_');
Errors_ = evalin('caller','Errors_');
SAT_ = evalin('caller','SAT_');


try
    saccLoc = evalin('caller','saccLoc');
catch
    
    EyeX_ = evalin('caller','EyeX_');
    EyeY_ = evalin('caller','EyeY_');
    newfile = evalin('caller','newfile');
    [~,saccLoc] = getSRT(EyeX_,EyeY_);
    assignin('caller','saccLoc',saccLoc);
end


%============
% FIND TRIALS
%===================================================================
getTrials_SAT


trlsToRemove = find(ismember(Target_(:,2),removeLoc));

disp(['Removing ' mat2str(length(trlsToRemove)) ' trials'])

slow_correct_made_dead = setdiff(slow_correct_made_dead,trlsToRemove);
slow_correct_missed_dead = setdiff(slow_correct_missed_dead,trlsToRemove);
slow_errors_made_dead = setdiff(slow_errors_made_dead,trlsToRemove);
slow_errors_missed_dead = setdiff(slow_errors_missed_dead,trlsToRemove);
slow_all_made_dead = setdiff(slow_all_made_dead,trlsToRemove);
slow_all_missed_dead = setdiff(slow_all_missed_dead,trlsToRemove);
slow_all = setdiff(slow_all,trlsToRemove);

med_correct = setdiff(med_correct,trlsToRemove);
med_errors = setdiff(med_errors,trlsToRemove);
med_all = setdiff(med_all,trlsToRemove);

fast_correct_made_dead_withCleared = setdiff(fast_correct_made_dead_withCleared,trlsToRemove);
fast_correct_made_dead_noCleared = setdiff(fast_correct_made_dead_noCleared,trlsToRemove);
fast_correct_missed_dead_withCleared = setdiff(fast_correct_missed_dead_withCleared,trlsToRemove);
fast_correct_missed_dead_noCleared = setdiff(fast_correct_missed_dead_noCleared,trlsToRemove);

fast_errors_made_dead_withCleared = setdiff(fast_errors_made_dead_withCleared,trlsToRemove);
fast_errors_made_dead_noCleared = setdiff(fast_errors_made_dead_noCleared,trlsToRemove);
fast_errors_missed_dead_withCleared = setdiff(fast_errors_missed_dead_withCleared,trlsToRemove);
fast_errors_missed_dead_noCleared = setdiff(fast_errors_missed_dead_noCleared,trlsToRemove);

fast_all_made_dead_withCleared = setdiff(fast_all_made_dead_withCleared,trlsToRemove);
fast_all_made_dead_noCleared = setdiff(fast_all_made_dead_noCleared,trlsToRemove);
fast_all_missed_dead_withCleared = setdiff(fast_all_made_dead_withCleared,trlsToRemove);
fast_all_missed_dead_noCleared = setdiff(fast_all_made_dead_noCleared,trlsToRemove);
fast_all_withCleared = setdiff(fast_all_withCleared,trlsToRemove);
fast_all_noCleared = setdiff(fast_all_noCleared,trlsToRemove);

%====================
% Calculate ACC rates
%percentage of CORRECT trials that missed the deadline
prc_missed_slow_correct = length(slow_correct_missed_dead) / (length(slow_correct_made_dead) + length(slow_correct_missed_dead));
prc_missed_fast_correct_withCleared = length(fast_correct_missed_dead_withCleared) / (length(fast_correct_made_dead_withCleared) + length(fast_correct_missed_dead_withCleared));
prc_missed_fast_correct_noCleared = length(fast_correct_missed_dead_noCleared) / (length(fast_correct_made_dead_noCleared) + length(fast_correct_missed_dead_noCleared));

%ACC rate for made deadlines
ACC.slow_made_dead = length(slow_correct_made_dead) / length(slow_all_made_dead);
ACC.fast_made_dead_withCleared = length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared);
ACC.fast_made_dead_noCleared = length(fast_correct_made_dead_noCleared) / length(fast_all_made_dead_noCleared);


%ACC rate for missed deadlines
ACC.slow_missed_dead = length(slow_correct_missed_dead) / length(slow_all_missed_dead);
ACC.fast_missed_dead_withCleared = length(fast_correct_missed_dead_withCleared) / length(fast_all_missed_dead_withCleared);
ACC.fast_missed_dead_noCleared = length(fast_correct_missed_dead_noCleared) / length(fast_all_missed_dead_noCleared);


%overall ACC rate for made + missed deadlines
ACC.slow_made_missed = length(slow_correct_made_missed) / length(slow_all);
ACC.fast_made_missed_withCleared = length(fast_correct_made_missed_withCleared) / length(fast_all_withCleared);
ACC.fast_made_missed_noCleared = length(fast_correct_made_missed_noCleared) / length(fast_all_noCleared);

ACC.med = length(med_correct) / length(med_all);

% CDFs for correct trials, made deadlines
[bins_correct_slow_made_dead cdf_correct_slow_made_dead] = getCDF(SRT(slow_correct_made_dead,1),50);
[bins_correct_fast_made_dead_withCleared cdf_correct_fast_made_dead_withCleared] = getCDF(SRT(fast_correct_made_dead_withCleared,1),50);
[bins_correct_fast_made_dead_noCleared cdf_correct_fast_made_dead_noCleared] = getCDF(SRT(fast_correct_made_dead_noCleared,1),50);

% CDFs for correct trials, missed deadlines
[bins_correct_slow_missed_dead cdf_correct_slow_missed_dead] = getCDF(SRT(slow_correct_missed_dead,1),50);
[bins_correct_fast_missed_dead_withCleared cdf_correct_fast_missed_dead_withCleared] = getCDF(SRT(fast_correct_missed_dead_withCleared,1),50);
[bins_correct_fast_missed_dead_noCleared cdf_correct_fast_missed_dead_noCleared] = getCDF(SRT(fast_correct_missed_dead_noCleared,1),50);

% CDFs for correct trials, made + missed deadlines
[bins_correct_slow_made_missed cdf_correct_slow_made_missed] = getCDF(SRT(slow_correct_made_missed,1),50);
[bins_correct_fast_made_missed_withCleared cdf_correct_fast_made_missed_withCleared] = getCDF(SRT(fast_correct_made_missed_withCleared,1),50);
[bins_correct_fast_made_missed_noCleared cdf_correct_fast_made_missed_noCleared] = getCDF(SRT(fast_correct_made_missed_noCleared,1),50);

% Medium
[bins_correct_med cdf_correct_med] = getCDF(SRT(med_correct,1),50);


    figure
    subplot(3,2,1)
    plot(bins_correct_slow_made_dead,cdf_correct_slow_made_dead,'r', ...
        bins_correct_med,cdf_correct_med,'k', ...
        bins_correct_fast_made_dead_withCleared,cdf_correct_fast_made_dead_withCleared,'g', ...
        bins_correct_fast_made_dead_noCleared,cdf_correct_fast_made_dead_noCleared,'--g')
    
    xlim([0 1000])
    %vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs correct made deadlines')
    
    subplot(3,2,2)
    bar(1:4,[ACC.slow_made_dead ACC.med ACC.fast_made_dead_withCleared ACC.fast_made_dead_noCleared])
    ylim([0 1])
    set(gca,'xticklabel',['   slow    ' ;'     med   '; ' fst WiClr ' ; ' fast NoClr'])
    title('ACC all made deadlines')
    
    subplot(3,2,3)
    plot(bins_correct_slow_missed_dead,cdf_correct_slow_missed_dead,'r', ...
        bins_correct_med,cdf_correct_med,'k', ...
        bins_correct_fast_missed_dead_withCleared,cdf_correct_fast_missed_dead_withCleared,'g', ...
        bins_correct_fast_missed_dead_noCleared,cdf_correct_fast_missed_dead_noCleared,'--g')
    
    xlim([0 1000])
    %vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs correct missed deadlines')
    
    subplot(3,2,4)
    bar(1:4,[ACC.slow_missed_dead ACC.med ACC.fast_missed_dead_withCleared ACC.fast_missed_dead_noCleared])
    ylim([0 1])
    set(gca,'xticklabel',['   slow    ' ;'     med   '; ' fst WiClr ' ; ' fast NoClr'])
    title('ACC missed deadlines')
    
    
    subplot(3,2,5)
    plot(bins_correct_slow_made_missed,cdf_correct_slow_made_missed,'r', ...
        bins_correct_med,cdf_correct_med,'k', ...
        bins_correct_fast_made_missed_withCleared,cdf_correct_fast_made_missed_withCleared,'g', ...
        bins_correct_fast_made_missed_noCleared,cdf_correct_fast_made_missed_noCleared,'--g')
    
    xlim([0 1000])
    %vline(max(SAT_(find(SAT_(:,2) == 3),3)),'k')
    title('RTs correct missed + made deadlines')
    
    subplot(3,2,6)
    bar(1:4,[ACC.slow_made_missed ACC.med ACC.fast_made_missed_withCleared ACC.fast_made_missed_noCleared])
    ylim([0 1])
    set(gca,'xticklabel',['   slow    ' ;'     med   '; ' fst WiClr ' ; ' fast NoClr'])
    title('ACC missed + made deadlines')
    
    
    
    
    %================
    % Histograms
    %     multiHist_SAT(50,slow_correct_made_dead,fast_correct_made_dead)
    %     title('Correct Made Deadlines')
    %
    %     multiHist_SAT(50,slow_correct_made_missed,fast_correct_made_missed)
    %     title('Correct Made + Missed Deadlines')
    

