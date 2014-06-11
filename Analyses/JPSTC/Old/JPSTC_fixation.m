function [] = JPSTC_vampire(file)
tic
% path(path,'/home/heitzrp/Mat_Code/Common')
% path(path,'/home/heitzrp/Mat_Code/JPSTC')
% path(path,'/home/heitzrp/Data')
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/Data/Fixation_Test')

plotFlag = 0;
pdfFlag = 0;
saveFlag = 1;
q = '''';
c = ',';
qcq = [q c q];


%find relevant channels in file
varlist = who('-file',file);
ADlist = cell2mat(varlist(strmatch('AD',varlist(1:15))));
%DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
clear varlist


for chanNum = 1:size(ADlist,1)
    ADchan = ADlist(chanNum,:);
    eval(['load(' q file qcq ADchan qcq '-mat' q ')'])
    disp(['load(' q file qcq ADchan qcq '-mat' q ')'])
    clear ADchan
end

%load Target_ & Correct_ variable
% eval(['load(' q file qcq 'RFs' qcq 'MFs' qcq 'BestRF' qcq 'BestMF' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq '-mat' q ')']);

%rename LFP channels for consistency
clear ADlist
varlist = who;
chanlist = varlist(strmatch('AD',varlist));
clear varlist


%Find all possible pairings of LFP channels
pairings = nchoosek(1:length(chanlist),2);

for pair = 1:size(pairings,1)

    fixErrors

    RF1 = [0 1 2 3 4 5 6 7];
    RF2 = [0 1 2 3 4 5 6 7];

    %====================================================
    %limit size of channels
    %use -50 to 400
    sig1 = eval(cell2mat(chanlist(pairings(pair,1))));
%     sig1_correct = sig1(find(ismember(Target_(:,2),RF1) & Target_(:,2) ~= 255 & Correct_(:,2) == 1),450:900);
%     sig1_correct_saccade = sig1(CorrectTrials,ceil(SRT(CorrectTrials,1))-400+500:ceil(SRT(CorrectTrials,1))+50+500);
%     sig1_errors =  sig1(find(ismember(Target_(:,2),RF1) & Target_(:,2) ~= 255 & Errors_(:,5) == 1),450:900);
% 
%     sig1_correct_ss2 = sig1(find(ismember(Target_(:,2),RF1) & Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1),450:900);
%     sig1_correct_ss4 = sig1(find(ismember(Target_(:,2),RF1) & Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1),450:900);
%     sig1_correct_ss8 = sig1(find(ismember(Target_(:,2),RF1) & Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1),450:900);
% 
%     %homogeneity (note: limit only to set sizes 4 and 8 since set size 2
%     %will always have only one distractor
%     sig1_correct_homo = sig1(find(ismember(Target_(:,2),RF1) & Target_(:,2) ~= 255 & (Target_(:,5) == 4 | Target_(:,5) == 8) & Target_(:,11) == 0 & Correct_(:,2) == 1),450:900);
%     sig1_correct_hete = sig1(find(ismember(Target_(:,2),RF1) & Target_(:,2) ~= 255 & (Target_(:,5) == 4 | Target_(:,5) == 8) & Target_(:,11) == 1 & Correct_(:,2) == 1),450:900);
% 

    sig2 = eval(cell2mat(chanlist(pairings(pair,2))));
%     sig2_correct = sig2(find(ismember(Target_(:,2),RF2) & Target_(:,2) ~= 255 & Correct_(:,2) == 1),450:900);
%     sig2_correct_saccade = sig2(CorrectTrials,ceil(SRT(CorrectTrials,1))-400+500:ceil(SRT(CorrectTrials,1))+50+500);
%     sig2_errors =  sig2(find(ismember(Target_(:,2),RF2) & Target_(:,2) ~= 255 & Errors_(:,5) == 1),450:900);
% 
%     sig2_correct_ss2 = sig2(find(ismember(Target_(:,2),RF2) & Target_(:,2) ~= 255 & Target_(:,5) == 2 & Correct_(:,2) == 1),450:900);
%     sig2_correct_ss4 = sig2(find(ismember(Target_(:,2),RF2) & Target_(:,2) ~= 255 & Target_(:,5) == 4 & Correct_(:,2) == 1),450:900);
%     sig2_correct_ss8 = sig2(find(ismember(Target_(:,2),RF2) & Target_(:,2) ~= 255 & Target_(:,5) == 8 & Correct_(:,2) == 1),450:900);
% 
%     %homogeneity (note: limit only to set sizes 4 and 8 since set size 2
%     %will always have only one distractor
%     sig2_correct_homo = sig2(find(ismember(Target_(:,2),RF2) & Target_(:,2) ~= 255 & (Target_(:,5) == 4 | Target_(:,5) == 8) & Target_(:,11) == 0 & Correct_(:,2) == 1),450:900);
%     sig2_correct_hete = sig2(find(ismember(Target_(:,2),RF2) & Target_(:,2) ~= 255 & (Target_(:,5) == 4 | Target_(:,5) == 8) & Target_(:,11) == 1 & Correct_(:,2) == 1),450:900);
%     %==========================================================================
% 

    %=========================================================
    % Keep track of average waveforms

    wf_sig1 = nanmean(sig1,1);
%     wf_sig1_correct_saccade = nanmean(sig1_correct_saccade,1);
%     wf_sig1_errors = nanmean(sig1_errors,1);
%     wf_sig1_correct_ss2 = nanmean(sig1_correct_ss2,1);
%     wf_sig1_correct_ss4 = nanmean(sig1_correct_ss4,1);
%     wf_sig1_correct_ss8 = nanmean(sig1_correct_ss8,1);
%     wf_sig1_correct_homo = nanmean(sig1_correct_homo,1);
%     wf_sig1_correct_hete = nanmean(sig1_correct_hete,1);

    wf_sig2 = nanmean(sig2,1);
%     wf_sig2_correct_saccade = nanmean(sig2_correct_saccade,1);
%     wf_sig2_errors = nanmean(sig2_errors,1);
%     wf_sig2_correct_ss2 = nanmean(sig2_correct_ss2,1);
%     wf_sig2_correct_ss4 = nanmean(sig2_correct_ss4,1);
%     wf_sig2_correct_ss8 = nanmean(sig2_correct_ss8,1);
%     wf_sig2_correct_homo = nanmean(sig2_correct_homo,1);
%     wf_sig2_correct_hete = nanmean(sig2_correct_hete,1);
    %===========================================================
% 
%     clear sig1 sig2
%     
     plottime = (1:440);
%     plottime_saccade = (-400:50);

    %
    % ========================================
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % % Time-averaged Correlogram
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   Take a given lag and for each trial, calculate
    %   the correlation between the two signals over time (i.e., time-
    %   averaged).  Do for all lags


    % preallocate space
    cor(1:size(sig1,1),1:401) = NaN;
%     cor_correct_saccade(1:size(sig1_correct_saccade,1),1:401) = NaN;
%     cor_errors(1:size(sig1_errors,1),1:401) = NaN;
%     cor_correct_ss2(1:size(sig1_correct_ss2,1),1:401) = NaN;
%     cor_correct_ss4(1:size(sig1_correct_ss4,1),1:401) = NaN;
%     cor_correct_ss8(1:size(sig1_correct_ss8,1),1:401) = NaN;
%     cor_correct_homo(1:size(sig1_correct_homo,1),1:401) = NaN;
%     cor_correct_hete(1:size(sig1_correct_hete,1),1:401) = NaN;

    lags = -200:200;

    %Correlogram for correct trials
    for trl = 1:size(sig1,1)
        cor(trl,1:401) = xcorr(sig2(trl,:),sig1(trl,:),200,'coeff');
    end
% 
%     %Correlogram for correct trials, saccade aligned
%     for trl = 1:size(sig1_correct_saccade,1)
%         cor_correct_saccade(trl,1:401) = xcorr(sig2_correct_saccade(trl,:),sig1_correct_saccade(trl,:),200,'coeff');
%     end
%     
%     %Correlogram for error trials
%     for trl = 1:size(sig1_errors,1)
%         %h = waitbar(trl/size(sig1,1));
%         cor_errors(trl,1:401) = xcorr(sig2_errors(trl,:),sig1_errors(trl,:),200,'coeff');
%     end
% 
%     %Correlogram for correct trials Set Size 2
%     for trl = 1:size(sig1_correct_ss2,1)
%         cor_correct_ss2(trl,1:401) = xcorr(sig2_correct_ss2(trl,:),sig1_correct_ss2(trl,:),200,'coeff');
%     end
% 
%     %Correlogram for correct trials Set Size 4
%     for trl = 1:size(sig1_correct_ss4,1)
%         cor_correct_ss4(trl,1:401) = xcorr(sig2_correct_ss4(trl,:),sig1_correct_ss4(trl,:),200,'coeff');
%     end
% 
%     %Correlogram for correct trials Set Size 8
%     for trl = 1:size(sig1_correct_ss8,1)
%         cor_correct_ss8(trl,1:401) = xcorr(sig2_correct_ss8(trl,:),sig1_correct_ss8(trl,:),200,'coeff');
%     end
% 
%     %Correlogram for correct trials homogeneous distractors
%     for trl = 1:size(sig1_correct_homo,1)
%         cor_correct_homo(trl,1:401) = xcorr(sig2_correct_homo(trl,:),sig1_correct_homo(trl,:),200,'coeff');
%     end
% 
%     %Correlogram for correct trials heterogeneous distractors
%     for trl = 1:size(sig1_correct_hete,1)
%         cor_correct_hete(trl,1:401) = xcorr(sig2_correct_hete(trl,:),sig1_correct_hete(trl,:),200,'coeff');
%     end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % JPSTC
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %===================================
    %Pre-allocate space
    JPSTC(1:440,1:440) = NaN;

    %====================================




    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS
    %   use times -50 to 400
    disp('Running... [Correct Trials]')
    for time1 = 1:size(sig1,2)
        h = time1/size(sig1,2);
        for time2 = 1:size(sig2,2)
            JPSTC(time1,time2) = corr(sig1(:,time1),sig2(:,time2));
            shift_predictor(time1,time2) = corr(circshift(sig1(:,time1),1),sig2(:,time2));
        end
    end
    
    clear sig1 sig2
%     
%     % 1.5) Correct Trials, saccade aligned
%     disp('Running... [Correct Trials, saccade aligned]')
%     for time1 = 1:size(sig1_correct_saccade,2)
%         h = time1/size(sig1_correct_saccade,2)
%         for time2 = 1:size(sig2_correct_saccade,2)
%             JPSTC_correct_saccade(time1,time2) = corr(sig1_correct_saccade(:,time1),sig2_correct_saccade(:,time2));
%         end
%     end
% 
%     clear sig1_correct_saccade sig2_correct_saccade
% 
%     % 2) Error TRIALS
%     %    use times -50 to 400
%     disp('Running... [Error Trials]')
%     for time1 = 1:size(sig1_errors,2)
%         for time2 = 1:size(sig2_errors,2)
%             JPSTC_errors(time1,time2) = corr(sig1_errors(:,time1),sig2_errors(:,time2));
%         end
%     end
% 
%     clear sig1_errors sig2_errors
% 
% 
%     % 3) CORRECT TRIALS, SET SIZE 2
%     disp('Running... [Correct Trials, Set Size 2]')
%     for time1 = 1:size(sig1_correct_ss2,2)
%         for time2 = 1:size(sig2_correct_ss2,2)
%             JPSTC_correct_ss2(time1,time2) = corr(sig1_correct_ss2(:,time1),sig2_correct_ss2(:,time2));
%         end
%     end
% 
%     clear sig1_correct_ss2 sig2_correct_ss2
% 
%     % 4) CORRECT TRIALS, SET SIZE 4
%     disp('Running... [Correct Trials, Set Size 4]')
%     for time1 = 1:size(sig1_correct_ss4,2)
%         for time2 = 1:size(sig2_correct_ss4,2)
%             JPSTC_correct_ss4(time1,time2) = corr(sig1_correct_ss4(:,time1),sig2_correct_ss4(:,time2));
%         end
%     end
% 
%     clear sig1_correct_ss4 sig2_correct_ss4
% 
%     % 5) CORRECT TRIALS, SET SIZE 8
%     disp('Running... [Correct Trials, Set Size 8]')
%     for time1 = 1:size(sig1_correct_ss8,2)
%         for time2 = 1:size(sig2_correct_ss8,2)
%             JPSTC_correct_ss8(time1,time2) = corr(sig1_correct_ss8(:,time1),sig2_correct_ss8(:,time2));
%         end
%     end
% 
%     clear sig1_correct_ss8 sig2_correct_ss8
% 
%     % 6) CORRECT TRIALS, homogeneous distractors
%     disp('Running... [Correct Trials, Homogeneous Distractors]')
%     for time1 = 1:size(sig1_correct_homo,2)
%         for time2 = 1:size(sig2_correct_homo,2)
%             JPSTC_correct_homo(time1,time2) = corr(sig1_correct_homo(:,time1),sig2_correct_homo(:,time2));
%         end
%     end
% 
%     clear sig1_correct_homo sig2_correct_homo
% 
%     % 7) CORRECT TRIALS, heterogeneous distractors
%     disp('Running... [Correct Trials, Heterogeneous]')
%     for time1 = 1:size(sig1_correct_hete,2)
%         for time2 = 1:size(sig2_correct_hete,2)
%             JPSTC_correct_hete(time1,time2) = corr(sig1_correct_hete(:,time1),sig2_correct_hete(:,time2));
%         end
%     end
% 
%     clear sig1_correct_hete sig2_correct_hete
% %     ======================================================================
% %     =====================End Main Loops===================================
% 


    %======================================
    % Save Variables
    if saveFlag == 1
        save(['//scratch/heitzrp/Output/fixation/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_JPSTC.mat'],'cor','lags','plottime','JPSTC','shift_predictor','-mat')
    end

    %======================================





    %=========================================================================
    %================================PLOTTING==============================

    if plotFlag == 1


        %===========
        %Figure 1: Correct trials vs shift-predictor
        figure
        set(gcf,'Color','white')

        %plot sig2
        subplot(5,12,[1 25])
        plot(wf_sig2,plottime);
        set(gca,'XTickLabel',[])
        ylim([1 440])

        %plot sig1
        subplot(5,12,38:42)
        plot(plottime,wf_sig1);
        set(gca,'YTickLabel',[])
        xlim([1 440])

        subplot(5,12,[2:6 26:30])
        surface(JPSTC,'edgecolor','none')
        xlim([1 440])
        ylim([1 440])
        set(gca,'XTick',0:100:440)
        set(gca,'YTick',0:100:440)
        set(gca,'XTickLabel',1:100:440)
        set(gca,'YTickLabel',[])
        %set(gca,'YTickLabel',-50:100:400)

        % xlabel(cell2mat(chanlist(pairings(pair,1))))
        % ylabel(cell2mat(chanlist(pairings(pair,2))))

        %draw lines marking target onset time
%         line([0 450],[50 50],'color','k')
%         line([50 50],[0 450],'color','k')
         colorbar('East')

        %Plot Shift-Predictor (shifted Sig1 by 1 trial)
        subplot(5,12,[8:12 32:36])
        surface(shift_predictor,'edgecolor','none')
        xlim([1 440])
        ylim([1 440])
        set(gca,'XTick',0:100:440)
        set(gca,'YTick',0:100:440)
        set(gca,'XTickLabel',1:100:440)
        set(gca,'YTickLabel',[])
        line([0 450],[50 50],'color','k')
        line([50 50],[0 450],'color','k')
        colorbar('East')

        %plot sig2 and sig 1
        %plot sig2
        subplot(5,12,[7 31])
        plot(wf_sig2,plottime);
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        ylim([1 440])

        %plot sig1
        subplot(5,12,44:48)
        plot(plottime,wf_sig1);
        set(gca,'YTickLabel',[])
        xlim([1 440])

        %plot correlogram
        subplot(5,12,49:54)
        plot(lags,mean(cor))
        xlabel('Lag')

        [ax,h2] = suplabel(cell2mat(chanlist(pairings(pair,2))),'y');
        set(h2,'FontSize',12)
        [ax,h3] = suplabel(strcat(cell2mat(chanlist(pairings(pair,1))),'   File: ',file,'   Generated: ',date),'t');
        set(h3,'FontSize',12')

        if pdfFlag == 1
            set(gcf, 'Renderer', 'ZBuffer')
            eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/fixation/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_shift.jpg',q])
        end

        close all

% 
%         %==================================================================
%         %==================================================================
%         %Figure 2: Correct vs errors
%         figure
%         set(gcf,'Color','white')
% 
%         %plot sig2
%         subplot(5,12,[1 25])
%         plot(wf_sig2_correct,plottime);
%         set(gca,'XTickLabel',[])
%         ylim([-50 400])
% 
%         %plot sig1
%         subplot(5,12,38:42)
%         plot(plottime,wf_sig1_correct);
%         set(gca,'YTickLabel',[])
%         xlim([-50 400])
% 
%         subplot(5,12,[2:6 26:30])
%         surface(JPSTC_correct,'edgecolor','none')
%         xlim([1 450])
%         ylim([1 450])
%         set(gca,'XTick',0:100:450)
%         set(gca,'YTick',0:100:450)
%         set(gca,'XTickLabel',-50:100:400)
%         set(gca,'YTickLabel',[])
%         %set(gca,'YTickLabel',-50:100:400)
% 
%         % xlabel(cell2mat(chanlist(pairings(pair,1))))
%         % ylabel(cell2mat(chanlist(pairings(pair,2))))
% 
%         %draw lines marking target onset time
%         line([0 450],[50 50],'color','k')
%         line([50 50],[0 450],'color','k')
%         colorbar('East')
% 
%         %Plot Errors
%         subplot(5,12,[8:12 32:36])
%         surface(JPSTC_errors,'edgecolor','none')
%         xlim([1 450])
%         ylim([1 450])
%         set(gca,'XTick',0:100:450)
%         set(gca,'YTick',0:100:450)
%         set(gca,'XTickLabel',-50:100:400)
%         set(gca,'YTickLabel',[])
%         line([0 450],[50 50],'color','k')
%         line([50 50],[0 450],'color','k')
%         colorbar('East')
% 
%         %plot sig2 and sig 1
%         %plot sig2
%         subplot(5,12,[7 31])
%         plot(wf_sig2_errors,plottime);
%         set(gca,'XTickLabel',[])
%         set(gca,'YTickLabel',[])
%         ylim([-50 400])
% 
%         %plot sig1
%         subplot(5,12,44:48)
%         plot(plottime,wf_sig1_errors);
%         set(gca,'YTickLabel',[])
%         xlim([-50 400])
% 
%         %plot correlogram
%         subplot(5,12,49:54)
%         plot(lags,mean(cor_correct),'b',lags,mean(cor_errors),'r')
%         xlabel('Lag...blue = correct')
% 
%         [ax,h2] = suplabel(cell2mat(chanlist(pairings(pair,2))),'y');
%         set(h2,'FontSize',12)
%         [ax,h3] = suplabel(strcat(cell2mat(chanlist(pairings(pair,1))),'   File: ',file,'   Generated: ',date),'t');
%         set(h3,'FontSize',12')
% 
%         if pdfFlag == 1
%             set(gcf, 'Renderer', 'ZBuffer')
%             eval(['print -dpdf ',q,'//scratch/heitzrp/Output/correct_vs_errors/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_errors.pdf',q])
%         end
%         
%         close all
%         
%         
%         
%         
%         
%         %==================================================================
%         %==================================================================
%         %Figure 3: Correct Target vs. Saccade Aligned
%         figure
%         set(gcf,'Color','white')
% 
%         %plot sig2
%         subplot(5,12,[1 25])
%         plot(wf_sig2_correct,plottime);
%         set(gca,'XTickLabel',[])
%         ylim([-50 400])
% 
%         %plot sig1
%         subplot(5,12,38:42)
%         plot(plottime,wf_sig1_correct);
%         set(gca,'YTickLabel',[])
%         xlim([-50 400])
% 
%         subplot(5,12,[2:6 26:30])
%         surface(JPSTC_correct,'edgecolor','none')
%         xlim([1 450])
%         ylim([1 450])
%         set(gca,'XTick',0:100:450)
%         set(gca,'YTick',0:100:450)
%         set(gca,'XTickLabel',-50:100:400)
%         set(gca,'YTickLabel',[])
%         %set(gca,'YTickLabel',-50:100:400)
% 
%         % xlabel(cell2mat(chanlist(pairings(pair,1))))
%         % ylabel(cell2mat(chanlist(pairings(pair,2))))
% 
%         %draw lines marking target onset time
%         line([0 450],[50 50],'color','k')
%         line([50 50],[0 450],'color','k')
%         colorbar('East')
% 
%         %Plot Saccade Aligned
%         subplot(5,12,[8:12 32:36])
%         surface(JPSTC_correct_saccade,'edgecolor','none')
%         xlim([1 450])
%         ylim([1 450])
%         set(gca,'XTick',0:100:450)
%         set(gca,'YTick',0:100:450)
%         set(gca,'XTickLabel',-400:100:50)
%         set(gca,'YTickLabel',[])
%         line([nanmean(SRT(CorrectTrials,1))+500 nanmean(SRT(CorrectTrials,1))+500],[0 450],'color','k')
%         line([0 nanmean(SRT(CorrectTrials,1))+500],[nanmean(SRT(CorrectTrials,1))+500 nanmean(SRT(CorrectTrials,1))+500],'color','k')
%         colorbar('East')
% 
%         %plot sig2 and sig 1
%         %plot sig2
%         subplot(5,12,[7 31])
%         plot(wf_sig2_correct_saccade,plottime_saccade);
%         set(gca,'XTickLabel',[])
%         set(gca,'YTickLabel',[])
%         ylim([-400 50])
% 
%         %plot sig1
%         subplot(5,12,44:48)
%         plot(plottime_saccade,wf_sig1_correct_saccade);
%         set(gca,'YTickLabel',[])
%         xlim([-400 50])
% 
%         %plot correlogram
%         subplot(5,12,49:54)
%         plot(lags,mean(cor_correct),'b',lags,mean(cor_correct_saccade),'r')
%         xlabel('Lag...blue = target aligned')
% 
%         [ax,h2] = suplabel(cell2mat(chanlist(pairings(pair,2))),'y');
%         set(h2,'FontSize',12)
%         [ax,h3] = suplabel(strcat(cell2mat(chanlist(pairings(pair,1))),'   File: ',file,'   Generated: ',date),'t');
%         set(h3,'FontSize',12')
% 
%         if pdfFlag == 1
%             set(gcf, 'Renderer', 'ZBuffer')
%             eval(['print -dpdf ',q,'//scratch/heitzrp/Output/target_vs_saccade/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_target_v_sacade.pdf',q])
%         end
%         
%         close all
%         
%         
%         
%         
        
        
    end
    
    clear JPSTC shift_predictor cor wf_sig1 wf_sig2
end
disp('Completed')
toc