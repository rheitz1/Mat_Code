% plots SAT accuracy effect by screen location
%
% RPH

function [] = plotSAT_ACC_SL()

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

trunc_RT = 2000;
plotBaselineBlocks = 1;
separate_cleared_nocleared = 0;
within_condition_RT_bins = 0; % Do you want to plot fast/med/slow bins within each FAST and SLOW condition?
match_variability = 0;
plot_integrals = 0;
basewin = [400 500]; %baseline correction window for AD channels

%============
% FIND TRIALS
%===================================================================
figure

for pos = 0:7
    switch pos
        case 0
            screenloc = 6;
        case 1
            screenloc = 3;
        case 2
            screenloc = 2;
        case 3
            screenloc = 1;
        case 4
            screenloc = 4;
        case 5
            screenloc = 7;
        case 6
            screenloc = 8;
        case 7
            screenloc = 9;
    end
    
    
    med_correct = find(saccLoc == pos & Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 2);
    med_errors = find(saccLoc == pos & Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 2);
    med_all = [med_correct ; med_errors];
    
    
    %All correct trials w/ made deadlines
    slow_correct_made_dead = find(saccLoc == pos & Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_correct_made_dead_withCleared = find(saccLoc == pos & Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
    fast_correct_made_dead_noCleared = find(saccLoc == pos & Correct_(:,2) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);
    
    slow_errors_made_dead = find(saccLoc == pos & Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 1 & SRT(:,1) >= SAT_(:,3));
    fast_errors_made_dead_withCleared = find(saccLoc == pos & Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3));
    fast_errors_made_dead_noCleared = find(saccLoc == pos & Errors_(:,5) == 1 & SRT(:,1) < trunc_RT & Target_(:,2) ~= 255 & SAT_(:,1) == 3 & SRT(:,1) <= SAT_(:,3) & SAT_(:,11) == 0);
    
    slow_all_made_dead = [slow_correct_made_dead ; slow_errors_made_dead];
    fast_all_made_dead_withCleared = [fast_correct_made_dead_withCleared ; fast_errors_made_dead_withCleared];
    fast_all_made_dead_noCleared = [fast_correct_made_dead_noCleared ; fast_errors_made_dead_noCleared];
    
    ACC.slow_made_dead = length(slow_correct_made_dead) / length(slow_all_made_dead);
    ACC.fast_made_dead_withCleared = length(fast_correct_made_dead_withCleared) / length(fast_all_made_dead_withCleared);
    ACC.fast_made_dead_noCleared = length(fast_correct_made_dead_noCleared) / length(fast_all_made_dead_noCleared);
    
    ACC.med = length(med_correct) / length(med_all);
    
    subplot(3,3,screenloc)
    bar(1:4,[ACC.slow_made_dead ACC.med ACC.fast_made_dead_withCleared ACC.fast_made_dead_noCleared])
    ylim([.3 1])
    set(gca,'xticklabel',['   slow    ' ;'     med   '; ' fst WiClr ' ; ' fast NoClr'])
    
    clear med* slow* fast* ACC*
end

