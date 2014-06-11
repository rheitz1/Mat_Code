%Compute and plot error-related negativity for each AD channel in file


%batch_list = dir('/volumes/dump/Search_Data/*_SEARCH.mat');
%batch_list = dir('/volumes/dump2/analyses/JPSTC/JPSTC_matrices/reg/correct_vs_errors_postsaccade/LFP-LFP/*.mat');
%batch_list2 = dir('/volumes/dump/analyses/JPSTC_Final/JPSTC_matrices/reg/LFP-LFP/WithinHemi/Bad-Spurious/*.mat');
%batch_list = cat(1,batch_list1,batch_list2);
[file_name chan_name hemi] = textread('ERN.txt', '%s %s %s');
Plot_Time = [-300 600];
plotFlag = 0;

%because there are more channels than there are sessions, we need an
%independent index to keep track of all correct and error ERPs across
%all possible LFPs
indexAD = 0;
% 
% for sess = 1:length(file_name)
%     file_name(sess)
%     
%     
%     %Load supporting variables
%     load(cell2mat(file_name(sess)),cell2mat(chan_name(sess)),'EyeX_','EyeY_','SaccDir_','Target_','SRT','Correct_','Errors_','RFs','Decide_','newfile','-mat')
%     
%     %base scripts
%     fixErrors
%     getBEH
%     getMonk
%     
%     
%     %For error signal truncation, get SecondSaccade RT, if it exists
%     %only needs to be run once per session.  Also need Sacc directions if
%     %not present
%     
%     if length(find(~isnan(SaccDir_))) < 5 %sometimes there are a couple strays
%         [SecondSaccRT_temp SaccDir_] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
%         SecondSaccRT = SecondSaccRT_temp(:,2) - SRT(:,1);
%     else
%         [SecondSaccRT_temp] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
%         SecondSaccRT = SecondSaccRT_temp(:,2) - SRT(:,1);
%     end
%     clear SecondSaccRT_temp ASL_Delay EyeX_ EyeY_
%     
%     hem = cell2mat(hemi(sess));
%     %generate file lists
%     switch hem
%         case 'L'
%             correct_contra = find(ismember(Target_(:,2),[7 0 1]) & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & SRT(:,1) > 100 & Target_(:,2) ~= 255);
%             correct_ipsi = find(ismember(Target_(:,2),[3 4 5]) & Correct_(:,2) == 1 & SRT(:,1) > 50 &  SRT(:,1) < 2000 & SRT(:,1) > 100 & Target_(:,2) ~= 255);
%             
%             errors_contra = find(ismember(SaccDir_(:,1),[7 0 1]) & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
%             errors_ipsi = find(ismember(SaccDir_(:,1),[3 4 5]) & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
%         case 'R'
%             correct_contra = find(ismember(Target_(:,2),[3 4 5]) & Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & SRT(:,1) > 100 & Target_(:,2) ~= 255);
%             correct_ipsi = find(ismember(Target_(:,2),[7 0 1]) & Correct_(:,2) == 1 & SRT(:,1) > 50 &  SRT(:,1) < 2000 & SRT(:,1) > 100 & Target_(:,2) ~= 255);
%             
%             errors_contra = find(ismember(SaccDir_(:,1),[3 4 5]) & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
%             errors_ipsi = find(ismember(SaccDir_(:,1),[7 0 1]) & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
%     end
%     
%     correct_all = cat(1,correct_contra,correct_ipsi);
%     errors_all = cat(1,errors_contra,errors_ipsi);
%     
%     
%     
%     sig = eval(cell2mat(chan_name(sess)));
%     
%     %saccade align
%     sig_resp = response_align(sig,SRT,[-300 600]);
%     
%     sig_correct_all = sig_resp(correct_all,:);
%     sig_errors_all = sig_resp(errors_all,:);
%     sig_correct_ipsi = sig_resp(correct_ipsi,:);
%     sig_correct_contra = sig_resp(correct_contra,:);
%     sig_errors_ipsi = sig_resp(errors_ipsi,:);
%     sig_errors_contra = sig_resp(errors_contra,:);
%     
%     
%     %baseline correct each trial. for each saccade-aligned LFP,
%     %subtract average voltage -300:0 ms before TARGET appearance
%     targ_basemat_correct_all = repmat(nanmean(sig(correct_all,200:500),2),1,length(Plot_Time(1):Plot_Time(2)));
%     targ_basemat_errors_all = repmat(nanmean(sig(errors_all,200:500),2),1,length(Plot_Time(1):Plot_Time(2)));
%     targ_basemat_correct_ipsi = repmat(nanmean(sig(correct_ipsi,200:500),2),1,length(Plot_Time(1):Plot_Time(2)));
%     targ_basemat_correct_contra = repmat(nanmean(sig(correct_contra,200:500),2),1,length(Plot_Time(1):Plot_Time(2)));
%     targ_basemat_errors_ipsi = repmat(nanmean(sig(errors_ipsi,200:500),2),1,length(Plot_Time(1):Plot_Time(2)));
%     targ_basemat_errors_contra = repmat(nanmean(sig(errors_contra,200:500),2),1,length(Plot_Time(1):Plot_Time(2)));
%     
%     %do correction
%     sig_correct_all_bc = sig_correct_all - targ_basemat_correct_all;
%     sig_errors_all_bc = sig_errors_all - targ_basemat_errors_all;
%     sig_correct_ipsi_bc = sig_correct_ipsi - targ_basemat_correct_ipsi;
%     sig_correct_contra_bc = sig_correct_contra - targ_basemat_correct_contra;
%     sig_errors_ipsi_bc = sig_errors_ipsi - targ_basemat_errors_ipsi;
%     sig_errors_contra_bc = sig_errors_contra - targ_basemat_errors_contra;
%     
%     %session index
%     indexAD = indexAD + 1;
%     sig_correct_all_contraipsi(indexAD,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_all_bc);
%     sig_errors_all_contraipsi(indexAD,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_all_bc);
%     sig_correct_all_ipsi(indexAD,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_ipsi_bc);
%     sig_correct_all_contra(indexAD,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_correct_contra_bc);
%     sig_errors_all_ipsi(indexAD,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_ipsi_bc);
%     sig_errors_all_contra(indexAD,1:length(Plot_Time(1):Plot_Time(2))) = nanmean(sig_errors_contra_bc);
%     
%     BEH_all(1:2,1:7,indexAD) = BEH;
%     filename_all{indexAD,1} = newfile;
%     filename_all{indexAD,2} = chan_name(sess);
%     filename_all{indexAD,3} = monkey;
%     
%     keep file_name chan_name hemi plotFlag indexAD Plot_Time ...
%         sig_correct_all_contraipsi sig_errors_all_contraipsi ...
%         sig_correct_all_ipsi sig_correct_all_contra ...
%         sig_errors_all_ipsi sig_errors_all_contra BEH_all ...
%         filename_all
% end

%find onset times & CDF
diffwave_contraipsi = sig_correct_all_contraipsi - sig_errors_all_contraipsi;
diffwave_contra = sig_correct_all_contra - sig_errors_all_contra;
diffwave_ipsi = sig_correct_all_ipsi - sig_errors_all_ipsi;

std_diff_contraipsi = nanstd(diffwave_contraipsi,0,2);
std_diff_contra = nanstd(diffwave_contra);
std_diff_ipsi = nanstd(diffwave_ipsi);

%find onset times of difference waves

%set criterion in units of standard deviation
crit = 2;
for sess = 1:size(diffwave_contraipsi,1)
    sigindex_contraipsi = diffwave_contraipsi(sess,:) > crit*std_diff_contraipsi(sess);
    sigindex_contra = diffwave_contra(sess,:) > crit*std_diff_contra(sess);
    sigindex_ipsi = diffwave_ipsi(sess,:) > crit*std_diff_ipsi(sess);
    
    %use findRuns function to locate 50 consecutive significant
    %time bins. First of these will be onset time
    sigtimes_contraipsi = min(findRuns(sigindex_contraipsi,50));
    sigtimes_contra = min(findRuns(sigindex_contra,50));
    sigtimes_ipsi = min(findRuns(sigindex_ipsi,50));
    
    %convert to real time values and subtract by baseline
    if ~isempty(sigtimes_contraipsi)
        onset_contraipsi(sess,1) = sigtimes_contraipsi - abs(Plot_Time(1));
    else
        onset_contraipsi(sess,1) = NaN;
    end
    
    if ~isempty(sigtimes_contra)
        onset_contra(sess,1) = sigtimes_contra - abs(Plot_Time(1));
    else
        onset_contra(sess,1) = NaN;
    end
    
    if ~isempty(sigtimes_ipsi)
        onset_ipsi(sess,1) = sigtimes_ipsi - abs(Plot_Time(1));
    else
        onset_ipsi(sess,1) = NaN;
    end
    
    
    
    %plot for each session
    if plotFlag == 1
        fig
        subplot(3,1,1)
        plot(Plot_Time(1):Plot_Time(2),sig_correct_all_contra(sess,:),'b',Plot_Time(1):Plot_Time(2),sig_errors_all_contra(sess,:),'--b',Plot_Time(1):Plot_Time(2),diffwave_contra(sess,:),'k')
        line([-300 600],[crit*std_diff_contra(sess) crit*std_diff_contra(sess)])
        line([onset_contra(sess,1) onset_contra(sess,1)],[-.05 .05])
        xlim([Plot_Time(1) Plot_Time(2)])
        title('Contra Target Contra Errors')
        
        subplot(3,1,2)
        plot(Plot_Time(1):Plot_Time(2),sig_correct_all_ipsi(sess,:),'b',Plot_Time(1):Plot_Time(2),sig_errors_all_ipsi(sess,:),'--b',Plot_Time(1):Plot_Time(2),diffwave_ipsi(sess,:),'k')
        line([-300 600],[crit*std_diff_ipsi(sess) crit*std_diff_ipsi(sess)])
        line([onset_ipsi(sess,1) onset_ipsi(sess,1)],[-.05 .05])
        xlim([Plot_Time(1) Plot_Time(2)])
        title('Ipsi Target Ipsi Errors')
        
        subplot(3,1,3)
        plot(Plot_Time(1):Plot_Time(2),sig_correct_all_contraipsi(sess,:),'b',Plot_Time(1):Plot_Time(2),sig_errors_all_contraipsi(sess,:),'--b',Plot_Time(1):Plot_Time(2),diffwave_contraipsi(sess,:),'k')
        line([-300 600],[crit*std_diff_contraipsi(sess) crit*std_diff_contraipsi(sess)])
        line([onset_contraipsi(sess,1) onset_contraipsi(sess,1)],[-.05 .05])
        xlim([Plot_Time(1) Plot_Time(2)])
        title('Contra and Ipsi Target and Errors')
        
        pause
        %sess_to_keep(sess,1) = input('keep?')
        cla
    end
    
    clear sigindex sigtimes
end