plotFlag = 1;
pdfFlag = 0;
q = '''';
c = ',';
qcq = [q c q];

%read in files and neurons
f_path = 'C:\data\Analyses\JPSTC\JPSTC_matrices\';
%[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
%[file_name cell_name] = textread('Vis-VisMove_MG.txt', '%s %s');
[file_name cell_name] = textread('temp.txt', '%s %s');


%=============================
%run scripts

%fixErrors

% % A L L   T R I A L S correction
% CorrectTrials = [];
% CorrectTrials = (1:size(Target_,1))';
% ValidTrials = CorrectTrials;
% %=============================

for file = 1:size(file_name,1)
    %echo current file and cell
    disp([file_name(file)])

    %find relevant channels in file
    varlist = who('-file',cell2mat(file_name(file)));
    ADlist = cell2mat(varlist(strmatch('AD',varlist)));
    %DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
    clear varlist


    for chanNum = 1:size(ADlist,1)
        ADchan = ADlist(chanNum,:);
        eval(['load(' q f_path cell2mat(file_name(file)) qcq ADchan qcq '-mat' q ')'])
        clear ADchan
    end

    %load Target_ & Correct_ variable
    eval(['load(' q f_path cell2mat(file_name(file)) qcq 'Target_' qcq 'Correct_' qcq '-mat' q ')'])

    %rename LFP channels for consistency
    clear ADlist
    varlist = who;
    chanlist = varlist(strmatch('AD',varlist));
    clear varlist


    %Find all possible pairings of LFP channels
    pairings = nchoosek(1:length(chanlist),2);

    for pair = 1:size(pairings,1)

        %determine hemispheres of LFPs to choose
        %relevant RFs
        %         if length(chanlist) > 2
        %             %if greater than 2, then used convention
        %             %left = 9-12 right = 13-16
        %             if isequal(cell2mat(chanlist(pairings(pair,1))),'AD09') == 1
        %                 RF1 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD10') == 1
        %                 RF1 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD11') == 1
        %                 RF1 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD12') == 1
        %                 RF1 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD13') == 1
        %                 RF1 = [3 4 5];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD14') == 1
        %                 RF1 = [3 4 5];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD15') == 1
        %                 RF1 = [3 4 5];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD16') == 1
        %                 RF1 = [7 4 5];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD16') == 1
        %                 RF1 = [7 4 5];
        %             end
        %
        %             if isequal(cell2mat(chanlist(pairings(pair,2))),'AD09') == 1
        %                 RF2 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,2))),'AD10') == 1
        %                 RF2 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,2))),'AD11') == 1
        %                 RF2 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,2))),'AD12') == 1
        %                 RF2 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,2))),'AD13') == 1
        %                 RF2 = [3 4 5];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,2))),'AD14') == 1
        %                 RF2 = [3 4 5];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,2))),'AD15') == 1
        %                 RF2 = [3 4 5];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,2))),'AD16') == 1
        %                 RF2 = [7 4 5];
        %             end
        %         elseif length(chanlist) <= 2
        %             %if there were 2 or fewer LFPs, then left == 9 and
        %             % right == 10.  AD04 was not pre-determined; temporarily
        %             %fix this by allowing all RF locations.
        %             if isequal(cell2mat(chanlist(pairings(pair,1))),'AD09') == 1
        %                 RF1 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD10') == 1
        %                 RF1 = [3 4 5];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,1))),'AD04') == 1
        %                 RF1 = [0 1 2 3 4 5 6 7];
        %             end
        %
        %             if isequal(cell2mat(chanlist(pairings(pair,2))),'AD09') == 1
        %                 RF2 = [7 0 1];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,2))),'AD10') == 1
        %                 RF2 = [3 4 5];
        %             elseif isequal(cell2mat(chanlist(pairings(pair,2))),'AD04') == 1
        %                 RF2 = [0 1 2 3 4 5 6 7];
        %             end
        %         end


        RF1 = [0 1 2 3 4 5 6 7];
        RF2 = [0 1 2 3 4 5 6 7];



        sig1 = eval(cell2mat(chanlist(pairings(pair,1))));
        %limit trials to RF determined above
        sig1 = sig1(find(ismember(Target_(:,2),RF1) & Correct_(:,2) == 1),:);

        sig2 = eval(cell2mat(chanlist(pairings(pair,2))));
        sig2 = sig2(find(ismember(Target_(:,2),RF2) & Correct_(:,2) == 1),:);


        %limit size of channels
        %use -50 to 400
        sig1 = sig1(:,450:900);
        sig2 = sig2(:,450:900);
        plottime = (-50:400);


        %find relevant RFs
        %     for cl = 1:length(CellNames)
        %         if strmatch(cell_name(file),CellNames(cl)) == 1
        %             RF = RFs{cl};
        %             cel = cl;
        %         end
        %     end
        %     file_name{file}
        %     RF


        %     if isempty(RF)
        %         disp('RFs for cell not found!  Aborting...')
        %         return
        %     end

        %what monkey?
        % getMonk


        %Note: according to Oliveira et al. 2001, variance of two signals will not
        %seriosly affect correlation structure between two signals.

        %for lag = 0
        % plottime = (1:2500)*4-3;
        % %correct for 500 ms baseline
        % plottime = plottime - 500;
        %
        % subplot(3,1,1)
        % plot(plottime,mean(sig1),'r',plottime,mean(sig2),'b')
        % legend('AD09','AD10','location','southeast')
        % xlim([-200 2000])
        %
        %
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % % Time-averaged Correlogram
        % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   take a given lag and for each trial, calculate
        %   the correlation between the two signals over time (i.e., time-
        %   averaged).  Do for all lags


        % preallocate space
        cor(1:size(sig1,1),1:401) = NaN;
        lags = -200:200;

        %do for each trial
        for trl = 1:size(sig1,1)
            %h = waitbar(trl/size(sig1,1));
            cor(trl,1:401) = xcorr(sig2(trl,:),sig1(trl,:),200,'coeff');
        end
        %close(h)


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % LFP JPSTC
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        JPSTC_matrix(1:451,1:451) = NaN;

        %use times -50 to 400
        for time1 = 1:size(sig1,2)
            h = waitbar((time1)/size(sig1,2));
            for time2 = 1:size(sig2,2)
                JPSTC_matrix(time1,time2) = corr(sig1(:,time1),sig2(:,time2));
                shift_predictor(time1,time2) = corr(circshift(sig1(:,time1),1),sig2(:,time2));
            end
        end
        close(h)



        %save matrix
        save([f_path (cell2mat(file_name(file))) '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_JPSTC.mat'],'JPSTC_matrix','shift_predictor','-mat')

        figure
        set(gcf,'Color','white')

        %plot sig2
        subplot(5,12,[1 25])
        plot(mean(sig2),plottime);
        set(gca,'XTickLabel',[])
        ylim([-50 400])

        %plot sig1
        subplot(5,12,38:42)
        plot(plottime,mean(sig1));
        set(gca,'YTickLabel',[])
        xlim([-50 400])

        subplot(5,12,[2:6 26:30])
        surface(JPSTC_matrix,'edgecolor','none')
        xlim([1 450])
        ylim([1 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-50:100:400)
        set(gca,'YTickLabel',[])
        %set(gca,'YTickLabel',-50:100:400)

        % xlabel(cell2mat(chanlist(pairings(pair,1))))
        % ylabel(cell2mat(chanlist(pairings(pair,2))))

        %draw lines marking target onset time
        line([0 450],[50 50],'color','k')
        line([50 50],[0 450],'color','k')
        colorbar('East')

        %Plot Shift-Predictor (shifted Sig1 by 1 trial)
        subplot(5,12,[8:12 32:36])
        surface(shift_predictor,'edgecolor','none')
        xlim([1 450])
        ylim([1 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-50:100:400)
        set(gca,'YTickLabel',[])
        line([0 450],[50 50],'color','k')
        line([50 50],[0 450],'color','k')
        colorbar('East')



        %plot sig2 and sig 1
        %plot sig2
        subplot(5,12,[7 31])
        plot(mean(sig2),plottime);
        set(gca,'XTickLabel',[])
        set(gca,'YTickLabel',[])
        ylim([-50 400])

        %plot sig1
        subplot(5,12,44:48)
        plot(plottime,mean(sig1));
        set(gca,'YTickLabel',[])
        xlim([-50 400])


        %plot correlogram
        subplot(5,12,49:54)
        plot(lags,mean(cor))
        xlabel('Lag')


        %generate pseudo-coincidence histogram
        %first, rotate matrix 90 degrees so we
        %can use 'diag' function to create vector
        %of diagonal elements

        flip_JPSTC = rot90(JPSTC_matrix,1);

        %now, obtain diagonal elements spanning -20:20
        diagonals = [];
        for j = -20:20
            temp = mean(diag(flip_JPSTC,j));
            diagonals = cat(1,diagonals,temp);
        end


        [ax,h2] = suplabel(cell2mat(chanlist(pairings(pair,2))),'y');
        set(h2,'FontSize',12)
        [ax,h3] = suplabel(strcat(cell2mat(chanlist(pairings(pair,1))),'   File: ',cell2mat(file_name(file)),'   Generated: ',date),'t');
        set(h3,'FontSize',12')

        if pdfFlag == 1
            set(gcf, 'Renderer', 'ZBuffer')
            outdir = 'C:\Data\Search_Data\JPSTC_PDF\';
            eval(['print -dpdf ',q,outdir,cell2mat(file_name(file)),'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'.pdf',q]);
        end

        close all

        %     bin_averager = 1:5:size(sig1,2);
        %
        %     index = 1;
        %
        %     for trl = 1:size(sig2,1)
        %         trl
        %         for bin = 1:length(bin_averager)-1
        %             sig2_avg(trl,bin) = mean(sig2(trl,bin_averager(bin):bin_averager(bin+1)-1));
        %         end
        %     end
        %
    end
end

keep plotFlag pdfFlag q c qcq f_path file_name file