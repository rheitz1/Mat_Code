%plots plotSAT_summary over specified files.

cd /Users/richardheitz/Desktop/Mat_Code/Analyses/SAT
[filename unit] = textread('SAT_LFP_Q.txt','%s %s');

normalizeAD = 1;

%keepcount = 0;
for file = 1:length(filename)
    
    filename{file}
    %loadChan(filename(file))
    load(filename{file},unit{file},'Hemi','saccLoc','Correct_','Target_','SRT','SAT_','Errors_','RFs','MFs','newfile')
    
    %
    %     varlist = who;
    %     listAD = varlist(strmatch('AD',varlist));
    %     clear varlist
    
    getTrials_SAT;
    
    %for curSig = 1:length(listAD)
    
    %    plotSAT_summary(eval('listAD{curSig}'))
    sig = eval(unit{file});
    sig_bc = baseline_correct(sig,[400 500]);
    
    
    if normalizeAD == 1
        %normalize by the MIN of the MEAN (the negative deflection) so that it ranges to 1 for all AD
        %channels.  Do this irrespective of trial type so condition effects remain
        mi = nanmin(nanmean(sig));
        mi_bc = nanmin(nanmean(sig_bc));
        
        sig = sig ./ mi;
        sig_bc = sig_bc ./ mi_bc;
        
    end
    %plotSAT_summary(unit{file})
    
    %   keeper = input('Keep?')
    
    %     if keeper
    %         keepcount = keepcount + 1;
    %         fi(keepcount,:) = {filename(file).name};
    %         sg(keepcount,:) = {listAD{curSig}};
    %     end
    
    
    
    
%     subplot(121)
%     plot(-500:2500,nanmean(sig(slow_all,:)),'r',-500:2500,nanmean(sig(med_all,:)),'k', ...
%         -500:2500,nanmean(sig(fast_all_withCleared,:)),'g')
%     xlim([-100 500])
%     
%     if ~normalizeAD; axis ij; end
%     
%     subplot(122)
%     plot(-500:2500,nanmean(sig_bc(slow_all,:)),'r',-500:2500,nanmean(sig_bc(med_all,:)),'k', ...
%         -500:2500,nanmean(sig_bc(fast_all_withCleared,:)),'g')
%     xlim([-100 500])
%     
%     if ~normalizeAD; axis ij; end
    
    %keep track of absolute value of peak within 40 - 65 ms of target onset
    Peaks.nobase.norm.slow(file,1) = max(abs(nanmean(sig(slow_all,Target_(1,1)+40:Target_(1,1)+65))));
    Peaks.nobase.norm.fast(file,1) = max(abs(nanmean(sig(fast_all_withCleared,Target_(1,1)+40:Target_(1,1)+65))));
    
    Peaks.base.norm.slow(file,1) = max(abs(nanmean(sig_bc(slow_all,Target_(1,1)+40:Target_(1,1)+65))));
    Peaks.base.norm.fast(file,1) = max(abs(nanmean(sig_bc(fast_all_withCleared,Target_(1,1)+40:Target_(1,1)+65))));


    allDif.nobase.norm(file,1:3001) = nanmean(sig(slow_all,:)) - nanmean(sig(fast_all_withCleared,:));
    allDif.base.norm(file,1:3001) = nanmean(sig_bc(slow_all,:)) - nanmean(sig_bc(fast_all_withCleared,:));
    
    allwf.nobase.norm.slow(file,1:3001) = nanmean(sig(slow_all,:));
    allwf.nobase.norm.fast(file,1:3001) = nanmean(sig(fast_all_withCleared,:));
    allwf.base.norm.slow(file,1:3001) = nanmean(sig_bc(slow_all,:));
    allwf.base.norm.fast(file,1:3001) = nanmean(sig_bc(fast_all_withCleared,:));
%     subplot(121)
%     plot(-500:2500,nanmean(sig(slow_all,:)),'r', ...
%         -500:2500,nanmean(sig(fast_all_withCleared,:)),'g')
%     xlim([-100 500])
%     
%     if ~normalizeAD; axis ij; end
%     
%     subplot(122)
%     plot(-500:2500,nanmean(sig_bc(slow_all,:)),'r', ...
%         -500:2500,nanmean(sig_bc(fast_all_withCleared,:)),'g')
%     xlim([-100 500])
%     
%     if ~normalizeAD; axis ij; end
%     
% 
% 
% pause
%     cla
%     
%     subplot(121)
%     cla
%     
    %end
    keep filename file unit normalizeAD Peaks allDif allwf
    
end