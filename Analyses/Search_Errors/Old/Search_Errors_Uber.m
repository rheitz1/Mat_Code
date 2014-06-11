%analysis routine for TDT correct vs errors in all signals

% Spikes: Compute TDT @ relaxed criterion of .05 for correct trials.
% No need to truncate
% Calucate correct trial TDT after downsampling to # of error trials,
% repeat 100 times, take average.

% LFP: compute TDT for correct trials truncated & non-Truncated.  If these
% two TDT's are w/i 10 ms of each other, compute error trial TDT based on
% non-truncated signals
%
% Then, for comparison, downsample the correct trials to the # of trials
% for errors; calculate TDT and repeat 100 times.  error trial TDT will be
% average of these (keep raw values so can get variability.
%
% LFP RF = spike RF AND hemifield, separately
%
%
%
% P2Pc: same as for LFP, but use only hemifield.
%RPH
%6/15/09

cd /volumes/Dump/Search_Data/
batch_list = dir('*SEARCH.mat');

for i = 1:length(batch_list)
    batch_list(i).name
    q = '''';
    c = ',';
    qcq = [q c q];
    PDFflag = 1;
    saveFlag = 1;
    % path(path,'//scratch/heitzrp/')
    % path(path,'//scratch/heitzrp/Data_all/')
    
    try
        ChanStruct = loadChan(batch_list(i).name,'DSP');
        DSPlist = fieldnames(ChanStruct);
        decodeChanStruct
    catch
        DSPlist = [];
        disp('ERROR IN DSP CHANNELS....SKIPPING')
    end
    
    
    try
        ChanStruct = loadChan(batch_list(i).name,'LFP');
        LFPlist = fieldnames(ChanStruct);
        decodeChanStruct
    catch
        LFPlist = [];
        disp('ERROR IN LFP CHANNELS ....SKIPPING')
    end
    
    %manually add AD02 and AD03
    try
        eval(['load(' q batch_list(i).name qcq 'AD02' qcq '-mat' q ')']);
        disp('loading AD02')
        chanlist3{1,1} = 'AD02';
    catch
        disp('Missing AD02')
    end
    
    try
        eval(['load(' q batch_list(i).name qcq 'AD03' qcq '-mat' q ')']);
        chanlist3{2,1} = 'AD03';
        disp('loading AD03')
    catch
        disp('Missing AD03')
    end
    
    EEGlist = chanlist3;
    
    %full chanlist
    allchanlist = [DSPlist;LFPlist;EEGlist];
    
    
    
    
    %load Target_ & Correct_ variable
    eval(['load(' q batch_list(i).name qcq 'SaccDir_' qcq 'Hemi' qcq 'RFs' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);
    fixErrors
    
    
    
    
    %Check file to see if SaccDir_ contains only NaNs (before this was
    %coded in Tempo)
    if length(find(~isnan(SaccDir_))) < 5 %sometimes there are strays...
        eval(['load(' q batch_list(i).name qcq 'EyeX_' qcq 'EyeY_' q ')'])
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
            
            %find trial #s and randomize them for the subsampling below
            in_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),RF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            out_correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & ismember(Target_(:,2),antiRF) & SRT(:,1) < 2000 & SRT(:,1) > 50);
            in_incorrect = find(ismember(Target_(:,2),RF) & ismember(SaccDir_,antiRF));
            out_incorrect = find(ismember(Target_(:,2),antiRF) & ismember(SaccDir_,RF));
            
            
    %======================
    % Set up trial-history
    e_e.in(1:size(Correct_,1),1) = NaN;
    e_c.in(1:size(Correct_,1),1) = NaN;
    c_e.in(1:size(Correct_,1),1) = NaN;
    c_c.in(1:size(Correct_,1),1) = NaN;
    
    e_e.out(1:size(Correct_,1),1) = NaN;
    e_c.out(1:size(Correct_,1),1) = NaN;
    c_e.out(1:size(Correct_,1),1) = NaN;
    c_c.out(1:size(Correct_,1),1) = NaN;
    
    
    for trl = 2:size(Correct_,1)
        if Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(saccLoc(trl),RF) & Target_(:,2) ~= 255
            e_e.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 0 & ismember(saccLoc(trl),antiRF) & Target_(:,2) ~= 255
            e_e.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),RF) & Target_(:,2) ~= 255
            e_c.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 0 & ismember(Target_(trl,2),antiRF) & Target_(:,2) ~= 255
            e_c.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(saccLoc(trl),RF) & Target_(:,2) ~= 255
            c_e.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 0 & Correct_(trl-1,2) == 1 & ismember(saccLoc(trl),antiRF) & Target_(:,2) ~= 255
            c_e.out(trl-1,1) = trl;
            
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),RF) & Target_(:,2) ~= 255
            c_c.in(trl-1,1) = trl;
        elseif Correct_(trl,2) == 1 & Correct_(trl-1,2) == 1 & ismember(Target_(trl,2),antiRF) & Target_(:,2) ~= 255
            c_c.out(trl-1,1) = trl;
        end
    end
    
    
    e_e.in = removeNaN(e_e.in);
    e_c.in = removeNaN(e_c.in);
    c_e.in = removeNaN(c_e.in);
    c_c.in = removeNaN(c_c.in);
    
    e_e.out = removeNaN(e_e.out);
    e_c.out = removeNaN(e_c.out);
    c_e.out = removeNaN(c_e.out);
    c_c.out = removeNaN(c_c.out);
    %===========================
            
            %abort if any condition has no trials
            if findMin(length(in_correct),length(out_correct),length(in_incorrect),length(out_incorrect)) < 10
                disp('At least one condition has too few trials')
                continue
            end
            
            SDF = sSDF(Spike,Target_(:,1),[-100 500]);
            %SDF = truncateSP_targ(SDF,SRT,[-100 500]);
            
            
            
            %===========================================
            % Find TDT for error trials
            %             SDF_in_correct = nanmean(SDF(in_correct,:));
            %             SDF_out_correct = nanmean(SDF(out_correct,:));
            SDF_in_incorrect = nanmean(SDF(in_incorrect,:));
            SDF_out_incorrect = nanmean(SDF(out_incorrect,:));
            
            SDF_in_correct_e_e = nanmean(SDF(e_e.in,:));
            SDF_in_correct_e_c = nanmean(SDF(e_c.in,:));
            SDF_in_correct_c_e = nanmean(SDF(c_e.in,:));
            SDF_in_correct_c_c = nanmean(SDF(c_c.in,:));
            SDF_out_correct_e_e = nanmean(SDF(e_e.out,:));
            SDF_out_correct_e_c = nanmean(SDF(e_c.out,:));
            SDF_out_correct_c_e = nanmean(SDF(c_e.out,:));
            SDF_out_correct_c_c = nanmean(SDF(c_c.out,:));

            %             n.(cell2mat(DSPlist(DSPchan))).correct.in = length(in_correct);
            %             n.(cell2mat(DSPlist(DSPchan))).correct.out = length(out_correct);
            n.(cell2mat(DSPlist(DSPchan))).errors.in = length(in_incorrect);
            n.(cell2mat(DSPlist(DSPchan))).errors.out = length(out_incorrect);
            
            %keep track of waveforms
            %             wf.(cell2mat(DSPlist(DSPchan))).correct.in = SDF_in_correct;
            %             wf.(cell2mat(DSPlist(DSPchan))).correct.out = SDF_out_correct;
            wf.(cell2mat(DSPlist(DSPchan))).errors.in = SDF_in_incorrect;
            wf.(cell2mat(DSPlist(DSPchan))).errors.out = SDF_out_incorrect;
            wf.(cell2mat(DSPlist(DSPchan))).correct.in_e_e = SDF_in_correct_e_e;
            wf.(cell2mat(DSPlist(DSPchan))).correct.in_e_c = SDF_in_correct_e_c;
            wf.(cell2mat(DSPlist(DSPchan))).correct.in_c_e = SDF_in_correct_c_e;
            wf.(cell2mat(DSPlist(DSPchan))).correct.in_c_c = SDF_in_correct_c_c;
            wf.(cell2mat(DSPlist(DSPchan))).correct.out_e_e = SDF_out_correct_e_e;
            wf.(cell2mat(DSPlist(DSPchan))).correct.out_e_c = SDF_out_correct_e_c;
            wf.(cell2mat(DSPlist(DSPchan))).correct.out_c_e = SDF_out_correct_c_e;
            wf.(cell2mat(DSPlist(DSPchan))).correct.out_c_c = SDF_out_correct_c_c;

            
            TDT.(cell2mat(DSPlist(DSPchan))).correct_e_e = getTDT_SP(Spike,e_e.in,e_e.out);
            TDT.(cell2mat(DSPlist(DSPchan))).correct_e_c = getTDT_SP(Spike,e_c.in,e_c.out);
            TDT.(cell2mat(DSPlist(DSPchan))).correct_c_e = getTDT_SP(Spike,c_e.in,c_e.out);
            TDT.(cell2mat(DSPlist(DSPchan))).correct_c_c = getTDT_SP(Spike,c_c.in,c_c.out);
            
            %non-sub-sampled correct trial TDT
            for time = 200:size(SDF,2) %200 == 100 ms post stimulus onset
                %remove any nan values for current time
                clean_in = SDF(in_correct,time);
                clean_in(find(isnan(clean_in))) = [];
                
                clean_out = SDF(out_correct,time);
                clean_out(find(isnan(clean_out))) = [];
                
                if ~isempty(clean_in) & ~isempty(clean_out)
                    [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',.05);
                else
                    p(time) = NaN;
                    h(time) = 0;
                end
                
            end
            
            
            TDT.(cell2mat(DSPlist(DSPchan))).correct_nosub = min(findRuns(h,10)) - 100;
            
            
            if TDT.(cell2mat(DSPlist(DSPchan))).correct_nosub > nanmean(RTs.correct)
                disp('TDT greater than RT...writing NaN')
                TDT.(cell2mat(DSPlist(DSPchan))).correct_nosub = NaN;
            end
            
            
            if isempty(TDT)
                TDT.(cell2mat(DSPlist(DSPchan))).correct_nosub = NaN;
            end
            
            
            
            for time = 200:size(SDF,2) %200 == 100 ms post stimulus onset
                %remove any nan values for current time
                clean_in = SDF(in_incorrect,time);
                clean_in(find(isnan(clean_in))) = [];
                
                clean_out = SDF(out_incorrect,time);
                clean_out(find(isnan(clean_out))) = [];
                
                if ~isempty(clean_in) & ~isempty(clean_out)
                    [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',.05);
                else
                    p(time) = NaN;
                    h(time) = 0;
                end
                
            end
            
            
            TDT.(cell2mat(DSPlist(DSPchan))).errors = min(findRuns(h,10)) - 100;
            
            
            if TDT.(cell2mat(DSPlist(DSPchan))).errors > nanmean(RTs.errors)
                disp('TDT greater than RT...writing NaN')
                TDT.(cell2mat(DSPlist(DSPchan))).errors = NaN;
            end
            
            
            if isempty(TDT)
                TDT.(cell2mat(DSPlist(DSPchan))).errors = NaN;
            end
            
            
            
            
            %=====================================================
            % Find TDT for correct trials after sub-sampling
            
            numSamps = 1;
            
            %keep track of original vector of trial numbers
            in_correct_all = in_correct;
            out_correct_all = out_correct;
            for samp = 1:numSamps
                %re-randomize
                in_correct = shake(in_correct_all);
                out_correct = shake(out_correct_all);
                
                %sub-sample to length of equivalent error signals
                in_correct = in_correct(randperm(length(in_incorrect)));
                out_correct = out_correct(randperm(length(out_incorrect)));
                
                
                %calculate TDT here rather than with function because truncated signals
                for time = 200:size(SDF,2) %200 == 100 ms post stimulus onset
                    %remove any nan values for current time
                    clean_in = SDF(in_correct,time);
                    clean_in(find(isnan(clean_in))) = [];
                    
                    clean_out = SDF(out_correct,time);
                    clean_out(find(isnan(clean_out))) = [];
                    
                    if ~isempty(clean_in) & ~isempty(clean_out)
                        [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',.05);
                    else
                        p(time) = NaN;
                        h(time) = 0;
                    end
                    
                end
                
                TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) = min(findRuns(h,10)) - 100;
                
                if TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) > nanmean(RTs.correct)
                    disp('TDT greater than RT...writing NaN')
                    TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) = NaN;
                end
                
                if isempty(TDT)
                    TDT.(cell2mat(DSPlist(DSPchan))).correct(samp,1) = NaN;
                end
                
                wf.(cell2mat(DSPlist(DSPchan))).correct.in(samp,1:601) = nanmean(SDF(in_correct,:));
                wf.(cell2mat(DSPlist(DSPchan))).correct.out(samp,1:601) = nanmean(SDF(out_correct,:));
            end
            %
            
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
            
            
            eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_' DSPlist{DSPchan} '.pdf'])
            
            
            close(f)
            
            %plot trial-history
            f = figure;
            subplot(1,2,1)
            plot(-100:500,SDF_in_correct_c_c,'b',-100:500,SDF_out_correct_c_c,'--b',-100:500,SDF_in_correct_e_c,'r',-100:500,SDF_out_correct_e_c,'--r')
            vline(TDT.(cell2mat(DSPlist(DSPchan))).correct_c_c,'b')
            vline(TDT.(cell2mat(DSPlist(DSPchan))).correct_e_c,'r')
            xlim([-100 500])
            legend('cor-cor in','cor-cor out','cor-err in','cor-err out')
            
            subplot(1,2,2)
            plot(-100:500,SDF_in_correct_c_e,'b',-100:500,SDF_out_correct_c_e,'--b',-100:500,SDF_in_correct_e_e,'r',-100:500,SDF_out_correct_e_e,'--r')
            vline(TDT.(cell2mat(DSPlist(DSPchan))).correct_c_e,'b')
            vline(TDT.(cell2mat(DSPlist(DSPchan))).correct_e_e,'r')
            xlim([-100 500])
            legend('cor-err in','cor-err out','err-err in','err-err out')
                        
            eval(['print -dpdf /volumes/Dump/Analyses/Errors/Trial_History/PDF/' batch_list(i).name '_' DSPlist{DSPchan} '.pdf'])
            close(f)
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
                continue
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
            
            
            n.(cell2mat(LFPlist(LFPchan))).RF.errors.in = length(in_incorrect);
            n.(cell2mat(LFPlist(LFPchan))).RF.errors.out = length(out_incorrect);
            
            %keep track of waveforms
            
            wf.(cell2mat(LFPlist(LFPchan))).RF.errors.in = LFP_in_incorrect;
            wf.(cell2mat(LFPlist(LFPchan))).RF.errors.out = LFP_out_incorrect;
            
            
            %             TDT.(cell2mat(LFPlist(LFPchan))).correct = getTDT_AD(LFP,in_correct,out_correct);
            %=======================================
            % Check to make sure that truncated correct trial TDT
            % equivalent to non-truncated TDT
            tempTDT_trunc = getTDT_AD(LFP_trunc,in_correct,out_correct,0,.05);
            tempTDT_notrunc = getTDT_AD(LFP,in_correct,out_correct,0,.05);
            
            if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
                disp('At least one correct trial signal has NaN TDT')
                continue
            elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
                disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
                continue
            end
            
            
            
            TDT.(cell2mat(LFPlist(LFPchan))).RF.errors = getTDT_AD(LFP,in_incorrect,out_incorrect,0,.05);
            
            if TDT.(cell2mat(LFPlist(LFPchan))).RF.errors > nanmean(RTs.errors);
                disp('TDT greater than RT')
                TDT.(cell2mat(LFPlist(LFPchan))).RF.errors = NaN;
            end
            
            if isempty(TDT.(cell2mat(LFPlist(LFPchan))).RF.errors)
                TDT.(cell2mat(LFPlist(LFPchan))).RF.errors = NaN;
            end
            
            
            
            %for non-subsampled correct trial TDT
            TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_nosub = getTDT_AD(LFP,in_correct,out_correct,0,.05);
            
            if TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_nosub > nanmean(RTs.correct)
                TDT.(cell2mat(LFPlist(LFPchan))).RF.correct_nosub = NaN;
            end
            
            %=======================================
            % Repeated-sampling correct trial TDT
            
            numSamps = 3;
            
            %keep track of original vector of trial numbers
            in_correct_all = in_correct;
            out_correct_all = out_correct;
            for samp = 1:numSamps
                %re-randomize
                in_correct = shake(in_correct_all);
                out_correct = shake(out_correct_all);
                
                %sub-sample to length of equivalent error signals
                in_correct = in_correct(randperm(length(in_incorrect)));
                out_correct = out_correct(randperm(length(out_incorrect)));
                
                TDT.(cell2mat(LFPlist(LFPchan))).RF.correct(samp,1) = getTDT_AD(LFP,in_correct,out_correct,0,.05);
                
                if TDT.(cell2mat(LFPlist(LFPchan))).RF.correct(samp,1) > nanmean(RTs.correct)
                    TDT.(cell2mat(LFPlist(LFPchan))).RF.correct(samp,1) = NaN;
                end
                
                wf.(cell2mat(LFPlist(LFPchan))).RF.correct.in(samp,1:3001) = nanmean(LFP(in_correct,:));
                wf.(cell2mat(LFPlist(LFPchan))).RF.correct.out(samp,1:3001) = nanmean(LFP(out_correct,:));
            end
            
            %
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
            
            
            eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_RF_' LFPlist{LFPchan} '.pdf'])
            close(f)
            
            
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
            tempTDT_trunc = getTDT_AD(LFP_trunc,in_correct,out_correct,0,.05);
            tempTDT_notrunc = getTDT_AD(LFP,in_correct,out_correct,0,.05);
            
            if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
                disp('At least one correct trial signal has NaN TDT')
                continue
            elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
                disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
                continue
            end
            
            
            TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_nosub = getTDT_AD(LFP,in_correct,out_correct,0,.05);
            
            if TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_nosub > nanmean(RTs.correct)
                TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct_nosub = NaN;
            end
            
            
            TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors = getTDT_AD(LFP,in_incorrect,out_incorrect,0,.05);
            
            if TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors > nanmean(RTs.errors)
                disp('TDT later than RT')
                TDT.(cell2mat(LFPlist(LFPchan))).Hemi.errors = NaN;
            end
            
            %=======================================
            % Repeated-sampling correct trial TDT
            
            numSamps = 3;
            
            %keep track of original vector of trial numbers
            in_correct_all = in_correct;
            out_correct_all = out_correct;
            for samp = 1:numSamps
                %re-randomize
                in_correct = shake(in_correct_all);
                out_correct = shake(out_correct_all);
                
                %sub-sample to length of equivalent error signals
                in_correct = in_correct(randperm(length(in_incorrect)));
                out_correct = out_correct(randperm(length(out_incorrect)));
                
                TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct(samp,1) = getTDT_AD(LFP,in_correct,out_correct,0,.05);
                
                if TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct(samp,1) > nanmean(RTs.correct)
                    TDT.(cell2mat(LFPlist(LFPchan))).Hemi.correct(samp,1) = NaN;
                end
                
                wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.in(samp,1:3001) = nanmean(LFP(in_correct,:));
                wf.(cell2mat(LFPlist(LFPchan))).Hemi.correct.out(samp,1:3001) = nanmean(LFP(out_correct,:));
            end
            
            %
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
            
            
            eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_Hemi_' LFPlist{LFPchan} '.pdf'])
            
            close(f)
            
            
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
        
        tempTDT_notrunc = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL,0,.05);
        tempTDT_trunc = getTDT_AD(OL_trunc,contraCorrectOL,ipsiCorrectOL,0,.05);
        
        
        if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
            disp('At least one correct trial signal has NaN TDT')
            continue
        elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
            disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
            continue
        end
        
        %non sub-sampled correct trial TDT
        TDT.OL.correct_nosub = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL,0,.05);
        
        if TDT.OL.correct_nosub > nanmean(RTs.correct)
            TDT.OL.correct_nosub = NaN;
        end
        
        
        %pass tests, so calculate error TDT
        TDT.OL.errors = getTDT_AD(OL,contraErrorsOL,ipsiErrorsOL,0,.05);
        
        if TDT.OL.errors > nanmean(RTs.errors)
            disp('Error TDT later than RT')
            TDT.OL.errors = NaN;
        end
        
        wf.OL.errors.contra = nanmean(OL(contraErrorsOL,:));
        wf.OL.errors.ipsi = nanmean(OL(ipsiErrorsOL,:));
        
        %=======================================
        % Repeated-sampling correct trial TDT
        
        numSamps = 3;
        
        %keep track of original vector of trial numbers
        contra_correct_all = contraCorrectOL;
        ipsi_correct_all = ipsiCorrectOL;
        
        for samp = 1:numSamps
            %re-randomize
            in_correct = shake(contra_correct_all);
            out_correct = shake(ipsi_correct_all);
            
            %sub-sample to length of equivalent error signals
            in_correct = in_correct(randperm(length(contraErrorsOL)));
            out_correct = out_correct(randperm(length(ipsiErrorsOL)));
            
            TDT.OL.correct(samp,1) = getTDT_AD(OL,in_correct,out_correct,0,.05);
            
            if TDT.OL.correct(samp,1) > nanmean(RTs.correct)
                TDT.OL.correct(samp,1) = NaN;
            end
            
            wf.OL.correct.contra(samp,1:3001) = nanmean(OL(in_correct,:));
            wf.OL.correct.ipsi(samp,1:3001) = nanmean(OL(out_correct,:));
        end
        
        
        
        
        %
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
        
        eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_OL.pdf'])
        
        
        close(f)
        
        
        
        
        
        %==============================================
        % OR
        
        contraCorrectOR = find(Target_(:,2) ~= 255 & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[3 4 5]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
        ipsiCorrectOR = find(Target_(:,2) ~= 255 & ~isnan(OR(:,1)) & Correct_(:,2) == 1 & ismember(Target_(:,2),[7 0 1]) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
        
        contraErrorsOR = find(~isnan(OR(:,1)) & ismember(SaccDir_,[7 0 1]) & ismember(Target_(:,2),[3 4 5]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        ipsiErrorsOR = find(~isnan(OR(:,1)) & ismember(SaccDir_,[3 4 5]) & ismember(Target_(:,2),[7 0 1]) & SRT(:,1) < 2000 & SRT(:,1) > 50);
        
        
        n.OR_errors.contra = length(contraErrorsOR);
        n.OR_errors.ipsi = length(ipsiErrorsOR);
        
        
        OR_trunc = truncateAD_targ(OR,SRT);
        
        tempTDT_notrunc = getTDT_AD(OR,contraCorrectOR,ipsiCorrectOR,0,.05);
        tempTDT_trunc = getTDT_AD(OR_trunc,contraCorrectOR,ipsiCorrectOR,0,.05);
        
        
        if isnan(tempTDT_trunc) | isnan(tempTDT_notrunc)
            disp('At least one correct trial signal has NaN TDT')
            continue
        elseif abs(tempTDT_trunc - tempTDT_notrunc) > 10
            disp('Correct trial LFP TDT not equivalent for trunc and no trunc')
            continue
        end
        
        TDT.OR.correct_nosub = getTDT_AD(OR,contraCorrectOL,ipsiCorrectOR,0,.05);
        
        if TDT.OR.correct_nosub > nanmean(RTs.correct)
            TDT.OR.correct_nosub = NaN;
        end
        
        %pass tests, so calculate error TDT
        TDT.OR.errors = getTDT_AD(OR,contraErrorsOR,ipsiErrorsOR,0,.05);
        
        if TDT.OR.errors > nanmean(RTs.errors)
            disp('Error TDT later than RT')
            TDT.OR.errors = NaN;
        end
        
        wf.OR.errors.contra = nanmean(OR(contraErrorsOR,:));
        wf.OR.errors.ipsi = nanmean(OR(ipsiErrorsOR,:));
        
        %=======================================
        % Repeated-sampling correct trial TDT
        
        numSamps = 3;
        
        %keep track of original vector of trial numbers
        contra_correct_all = contraCorrectOR;
        ipsi_correct_all = ipsiCorrectOR;
        
        for samp = 1:numSamps
            %re-randomize
            in_correct = shake(contra_correct_all);
            out_correct = shake(ipsi_correct_all);
            
            %sub-sample to length of equivalent error signals
            in_correct = in_correct(randperm(length(contraErrorsOR)));
            out_correct = out_correct(randperm(length(ipsiErrorsOR)));
            
            TDT.OR.correct(samp,1) = getTDT_AD(OR,in_correct,out_correct,0,.05);
            
            if TDT.OR.correct(samp,1) > nanmean(RTs.errors)
                TDT.OR.correct(samp,1) = NaN;
            end
            
            wf.OR.correct.contra(samp,1:3001) = nanmean(OL(in_correct,:));
            wf.OR.correct.ipsi(samp,1:3001) = nanmean(OL(out_correct,:));
        end
        
        
        
        
        %
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
        
        
        
        eval(['print -dpdf /volumes/Dump/Analyses/Errors/Uber/PDF/' batch_list(i).name '_OR.pdf'])
        
        
        close(f)
        
        
        
        
    end
    clear OL* OR* n2pc* RF antiRF
    
    %==========================================================
    
    
    outdir = '/volumes/Dump/Analyses/Errors/Uber/Matrices/';
    
    
    if saveFlag == 1
        if exist('TDT')
            eval(['save(' q outdir,batch_list(i).name,'_TDT.mat' qcq 'n' qcq 'wf' qcq 'TDT' qcq 'RTs' qcq '-mat' q ')'])
        else
            disp('Calculation of TDT Failed...not saving...')
            return
        end
    end
    
    keep batch_list i q c qcq saveFlag
    
end