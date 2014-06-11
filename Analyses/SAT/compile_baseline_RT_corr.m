cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
%[filename1 unit1] = textread('SAT_Vis_NoMed_Q.txt','%s %s');
%[filename2 unit2] = textread('SAT_VisMove_NoMed_Q.txt','%s %s');
[filename3 unit3] = textread('SAT_Vis_NoMed_S.txt','%s %s');
[filename4 unit4] = textread('SAT_VisMove_NoMed_S.txt','%s %s');
%[filename5 unit5] = textread('SAT_Vis_Med_Q.txt','%s %s');
%[filename6 unit6] = textread('SAT_VisMove_Med_Q.txt','%s %s');
[filename7 unit7] = textread('SAT_Vis_Med_S.txt','%s %s');
[filename8 unit8] = textread('SAT_VisMove_Med_S.txt','%s %s');
filename = [filename3 ; filename4 ; filename7 ; filename8];
unit = [unit3 ; unit4 ; unit7 ; unit8];


win = [-300 0];

%preallocate
for file = 1:length(filename)
    
    load(filename{file},unit{file},'Correct_','Target_','SRT','SAT_','Errors_')
    filename{file}
    
    
    [r dat] = baseline_RT_corr(unit{file},win,0);
    
    all_r.slow_correct_made_dead(file,1) = r.slow_correct_made_dead;
    all_r.slow_correct_missed_dead(file,1) = r.slow_correct_missed_dead;
    all_r.slow_correct_made_missed(file,1) = r.slow_correct_made_missed;
    
    all_r.slow_errors_made_dead(file,1) = r.slow_errors_made_dead;
    all_r.slow_errors_missed_dead(file,1) = r.slow_errors_missed_dead;
    all_r.slow_errors_made_missed(file,1) = r.slow_errors_made_missed;
    
    all_r.slow_correct_made_missed(file,1) = r.slow_correct_made_missed;
        
    all_r.slow_all(file,1) = r.slow_all;
    
    
    all_r.fast_correct_made_dead(file,1) = r.fast_correct_made_dead;
    all_r.fast_correct_missed_dead(file,1) = r.fast_correct_missed_dead;
    all_r.fast_correct_made_missed(file,1) = r.fast_correct_made_missed;
    
    all_r.fast_errors_made_dead(file,1) = r.fast_errors_made_dead;
    all_r.fast_errors_missed_dead(file,1) = r.fast_errors_missed_dead;
    all_r.fast_errors_made_missed(file,1) = r.fast_errors_made_missed;
    
    
    all_r.fast_all(file,1) = r.fast_all;
    
    
%     all_r.ALL_CORRECT(file,1) = r.ALL_CORRECT;
%     all_r.ALL_ERRORS(file,1) = r.ALL_ERRORS;
%     all_r.ALL_ALL(file,1) = r.ALL_ALL;
    
    
    all_dat.h(file,1) = dat.h;
    all_dat.h_dir(file,1) = dat.h_dir;
    
    all_dat.slow_correct_made_dead(1:length(dat.slow_correct_made_dead),1:2,file) = dat.slow_correct_made_dead;
    all_dat.slow_correct_missed_dead(1:length(dat.slow_correct_missed_dead),1:2,file) = dat.slow_correct_missed_dead;
    all_dat.slow_correct_made_missed(1:length(dat.slow_correct_made_missed),1:2,file) = dat.slow_correct_made_missed;
    
    all_dat.slow_errors_made_dead(1:length(dat.slow_errors_made_dead),1:2,file) = dat.slow_errors_made_dead;
    all_dat.slow_errors_missed_dead(1:length(dat.slow_errors_missed_dead),1:2,file) = dat.slow_errors_missed_dead;
    all_dat.slow_errors_made_missed(1:length(dat.slow_errors_made_missed),1:2,file) = dat.slow_errors_made_missed;
    
    all_dat.slow_all(1:length(dat.slow_all),1:2,file) = dat.slow_all;
    
    
    all_dat.fast_correct_made_dead(1:length(dat.fast_correct_made_dead),1:2,file) = dat.fast_correct_made_dead;
    all_dat.fast_correct_missed_dead(1:length(dat.fast_correct_missed_dead),1:2,file) = dat.fast_correct_missed_dead;
    all_dat.fast_correct_made_missed(1:length(dat.fast_correct_made_missed),1:2,file) = dat.fast_correct_made_missed;
    
    all_dat.fast_errors_made_dead(1:length(dat.fast_errors_made_dead),1:2,file) = dat.fast_errors_made_dead;
    all_dat.fast_errors_missed_dead(1:length(dat.fast_errors_missed_dead),1:2,file) = dat.fast_errors_missed_dead;
    all_dat.fast_errors_made_missed(1:length(dat.fast_errors_made_missed),1:2,file) = dat.fast_errors_made_missed;
    

    all_dat.fast_all(1:length(dat.fast_all),1:2,file) = dat.fast_all;
    
    if any(SAT_(:,1) == 2)
        all_dat.med_correct(1:length(dat.med_correct),1:2,file) = dat.med_correct;
        all_dat.med_errors(1:length(dat.med_errors),1:2,file) = dat.med_errors;
        all_dat.med_all(1:length(dat.med_all),1:2,file) = dat.med_all;
    end
    
%     all_dat.ALL_CORRECT(1:length(dat.ALL_CORRECT),1:2,file) = dat.ALL_CORRECT;
%     all_dat.ALL_ERRORS(1:length(dat.ALL_ERRORS),1:2,file) = dat.ALL_ERRORS;
%     all_dat.ALL_ALL(1:length(dat.ALL_ALL),1:2,file) = dat.ALL_ALL;
    
    keep win filename file all_dat all_r unit
    
end

%remove all 0's again - they were put there because of unequal matrix sizes
all_dat.slow_correct_made_dead(find(all_dat.slow_correct_made_dead == 0)) = NaN;
all_dat.slow_correct_missed_dead(find(all_dat.slow_correct_missed_dead == 0)) = NaN;
all_dat.slow_correct_made_missed(find(all_dat.slow_correct_made_missed == 0)) = NaN;
all_dat.slow_errors_made_dead(find(all_dat.slow_errors_made_dead == 0)) = NaN;
all_dat.slow_errors_missed_dead(find(all_dat.slow_errors_missed_dead == 0)) = NaN;
all_dat.slow_errors_made_missed(find(all_dat.slow_errors_made_missed == 0)) = NaN;
all_dat.slow_all(find(all_dat.slow_all == 0)) = NaN;

all_dat.fast_correct_made_dead(find(all_dat.fast_correct_made_dead == 0)) = NaN;
all_dat.fast_correct_missed_dead(find(all_dat.fast_correct_missed_dead == 0)) = NaN;
all_dat.fast_correct_made_missed(find(all_dat.fast_correct_made_missed == 0)) = NaN;
all_dat.fast_errors_made_dead(find(all_dat.fast_errors_made_dead == 0)) = NaN;
all_dat.fast_errors_missed_dead(find(all_dat.fast_errors_missed_dead == 0)) = NaN;
all_dat.fast_errors_made_missed(find(all_dat.fast_errors_made_missed == 0)) = NaN;
all_dat.fast_all(find(all_dat.fast_all == 0)) = NaN;

if exist('all_dat.med_correct')
    all_dat.med_correct(find(all_dat.med_correct == 0)) = NaN;
    all_dat.med_errors(find(all_dat.med_errors == 0)) = NaN;
    all_dat.med_all(find(all_dat.med_all == 0)) = NaN;
end

% all_dat.ALL_CORRECT(find(all_dat.ALL_CORRECT == 0)) = NaN;
% all_dat.ALL_ERRORS(find(all_dat.ALL_ERRORS == 0)) = NaN;
% all_dat.ALL_ALL(find(all_dat.ALL_ALL == 0)) = NaN;
