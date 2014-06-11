%analysis routine for TDT correct vs errors in spike and AD channels
%RPH
%4/22/09

function [] = Search_Errors(file)
f = figure;
q = '''';
c = ',';
qcq = [q c q];
PDFflag = 0;
saveFlag = 1;

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
        
        %keep track of waveforms
        wf.(cell2mat(DSPlist(DSPchan))).in_correct = SDF_in_correct;
        wf.(cell2mat(DSPlist(DSPchan))).out_correct = SDF_out_correct;
        wf.(cell2mat(DSPlist(DSPchan))).in_incorrect = SDF_in_incorrect;
        wf.(cell2mat(DSPlist(DSPchan))).out_incorrect = SDF_out_incorrect;
        
        %keep track of RTs
        RTs.correct = SRT(find(Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1);
        RTs.errors = SRT(find(Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1);
        
        
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
            if SDF_in_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100) > SDF_out_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100)
                valence.([cell2mat(DSPlist(DSPchan)) '_errors']) = '1';
            elseif SDF_in_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100) < SDF_out_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100)
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
        
        
        %lowpass filter @ 40 Hz
        for trl = 1:size(LFP,1)
            LFP(trl,1:3001) = filtSig(LFP(trl,:),40,'lowpass');
        end
        
        %remove clipped trials
        LFP = fixClipped(LFP);
        
        %baseline correct
        LFP = baseline_correct(LFP,[400 500]);
        
        LFP_in_correct = nanmean(LFP(in_correct,:));
        LFP_out_correct = nanmean(LFP(out_correct,:));
        LFP_in_incorrect = nanmean(LFP(in_incorrect,:));
        LFP_out_incorrect = nanmean(LFP(out_incorrect,:));
        
        %keep track of waveforms
        wf.(cell2mat(LFPlist(LFPchan))).in_correct = LFP_in_correct;
        wf.(cell2mat(LFPlist(LFPchan))).out_correct = LFP_out_correct;
        wf.(cell2mat(LFPlist(LFPchan))).in_incorrect = LFP_in_incorrect;
        wf.(cell2mat(LFPlist(LFPchan))).out_incorrect = LFP_out_incorrect;
        
%         %keep track of RTs
%         RTs.correct_Tin = SRT(find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50),1);
%         RTs.errors_Din = SRT(find(ismember(SaccDir_,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50),1);
%         
        
        TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) = getTDT_AD(LFP,in_correct,out_correct);
        
        %check valence of target in vs target out activity at TDT (1 ==
        %Tin MORE POSITIVE
        
        try
            if LFP_in_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct'])) + 500 > LFP_out_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500)
                valence.([cell2mat(LFPlist(LFPchan)) '_correct']) = '1';
            elseif LFP_in_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct'])) + 500 < LFP_out_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500)
                valence.([cell2mat(LFPlist(LFPchan)) '_correct']) = '-1';
            end
        catch
            valence.([cell2mat(LFPlist(LFPchan)) '_correct']) = NaN;
        end
        
        TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) = getTDT_AD(LFP,in_incorrect,out_incorrect);
        
        %check valence of target in vs target out activity at TDT (1 ==
        %Tin greater
        try
            if LFP_in_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500) > LFP_out_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500)
                valence.([cell2mat(LFPlist(LFPchan)) '_errors']) = '1';
            elseif LFP_in_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500) < LFP_out_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500)
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
% TDT for EEG Channels (just AD02 and AD03 because both monkeys have
% them)
if isempty(EEGlist)
    disp('No EEG Channel detected...')
else
    
    
    
    for EEGchan = 1:size(EEGlist,1)
        EEG = eval(cell2mat(EEGlist(EEGchan)));
        
        if Hemi.(cell2mat(EEGlist(EEGchan))) == 'L'
            RF = [7 0 1];
        elseif Hemi.(cell2mat(EEGlist(EEGchan))) == 'R'
            RF = [3 4 5];
        end
        
        
        if isempty(RF)
            disp('Empty EEG RF...moving on...')
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
        
        
        
        
        %lowpass filter @ 40 Hz
        for trl = 1:size(EEG,1)
            EEG(trl,1:3001) = filtSig(EEG(trl,:),40,'lowpass');
        end
        
        %truncate 20 ms before saccade
        %%%% EEG = truncateAD_targ(EEG,SRT);
        
        %remove clipped trials
        %%%% EEG = fixClipped(EEG);
        
        %baseline_correct
        EEG = baseline_correct(EEG,[400 500]);
        
        EEG_in_correct = nanmean(EEG(in_correct,:));
        EEG_out_correct = nanmean(EEG(out_correct,:));
        EEG_in_incorrect = nanmean(EEG(in_incorrect,:));
        EEG_out_incorrect = nanmean(EEG(out_incorrect,:));
        
        %keep track of waveforms
        wf.(cell2mat(EEGlist(EEGchan))).in_correct = EEG_in_correct;
        wf.(cell2mat(EEGlist(EEGchan))).out_correct = EEG_out_correct;
        wf.(cell2mat(EEGlist(EEGchan))).in_incorrect = EEG_in_incorrect;
        wf.(cell2mat(EEGlist(EEGchan))).out_incorrect = EEG_out_incorrect;
        
        %keep track of RTs
%         RTs.correct_Tin = SRT(find(Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50),1);
%         RTs.errors_Din = SRT(find(ismember(SaccDir_,RF) & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50),1);
%         
        
        TDT.([cell2mat(EEGlist(EEGchan)) '_correct']) = getTDT_AD(EEG,in_correct,out_correct);
        
        %check valence of target in vs target out activity at TDT (1 ==
        %Tin MORE POSITIVE
        try
            if EEG_in_correct(TDT.([cell2mat(EEGlist(EEGchan)) '_correct'])) + 500 > EEG_out_correct(TDT.([cell2mat(EEGlist(EEGchan)) '_correct']) + 500)
                valence.([cell2mat(EEGlist(EEGchan)) '_correct']) = '1';
            elseif EEG_in_correct(TDT.([cell2mat(EEGlist(EEGchan)) '_correct'])) + 500 < EEG_out_correct(TDT.([cell2mat(EEGlist(EEGchan)) '_correct']) + 500)
                valence.([cell2mat(EEGlist(EEGchan)) '_correct']) = '-1';
            end
        catch
            valence.([cell2mat(EEGlist(EEGchan)) '_correct']) = NaN;
        end
        
        TDT.([cell2mat(EEGlist(EEGchan)) '_errors']) = getTDT_AD(EEG,in_incorrect,out_incorrect);
        
        %check valence of target in vs target out activity at TDT (1 ==
        %Tin greater
        try
            if EEG_in_correct(TDT.([cell2mat(EEGlist(EEGchan)) '_errors'])) + 500 > EEG_out_correct(TDT.([cell2mat(EEGlist(EEGchan)) '_errors']) + 500)
                valence.([cell2mat(EEGlist(EEGchan)) '_errors']) = '1';
            elseif EEG_in_correct(TDT.([cell2mat(EEGlist(EEGchan)) '_errors'])) + 500 < EEG_out_correct(TDT.([cell2mat(EEGlist(EEGchan)) '_errors']) + 500)
                valence.([cell2mat(EEGlist(EEGchan)) '_errors']) = '-1';
            end
        catch
            valence.([cell2mat(EEGlist(EEGchan)) '_errors']) = NaN;
        end
        
        
        subplot(maty,matx,plotnum)
        plot(-500:2500,EEG_in_correct,'b',-500:2500,EEG_out_correct,'--b',-500:2500,EEG_in_incorrect,'r',-500:2500,EEG_out_incorrect,'--r')
        fon
        axis ij
        xlim([-100 500])
        
        vline(TDT.([cell2mat(EEGlist(EEGchan)) '_correct']),'b')
        vline(TDT.([cell2mat(EEGlist(EEGchan)) '_errors']),'r')
        
        title(cell2mat(EEGlist(EEGchan)))
        
        plotnum = plotnum + 1;
    end
    clear EEG* RF antiRF
end
%==========================================================

outdir = '/volumes/Dump/Analyses/Errors/PDF/';
if PDFflag == 1
    eval(['print -dpdf ',outdir,file,'.pdf']);
end

close(f);

outdir = '/volumes/Dump/Analyses/Errors/';

if saveFlag == 1
    if exist('TDT')
        eval(['save(' q outdir,file,'_TDT.mat' qcq 'wf' qcq 'TDT' qcq 'RTs' qcq 'valence' qcq '-mat' q ')'])
    else
        disp('Calculation of TDT Failed...not saving...')
        return
    end
end