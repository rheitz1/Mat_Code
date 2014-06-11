%partial coherence for SPK-LFP comparisons
%
%SPK-SPK comparisons consider any 2 neurons with overlapping RFs.  Using
%intersection of both RFs.  Signals had to demonstrate significant selectivity by
%running Wilcoxon (i.e., have significant TDT that looked correct by
%inspection).

[file_name sig1_name sig2_name] = textread('SPKSPK_anyhemi.txt', '%s %s %s');

q = '''';
c = ',';
qcq = [q c q];

saveFlag = 1;

for sess = 1:length(file_name)
    cell2mat(file_name(sess))
    
    load(cell2mat(file_name(sess)),sig1_name{sess},sig2_name{sess}, ...
        'EyeX_','EyeY_','newfile','Target_','Errors_','Correct_','RFs','Hemi','SRT','TrialStart_')
    
    fixErrors
    
    %get saccade locations for error trials
    [SRT saccLoc] = getSRT(EyeX_,EyeY_);
    
    sig1 = eval(sig1_name{sess});
    sig2 = eval(sig2_name{sess});
    
    tapers = PreGenTapers([.2 5]);
    
    RF1 = RFs.(sig1_name{sess});
    RF2 = RFs.(sig2_name{sess});
    
    RF = intersect(RF1,RF2);
    antiRF = mod((RF+4),8);
    
    
    
    
    
    % Do median split for fast/slow comparison
    cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    
    in.fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < cMed & SRT(:,1) > 50);
    in.slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
    in.err = find(Errors_(:,5) == 1 & ismember(Target_(:,2),RF) & ismember(saccLoc,antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    out.fast = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < cMed & SRT(:,1) > 50);
    out.slow = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) >= cMed & SRT(:,1) < 2000);
    out.err = find(Errors_(:,5) == 1 & ismember(Target_(:,2),antiRF) & ismember(saccLoc,RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    in.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 2 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 4 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    in.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & Target_(:,5) == 8 &  SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    out.all = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss2 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss4 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    out.ss8 = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    %baseline correct
    %sig1 = baseline_correct(sig1,[400 500]);
    
    TDT.sig1.all = getTDT_SP(sig1,in.all,out.all);
    TDT.sig1.ss2 = getTDT_SP(sig1,in.ss2,out.ss2);
    TDT.sig1.ss4 = getTDT_SP(sig1,in.ss4,out.ss4);
    TDT.sig1.ss8 = getTDT_SP(sig1,in.ss8,out.ss8);
    TDT.sig1.fast = getTDT_SP(sig1,in.fast,out.fast);
    TDT.sig1.slow = getTDT_SP(sig1,in.slow,out.slow);
    TDT.sig1.err = getTDT_SP(sig1,in.err,out.err);
    
    TDT.sig2.all = getTDT_SP(sig2,in.all,out.all);
    TDT.sig2.ss2 = getTDT_SP(sig2,in.ss2,out.ss2);
    TDT.sig2.ss4 = getTDT_SP(sig2,in.ss4,out.ss4);
    TDT.sig2.ss8 = getTDT_SP(sig2,in.ss8,out.ss8);
    TDT.sig2.fast = getTDT_SP(sig2,in.fast,out.fast);
    TDT.sig2.slow = getTDT_SP(sig2,in.slow,out.slow);
    TDT.sig2.err = getTDT_SP(sig2,in.err,out.err);
    
    wf.sig1.in.all = spikedensityfunct(sig1,Target_(:,1),[-500 2500],in.all,TrialStart_);
    wf.sig1.in.ss2 = spikedensityfunct(sig1,Target_(:,1),[-500 2500],in.ss2,TrialStart_);
    wf.sig1.in.ss4 = spikedensityfunct(sig1,Target_(:,1),[-500 2500],in.ss4,TrialStart_);
    wf.sig1.in.ss8 = spikedensityfunct(sig1,Target_(:,1),[-500 2500],in.ss8,TrialStart_);
    wf.sig1.in.fast = spikedensityfunct(sig1,Target_(:,1),[-500 2500],in.fast,TrialStart_);
    wf.sig1.in.slow = spikedensityfunct(sig1,Target_(:,1),[-500 2500],in.slow,TrialStart_);
    wf.sig1.in.err = spikedensityfunct(sig1,Target_(:,1),[-500 2500],in.err,TrialStart_);
    
    wf.sig1.out.all = spikedensityfunct(sig1,Target_(:,1),[-500 2500],out.all,TrialStart_);
    wf.sig1.out.ss2 = spikedensityfunct(sig1,Target_(:,1),[-500 2500],out.ss2,TrialStart_);
    wf.sig1.out.ss4 = spikedensityfunct(sig1,Target_(:,1),[-500 2500],out.ss4,TrialStart_);
    wf.sig1.out.ss8 = spikedensityfunct(sig1,Target_(:,1),[-500 2500],out.ss8,TrialStart_);
    wf.sig1.out.fast = spikedensityfunct(sig1,Target_(:,1),[-500 2500],out.fast,TrialStart_);
    wf.sig1.out.slow = spikedensityfunct(sig1,Target_(:,1),[-500 2500],out.slow,TrialStart_);
    wf.sig1.out.err = spikedensityfunct(sig1,Target_(:,1),[-500 2500],out.err,TrialStart_);
    
    wf.sig2.in.all = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.all,TrialStart_);
    wf.sig2.in.ss2 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss2,TrialStart_);
    wf.sig2.in.ss4 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss4,TrialStart_);
    wf.sig2.in.ss8 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.ss8,TrialStart_);
    wf.sig2.in.fast = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.fast,TrialStart_);
    wf.sig2.in.slow = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.slow,TrialStart_);
    wf.sig2.in.err = spikedensityfunct(sig2,Target_(:,1),[-500 2500],in.err,TrialStart_);
    
    wf.sig2.out.all = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.all,TrialStart_);
    wf.sig2.out.ss2 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss2,TrialStart_);
    wf.sig2.out.ss4 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss4,TrialStart_);
    wf.sig2.out.ss8 = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.ss8,TrialStart_);
    wf.sig2.out.fast = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.fast,TrialStart_);
    wf.sig2.out.slow = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.slow,TrialStart_);
    wf.sig2.out.err = spikedensityfunct(sig2,Target_(:,1),[-500 2500],out.err,TrialStart_);
    
    %fix Spike channels; change 0's to NaN and alter times
    sig1(sig1 == 0) = NaN;
    sig1 = sig1 - 500;
    
    sig2(sig2 == 0) = NaN;
    sig2 = sig2 - 500;
    
    %These are partial coherence/spectra only
    [a, b, c, Sx_noz.in.all, Sy_noz.in.all, d, PSx_noz.in.all, PSy_noz.in.all] = Spk_SpkCoh(sig1(in.all,:),sig2(in.all,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.all, f, tout, Sx.in.all, Sy.in.all, Pcoh.in.all, PSx.in.all, PSy.in.all] = Spk_SpkCoh(sig1(in.all,:),sig2(in.all,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.ss2, Sy_noz.in.ss2, d, PSx_noz.in.ss2, PSy_noz.in.ss2] = Spk_SpkCoh(sig1(in.ss2,:),sig2(in.ss2,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.ss2, f, tout, Sx.in.ss2, Sy.in.ss2, Pcoh.in.ss2, PSx.in.ss2, PSy.in.ss2] = Spk_SpkCoh(sig1(in.ss2,:),sig2(in.ss2,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.ss4, Sy_noz.in.ss4, d, PSx_noz.in.ss4, PSy_noz.in.ss4] = Spk_SpkCoh(sig1(in.ss4,:),sig2(in.ss4,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.ss4, f, tout, Sx.in.ss4, Sy.in.ss4, Pcoh.in.ss4, PSx.in.ss4, PSy.in.ss4] = Spk_SpkCoh(sig1(in.ss4,:),sig2(in.ss4,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.ss8, Sy_noz.in.ss8, d, PSx_noz.in.ss8, PSy_noz.in.ss8] = Spk_SpkCoh(sig1(in.ss8,:),sig2(in.ss8,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.ss8, f, tout, Sx.in.ss8, Sy.in.ss8, Pcoh.in.ss8, PSx.in.ss8, PSy.in.ss8] = Spk_SpkCoh(sig1(in.ss8,:),sig2(in.ss8,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.fast, Sy_noz.in.fast, d, PSx_noz.in.fast, PSy_noz.in.fast] = Spk_SpkCoh(sig1(in.fast,:),sig2(in.fast,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.fast, f, tout, Sx.in.fast, Sy.in.fast, Pcoh.in.fast, PSx.in.fast, PSy.in.fast] = Spk_SpkCoh(sig1(in.fast,:),sig2(in.fast,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.slow, Sy_noz.in.slow, d, PSx_noz.in.slow, PSy_noz.in.slow] = Spk_SpkCoh(sig1(in.slow,:),sig2(in.slow,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.slow, f, tout, Sx.in.slow, Sy.in.slow, Pcoh.in.slow, PSx.in.slow, PSy.in.slow] = Spk_SpkCoh(sig1(in.slow,:),sig2(in.slow,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.in.err, Sy_noz.in.err, d, PSx_noz.in.err, PSy_noz.in.err] = Spk_SpkCoh(sig1(in.err,:),sig2(in.err,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.in.err, f, tout, Sx.in.err, Sy.in.err, Pcoh.in.err, PSx.in.err, PSy.in.err] = Spk_SpkCoh(sig1(in.err,:),sig2(in.err,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    clear a b c d
    
    [a, b, c, Sx_noz.out.all, Sy_noz.out.all, d, PSx_noz.out.all, PSy_noz.out.all] = Spk_SpkCoh(sig1(out.all,:),sig2(out.all,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.all, f, tout, Sx.out.all, Sy.out.all, Pcoh.out.all, PSx.out.all, PSy.out.all] = Spk_SpkCoh(sig1(out.all,:),sig2(out.all,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.ss2, Sy_noz.out.ss2, d, PSx_noz.out.ss2, PSy_noz.out.ss2] = Spk_SpkCoh(sig1(out.ss2,:),sig2(out.ss2,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.ss2, f, tout, Sx.out.ss2, Sy.out.ss2, Pcoh.out.ss2, PSx.out.ss2, PSy.out.ss2] = Spk_SpkCoh(sig1(out.ss2,:),sig2(out.ss2,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.ss4, Sy_noz.out.ss4, d, PSx_noz.out.ss4, PSy_noz.out.ss4] = Spk_SpkCoh(sig1(out.ss4,:),sig2(out.ss4,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.ss4, f, tout, Sx.out.ss4, Sy.out.ss4, Pcoh.out.ss4, PSx.out.ss4, PSy.out.ss4] = Spk_SpkCoh(sig1(out.ss4,:),sig2(out.ss4,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.ss8, Sy_noz.out.ss8, d, PSx_noz.out.ss8, PSy_noz.out.ss8] = Spk_SpkCoh(sig1(out.ss8,:),sig2(out.ss8,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.ss8, f, tout, Sx.out.ss8, Sy.out.ss8, Pcoh.out.ss8, PSx.out.ss8, PSy.out.ss8] = Spk_SpkCoh(sig1(out.ss8,:),sig2(out.ss8,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.fast, Sy_noz.out.fast, d, PSx_noz.out.fast, PSy_noz.out.fast] = Spk_SpkCoh(sig1(out.fast,:),sig2(out.fast,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.fast, f, tout, Sx.out.fast, Sy.out.fast, Pcoh.out.fast, PSx.out.fast, PSy.out.fast] = Spk_SpkCoh(sig1(out.fast,:),sig2(out.fast,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.slow, Sy_noz.out.slow, d, PSx_noz.out.slow, PSy_noz.out.slow] = Spk_SpkCoh(sig1(out.slow,:),sig2(out.slow,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.slow, f, tout, Sx.out.slow, Sy.out.slow, Pcoh.out.slow, PSx.out.slow, PSy.out.slow] = Spk_SpkCoh(sig1(out.slow,:),sig2(out.slow,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    [a, b, c, Sx_noz.out.err, Sy_noz.out.err, d, PSx_noz.out.err, PSy_noz.out.err] = Spk_SpkCoh(sig1(out.err,:),sig2(out.err,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,0);
    [coh.out.err, f, tout, Sx.out.err, Sy.out.err, Pcoh.out.err, PSx.out.err, PSy.out.err] = Spk_SpkCoh(sig1(out.err,:),sig2(out.err,:),tapers,[-500 2500],1000,.01,[0 100],0,4,.05,0,2,1);
    
    clear a b c d
    
    
    
    
    
    if saveFlag == 1
        save(['/volumes/Dump2/Coherence/Uber/SPK-SPK/' file_name{sess} '_' ...
            sig1_name{sess} sig2_name{sess} '.mat'],'coh','f','tout','Sx','Sy', ...
            'Pcoh','PSx','PSy','wf','TDT','Sx_noz','Sy_noz', ...
            'PSx_noz','PSy_noz','-mat')
    end
    
    keep file_name sig1_name sig2_name sess saveFlag q c qcq
    
end