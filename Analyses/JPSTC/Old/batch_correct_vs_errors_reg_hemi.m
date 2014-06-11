%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

batch_list = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-LFP/BetweenHemi/*.mat');
%batch_list = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-LFP/WithinHemi/*.mat');

%batch_list = cat(1,batch_list1,batch_list2);
%preallocate

above_close_correct(1:length(batch_list),1:251) = NaN;
above_close_errors(1:length(batch_list),1:251) = NaN;

below_close_correct(1:length(batch_list),1:251) = NaN;
below_close_errors(1:length(batch_list),1:251) = NaN;

main_correct(1:length(batch_list),1:251) = NaN;
main_errors(1:length(batch_list),1:251) = NaN;
main_close_ss8_all(1:length(batch_list),1:251) = NaN;

thickdiagonal_correct(1:length(batch_list),1:251) = NaN;
thickdiagonal_errors(1:length(batch_list),1:251) = NaN;


JPSTC_all_correct(1:451,1:451,1:length(batch_list)) = NaN;
JPSTC_all_errors(1:451,1:451,1:length(batch_list)) = NaN;
%ABOVE close & main & thickdiagonal
for i = 1:length(batch_list)
    i
    load(batch_list(i).name,'JPSTC_correct','JPSTC_errors','above_close_correct','above_close_errors','below_close_correct','below_close_errors','main_correct','main_errors','thickdiagonal_correct','thickdiagonal_errors','t_vector')
    above_close_correct_all(i,1:length(t_vector)) = above_close_correct;
    above_close_errors_all(i,1:length(t_vector)) = above_close_errors;

       below_close_correct_all(i,1:length(t_vector)) = below_close_correct;
    below_close_errors_all(i,1:length(t_vector)) = below_close_errors;
    
    main_correct_all(i,1:length(t_vector)) = main_correct;
    main_errors_all(i,1:length(t_vector)) = main_errors;
    
    thickdiagonal_correct_all(i,1:length(t_vector)) = thickdiagonal_correct;
    thickdiagonal_errors_all(i,1:length(t_vector)) = thickdiagonal_errors;
    
    %mean JPSTC
    JPSTC_all_correct(1:451,1:451,i) = JPSTC_correct;
    JPSTC_all_errors(1:451,1:451,i) = JPSTC_errors;
  
    clear above_close_correct above_close_errors below_close_correct below_close_errors ...
        main_correct main_errors thickdiagonal_correct thickdiagonal_errors
end
clear batch_list i


%plot main diagonal
figure
set(gcf,'color','white')
orient landscape

subplot(2,2,1)
plot(t_vector,nanmean(main_correct_all),t_vector,nanmean(main_errors_all))
legend('Correct','Errors')
title('Main diagonal averages')

%plot above
subplot(2,2,2)
plot(t_vector,nanmean(above_close_correct_all),t_vector,nanmean(above_close_errors_all))
legend('Correct','Errors')
title('Above diagonal averages')

%plot below
subplot(2,2,3)
plot(t_vector,nanmean(below_close_correct_all),t_vector,nanmean(below_close_errors_all))
legend('Correct','Errors')
title('Below diagonal averages')

%plot thickdiagonal
subplot(2,2,4)
plot(t_vector,nanmean(thickdiagonal_correct_all),t_vector,nanmean(thickdiagonal_errors_all))
legend('Correct','Errors')
title('Thick diagonal averages')

