use_baseline_corrected = 1;

%%%%%
% WITH BASELINE CORRECTION
%%%%%%

%plot_grand_average_coh_interp
plot_grand_average_coh_Tin_only

%Don't need this - can get xunits from previous script
%xunits = [-100 500];
%xunits = [-400 200];

f_
%load S_overlap_DifferentElectrode
%load S_nooverlap_SameElectrode
%load S_nooverlap_DifferentElectrode


%for set size, normalize to maximal value of mean in set size 2
if use_baseline_corrected == 1
    norm.ss = max(nanmean(s2dif_bc,2));
    %norm.ss = max(s2dif_bc,[],1);
    %norm.ss = repmat(norm.ss,size(s2dif_bc,1),1);
    
    s2dif_bc = s2dif_bc ./ norm.ss;
    s4dif_bc = s4dif_bc ./ norm.ss;
    s8dif_bc = s8dif_bc ./ norm.ss;
    
    %for fast vs slow, normalize to max of mean in fast
    norm.fast = max(nanmean(fs_all_dif_bc,2));
    %norm.fast = max(fs_all_dif_bc,[],1);
    %norm.fast = repmat(norm.fast,size(fs_all_dif_bc,1),1);
    
    fs_all_dif_bc = fs_all_dif_bc ./norm.fast;
    sl_all_dif_bc = sl_all_dif_bc ./norm.fast;
    
    %for correct vs error, normalize to max of mean in correct
    norm.correct = max(nanmean(alldif_bc,2));
    %norm.correct = max(alldif_bc,[],1);
    %norm.correct = repmat(norm.correct,size(alldif_bc,1),1);
    
    alldif_bc = alldif_bc ./norm.correct;
    alldif_out_bc = alldif_out_bc ./norm.correct;
    allsubdif_bc = allsubdif_bc ./norm.correct;
    errdif_bc = errdif_bc ./norm.correct;
    errdif_bc_out = errdif_bc_out ./norm.correct;
    
    
    sem.corr = nanstd(alldif_bc,1,2) / sqrt(sum(~isnan(alldif_bc(1,:))));
    sem.corr_out = nanstd(alldif_out_bc,1,2) / sqrt(sum(~isnan(alldif_out_bc(1,:))));
    sem.err = nanstd(errdif_bc,1,2) / sqrt(sum(~isnan(errdif_bc(1,:))));
    sem.err_out = nanstd(errdif_bc_out,1,2) / sqrt(sum(~isnan(errdif_bc_out(1,:))));
    sem.ss2 = nanstd(s2dif_bc,1,2) / sqrt(sum(~isnan(s2dif_bc(1,:))));
    sem.ss4 = nanstd(s4dif_bc,1,2) / sqrt(sum(~isnan(s4dif_bc(1,:))));
    sem.ss8 = nanstd(s8dif_bc,1,2) / sqrt(sum(~isnan(s8dif_bc(1,:))));
    sem.fast.all = nanstd(fs_all_dif_bc,1,2) / sqrt(sum(~isnan(fs_all_dif_bc(1,:))));
    sem.slow.all = nanstd(sl_all_dif_bc,1,2) / sqrt(sum(~isnan(sl_all_dif_bc(1,:))));
    sem.subsamp = nanstd(allsubdif_bc,1,2) / sqrt(sum(~isnan(allsubdif_bc(1,:))));
    
    sempos.corr = nanmean(alldif_bc,2) + sem.corr;
    sempos.corr_out = nanmean(alldif_out_bc,2) + sem.corr_out;
    sempos.err = nanmean(errdif_bc,2) + sem.err;
    sempos.err_out = nanmean(errdif_bc_out,2) + sem.err_out;
    sempos.s2 = nanmean(s2dif_bc,2) + sem.ss2;
    sempos.s4 = nanmean(s4dif_bc,2) + sem.ss4;
    sempos.s8 = nanmean(s8dif_bc,2) + sem.ss8;
    sempos.fast.all = nanmean(fs_all_dif_bc,2) + sem.fast.all;
    sempos.slow.all = nanmean(sl_all_dif_bc,2) + sem.slow.all;
    sempos.subsamp = nanmean(allsubdif_bc,2) + sem.subsamp;
    
    semneg.corr = nanmean(alldif_bc,2) - sem.corr;
    semneg.corr_out = nanmean(alldif_out_bc,2) - sem.corr_out;
    semneg.err = nanmean(errdif_bc,2) - sem.err;
    semneg.err_out = nanmean(errdif_bc_out,2) - sem.err_out;
    semneg.s2 = nanmean(s2dif_bc,2) - sem.ss2;
    semneg.s4 = nanmean(s4dif_bc,2) - sem.ss4;
    semneg.s8 = nanmean(s8dif_bc,2) - sem.ss8;
    semneg.fast.all = nanmean(fs_all_dif_bc,2) - sem.fast.all;
    semneg.slow.all = nanmean(sl_all_dif_bc,2) - sem.slow.all;
    semneg.subsamp = nanmean(allsubdif_bc,2) - sem.subsamp;
    
    
    % Time Tests for fast vs. slow
    % Use Wilcoxon signrank test (versus 0) to find timing of fast vs slow
    % gamma band coherence. Start at 100 ms
    
    %DOING A ONE-TAILED TEST VERSUS 0...To implement here, use .10 alpha
    %level.
    start = find(tout == 100);
    
    for t = start:size(fs_all_dif_bc,1)
        if ~all(isnan(fs_all_dif_bc(t,:)))
            [fsp_bc(t) fsh_bc(t) s] = signrank(fs_all_dif_bc(t,:),0,'alpha',.1);
        else
            fsp_bc(t) = 1;
            fsh_bc(t) = 0;
        end
    end
    
    temp = tout(findRuns(fsh_bc,10));
    time_fast_bc = min(temp(find(temp > 0)));
    clear temp fsp_bc fsh_bc
    
    
    for t = start:size(sl_all_dif_bc,1)
        if ~all(isnan(sl_all_dif_bc(t,:)))
            [slp_bc(t) slh_bc(t) s] = signrank(sl_all_dif_bc(t,:),0,'alpha',.1);
        else
            slp_bc(t) = 1;
            slh_bc(t) = 0;
        end
    end
    
    temp = tout(findRuns(slh_bc,10));
    time_slow_bc = min(temp(find(temp > 0)));
    clear temp slp_bc slh_bc

    
    figure
    plot(tout,nanmean(s2dif_bc,2),'b',tout,nanmean(s4dif_bc,2),'r',tout,nanmean(s8dif_bc,2),'g')
    hold on
    plot(tout,sempos.s2,'--b',tout,sempos.s4,'--r',tout,sempos.s8,'--g')
    plot(tout,semneg.s2,'--b',tout,semneg.s4,'--r',tout,semneg.s8,'--g')
    xlim(xunits)
    hline(0,'k')
    title('Tin - Din Baseline Correction')
    z.setsize = get(gca,'ylim');
    box off
    
    figure
    plot(tout,nanmean(fs_all_dif_bc,2),'r',tout,nanmean(sl_all_dif_bc,2),'b')
    hold on
    plot(tout,sempos.fast.all,'--r',tout,sempos.slow.all,'--b')
    plot(tout,semneg.fast.all,'--r',tout,semneg.slow.all,'--b')
    vline(time_fast_bc,'r')
    vline(time_slow_bc,'b')
    xlim(xunits)
    hline(0,'k')
    title('Baseline corrected')
    z.fast_slow = get(gca,'ylim');
    box off
    
    figure
    plot(tout,nanmean(alldif_bc,2),'k',tout,nanmean(errdif_bc,2),'r',tout,nanmean(allsubdif_bc,2),'y')
    hold on
    plot(tout,sempos.corr,'--k',tout,sempos.err,'--r')
    plot(tout,semneg.corr,'--k',tout,semneg.err,'--r')
    plot(tout,sempos.subsamp,'y',tout,semneg.subsamp,'y')
    
    xlim(xunits)
    hline(0,'k')
    title('Errors Baseline Correction')
    z.corr_err = get(gca,'ylim');
    box off
    
    figure
    plot(tout,nanmean(alldif_bc,2),'k',tout,nanmean(alldif_out_bc,2),'m',tout,nanmean(errdif_bc_out,2),'r')
    hold on
    plot(tout,sempos.corr,'--k',tout,semneg.corr,'--k', ...
        tout,sempos.corr_out,'--m',tout,semneg.corr_out,'--m', ...
        tout,sempos.err_out,'--r',tout,semneg.err_out,'--r')
    xlim(xunits)
    hline(0,'k')
    title('Correct Target-In vs. Correct Target-Out')
    box off
    
elseif use_baseline_corrected == 0
    norm.ss = max(nanmean(s2dif_bc,2));
    %norm.ss = max(s2dif,[],1);
    %norm.ss = repmat(norm.ss,size(s2dif,1),1);
    
    s2dif = s2dif ./ norm.ss;
    s4dif = s4dif ./ norm.ss;
    s8dif = s8dif ./ norm.ss;
    
    %for fast vs slow, normalize to max of mean in fast
    norm.fast = max(nanmean(fs_all_dif_bc,2));
    %norm.fast = max(fs_all_dif,[],1);
    %norm.fast = repmat(norm.fast,size(fs_all_dif,1),1);
    
    fs_all_dif = fs_all_dif ./norm.fast;
    sl_all_dif = sl_all_dif ./norm.fast;
    
    %for correct vs error, normalize to max of mean in correct
    norm.correct = max(nanmean(alldif_bc,2));
    %norm.correct = max(alldif,[],1);
    %norm.correct = repmat(norm.correct,size(alldif,1),1);
    
    alldif = alldif ./norm.correct;
    alldif_out = alldif_out ./norm.correct;
    allsubdif = allsubdif ./norm.correct;
    errdif = errdif ./norm.correct;
    errdif_out = errdif_out ./norm.correct;
    
    
    sem.corr = nanstd(alldif,1,2) ./ sqrt(sum(~isnan(alldif(1,:))));
    sem.corr_out = nanstd(alldif_out,1,2) ./ sqrt(sum(~isnan(alldif_out(1,:))));
    sem.err = nanstd(errdif,1,2) ./ sqrt(sum(~isnan(errdif(1,:))));
    sem.err_out = nanstd(errdif_out,1,2) ./ sqrt(sum(~isnan(errdif_out(1,:))));
    sem.ss2 = nanstd(s2dif,1,2) ./ sqrt(sum(~isnan(s2dif(1,:))));
    sem.ss4 = nanstd(s4dif,1,2) ./ sqrt(sum(~isnan(s4dif(1,:))));
    sem.ss8 = nanstd(s8dif,1,2) ./ sqrt(sum(~isnan(s8dif(1,:))));
    sem.fast.all = nanstd(fs_all_dif,1,2) ./ sqrt(sum(~isnan(fs_all_dif(1,:))));
    sem.slow.all = nanstd(sl_all_dif,1,2) ./ sqrt(sum(~isnan(sl_all_dif(1,:))));
    sem.subsamp = nanstd(allsubdif,1,2) ./ sqrt(sum(~isnan(allsubdif(1,:))));
    
    sempos.corr = nanmean(alldif,2) + sem.corr;
    sempos.corr_out = nanmean(alldif_out,2) + sem.corr_out;
    sempos.err = nanmean(errdif,2) + sem.err;
    sempos.err_out = nanmean(errdif_out,2) + sem.err_out;
    sempos.s2 = nanmean(s2dif,2) + sem.ss2;
    sempos.s4 = nanmean(s4dif,2) + sem.ss4;
    sempos.s8 = nanmean(s8dif,2) + sem.ss8;
    sempos.fast.all = nanmean(fs_all_dif,2) + sem.fast.all;
    sempos.slow.all = nanmean(sl_all_dif,2) + sem.slow.all;
    sempos.subsamp = nanmean(allsubdif,2) + sem.subsamp;
    
    
    semneg.corr = nanmean(alldif,2) - sem.corr;
    semneg.corr_out = nanmean(alldif_out,2) - sem.corr_out;
    semneg.err = nanmean(errdif,2) - sem.err;
    semneg.err_out = nanmean(errdif_out,2) - sem.err_out;
    semneg.s2 = nanmean(s2dif,2) - sem.ss2;
    semneg.s4 = nanmean(s4dif,2) - sem.ss4;
    semneg.s8 = nanmean(s8dif,2) - sem.ss8;
    semneg.fast.all = nanmean(fs_all_dif,2) - sem.fast.all;
    semneg.slow.all = nanmean(sl_all_dif,2) - sem.slow.all;
    semneg.subsamp = nanmean(allsubdif,2) - sem.subsamp;
    
    
    
    % Time Tests for fast vs. slow
    % Use Wilcoxon signrank test (versus 0) to find timing of fast vs slow
    % gamma band coherence. Start at 100 ms
    start = find(tout == 100);
    
    for t = start:size(fs_all_dif_bc,1)
        if ~all(isnan(fs_all_dif_bc(t,:)))
            [fsp_bc(t) fsh_bc(t) s] = signrank(fs_all_dif_bc(t,:),0,'alpha',.1);
        else
            fsp_bc(t) = 1;
            fsh_bc(t) = 0;
        end
    end
    
    temp = tout(findRuns(fsh_bc,10));
    time_fast_bc = min(temp(find(temp > 0)));
    clear temp fsp_bc fsh_bc
    
    
    for t = start:size(sl_all_dif_bc,1)
        if ~all(isnan(sl_all_dif_bc(t,:)))
            [slp_bc(t) slh_bc(t) s] = signrank(sl_all_dif_bc(t,:),0,'alpha',.1);
        else
            slp_bc(t) = 1;
            slh_bc(t) = 0;
        end
    end
    
    temp = tout(findRuns(slh_bc,10));
    time_slow_bc = min(temp(find(temp > 0)));
    clear temp slp_bc slh_bc
    
    
    
    
    figure
    plot(tout,nanmean(s2dif,2),'b',tout,nanmean(s4dif,2),'r',tout,nanmean(s8dif,2),'g')
    hold on
    plot(tout,sempos.s2,'--b',tout,sempos.s4,'--r',tout,sempos.s8,'--g')
    plot(tout,semneg.s2,'--b',tout,semneg.s4,'--r',tout,semneg.s8,'--g')
    xlim(xunits)
    hline(0,'k')
    title('Tin - Din NO Baseline Correction')
    z.setsize = get(gca,'ylim');
    box off
    
    figure
    plot(tout,nanmean(fs_all_dif,2),'r',tout,nanmean(sl_all_dif,2),'b')
    hold on
    plot(tout,sempos.fast.all,'--r',tout,sempos.slow.all,'--b')
    plot(tout,semneg.fast.all,'--r',tout,semneg.slow.all,'--b')
    vline(time_fast,'r')
    vline(time_slow,'b')
    xlim(xunits)
    hline(0,'k')
    title('NO Baseline correction')
    z.fast_slow = get(gca,'ylim');
    box off
    
    figure
    plot(tout,nanmean(alldif,2),'k',tout,nanmean(errdif,2),'r',tout,nanmean(allsubdif,2),'--k', ...
        tout,nanmean(errdif_out,2),'.-r')
    hold on
    plot(tout,sempos.corr,'--k',tout,sempos.err,'--r')
    plot(tout,semneg.corr,'--k',tout,semneg.err,'--r')
    plot(tout,sempos.err_out,'--r',tout,semneg.err_out,'--r')
    plot(tout,sempos.subsamp,'.-k',tout,semneg.subsamp,'.-k')
    xlim(xunits)
    hline(0,'k')
    title('Errors NO Baseline Correction')
    z.corr_err = get(gca,'ylim');
    box off
    
    
        
    figure
    plot(tout,nanmean(alldif,2),'k',tout,nanmean(alldif_out,2),'m',tout,nanmean(errdif_out,2),'.-r')
    hold on
    plot(tout,sempos.corr,'--k',tout,semneg.corr,'--k', ...
        tout,sempos.corr_out,'--m',tout,semneg.corr_out,'--m', ...
        tout,sempos.err_out,'--r',tout,semneg.err_out,'--r')
    xlim(xunits)
    hline(0,'k')
    title('Correct Target-In vs. Correct Target-Out')
    box off
end
