SDFwin = [-100 300];

cd '/volumes/Dump/Search_Data_longBase/'

batch_list = dir('*SEARCH.mat');

totalCount = 0;
for sess = 1:length(batch_list)
    batch_list(sess).name

    load(batch_list(sess).name,'Target_','Correct_','SRT','newfile','RFs')
    loadChan(batch_list(sess).name,'DSP')
    varlist = who;
    SPKlist = varlist(strmatch('DSP',varlist));

    for currSPK = 1:length(SPKlist)
        sig = eval(SPKlist{currSPK});
        
        try
            RF = RFs.(SPKlist{currSPK});
        catch
            disp('Missing Field...skipping') %Some of Braden's files are missing fields in RFs for neurons that were unclassified
            continue
        end
        
        if ~isempty(RF)
            totalCount = totalCount + 1;
            SDF = sSDF(sig,Target_(:,1),SDFwin);
            
            %baseline correct -- will not seriously affect results
            SDF = baseline_correct(SDF,[1 50]);
            
            SDFDiff = diff(nanmean(SDF));
            
            SDF_norm = normalize_SP(SDF,[abs(SDFwin(1)) abs(SDFwin(1))+300]);
            SDFDiff_norm = diff(nanmean(SDF_norm));
            
        else
            disp('No RF...skipping')
            continue
        end
        
        wf_all(totalCount,1:length(SDFwin(1):SDFwin(2))) = nanmean(SDF);
        wf_all_norm(totalCount,1:length(SDFwin(1):SDFwin(2))) = nanmean(SDF_norm);
        wf_diff_all(totalCount,1:length(SDFwin(1):SDFwin(2))-1) = SDFDiff;
        wf_diff_norm(totalCount,1:length(SDFwin(1):SDFwin(2))-1) = SDFDiff_norm;
        
        clear sig RF SDF SDFDiff SDF_norm SDFDiff_norm
    end
    
    keep batch_list sess totalCount wf_all* wf_diff* SDFwin

end

figure
subplot(221)
plot(SDFwin(1):SDFwin(2),wf_all,'k')
xlim([SDFwin(1) SDFwin(2)])

subplot(222)
plot(SDFwin(1):SDFwin(2)-1,wf_diff_all,'k')
xlim([SDFwin(1) SDFwin(2)-1])

subplot(223)
plot(SDFwin(1):SDFwin(2),wf_all_norm,'k')
xlim([SDFwin(1) SDFwin(2)])

subplot(224)
plot(SDFwin(1):SDFwin(2)-1,wf_diff_norm,'k')
xlim([SDFwin(1) SDFwin(2)-1])


