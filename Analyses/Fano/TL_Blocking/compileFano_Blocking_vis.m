
plotFlag = 0;
PDFflag = 0;
cd ~/Desktop/Mat_Code/Analyses/Blocking/

[file_name cell_name] = textread('Blocked_SetSize.txt', '%s %s');


q = '''';
c = ',';
qcq = [q c q];


for file = 1:size(file_name,1)
    cd /volumes/Dump/Search_Data_longBase/
    %================================================================
    %================================================================
    %FOR SPIKES
    eval(['load(' q cell2mat(file_name(file)) qcq cell2mat(cell_name(file)) qcq 'FixTime_Jit_' qcq 'SRT' qcq 'Correct_' qcq 'Errors_' qcq 'Target_' qcq 'newfile' qcq '-mat' q ')'])
    disp([cell2mat(file_name(file)) ' ' cell2mat(cell_name(file))])
    Spike = eval(cell2mat(cell_name(file)));
    
    
    %===========================================
    %Run setup scripts
    ntiles = prctile(FixTime_Jit_,[33 66]);
    
    shortest = find(FixTime_Jit_ <= ntiles(1));
    middle = find(FixTime_Jit_ > ntiles(1) & FixTime_Jit_ <= ntiles(2));
    longest = find(FixTime_Jit_ > ntiles(2));
    
    
    
    %===========================================
    % Assign relevant trial conditions
    set2blk.all = find(Target_(:,6) == 0);
    set4blk.all = find(Target_(:,6) == 1);
    set8blk.all = find(Target_(:,6) == 2);
    
    set2rnd.all = find(Target_(:,6) == 3 & Target_(:,5) == 2);
    set4rnd.all = find(Target_(:,6) == 3 & Target_(:,5) == 4);
    set8rnd.all = find(Target_(:,6) == 3 & Target_(:,5) == 8);
    
    set2blk.shortest = intersect(shortest,set2blk.all);
    set4blk.shortest = intersect(shortest,set4blk.all);
    set8blk.shortest = intersect(shortest,set8blk.all);
    
    set2rnd.shortest = intersect(shortest,set2rnd.all);
    set4rnd.shortest = intersect(shortest,set4rnd.all);
    set8rnd.shortest = intersect(shortest,set8rnd.all);
    
    
    set2blk.middle = intersect(middle,set2blk.all);
    set4blk.middle = intersect(middle,set4blk.all);
    set8blk.middle = intersect(middle,set8blk.all);
    
    set2rnd.middle = intersect(middle,set2rnd.all);
    set4rnd.middle = intersect(middle,set4rnd.all);
    set8rnd.middle = intersect(middle,set8rnd.all);
    
    
    set2blk.longest = intersect(longest,set2blk.all);
    set4blk.longest = intersect(longest,set4blk.all);
    set8blk.longest = intersect(longest,set8blk.all);
    
    set2rnd.longest = intersect(longest,set2rnd.all);
    set4rnd.longest = intersect(longest,set4rnd.all);
    set8rnd.longest = intersect(longest,set8rnd.all);
    
    allblk.all = [set2blk.all ; set4blk.all ; set8blk.all];
    allblk.shortest = [set2blk.shortest ; set4blk.shortest ; set8blk.shortest];
    allblk.middle = [set2blk.middle ; set4blk.middle ; set8blk.middle];
    allblk.longest = [set2blk.longest ; set4blk.longest ; set8blk.longest];
    
    allrnd.all = [set2rnd.all ; set4rnd.all ; set8rnd.all];
    allrnd.shortest = [set2rnd.shortest ; set4rnd.shortest ; set8rnd.shortest];
    allrnd.middle = [set2rnd.middle ; set4rnd.middle ; set8rnd.middle];
    allrnd.longest = [set2rnd.longest ; set4rnd.longest ; set8rnd.longest];

    %===========================================
    
    [allFano.allblk.all(file,:),real_time,allCV2.allblk(file,:)] = getFano_fix(Spike,50,10,[-50 3000],allblk.all);
    [allFano.allblk.shortest(file,:),~,allCV2.allblk(file,:)] = getFano_fix(Spike,50,10,[-50 3000],allblk.shortest);
    [allFano.allblk.middle(file,:),~,allCV2.allblk(file,:)] = getFano_fix(Spike,50,10,[-50 3000],allblk.middle);
    [allFano.allblk.longest(file,:),~,allCV2.allblk(file,:)] = getFano_fix(Spike,50,10,[-50 3000],allblk.longest);
    
    
    [allFano.allrnd.all(file,:),~,allCV2.allrnd(file,:)] = getFano_fix(Spike,50,10,[-50 3000],allrnd.all);
    [allFano.allrnd.shortest(file,:),~,allCV2.allrnd(file,:)] = getFano_fix(Spike,50,10,[-50 3000],allrnd.shortest);
    [allFano.allrnd.middle(file,:),~,allCV2.allrnd(file,:)] = getFano_fix(Spike,50,10,[-50 3000],allrnd.middle);
    [allFano.allrnd.longest(file,:),~,allCV2.allrnd(file,:)] = getFano_fix(Spike,50,10,[-50 3000],allrnd.longest);

    
    [allFano.set2blk.all(file,:),~,allCV2.set2blk.all(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set2blk.all);
    [allFano.set4blk.all(file,:),~,allCV2.set4blk.all(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set4blk.all);
    [allFano.set8blk.all(file,:),~,allCV2.set8blk.all(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set8blk.all);
    
    [allFano.set2rnd.all(file,:),~,allCV2.set2rnd.all(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set2rnd.all);
    [allFano.set4rnd.all(file,:),~,allCV2.set4rnd.all(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set4rnd.all);
    [allFano.set8rnd.all(file,:),~,allCV2.set8rnd.all(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set8rnd.all);
    
    
    [allFano.set2blk.shortest(file,:),~,allCV2.set2blk.shortest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set2blk.shortest);
    [allFano.set4blk.shortest(file,:),~,allCV2.set4blk.shortest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set4blk.shortest);
    [allFano.set8blk.shortest(file,:),~,allCV2.set8blk.shortest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set8blk.shortest);
    
    [allFano.set2rnd.shortest(file,:),~,allCV2.set2rnd.shortest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set2rnd.shortest);
    [allFano.set4rnd.shortest(file,:),~,allCV2.set4rnd.shortest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set4rnd.shortest);
    [allFano.set8rnd.shortest(file,:),~,allCV2.set8rnd.shortest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set8rnd.shortest);
    
    
    [allFano.set2blk.middle(file,:),~,allCV2.set2blk.middle(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set2blk.middle);
    [allFano.set4blk.middle(file,:),~,allCV2.set4blk.middle(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set4blk.middle);
    [allFano.set8blk.middle(file,:),~,allCV2.set8blk.middle(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set8blk.middle);
    
    [allFano.set2rnd.middle(file,:),~,allCV2.set2rnd.middle(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set2rnd.middle);
    [allFano.set4rnd.middle(file,:),~,allCV2.set4rnd.middle(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set4rnd.middle);
    [allFano.set8rnd.middle(file,:),~,allCV2.set8rnd.middle(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set8rnd.middle);
    
    
    [allFano.set2blk.longest(file,:),~,allCV2.set2blk.longest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set2blk.longest);
    [allFano.set4blk.longest(file,:),~,allCV2.set4blk.longest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set4blk.longest);
    [allFano.set8blk.longest(file,:),~,allCV2.set8blk.longest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set8blk.longest);
    
    [allFano.set2rnd.longest(file,:),~,allCV2.set2rnd.longest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set2rnd.longest);
    [allFano.set4rnd.longest(file,:),~,allCV2.set4rnd.longest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set4rnd.longest);
    [allFano.set8rnd.longest(file,:),~,allCV2.set8rnd.longest(file,:)] = getFano_fix(Spike,50,10,[-50 3000],set8rnd.longest);
    
    
    
    SDF = sSDF(Spike,Target_(:,1)-FixTime_Jit_,[-50 3000]);
    SDF = normalize_SP(SDF);
    
    allSDF.allblk.all(file,:) = nanmean(SDF(allblk.all,:));
    allSDF.allblk.shortest(file,:) = nanmean(SDF(allblk.shortest,:));
    allSDF.allblk.middle(file,:) = nanmean(SDF(allblk.middle,:));
    allSDF.allblk.longest(file,:) = nanmean(SDF(allblk.longest,:));
    
    allSDF.allrnd.all(file,:) = nanmean(SDF(allrnd.all,:));
    allSDF.allrnd.shortest(file,:) = nanmean(SDF(allrnd.shortest,:));
    allSDF.allrnd.middle(file,:) = nanmean(SDF(allrnd.middle,:));
    allSDF.allrnd.longest(file,:) = nanmean(SDF(allrnd.longest,:));

    
    allSDF.set2blk.all(file,:) = nanmean(SDF(set2blk.all,:));
    allSDF.set4blk.all(file,:) = nanmean(SDF(set4blk.all,:));
    allSDF.set8blk.all(file,:) = nanmean(SDF(set8blk.all,:));
    
    allSDF.set2rnd.all(file,:) = nanmean(SDF(set2rnd.all,:));
    allSDF.set4rnd.all(file,:) = nanmean(SDF(set4rnd.all,:));
    allSDF.set8rnd.all(file,:) = nanmean(SDF(set8rnd.all,:));
    
    allSDF.set2blk.shortest(file,:) = nanmean(SDF(set2blk.shortest,:));
    allSDF.set4blk.shortest(file,:) = nanmean(SDF(set4blk.shortest,:));
    allSDF.set8blk.shortest(file,:) = nanmean(SDF(set8blk.shortest,:));
    
    allSDF.set2rnd.shortest(file,:) = nanmean(SDF(set2rnd.shortest,:));
    allSDF.set4rnd.shortest(file,:) = nanmean(SDF(set4rnd.shortest,:));
    allSDF.set8rnd.shortest(file,:) = nanmean(SDF(set8rnd.shortest,:));
    
    allSDF.set2blk.middle(file,:) = nanmean(SDF(set2blk.middle,:));
    allSDF.set4blk.middle(file,:) = nanmean(SDF(set4blk.middle,:));
    allSDF.set8blk.middle(file,:) = nanmean(SDF(set8blk.middle,:));
    
    allSDF.set2rnd.middle(file,:) = nanmean(SDF(set2rnd.middle,:));
    allSDF.set4rnd.middle(file,:) = nanmean(SDF(set4rnd.middle,:));
    allSDF.set8rnd.middle(file,:) = nanmean(SDF(set8rnd.middle,:));
    
    allSDF.set2blk.longest(file,:) = nanmean(SDF(set2blk.longest,:));
    allSDF.set4blk.longest(file,:) = nanmean(SDF(set4blk.longest,:));
    allSDF.set8blk.longest(file,:) = nanmean(SDF(set8blk.longest,:));
    
    allSDF.set2rnd.longest(file,:) = nanmean(SDF(set2rnd.longest,:));
    allSDF.set4rnd.longest(file,:) = nanmean(SDF(set4rnd.longest,:));
    allSDF.set8rnd.longest(file,:) = nanmean(SDF(set8rnd.longest,:));
    
    
    
    keep all* file file_name cell_name q c qcq real_time
end
% 
% 
% figure
% subplot(221)
% plot(real_time,nanmean(allFano.set2blk),'k',real_time,nanmean(allFano.set2rnd),'--k')
% box off
% 
% subplot(222)
% plot(real_time,nanmean(allFano.set4blk),'k',real_time,nanmean(allFano.set4rnd),'--k')
% box off
% 
% subplot(223)
% plot(real_time,nanmean(allFano.set8blk),'k',real_time,nanmean(allFano.set8rnd),'--k')
% box off