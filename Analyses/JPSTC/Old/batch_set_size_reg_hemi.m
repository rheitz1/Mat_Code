%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all


%B E T W E E N   H E M I
batch_list = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-LFP/BetweenHemi/*.mat');

%batch_list = cat(1,batch_list1,batch_list2);

%preallocate
above_close_ss2_all(1:length(batch_list),1:251) = NaN;
above_close_ss4_all(1:length(batch_list),1:251) = NaN;
above_close_ss8_all(1:length(batch_list),1:251) = NaN;

below_close_ss2_all(1:length(batch_list),1:251) = NaN;
below_close_ss4_all(1:length(batch_list),1:251) = NaN;
below_close_ss8_all(1:length(batch_list),1:251) = NaN;

main_close_ss2_all(1:length(batch_list),1:251) = NaN;
main_close_ss4_all(1:length(batch_list),1:251) = NaN;
main_close_ss8_all(1:length(batch_list),1:251) = NaN;

thickdiagonal_ss2_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_ss4_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_ss8_all(1:length(batch_list),1:251) = NaN;



%ABOVE close & main & thickdiagonal
for i = 1:length(batch_list)
    i
    load(batch_list(i).name,'JPSTC_correct_ss2','JPSTC_correct_ss4','JPSTC_correct_ss8','above_close_ss2','above_close_ss4','above_close_ss8','below_close_ss2','below_close_ss4','below_close_ss8','main_ss2','main_ss4','main_ss8','thickdiagonal_ss2','thickdiagonal_ss4','thickdiagonal_ss8','t_vector')
    above_close_ss2_all(i,1:length(t_vector)) = above_close_ss2;
    above_close_ss4_all(i,1:length(t_vector)) = above_close_ss4;
    above_close_ss8_all(i,1:length(t_vector)) = above_close_ss8;

    below_close_ss2_all(i,1:length(t_vector)) = below_close_ss2;
    below_close_ss4_all(i,1:length(t_vector)) = below_close_ss4;
    below_close_ss8_all(i,1:length(t_vector)) = below_close_ss8;

    main_ss2_all(i,1:length(t_vector)) = main_ss2;
    main_ss4_all(i,1:length(t_vector)) = main_ss4;
    main_ss8_all(i,1:length(t_vector)) = main_ss8;


    thickdiagonal_ss2_all(i,1:length(t_vector)) = thickdiagonal_ss2;
    thickdiagonal_ss4_all(i,1:length(t_vector)) = thickdiagonal_ss4;
    thickdiagonal_ss8_all(i,1:length(t_vector)) = thickdiagonal_ss8;

    %mean JPSTC
    JPSTC_all_ss2(1:451,1:451,i) = JPSTC_correct_ss2;
    JPSTC_all_ss4(1:451,1:451,i) = JPSTC_correct_ss4;
    JPSTC_all_ss8(1:451,1:451,i) = JPSTC_correct_ss8;

    clear above_close_ss2 above_close_ss4 above_close_ss8 below_close_ss2 below_close_ss4 ...
        below_close_ss8 main_ss2 main_ss4 main_ss8 thickdiagonal_ss2 ...
        thickdiagonal_ss4 thickdiagonal_ss8 JPSTC_correct_ss2 JPSTC_correct_ss4 JPSTC_correct_ss8

end
clear batch_list i


%plot main diagonal
figure
set(gcf,'color','white')
orient landscape

subplot(2,2,1)
plot(t_vector,nanmean(main_ss2_all),t_vector,nanmean(main_ss4_all),t_vector,nanmean(main_ss8_all))
legend('Set size 2','Set size 4','set size 8')
title('Main diagonal averages (between)')

%plot above
subplot(2,2,2)
plot(t_vector,nanmean(above_close_ss2_all),t_vector,nanmean(above_close_ss4_all),t_vector,nanmean(above_close_ss8_all))
legend('Set size 2','Set size 4','set size 8')
title('Above diagonal averages (between)')

%plot below
subplot(2,2,3)
plot(t_vector,nanmean(below_close_ss2_all),t_vector,nanmean(below_close_ss4_all),t_vector,nanmean(below_close_ss8_all))
legend('Set size 2','Set size 4','set size 8')
title('Below diagonal averages (between)')

%plot thickdiagonal
subplot(2,2,4)
plot(t_vector,nanmean(thickdiagonal_ss2_all),t_vector,nanmean(thickdiagonal_ss4_all),t_vector,nanmean(thickdiagonal_ss8_all))
legend('Set size 2','Set size 4','set size 8')
title('Thick diagonal averages (between)')

clear batch_list

% W I T H I N   H E M I
batch_list = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-LFP/WithinHemi/*.mat');
above_close_ss2_all(1:length(batch_list),1:251) = NaN;
above_close_ss4_all(1:length(batch_list),1:251) = NaN;
above_close_ss8_all(1:length(batch_list),1:251) = NaN;

below_close_ss2_all(1:length(batch_list),1:251) = NaN;
below_close_ss4_all(1:length(batch_list),1:251) = NaN;
below_close_ss8_all(1:length(batch_list),1:251) = NaN;

main_close_ss2_all(1:length(batch_list),1:251) = NaN;
main_close_ss4_all(1:length(batch_list),1:251) = NaN;
main_close_ss8_all(1:length(batch_list),1:251) = NaN;

thickdiagonal_ss2_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_ss4_all(1:length(batch_list),1:251) = NaN;
thickdiagonal_ss8_all(1:length(batch_list),1:251) = NaN;



%ABOVE close & main & thickdiagonal
for i = 1:length(batch_list)
    i
    load(batch_list(i).name,'JPSTC_correct_ss2','JPSTC_correct_ss4','JPSTC_correct_ss8','above_close_ss2','above_close_ss4','above_close_ss8','below_close_ss2','below_close_ss4','below_close_ss8','main_ss2','main_ss4','main_ss8','thickdiagonal_ss2','thickdiagonal_ss4','thickdiagonal_ss8','t_vector')
    above_close_ss2_all(i,1:length(t_vector)) = above_close_ss2;
    above_close_ss4_all(i,1:length(t_vector)) = above_close_ss4;
    above_close_ss8_all(i,1:length(t_vector)) = above_close_ss8;

    below_close_ss2_all(i,1:length(t_vector)) = below_close_ss2;
    below_close_ss4_all(i,1:length(t_vector)) = below_close_ss4;
    below_close_ss8_all(i,1:length(t_vector)) = below_close_ss8;

    main_ss2_all(i,1:length(t_vector)) = main_ss2;
    main_ss4_all(i,1:length(t_vector)) = main_ss4;
    main_ss8_all(i,1:length(t_vector)) = main_ss8;


    thickdiagonal_ss2_all(i,1:length(t_vector)) = thickdiagonal_ss2;
    thickdiagonal_ss4_all(i,1:length(t_vector)) = thickdiagonal_ss4;
    thickdiagonal_ss8_all(i,1:length(t_vector)) = thickdiagonal_ss8;

    %mean JPSTC
    JPSTC_all_ss2(1:451,1:451,i) = JPSTC_correct_ss2;
    JPSTC_all_ss4(1:451,1:451,i) = JPSTC_correct_ss4;
    JPSTC_all_ss8(1:451,1:451,i) = JPSTC_correct_ss8;

    clear above_close_ss2 above_close_ss4 above_close_ss8 below_close_ss2 below_close_ss4 ...
        below_close_ss8 main_ss2 main_ss4 main_ss8 thickdiagonal_ss2 ...
        thickdiagonal_ss4 thickdiagonal_ss8 JPSTC_correct_ss2 JPSTC_correct_ss4 JPSTC_correct_ss8

end
clear batch_list i



%plot main diagonal
figure
set(gcf,'color','white')
orient landscape

subplot(2,2,1)
plot(t_vector,nanmean(main_ss2_all),t_vector,nanmean(main_ss4_all),t_vector,nanmean(main_ss8_all))
legend('Set size 2','Set size 4','set size 8')
title('Main diagonal averages (within)')

%plot above
subplot(2,2,2)
plot(t_vector,nanmean(above_close_ss2_all),t_vector,nanmean(above_close_ss4_all),t_vector,nanmean(above_close_ss8_all))
legend('Set size 2','Set size 4','set size 8')
title('Above diagonal averages (within)')

%plot below
subplot(2,2,3)
plot(t_vector,nanmean(below_close_ss2_all),t_vector,nanmean(below_close_ss4_all),t_vector,nanmean(below_close_ss8_all))
legend('Set size 2','Set size 4','set size 8')
title('Below diagonal averages (within)')

%plot thickdiagonal
subplot(2,2,4)
plot(t_vector,nanmean(thickdiagonal_ss2_all),t_vector,nanmean(thickdiagonal_ss4_all),t_vector,nanmean(thickdiagonal_ss8_all))
legend('Set size 2','Set size 4','set size 8')
title('Thick diagonal averages (within)')
