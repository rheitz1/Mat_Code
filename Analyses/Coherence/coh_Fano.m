%sub for various uses; iterates through all search files

cd /Volumes/Dump2/Coherence/Uber_Tune_NeuronRF_intersection_shuff_allTL/overlap/SameElectrode/

batch_list = dir('Q*mat');

for sess = 1:length(batch_list)
    
    batch_list(sess).name
    fname = batch_list(sess).name(1:20);
    ADname = batch_list(sess).name(22:25);
    DSPname = batch_list(sess).name(26:31);
    
    load(fname,DSPname,'EyeX_','Errors_','EyeY_','newfile','Target_','Correct_','SRT','RFs','TrialStart_')
    timewin = [-200 500];
    RF = RFs.(DSPname);
    antiRF = mod((RF+4),8);
    
    %get saccade locations for error trials
    [SRT saccLoc] = getSRT(EyeX_,EyeY_);
    clear EyeX_ EyeY_
    
    
    Spike = eval(DSPname);
    %SDF = sSDF(Spike,Target_(:,1),[timewin(1) timewin(2)]);
    
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
    
    RTs.correct(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.err(sess,1) = nanmean(SRT(find(Correct_(:,2) == 0 & Target_(:,2) ~= 255),1));
    RTs.ss2(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 2 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.ss4(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 4 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.ss8(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & Target_(:,5) == 8 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
    RTs.fast(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) > 50 & SRT(:,1) < cMed),1));
    RTs.slow(sess,1) = nanmean(SRT(find(Correct_(:,2) == 1 & Target_(:,2) ~= 255 & SRT(:,1) < 2000 & SRT(:,1) >= cMed),1));
    
    
    binwidth = 20;
    stats.in.all = getSpikeStats(Spike,binwidth,in.all);
    stats.in.ss2 = getSpikeStats(Spike,binwidth,in.ss2);
    stats.in.ss4 = getSpikeStats(Spike,binwidth,in.ss4);
    stats.in.ss8 = getSpikeStats(Spike,binwidth,in.ss8);
    stats.in.fast = getSpikeStats(Spike,binwidth,in.fast);
    stats.in.slow = getSpikeStats(Spike,binwidth,in.slow);
    
    stats.out.all = getSpikeStats(Spike,binwidth,out.all);
    stats.out.ss2 = getSpikeStats(Spike,binwidth,out.ss2);
    stats.out.ss4 = getSpikeStats(Spike,binwidth,out.ss4);
    stats.out.ss8 = getSpikeStats(Spike,binwidth,out.ss8);
    stats.out.fast = getSpikeStats(Spike,binwidth,out.fast);
    stats.out.slow = getSpikeStats(Spike,binwidth,out.slow);
    
    
    CV.in.all(sess,1) = stats.in.all.CV;
    CV.in.ss2(sess,1) = stats.in.ss2.CV;
    CV.in.ss4(sess,1) = stats.in.ss4.CV;
    CV.in.ss8(sess,1) = stats.in.ss8.CV;
    CV.in.fast(sess,1) = stats.in.fast.CV;
    CV.in.slow(sess,1) = stats.in.slow.CV;
    
    CV.out.all(sess,1) = stats.out.all.CV;
    CV.out.ss2(sess,1) = stats.out.ss2.CV;
    CV.out.ss4(sess,1) = stats.out.ss4.CV;
    CV.out.ss8(sess,1) = stats.out.ss8.CV;
    CV.out.fast(sess,1) = stats.out.fast.CV;
    CV.out.slow(sess,1) = stats.out.slow.CV;
    
    
    NV.in.all(sess,1:3001) = stats.in.all.NV;
    NV.in.ss2(sess,1:3001) = stats.in.ss2.NV;
    NV.in.ss4(sess,1:3001) = stats.in.ss4.NV;
    NV.in.ss8(sess,1:3001) = stats.in.ss8.NV;
    NV.in.fast(sess,1:3001) = stats.in.fast.NV;
    NV.in.slow(sess,1:3001) = stats.in.slow.NV;
    
    NV.out.all(sess,1:3001) = stats.out.all.NV;
    NV.out.ss2(sess,1:3001) = stats.out.ss2.NV;
    NV.out.ss4(sess,1:3001) = stats.out.ss4.NV;
    NV.out.ss8(sess,1:3001) = stats.out.ss8.NV;
    NV.out.fast(sess,1:3001) = stats.out.fast.NV;
    NV.out.slow(sess,1:3001) = stats.out.slow.NV;
    
    Fano.in.all(sess,1:length(1:binwidth:3001-1)) = stats.in.all.Fano;
    Fano.in.ss2(sess,1:length(1:binwidth:3001-1)) = stats.in.ss2.Fano;
    Fano.in.ss4(sess,1:length(1:binwidth:3001-1)) = stats.in.ss4.Fano;
    Fano.in.ss8(sess,1:length(1:binwidth:3001-1)) = stats.in.ss8.Fano;
    Fano.in.fast(sess,1:length(1:binwidth:3001-1)) = stats.in.fast.Fano;
    Fano.in.slow(sess,1:length(1:binwidth:3001-1)) = stats.in.slow.Fano;
    
    Fano.out.all(sess,1:length(1:binwidth:3001-1)) = stats.out.all.Fano;
    Fano.out.ss2(sess,1:length(1:binwidth:3001-1)) = stats.out.ss2.Fano;
    Fano.out.ss4(sess,1:length(1:binwidth:3001-1)) = stats.out.ss4.Fano;
    Fano.out.ss8(sess,1:length(1:binwidth:3001-1)) = stats.out.ss8.Fano;
    Fano.out.fast(sess,1:length(1:binwidth:3001-1)) = stats.out.fast.Fano;
    Fano.out.slow(sess,1:length(1:binwidth:3001-1)) = stats.out.slow.Fano;
    
    
    %for errors
    try
        stats.in.err = getSpikeStats(Spike,binwidth,in.err);
        CV.in.err(sess,1) = stats.in.err.CV;
        NV.in.err(sess,1:3001) = stats.in.err.NV;
        Fano.in.err(sess,1:length(1:binwidth:3001-1)) = stats.in.err.Fano;
    catch
        CV.in.err(sess,1) = NaN;
        NV.in.err(sess,1:3001) = NaN;
        Fano.in.err(sess,1:length(1:binwidth:3001-1)) = NaN;
    end
    
    try
        stats.out.err = getSpikeStats(Spike,binwidth,out.err);
        CV.out.err(sess,1) = stats.out.err.CV;
        NV.out.err(sess,1:3001) = stats.out.err.NV;
        Fano.out.err(sess,1:length(1:binwidth:3001-1)) = stats.out.err.Fano;
    catch
        CV.out.err(sess,1) = NaN;
        NV.out.err(sess,1:3001) = NaN;
        Fano.out.err(sess,1:length(1:binwidth:3001-1)) = NaN;
    end
    
    keep RTs CV NV Fano batch_list sess
    
end
