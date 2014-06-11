%cd '/volumes/Dump/Search_Data_EEG_only/'
cd /volumes/Dump/Search_Data_PopOut/

plotFlag = 0;
monkey = 'S';

if monkey == 'S'
    batch_list = dir('S*SEARCH.mat');
elseif monkey == 'Q'
    batch_list = dir('Q*SEARCH.mat');
elseif monkey == 'P'
    batch_list = dir('P*SEARCH.mat');
elseif monkey == 'F'
    batch_list = dir('F*SEARCH.mat');
end


if monkey == 'S' || monkey == 'P' || monkey == 'F'
    for sess = 1:length(batch_list)
        
        
        load(batch_list(sess).name,'Target_','Correct_','SRT','EyeX_','EyeY_','newfile','TrialStart_');
        loadChan(batch_list(sess).name,'EEG')
        batch_list(sess).name
        

        
        %stupid trick to get script to work for F, who has AD01-AD05
        
%         if exist('AD01') == 0; AD01 = NaN(size(Target_,1),3001); end
%         if exist('AD02') == 0; AD02 = NaN(size(Target_,1),3001); end
%         if exist('AD03') == 0; AD03 = NaN(size(Target_,1),3001); end
%         if exist('AD04') == 0; AD04 = NaN(size(Target_,1),3001); end
%         if exist('AD05') == 0; AD05 = NaN(size(Target_,1),3001); end
%         if exist('AD06') == 0; AD06 = NaN(size(Target_,1),3001); end
%         if exist('AD07') == 0; AD07 = NaN(size(Target_,1),3001); end
        
        [SRT,saccLoc] = getSRT(EyeX_,EyeY_);
        %====================================
        % Remove saturated trials.  Implemented to change saturated trials to
        % NaN but we are keeping only averages of each session anyway so should
        % not matter for Curry.
        AD01 = fixClipped(AD01);
        AD02 = fixClipped(AD02);
        AD03 = fixClipped(AD03);
        AD04 = fixClipped(AD04);
        AD05 = fixClipped(AD05);
        AD06 = fixClipped(AD06);
        AD07 = fixClipped(AD07);
        
        %=================================================
        
        AD01 = baseline_correct(AD01,[400 500]);
        AD02 = baseline_correct(AD02,[400 500]);
        AD03 = baseline_correct(AD03,[400 500]);
        AD04 = baseline_correct(AD04,[400 500]);
        AD05 = baseline_correct(AD05,[400 500]);
        AD06 = baseline_correct(AD06,[400 500]);
        AD07 = baseline_correct(AD07,[400 500]);
        
        % Truncate 10 ms before saccade
%         AD01_trunc_10 = truncateAD_targ(AD01,SRT,10);
%         AD02_trunc_10 = truncateAD_targ(AD02,SRT,10);
%         AD03_trunc_10 = truncateAD_targ(AD03,SRT,10);
%         AD04_trunc_10 = truncateAD_targ(AD04,SRT,10);
%         AD05_trunc_10 = truncateAD_targ(AD05,SRT,10);
%         AD06_trunc_10 = truncateAD_targ(AD06,SRT,10);
%         AD07_trunc_10 = truncateAD_targ(AD07,SRT,10);
        
        % Truncate 20 ms before saccade
        AD01_trunc_20 = truncateAD_targ(AD01,SRT,20);
        AD02_trunc_20 = truncateAD_targ(AD02,SRT,20);
        AD03_trunc_20 = truncateAD_targ(AD03,SRT,20);
        AD04_trunc_20 = truncateAD_targ(AD04,SRT,20);
        AD05_trunc_20 = truncateAD_targ(AD05,SRT,20);
        AD06_trunc_20 = truncateAD_targ(AD06,SRT,20);
        AD07_trunc_20 = truncateAD_targ(AD07,SRT,20);
        
        RT(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1),1));
        
        %=================================================
        % keep track of average for each session
        
        % No truncation
%         AD01_av_left_all_noTrunc(sees,1:3001) = nanmean(AD01(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD02_av_left_all_noTrunc(sess,1:3001) = nanmean(AD02(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD03_av_left_all_noTrunc(sess,1:3001) = nanmean(AD03(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD04_av_left_all_noTrunc(sess,1:3001) = nanmean(AD04(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD05_av_left_all_noTrunc(sess,1:3001) = nanmean(AD05(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD06_av_left_all_noTrunc(sess,1:3001) = nanmean(AD06(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD07_av_left_all_noTrunc(sess,1:3001) = nanmean(AD07(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         
%         AD01_av_right_all_noTrunc(sess,1:3001) = nanmean(AD01(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD02_av_right_all_noTrunc(sess,1:3001) = nanmean(AD02(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD03_av_right_all_noTrunc(sess,1:3001) = nanmean(AD03(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD04_av_right_all_noTrunc(sess,1:3001) = nanmean(AD04(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD05_av_right_all_noTrunc(sess,1:3001) = nanmean(AD05(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD06_av_right_all_noTrunc(sess,1:3001) = nanmean(AD06(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD07_av_right_all_noTrunc(sess,1:3001) = nanmean(AD07(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));

%         
%         % 10 ms truncation
%         AD01_av_left_Trunc10(sess,1:3001) = nanmean(AD01_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD02_av_left_Trunc10(sess,1:3001) = nanmean(AD02_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD03_av_left_Trunc10(sess,1:3001) = nanmean(AD03_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD04_av_left_Trunc10(sess,1:3001) = nanmean(AD04_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD05_av_left_Trunc10(sess,1:3001) = nanmean(AD05_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD06_av_left_Trunc10(sess,1:3001) = nanmean(AD06_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         AD07_av_left_Trunc10(sess,1:3001) = nanmean(AD07_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%         
%         AD01_av_right_Trunc10(sess,1:3001) = nanmean(AD01_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD02_av_right_Trunc10(sess,1:3001) = nanmean(AD02_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD03_av_right_Trunc10(sess,1:3001) = nanmean(AD03_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD04_av_right_Trunc10(sess,1:3001) = nanmean(AD04_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD05_av_right_Trunc10(sess,1:3001) = nanmean(AD05_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD06_av_right_Trunc10(sess,1:3001) = nanmean(AD06_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%         AD07_av_right_Trunc10(sess,1:3001) = nanmean(AD07_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        
        % 20 ms truncation
        
        % all trials
        AD01_av_left_all_Trunc20(sess,1:3001) = nanmean(AD01_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD02_av_left_all_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD03_av_left_all_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD04_av_left_all_Trunc20(sess,1:3001) = nanmean(AD04_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD05_av_left_all_Trunc20(sess,1:3001) = nanmean(AD05_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD06_av_left_all_Trunc20(sess,1:3001) = nanmean(AD06_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD07_av_left_all_Trunc20(sess,1:3001) = nanmean(AD07_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        
        AD01_av_right_all_Trunc20(sess,1:3001) = nanmean(AD01_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD02_av_right_all_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD03_av_right_all_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD04_av_right_all_Trunc20(sess,1:3001) = nanmean(AD04_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD05_av_right_all_Trunc20(sess,1:3001) = nanmean(AD05_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD06_av_right_all_Trunc20(sess,1:3001) = nanmean(AD06_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD07_av_right_all_Trunc20(sess,1:3001) = nanmean(AD07_trunc_20(find(Correct_(:,2) == 1  & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        
        % ss2
        AD01_av_left_ss2_Trunc20(sess,1:3001) = nanmean(AD01_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD02_av_left_ss2_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD03_av_left_ss2_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD04_av_left_ss2_Trunc20(sess,1:3001) = nanmean(AD04_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD05_av_left_ss2_Trunc20(sess,1:3001) = nanmean(AD05_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD06_av_left_ss2_Trunc20(sess,1:3001) = nanmean(AD06_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD07_av_left_ss2_Trunc20(sess,1:3001) = nanmean(AD07_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        
        AD01_av_right_ss2_Trunc20(sess,1:3001) = nanmean(AD01_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD02_av_right_ss2_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD03_av_right_ss2_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD04_av_right_ss2_Trunc20(sess,1:3001) = nanmean(AD04_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD05_av_right_ss2_Trunc20(sess,1:3001) = nanmean(AD05_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD06_av_right_ss2_Trunc20(sess,1:3001) = nanmean(AD06_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD07_av_right_ss2_Trunc20(sess,1:3001) = nanmean(AD07_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 2 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        
        % ss4
        AD01_av_left_ss4_Trunc20(sess,1:3001) = nanmean(AD01_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD02_av_left_ss4_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD03_av_left_ss4_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD04_av_left_ss4_Trunc20(sess,1:3001) = nanmean(AD04_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD05_av_left_ss4_Trunc20(sess,1:3001) = nanmean(AD05_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD06_av_left_ss4_Trunc20(sess,1:3001) = nanmean(AD06_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD07_av_left_ss4_Trunc20(sess,1:3001) = nanmean(AD07_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        
        AD01_av_right_ss4_Trunc20(sess,1:3001) = nanmean(AD01_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD02_av_right_ss4_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD03_av_right_ss4_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD04_av_right_ss4_Trunc20(sess,1:3001) = nanmean(AD04_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD05_av_right_ss4_Trunc20(sess,1:3001) = nanmean(AD05_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD06_av_right_ss4_Trunc20(sess,1:3001) = nanmean(AD06_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD07_av_right_ss4_Trunc20(sess,1:3001) = nanmean(AD07_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 4 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        
        % ss8
        AD01_av_left_ss8_Trunc20(sess,1:3001) = nanmean(AD01_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD02_av_left_ss8_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD03_av_left_ss8_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD04_av_left_ss8_Trunc20(sess,1:3001) = nanmean(AD04_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD05_av_left_ss8_Trunc20(sess,1:3001) = nanmean(AD05_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD06_av_left_ss8_Trunc20(sess,1:3001) = nanmean(AD06_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        AD07_av_left_ss8_Trunc20(sess,1:3001) = nanmean(AD07_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
        
        AD01_av_right_ss8_Trunc20(sess,1:3001) = nanmean(AD01_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD02_av_right_ss8_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD03_av_right_ss8_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD04_av_right_ss8_Trunc20(sess,1:3001) = nanmean(AD04_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD05_av_right_ss8_Trunc20(sess,1:3001) = nanmean(AD05_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD06_av_right_ss8_Trunc20(sess,1:3001) = nanmean(AD06_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        AD07_av_right_ss8_Trunc20(sess,1:3001) = nanmean(AD07_trunc_20(find(Correct_(:,2) == 1 & Target_(:,5) == 8 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
        
        
        % correct catch trials (DOES NOT DISCRIMINATE BETWEEN LATE CATCH
        % AND NO RESPONSE -- MOST WILL HAVE A LATE RESPONSE)
        if length(find(Target_(:,2) == 255 & Correct_(:,2) == 1)) > 10
            AD01_av_catch_Trunc20(sess,1:3001) = nanmean(AD01_trunc_20(find(Correct_(:,2) == 1 & Target_(:,2) == 255),:));
            AD02_av_catch_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1 & Target_(:,2) == 255),:));
            AD03_av_catch_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1 & Target_(:,2) == 255),:));
            AD04_av_catch_Trunc20(sess,1:3001) = nanmean(AD04_trunc_20(find(Correct_(:,2) == 1 & Target_(:,2) == 255),:));
            AD05_av_catch_Trunc20(sess,1:3001) = nanmean(AD05_trunc_20(find(Correct_(:,2) == 1 & Target_(:,2) == 255),:));
            AD06_av_catch_Trunc20(sess,1:3001) = nanmean(AD06_trunc_20(find(Correct_(:,2) == 1 & Target_(:,2) == 255),:));
            AD07_av_catch_Trunc20(sess,1:3001) = nanmean(AD07_trunc_20(find(Correct_(:,2) == 1 & Target_(:,2) == 255),:));
        else
            AD01_av_catch_Trunc20(sess,1:3001) = NaN;
            AD02_av_catch_Trunc20(sess,1:3001) = NaN;
            AD03_av_catch_Trunc20(sess,1:3001) = NaN;
            AD04_av_catch_Trunc20(sess,1:3001) = NaN;
            AD05_av_catch_Trunc20(sess,1:3001) = NaN;
            AD06_av_catch_Trunc20(sess,1:3001) = NaN;
            AD07_av_catch_Trunc20(sess,1:3001) = NaN;
        end
        
        
        keep RT batch_list sess *av_* plotFlag monkey
    end
    
    
    
    %=======================================
    % Create grand averages
    
    % No truncation
    %     AD01_right_noTrunc = nanmean(AD01_av_right_noTrunc);
    %     AD02_right_noTrunc = nanmean(AD02_av_right_noTrunc);
    %     AD03_right_noTrunc = nanmean(AD03_av_right_noTrunc);
    %     AD04_right_noTrunc = nanmean(AD04_av_right_noTrunc);
    %     AD05_right_noTrunc = nanmean(AD05_av_right_noTrunc);
    %     AD06_right_noTrunc = nanmean(AD06_av_right_noTrunc);
    %     AD07_right_noTrunc = nanmean(AD07_av_right_noTrunc);
    %
    %     AD01_left_noTrunc = nanmean(AD01_av_left_noTrunc);
    %     AD02_left_noTrunc = nanmean(AD02_av_left_noTrunc);
    %     AD03_left_noTrunc = nanmean(AD03_av_left_noTrunc);
    %     AD04_left_noTrunc = nanmean(AD04_av_left_noTrunc);
    %     AD05_left_noTrunc = nanmean(AD05_av_left_noTrunc);
    %     AD06_left_noTrunc = nanmean(AD06_av_left_noTrunc);
    %     AD07_left_noTrunc = nanmean(AD07_av_left_noTrunc);
    
    % 10 ms truncation
    %     AD01_right_Trunc10 = nanmean(AD01_av_right_Trunc10);
    %     AD02_right_Trunc10 = nanmean(AD02_av_right_Trunc10);
    %     AD03_right_Trunc10 = nanmean(AD03_av_right_Trunc10);
    %     AD04_right_Trunc10 = nanmean(AD04_av_right_Trunc10);
    %     AD05_right_Trunc10 = nanmean(AD05_av_right_Trunc10);
    %     AD06_right_Trunc10 = nanmean(AD06_av_right_Trunc10);
    %     AD07_right_Trunc10 = nanmean(AD07_av_right_Trunc10);
    %
    %     AD01_left_Trunc10 = nanmean(AD01_av_left_Trunc10);
    %     AD02_left_Trunc10 = nanmean(AD02_av_left_Trunc10);
    %     AD03_left_Trunc10 = nanmean(AD03_av_left_Trunc10);
    %     AD04_left_Trunc10 = nanmean(AD04_av_left_Trunc10);
    %     AD05_left_Trunc10 = nanmean(AD05_av_left_Trunc10);
    %     AD06_left_Trunc10 = nanmean(AD06_av_left_Trunc10);
    %     AD07_left_Trunc10 = nanmean(AD07_av_left_Trunc10);
    
    % 20 ms truncation
    AD01_right_all_Trunc20 = nanmean(AD01_av_right_all_Trunc20);
    AD02_right_all_Trunc20 = nanmean(AD02_av_right_all_Trunc20);
    AD03_right_all_Trunc20 = nanmean(AD03_av_right_all_Trunc20);
    AD04_right_all_Trunc20 = nanmean(AD04_av_right_all_Trunc20);
    AD05_right_all_Trunc20 = nanmean(AD05_av_right_all_Trunc20);
    AD06_right_all_Trunc20 = nanmean(AD06_av_right_all_Trunc20);
    AD07_right_all_Trunc20 = nanmean(AD07_av_right_all_Trunc20);
    
    AD01_left_all_Trunc20 = nanmean(AD01_av_left_all_Trunc20);
    AD02_left_all_Trunc20 = nanmean(AD02_av_left_all_Trunc20);
    AD03_left_all_Trunc20 = nanmean(AD03_av_left_all_Trunc20);
    AD04_left_all_Trunc20 = nanmean(AD04_av_left_all_Trunc20);
    AD05_left_all_Trunc20 = nanmean(AD05_av_left_all_Trunc20);
    AD06_left_all_Trunc20 = nanmean(AD06_av_left_all_Trunc20);
    AD07_left_all_Trunc20 = nanmean(AD07_av_left_all_Trunc20);
    
    AD01_right_ss2_Trunc20 = nanmean(AD01_av_right_ss2_Trunc20);
    AD02_right_ss2_Trunc20 = nanmean(AD02_av_right_ss2_Trunc20);
    AD03_right_ss2_Trunc20 = nanmean(AD03_av_right_ss2_Trunc20);
    AD04_right_ss2_Trunc20 = nanmean(AD04_av_right_ss2_Trunc20);
    AD05_right_ss2_Trunc20 = nanmean(AD05_av_right_ss2_Trunc20);
    AD06_right_ss2_Trunc20 = nanmean(AD06_av_right_ss2_Trunc20);
    AD07_right_ss2_Trunc20 = nanmean(AD07_av_right_ss2_Trunc20);
    
    AD01_left_ss2_Trunc20 = nanmean(AD01_av_left_ss2_Trunc20);
    AD02_left_ss2_Trunc20 = nanmean(AD02_av_left_ss2_Trunc20);
    AD03_left_ss2_Trunc20 = nanmean(AD03_av_left_ss2_Trunc20);
    AD04_left_ss2_Trunc20 = nanmean(AD04_av_left_ss2_Trunc20);
    AD05_left_ss2_Trunc20 = nanmean(AD05_av_left_ss2_Trunc20);
    AD06_left_ss2_Trunc20 = nanmean(AD06_av_left_ss2_Trunc20);
    AD07_left_ss2_Trunc20 = nanmean(AD07_av_left_ss2_Trunc20);
    
    AD01_right_ss4_Trunc20 = nanmean(AD01_av_right_ss4_Trunc20);
    AD02_right_ss4_Trunc20 = nanmean(AD02_av_right_ss4_Trunc20);
    AD03_right_ss4_Trunc20 = nanmean(AD03_av_right_ss4_Trunc20);
    AD04_right_ss4_Trunc20 = nanmean(AD04_av_right_ss4_Trunc20);
    AD05_right_ss4_Trunc20 = nanmean(AD05_av_right_ss4_Trunc20);
    AD06_right_ss4_Trunc20 = nanmean(AD06_av_right_ss4_Trunc20);
    AD07_right_ss4_Trunc20 = nanmean(AD07_av_right_ss4_Trunc20);
    
    AD01_left_ss4_Trunc20 = nanmean(AD01_av_left_ss4_Trunc20);
    AD02_left_ss4_Trunc20 = nanmean(AD02_av_left_ss4_Trunc20);
    AD03_left_ss4_Trunc20 = nanmean(AD03_av_left_ss4_Trunc20);
    AD04_left_ss4_Trunc20 = nanmean(AD04_av_left_ss4_Trunc20);
    AD05_left_ss4_Trunc20 = nanmean(AD05_av_left_ss4_Trunc20);
    AD06_left_ss4_Trunc20 = nanmean(AD06_av_left_ss4_Trunc20);
    AD07_left_ss4_Trunc20 = nanmean(AD07_av_left_ss4_Trunc20);
    
    AD01_right_ss8_Trunc20 = nanmean(AD01_av_right_ss8_Trunc20);
    AD02_right_ss8_Trunc20 = nanmean(AD02_av_right_ss8_Trunc20);
    AD03_right_ss8_Trunc20 = nanmean(AD03_av_right_ss8_Trunc20);
    AD04_right_ss8_Trunc20 = nanmean(AD04_av_right_ss8_Trunc20);
    AD05_right_ss8_Trunc20 = nanmean(AD05_av_right_ss8_Trunc20);
    AD06_right_ss8_Trunc20 = nanmean(AD06_av_right_ss8_Trunc20);
    AD07_right_ss8_Trunc20 = nanmean(AD07_av_right_ss8_Trunc20);
    
    AD01_left_ss8_Trunc20 = nanmean(AD01_av_left_ss8_Trunc20);
    AD02_left_ss8_Trunc20 = nanmean(AD02_av_left_ss8_Trunc20);
    AD03_left_ss8_Trunc20 = nanmean(AD03_av_left_ss8_Trunc20);
    AD04_left_ss8_Trunc20 = nanmean(AD04_av_left_ss8_Trunc20);
    AD05_left_ss8_Trunc20 = nanmean(AD05_av_left_ss8_Trunc20);
    AD06_left_ss8_Trunc20 = nanmean(AD06_av_left_ss8_Trunc20);
    AD07_left_ss8_Trunc20 = nanmean(AD07_av_left_ss8_Trunc20);
    
    AD01_catch_Trunc20 = nanmean(AD01_av_catch_Trunc20);
    AD02_catch_Trunc20 = nanmean(AD02_av_catch_Trunc20);
    AD03_catch_Trunc20 = nanmean(AD03_av_catch_Trunc20);
    AD04_catch_Trunc20 = nanmean(AD04_av_catch_Trunc20);
    AD05_catch_Trunc20 = nanmean(AD05_av_catch_Trunc20);
    AD06_catch_Trunc20 = nanmean(AD06_av_catch_Trunc20);
    AD07_catch_Trunc20 = nanmean(AD07_av_catch_Trunc20);
    
    
    % get TDTs.  Does not necessarily matter whether you put targ_on_left
    % or targ_on_right first; time will be independent of valence.
    in = 1:length(batch_list);
    out = length(batch_list)+1:length(batch_list)*2;
    TDT.AD01 = getTDT_AD([AD01_av_left_all_Trunc20;AD01_av_right_all_Trunc20],in,out);
    TDT.AD02 = getTDT_AD([AD02_av_left_all_Trunc20;AD02_av_right_all_Trunc20],in,out);
    TDT.AD03 = getTDT_AD([AD03_av_left_all_Trunc20;AD03_av_right_all_Trunc20],in,out);
    TDT.AD04 = getTDT_AD([AD04_av_left_all_Trunc20;AD04_av_right_all_Trunc20],in,out);
    TDT.AD05 = getTDT_AD([AD05_av_left_all_Trunc20;AD05_av_right_all_Trunc20],in,out);
    TDT.AD06 = getTDT_AD([AD06_av_left_all_Trunc20;AD06_av_right_all_Trunc20],in,out);
    TDT.AD07 = getTDT_AD([AD07_av_left_all_Trunc20;AD07_av_right_all_Trunc20],in,out);
    
    %clear *av* batch_list sess
    
    
    
    [bins cdf] = getCDF(RT,30);
    
    if plotFlag == 1
        figure
        
        
        subplot(3,3,1)
        plot(-500:2500,AD07_left_all_Trunc20,'k',-500:2500,AD07_right_all_Trunc20,'r')
        axis ij
        xlim([-50 300])
        vline(TDT.AD07,'k')
        title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
        newax
        plot(bins,cdf)
        xlim([-50 300])
        ylim([0 1])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
        
        
        subplot(3,3,3)
        plot(-500:2500,AD06_left_all_Trunc20,'k',-500:2500,AD06_right_all_Trunc20,'r')
        axis ij
        xlim([-50 300])
        vline(TDT.AD06,'k')
        title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
        newax
        plot(bins,cdf)
        xlim([-50 300])
        ylim([0 1])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
        
        subplot(3,3,4)
        plot(-500:2500,AD05_left_all_Trunc20,'k',-500:2500,AD05_right_all_Trunc20,'r')
        axis ij
        xlim([-50 300])
        vline(TDT.AD05,'k')
        title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
        newax
        plot(bins,cdf)
        xlim([-50 300])
        ylim([0 1])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
        
        subplot(3,3,6)
        plot(-500:2500,AD04_left_all_Trunc20,'k',-500:2500,AD04_right_all_Trunc20,'r')
        axis ij
        xlim([-50 300])
        vline(TDT.AD04,'k')
        title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
        newax
        plot(bins,cdf)
        xlim([-50 300])
        ylim([0 1])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
        
        subplot(3,3,7)
        plot(-500:2500,AD03_left_all_Trunc20,'k',-500:2500,AD03_right_all_Trunc20,'r')
        axis ij
        xlim([-50 300])
        vline(TDT.AD03,'k')
        title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
        newax
        plot(bins,cdf)
        xlim([-50 300])
        ylim([0 1])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
        
        subplot(3,3,8)
        plot(-500:2500,AD01_left_all_Trunc20,'k',-500:2500,AD01_right_all_Trunc20,'r')
        axis ij
        xlim([-50 300])
        vline(TDT.AD01,'k')
        title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
        newax
        plot(bins,cdf)
        xlim([-50 300])
        ylim([0 1])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
        
        subplot(3,3,9)
        plot(-500:2500,AD02_left_all_Trunc20,'k',-500:2500,AD02_right_all_Trunc20,'r')
        axis ij
        xlim([-50 300])
        vline(TDT.AD02,'k')
        title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
        newax
        plot(bins,cdf)
        xlim([-50 300])
        ylim([0 1])
        set(gca,'xticklabel',[])
        set(gca,'yticklabel',[])
        
        
        [ax h] = suplabel('RED = Target on Right','t');
        set(h,'fontsize',12,'fontweight','bold')
    end
    
    elseif monkey == 'Q'
    
        for sess = 1:length(batch_list)
    
    
            load(batch_list(sess).name,'Target_','Correct_','SRT');
            loadChan(batch_list(sess).name,'EEG')
            batch_list(sess).name
    
            %====================================
            % Remove saturated trials.  Implemented to change saturated trials to
            % NaN but we are keeping only averages of each session anyway so should
            % not matter for Curry.
            AD02 = fixClipped(AD02);
            AD03 = fixClipped(AD03);
    
            %=================================================
            % Get averages for current session (no truncation)
            AD02 = baseline_correct(AD02,[400 500]);
            AD03 = baseline_correct(AD03,[400 500]);
    
            % Truncate 10 ms before saccade
    %         AD02_trunc_10 = truncateAD_targ(AD02,SRT,10);
    %         AD03_trunc_10 = truncateAD_targ(AD03,SRT,10);
    
            % Truncate 20 ms before saccade
            AD02_trunc_20 = truncateAD_targ(AD02,SRT,20);
            AD03_trunc_20 = truncateAD_targ(AD03,SRT,20);
    
    
            %=================================================
            % keep track of average for each session
    
            % No truncation
%             AD02_av_left_noTrunc(sess,1:3001) = nanmean(AD02(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%             AD03_av_left_noTrunc(sess,1:3001) = nanmean(AD03(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
%     
%             AD02_av_right_noTrunc(sess,1:3001) = nanmean(AD02(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
%             AD03_av_right_noTrunc(sess,1:3001) = nanmean(AD03(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
    
            % 10 ms truncation
    %         AD02_av_left_Trunc10(sess,1:3001) = nanmean(AD02_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
    %         AD03_av_left_Trunc10(sess,1:3001) = nanmean(AD03_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
    %
    %         AD02_av_right_Trunc10(sess,1:3001) = nanmean(AD02_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
    %         AD03_av_right_Trunc10(sess,1:3001) = nanmean(AD03_trunc_10(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
    
            % 20 ms truncation
            AD02_av_left_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
            AD03_av_left_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) & ~isnan(SRT(:,1))),:));
    
            AD02_av_right_Trunc20(sess,1:3001) = nanmean(AD02_trunc_20(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
            AD03_av_right_Trunc20(sess,1:3001) = nanmean(AD03_trunc_20(find(Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) & ~isnan(SRT(:,1))),:));
    
            keep batch_list sess *av_* plotFlag
        end
    
    
    
        %=======================================
        % Create grand averages
    
        % No truncation
%         AD02_right_noTrunc = nanmean(AD02_av_right_noTrunc);
%         AD03_right_noTrunc = nanmean(AD03_av_right_noTrunc);
%     
%         AD02_left_noTrunc = nanmean(AD02_av_left_noTrunc);
%         AD03_left_noTrunc = nanmean(AD03_av_left_noTrunc);
%     
        % 10 ms truncation
    %     AD02_right_Trunc10 = nanmean(AD02_av_right_Trunc10);
    %     AD03_right_Trunc10 = nanmean(AD03_av_right_Trunc10);
    %
    %     AD02_left_Trunc10 = nanmean(AD02_av_left_Trunc10);
    %     AD03_left_Trunc10 = nanmean(AD03_av_left_Trunc10);
    
        % 20 ms truncation
        AD02_right_Trunc20 = nanmean(AD02_av_right_Trunc20);
        AD03_right_Trunc20 = nanmean(AD03_av_right_Trunc20);
    
        AD02_left_Trunc20 = nanmean(AD02_av_left_Trunc20);
        AD03_left_Trunc20 = nanmean(AD03_av_left_Trunc20);
    
        clear *av* batch_list sess
    
    
        if plotFlag == 1
            figure
    
            subplot(1,2,1)
            plot(-500:2500,AD02_left_noTrunc,'k',-500:2500,AD02_left_Trunc10,'b',-500:2500,AD02_left_Trunc20,'r')
            axis ij
            xlim([-50 300])
            title('AD02 target on left')
    
            subplot(1,2,2)
            plot(-500:2500,AD02_right_noTrunc,'k',-500:2500,AD02_right_Trunc10,'b',-500:2500,AD02_right_Trunc20,'r')
            axis ij
            xlim([-50 300])
            title('AD02 target on right')
    
    
            figure
            subplot(1,2,1)
            plot(-500:2500,AD03_left_noTrunc,'k',-500:2500,AD03_left_Trunc10,'b',-500:2500,AD03_left_Trunc20,'r')
            axis ij
            xlim([-50 300])
            title('AD03 target on left')
    
            subplot(1,2,2)
            plot(-500:2500,AD03_right_noTrunc,'k',-500:2500,AD03_right_Trunc10,'b',-500:2500,AD03_right_Trunc20,'r')
            axis ij
            xlim([-50 300])
            title('AD03 target on right')
    
    
    
            tileFigs
            clear plotFlag
        end
    
end