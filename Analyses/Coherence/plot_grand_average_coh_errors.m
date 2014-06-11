%make grand average coherence plots
% RPH

% frequency windows to average over

freqwin = [35 100];
%freqwin = [0 25];
%freqwin = [12 30];

%freqwin = [.01 10];

basewin = [-200 -100];

allGrandaverage = 0;
sigOnly = 1; %only use sessions that had some number of significant clusters

basecorrect_coh = 1; %do you want to baseline correct the coherence matrices (only works for raw)?
propFlag = 0; %do you want to plot Tin / Din or Tin - Din.  Set to 1 for former

if sigOnly == 1
    for sess = 1:size(Pcoh_all.in.err,3)

        
        if ~any(any(shuff_all.in_v_out.err.Neg(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
            Pcoh_all.in.err(:,:,sess) = NaN;
            Pcoh_all.out.err(:,:,sess) = NaN;
            nsig.err(sess,1) = 0;
        else
            nsig.err(sess,1) = 1;
        end
    end
else

    nsig.err = size(Pcoh_all.in.err,3);
end

%grand average coherence using all data
if allGrandaverage == 1 & propFlag == 0
    
    %============
    % ALL
    d_all = nanmean(abs(Pcoh_all.in.all),3) - nanmean(abs(Pcoh_all.out.all),3);
    
    if basecorrect_coh == 1
        d_all = baseline_correct(d_all',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    figure
    imagesc(tout,f,d_all')
    axis xy
    xlim([-50 500])
    colorbar
    z.all = get(gca,'clim');
    fw
    title('Tin - Tout ALL Full data set')
    
    
    %============
    % err
    d_err = nanmean(abs(Pcoh_all.in.err),3) - nanmean(abs(Pcoh_all.out.err),3);
    
    
    if basecorrect_coh == 1
        d_err = baseline_correct(d_err',[find(tout == basewin(1)) find(tout == basewin(2))])';
    end
    
    
    
    figure
    imagesc(tout,f,d_err')
    axis xy
    xlim([-50 500])
    colorbar
    set(gca,'clim',z.all)
    fw
    title('Tin - Tout err Full data set')
    
    
end
%========================
%========================
% Time based-analyses


dif.all = abs(Pcoh_all.in.all) - abs(Pcoh_all.out.all);
dif.err = abs(Pcoh_all.in.err) - abs(Pcoh_all.out.err);

%======
% Baseline corrected versions
alldif_bc = baseline_correct(transpose3(dif.all),[find(tout == basewin(1)) find(tout == basewin(2))]);
errdif_bc = baseline_correct(transpose3(dif.err),[find(tout == basewin(1)) find(tout == basewin(2))]);


alldif_bc = squeeze(nanmean(alldif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
errdif_bc = squeeze(nanmean(errdif_bc(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));


%===========
% No baseline correction version

alldif = transpose3(dif.all);
errdif = transpose3(dif.err);


alldif = squeeze(nanmean(alldif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));
errdif = squeeze(nanmean(errdif(find(f>=freqwin(1) & f<=freqwin(2)),:,:),1));




