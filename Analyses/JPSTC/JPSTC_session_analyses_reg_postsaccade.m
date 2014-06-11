%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

batch_list = dir('/volumes/dump2/correct_vs_errors_postsaccade_truncated/LFP-LFP/*.mat');
%batch_list = dir('/volumes/dump2/analyses/JPSTC/JPSTC_matrices/reg/correct_vs_errors_postsaccade/LFP-LFP/*.mat');
%batch_list2 = dir('/volumes/dump/analyses/JPSTC_Final/JPSTC_matrices/reg/LFP-LFP/WithinHemi/Bad-Spurious/*.mat');
%batch_list = cat(1,batch_list1,batch_list2);


%initialize between-session variables
above_close_correct_postsaccade_all(1:length(batch_list),1:251) = NaN;
above_close_errors_postsaccade_all(1:length(batch_list),1:251) = NaN;
below_close_correct_postsaccade_all(1:length(batch_list),1:251) = NaN;
below_close_errors_postsaccade_all(1:length(batch_list),1:251) = NaN;
main_correct_postsaccade_all(1:length(batch_list),1:251) = NaN;
main_errors_postsaccade_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_correct_postsaccade_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_errors_postsaccade_all(1:length(batch_list),1:251) = NaN;
thindiagonal_correct_postsaccade_all(1:length(batch_list),1:251) = NaN;
thindiagonal_errors_postsaccade_all(1:length(batch_list),1:251) = NaN;
JPSTC_correct_postsaccade_all(1:451,1:451,1:length(batch_list)) = NaN;
JPSTC_errors_postsaccade_all(1:451,1:451,1:length(batch_list)) = NaN;

for i = 1:length(batch_list)
    i
    load(batch_list(i).name,'JPSTC_correct_saccade','JPSTC_errors_saccade','above_close_correct_saccade','above_close_errors_saccade','below_close_correct_saccade','below_close_errors_saccade','main_correct_saccade','main_errors_saccade','thickdiagonal_correct_saccade','thickdiagonal_errors_saccade','t_vector','-mat')
    
    thin_temp(1:3,1:length(t_vector)) = NaN;
    
    above_close_correct_postsaccade_all(i,1:length(t_vector)) = above_close_correct_saccade;
    above_close_errors_postsaccade_all(i,1:length(t_vector)) = above_close_errors_saccade;

    below_close_correct_postsaccade_all(i,1:length(t_vector)) = below_close_correct_saccade;
    below_close_errors_postsaccade_all(i,1:length(t_vector)) = below_close_errors_saccade;

    main_correct_postsaccade_all(i,1:length(t_vector)) = main_correct_saccade;
    main_errors_postsaccade_all(i,1:length(t_vector)) = main_errors_saccade;

    thickdiagonal_correct_postsaccade_all(i,1:length(t_vector)) = thickdiagonal_correct_saccade;
    thickdiagonal_errors_postsaccade_all(i,1:length(t_vector)) = thickdiagonal_errors_saccade;

   
    thin_temp(1,1:length(t_vector)) = below_close_correct_saccade;
    thin_temp(2,1:length(t_vector)) = above_close_correct_saccade;
    thin_temp(3,1:length(t_vector)) = main_correct_saccade;
    thindiagonal_correct_postsaccade_all(i,1:length(t_vector)) = nanmean(thin_temp);
    
    thin_temp(1,1:length(t_vector)) = below_close_errors_saccade;
    thin_temp(2,1:length(t_vector)) = above_close_errors_saccade;
    thin_temp(3,1:length(t_vector)) = main_errors_saccade;
    thindiagonal_errors_postsaccade_all(i,1:length(t_vector)) = nanmean(thin_temp);
        
    %mean JPSTC
    JPSTC_correct_postsaccade_all(1:451,1:451,i) = JPSTC_correct_saccade;
    JPSTC_errors_postsaccade_all(1:451,1:451,i) = JPSTC_errors_saccade;

    clear thin_temp
end
clear batch_list i