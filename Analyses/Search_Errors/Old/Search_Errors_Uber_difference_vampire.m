%analysis routine for TDT correct vs errors in all signals

% This version computes the TDT for all signals using the 30 Hz
% lowpass-filtered difference score.  I calculate the time where 50% of the
% max - min or min - max value in window 100:300 occurs.

% Only non-truncated signals are used
% I do sub-sample correct trials 100 x
%
%
%
% P2Pc: same as for LFP, but use only hemifield.
%RPH
%6/15/09
function [] = Search_Errors_Uber_difference_vampire(file)
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/ALLDATA/')


q = '''';
c = ',';
qcq = [q c q];
PDFflag = 1;
saveFlag = 1;
% path(path,'//scratch/heitzrp/')
% path(path,'//scratch/heitzrp/Data_all/')

try
    ChanStruct = loadChan(file,'DSP');
    DSPlist = fieldnames(ChanStruct);
    decodeChanStruct
catch
    DSPlist = [];
    disp('ERROR IN DSP CHANNELS....SKIPPING')
end


try
    ChanStruct = loadChan(file,'LFP');
    LFPlist = fieldnames(ChanStruct);
    decodeChanStruct
catch
    LFPlist = [];
    disp('ERROR IN LFP CHANNELS ....SKIPPING')
end

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
        else
            
            antiRF = mod((RF+4),8);
            
            %find trial #s and randomize them for the subsampling below
            in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            in_incorrect = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,antiRF));
            out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(SaccDir_,RF));
            
            
            
            %abort if any condition has no trials
            if findMin(length(in_correct),length(out_correct),length(in_incorrect),length(out_incorrect)) < 10
                disp('At least one condition has too few trials')
                
            else
                
                SDF = sSDF(Spike,Target_(:,1),[-100 500]);

                SDF_in_incorrect = nanmean(SDF(in_incorrect,:));
                SDF_out_incorrect = nanmean(SDF(out_incorrect,:));
                
                n.(cell2mat(DSPlist(DSPchan))).errors.in = length(in_incorrect);
                n.(cell2mat(DSPlist(DSPchan))).errors.out = length(out_incorrect);
                
                wf.(cell2mat(DSPlist(DSPchan))).errors.in = SDF_in_incorrect;
                wf.(cell2mat(DSPlist(DSPchan))).errors.out = SDF_out_incorrect;
                wf.(cell2mat(DSPlist(DSPchan))).errors.diff = SDF_in_incorrect - SDF_out_incorrect;
                
                %find error trial TDT
                dif = SDF_out_incorrect - SDF_in_incorrect;
                dif = filtSig(dif,30,'lowpass');
                [minval min_ix] = min(dif(200:601));
                [maxval max_ix] = max(dif(200:601));
                
                if (max_ix > min_ix)
                TDT = min_ix + min(find(dif((200 + min_ix):(200+max_ix)) > (minval + range([minval maxval]) / 2))) + 100;
                elseif (max_ix < min_ix)
                TDT = min_ix + min(find(dif((200 + max_ix):(200+min_ix)) > (minval + range([minval maxval]) / 2))) + 100;
                end
                %=====================================================
                % Find TDT for correct trials after sub-sampling
                
                numSamps = 100;
                
                %keep track of original vector of trial numbers
                in_correct_all = in_correct;
                out_correct_all = out_correct;
                for samp = 1:numSamps
                    %re-randomize
                    in_correct = shake(in_correct_all);
                    out_correct = shake(out_correct_all);
                    
                    %sub-sample to length of equivalent error signals
                    %check to make sure there are fewer correct trials than
                    %incorrect; if not true, then just keep resampling same
                    %correct trials
                    
                    if length(in_correct) > length(in_incorrect)
                        in_correct = in_correct(randperm(length(in_incorrect)));
                    end
                    
                    if length(out_correct) > length(out_incorrect)
                        out_correct = out_correct(randperm(length(out_incorrect)));
                    end
                    
                    
                    %calculate TDT here rather than with function because truncated signals
                    for time = 200:size(SDF,2) %200 == 100 ms post stimulus onset
                        %remove any nan values for current time
                        clean_in = SDF(in_correct,time);
                        clean_in(find(isnan(clean_in))) = [];
                        
                        clean_out = SDF(out_correct,time);
                        clean_out(find(isnan(clean_out))) = [];
                        
                        if ~isempty(clean_in) & ~isempty(clean_out)
                            [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',.05,5);
                        else
                            p(time) = NaN;
                            h(time) = 0;
                        end
                        
                    end
                    
                    if ~isempty(findRuns(h,5))
                        TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) = min(findRuns(h,5)) - 100;
                    else
                        TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) = NaN;
                    end
                    
                    if TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) > nanmean(RTs.correct)
                        TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) = NaN;
                    end
                    
                    
                    
                    wf.(cell2mat(DSPlist(DSPchan))).correct.in(samp,1:601) = nanmean(SDF(in_correct,:));
                    wf.(cell2mat(DSPlist(DSPchan))).correct.out(samp,1:601) = nanmean(SDF(out_correct,:));
                end
                %
                
                
                if PDFflag == 1
                    f  = figure;
                    subplot(1,2,1)
                    plot(-100:500,nanmean(wf.(cell2mat(DSPlist(DSPchan))).correct.in),'b',-100:500,nanmean(wf.(cell2mat(DSPlist(DSPchan))).correct.out),'--b')
                    fon
                    xlim([-50 300])
                    %             ylim([mn mx])
                    
                    vline(nanmean(TDT.(cell2mat(DSPlist(DSPchan))).correct),'b')
                    
                    
                    title([cell2mat(DSPlist(DSPchan)) ' Correct'])
                    
                    
                    subplot(1,2,2)
                    plot(-100:500,SDF_in_incorrect,'r',-100:500,SDF_out_incorrect,'--r')
                    fon
                    xlim([-50 300])
                    %             ylim([mn mx])
                    
                    
                    vline(TDT.(cell2mat(DSPlist(DSPchan))).errors,'r')
                    
                    title([cell2mat(DSPlist(DSPchan)) ' Errors'])
                    
                    
                    eval(['print -dpdf //scratch/heitzrp/Output/Search_Errors/PDF/' file '_' DSPlist{DSPchan} '.pdf'])
                    %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_' DSPlist{DSPchan} '.pdf'])
                    
                    
                    close(f)
                end
            end
        end
        
    end
    clear Spike SDF* RF antiRF
end
%==========================================================











%=============================================================
% TDT for LFP Channels w/ neuron RF
if isempty(LFPlist)
    disp('No LFP Channel detected...')
else
    
    
    
    for LFPchan = 1:size(LFPlist,1)
        LFP = eval(cell2mat(LFPlist(LFPchan)));
        LFPname = cell2mat(LFPlist(LFPchan));
        
        %find RF of corresponding first single unit
        newname = ['DSP' LFPname(end-1:end) 'a'];
        RF = RFs.(str2mat(DSPlist(strmatch(newname,DSPlist,'exact'))));
        
        
        if isempty(RF)
            disp('Empty LFP RF...moving on...')
        else
            
            antiRF = mod((RF+4),8);
            
            
            in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            in_incorrect = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,antiRF));
            out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(SaccDir_,RF));
            
            
            
            
            %remove clipped trials
            LFP = fixClipped(LFP,[500 900]);
            
            %baseline correct
            LFP = baseline_correct(LFP,[400 500]);
            
            %truncate 20 ms before saccade
            LFP_trunc = truncateAD_targ(LFP,SRT);
            
            
            LFP_in_incorrect = nanmean(LFP(in_incorrect,:));
            LFP_out_incorrect = nanmean(LFP(out_incorrect,:));
            
            
            n.(cell2mat(LFPlist(LFPchan))).RF.errors.in = length(in_incorrect);
            n.(cell2mat(LFPlist(LFPchan))).RF.errors.out = length(out_incorrect);
            
            %keep track of waveforms
            
            wf.(cell2mat(LFPlist(LFPchan))).RF.errors.in = LFP_in_incorrect;
            wf.(cell2mat(LFPlist(LFPchan))).RF.errors.out = LFP_out_incorrect;
            
            
            %             TDT.(cell2mat(LFPlist(LFPchan))).correct = getTDT_AD(LFP,in_correct,out_correct);
            %=======================================
            % Check to make sure that truncated correct trial TDT
            % equivalent to non-truncated TDT
            tempTDT_trunc = getTDT_AD(LFP_trunc,in_correct,out_correct,0,.05,5);
            tempTDT_notrunc = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
            
            if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
                disp('At least one correct trial signal has NaN TDT')
                
            elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
                disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
                
            else
                
                
                
                TDT.(cell2mat(LFPlist(LFPchan))).RF.errors = getTDT_AD(LFP,in_incorrect,out_incorrect,0,.05,5);
                
                if TDT.(cell2mat(LFPlist(LFPchan))).RF.errors > nanmean(RTs.errors);
                    disp('TDT greater than RT')
                    TDT.(cell2mat(LFPlist(LFPchan))).RF.errors = NaN;
                end
                
                if isempty(TDT.(cell2mat(LFPlist(LFPchan))).RF.errors)
                    TDT.(cell2mat(LFPlist(LFPchan))).RF.errors = NaN;
                end
                
                
                
                %for non-subsampled correct trial TDT
                TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_nosub = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
                
                if TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_nosub > nanmean(RTs.correct)
                    TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_nosub = NaN;
                end
                
                %=======================================
                % Repeated-sampling correct trial TDT
                
                numSamps = 100;
                
                %keep track of original vector of trial numbers
                in_correct_all = in_correct;
                out_correct_all = out_correct;
                for samp = 1:numSamps
                    %re-randomize
                    in_correct = shake(in_correct_all);
                    out_correct = shake(out_correct_all);
                    
                    %sub-sample to length of equivalent error signals
                    
                    if length(in_correct) > length(in_incorrect)
                        in_correct = in_correct(randperm(length(in_incorrect)));
                    end
                    
                    if length(out_correct) > length(out_incorrect)
                        out_correct = out_correct(randperm(length(out_incorrect)));
                    end
                    
                    TDT.(cell2mat(LFPlist(LFPchan))).RF.correct(samp,1) = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
                    
                    if TDT.(cell2mat(LFPlist(LFPchan))).RF.correct(samp,1) > nanmean(RTs.correct)
                        TDT.(cell2mat(LFPlist(LFPchan))).RF.correct(samp,1) = NaN;
                    end
                    
                    wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in(samp,1:3001) = nanmean(LFP(in_correct,:));
                    wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out(samp,1:3001) = nanmean(LFP(out_correct,:));
                end
                
                %
                if PDFflag == 1
                    f = figure;
                    subplot(1,2,1)
                    plot(-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in),'b',-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out),'--b')
                    fon
                    axis ij
                    xlim([-50 300])
                    
                    
                    vline(nanmean(TDT.(cell2mat(LFPlist(LFPchan))).RF.correct),'b')
                    
                    
                    title([cell2mat(LFPlist(LFPchan)) ' Correct'])
                    
                    
                    subplot(1,2,2)
                    plot(-500:2500,LFP_in_incorrect,'r',-500:2500,LFP_out_incorrect,'--r')
                    fon
                    axis ij
                    xlim([-50 300])
                    
                    vline(TDT.(cell2mat(LFPlist(LFPchan))).RF.errors,'r')
                    
                    title([cell2mat(LFPlist(LFPchan)) ' Errors'])
                    
                    eval(['print -dpdf //scratch/heitzrp/Output/Search_Errors/PDF/' file '_RF_' LFPlist{LFPchan} '.pdf'])
                    %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_RF_' LFPlist{LFPchan} '.pdf'])
                    close(f)
                end
            end
        end
        
    end
    clear RF antiRF
end
%==========================================================










%=============================================================
% TDT for LFP Channels w/ Hemifield RF
if isempty(LFPlist)
    disp('No LFP Channel detected...')
else
    
    
    
    for LFPchan = 1:size(LFPlist,1)
        LFP = eval(cell2mat(LFPlist(LFPchan)));
        LFPname = cell2mat(LFPlist(LFPchan));
        
        
        if Hemi.(cell2mat(LFPlist(LFPchan))) == 'L'
            RF = [7 0 1];
        elseif Hemi.(cell2mat(LFPlist(LFPchan))) == 'R'
            RF = [3 4 5];
        end
        
        antiRF = mod((RF+4),8);
        
        
        in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        in_incorrect = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,antiRF));
        out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(SaccDir_,RF));
        
        
        
        
        %remove clipped trials
        LFP = fixClipped(LFP,[500 900]);
        
        %baseline correct
        LFP = baseline_correct(LFP,[400 500]);
        
        %truncate 20 ms before saccade
        LFP_trunc = truncateAD_targ(LFP,SRT);
        
        
        
        
        LFP_in_incorrect = nanmean(LFP(in_incorrect,:));
        LFP_out_incorrect = nanmean(LFP(out_incorrect,:));
        
        
        n.(cell2mat(LFPlist(LFPchan))).Hemi.errors.in = length(in_incorrect);
        n.(cell2mat(LFPlist(LFPchan))).Hemi.errors.out = length(out_incorrect);
        
        %keep track of waveforms
        
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.errors.in = LFP_in_incorrect;
        wf.(cell2mat(LFPlist(LFPchan))).Hemi.errors.out = LFP_out_incorrect;
        
        
        
        %=======================================
        % Check to make sure that truncated correct trial TDT
        % equivalent to non-truncated TDT
        tempTDT_trunc = getTDT_AD(LFP_trunc,in_correct,out_correct,0,.05,5);
        tempTDT_notrunc = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
        
        if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
            disp('At least one correct trial signal has NaN TDT')
        elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
            disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
        else
            
            
            TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_nosub = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
            
            if TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_nosub > nanmean(RTs.correct)
                TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_nosub = NaN;
            end
            
            
            TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors = getTDT_AD(LFP,in_incorrect,out_incorrect,0,.05,5);
            
            if TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors > nanmean(RTs.errors)
                disp('TDT later than RT')
                TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors = NaN;
            end
            
            %=======================================
            % Repeated-sampling correct trial TDT
            
            numSamps = 100;
            
            %keep track of original vector of trial numbers
            in_correct_all = in_correct;
            out_correct_all = out_correct;
            for samp = 1:numSamps
                %re-randomize
                in_correct = shake(in_correct_all);
                out_correct = shake(out_correct_all);
                
                %sub-sample to length of equivalent error signals
                if length(in_correct) > length(in_incorrect)
                    in_correct = in_correct(randperm(length(in_incorrect)));
                end
                
                if length(out_correct) > length(out_incorrect)
                    out_correct = out_correct(randperm(length(out_incorrect)));
                end
                
                TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct(samp,1) = getTDT_AD(LFP,in_correct,out_correct,0,.05,5);
                
                if TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct(samp,1) > nanmean(RTs.correct)
                    TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct(samp,1) = NaN;
                end
                
                wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in(samp,1:3001) = nanmean(LFP(in_correct,:));
                wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out(samp,1:3001) = nanmean(LFP(out_correct,:));
            end
            
            %
            if PDFflag == 1
                f = figure;
                subplot(1,2,1)
                plot(-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in),'b',-500:2500,nanmean(wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out),'--b')
                fon
                axis ij
                xlim([-50 300])
                
                vline(nanmean(TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct),'b')
                
                
                title([cell2mat(LFPlist(LFPchan)) ' Correct'])
                
                subplot(1,2,2)
                plot(-500:2500,LFP_in_incorrect,'r',-500:2500,LFP_out_incorrect,'--r')
                fon
                axis ij
                xlim([-50 300])
                
                
                vline(TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors,'r')
                
                title([cell2mat(LFPlist(LFPchan)) ' Errors'])
                
                eval(['print -dpdf //scratch/heitzrp/Output/Search_Errors/PDF/' file '_Hemi_' LFPlist{LFPchan} '.pdf'])
                %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_Hemi_' LFPlist{LFPchan} '.pdf'])
                
                close(f)
            end
        end
        
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
    
    
    %remove saturated trials, considering only 0:400 ms post-target
    OL = fixClipped(OL,[500 900]);
    OR = fixClipped(OR,[500 900]);
    
    %truncate 20 ms before saccade
    
    %baseline correct
    OL = baseline_correct(OL,[400 500]);
    OR = baseline_correct(OR,[400 500]);
    
    
    
    
    
    
    
    %============================================
    % OL
    
    contraCorrectOL = find(Target_(:,2) ~= 255 & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOL = find(Target_(:,2) ~= 255 & ~isnan(OL(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraErrorsOL = find(~isnan(OL(:,1)) & ismember(SaccDir_,[3 4 5]) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiErrorsOL = find(~isnan(OL(:,1)) & ismember(SaccDir_,[7 0 1]) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    n.OL_errors.contra = length(contraErrorsOL);
    n.OL_errors.ipsi = length(ipsiErrorsOL);
    
    
    
    OL_trunc = truncateAD_targ(OL,SRT);
    
    tempTDT_notrunc = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL,0,.05,5);
    tempTDT_trunc = getTDT_AD(OL_trunc,contraCorrectOL,ipsiCorrectOL,0,.05,5);
    
    
    if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
        disp('At least one correct trial signal has NaN TDT')
        
    elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
        disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
        
    else
        
        %non sub-sampled correct trial TDT
        TDT.OL.correct_nosub = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL,0,.05,5);
        
        if TDT.OL.correct_nosub > nanmean(RTs.correct)
            TDT.OL.correct_nosub = NaN;
        end
        
        
        %pass tests, so calculate error TDT
        TDT.OL.errors = getTDT_AD(OL,contraErrorsOL,ipsiErrorsOL,0,.05,5);
        
        if TDT.OL.errors > nanmean(RTs.errors)
            disp('Error TDT later than RT')
            TDT.OL.errors = NaN;
        end
        
        wf.OL.errors.contra = nanmean(OL(contraErrorsOL,:));
        wf.OL.errors.ipsi = nanmean(OL(ipsiErrorsOL,:));
        
        %=======================================
        % Repeated-sampling correct trial TDT
        
        numSamps = 100;
        
        %keep track of original vector of trial numbers
        contra_correct_all = contraCorrectOL;
        ipsi_correct_all = ipsiCorrectOL;
        contra_errors_all = contraErrorsOL;
        ipsi_errors_all = ipsiErrorsOL;
        
        
        for samp = 1:numSamps
            %re-randomize
            in_correct = shake(contra_correct_all);
            out_correct = shake(ipsi_correct_all);
            in_incorrect = shake(contra_errors_all);
            out_incorrect = shake(ipsi_errors_all);
            
            
            %sub-sample to length of equivalent error signals
            if length(in_correct) > length(in_incorrect)
                in_correct = in_correct(randperm(length(contraErrorsOL)));
            end
            
            if length(out_correct) > length(out_incorrect)
                out_correct = out_correct(randperm(length(ipsiErrorsOL)));
            end
            
            TDT.OL.correct(samp,1) = getTDT_AD(OL,in_correct,out_correct,0,.05,5);
            
            if TDT.OL.correct(samp,1) > nanmean(RTs.correct)
                TDT.OL.correct(samp,1) = NaN;
            end
            
            wf.OL.correct.contra(samp,1:3001) = nanmean(OL(in_correct,:));
            wf.OL.correct.ipsi(samp,1:3001) = nanmean(OL(out_correct,:));
        end
        
        
        
        
        %
        if PDFflag == 1
            f = figure;
            subplot(1,2,1)
            plot(-500:2500,nanmean(wf.OL.correct.contra),'b',-500:2500,nanmean(wf.OL.correct.ipsi),'--b')
            fon
            axis ij
            xlim([-50 300])
            
            
            vline(nanmean(TDT.OL.correct),'b')
            
            
            title('OL Correct')
            
            subplot(1,2,2)
            
            plot(-500:2500,wf.OL.errors.contra,'r',-500:2500,wf.OL.errors.ipsi,'--r')
            fon
            axis ij
            xlim([-50 300])
            
            
            vline(TDT.OL.errors,'r')
            
            title('OL Errors')
            
            eval(['print -dpdf //scratch/heitzrp/Output/Search_Errors/PDF/' file '_OL.pdf'])
            %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_OL.pdf'])
            
            
            close(f)
        end
    end
    
    
    
    %==============================================
    % OR
    
    contraCorrectOR = find(Target_(:,2) ~= 255 & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiCorrectOR = find(Target_(:,2) ~= 255 & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    contraErrorsOR = find(~isnan(OR(:,1)) & ismember(SaccDir_,[7 0 1]) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    ipsiErrorsOR = find(~isnan(OR(:,1)) & ismember(SaccDir_,[3 4 5]) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
    
    
    n.OR_errors.contra = length(contraErrorsOR);
    n.OR_errors.ipsi = length(ipsiErrorsOR);
    
    
    OR_trunc = truncateAD_targ(OR,SRT);
    
    tempTDT_notrunc = getTDT_AD(OR,contraCorrectOR,ipsiCorrectOR,0,.05,5);
    tempTDT_trunc = getTDT_AD(OR_trunc,contraCorrectOR,ipsiCorrectOR,0,.05,5);
    
    
    if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
        disp('At least one correct trial signal has NaN TDT')
    elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
        disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
    else
        
        TDT.OR.correct_nosub = getTDT_AD(OR,contraCorrectOL,ipsiCorrectOR,0,.05,5);
        
        if TDT.OR.correct_nosub > nanmean(RTs.correct)
            TDT.OR.correct_nosub = NaN;
        end
        
        %pass tests, so calculate error TDT
        TDT.OR.errors = getTDT_AD(OR,contraErrorsOR,ipsiErrorsOR,0,.05,5);
        
        if TDT.OR.errors > nanmean(RTs.errors)
            disp('Error TDT later than RT')
            TDT.OR.errors = NaN;
        end
        
        wf.OR.errors.contra = nanmean(OR(contraErrorsOR,:));
        wf.OR.errors.ipsi = nanmean(OR(ipsiErrorsOR,:));
        
        %=======================================
        % Repeated-sampling correct trial TDT
        
        numSamps = 100;
        
        %keep track of original vector of trial numbers
        contra_correct_all = contraCorrectOR;
        ipsi_correct_all = ipsiCorrectOR;
        contra_errors_all = contraErrorsOR;
        ipsi_errors_all = ipsiErrorsOR;
        
        for samp = 1:numSamps
            %re-randomize
            in_correct = shake(contra_correct_all);
            out_correct = shake(ipsi_correct_all);
            in_incorrect = shake(contra_errors_all);
            out_incorrect = shake(ipsi_errors_all);
            
            
            %sub-sample to length of equivalent error signals
            if length(in_correct) > length(in_incorrect)
                in_correct = in_correct(randperm(length(contraErrorsOR)));
            end
            
            if length(out_correct) > length(out_incorrect)
                out_correct = out_correct(randperm(length(ipsiErrorsOR)));
            end
            
            TDT.OR.correct(samp,1) = getTDT_AD(OR,in_correct,out_correct,0,.05,5);
            
            if TDT.OR.correct(samp,1) > nanmean(RTs.correct)
                TDT.OR.correct(samp,1) = NaN;
            end
            
            wf.OR.correct.contra(samp,1:3001) = nanmean(OL(in_correct,:));
            wf.OR.correct.ipsi(samp,1:3001) = nanmean(OL(out_correct,:));
        end
        
        
        
        
        %
        if PDFflag == 1
            f = figure;
            subplot(1,2,1)
            plot(-500:2500,nanmean(wf.OR.correct.contra),'b',-500:2500,nanmean(wf.OR.correct.ipsi),'--b')
            fon
            axis ij
            xlim([-50 300])
            
            
            vline(nanmean(TDT.OR.correct),'b')
            
            
            title('OR Correct')
            
            subplot(1,2,2)
            plot(-500:2500,wf.OR.errors.contra,'r',-500:2500,wf.OR.errors.ipsi,'--r')
            fon
            axis ij
            xlim([-50 300])
            
            
            
            vline(TDT.OR.errors,'r')
            
            title('OR Errors')
            
            
            eval(['print -dpdf //scratch/heitzrp/Output/Search_Errors/PDF/' file '_OR.pdf'])
            %eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_OR.pdf'])
            
            
            close(f)
        end
    end
    
    
end
clear OL* OR* n2pc* RF antiRF

%==========================================================


outdir = '//scratch/heitzrp/Output/Search_Errors/Matrices/';


if saveFlag == 1
    if exist('TDT')
        eval(['save(' q outdir,file,'_TDT.mat' qcq 'n' qcq 'wf' qcq 'TDT' qcq 'RTs' qcq '-mat' q ')'])
    else
        disp('Calculation of TDT Failed...not saving...')
        return
    end
end

keep  i q c qcq saveFlag

end