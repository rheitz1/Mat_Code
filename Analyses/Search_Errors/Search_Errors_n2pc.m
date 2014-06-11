%analysis routine for TDT correct vs errors in spike and AD channels
%RPH
%4/22/09

function [] = Search_Errors_n2pc(file)
f = figure;
q = '''';
c = ',';
qcq = [q c q];
PDFflag = 0;
saveFlag = 1;
% path(path,'//scratch/heitzrp/')
% path(path,'//scratch/heitzrp/Data_all/')

try
    ChanStruct = loadChan(file,'DSP');
catch
    disp('ERROR IN LOADING CHANNELS....SKIPPING')
    return
end

DSPlist = fieldnames(ChanStruct);
decodeChanStruct

ChanStruct = loadChan(file,'LFP');
LFPlist = fieldnames(ChanStruct);
decodeChanStruct

%manually add AD02 and AD03
try
    eval(['load(' q file qcq 'AD02' qcq '-mat' q ')']);
    disp('loading AD02')
    chanlist3{1,1} = 'AD02';
catch
    disp('Missing AD02')
end

try
    eval(['load(' q file qcq 'AD03' qcq '-mat' q ')']);
    chanlist3{2,1} = 'AD03';
    disp('loading AD03')
catch
    disp('Missing AD03')
end

EEGlist = chanlist3;

%full chanlist
allchanlist = [DSPlist;LFPlist;EEGlist];


%set up subplot display by number of channels to be plotted
if size(allchanlist,1) <= 4
    matx = 2;
    maty = 2;
elseif size(allchanlist,1) > 4 & size(allchanlist,1) <=6
    matx = 3;
    maty = 2;
elseif size(allchanlist,1) > 6 & size(allchanlist,1) <= 9
    matx = 3;
    maty = 3;
elseif size(allchanlist,1) > 9 & size(allchanlist,1) <= 12
    matx = 4;
    maty = 4;
else
    matx = 5;
    maty = 5;
end
plotnum = 1;

%load Target_ & Correct_ variable
eval(['load(' q file qcq 'SaccDir_' qcq 'Hemi' qcq 'RFs' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);
fixErrors


%Check file to see if SaccDir_ contains only NaNs (before this was
%coded in Tempo)
if length(find(~isnan(SaccDir_))) < 5 %sometimes there are strays...
    eval(['load(' q file qcq 'EyeX_' qcq 'EyeY_' q ')'])
    getMonk
    [x SaccDir_] = getSRT(EyeX_,EyeY_,ASL_Delay,monkey);
    clear x EyeX_ EyeY_ ASL_Delay monkey
end

%keep track of RTs
RTs.correct = SRT(find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) ~= 255),1);
RTs.errors = SRT(find(Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & Target_(:,2) ~= 255),1);
%=============================================================
% TDT for Spike Channels
if isempty(DSPlist)
    disp('No Spike Channel detected...')
else
    
    
    
    for DSPchan = 1:size(DSPlist,1)
        Spike = eval(cell2mat(DSPlist(DSPchan)));
        RF = eval(['RFs.' cell2mat(DSPlist(DSPchan))]);
        
        if isempty(RF)
            disp('Empty RF...moving on...')
            continue
        end
        
        antiRF = mod((RF+4),8);
        
        
        in_correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out_correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        in_incorrect = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,antiRF));
        out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(SaccDir_,RF));
        
        
        %abort if there any condition has no trials
        if (isempty(in_correct) || isempty(out_correct) || isempty(in_incorrect) || isempty(out_incorrect))
            disp('At least one condition has no trials...moving on...')
            continue
        end
        
        
        SDF_in_correct = spikedensityfunct(Spike,Target_(:,1),[-100 500],in_correct,TrialStart_);
        SDF_out_correct = spikedensityfunct(Spike,Target_(:,1),[-100 500],out_correct,TrialStart_);
        SDF_in_incorrect = spikedensityfunct(Spike,Target_(:,1),[-100 500],in_incorrect,TrialStart_);
        SDF_out_incorrect = spikedensityfunct(Spike,Target_(:,1),[-100 500],out_incorrect,TrialStart_);
        
        n.([cell2mat(DSPlist(DSPchan)) '_correct']).in = length(in_correct);
        n.([cell2mat(DSPlist(DSPchan)) '_correct']).out = length(out_correct);
        n.([cell2mat(DSPlist(DSPchan)) '_errors']).in = length(in_incorrect);
        n.([cell2mat(DSPlist(DSPchan)) '_errors']).out = length(out_incorrect);
        
        %keep track of waveforms
        wf.([cell2mat(DSPlist(DSPchan)) '_correct']).in = SDF_in_correct;
        wf.([cell2mat(DSPlist(DSPchan)) '_correct']).out = SDF_out_correct;
        wf.([cell2mat(DSPlist(DSPchan)) '_errors']).in = SDF_in_incorrect;
        wf.([cell2mat(DSPlist(DSPchan)) '_errors']).out = SDF_out_incorrect;
        
        
        TDT.([cell2mat(DSPlist(DSPchan)) '_correct']) = getTDT_SP(Spike,in_correct,out_correct);
        
        %check valence of target in vs target out activity at TDT (1 ==
        %Tin greater
        try
            if SDF_in_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']) + 100) > SDF_out_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']) + 100)
                valence.([cell2mat(DSPlist(DSPchan)) '_correct']) = '1';
            elseif SDF_in_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']) + 100) < SDF_out_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']) + 100)
                valence.([cell2mat(DSPlist(DSPchan)) '_correct']) = '-1';
            end
        catch
            valence.([cell2mat(DSPlist(DSPchan)) '_correct']) = NaN;
        end
        
        TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) = getTDT_SP(Spike,in_incorrect,out_incorrect);
        
        %check valence of target in vs target out activity at TDT (1 ==
        %Tin greater
        try
            if SDF_in_incorrect(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100) > SDF_out_incorrect(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100)
                valence.([cell2mat(DSPlist(DSPchan)) '_errors']) = '1';
            elseif SDF_in_incorrect(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100) < SDF_out_incorrect(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100)
                valence.([cell2mat(DSPlist(DSPchan)) '_errors']) = '-1';
            end
        catch
            valence.([cell2mat(DSPlist(DSPchan)) '_errors']) = NaN;
        end
        
        
        subplot(maty,matx,plotnum)
        plot(-100:500,SDF_in_correct,'b',-100:500,SDF_out_correct,'--b',-100:500,SDF_in_incorrect,'r',-100:500,SDF_out_incorrect,'--r')
        fon
        xlim([-100 500])
        
        vline(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']),'b')
        vline(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']),'r')
        
        title(cell2mat(DSPlist(DSPchan)))
        
        plotnum = plotnum + 1;
    end
    clear Spike SDF* RF antiRF
end
%==========================================================











%=============================================================
% TDT for LFP Channels
if isempty(LFPlist)
    disp('No LFP Channel detected...')
else
    
    
    
    for LFPchan = 1:size(LFPlist,1)
        LFP = eval(cell2mat(LFPlist(LFPchan)));
        LFPname = cell2mat(LFPlist(LFPchan));
        
        %find RF of corresponding single unit
        newname = ['DSP' LFPname(end-1:end) 'a'];
        RF = RFs.(str2mat(DSPlist(strmatch(newname,DSPlist,'exact'))));
        
        
        if isempty(RF)
            disp('Empty LFP RF...moving on...')
            continue
        end
        
        antiRF = mod((RF+4),8);
        
        
        in_correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out_correct = find(Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        in_incorrect = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,antiRF));
        out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(SaccDir_,RF));
        
        %abort if there any condition has no trials
        if (isempty(in_correct) || isempty(out_correct) || isempty(in_incorrect) || isempty(out_incorrect))
            disp('At least one condition has no trials...moving on...')
            continue
        end
        
        
        LFP = filtSig(LFP,40,'lowpass');
        
        %remove clipped trials
        LFP = fixClipped(LFP);
        
        %baseline correct
        LFP = baseline_correct(LFP,[400 500]);
        
        LFP_in_correct = nanmean(LFP(in_correct,:));
        LFP_out_correct = nanmean(LFP(out_correct,:));
        LFP_in_incorrect = nanmean(LFP(in_incorrect,:));
        LFP_out_incorrect = nanmean(LFP(out_incorrect,:));
        
        n.([cell2mat(LFPlist(LFPchan)) '_correct']).in = length(in_correct);
        n.([cell2mat(LFPlist(LFPchan)) '_correct']).out = length(out_correct);
        n.([cell2mat(LFPlist(LFPchan)) '_errors']).in = length(in_incorrect);
        n.([cell2mat(LFPlist(LFPchan)) '_errors']).out = length(out_incorrect);
        
        %keep track of waveforms
        wf.([cell2mat(LFPlist(LFPchan)) '_correct']).in = LFP_in_correct;
        wf.([cell2mat(LFPlist(LFPchan)) '_correct']).out = LFP_out_correct;
        wf.([cell2mat(LFPlist(LFPchan)) '_errors']).in = LFP_in_incorrect;
        wf.([cell2mat(LFPlist(LFPchan)) '_errors']).out = LFP_out_incorrect;
        
        
        TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) = getTDT_AD(LFP,in_correct,out_correct);
        
        %check valence of target in vs target out activity at TDT (1 ==
        %Tin MORE POSITIVE
        
        try
            if LFP_in_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500) > LFP_out_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500)
                valence.([cell2mat(LFPlist(LFPchan)) '_correct']) = '1';
            elseif LFP_in_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500)  < LFP_out_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500)
                valence.([cell2mat(LFPlist(LFPchan)) '_correct']) = '-1';
            end
        catch
            valence.([cell2mat(LFPlist(LFPchan)) '_correct']) = NaN;
        end
        
        TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) = getTDT_AD(LFP,in_incorrect,out_incorrect);
        
        %check valence of target in vs target out activity at TDT (1 ==
        %Tin greater
        try
            if LFP_in_incorrect(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500) > LFP_out_incorrect(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500)
                valence.([cell2mat(LFPlist(LFPchan)) '_errors']) = '1';
            elseif LFP_in_incorrect(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500) < LFP_out_incorrect(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500)
                valence.([cell2mat(LFPlist(LFPchan)) '_errors']) = '-1';
            end
        catch
            valence.([cell2mat(LFPlist(LFPchan)) '_errors']) = NaN;
        end
        
        
        subplot(maty,matx,plotnum)
        plot(-500:2500,LFP_in_correct,'b',-500:2500,LFP_out_correct,'--b',-500:2500,LFP_in_incorrect,'r',-500:2500,LFP_out_incorrect,'--r')
        fon
        axis ij
        xlim([-100 500])
        
        vline(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']),'b')
        vline(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']),'r')
        
        title(cell2mat(LFPlist(LFPchan)))
        
        plotnum = plotnum + 1;
    end
    clear LFP* RF antiRF
end
%==========================================================






%=============================================================
% n2pc for EEG Channels
if isempty(EEGlist)
    disp('No EEG Channel detected...')
else
    
    OL = AD03;
    OR = AD02;
    
    %lowpass filter @ 40 Hz
    
    OL = filtSig(OL,40,'lowpass');
    OR = filtSig(OR,40,'lowpass');
    
    
    contraCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL = find(~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR = find(~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    contraErrorsOL = find(~isnan(OL(:,1)) & ismember(SaccDir_,[3 4 5]) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiErrorsOL = find(~isnan(OL(:,1)) & ismember(SaccDir_,[7 0 1]) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraErrorsOR = find(~isnan(OR(:,1)) & ismember(SaccDir_,[7 0 1]) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiErrorsOR = find(~isnan(OR(:,1)) & ismember(SaccDir_,[3 4 5]) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    OLcontra_correct = OL(contraCorrectOL,:);
    OLipsi_correct = OL(ipsiCorrectOL,:);
    ORcontra_correct = OR(contraCorrectOR,:);
    ORipsi_correct = OR(ipsiCorrectOR,:);
    
    OLcontra_errors = OL(contraErrorsOL,:);
    OLipsi_errors = OL(ipsiErrorsOL,:);
    ORcontra_errors = OR(contraErrorsOR,:);
    ORipsi_errors = OR(ipsiErrorsOR,:);
    
    n.OL_correct.contra = length(contraCorrectOL);
    n.OL_correct.ipsi = length(ipsiCorrectOL);
    n.OL_errors.contra = length(contraErrorsOL);
    n.OL_errors.ipsi = length(ipsiErrorsOL);
    
    n.OR_correct.contra = length(contraCorrectOR);
    n.OR_correct.ipsi = length(ipsiCorrectOR);
    n.OR_errors.contra = length(contraErrorsOR);
    n.OR_errors.ipsi = length(ipsiErrorsOR);
    
    %baseline correct
    OLcontra_correct = baseline_correct(OLcontra_correct,[400 500]);
    OLipsi_correct = baseline_correct(OLipsi_correct,[400 500]);
    ORcontra_correct = baseline_correct(ORcontra_correct,[400 500]);
    ORipsi_correct = baseline_correct(ORipsi_correct,[400 500]);
    
    OLcontra_errors = baseline_correct(OLcontra_errors,[400 500]);
    OLipsi_errors = baseline_correct(OLipsi_errors,[400 500]);
    ORcontra_errors = baseline_correct(ORcontra_errors,[400 500]);
    ORipsi_errors = baseline_correct(ORipsi_errors,[400 500]);
    
    %find onset time but look between 100 after Target onset and 500 ms for
    %speed
    for time = 600:1000%size(AD02,2);
        [WilcoxonOL_p_correct(time) WilcoxonOL_h_correct(time)] = ranksum(OLcontra_correct(:,time),OLipsi_correct(:,time),'alpha',.01);
        [WilcoxonOR_p_correct(time) WilcoxonOR_h_correct(time)] = ranksum(ORcontra_correct(:,time),ORipsi_correct(:,time),'alpha',.01);
        [WilcoxonOL_p_errors(time) WilcoxonOL_h_errors(time)] = ranksum(OLcontra_errors(:,time),OLipsi_errors(:,time),'alpha',.01);
        [WilcoxonOR_p_errors(time) WilcoxonOR_h_errors(time)] = ranksum(ORcontra_errors(:,time),ORipsi_errors(:,time),'alpha',.01);
    end
    
    %find miminum time of 10 consecutive significant bins; begin looking 100 ms
    %after target onset (which is column 600)
    N2pc_TDT_OL_correct = min(findRuns(WilcoxonOL_h_correct,10)) - 500;
    N2pc_TDT_OR_correct = min(findRuns(WilcoxonOR_h_correct,10)) - 500;
    
    N2pc_TDT_OL_errors = min(findRuns(WilcoxonOL_h_errors,10)) - 500;
    N2pc_TDT_OR_errors = min(findRuns(WilcoxonOR_h_errors,10)) - 500;
    
    
    
    %keep track of waveforms
    wf.OL_correct.contra = nanmean(OLcontra_correct);
    wf.OL_correct.ipsi = nanmean(OLipsi_correct);
    wf.OR_correct.contra = nanmean(ORcontra_correct);
    wf.OR_correct.ipsi = nanmean(ORipsi_correct);
    
    wf.OL_errors.contra = nanmean(OLcontra_errors);
    wf.OL_errors.ipsi = nanmean(OLipsi_errors);
    wf.OR_errors.contra = nanmean(ORcontra_errors);
    wf.OR_errors.ipsi = nanmean(ORipsi_errors);
    
    
    %keep track of RTs
    %     RTs.correct_Tin = SRT(find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50),1);
    %     RTs.errors_Din = SRT(find(ismember(SaccDir_,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50),1);
    
    TDT.OL_correct = N2pc_TDT_OL_correct;
    TDT.OR_correct = N2pc_TDT_OR_correct;
    TDT.OL_errors = N2pc_TDT_OL_errors;
    TDT.OR_errors = N2pc_TDT_OR_errors;
    
    %check valence of target in vs target out activity at TDT (1 ==
    %CONTRA MORE POSITIVE
    try
        if wf.OL_correct.contra(TDT.OL_correct + 500) > wf.OL_correct.ipsi(TDT.OL_correct + 500)
            valence.OL_correct = '1';
        elseif wf.OL_correct.contra(TDT.OL_correct + 500) < wf.OL_correct.ipsi(TDT.OL_correct + 500)
            valence.OL_correct = '-1';
        else valence.OL_correct = NaN;
        end
    catch
        valence.OL_correct = NaN;
    end
    
    try
        if wf.OR_correct.contra(TDT.OR_correct + 500) > wf.OR_correct.ipsi(TDT.OR_correct + 500)
            valence.OR_correct = '1';
        elseif wf.OR_correct.contra(TDT.OR_correct + 500) < wf.OR_correct.ipsi(TDT.OR_correct + 500)
            valence.OR_correct = '-1';
        else
            valence.OR_correct = NaN;
        end
    catch
        valence.OR_correct = NaN;
    end
    
    try
        if wf.OL_errors.contra(TDT.OL_errors + 500) > wf.OL_errors.ipsi(TDT.OL_errors + 500)
            valence.OL_errors = '1';
        elseif wf.OL_errors.contra(TDT.OL_errors + 500) < wf.OL_errors.ipsi(TDT.OL_errors + 500)
            valence.OL_errors = '-1';
        else
            valence.OL_errors = NaN;
        end
    catch
        valence.OL_errors = NaN;
    end
    
    try
        if wf.OR_errors.contra(TDT.OR_errors + 500) > wf.OR_errors.ipsi(TDT.OR_errors + 500)
            valence.OR_errors = '1';
        elseif wf.OR_errors.contra(TDT.OR_errors + 500) < wf.OR_errors.ipsi(TDT.OR_errors + 500)
            valence.OR_errors = '-1';
        else
            valence.OR_errors = NaN;
        end
    catch
        valence.OR_errors = NaN;
    end
    
    
    
    
    subplot(maty,matx,plotnum)
    plot(-500:2500,wf.OL_correct.contra,'b',-500:2500,wf.OL_correct.ipsi,'--b',-500:2500,wf.OL_errors.contra,'r',-500:2500,wf.OL_errors.ipsi,'--r')
    fon
    axis ij
    xlim([-100 500])
    
    vline(TDT.OL_correct,'b')
    vline(TDT.OL_errors,'r')
    
    title('OL')
    
    
    subplot(maty,matx,plotnum + 1)
    plot(-500:2500,wf.OR_correct.contra,'b',-500:2500,wf.OR_correct.ipsi,'--b',-500:2500,wf.OR_errors.contra,'r',-500:2500,wf.OR_errors.ipsi,'--r')
    fon
    axis ij
    xlim([-100 500])
    
    vline(TDT.OR_correct,'b')
    vline(TDT.OR_errors,'r')
    
    title('OR')
    
    plotnum = plotnum + 2;
end
clear OL* OR* n2pc* RF antiRF

%==========================================================

outdir = '/volumes/Dump/Analyses/Errors/PDF/';
if PDFflag == 1
    eval(['print -dpdf ',outdir,file,'.pdf']);
end

close(f);

%outdir = '/scratch/heitzrp/Output/TDT/';
outdir = '/volumes/Dump/Analyses/Errors/';

if saveFlag == 1
    if exist('TDT')
        eval(['save(' q outdir,file,'_TDT.mat' qcq 'n' qcq 'wf' qcq 'TDT' qcq 'RTs' qcq 'valence' qcq '-mat' q ')'])
    else
        disp('Calculation of TDT Failed...not saving...')
        return
    end
end