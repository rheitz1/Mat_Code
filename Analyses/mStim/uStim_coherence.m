%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons were only those recorded in same hemisphere.  Using
%NEURON RF for both signals.  Signals had to demonstrate significant selectivity by
%running Wilcoxon (i.e., have significant TDT that looked correct by
%inspection)


[file_name sig1_name sig2_name] = textread('SPK-LFP_uStim.txt', '%s %s %s');

q = '''';
c = ',';
qcq = [q c q];

saveFlag = 1;

for sess = 1:length(file_name)
    cell2mat(file_name(sess))
    
    load(cell2mat(file_name(sess)),sig1_name{sess},sig2_name{sess}, ...
        'MStim_','EyeX_','EyeY_','newfile','Target_','Errors_','Correct_','RFs','Hemi','SRT','TrialStart_')
    
    fixErrors
    
    %get saccade locations for error trials
    [SRT saccLoc] = getSRT(EyeX_,EyeY_);
    
    sig1 = eval(sig1_name{sess});
    sig2 = eval(sig2_name{sess});
    
    tapers = PreGenTapers([.2 5]);

    CHECK CHECK CHECK
    if Hemi.(sig1_name{sess}) == 'R' & Hemi.(sig2_name{sess}) == 'R'
        %neuron is always listed 2nd, so use this to find RF
        RF = RFs.(sig2_name{sess});
        antiRF = mod((RF+4),8);
    elseif Hemi.(sig1_name{sess}) == 'L' & Hemi.(sig2_name{sess}) == 'L'
        RF = RFs.(sig2_name{sess});
        antiRF = mod((RF+4),8);
    else
        error('Error with RFs...')
    end
    
    
    
    
    % Do median split for fast/slow comparison
    cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    
    in.fast.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed & SRT(:,1) > 50);
    in.slow.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
    in.err.stim = find(~isnan(MStim_(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    out.fast.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed & SRT(:,1) > 50);
    out.slow.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
    out.err.stim = find(~isnan(MStim_(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.all.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss2.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss4.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss8.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    out.all.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss2.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss4.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss8.stim = find(~isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.fast.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed & SRT(:,1) > 50);
    in.slow.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
    in.err.nostim = find(isnan(MStim_(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    out.fast.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed & SRT(:,1) > 50);
    out.slow.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
    out.err.nostim = find(isnan(MStim_(:,1)) & Errors_(:,5) == 1 & ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.all.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss2.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss4.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss8.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    out.all.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss2.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss4.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss8.nostim = find(isnan(MStim_(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    RT
    
    if length(in.err.stim) < 5 | length(out.err.stim) < 5 | length(in.err.nostim) < 5 | length(out.err.nostim) < 5
        disp('too few errors; setting to NaN')
        errskip = 1;
    else
        errskip = 0;
    end
    
    
    %baseline correct
    %sig1 = baseline_correct(sig1,[400 500]);
    
    TDT.sig1.all.stim = getTDT_AD(sig1,in.all.stim,out.all.stim);
    TDT.sig1.ss2.stim = getTDT_AD(sig1,in.ss2.stim,out.ss2.stim);
    TDT.sig1.ss4.stim = getTDT_AD(sig1,in.ss4.stim,out.ss4.stim);
    TDT.sig1.ss8.stim = getTDT_AD(sig1,in.ss8.stim,out.ss8.stim);
    TDT.sig1.fast.stim = getTDT_AD(sig1,in.fast.stim,out.fast.stim);
    TDT.sig1.slow.stim = getTDT_AD(sig1,in.slow.stim,out.slow.stim);
    TDT.sig1.err.stim = getTDT_AD(sig1,in.err.stim,out.err.stim);
    
    TDT.sig2.all.stim = getTDT_SP(sig2,in.all.stim,out.all.stim);
    TDT.sig2.ss2.stim = getTDT_SP(sig2,in.ss2.stim,out.ss2.stim);
    TDT.sig2.ss4.stim = getTDT_SP(sig2,in.ss4.stim,out.ss4.stim);
    TDT.sig2.ss8.stim = getTDT_SP(sig2,in.ss8.stim,out.ss8.stim);
    TDT.sig2.fast.stim = getTDT_SP(sig2,in.fast.stim,out.fast.stim);
    TDT.sig2.slow.stim = getTDT_SP(sig2,in.slow.stim,out.slow.stim);
    TDT.sig2.err.stim = getTDT_SP(sig2,in.err.stim,out.err.stim);
    
    wf.sig1.in.all.stim = nanmean(sig1(in.all.stim,:));
    wf.sig1.in.ss2.stim = nanmean(sig1(in.ss2.stim,:));
    wf.sig1.in.ss4.stim = nanmean(sig1(in.ss4.stim,:));
    wf.sig1.in.ss8.stim = nanmean(sig1(in.ss8.stim,:));
    wf.sig1.in.fast.stim = nanmean(sig1(in.fast.stim,:));
    wf.sig1.in.slow.stim = nanmean(sig1(in.slow.stim,:));
    wf.sig1.in.err.stim = nanmean(sig1(in.err.stim,:));
    
    wf.sig1.out.all.stim = nanmean(sig1(out.all.stim,:));
    wf.sig1.out.ss2.stim = nanmean(sig1(out.ss2.stim,:));
    wf.sig1.out.ss4.stim = nanmean(sig1(out.ss4.stim,:));
    wf.sig1.out.ss8.stim = nanmean(sig1(out.ss8.stim,:));
    wf.sig1.out.fast.stim = nanmean(sig1(out.fast.stim,:));
    wf.sig1.out.slow.stim = nanmean(sig1(out.slow.stim,:));
    wf.sig1.out.err.stim = nanmean(sig1(out.err.stim,:));
    
    wf.sig2.in.all.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.all.stim,TrialStart_);
    wf.sig2.in.ss2.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss2.stim,TrialStart_);
    wf.sig2.in.ss4.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss4.stim,TrialStart_);
    wf.sig2.in.ss8.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss8.stim,TrialStart_);
    wf.sig2.in.fast.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.fast.stim,TrialStart_);
    wf.sig2.in.slow.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.slow.stim,TrialStart_);
    wf.sig2.in.err.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.err.stim,TrialStart_);
    
    wf.sig2.out.all.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.all.stim,TrialStart_);
    wf.sig2.out.ss2.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss2.stim,TrialStart_);
    wf.sig2.out.ss4.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss4.stim,TrialStart_);
    wf.sig2.out.ss8.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss8.stim,TrialStart_);
    wf.sig2.out.fast.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.fast.stim,TrialStart_);
    wf.sig2.out.slow.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.slow.stim,TrialStart_);
    wf.sig2.out.err.stim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.err.stim,TrialStart_);
    
    TDT.sig1.all.nostim = getTDT_AD(sig1,in.all.nostim,out.all.nostim);
    TDT.sig1.ss2.nostim = getTDT_AD(sig1,in.ss2.nostim,out.ss2.nostim);
    TDT.sig1.ss4.nostim = getTDT_AD(sig1,in.ss4.nostim,out.ss4.nostim);
    TDT.sig1.ss8.nostim = getTDT_AD(sig1,in.ss8.nostim,out.ss8.nostim);
    TDT.sig1.fast.nostim = getTDT_AD(sig1,in.fast.nostim,out.fast.nostim);
    TDT.sig1.slow.nostim = getTDT_AD(sig1,in.slow.nostim,out.slow.nostim);
    TDT.sig1.err.nostim = getTDT_AD(sig1,in.err.nostim,out.err.nostim);
    
    TDT.sig2.all.nostim = getTDT_SP(sig2,in.all.nostim,out.all.nostim);
    TDT.sig2.ss2.nostim = getTDT_SP(sig2,in.ss2.nostim,out.ss2.nostim);
    TDT.sig2.ss4.nostim = getTDT_SP(sig2,in.ss4.nostim,out.ss4.nostim);
    TDT.sig2.ss8.nostim = getTDT_SP(sig2,in.ss8.nostim,out.ss8.nostim);
    TDT.sig2.fast.nostim = getTDT_SP(sig2,in.fast.nostim,out.fast.nostim);
    TDT.sig2.slow.nostim = getTDT_SP(sig2,in.slow.nostim,out.slow.nostim);
    TDT.sig2.err.nostim = getTDT_SP(sig2,in.err.nostim,out.err.nostim);
    
    wf.sig1.in.all.nostim = nanmean(sig1(in.all.nostim,:));
    wf.sig1.in.ss2.nostim = nanmean(sig1(in.ss2.nostim,:));
    wf.sig1.in.ss4.nostim = nanmean(sig1(in.ss4.nostim,:));
    wf.sig1.in.ss8.nostim = nanmean(sig1(in.ss8.nostim,:));
    wf.sig1.in.fast.nostim = nanmean(sig1(in.fast.nostim,:));
    wf.sig1.in.slow.nostim = nanmean(sig1(in.slow.nostim,:));
    wf.sig1.in.err.nostim = nanmean(sig1(in.err.nostim,:));
    
    wf.sig1.out.all.nostim = nanmean(sig1(out.all.nostim,:));
    wf.sig1.out.ss2.nostim = nanmean(sig1(out.ss2.nostim,:));
    wf.sig1.out.ss4.nostim = nanmean(sig1(out.ss4.nostim,:));
    wf.sig1.out.ss8.nostim = nanmean(sig1(out.ss8.nostim,:));
    wf.sig1.out.fast.nostim = nanmean(sig1(out.fast.nostim,:));
    wf.sig1.out.slow.nostim = nanmean(sig1(out.slow.nostim,:));
    wf.sig1.out.err.nostim = nanmean(sig1(out.err.nostim,:));
    
    wf.sig2.in.all.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.all.nostim,TrialStart_);
    wf.sig2.in.ss2.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss2.nostim,TrialStart_);
    wf.sig2.in.ss4.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss4.nostim,TrialStart_);
    wf.sig2.in.ss8.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss8.nostim,TrialStart_);
    wf.sig2.in.fast.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.fast.nostim,TrialStart_);
    wf.sig2.in.slow.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.slow.nostim,TrialStart_);
    wf.sig2.in.err.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.err.nostim,TrialStart_);
    
    wf.sig2.out.all.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.all.nostim,TrialStart_);
    wf.sig2.out.ss2.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss2.nostim,TrialStart_);
    wf.sig2.out.ss4.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss4.nostim,TrialStart_);
    wf.sig2.out.ss8.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss8.nostim,TrialStart_);
    wf.sig2.out.fast.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.fast.nostim,TrialStart_);
    wf.sig2.out.slow.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.slow.nostim,TrialStart_);
    wf.sig2.out.err.nostim = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.err.nostim,TrialStart_);
    
    
    %fix Spike channel; change 0's to NaN and alter times
    sig2(sig2 == 0) = NaN;
    sig2 = sig2 - 500;
    
    %These are partial coherence/spectra only
    [a, b, c, Sx_noz.in.all.stim, Sy_noz.in.all.stim, d, PSx_noz.in.all.stim, PSy_noz.in.all.stim] = Spk_LFPCoh(sig2(in.all.stim,:),sig1(in.all.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.all.stim, f, tout, Sx.in.all.stim, Sy.in.all.stim, Pcoh.in.all.stim, PSx.in.all.stim, PSy.in.all.stim] = Spk_LFPCoh(sig2(in.all.stim,:),sig1(in.all.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.ss2.stim, Sy_noz.in.ss2.stim, d, PSx_noz.in.ss2.stim, PSy_noz.in.ss2.stim] = Spk_LFPCoh(sig2(in.ss2.stim,:),sig1(in.ss2.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.ss2.stim, f, tout, Sx.in.ss2.stim, Sy.in.ss2.stim, Pcoh.in.ss2.stim, PSx.in.ss2.stim, PSy.in.ss2.stim] = Spk_LFPCoh(sig2(in.ss2.stim,:),sig1(in.ss2.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.ss4.stim, Sy_noz.in.ss4.stim, d, PSx_noz.in.ss4.stim, PSy_noz.in.ss4.stim] = Spk_LFPCoh(sig2(in.ss4.stim,:),sig1(in.ss4.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.ss4.stim, f, tout, Sx.in.ss4.stim, Sy.in.ss4.stim, Pcoh.in.ss4.stim, PSx.in.ss4.stim, PSy.in.ss4.stim] = Spk_LFPCoh(sig2(in.ss4.stim,:),sig1(in.ss4.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.ss8.stim, Sy_noz.in.ss8.stim, d, PSx_noz.in.ss8.stim, PSy_noz.in.ss8.stim] = Spk_LFPCoh(sig2(in.ss8.stim,:),sig1(in.ss8.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.ss8.stim, f, tout, Sx.in.ss8.stim, Sy.in.ss8.stim, Pcoh.in.ss8.stim, PSx.in.ss8.stim, PSy.in.ss8.stim] = Spk_LFPCoh(sig2(in.ss8.stim,:),sig1(in.ss8.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.fast.stim, Sy_noz.in.fast.stim, d, PSx_noz.in.fast.stim, PSy_noz.in.fast.stim] = Spk_LFPCoh(sig2(in.fast.stim,:),sig1(in.fast.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.fast.stim, f, tout, Sx.in.fast.stim, Sy.in.fast.stim, Pcoh.in.fast.stim, PSx.in.fast.stim, PSy.in.fast.stim] = Spk_LFPCoh(sig2(in.fast.stim,:),sig1(in.fast.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.slow.stim, Sy_noz.in.slow.stim, d, PSx_noz.in.slow.stim, PSy_noz.in.slow.stim] = Spk_LFPCoh(sig2(in.slow.stim,:),sig1(in.slow.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.slow.stim, f, tout, Sx.in.slow.stim, Sy.in.slow.stim, Pcoh.in.slow.stim, PSx.in.slow.stim, PSy.in.slow.stim] = Spk_LFPCoh(sig2(in.slow.stim,:),sig1(in.slow.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    if errskip == 0
        [a, b, c, Sx_noz.in.err.stim, Sy_noz.in.err.stim, d, PSx_noz.in.err.stim, PSy_noz.in.err.stim] = Spk_LFPCoh(sig2(in.err.stim,:),sig1(in.err.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
        [coh.in.err.stim, f, tout, Sx.in.err.stim, Sy.in.err.stim, Pcoh.in.err.stim, PSx.in.err.stim, PSy.in.err.stim] = Spk_LFPCoh(sig2(in.err.stim,:),sig1(in.err.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    else
        Sx_noz.in.err.stim(1:length(tout),1:length(f)) = NaN;
        Sy_noz.in.err.stim(1:length(tout),1:length(f)) = NaN;
        PSx_noz.in.err.stim(1:length(tout),1:length(f)) = NaN;
        PSy_noz.in.err.stim(1:length(tout),1:length(f)) = NaN;
        coh.in.err.stim(1:length(tout),1:length(f)) = NaN;
        Sx.in.err.stim(1:length(tout),1:length(f)) = NaN;
        Sy.in.err.stim(1:length(tout),1:length(f)) = NaN;
        Pcoh.in.err.stim(1:length(tout),1:length(f)) = NaN;
        PSx.in.err.stim(1:length(tout),1:length(f)) = NaN;
        PSy.in.err.stim(1:length(tout),1:length(f)) = NaN;
    end
    
    clear a b c d
    
    [a, b, c, Sx_noz.out.all.stim, Sy_noz.out.all.stim, d, PSx_noz.out.all.stim, PSy_noz.out.all.stim] = Spk_LFPCoh(sig2(out.all.stim,:),sig1(out.all.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.all.stim, f, tout, Sx.out.all.stim, Sy.out.all.stim, Pcoh.out.all.stim, PSx.out.all.stim, PSy.out.all.stim] = Spk_LFPCoh(sig2(out.all.stim,:),sig1(out.all.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.ss2.stim, Sy_noz.out.ss2.stim, d, PSx_noz.out.ss2.stim, PSy_noz.out.ss2.stim] = Spk_LFPCoh(sig2(out.ss2.stim,:),sig1(out.ss2.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.ss2.stim, f, tout, Sx.out.ss2.stim, Sy.out.ss2.stim, Pcoh.out.ss2.stim, PSx.out.ss2.stim, PSy.out.ss2.stim] = Spk_LFPCoh(sig2(out.ss2.stim,:),sig1(out.ss2.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.ss4.stim, Sy_noz.out.ss4.stim, d, PSx_noz.out.ss4.stim, PSy_noz.out.ss4.stim] = Spk_LFPCoh(sig2(out.ss4.stim,:),sig1(out.ss4.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.ss4.stim, f, tout, Sx.out.ss4.stim, Sy.out.ss4.stim, Pcoh.out.ss4.stim, PSx.out.ss4.stim, PSy.out.ss4.stim] = Spk_LFPCoh(sig2(out.ss4.stim,:),sig1(out.ss4.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.ss8.stim, Sy_noz.out.ss8.stim, d, PSx_noz.out.ss8.stim, PSy_noz.out.ss8.stim] = Spk_LFPCoh(sig2(out.ss8.stim,:),sig1(out.ss8.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.ss8.stim, f, tout, Sx.out.ss8.stim, Sy.out.ss8.stim, Pcoh.out.ss8.stim, PSx.out.ss8.stim, PSy.out.ss8.stim] = Spk_LFPCoh(sig2(out.ss8.stim,:),sig1(out.ss8.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.fast.stim, Sy_noz.out.fast.stim, d, PSx_noz.out.fast.stim, PSy_noz.out.fast.stim] = Spk_LFPCoh(sig2(out.fast.stim,:),sig1(out.fast.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.fast.stim, f, tout, Sx.out.fast.stim, Sy.out.fast.stim, Pcoh.out.fast.stim, PSx.out.fast.stim, PSy.out.fast.stim] = Spk_LFPCoh(sig2(out.fast.stim,:),sig1(out.fast.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.slow.stim, Sy_noz.out.slow.stim, d, PSx_noz.out.slow.stim, PSy_noz.out.slow.stim] = Spk_LFPCoh(sig2(out.slow.stim,:),sig1(out.slow.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.slow.stim, f, tout, Sx.out.slow.stim, Sy.out.slow.stim, Pcoh.out.slow.stim, PSx.out.slow.stim, PSy.out.slow.stim] = Spk_LFPCoh(sig2(out.slow.stim,:),sig1(out.slow.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    if errskip == 0
        [a, b, c, Sx_noz.out.err.stim, Sy_noz.out.err.stim, d, PSx_noz.out.err.stim, PSy_noz.out.err.stim] = Spk_LFPCoh(sig2(out.err.stim,:),sig1(out.err.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
        [coh.out.err.stim, f, tout, Sx.out.err.stim, Sy.out.err.stim, Pcoh.out.err.stim, PSx.out.err.stim, PSy.out.err.stim] = Spk_LFPCoh(sig2(out.err.stim,:),sig1(out.err.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    else
        Sx_noz.out.err.stim(1:length(tout),1:length(f)) = NaN;
        Sy_noz.out.err.stim(1:length(tout),1:length(f)) = NaN;
        PSx_noz.out.err.stim(1:length(tout),1:length(f)) = NaN;
        PSy_noz.out.err.stim(1:length(tout),1:length(f)) = NaN;
        coh.out.err.stim(1:length(tout),1:length(f)) = NaN;
        Sx.out.err.stim(1:length(tout),1:length(f)) = NaN;
        Sy.out.err.stim(1:length(tout),1:length(f)) = NaN;
        Pcoh.out.err.stim(1:length(tout),1:length(f)) = NaN;
        PSx.out.err.stim(1:length(tout),1:length(f)) = NaN;
        PSy.out.err.stim(1:length(tout),1:length(f)) = NaN;
    end
    
    clear a b c d
    
    %==============================================
    % Do subsampling of correct trials for comparison with error trials
    nReps = 50;
    if errskip == 0
        for rep = 1:nReps
            rep
            in.all_sub.stim = shake(in.all.stim);
            in.all_sub.stim = in.all_sub.stim(randperm(length(in.err.stim)));
            
            out.all_sub.stim = shake(out.all.stim);
            out.all_sub.stim = out.all_sub.stim(randperm(length(out.err.stim)));
            
            [a, b, c, tempSx_noz.in.all_sub.stim, tempSy_noz.in.all_sub.stim, d, tempPSx_noz.in.all_sub.stim, tempPSy_noz.in.all_sub.stim] = Spk_LFPCoh(sig2(in.all_sub.stim,:),sig1(in.all_sub.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
            [tempcoh.in.all_sub.stim, f, tout, tempSx.in.all_sub.stim, tempSy.in.all_sub.stim, tempPcoh.in.all_sub.stim, tempPSx.in.all_sub.stim, tempPSy.in.all_sub.stim] = Spk_LFPCoh(sig2(in.all_sub.stim,:),sig1(in.all_sub.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
            
            [a, b, c, tempSx_noz.out.all_sub.stim, tempSy_noz.out.all_sub.stim, d, tempPSx_noz.out.all_sub.stim, tempPSy_noz.out.all_sub.stim] = Spk_LFPCoh(sig2(out.all_sub.stim,:),sig1(out.all_sub.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
            [tempcoh.out.all_sub.stim, f, tout, tempSx.out.all_sub.stim, tempSy.out.all_sub.stim, tempPcoh.out.all_sub.stim, tempPSx.out.all_sub.stim, tempPSy.out.all_sub.stim] = Spk_LFPCoh(sig2(out.all_sub.stim,:),sig1(out.all_sub.stim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
            
            Sx_noz.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempSx_noz.in.all_sub.stim;
            Sy_noz.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempSy_noz.in.all_sub.stim;
            PSx_noz.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempPSx_noz.in.all_sub.stim;
            PSy_noz.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempPSy_noz.in.all_sub.stim;
            coh.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempcoh.in.all_sub.stim;
            Sx.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempSx.in.all_sub.stim;
            Sy.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempSy.in.all_sub.stim;
            Pcoh.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempPcoh.in.all_sub.stim;
            PSx.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempPSx.in.all_sub.stim;
            PSy.in.all_sub.stim(1:length(tout),1:length(f),rep) = tempPSy.in.all_sub.stim;
            
            Sx_noz.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempSx_noz.out.all_sub.stim;
            Sy_noz.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempSy_noz.out.all_sub.stim;
            PSx_noz.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempPSx_noz.out.all_sub.stim;
            PSy_noz.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempPSy_noz.out.all_sub.stim;
            coh.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempcoh.out.all_sub.stim;
            Sx.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempSx.out.all_sub.stim;
            Sy.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempSy.out.all_sub.stim;
            Pcoh.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempPcoh.out.all_sub.stim;
            PSx.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempPSx.out.all_sub.stim;
            PSy.out.all_sub.stim(1:length(tout),1:length(f),rep) = tempPSy.out.all_sub.stim;
            
            clear temp*
        end
    else
        Sx_noz.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        Sy_noz.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        PSx_noz.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        PSy_noz.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        coh.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        Sx.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        Sy.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        Pcoh.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        PSx.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        PSy.in.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        
        Sx_noz.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        Sy_noz.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        PSx_noz.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        PSy_noz.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        coh.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        Sx.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        Sy.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        Pcoh.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        PSx.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        PSy.out.all_sub.stim(1:length(tout),1:length(f)) = NaN;
        
    end
    
    
    
    %These are partial coherence/spectra only
    [a, b, c, Sx_noz.in.all.nostim, Sy_noz.in.all.nostim, d, PSx_noz.in.all.nostim, PSy_noz.in.all.nostim] = Spk_LFPCoh(sig2(in.all.nostim,:),sig1(in.all.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.all.nostim, f, tout, Sx.in.all.nostim, Sy.in.all.nostim, Pcoh.in.all.nostim, PSx.in.all.nostim, PSy.in.all.nostim] = Spk_LFPCoh(sig2(in.all.nostim,:),sig1(in.all.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.ss2.nostim, Sy_noz.in.ss2.nostim, d, PSx_noz.in.ss2.nostim, PSy_noz.in.ss2.nostim] = Spk_LFPCoh(sig2(in.ss2.nostim,:),sig1(in.ss2.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.ss2.nostim, f, tout, Sx.in.ss2.nostim, Sy.in.ss2.nostim, Pcoh.in.ss2.nostim, PSx.in.ss2.nostim, PSy.in.ss2.nostim] = Spk_LFPCoh(sig2(in.ss2.nostim,:),sig1(in.ss2.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.ss4.nostim, Sy_noz.in.ss4.nostim, d, PSx_noz.in.ss4.nostim, PSy_noz.in.ss4.nostim] = Spk_LFPCoh(sig2(in.ss4.nostim,:),sig1(in.ss4.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.ss4.nostim, f, tout, Sx.in.ss4.nostim, Sy.in.ss4.nostim, Pcoh.in.ss4.nostim, PSx.in.ss4.nostim, PSy.in.ss4.nostim] = Spk_LFPCoh(sig2(in.ss4.nostim,:),sig1(in.ss4.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.ss8.nostim, Sy_noz.in.ss8.nostim, d, PSx_noz.in.ss8.nostim, PSy_noz.in.ss8.nostim] = Spk_LFPCoh(sig2(in.ss8.nostim,:),sig1(in.ss8.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.ss8.nostim, f, tout, Sx.in.ss8.nostim, Sy.in.ss8.nostim, Pcoh.in.ss8.nostim, PSx.in.ss8.nostim, PSy.in.ss8.nostim] = Spk_LFPCoh(sig2(in.ss8.nostim,:),sig1(in.ss8.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.fast.nostim, Sy_noz.in.fast.nostim, d, PSx_noz.in.fast.nostim, PSy_noz.in.fast.nostim] = Spk_LFPCoh(sig2(in.fast.nostim,:),sig1(in.fast.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.fast.nostim, f, tout, Sx.in.fast.nostim, Sy.in.fast.nostim, Pcoh.in.fast.nostim, PSx.in.fast.nostim, PSy.in.fast.nostim] = Spk_LFPCoh(sig2(in.fast.nostim,:),sig1(in.fast.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.slow.nostim, Sy_noz.in.slow.nostim, d, PSx_noz.in.slow.nostim, PSy_noz.in.slow.nostim] = Spk_LFPCoh(sig2(in.slow.nostim,:),sig1(in.slow.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.slow.nostim, f, tout, Sx.in.slow.nostim, Sy.in.slow.nostim, Pcoh.in.slow.nostim, PSx.in.slow.nostim, PSy.in.slow.nostim] = Spk_LFPCoh(sig2(in.slow.nostim,:),sig1(in.slow.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    if errskip == 0
        [a, b, c, Sx_noz.in.err.nostim, Sy_noz.in.err.nostim, d, PSx_noz.in.err.nostim, PSy_noz.in.err.nostim] = Spk_LFPCoh(sig2(in.err.nostim,:),sig1(in.err.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
        [coh.in.err.nostim, f, tout, Sx.in.err.nostim, Sy.in.err.nostim, Pcoh.in.err.nostim, PSx.in.err.nostim, PSy.in.err.nostim] = Spk_LFPCoh(sig2(in.err.nostim,:),sig1(in.err.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    else
        Sx_noz.in.err.nostim(1:length(tout),1:length(f)) = NaN;
        Sy_noz.in.err.nostim(1:length(tout),1:length(f)) = NaN;
        PSx_noz.in.err.nostim(1:length(tout),1:length(f)) = NaN;
        PSy_noz.in.err.nostim(1:length(tout),1:length(f)) = NaN;
        coh.in.err.nostim(1:length(tout),1:length(f)) = NaN;
        Sx.in.err.nostim(1:length(tout),1:length(f)) = NaN;
        Sy.in.err.nostim(1:length(tout),1:length(f)) = NaN;
        Pcoh.in.err.nostim(1:length(tout),1:length(f)) = NaN;
        PSx.in.err.nostim(1:length(tout),1:length(f)) = NaN;
        PSy.in.err.nostim(1:length(tout),1:length(f)) = NaN;
    end
    
    clear a b c d
    
    [a, b, c, Sx_noz.out.all.nostim, Sy_noz.out.all.nostim, d, PSx_noz.out.all.nostim, PSy_noz.out.all.nostim] = Spk_LFPCoh(sig2(out.all.nostim,:),sig1(out.all.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.all.nostim, f, tout, Sx.out.all.nostim, Sy.out.all.nostim, Pcoh.out.all.nostim, PSx.out.all.nostim, PSy.out.all.nostim] = Spk_LFPCoh(sig2(out.all.nostim,:),sig1(out.all.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.ss2.nostim, Sy_noz.out.ss2.nostim, d, PSx_noz.out.ss2.nostim, PSy_noz.out.ss2.nostim] = Spk_LFPCoh(sig2(out.ss2.nostim,:),sig1(out.ss2.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.ss2.nostim, f, tout, Sx.out.ss2.nostim, Sy.out.ss2.nostim, Pcoh.out.ss2.nostim, PSx.out.ss2.nostim, PSy.out.ss2.nostim] = Spk_LFPCoh(sig2(out.ss2.nostim,:),sig1(out.ss2.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.ss4.nostim, Sy_noz.out.ss4.nostim, d, PSx_noz.out.ss4.nostim, PSy_noz.out.ss4.nostim] = Spk_LFPCoh(sig2(out.ss4.nostim,:),sig1(out.ss4.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.ss4.nostim, f, tout, Sx.out.ss4.nostim, Sy.out.ss4.nostim, Pcoh.out.ss4.nostim, PSx.out.ss4.nostim, PSy.out.ss4.nostim] = Spk_LFPCoh(sig2(out.ss4.nostim,:),sig1(out.ss4.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.ss8.nostim, Sy_noz.out.ss8.nostim, d, PSx_noz.out.ss8.nostim, PSy_noz.out.ss8.nostim] = Spk_LFPCoh(sig2(out.ss8.nostim,:),sig1(out.ss8.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.ss8.nostim, f, tout, Sx.out.ss8.nostim, Sy.out.ss8.nostim, Pcoh.out.ss8.nostim, PSx.out.ss8.nostim, PSy.out.ss8.nostim] = Spk_LFPCoh(sig2(out.ss8.nostim,:),sig1(out.ss8.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.fast.nostim, Sy_noz.out.fast.nostim, d, PSx_noz.out.fast.nostim, PSy_noz.out.fast.nostim] = Spk_LFPCoh(sig2(out.fast.nostim,:),sig1(out.fast.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.fast.nostim, f, tout, Sx.out.fast.nostim, Sy.out.fast.nostim, Pcoh.out.fast.nostim, PSx.out.fast.nostim, PSy.out.fast.nostim] = Spk_LFPCoh(sig2(out.fast.nostim,:),sig1(out.fast.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.slow.nostim, Sy_noz.out.slow.nostim, d, PSx_noz.out.slow.nostim, PSy_noz.out.slow.nostim] = Spk_LFPCoh(sig2(out.slow.nostim,:),sig1(out.slow.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.slow.nostim, f, tout, Sx.out.slow.nostim, Sy.out.slow.nostim, Pcoh.out.slow.nostim, PSx.out.slow.nostim, PSy.out.slow.nostim] = Spk_LFPCoh(sig2(out.slow.nostim,:),sig1(out.slow.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    if errskip == 0
        [a, b, c, Sx_noz.out.err.nostim, Sy_noz.out.err.nostim, d, PSx_noz.out.err.nostim, PSy_noz.out.err.nostim] = Spk_LFPCoh(sig2(out.err.nostim,:),sig1(out.err.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
        [coh.out.err.nostim, f, tout, Sx.out.err.nostim, Sy.out.err.nostim, Pcoh.out.err.nostim, PSx.out.err.nostim, PSy.out.err.nostim] = Spk_LFPCoh(sig2(out.err.nostim,:),sig1(out.err.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    else
        Sx_noz.out.err.nostim(1:length(tout),1:length(f)) = NaN;
        Sy_noz.out.err.nostim(1:length(tout),1:length(f)) = NaN;
        PSx_noz.out.err.nostim(1:length(tout),1:length(f)) = NaN;
        PSy_noz.out.err.nostim(1:length(tout),1:length(f)) = NaN;
        coh.out.err.nostim(1:length(tout),1:length(f)) = NaN;
        Sx.out.err.nostim(1:length(tout),1:length(f)) = NaN;
        Sy.out.err.nostim(1:length(tout),1:length(f)) = NaN;
        Pcoh.out.err.nostim(1:length(tout),1:length(f)) = NaN;
        PSx.out.err.nostim(1:length(tout),1:length(f)) = NaN;
        PSy.out.err.nostim(1:length(tout),1:length(f)) = NaN;
    end
    
    clear a b c d
    
    %==============================================
    % Do subsampling of correct trials for comparison with error trials
    nReps = 50;
    if errskip == 0
        for rep = 1:nReps
            rep
            in.all_sub.nostim = shake(in.all.nostim);
            in.all_sub.nostim = in.all_sub.nostim(randperm(length(in.err.nostim)));
            
            out.all_sub.nostim = shake(out.all.nostim);
            out.all_sub.nostim = out.all_sub.nostim(randperm(length(out.err.nostim)));
            
            [a, b, c, tempSx_noz.in.all_sub.nostim, tempSy_noz.in.all_sub.nostim, d, tempPSx_noz.in.all_sub.nostim, tempPSy_noz.in.all_sub.nostim] = Spk_LFPCoh(sig2(in.all_sub.nostim,:),sig1(in.all_sub.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
            [tempcoh.in.all_sub.nostim, f, tout, tempSx.in.all_sub.nostim, tempSy.in.all_sub.nostim, tempPcoh.in.all_sub.nostim, tempPSx.in.all_sub.nostim, tempPSy.in.all_sub.nostim] = Spk_LFPCoh(sig2(in.all_sub.nostim,:),sig1(in.all_sub.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
            
            [a, b, c, tempSx_noz.out.all_sub.nostim, tempSy_noz.out.all_sub.nostim, d, tempPSx_noz.out.all_sub.nostim, tempPSy_noz.out.all_sub.nostim] = Spk_LFPCoh(sig2(out.all_sub.nostim,:),sig1(out.all_sub.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
            [tempcoh.out.all_sub.nostim, f, tout, tempSx.out.all_sub.nostim, tempSy.out.all_sub.nostim, tempPcoh.out.all_sub.nostim, tempPSx.out.all_sub.nostim, tempPSy.out.all_sub.nostim] = Spk_LFPCoh(sig2(out.all_sub.nostim,:),sig1(out.all_sub.nostim,:),tapers,-500,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
            
            Sx_noz.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempSx_noz.in.all_sub.nostim;
            Sy_noz.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempSy_noz.in.all_sub.nostim;
            PSx_noz.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPSx_noz.in.all_sub.nostim;
            PSy_noz.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPSy_noz.in.all_sub.nostim;
            coh.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempcoh.in.all_sub.nostim;
            Sx.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempSx.in.all_sub.nostim;
            Sy.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempSy.in.all_sub.nostim;
            Pcoh.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPcoh.in.all_sub.nostim;
            PSx.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPSx.in.all_sub.nostim;
            PSy.in.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPSy.in.all_sub.nostim;
            
            Sx_noz.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempSx_noz.out.all_sub.nostim;
            Sy_noz.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempSy_noz.out.all_sub.nostim;
            PSx_noz.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPSx_noz.out.all_sub.nostim;
            PSy_noz.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPSy_noz.out.all_sub.nostim;
            coh.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempcoh.out.all_sub.nostim;
            Sx.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempSx.out.all_sub.nostim;
            Sy.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempSy.out.all_sub.nostim;
            Pcoh.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPcoh.out.all_sub.nostim;
            PSx.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPSx.out.all_sub.nostim;
            PSy.out.all_sub.nostim(1:length(tout),1:length(f),rep) = tempPSy.out.all_sub.nostim;
            
            clear temp*
        end
    else
        Sx_noz.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        Sy_noz.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        PSx_noz.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        PSy_noz.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        coh.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        Sx.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        Sy.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        Pcoh.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        PSx.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        PSy.in.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        
        Sx_noz.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        Sy_noz.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        PSx_noz.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        PSy_noz.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        coh.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        Sx.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        Sy.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        Pcoh.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        PSx.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        PSy.out.all_sub.nostim(1:length(tout),1:length(f)) = NaN;
        
    end
    
    
    
    if saveFlag == 1
        save(['/volumes/Dump/Analyses/uStim/SPK-LFP/' file_name{sess} '_' ...
            sig1_name{sess} sig2_name{sess} '.mat'],'coh','f','tout','Sx','Sy', ...
            'Pcoh','PSx','PSy','wf','TDT','Sx_noz','Sy_noz', ...
            'PSx_noz','PSy_noz','-mat')
    end
    
    keep file_name sig1_name sig2_name sess saveFlag q c qcq
    
end