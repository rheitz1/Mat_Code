
PDFflag = 1;
[file_name cell_name] = textread('Blocking_TDT.txt', '%s %s');


q = '''';
c = ',';
qcq = [q c q];


for file = 1:size(file_name,1)
    
    %================================================================
    %================================================================
    %FOR SPIKES
    eval(['load(' q cell2mat(file_name(file)) qcq cell2mat(cell_name(file)) qcq 'RF' qcq 'Target_' qcq 'SRT' qcq 'newfile' qcq 'Decide_' qcq 'Errors_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')'])
    disp([cell2mat(file_name(file)) ' ' cell2mat(cell_name(file))])
    Spike = eval(cell2mat(cell_name(file)));
    RF = eval(['RF.' cell2mat(cell_name(file))]);
    antiRF = mod((RF + 4),8);
    
    set2block_in = find(Correct_(:,2) == 1 & Target_(:,6) == 0 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set4block_in = find(Correct_(:,2) == 1 & Target_(:,6) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set8block_in = find(Correct_(:,2) == 1 & Target_(:,6) == 2 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    
    set2block_out = find(Correct_(:,2) == 1 & Target_(:,6) == 0 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set4block_out = find(Correct_(:,2) == 1 & Target_(:,6) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set8block_out = find(Correct_(:,2) == 1 & Target_(:,6) == 2 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    
    
    set2rand_in = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 2 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set4rand_in = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 4 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set8rand_in = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 8 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    
    set2rand_out = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 2 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set4rand_out = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 4 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    set8rand_out = find(Correct_(:,2) == 1 & Target_(:,6) == 3 & Target_(:,5) == 8 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 100);
    
    
    SDF_block2_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],set2block_in,TrialStart_);
    SDF_block4_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],set4block_in,TrialStart_);
    SDF_block8_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],set8block_in,TrialStart_);
    
    SDF_block2_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],set2block_out,TrialStart_);
    SDF_block4_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],set4block_out,TrialStart_);
    SDF_block8_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],set8block_out,TrialStart_);
    
    SDF_rand2_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],set2rand_in,TrialStart_);
    SDF_rand4_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],set4rand_in,TrialStart_);
    SDF_rand8_in = spikedensityfunct(Spike,Target_(:,1),[-100 500],set8rand_in,TrialStart_);
    
    SDF_rand2_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],set2rand_out,TrialStart_);
    SDF_rand4_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],set4rand_out,TrialStart_);
    SDF_rand8_out = spikedensityfunct(Spike,Target_(:,1),[-100 500],set8rand_out,TrialStart_);
    
    %get CDFs considering correct trials; collapse on target_in and
    %target_out
    [bins_block2 CDF_block2] = getCDF(SRT([set2block_in;set2block_out],1),30);
    [bins_block4 CDF_block4] = getCDF(SRT([set4block_in;set4block_out],1),30);
    [bins_block8 CDF_block8] = getCDF(SRT([set8block_in;set8block_out],1),30);
    
    [bins_rand2 CDF_rand2] = getCDF(SRT([set2rand_in;set2rand_out],1),30);
    [bins_rand4 CDF_rand4] = getCDF(SRT([set4rand_in;set4rand_out],1),30);
    [bins_rand8 CDF_rand8] = getCDF(SRT([set8rand_in;set8rand_out],1),30);
    
    
    TDT_block2(file,1) = getTDT_SP(Spike,set2block_in,set2block_out);
    TDT_block4(file,1) = getTDT_SP(Spike,set4block_in,set4block_out);
    TDT_block8(file,1) = getTDT_SP(Spike,set8block_in,set8block_out);
    
    TDT_rand2(file,1) = getTDT_SP(Spike,set2rand_in,set2rand_out);
    TDT_rand4(file,1) = getTDT_SP(Spike,set4rand_in,set4rand_out);
    TDT_rand8(file,1) = getTDT_SP(Spike,set8rand_in,set8rand_out);
    
    %find min and max total firing rates
    minFire = findMin(SDF_block2_in,SDF_block4_in,SDF_block8_in,SDF_block2_out,SDF_block4_out,SDF_block8_out,SDF_rand2_in,SDF_rand4_in,SDF_rand8_in,SDF_rand2_out,SDF_rand4_out,SDF_rand8_out);
    maxFire = findMax(SDF_block2_in,SDF_block4_in,SDF_block8_in,SDF_block2_out,SDF_block4_out,SDF_block8_out,SDF_rand2_in,SDF_rand4_in,SDF_rand8_in,SDF_rand2_out,SDF_rand4_out,SDF_rand8_out);
    
    f = figure;
    subplot(2,2,1)
    plot(-100:500,SDF_block2_in,'r',-100:500,SDF_block2_out,'--r',-100:500,SDF_block4_in,'b',-100:500,SDF_block4_out,'--b',-100:500,SDF_block8_in,'k',-100:500,SDF_block8_out,'--k')
    fon
    %legend('BL SS2 in','BL SS2 out','BL SS4 in','BL SS4 out','BL SS8 in','BL SS8 out','RND SS2 in','RND SS2 out','RND SS4 in','RND SS4 out','RND SS8 in','RND SS8 out','location','southeast')
    vline(TDT_block2(file,1),'r')
    vline(TDT_block4(file,1),'b')
    vline(TDT_block8(file,1),'k')
    title('Blocked')
    xlim([0 500])
    ylim([minFire maxFire])
    
    
    
    subplot(2,2,2)
    plot(-100:500,SDF_rand2_in,'r',-100:500,SDF_rand2_out,'--r',-100:500,SDF_rand4_in,'b',-100:500,SDF_rand4_out,'--b',-100:500,SDF_rand8_in,'k',-100:500,SDF_rand8_out,'--k')
    fon
    vline(TDT_rand2(file,1),'r')
    vline(TDT_rand4(file,1),'b')
    vline(TDT_rand8(file,1),'k')
    title('Random')
    xlim([0 500])
    ylim([minFire maxFire])
    
    
    subplot(2,2,3)
    hold on
    plot(bins_block2,CDF_block2,'r',bins_block4,CDF_block4,'b',bins_block8,CDF_block8,'k',bins_rand2,CDF_rand2,'--r',bins_rand4,CDF_rand4,'--b',bins_rand8,CDF_rand8,'--k')
    fon
    legend('Block SS2','location','southeast')
    xlim([0 500])
    
    
    
    
    if PDFflag == 1
        outdir = '/Volumes/Dump/Analyses/Blocking/TDT/PDF/';
        eval(['print -dpdf ',outdir,cell2mat(file_name(file)),'_',cell2mat(cell_name(file)),'_TDT.pdf']);
    end
    
    close(f)
    
    keep PDFflag q c qcq file_name cell_name file TDT*
    
end