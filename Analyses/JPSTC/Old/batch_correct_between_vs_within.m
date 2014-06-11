%Analysis routine:
%Between vs Within hemisphere LFPs
%regular vs base_correct


%batch for across-session JPSTC analyses
%%SET_SIZE REGULAR (not baseline-corrected)
clear all

batch_list_reg_bet = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-LFP/BetweenHemi/*.mat');
batch_list_reg_with = dir('/volumes/dump/final/JPSTC_matrices/reg/LFP-LFP/WithinHemi/*.mat');
batch_list_base_bet = dir('/volumes/dump/final/JPSTC_matrices/base_correct/LFP-LFP/BetweenHemi/*.mat');
batch_list_base_with = dir('/volumes/dump/final/JPSTC_matrices/base_correct/LFP-LFP/WithinHemi/*.mat');

%preallocate for diagonal averages
above_close_reg_bet(1:length(batch_list_reg_bet),1:251) = NaN;
above_close_reg_with(1:length(batch_list_reg_with),1:251) = NaN;
above_close_base_bet(1:length(batch_list_base_bet),1:251) = NaN;
above_close_base_with(1:length(batch_list_base_with),1:251) = NaN;

below_close_reg_bet(1:length(batch_list_reg_bet),1:251) = NaN;
below_close_reg_with(1:length(batch_list_reg_with),1:251) = NaN;
below_close_base_bet(1:length(batch_list_base_bet),1:251) = NaN;
below_close_base_with(1:length(batch_list_base_with),1:251) = NaN;

main_reg_bet(1:length(batch_list_reg_bet),1:251) = NaN;
main_reg_with(1:length(batch_list_reg_with),1:251) = NaN;
main_base_bet(1:length(batch_list_base_bet),1:251) = NaN;
main_base_with(1:length(batch_list_base_with),1:251) = NaN;

thickdiagonal_close_reg_bet(1:length(batch_list_reg_bet),1:251) = NaN;
thickdiagonal_close_reg_with(1:length(batch_list_reg_with),1:251) = NaN;
thickdiagonal_close_base_bet(1:length(batch_list_base_bet),1:251) = NaN;
thickdiagonal_close_base_with(1:length(batch_list_base_with),1:251) = NaN;



%Reg/between
for i = 1:length(batch_list_reg_bet)
    i
    load(batch_list_reg_bet(i).name,'JPSTC_correct','above_close_correct','below_close_correct','main_correct','thickdiagonal_correct','t_vector')
    above_close_reg_bet(i,1:length(t_vector)) = above_close_correct;
    below_close_reg_bet(i,1:length(t_vector)) = below_close_correct;
    main_reg_bet(i,1:length(t_vector)) = main_correct;
    thickdiagonal_reg_bet(i,1:length(t_vector)) = thickdiagonal_correct;

    %mean JPSTC
    JPSTC_reg_bet(1:451,1:451,i) = JPSTC_correct;
    
    clear JPSTC_correct above_close_correct below_close_correct main_correct thickdiagonal_correct
end

%Reg/within
for i = 1:length(batch_list_reg_with)
    i
    load(batch_list_reg_with(i).name,'JPSTC_correct','above_close_correct','below_close_correct','main_correct','thickdiagonal_correct','t_vector')
    above_close_reg_with(i,1:length(t_vector)) = above_close_correct;
    below_close_reg_with(i,1:length(t_vector)) = below_close_correct;
    main_reg_with(i,1:length(t_vector)) = main_correct;
    thickdiagonal_reg_with(i,1:length(t_vector)) = thickdiagonal_correct;

    %mean JPSTC
    JPSTC_reg_with(1:451,1:451,i) = JPSTC_correct;
    
    clear JPSTC_correct above_close_correct below_close_correct main_correct thickdiagonal_correct
end

%base/between
for i = 1:length(batch_list_base_bet)
    i
    load(batch_list_base_bet(i).name,'JPSTC_correct','above_close_correct','below_close_correct','main_correct','thickdiagonal_correct','t_vector')
    above_close_base_bet(i,1:length(t_vector)) = above_close_correct;
    below_close_base_bet(i,1:length(t_vector)) = below_close_correct;
    main_base_bet(i,1:length(t_vector)) = main_correct;
    thickdiagonal_base_bet(i,1:length(t_vector)) = thickdiagonal_correct;

    %mean JPSTC
    JPSTC_base_bet(1:451,1:451,i) = JPSTC_correct;
    
    clear JPSTC_correct above_close_correct below_close_correct main_correct thickdiagonal_correct
end


%base/within
for i = 1:length(batch_list_base_with)
    i
    load(batch_list_base_with(i).name,'JPSTC_correct','above_close_correct','below_close_correct','main_correct','thickdiagonal_correct','t_vector')
    above_close_base_with(i,1:length(t_vector)) = above_close_correct;
    below_close_base_with(i,1:length(t_vector)) = below_close_correct;
    main_base_with(i,1:length(t_vector)) = main_correct;
    thickdiagonal_base_with(i,1:length(t_vector)) = thickdiagonal_correct;

    %mean JPSTC
    JPSTC_base_with(1:451,1:451,i) = JPSTC_correct;
    
    clear JPSTC_correct above_close_correct below_close_correct main_correct thickdiagonal_correct
end

clear batch_list_reg_with batch_list_reg_bet batch_list_base_with batch_list_base_bet i



% %plot main diagonal
% figure
% set(gcf,'color','white')
% orient landscape
% 
% subplot(2,2,1)
% plot(t_vector,nanmean(main_ss2_all),t_vector,nanmean(main_ss4_all),t_vector,nanmean(main_ss8_all))
% legend('Set size 2','Set size 4','set size 8')
% title('Main diagonal averages')
% 
% %plot above
% subplot(2,2,2)
% plot(t_vector,nanmean(above_close_ss2_all),t_vector,nanmean(above_close_ss4_all),t_vector,nanmean(above_close_ss8_all))
% legend('Set size 2','Set size 4','set size 8')
% title('Above diagonal averages')
% 
% %plot below
% subplot(2,2,3)
% plot(t_vector,nanmean(below_close_ss2_all),t_vector,nanmean(below_close_ss4_all),t_vector,nanmean(below_close_ss8_all))
% legend('Set size 2','Set size 4','set size 8')
% title('Below diagonal averages')
% 
% %plot thickdiagonal
% subplot(2,2,4)
% plot(t_vector,nanmean(thickdiagonal_ss2_all),t_vector,nanmean(thickdiagonal_ss4_all),t_vector,nanmean(thickdiagonal_ss8_all))
% legend('Set size 2','Set size 4','set size 8')
% title('Thick diagonal averages')
% 
