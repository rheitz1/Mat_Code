%partial coherence for SPK-LFP comparisons
%
%SPK-LFP comparisons were only those recorded in same hemisphere.  Using
%NEURON RF for both signals.  Signals had to demonstrate significant selectivity by
%running Wilcoxon (i.e., have significant TDT that looked correct by
%inspection)


[file_name sig1_name sig2_name] = textread('SPKLFP.txt', '%s %s %s');

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
    
    %FILTER 35-80 as did Gregariou et al. 2009
    
    sig1 = filtSig(sig1,[35 80],'bandpass');
    
    STA.in.all = getSTA(sig2(in.all,:),sig1(in.all,:),100);
    STA.in.ss2 = getSTA(sig2(in.ss2,:),sig1(in.ss2,:),100);
    STA.in.ss4 = getSTA(sig2(in.ss4,:),sig1(in.ss4,:),100);
    STA.in.ss8 = getSTA(sig2(in.ss8,:),sig1(in.ss8,:),100);
    STA.in.fast = getSTA(sig2(in.fast,:),sig1(in.fast,:),100);
    STA.in.slow = getSTA(sig2(in.slow,:),sig1(in.slow,:),100);
    STA.in.err = getSTA(sig2(in.err,:),sig1(in.err,:),100);
    
    STA.out.all = getSTA(sig2(out.all,:),sig1(out.all,:),100);
    STA.out.ss2 = getSTA(sig2(out.ss2,:),sig1(out.ss2,:),100);
    STA.out.ss4 = getSTA(sig2(out.ss4,:),sig1(out.ss4,:),100);
    STA.out.ss8 = getSTA(sig2(out.ss8,:),sig1(out.ss8,:),100);
    STA.out.fast = getSTA(sig2(out.fast,:),sig1(out.fast,:),100);
    STA.out.slow = getSTA(sig2(out.slow,:),sig1(out.slow,:),100);
    STA.out.err = getSTA(sig2(out.err,:),sig1(out.err,:),100);
    
    
    
    
    if saveFlag == 1
        save(['/volumes/Dump2/Coherence/Uber/SPK-LFP_STA/' file_name{sess} '_' ...
            sig1_name{sess} sig2_name{sess} '_STA.mat'],'STA','-mat')
    end
    
    keep file_name sig1_name sig2_name sess saveFlag q c qcq
    
end