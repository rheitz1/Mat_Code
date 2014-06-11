cd '/volumes/Dump/Search_Data/'

batch_list = dir('*SEARCH.mat');

saveFlag = 0;
binsize = 10;
tapers = PreGenTapers([.2 5]);

totalCount = 1;
for sess = 2:length(batch_list)
    
    batch_list(sess).name
    
    loadChan(batch_list(sess).name,'LFP');
    
    varlist = who;
    list = varlist(strmatch('AD',varlist));
    clear varlist
    
    
    
    for chan = 1:length(list)
        list(chan)
        
        trlbin = 1;
        sig = eval(cell2mat(list(chan)));
        nBins = floor(size(sig,1)/binsize);
        
        for bin = 1:binsize:nBins
            bin
            s = sig(bin:bin+binsize-1,:);
            [Sx,f,tout,PSx] = LFPSpec(s,tapers,1000,.01,[0 100],0,-500,0,4);
            PSx = PSx';
            ROI(totalCount,trlbin) = nanmean(nanmean(PSx(find(tout >=100 & tout <= 300),find(f>=30 & f<=80))));
            
            trlbin = trlbin + 1;
        end
        totalCount = totalCount + 1; %increment counter for total number of signals
    end
    
    keep ROI batch_list binsize tapers totalCount
end

if saveFlag
    save('/volumes/Dump/Analyses/TF_time/ROI.mat','-mat')
end