cd '/volumes/Dump/Search_Data_PopOut_SEF_longBase/'

batch_list = dir('*SEARCH.mat');

totalCount = 1;
for sess = 1:length(batch_list)
    batch_list(sess).name

    load(batch_list(sess).name,'Target_','Correct_','SRT','newfile','TrialStart_')
    loadChan(batch_list(sess).name,'DSP')
    varlist = who;
    SPKlist = varlist(strmatch('DSP',varlist));

    for currSPK = 1:length(SPKlist)
        sig = eval(SPKlist{currSPK});
        
        
        %SDF = sSDF(sig,Target_(:,1),[-3500 800]);
        %plot(-3500:800,nanmean(SDF))
        %xlim([-3500 800])
        
        %SDF = sSDF(sig,Target_(:,1),[-500 800]);
        SDF = spikedensityfunct(sig,Target_(:,1),[-500 800],1:size(sig,1),TrialStart_);
        %plot(-500:800,nanmean(SDF))
        plot(-500:800,SDF)
        xlim([-400 800])
        box off
        
        keeper(sess,1) = input('Keep?');
        
        if keeper(sess) == 1
            keeper_info{totalCount,1} = batch_list(sess).name;
            keeper_info{totalCount,2} = SPKlist{currSPK};
            totalCount = totalCount + 1;
        end
        
        
        cla
    end
    keep batch_list sess keeper totalCount keeper*

end