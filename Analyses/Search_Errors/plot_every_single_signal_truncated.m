%analysis routine for TDT correct vs errors in all signals
% This version DOES truncate 20 ms before saccade for ALL signals
% This version DOES NOT subsample.
% n2pc uses left and right hemifield
% Spike and LFP use Spike's RF.
% This version DOES calculate TDT, but these values are not to be used.  I
% do this only to define a signal as 'good' or 'bad'

% This type of analysis should be used to generate the PATTERN of activity,
% and not to be used to estimate timing.
%RPH
%4/22/09

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
            
            
            
            %abort if any condition has no trials
            if (isempty(in_correct) || isempty(out_correct) || isempty(in_incorrect) || isempty(out_incorrect))
                disp('At least one condition has no trials...moving on...')
                continue
            end
            
            SDF = sSDF(Spike,Target_(:,1),[-100 500]);
            SDF = truncateSP_targ(SDF,SRT,[-100 500]);
            
            
            SDF_in_correct = nanmean(SDF(in_correct,:));
            SDF_out_correct = nanmean(SDF(out_correct,:));
            SDF_in_incorrect = nanmean(SDF(in_incorrect,:));
            SDF_out_incorrect = nanmean(SDF(out_incorrect,:));
            
            n.(cell2mat(DSPlist(DSPchan))).correct.in = length(in_correct);
            n.(cell2mat(DSPlist(DSPchan))).correct.out = length(out_correct);
            n.(cell2mat(DSPlist(DSPchan))).errors.in = length(in_incorrect);
            n.(cell2mat(DSPlist(DSPchan))).errors.out = length(out_incorrect);
            
            %keep track of waveforms
            wf.(cell2mat(DSPlist(DSPchan))).correct.in = SDF_in_correct;
            wf.(cell2mat(DSPlist(DSPchan))).correct.out = SDF_out_correct;
            wf.(cell2mat(DSPlist(DSPchan))).errors.in = SDF_in_incorrect;
            wf.(cell2mat(DSPlist(DSPchan))).errors.out = SDF_out_incorrect;
            
            %calculate TDT here rather than with function because truncated signals
            for time = 200:size(SDF,2) %200 == 100 ms post stimulus onset
                %remove any nan values for current time
                clean_in = SDF(in_correct,time);
                clean_in(find(isnan(clean_in))) = [];
                
                clean_out = SDF(out_correct,time);
                clean_out(find(isnan(clean_out))) = [];
                
                if ~isempty(clean_in) & ~isempty(clean_out)
                    [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',.01);
                else
                    p(time) = NaN;
                    h(time) = 0;
                end
                
            end
            
            TDT.(cell2mat(DSPlist(DSPchan))).correct = min(findRuns(h,10)) - 100;
            
            if isempty(TDT)
                TDT.(cell2mat(DSPlist(DSPchan))).correct = NaN;
            end
            
            
            
            
            for time = 200:size(SDF,2) %200 == 100 ms post stimulus onset
                %remove any nan values for current time
                clean_in = SDF(in_incorrect,time);
                clean_in(find(isnan(clean_in))) = [];
                
                clean_out = SDF(out_incorrect,time);
                clean_out(find(isnan(clean_out))) = [];
                
                if ~isempty(clean_in) & ~isempty(clean_out)
                    [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',.01);
                else
                    p(time) = NaN;
                    h(time) = 0;
                end
                
            end
            
            TDT.(cell2mat(DSPlist(DSPchan))).errors = min(findRuns(h,10)) - 100;
            
            if isempty(TDT)
                TDT.(cell2mat(DSPlist(DSPchan))).errors = NaN;
            end
            
            
            %find max an dmin values for plotting
%             mx = findMax(SDF_in_correct,SDF_out_correct,SDF_in_incorrect,SDF_out_incorrect);
%             mn = findMin(SDF_in_correct,SDF_out_correct,SDF_in_incorrect,SDF_out_incorrect);
%             
%             
%             try
%                 if SDF_in_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']) + 100) > SDF_out_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']) + 100)
%                     valence.([cell2mat(DSPlist(DSPchan)) '_correct']) = '1';
%                 elseif SDF_in_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']) + 100) < SDF_out_correct(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']) + 100)
%                     valence.([cell2mat(DSPlist(DSPchan)) '_correct']) = '-1';
%                 end
%             catch
%                 valence.([cell2mat(DSPlist(DSPchan)) '_correct']) = NaN;
%             end
%             
%             TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) = getTDT_SP(Spike,in_incorrect,out_incorrect);
%             
%             %check valence of target in vs target out activity at TDT (1 ==
%             %Tin greater
%             try
%                 if SDF_in_incorrect(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100) > SDF_out_incorrect(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100)
%                     valence.([cell2mat(DSPlist(DSPchan)) '_errors']) = '1';
%                 elseif SDF_in_incorrect(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100) < SDF_out_incorrect(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']) + 100)
%                     valence.([cell2mat(DSPlist(DSPchan)) '_errors']) = '-1';
%                 end
%             catch
%                 valence.([cell2mat(DSPlist(DSPchan)) '_errors']) = NaN;
%             end
%             
            
%             f  = figure;
%             plot(-100:500,SDF_in_correct,'b',-100:500,SDF_out_correct,'--b')
%             fon
%             xlim([-100 500])
% %             ylim([mn mx])
%             
%             vline(TDT.([cell2mat(DSPlist(DSPchan)) '_correct']),'b')
%             
%             
%             title(cell2mat(DSPlist(DSPchan)))
%             
%             keeper = input('Keep? ');
%             
%             if keeper == 1
%                 eval(['print -dpdf /volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_NotTruncated/PDF/' batch_list(i).name '_' DSPlist{DSPchan} '_correct.pdf'])
%             end
%             
%             close(f)
            
%             
%             f  = figure;
%             plot(-100:500,SDF_in_incorrect,'r',-100:500,SDF_out_incorrect,'--r')
%             fon
%             xlim([-100 500])
% %             ylim([mn mx])
%             
%             
%             vline(TDT.([cell2mat(DSPlist(DSPchan)) '_errors']),'r')
%             
%             title(cell2mat(DSPlist(DSPchan)))
%             
%             keeper = input('Keep? ');
%             
%             if keeper == 1
%                 eval(['print -dpdf /volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_NotTruncated/PDF/' batch_list(i).name '_' DSPlist{DSPchan} '_error.pdf'])
%             end
%             
%             close(f)
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
            
            %find RF of corresponding first single unit
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
            
            
            
            
            %remove clipped trials
            LFP = fixClipped(LFP,[500 900]);
            
            %truncate 20 ms before saccade
            LFP = truncateAD_targ(LFP,SRT);
            
            %baseline correct
            LFP = baseline_correct(LFP,[400 500]);
            
            LFP_in_correct = nanmean(LFP(in_correct,:));
            LFP_out_correct = nanmean(LFP(out_correct,:));
            LFP_in_incorrect = nanmean(LFP(in_incorrect,:));
            LFP_out_incorrect = nanmean(LFP(out_incorrect,:));
            
            n.(cell2mat(LFPlist(LFPchan))).correct.in = length(in_correct);
            n.(cell2mat(LFPlist(LFPchan))).correct.out = length(out_correct);
            n.(cell2mat(LFPlist(LFPchan))).errors.in = length(in_incorrect);
            n.(cell2mat(LFPlist(LFPchan))).errors.out = length(out_incorrect);
            
            %keep track of waveforms
            wf.(cell2mat(LFPlist(LFPchan))).correct.in = LFP_in_correct;
            wf.(cell2mat(LFPlist(LFPchan))).correct.out = LFP_out_correct;
            wf.(cell2mat(LFPlist(LFPchan))).errors.in = LFP_in_incorrect;
            wf.(cell2mat(LFPlist(LFPchan))).errors.out = LFP_out_incorrect;
            
            
            TDT.(cell2mat(LFPlist(LFPchan))).correct = getTDT_AD(LFP,in_correct,out_correct);
            
            
            TDT.(cell2mat(LFPlist(LFPchan))).errors = getTDT_AD(LFP,in_incorrect,out_incorrect);
            
            %check valence of target in vs target out activity at TDT (1 ==
            %Tin MORE POSITIVE
%             
%             try
%                 if LFP_in_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500) > LFP_out_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500)
%                     valence.([cell2mat(LFPlist(LFPchan)) '_correct']) = '1';
%                 elseif LFP_in_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500)  < LFP_out_correct(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']) + 500)
%                     valence.([cell2mat(LFPlist(LFPchan)) '_correct']) = '-1';
%                 end
%             catch
%                 valence.([cell2mat(LFPlist(LFPchan)) '_correct']) = NaN;
%             end
%             
%             TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) = getTDT_AD(LFP,in_incorrect,out_incorrect);
%             
%             %check valence of target in vs target out activity at TDT (1 ==
%             %Tin greater
%             try
%                 if LFP_in_incorrect(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500) > LFP_out_incorrect(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500)
%                     valence.([cell2mat(LFPlist(LFPchan)) '_errors']) = '1';
%                 elseif LFP_in_incorrect(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500) < LFP_out_incorrect(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']) + 500)
%                     valence.([cell2mat(LFPlist(LFPchan)) '_errors']) = '-1';
%                 end
%             catch
%                 valence.([cell2mat(LFPlist(LFPchan)) '_errors']) = NaN;
%             end
            
            %find min and max values for scaling
%             mx = findMax(LFP_in_correct(400:1000),LFP_out_correct(400:1000),LFP_in_incorrect(400:1000),LFP_out_incorrect(400:1000));
%             mn = findMin(LFP_in_correct(400:1000),LFP_out_correct(400:1000),LFP_in_incorrect(400:1000),LFP_out_incorrect(400:1000));
%             
%             f = figure;
%             plot(-500:2500,LFP_in_correct,'b',-500:2500,LFP_out_correct,'--b')
%             fon
%             axis ij
%             xlim([-100 500])
% %             ylim([mn mx])
%             
%             vline(TDT.([cell2mat(LFPlist(LFPchan)) '_correct']),'b')
%             
%             
%             title(cell2mat(LFPlist(LFPchan)))
%             
%             keeper = input('Keep? ');
%             
%             if keeper == 1
%                 eval(['print -dpdf /volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_NotTruncated/PDF/' batch_list(i).name '_' LFPlist{LFPchan} '_correct.pdf'])
%             end
%             
%             close(f)
%             
%             
%             
%             f = figure;
%             plot(-500:2500,LFP_in_incorrect,'r',-500:2500,LFP_out_incorrect,'--r')
%             fon
%             axis ij
%             xlim([-100 500])
% %             ylim([mn mx])
%             
%             
%             vline(TDT.([cell2mat(LFPlist(LFPchan)) '_errors']),'r')
%             
%             title(cell2mat(LFPlist(LFPchan)))
%             
%             keeper = input('Keep? ');
%             
%             if keeper == 1
%                 eval(['print -dpdf /volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_NotTruncated/PDF/' batch_list(i).name '_' LFPlist{LFPchan} '_error.pdf'])
%             end
%             
%             close(f)
            
            
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
        OL = truncateAD_targ(OL,SRT);
        OR = truncateAD_targ(OR,SRT);
        
        %baseline correct
        OL = baseline_correct(OL,[400 500]);
        OR = baseline_correct(OR,[400 500]);
        
        
        
        
        
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
        
        
        %find onset time but look between 100 after Target onset and 500 ms for
        %speed
        
        
        %
        %         for time = 600:1000%size(AD02,2);
        %             [WilcoxonOL_p_correct(time) WilcoxonOL_h_correct(time)] = ranksum(OLcontra_correct(:,time),OLipsi_correct(:,time),'alpha',.01);
        %             [WilcoxonOR_p_correct(time) WilcoxonOR_h_correct(time)] = ranksum(ORcontra_correct(:,time),ORipsi_correct(:,time),'alpha',.01);
        %             [WilcoxonOL_p_errors(time) WilcoxonOL_h_errors(time)] = ranksum(OLcontra_errors(:,time),OLipsi_errors(:,time),'alpha',.01);
        %             [WilcoxonOR_p_errors(time) WilcoxonOR_h_errors(time)] = ranksum(ORcontra_errors(:,time),ORipsi_errors(:,time),'alpha',.01);
        %         end
        %
        %         %find miminum time of 10 consecutive significant bins; begin looking 100 ms
        %         %after target onset (which is column 600)
        %         N2pc_TDT_OL_correct = min(findRuns(WilcoxonOL_h_correct,10)) - 500;
        %         N2pc_TDT_OR_correct = min(findRuns(WilcoxonOR_h_correct,10)) - 500;
        %
        %         N2pc_TDT_OL_errors = min(findRuns(WilcoxonOL_h_errors,10)) - 500;
        %         N2pc_TDT_OR_errors = min(findRuns(WilcoxonOR_h_errors,10)) - 500;
        
        N2pc_TDT_OL_correct = getTDT_AD(OL,contraCorrectOL,ipsiCorrectOL);
        N2pc_TDT_OR_correct = getTDT_AD(OR,contraCorrectOR,ipsiCorrectOR);
        N2pc_TDT_OL_errors = getTDT_AD(OL,contraErrorsOL,ipsiErrorsOL);
        N2pc_TDT_OR_errors = getTDT_AD(OR,contraErrorsOR,ipsiErrorsOR);
        
        
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
%         try
%             if wf.OL_correct.contra(TDT.OL_correct + 500) > wf.OL_correct.ipsi(TDT.OL_correct + 500)
%                 valence.OL_correct = '1';
%             elseif wf.OL_correct.contra(TDT.OL_correct + 500) < wf.OL_correct.ipsi(TDT.OL_correct + 500)
%                 valence.OL_correct = '-1';
%             else valence.OL_correct = NaN;
%             end
%         catch
%             valence.OL_correct = NaN;
%         end
%         
%         try
%             if wf.OR_correct.contra(TDT.OR_correct + 500) > wf.OR_correct.ipsi(TDT.OR_correct + 500)
%                 valence.OR_correct = '1';
%             elseif wf.OR_correct.contra(TDT.OR_correct + 500) < wf.OR_correct.ipsi(TDT.OR_correct + 500)
%                 valence.OR_correct = '-1';
%             else
%                 valence.OR_correct = NaN;
%             end
%         catch
%             valence.OR_correct = NaN;
%         end
%         
%         try
%             if wf.OL_errors.contra(TDT.OL_errors + 500) > wf.OL_errors.ipsi(TDT.OL_errors + 500)
%                 valence.OL_errors = '1';
%             elseif wf.OL_errors.contra(TDT.OL_errors + 500) < wf.OL_errors.ipsi(TDT.OL_errors + 500)
%                 valence.OL_errors = '-1';
%             else
%                 valence.OL_errors = NaN;
%             end
%         catch
%             valence.OL_errors = NaN;
%         end
%         
%         try
%             if wf.OR_errors.contra(TDT.OR_errors + 500) > wf.OR_errors.ipsi(TDT.OR_errors + 500)
%                 valence.OR_errors = '1';
%             elseif wf.OR_errors.contra(TDT.OR_errors + 500) < wf.OR_errors.ipsi(TDT.OR_errors + 500)
%                 valence.OR_errors = '-1';
%             else
%                 valence.OR_errors = NaN;
%             end
%         catch
%             valence.OR_errors = NaN;
%         end
        %find max and min values for scaling
%         mx = findMax(wf.OL_correct.contra(400:1000),wf.OL_correct.ipsi(400:1000),wf.OL_errors.contra(400:1000),wf.OL_errors.ipsi(400:1000));
%         mn = findMin(wf.OL_correct.contra(400:1000),wf.OL_correct.ipsi(400:1000),wf.OL_errors.contra(400:1000),wf.OL_errors.ipsi(400:1000));
%         
%         f = figure;
%         plot(-500:2500,wf.OL_correct.contra,'b',-500:2500,wf.OL_correct.ipsi,'--b')
%         fon
%         axis ij
%         xlim([-100 500])
% %         ylim([mn mx])
%         
%         
%         vline(TDT.OL_correct,'b')
%         
%         
%         title('OL')
%         
%         
%         keeper = input('Keep? ');
%         
%         if keeper == 1
%             eval(['print -dpdf /volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_NotTruncated/PDF/' batch_list(i).name '_OL_correct.pdf'])
%         end
%         
%         close(f)
%         
%         
%         
%         f = figure;
%         plot(-500:2500,wf.OL_errors.contra,'r',-500:2500,wf.OL_errors.ipsi,'--r')
%         fon
%         axis ij
%         xlim([-100 500])
% %         ylim([mn mx])
%         
%         
%         
%         vline(TDT.OL_errors,'r')
%         
%         title('OL')
%         
%         
%         keeper = input('Keep? ');
%         
%         if keeper == 1
%             eval(['print -dpdf /volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_NotTruncated/PDF/' batch_list(i).name '_OL_error.pdf'])
%         end
%         
%         close(f)
%         
%         
% %         mx = findMax(wf.OR_correct.contra(400:1000),wf.OR_correct.ipsi(400:1000),wf.OR_errors.contra(400:1000),wf.OR_errors.ipsi(400:1000));
% %         mn = findMin(wf.OR_correct.contra(400:1000),wf.OR_correct.ipsi(400:1000),wf.OR_errors.contra(400:1000),wf.OR_errors.ipsi(400:1000));
% %         
%         
%         f = figure;
%         plot(-500:2500,wf.OR_correct.contra,'b',-500:2500,wf.OR_correct.ipsi,'--b')
%         fon
%         axis ij
%         xlim([-100 500])
% %         ylim([mn mx])
%         
%         vline(TDT.OR_correct,'b')
%         
%         
%         title('OR')
%         
%         
%         keeper = input('Keep? ');
%         
%         if keeper == 1
%             eval(['print -dpdf /volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_NotTruncated/PDF/' batch_list(i).name '_OR_correct.pdf'])
%         end
%         
%         close(f)
%         
%         
%         f = figure;
%         plot(-500:2500,wf.OR_errors.contra,'r',-500:2500,wf.OR_errors.ipsi,'--r')
%         fon
%         axis ij
%         xlim([-100 500])
% %         ylim([mn mx])
%         
%         
%         vline(TDT.OR_errors,'r')
%         
%         title('OR')
%         
%         
%         keeper = input('Keep? ');
%         
%         if keeper == 1
%             eval(['print -dpdf /volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_NotTruncated/PDF/' batch_list(i).name '_OR_error.pdf'])
%         end
%         
%         close(f)
    end
    clear OL* OR* n2pc* RF antiRF
    
    %==========================================================
    
    
    outdir = '/volumes/Dump/Analyses/Errors/Plot_Every_Single_Signal_Truncated/Matrices/';
    
    
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