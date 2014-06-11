
outdir = '/Volumes/Dump/Analyses/Blocking/PDF/LFP/';


plotFlag = 1;
PDFflag = 1;
[file_name cell_name] = textread('Blocked_SetSize.txt', '%s %s');


q = '''';
c = ',';
qcq = [q c q];


for file = 1:size(file_name,1)
    if plotFlag == 1
        figure
        orient landscape
        set(gcf,'color','white')
    end
    %================================================================
    %================================================================
    %FOR SPIKES
    eval(['load(' q cell2mat(file_name(file)) qcq cell2mat(cell_name(file)) qcq 'Target_' qcq 'SRT' qcq 'newfile' qcq 'Decide_' qcq 'Errors_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')'])
    disp([cell2mat(file_name(file)) ' ' cell2mat(cell_name(file))])
    Spike = eval(cell2mat(cell_name(file)));

    %For AD channels
    ADstruct = loadAD(cell2mat(file_name(file)),'ALL');
    decodeADstruct;


    %===========================================
    %Run setup scripts

    fixErrors

    %find 'valid' Correct trials
    [ValidTrials,NonValidTrials,resid] = findValid(SRT,Decide_,CorrectTrials);


    %===========================================
    % Assign relevant trial conditions

    set2block = find(Correct_(:,2) == 1 & Target_(:,6) == 0);
    set4block = find(Correct_(:,2) == 1 & Target_(:,6) == 1);
    set8block = find(Correct_(:,2) == 1 & Target_(:,6) == 2);

    set2rand = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 2);
    set4rand = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 4);
    set8rand = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 8);



    %===========================================


    %========================================================
    % CDFs
    [set2blockCDF set2blockBINS] = getCDF(SRT(set2block,1),50);
    [set4blockCDF set4blockBINS] = getCDF(SRT(set4block,1),50);
    [set8blockCDF set8blockBINS] = getCDF(SRT(set8block,1),50);
    [set2randCDF set2randBINS] = getCDF(SRT(set2rand,1),50);
    [set4randCDF set4randBINS] = getCDF(SRT(set4rand,1),50);
    [set8randCDF set8randBINS] = getCDF(SRT(set8rand,1),50);
    %========================================================


    %=================================================================
    % Saccade-aligned AD channels
    Align_ = 'r';
    setAlign;
    Plot_Time_r = [-200 200];

    varlist = who;
    ADlist = varlist(strmatch('AD',varlist));
    for ADnum = 1:length(ADlist)
        disp(ADlist(ADnum))
        currAD = eval([ADlist{ADnum} ';']);

        %saccade align AD chan

        for trl = 1:size(currAD,1)
            if isnan(SRT(trl,1)) == 1
                currAD_r(trl,1:401) = NaN;
            else
                currAD_r(trl,1:401) = currAD(trl,ceil(SRT(trl,1)-200+500):ceil(SRT(trl,1)+200+500));
            end
        end

        eval(['set2blockStruct.' cell2mat(ADlist(ADnum)) '_r = nanmean(currAD_r(set2block,:))'])
        eval(['set4blockStruct.' cell2mat(ADlist(ADnum)) '_r = nanmean(currAD_r(set4block,:))'])
        eval(['set8blockStruct.' cell2mat(ADlist(ADnum)) '_r = nanmean(currAD_r(set8block,:))'])

        eval(['set2randStruct.' cell2mat(ADlist(ADnum)) '_r = nanmean(currAD_r(set2rand,:))'])
        eval(['set4randStruct.' cell2mat(ADlist(ADnum)) '_r = nanmean(currAD_r(set4rand,:))'])
        eval(['set8randStruct.' cell2mat(ADlist(ADnum)) '_r = nanmean(currAD_r(set8rand,:))']);
        %
        %     maxblock_r = max(max(set8blockSDF_r),(max(max(set2blockSDF_r),max(set4blockSDF_r))));
        %     maxrand_r = max(max(set8randSDF_r),(max(max(set2randSDF_r),max(set4randSDF_r))));
        %     maxplot_r = max(maxblock_r,maxrand_r);
        %
        %     set2blockSDF_all(file,1:length(Plot_Time(1):Plot_Time(2))) = set2blockSDF_r;
        %     set4blockSDF_all(file,1:length(Plot_Time(1):Plot_Time(2))) = set4blockSDF_r;
        %     set8blockSDF_all(file,1:length(Plot_Time(1):Plot_Time(2))) = set8blockSDF_r;
        %
        %     set2randSDF_all(file,1:length(Plot_Time(1):Plot_Time(2))) = set2randSDF_r;
        %     set4randSDF_all(file,1:length(Plot_Time(1):Plot_Time(2))) = set4randSDF_r;
        %     set8randSDF_all(file,1:length(Plot_Time(1):Plot_Time(2))) = set8randSDF_r;
        %===================================================================



        %===================================================================
        % Target-aligned SDFs
        Align_ = 's';
        setAlign;
        Plot_Time_s = Plot_Time;

        currAD = currAD(:,Plot_Time_s(1)+500:Plot_Time_s(2)+500);
        eval(['set2blockStruct.' cell2mat(ADlist(ADnum)) '_s = nanmean(currAD(set2block,:))'])
        eval(['set4blockStruct.' cell2mat(ADlist(ADnum)) '_s = nanmean(currAD(set4block,:))'])
        eval(['set8blockStruct.' cell2mat(ADlist(ADnum)) '_s = nanmean(currAD(set8block,:))'])

        eval(['set2randStruct.' cell2mat(ADlist(ADnum)) '_s = nanmean(currAD(set2rand,:))'])
        eval(['set4randStruct.' cell2mat(ADlist(ADnum)) '_s = nanmean(currAD(set4rand,:))'])
        eval(['set8randStruct.' cell2mat(ADlist(ADnum)) '_s = nanmean(currAD(set8rand,:))']);

        %     maxblock_s = max(max(set8blockSDF_s),(max(max(set2blockSDF_s),max(set4blockSDF_s))));
        %     maxrand_s = max(max(set8randSDF_s),(max(max(set2randSDF_s),max(set4randSDF_s))));
        %     maxplot_s = max(maxblock_s,maxrand_s);
        %====================================================================
        clear currAD currAD_r




        if plotFlag == 1

            %set subplots based on number of plots to make
            if length(ADlist) <= 4
                r = 2;
                c = 2;
            elseif length(ADlist) > 4 && length(ADlist) <= 9
                r = 3;
                c = 3;
            elseif length(ADlist) > 9 && length(ADlist) <= 12
                r = 3;
                c = 4;
            elseif length(ADlist) > 12
                r = 4;
                c = 4;
            end

            subplot(r,c,ADnum)
            plot(Plot_Time_r(1):Plot_Time_r(2),eval(['set2blockStruct.' cell2mat(ADlist(ADnum)) '_r']),'r',Plot_Time_r(1):Plot_Time_r(2),eval(['set4blockStruct.' cell2mat(ADlist(ADnum)) '_r']),'b',Plot_Time_r(1):Plot_Time_r(2),eval(['set8blockStruct.' cell2mat(ADlist(ADnum)) '_r']),'k',Plot_Time_r(1):Plot_Time_r(2),eval(['set2randStruct.' cell2mat(ADlist(ADnum)) '_r']),'--r',Plot_Time_r(1):Plot_Time_r(2),eval(['set4randStruct.' cell2mat(ADlist(ADnum)) '_r']),'--b',Plot_Time_r(1):Plot_Time_r(2),eval(['set8randStruct.' cell2mat(ADlist(ADnum)) '_r']),'--k')
            xlim([Plot_Time_r(1) Plot_Time_r(2)])
            title(cell2mat(ADlist(ADnum)))

            if ADnum == 1
                legend('Blocked 2','Blocked 4','Blocked 8','Random 2','Random 4','Random 8','location','northwest')
            end
            %line([0 0],[0 maxplot_r])

            %
            %         subplot(2,2,3)
            %         plot(set2blockBINS,set2blockCDF,'--r',set4blockBINS,set4blockCDF,'--b',set8blockBINS,set8blockCDF,'--k',set2randBINS,set2randCDF,'r',set4randBINS,set4randCDF,'b',set8randBINS,set8randCDF,'k','linewidth',2)
            %         %legend('Blocked 2','Blocked 4','Blocked 8','Random 2','Random 4','Random 8')
            %         xlim([0 600])
            %
            %         subplot(2,2,4)
            %         plot(blockACC,'-ok','linewidth',2)
            %         hold
            %         plot(randACC,'--ok','linewidth',2)
            %         %ylim([.4 1])
            %         %xlim([.5 3])
            %         set(gca,'xtick',[1;2;3])
            %         xlim([.5 3.5])
            %         set(gca,'xticklabel',['SS2';'SS4';'SS8'])
        end
    end

    [ax,h3] = suplabel(strcat('File: ',newfile,'     Generated: ',date),'t');
    set(h3,'FontSize',14,'FontWeight','bold')

    maximize

    if PDFflag == 1
        eval(['print -dpdf ',outdir,cell2mat(file_name(file)),'_','_Blocking_AD.pdf']);
    end



    %pause
    close all
    keep PDFflag outdir plotFlag file_name cell_name file q c qcq
end

