%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

batch_list1 = dir('/volumes/dump/analyses/JPSTC_Final/JPSTC_matrices/reg/LFP-LFP/BetweenHemi/Bad-Spurious/*.mat');
batch_list2 = dir('/volumes/dump/analyses/JPSTC_Final/JPSTC_matrices/reg/LFP-LFP/WithinHemi/Bad-Spurious/*.mat');


batch_list = cat(1,batch_list1,batch_list2);
%preallocate
above_close_correct_all(1:length(batch_list),1:251) = NaN;
above_close_errors_all(1:length(batch_list),1:251) = NaN;
above_close_ss2_all(1:length(batch_list),1:251) = NaN;
above_close_ss4_all(1:length(batch_list),1:251) = NaN;
above_close_ss8_all(1:length(batch_list),1:251) = NaN;
above_close_homo_all(1:length(batch_list),1:251) = NaN;
above_close_hete_all(1:length(batch_list),1:251) = NaN;


below_close_correct_all(1:length(batch_list),1:251) = NaN;
below_close_errors_all(1:length(batch_list),1:251) = NaN;
below_close_ss2_all(1:length(batch_list),1:251) = NaN;
below_close_ss4_all(1:length(batch_list),1:251) = NaN;
below_close_ss8_all(1:length(batch_list),1:251) = NaN;
below_close_homo_all(1:length(batch_list),1:251) = NaN;
below_close_hete_all(1:length(batch_list),1:251) = NaN;

main_correct_all(1:length(batch_list),1:251) = NaN;
main_errors_all(1:length(batch_list),1:251) = NaN;
main_ss2_all(1:length(batch_list),1:251) = NaN;
main_ss4_all(1:length(batch_list),1:251) = NaN;
main_ss8_all(1:length(batch_list),1:251) = NaN;
main_homo_all(1:length(batch_list),1:251) = NaN;
main_hete_all(1:length(batch_list),1:251) = NaN;

thickdiagonal_correct_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_errors_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_ss2_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_ss4_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_ss8_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_homo_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_hete_all(1:length(batch_list),1:251) = NaN;

thindiagonal_correct_all(1:length(batch_list),1:251) = NaN;
thindiagonal_errors_all(1:length(batch_list),1:251) = NaN;
thindiagonal_ss2_all(1:length(batch_list),1:251) = NaN;
thindiagonal_ss4_all(1:length(batch_list),1:251) = NaN;
thindiagonal_ss8_all(1:length(batch_list),1:251) = NaN;
thindiagonal_homo_all(1:length(batch_list),1:251) = NaN;
thindiagonal_hete_all(1:length(batch_list),1:251) = NaN;


JPSTC_correct_all(1:451,1:451,1:length(batch_list)) = NaN;
JPSTC_errors_all(1:451,1:451,1:length(batch_list)) = NaN;
JPSTC_ss2_all(1:451,1:451,1:length(batch_list)) = NaN;
JPSTC_ss4_all(1:451,1:451,1:length(batch_list)) = NaN;
JPSTC_ss8_all(1:451,1:451,1:length(batch_list)) = NaN;
JPSTC_homo_all(1:451,1:451,1:length(batch_list)) = NaN;
JPSTC_hete_all(1:451,1:451,1:length(batch_list)) = NaN;


%ABOVE close & main & thickdiagonal
for i = 1:length(batch_list)
    i
    load(batch_list(i).name,'JPSTC_correct','JPSTC_errors','JPSTC_correct_ss2','JPSTC_correct_ss4','JPSTC_correct_ss8','JPSTC_correct_homo','JPSTC_correct_hete','above_close_correct','above_close_errors','above_close_ss2','above_close_ss4','above_close_ss8','above_close_homo','above_close_hete','below_close_correct','below_close_errors','below_close_ss2','below_close_ss4','below_close_ss8','below_close_homo','below_close_hete','main_correct','main_errors','main_ss2','main_ss4','main_ss8','main_homo','main_hete','thickdiagonal_correct','thickdiagonal_errors','thickdiagonal_ss2','thickdiagonal_ss4','thickdiagonal_ss8','thickdiagonal_homo','thickdiagonal_hete','t_vector')
    
    thin_temp(1:3,1:length(t_vector)) = NaN;
    
    above_close_correct_all(i,1:length(t_vector)) = above_close_correct;
    above_close_errors_all(i,1:length(t_vector)) = above_close_errors;
    above_close_ss2_all(i,1:length(t_vector)) = above_close_ss2;
    above_close_ss4_all(i,1:length(t_vector)) = above_close_ss4;
    above_close_ss8_all(i,1:length(t_vector)) = above_close_ss8;
    above_close_homo_all(i,1:length(t_vector)) = above_close_homo;
    above_close_hete_all(i,1:length(t_vector)) = above_close_hete;

    below_close_correct_all(i,1:length(t_vector)) = below_close_correct;
    below_close_errors_all(i,1:length(t_vector)) = below_close_errors;
    below_close_ss2_all(i,1:length(t_vector)) = below_close_ss2;
    below_close_ss4_all(i,1:length(t_vector)) = below_close_ss4;
    below_close_ss8_all(i,1:length(t_vector)) = below_close_ss8;
    below_close_homo_all(i,1:length(t_vector)) = below_close_homo;
    below_close_hete_all(i,1:length(t_vector)) = below_close_hete;

    main_correct_all(i,1:length(t_vector)) = main_correct;
    main_errors_all(i,1:length(t_vector)) = main_errors;
    main_ss2_all(i,1:length(t_vector)) = main_ss2;
    main_ss4_all(i,1:length(t_vector)) = main_ss4;
    main_ss8_all(i,1:length(t_vector)) = main_ss8;
    main_homo_all(i,1:length(t_vector)) = main_homo;
    main_hete_all(i,1:length(t_vector)) = main_hete;


    thickdiagonal_correct_all(i,1:length(t_vector)) = thickdiagonal_correct;
    thickdiagonal_errors_all(i,1:length(t_vector)) = thickdiagonal_errors;
    thickdiagonal_ss2_all(i,1:length(t_vector)) = thickdiagonal_ss2;
    thickdiagonal_ss4_all(i,1:length(t_vector)) = thickdiagonal_ss4;
    thickdiagonal_ss8_all(i,1:length(t_vector)) = thickdiagonal_ss8;
    thickdiagonal_homo_all(i,1:length(t_vector)) = thickdiagonal_homo;
    thickdiagonal_hete_all(i,1:length(t_vector)) = thickdiagonal_hete;
    
   
    thin_temp(1,1:length(t_vector)) = below_close_correct;
    thin_temp(2,1:length(t_vector)) = above_close_correct;
    thin_temp(3,1:length(t_vector)) = main_correct;
    thindiagonal_correct_all(i,1:length(t_vector)) = nanmean(thin_temp);
    
    thin_temp(1,1:length(t_vector)) = below_close_errors;
    thin_temp(2,1:length(t_vector)) = above_close_errors;
    thin_temp(3,1:length(t_vector)) = main_errors;
    thindiagonal_errors_all(i,1:length(t_vector)) = nanmean(thin_temp);
        
    thin_temp(1,1:length(t_vector)) = below_close_ss2;
    thin_temp(2,1:length(t_vector)) = above_close_ss2;
    thin_temp(3,1:length(t_vector)) = main_ss2;
    thindiagonal_ss2_all(i,1:length(t_vector)) = nanmean(thin_temp);
    
    thin_temp(1,1:length(t_vector)) = below_close_ss4;
    thin_temp(2,1:length(t_vector)) = above_close_ss4;
    thin_temp(3,1:length(t_vector)) = main_ss4;
    thindiagonal_ss4_all(i,1:length(t_vector)) = nanmean(thin_temp);
    
    thin_temp(1,1:length(t_vector)) = below_close_ss8;
    thin_temp(2,1:length(t_vector)) = above_close_ss8;
    thin_temp(3,1:length(t_vector)) = main_ss8;
    thindiagonal_ss8_all(i,1:length(t_vector)) = nanmean(thin_temp);
    
    
    thin_temp(1,1:length(t_vector)) = below_close_homo;
    thin_temp(2,1:length(t_vector)) = above_close_homo;
    thin_temp(3,1:length(t_vector)) = main_homo;
    thindiagonal_homo_all(i,1:length(t_vector)) = nanmean(thin_temp);
    

    thin_temp(1,1:length(t_vector)) = below_close_hete;
    thin_temp(2,1:length(t_vector)) = above_close_hete;
    thin_temp(3,1:length(t_vector)) = main_hete;
    thindiagonal_hete_all(i,1:length(t_vector)) = nanmean(thin_temp);
    
    %mean JPSTC
    JPSTC_correct_all(1:451,1:451,i) = JPSTC_correct;
    JPSTC_errors_all(1:451,1:451,i) = JPSTC_errors;
    JPSTC_ss2_all(1:451,1:451,i) = JPSTC_correct_ss2;
    JPSTC_ss4_all(1:451,1:451,i) = JPSTC_correct_ss4;
    JPSTC_ss8_all(1:451,1:451,i) = JPSTC_correct_ss8;
    JPSTC_homo_all(1:451,1:451,i) = JPSTC_correct_homo;
    JPSTC_hete_all(1:451,1:451,i) = JPSTC_correct_hete;

    clear above_close_ss2 above_close_ss4 above_close_ss8 below_close_ss2 below_close_ss4 ...
        below_close_ss8 main_ss2 main_ss4 main_ss8 thickdiagonal_ss2 ...
        thickdiagonal_ss4 thickdiagonal_ss8 JPSTC_correct_ss2 JPSTC_correct_ss4 JPSTC_correct_ss8

    clear thin_temp
end
clear batch_list i
