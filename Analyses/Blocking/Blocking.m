tic
outdir = '/Volumes/Dump/Analyses/Blocking/PDF/';


plotFlag = 0;
PDFflag = 0;
cd ~/Desktop/Mat_Code/Analyses/Blocking/

[file_name cell_name] = textread('Blocked_SetSize.txt', '%s %s');


q = '''';
c = ',';
qcq = [q c q];


for file = 1:size(file_name,1)
    
    %================================================================
    %================================================================
    %FOR SPIKES
    eval(['load(' q cell2mat(file_name(file)) qcq cell2mat(cell_name(file)) qcq 'MFs' qcq 'Target_' qcq 'SRT' qcq 'newfile' qcq 'Decide_' qcq 'Errors_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')'])
    disp([cell2mat(file_name(file)) ' ' cell2mat(cell_name(file))])
    Spike = eval(cell2mat(cell_name(file)));
    
    MF = MFs.(cell2mat(cell_name(file)));
    anti_MF = mod((MF+4),8);
    
    %===========================================
    %Run setup scripts
    
    fixErrors
    
    
    %===========================================
    % Assign relevant trial conditions
    set2block = find(Correct_(:,2) == 1 & Target_(:,6) == 0 & ismember(Target_(:,2),MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set4block = find(Correct_(:,2) == 1 & Target_(:,6) == 1 & ismember(Target_(:,2),MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set8block = find(Correct_(:,2) == 1 & Target_(:,6) == 2 & ismember(Target_(:,2),MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    
    set2block_anti = find(Correct_(:,2) == 1 & Target_(:,6) == 0 & ismember(Target_(:,2),anti_MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set4block_anti = find(Correct_(:,2) == 1 & Target_(:,6) == 1 & ismember(Target_(:,2),anti_MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set8block_anti = find(Correct_(:,2) == 1 & Target_(:,6) == 2 & ismember(Target_(:,2),anti_MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    
    set2rand = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 2 & ismember(Target_(:,2),MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set4rand = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 4 & ismember(Target_(:,2),MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set8rand = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 8 & ismember(Target_(:,2),MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    
    set2rand_anti = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 2 & ismember(Target_(:,2),anti_MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set4rand_anti = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 4 & ismember(Target_(:,2),anti_MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set8rand_anti = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 8 & ismember(Target_(:,2),anti_MF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    
    set2block_all = find(Target_(:,6) == 0);
    set4block_all = find(Target_(:,6) == 1);
    set8block_all = find(Target_(:,6) == 2);
    
    set2rand_all = find(Target_(:,6) == 3 & Target_(:,5) == 2);
    set4rand_all = find(Target_(:,6) == 3 & Target_(:,5) == 4);
    set8rand_all = find(Target_(:,6) == 3 & Target_(:,5) == 8);
    %===========================================
    
    
    %===========================ex=========================
    % CDFs
    [set2blockCDF set2blockBINS] = getCDF(SRT(set2block,1),50);
    [set4blockCDF set4blockBINS] = getCDF(SRT(set4block,1),50);
    [set8blockCDF set8blockBINS] = getCDF(SRT(set8block,1),50);
    [set2randCDF set2randBINS] = getCDF(SRT(set2rand,1),50);
    [set4randCDF set4randBINS] = getCDF(SRT(set4rand,1),50);
    [set8randCDF set8randBINS] = getCDF(SRT(set8rand,1),50);
    %========================================================
    
    %========================================================
    % Accuracy Rates
    set2blockACC = mean(Correct_(find(Target_(:,6) == 0 & ismember(Target_(:,2),MF)),2));
    set4blockACC = mean(Correct_(find(Target_(:,6) == 1 & ismember(Target_(:,2),MF)),2));
    set8blockACC = mean(Correct_(find(Target_(:,6) == 2 & ismember(Target_(:,2),MF)),2));
    blockACC = [set2blockACC set4blockACC set8blockACC];
    
    set2randACC = mean(Correct_(find(Target_(:,6) == 3 & Target_(:,5) == 2 & ismember(Target_(:,2),MF)),2));
    set4randACC = mean(Correct_(find(Target_(:,6) == 3 & Target_(:,5) == 4 & ismember(Target_(:,2),MF)),2));
    set8randACC = mean(Correct_(find(Target_(:,6) == 3 & Target_(:,5) == 8 & ismember(Target_(:,2),MF)),2));
    randACC = [set2randACC set4randACC set8randACC];
    
    blockACC_all(file,1) = set2blockACC;
    blockACC_all(file,2) = set4blockACC;
    blockACC_all(file,3) = set8blockACC;
    
    randACC_all(file,1) = set2randACC;
    randACC_all(file,2) = set4randACC;
    randACC_all(file,3) = set8randACC;
    
    
    %========================================================
    % RTs
    blockRT_all(file,1) = nanmean(SRT(set2block,1));
    blockRT_all(file,2) = nanmean(SRT(set4block,1));
    blockRT_all(file,3) = nanmean(SRT(set8block,1));
    
    randRT_all(file,1) = nanmean(SRT(set2rand,1));
    randRT_all(file,2) = nanmean(SRT(set4rand,1));
    randRT_all(file,3) = nanmean(SRT(set8rand,1));
    
    %=================================================================
    % Saccade-aligned SDFS
    Plot_Time = [-400 200];
    Plot_Time_r = [-400 200];
    Align_Time = SRT(:,1) + Target_(1,1);
    
    set2blockSDF_r = spikedensityfunct(Spike, Align_Time, Plot_Time, set2block, TrialStart_);
    set4blockSDF_r = spikedensityfunct(Spike, Align_Time, Plot_Time, set4block, TrialStart_);
    set8blockSDF_r = spikedensityfunct(Spike, Align_Time, Plot_Time, set8block, TrialStart_);
    
    set2randSDF_r = spikedensityfunct(Spike, Align_Time, Plot_Time, set2rand, TrialStart_);
    set4randSDF_r = spikedensityfunct(Spike, Align_Time, Plot_Time, set4rand, TrialStart_);
    set8randSDF_r = spikedensityfunct(Spike, Align_Time, Plot_Time, set8rand, TrialStart_);
    
    maxblock_r = max(max(set8blockSDF_r),(max(max(set2blockSDF_r),max(set4blockSDF_r))));
    maxrand_r = max(max(set8randSDF_r),(max(max(set2randSDF_r),max(set4randSDF_r))));
    maxplot_r = max(maxblock_r,maxrand_r);
    
    set2blockSDF_all_resp(file,1:length(Plot_Time(1):Plot_Time(2))) = set2blockSDF_r;
    set4blockSDF_all_resp(file,1:length(Plot_Time(1):Plot_Time(2))) = set4blockSDF_r;
    set8blockSDF_all_resp(file,1:length(Plot_Time(1):Plot_Time(2))) = set8blockSDF_r;
    
    set2randSDF_all_resp(file,1:length(Plot_Time(1):Plot_Time(2))) = set2randSDF_r;
    set4randSDF_all_resp(file,1:length(Plot_Time(1):Plot_Time(2))) = set4randSDF_r;
    set8randSDF_all_resp(file,1:length(Plot_Time(1):Plot_Time(2))) = set8randSDF_r;
    %===================================================================
    
    
    
    %===================================================================
    % Target-aligned SDFs
    Plot_Time = [-400 800];
    Plot_Time_s = Plot_Time;
    Align_Time = Target_(:,1);
    
    set2blockSDF_s = spikedensityfunct(Spike, Align_Time, Plot_Time, set2block, TrialStart_);
    set4blockSDF_s = spikedensityfunct(Spike, Align_Time, Plot_Time, set4block, TrialStart_);
    set8blockSDF_s = spikedensityfunct(Spike, Align_Time, Plot_Time, set8block, TrialStart_);
    
    set2blockSDF_s_anti = spikedensityfunct(Spike, Align_Time, Plot_Time, set2block_anti, TrialStart_);
    set4blockSDF_s_anti = spikedensityfunct(Spike, Align_Time, Plot_Time, set4block_anti, TrialStart_);
    set8blockSDF_s_anti = spikedensityfunct(Spike, Align_Time, Plot_Time, set8block_anti, TrialStart_);
    
    
    set2randSDF_s = spikedensityfunct(Spike, Align_Time, Plot_Time, set2rand, TrialStart_);
    set4randSDF_s = spikedensityfunct(Spike, Align_Time, Plot_Time, set4rand, TrialStart_);
    set8randSDF_s = spikedensityfunct(Spike, Align_Time, Plot_Time, set8rand, TrialStart_);
    
    set2randSDF_s_anti = spikedensityfunct(Spike, Align_Time, Plot_Time, set2rand_anti, TrialStart_);
    set4randSDF_s_anti = spikedensityfunct(Spike, Align_Time, Plot_Time, set4rand_anti, TrialStart_);
    set8randSDF_s_anti = spikedensityfunct(Spike, Align_Time, Plot_Time, set8rand_anti, TrialStart_);
    
    
    maxblock_s = max(max(set8blockSDF_s),(max(max(set2blockSDF_s),max(set4blockSDF_s))));
    maxrand_s = max(max(set8randSDF_s),(max(max(set2randSDF_s),max(set4randSDF_s))));
    maxplot_s = max(maxblock_s,maxrand_s);
    
    
    
    set2blockSDF_all_targ(file,1:length(Plot_Time_s(1):Plot_Time_s(2))) = set2blockSDF_s;
    set4blockSDF_all_targ(file,1:length(Plot_Time_s(1):Plot_Time_s(2))) = set4blockSDF_s;
    set8blockSDF_all_targ(file,1:length(Plot_Time_s(1):Plot_Time_s(2))) = set8blockSDF_s;
    
    set2randSDF_all_targ(file,1:length(Plot_Time_s(1):Plot_Time_s(2))) = set2randSDF_s;
    set4randSDF_all_targ(file,1:length(Plot_Time_s(1):Plot_Time_s(2))) = set4randSDF_s;
    set8randSDF_all_targ(file,1:length(Plot_Time_s(1):Plot_Time_s(2))) = set8randSDF_s;
    %====================================================================
    
    
    %=====================
    % Calculate baseline effect and statistical test across trials
    SDF = sSDF(Spike,Target_(:,1),[-400 200]);
    
    set2block_all = find(Target_(:,6) == 0);
    set4block_all = find(Target_(:,6) == 1);
    set8block_all = find(Target_(:,6) == 2);
    
    set2rand_all = find(Target_(:,6) == 3 & Target_(:,5) == 2);
    set4rand_all = find(Target_(:,6) == 3 & Target_(:,5) == 4);
    set8rand_all = find(Target_(:,6) == 3 & Target_(:,5) == 8);
    
    
    % Test whether ss2 is significantly different from ss8
    [issig.ss2_v_ss8_block(file,1)] = ttest2(nanmean(SDF(set2block_all,200:400),2),nanmean(SDF(set8block_all,200:400),2));
    [issig.ss2_v_ss8_rand(file,1)] = ttest2(nanmean(SDF(set2rand_all,200:400),2),nanmean(SDF(set8rand_all,200:400),2));
    [issig.ss2_block_v_ss2_rand(file,1)] = ttest2(nanmean(SDF(set2block_all,200:400),2),nanmean(SDF(set2rand_all,200:400),2));
    [issig.ss4_block_v_ss4_rand(file,1)] = ttest2(nanmean(SDF(set4block_all,200:400),2),nanmean(SDF(set4rand_all,200:400),2));
    [issig.ss8_block_v_ss8_rand(file,1)] = ttest2(nanmean(SDF(set8block_all,200:400),2),nanmean(SDF(set8rand_all,200:400),2));
    
    %Take averages after normalizing
    
    %SDF = normalize_SP(SDF);
    
    baselineSDF.s2block(file,:) = nanmean(SDF(set2block_all,:));
    baselineSDF.s4block(file,:) = nanmean(SDF(set4block_all,:));
    baselineSDF.s8block(file,:) = nanmean(SDF(set8block_all,:));
    
    baselineSDF.s2rand(file,:) = nanmean(SDF(set2rand_all,:));
    baselineSDF.s4rand(file,:) = nanmean(SDF(set4rand_all,:));
    baselineSDF.s8rand(file,:) = nanmean(SDF(set8rand_all,:));
    
    if plotFlag == 1
        
        %Figure 1
        figure
        orient landscape
        set(gcf,'color','white')
        subplot(1,2,1)
        plot(Plot_Time_s(1):Plot_Time_s(2),set2blockSDF_s,'b',Plot_Time_s(1):Plot_Time_s(2),set2blockSDF_s_anti,'--b',Plot_Time_s(1):Plot_Time_s(2),set4blockSDF_s,'r',Plot_Time_s(1):Plot_Time_s(2),set4blockSDF_s_anti,'--r',Plot_Time_s(1):Plot_Time_s(2),set8blockSDF_s,'k',Plot_Time_s(1):Plot_Time_s(2),set8blockSDF_s_anti,'--k')
        legend('SS2 In','SS2 Out','SS4 In','SS4 Out','SS8 In','SS8 Out')
        title('Blocked')
        subplot(1,2,2)
        plot(Plot_Time_s(1):Plot_Time_s(2),set2randSDF_s,'b',Plot_Time_s(1):Plot_Time_s(2),set2randSDF_s_anti,'--b',Plot_Time_s(1):Plot_Time_s(2),set4randSDF_s,'r',Plot_Time_s(1):Plot_Time_s(2),set4randSDF_s_anti,'--r',Plot_Time_s(1):Plot_Time_s(2),set8randSDF_s,'k',Plot_Time_s(1):Plot_Time_s(2),set8randSDF_s_anti,'--k')
        legend('SS2 In','SS2 Out','SS4 In','SS4 Out','SS8 In','SS8 Out')
        title('Random')
        
        maximize
        
        
        
        
        %Figure 2
        figure
        orient landscape
        set(gcf,'color','white')
        
        subplot(2,2,1)
        plot(Plot_Time_s(1):Plot_Time_s(2),set2blockSDF_s,'r',Plot_Time_s(1):Plot_Time_s(2),set4blockSDF_s,'b',Plot_Time_s(1):Plot_Time_s(2),set8blockSDF_s,'k',Plot_Time_s(1):Plot_Time_s(2),set2randSDF_s,'--r',Plot_Time_s(1):Plot_Time_s(2),set4randSDF_s,'--b',Plot_Time_s(1):Plot_Time_s(2),set8randSDF_s,'--k','linewidth',2)
        xlim([Plot_Time_s(1) Plot_Time_s(2)])
        legend('Blocked 2','Blocked 4','Blocked 8','Random 2','Random 4','Random 8')
        %line([0 0],[0 maxplot_s])
        
        subplot(2,2,2)
        plot(Plot_Time_r(1):Plot_Time_r(2),set2blockSDF_r,'r',Plot_Time_r(1):Plot_Time_r(2),set4blockSDF_r,'b',Plot_Time_r(1):Plot_Time_r(2),set8blockSDF_r,'k',Plot_Time_r(1):Plot_Time_r(2),set2randSDF_r,'--r',Plot_Time_r(1):Plot_Time_r(2),set4randSDF_r,'--b',Plot_Time_r(1):Plot_Time_r(2),set8randSDF_r,'--k','linewidth',2)
        xlim([Plot_Time_r(1) Plot_Time_r(2)])
        %legend('Blocked 2','Blocked 4','Blocked 8','Random 2','Random 4','Random 8')
        line([0 0],[0 maxplot_r])
        
        
        subplot(2,2,3)
        plot(set2blockBINS,set2blockCDF,'--r',set4blockBINS,set4blockCDF,'--b',set8blockBINS,set8blockCDF,'--k',set2randBINS,set2randCDF,'r',set4randBINS,set4randCDF,'b',set8randBINS,set8randCDF,'k','linewidth',2)
        %legend('Blocked 2','Blocked 4','Blocked 8','Random 2','Random 4','Random 8')
        xlim([0 600])
        
        subplot(2,2,4)
        plot(blockACC,'-ok','linewidth',2)
        hold
        plot(randACC,'--ok','linewidth',2)
        %ylim([.4 1])
        %xlim([.5 3])
        set(gca,'xtick',[1;2;3])
        xlim([.5 3.5])
        set(gca,'xticklabel',['SS2';'SS4';'SS8'])
        
        [ax,h3] = suplabel(strcat('File: ',newfile,'     Cell: ',mat2str(cell2mat(cell_name(file))),'   Generated: ',date),'t');
        set(h3,'FontSize',14,'FontWeight','bold')
        
        maximize
        
        if PDFflag == 1
            eval(['print -dpdf ',outdir,cell2mat(file_name(file)),'_',cell2mat(cell_name(file)),'_Blocking.pdf']);
        end
    end
    
    
    %pause
    close all
    keep *_all_targ *_all_resp PDFflag outdir plotFlag file_name cell_name file q c qcq ...
        blockACC_all randACC_all blockRT_all randRT_all issig baselineSDF
end
toc