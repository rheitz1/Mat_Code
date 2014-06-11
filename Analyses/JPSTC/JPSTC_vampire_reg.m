% Joint Peri-stimulus time correlogram
% time-based correlation analysis for EEG-EEG, LFP-FLP, and LFP-EEG
% comparisons.

% (c) Richard P. Heitz, Vanderbilt 2008
% All rights reserved.

function [] = JPSTC_vampire(file)
tic
% path(path,'/home/heitzrp/Mat_Code/Common')
% path(path,'/home/heitzrp/Mat_Code/JPSTC')
% path(path,'/home/heitzrp/Data')
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/Data/')

plotFlag = 1;
pdfFlag = 1;
saveFlag = 1;
q = '''';
c = ',';
qcq = [q c q];


%find relevant channels in file
varlist = who('-file',file);
ADlist = cell2mat(varlist(strmatch('AD',varlist)));
%DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
clear varlist


for chanNum = 1:size(ADlist,1)
    ADchan = ADlist(chanNum,:);
    eval(['load(' q file qcq ADchan qcq '-mat' q ')'])
    disp(['load(' q file qcq ADchan qcq '-mat' q ')'])
    clear ADchan
end

%load Target_ & Correct_ variable
eval(['load(' q file qcq 'RFs' qcq 'MFs' qcq 'BestRF' qcq 'BestMF' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq '-mat' q ')']);

%rename LFP channels for consistency
clear ADlist
varlist = who;
chanlist = varlist(strmatch('AD',varlist));
clear varlist

plottime = (-50:400);
plottime_saccade = (-400:50);


%Find all possible pairings of LFP channels
pairings = nchoosek(1:length(chanlist),2);


%Compute comparisons backwards so we get LFP correlations out first
for pair = size(pairings,1):-1:1
    disp(['Comparing... ' cell2mat(chanlist(pairings(pair,1))) ' vs ' cell2mat(chanlist(pairings(pair,2))) ' ... ' mat2str(length(pairings) - pair + 1) ' of ' mat2str(size(pairings,1))])

    fixErrors
    error_skip = 0;
    set_size_skip = 0;
    homog_skip = 0;

    %====================================================
    % SET UP DATA
    %find relevant trials, exclude catch trials (255)
    correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    %use only ss4 or ss8 for homo/hete because set size 2 is equivocal
    homo = find(Target_(:,2) ~= 255 & (Target_(:,5) == 4 | Target_(:,5) == 8) & Target_(:,11) == 0 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    hete = find(Target_(:,2) ~= 255 & (Target_(:,5) == 4 | Target_(:,5) == 8) & Target_(:,11) == 1 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);

    %make sure we have data for all conditions
    if isempty(errors) == 1
        error_skip = 1;
    end

    if isempty(ss2) == 1 || isempty(ss4) == 1 || isempty(ss8) == 1
        set_size_skip = 1;
    end

    if isempty(homo) == 1 || isempty(hete) == 1
        homog_skip = 1;
    end

    %generate matrices, limit size of channels
    %target align = -50:400
    %saccade align = -400:50
    sig1 = eval(cell2mat(chanlist(pairings(pair,1))));
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NEW  
    sig1 = baseline_correct(sig1,[400 500]);
    
    sig1_correct = sig1(correct,450:900);
    sig1_errors =  sig1(errors,450:900);
    sig1_correct_ss2 = sig1(ss2,450:900);
    sig1_correct_ss4 = sig1(ss4,450:900);
    sig1_correct_ss8 = sig1(ss8,450:900);

    %homogeneity (note: limit only to set sizes 4 and 8 since set size 2
    %will always have only one distractor
    sig1_correct_homo = sig1(homo,450:900);
    sig1_correct_hete = sig1(hete,450:900);


    sig2 = eval(cell2mat(chanlist(pairings(pair,2))));
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NEW
    sig2 = baseline_correct(sig2,[400 500]);
    
    sig2_correct = sig2(correct,450:900);
    sig2_errors =  sig2(errors,450:900);
    sig2_correct_ss2 = sig2(ss2,450:900);
    sig2_correct_ss4 = sig2(ss4,450:900);
    sig2_correct_ss8 = sig2(ss8,450:900);

    %homogeneity (note: limit only to set sizes 4 and 8 since set size 2
    %will always have only one distractor
    sig2_correct_homo = sig2(homo,450:900);
    sig2_correct_hete = sig2(hete,450:900);

    %Get saccade-aligned traces

    %initialize variables
    sig1_correct_saccade(1:length(correct),1:451) = NaN;
    sig2_correct_saccade(1:length(correct),1:451) = NaN;
    sig1_errors_saccade(1:length(errors),1:451) = NaN;
    sig2_errors_saccade(1:length(errors),1:451) = NaN;
    sig1_correct_ss2_saccade(1:length(ss2),1:451) = NaN;
    sig2_correct_ss2_saccade(1:length(ss2),1:451) = NaN;
    sig1_correct_ss4_saccade(1:length(ss4),1:451) = NaN;
    sig2_correct_ss4_saccade(1:length(ss4),1:451) = NaN;
    sig1_correct_ss8_saccade(1:length(ss8),1:451) = NaN;
    sig2_correct_ss8_saccade(1:length(ss8),1:451) = NaN;
    sig1_correct_homo_saccade(1:length(homo),1:451) = NaN;
    sig2_correct_homo_saccade(1:length(homo),1:451) = NaN;
    sig1_correct_hete_saccade(1:length(hete),1:451) = NaN;
    sig2_correct_hete_saccade(1:length(hete),1:451) = NaN;


    for trl = 1:length(correct)
        sig1_correct_saccade(trl,1:451) = sig1(correct(trl),ceil(SRT(correct(trl),1)-400+500:ceil(SRT(correct(trl),1)+50+500)));
        sig2_correct_saccade(trl,1:451) = sig2(correct(trl),ceil(SRT(correct(trl),1)-400+500:ceil(SRT(correct(trl),1)+50+500)));
    end


    if error_skip ~= 1
        for trl = 1:length(errors)
            sig1_errors_saccade(trl,1:451) = sig1(errors(trl),ceil(SRT(errors(trl),1)-400+500:ceil(SRT(errors(trl),1)+50+500)));
            sig2_errors_saccade(trl,1:451) = sig2(errors(trl),ceil(SRT(errors(trl),1)-400+500:ceil(SRT(errors(trl),1)+50+500)));
        end
    end

    if set_size_skip ~= 1
        for trl = 1:length(ss2)
            sig1_correct_ss2_saccade(trl,1:451) = sig1(ss2(trl),ceil(SRT(ss2(trl),1)-400+500:ceil(SRT(ss2(trl),1)+50+500)));
            sig2_correct_ss2_saccade(trl,1:451) = sig2(ss2(trl),ceil(SRT(ss2(trl),1)-400+500:ceil(SRT(ss2(trl),1)+50+500)));
        end

        for trl = 1:length(ss4)
            sig1_correct_ss4_saccade(trl,1:451) = sig1(ss4(trl),ceil(SRT(ss4(trl),1)-400+500:ceil(SRT(ss4(trl),1)+50+500)));
            sig2_correct_ss4_saccade(trl,1:451) = sig2(ss4(trl),ceil(SRT(ss4(trl),1)-400+500:ceil(SRT(ss4(trl),1)+50+500)));
        end

        for trl = 1:length(ss8)
            sig1_correct_ss8_saccade(trl,1:451) = sig1(ss8(trl),ceil(SRT(ss8(trl),1)-400+500:ceil(SRT(ss8(trl),1)+50+500)));
            sig2_correct_ss8_saccade(trl,1:451) = sig2(ss8(trl),ceil(SRT(ss8(trl),1)-400+500:ceil(SRT(ss8(trl),1)+50+500)));
        end

    end

    if homog_skip ~= 1
        for trl = 1:length(homo)
            sig1_correct_homo_saccade(trl,1:451) = sig1(homo(trl),ceil(SRT(homo(trl),1)-400+500:ceil(SRT(homo(trl),1)+50+500)));
            sig2_correct_homo_saccade(trl,1:451) = sig2(homo(trl),ceil(SRT(homo(trl),1)-400+500:ceil(SRT(homo(trl),1)+50+500)));
        end

        for trl = 1:length(hete)
            sig1_correct_hete_saccade(trl,1:451) = sig1(hete(trl),ceil(SRT(hete(trl),1)-400+500:ceil(SRT(hete(trl),1)+50+500)));
            sig2_correct_hete_saccade(trl,1:451) = sig2(hete(trl),ceil(SRT(hete(trl),1)-400+500:ceil(SRT(hete(trl),1)+50+500)));
        end
    end

    %==========================================================================

    clear sig1 sig2 correct errors ss2 ss4 ss8 homo hete


    %=========================================================
    % Keep track of average waveforms

    %sig1-target aligned
    wf_sig1_correct = nanmean(sig1_correct,1);
    wf_sig1_errors = nanmean(sig1_errors,1);
    wf_sig1_correct_ss2 = nanmean(sig1_correct_ss2,1);
    wf_sig1_correct_ss4 = nanmean(sig1_correct_ss4,1);
    wf_sig1_correct_ss8 = nanmean(sig1_correct_ss8,1);
    wf_sig1_correct_homo = nanmean(sig1_correct_homo,1);
    wf_sig1_correct_hete = nanmean(sig1_correct_hete,1);

    %sig1-saccade aligned
    wf_sig1_correct_saccade = nanmean(sig1_correct_saccade,1);
    wf_sig1_errors_saccade = nanmean(sig1_errors_saccade,1);
    wf_sig1_correct_ss2_saccade = nanmean(sig1_correct_ss2_saccade,1);
    wf_sig1_correct_ss4_saccade = nanmean(sig1_correct_ss4_saccade,1);
    wf_sig1_correct_ss8_saccade = nanmean(sig1_correct_ss8_saccade,1);
    wf_sig1_correct_homo_saccade = nanmean(sig1_correct_homo_saccade,1);
    wf_sig1_correct_hete_saccade = nanmean(sig1_correct_hete_saccade,1);

    %sig2-target aligned
    wf_sig2_correct = nanmean(sig2_correct,1);
    wf_sig2_errors = nanmean(sig2_errors,1);
    wf_sig2_correct_ss2 = nanmean(sig2_correct_ss2,1);
    wf_sig2_correct_ss4 = nanmean(sig2_correct_ss4,1);
    wf_sig2_correct_ss8 = nanmean(sig2_correct_ss8,1);
    wf_sig2_correct_homo = nanmean(sig2_correct_homo,1);
    wf_sig2_correct_hete = nanmean(sig2_correct_hete,1);

    %sig2-saccade aligned
    wf_sig2_correct_saccade = nanmean(sig2_correct_saccade,1);
    wf_sig2_errors_saccade = nanmean(sig2_errors_saccade,1);
    wf_sig2_correct_ss2_saccade = nanmean(sig2_correct_ss2_saccade,1);
    wf_sig2_correct_ss4_saccade = nanmean(sig2_correct_ss4_saccade,1);
    wf_sig2_correct_ss8_saccade = nanmean(sig2_correct_ss8_saccade,1);
    wf_sig2_correct_homo_saccade = nanmean(sig2_correct_homo_saccade,1);
    wf_sig2_correct_hete_saccade = nanmean(sig2_correct_hete_saccade,1);

    %===========================================================


    %========================================================
    % Get FFT for sig1 and sig2 to examine 60 and 75 Hz noise

    %sig1-target aligned
    [freq FFT_correct_1] = getFFT(wf_sig1_correct);
    [freq FFT_errors_1] = getFFT(wf_sig1_errors);
    [freq FFT_correct_ss2_1] = getFFT(wf_sig1_correct_ss2);
    [freq FFT_correct_ss4_1] = getFFT(wf_sig1_correct_ss4);
    [freq FFT_correct_ss8_1] = getFFT(wf_sig1_correct_ss8);
    [freq FFT_correct_homo_1] = getFFT(wf_sig1_correct_homo);
    [freq FFT_correct_hete_1] = getFFT(wf_sig1_correct_hete);

    %sig2-target aligned
    [freq FFT_correct_2] = getFFT(wf_sig2_correct);
    [freq FFT_errors_2] = getFFT(wf_sig2_errors);
    [freq FFT_correct_ss2_2] = getFFT(wf_sig2_correct_ss2);
    [freq FFT_correct_ss4_2] = getFFT(wf_sig2_correct_ss4);
    [freq FFT_correct_ss8_2] = getFFT(wf_sig2_correct_ss8);
    [freq FFT_correct_homo_2] = getFFT(wf_sig2_correct_homo);
    [freq FFT_correct_hete_2] = getFFT(wf_sig2_correct_hete);

    %sig1-saccade aligned
    [freq FFT_correct_1_saccade] = getFFT(wf_sig1_correct_saccade);
    [freq FFT_errors_1_saccade] = getFFT(wf_sig1_errors_saccade);
    [freq FFT_correct_ss2_1_saccade] = getFFT(wf_sig1_correct_ss2_saccade);
    [freq FFT_correct_ss4_1_saccade] = getFFT(wf_sig1_correct_ss4_saccade);
    [freq FFT_correct_ss8_1_saccade] = getFFT(wf_sig1_correct_ss8_saccade);
    [freq FFT_correct_homo_1_saccade] = getFFT(wf_sig1_correct_homo_saccade);
    [freq FFT_correct_hete_1_saccade] = getFFT(wf_sig1_correct_hete_saccade);

    %sig2-saccade aligned
    [freq FFT_correct_2_saccade] = getFFT(wf_sig2_correct_saccade);
    [freq FFT_errors_2_saccade] = getFFT(wf_sig2_errors_saccade);
    [freq FFT_correct_ss2_2_saccade] = getFFT(wf_sig2_correct_ss2_saccade);
    [freq FFT_correct_ss4_2_saccade] = getFFT(wf_sig2_correct_ss4_saccade);
    [freq FFT_correct_ss8_2_saccade] = getFFT(wf_sig2_correct_ss8_saccade);
    [freq FFT_correct_homo_2_saccade] = getFFT(wf_sig2_correct_homo_saccade);
    [freq FFT_correct_hete_2_saccade] = getFFT(wf_sig2_correct_hete_saccade);

    %========================================================



    %
    % ========================================
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % % Time-averaged Correlograms
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %   Take a given lag and for each trial, calculate
    %   the correlation between the two signals over time (i.e., time-
    %   averaged).  Do for all lags


    % preallocate space
    cor_correct(1:size(sig1_correct,1),1:401) = NaN;
    cor_errors(1:size(sig1_errors,1),1:401) = NaN;
    cor_correct_ss2(1:size(sig1_correct_ss2,1),1:401) = NaN;
    cor_correct_ss4(1:size(sig1_correct_ss4,1),1:401) = NaN;
    cor_correct_ss8(1:size(sig1_correct_ss8,1),1:401) = NaN;
    cor_correct_homo(1:size(sig1_correct_homo,1),1:401) = NaN;
    cor_correct_hete(1:size(sig1_correct_hete,1),1:401) = NaN;

    cor_correct_saccade(1:size(sig1_correct_saccade,1),1:401) = NaN;
    cor_errors_saccade(1:size(sig1_errors_saccade,1),1:401) = NaN;
    cor_correct_ss2_saccade(1:size(sig1_correct_ss2_saccade,1),1:401) = NaN;
    cor_correct_ss4_saccade(1:size(sig1_correct_ss4_saccade,1),1:401) = NaN;
    cor_correct_ss8_saccade(1:size(sig1_correct_ss8_saccade,1),1:401) = NaN;
    cor_correct_homo_saccade(1:size(sig1_correct_homo_saccade,1),1:401) = NaN;
    cor_correct_hete_saccade(1:size(sig1_correct_hete_saccade,1),1:401) = NaN;

    lags = -200:200;

    %Correlogram for correct trials
    for trl = 1:size(sig1_correct,1)
        cor_correct(trl,1:401) = xcorr(sig2_correct(trl,:),sig1_correct(trl,:),200,'coeff');
        cor_correct_saccade(trl,1:401) = xcorr(sig2_correct_saccade(trl,:),sig1_correct_saccade(trl,:),200,'coeff');
    end

    %Correlogram for error trials
    for trl = 1:size(sig1_errors,1)
        cor_errors(trl,1:401) = xcorr(sig2_errors(trl,:),sig1_errors(trl,:),200,'coeff');
        cor_errors_saccade(trl,1:401) = xcorr(sig2_errors_saccade(trl,:),sig1_errors_saccade(trl,:),200,'coeff');
    end

    %Correlogram for correct trials Set Size 2
    for trl = 1:size(sig1_correct_ss2,1)
        cor_correct_ss2(trl,1:401) = xcorr(sig2_correct_ss2(trl,:),sig1_correct_ss2(trl,:),200,'coeff');
        cor_correct_ss2_saccade(trl,1:401) = xcorr(sig2_correct_ss2_saccade(trl,:),sig1_correct_ss2_saccade(trl,:),200,'coeff');
    end

    %Correlogram for correct trials Set Size 4
    for trl = 1:size(sig1_correct_ss4,1)
        cor_correct_ss4(trl,1:401) = xcorr(sig2_correct_ss4(trl,:),sig1_correct_ss4(trl,:),200,'coeff');
        cor_correct_ss4_saccade(trl,1:401) = xcorr(sig2_correct_ss4_saccade(trl,:),sig1_correct_ss4_saccade(trl,:),200,'coeff');
    end

    %Correlogram for correct trials Set Size 8
    for trl = 1:size(sig1_correct_ss8,1)
        cor_correct_ss8(trl,1:401) = xcorr(sig2_correct_ss8(trl,:),sig1_correct_ss8(trl,:),200,'coeff');
        cor_correct_ss8_saccade(trl,1:401) = xcorr(sig2_correct_ss8_saccade(trl,:),sig1_correct_ss8_saccade(trl,:),200,'coeff');
    end


    %Correlogram for correct trials homogeneous distractors
    for trl = 1:size(sig1_correct_homo,1)
        cor_correct_homo(trl,1:401) = xcorr(sig2_correct_homo(trl,:),sig1_correct_homo(trl,:),200,'coeff');
        cor_correct_homo_saccade(trl,1:401) = xcorr(sig2_correct_homo_saccade(trl,:),sig1_correct_homo_saccade(trl,:),200,'coeff');
    end

    %Correlogram for correct trials heterogeneous distractors
    for trl = 1:size(sig1_correct_hete,1)
        cor_correct_hete(trl,1:401) = xcorr(sig2_correct_hete(trl,:),sig1_correct_hete(trl,:),200,'coeff');
        cor_correct_hete_saccade(trl,1:401) = xcorr(sig2_correct_hete_saccade(trl,:),sig1_correct_hete_saccade(trl,:),200,'coeff');
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % JPSTC
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %===================================
    %Pre-allocate space
    JPSTC_correct(1:451,1:451) = NaN;
    JPSTC_errors(1:451,1:451) = NaN;
    shift_predictor(1:451,1:451) = NaN;
    JPSTC_correct_ss2(1:451,1:451) = NaN;
    JPSTC_correct_ss4(1:451,1:451) = NaN;
    JPSTC_correct_ss8(1:451,1:451) = NaN;
    JPSTC_correct_homo(1:451,1:451) = NaN;
    JPSTC_correct_hete(1:451,1:451) = NaN;

    JPSTC_correct_saccade(1:451,1:451) = NaN;
    JPSTC_errors_saccade(1:451,1:451) = NaN;
    shift_predictor(1:451,1:451) = NaN;
    JPSTC_correct_ss2_saccade(1:451,1:451) = NaN;
    JPSTC_correct_ss4_saccade(1:451,1:451) = NaN;
    JPSTC_correct_ss8_saccade(1:451,1:451) = NaN;
    JPSTC_correct_homo_saccade(1:451,1:451) = NaN;
    JPSTC_correct_hete_saccade(1:451,1:451) = NaN;
    %====================================




    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS
    %   use times -50 to 400
    disp('Running... [Correct Trials Targ-align & Sacc-align, Shift-Predictor]')
    tic
    JPSTC_correct = corr(sig1_correct,sig2_correct);
    JPSTC_correct_saccade = corr(sig1_correct_saccade,sig2_correct_saccade);
    shift_predictor = corr(circshift(sig1_correct,1),sig2_correct);
%             for time1 = 1:size(sig1_correct,2)
%                 for time2 = 1:size(sig2_correct,2)
%                     JPSTC_correct(time1,time2) = corr(sig1_correct(:,time1),sig2_correct(:,time2));
%                     JPSTC_correct_saccade(time1,time2) = corr(sig1_correct_saccade(:,time1),sig2_correct_saccade(:,time2));
%                     shift_predictor(time1,time2) = corr(circshift(sig1_correct(:,time1),1),sig2_correct(:,time2));
%                 end
%             end
    n_correct = size(sig1_correct,1);
    clear sig1_correct sig2_correct sig1_correct_saccade sig2_correct_saccade


    % 2) Error TRIALS
    %    use times -50 to 400
    if error_skip ~= 1
        disp('Running... [Error Trials]')
        JPSTC_errors = corr(sig1_errors,sig2_errors);
        JPSTC_errors_saccade = corr(sig1_errors_saccade,sig2_errors_saccade);
        %         for time1 = 1:size(sig1_errors,2)
        %             for time2 = 1:size(sig2_errors,2)
        %                 JPSTC_errors(time1,time2) = corr(sig1_errors(:,time1),sig2_errors(:,time2));
        %                 JPSTC_errors_saccade(time1,time2) = corr(sig1_errors_saccade(:,time1),sig2_errors_saccade(:,time2));
        %             end
        %         end

        n_errors = size(sig1_errors,1);
        clear sig1_errors sig2_errors sig1_errors_saccade sig2_errors_saccade

    else
        disp('No Errors found...skipping')
    end

    if set_size_skip ~= 1
        % 3) CORRECT TRIALS, SET SIZE 2
        disp('Running... [Correct Trials, Set Size 2]')
        JPSTC_correct_ss2 = corr(sig1_correct_ss2,sig2_correct_ss2);
        JPSTC_correct_ss2_saccade = corr(sig1_correct_ss2_saccade,sig2_correct_ss2_saccade);
        %         for time1 = 1:size(sig1_correct_ss2,2)
        %             for time2 = 1:size(sig2_correct_ss2,2)
        %                 JPSTC_correct_ss2(time1,time2) = corr(sig1_correct_ss2(:,time1),sig2_correct_ss2(:,time2));
        %                 JPSTC_correct_ss2_saccade(time1,time2) = corr(sig1_correct_ss2_saccade(:,time1),sig2_correct_ss2_saccade(:,time2));
        %             end
        %         end

        n_ss2 = size(sig1_correct_ss2,1);
        clear sig1_correct_ss2 sig2_correct_ss2 sig1_correct_ss2_saccade sig2_correct_ss2_saccade

        % 4) CORRECT TRIALS, SET SIZE 4
        disp('Running... [Correct Trials, Set Size 4]')
        JPSTC_correct_ss4 = corr(sig1_correct_ss4,sig2_correct_ss4);
        JPSTC_correct_ss4_saccade = corr(sig1_correct_ss4_saccade,sig2_correct_ss4_saccade);
        %         for time1 = 1:size(sig1_correct_ss4,2)
        %             for time2 = 1:size(sig2_correct_ss4,2)
        %                 JPSTC_correct_ss4(time1,time2) = corr(sig1_correct_ss4(:,time1),sig2_correct_ss4(:,time2));
        %                 JPSTC_correct_ss4_saccade(time1,time2) = corr(sig1_correct_ss4_saccade(:,time1),sig2_correct_ss4_saccade(:,time2));
        %             end
        %         end

        n_ss4 = size(sig1_correct_ss4,1);
        clear sig1_correct_ss4 sig2_correct_ss4 sig1_correct_ss4_saccade sig2_correct_ss4_saccade

        % 5) CORRECT TRIALS, SET SIZE 8
        disp('Running... [Correct Trials, Set Size 8]')
        JPSTC_correct_ss8 = corr(sig1_correct_ss8,sig2_correct_ss8);
        JPSTC_correct_ss8_saccade = corr(sig1_correct_ss8_saccade,sig2_correct_ss8_saccade);
        %         for time1 = 1:size(sig1_correct_ss8,2)
        %             for time2 = 1:size(sig2_correct_ss8,2)
        %                 JPSTC_correct_ss8(time1,time2) = corr(sig1_correct_ss8(:,time1),sig2_correct_ss8(:,time2));
        %                 JPSTC_correct_ss8_saccade(time1,time2) = corr(sig1_correct_ss8_saccade(:,time1),sig2_correct_ss8_saccade(:,time2));
        %             end
        %         end

        n_ss8 = size(sig1_correct_ss8,1);
        clear sig1_correct_ss8 sig2_correct_ss8 sig1_correct_ss8_saccade sig2_correct_ss8_saccade


    else
        disp('Missing set size data...skipping')
    end

    % 6) CORRECT TRIALS, homogeneous distractors
    if homog_skip ~= 1
        disp('Running... [Correct Trials, Homogeneous Distractors]')
        JPSTC_correct_homo = corr(sig1_correct_homo,sig2_correct_homo);
        JPSTC_correct_homo_saccade = corr(sig1_correct_homo_saccade,sig2_correct_homo_saccade);
        %         for time1 = 1:size(sig1_correct_homo,2)
        %             for time2 = 1:size(sig2_correct_homo,2)
        %                 JPSTC_correct_homo(time1,time2) = corr(sig1_correct_homo(:,time1),sig2_correct_homo(:,time2));
        %                 JPSTC_correct_homo_saccade(time1,time2) = corr(sig1_correct_homo_saccade(:,time1),sig2_correct_homo_saccade(:,time2));
        %             end
        %         end

        n_homo = size(sig1_correct_homo,1);
        clear sig1_correct_homo sig2_correct_homo sig1_correct_homo_saccade sig2_correct_homo_saccade

        % 7) CORRECT TRIALS, heterogeneous distractors
        disp('Running... [Correct Trials, Heterogeneous]')
        JPSTC_correct_hete = corr(sig1_correct_hete,sig2_correct_hete);
        JPSTC_correct_hete_saccade = corr(sig1_correct_hete,sig2_correct_hete);
        %         for time1 = 1:size(sig1_correct_hete,2)
        %             for time2 = 1:size(sig2_correct_hete,2)
        %                 JPSTC_correct_hete(time1,time2) = corr(sig1_correct_hete(:,time1),sig2_correct_hete(:,time2));
        %                 JPSTC_correct_hete_saccade(time1,time2) = corr(sig1_correct_hete_saccade(:,time1),sig2_correct_hete_saccade(:,time2));
        %             end
        %         end

        n_hete = size(sig1_correct_hete,1);
        clear sig1_correct_hete sig2_correct_hete sig1_correct_hete_saccade sig2_correct_hete_saccade

    else
        disp('Missing Homogeneous or Heterogeneous trials...skipping')
    end

    %     ======================================================================
    %     =====================End Main Loops===================================



    %======================================================================
    % Calculate Main and Off-Diagonal Averages
    [t_vector,above_furthest_correct,above_far_correct,above_close_correct,main_correct,below_close_correct,below_far_correct,below_furthest_correct,thickdiagonal_correct] = OffDiagonalAverage_vampire2(JPSTC_correct);
    [t_vector,above_furthest_correct_saccade,above_far_correct_saccade,above_close_correct_saccade,main_correct_saccade,below_close_correct_saccade,below_far_correct_saccade,below_furthest_correct_saccade,thickdiagonal_correct_saccade] = OffDiagonalAverage_vampire2(JPSTC_correct_saccade);

    [t_vector,above_furthest_errors,above_far_errors,above_close_errors,main_errors,below_close_errors,below_far_errors,below_furthest_errors,thickdiagonal_errors] = OffDiagonalAverage_vampire2(JPSTC_errors);
    [t_vector,above_furthest_errors_saccade,above_far_errors_saccade,above_close_errors_saccade,main_errors_saccade,below_close_errors_saccade,below_far_errors_saccade,below_furthest_errors_saccade,thickdiagonal_errors_saccade] = OffDiagonalAverage_vampire2(JPSTC_errors_saccade);

    [t_vector,above_furthest_ss2,above_far_ss2,above_close_ss2,main_ss2,below_close_ss2,below_far_ss2,below_furthest_ss2,thickdiagonal_ss2] = OffDiagonalAverage_vampire2(JPSTC_correct_ss2);
    [t_vector,above_furthest_ss2_saccade,above_far_ss2_saccade,above_close_ss2_saccade,main_ss2_saccade,below_close_ss2_saccade,below_far_ss2_saccade,below_furthest_ss2_saccade,thickdiagonal_ss2_saccade] = OffDiagonalAverage_vampire2(JPSTC_correct_ss2_saccade);

    [t_vector,above_furthest_ss4,above_far_ss4,above_close_ss4,main_ss4,below_close_ss4,below_far_ss4,below_furthest_ss4,thickdiagonal_ss4] = OffDiagonalAverage_vampire2(JPSTC_correct_ss4);
    [t_vector,above_furthest_ss4_saccade,above_far_ss4_saccade,above_close_ss4_saccade,main_ss4_saccade,below_close_ss4_saccade,below_far_ss4_saccade,below_furthest_ss4_saccade,thickdiagonal_ss4_saccade] = OffDiagonalAverage_vampire2(JPSTC_correct_ss4_saccade);

    [t_vector,above_furthest_ss8,above_far_ss8,above_close_ss8,main_ss8,below_close_ss8,below_far_ss8,below_furthest_ss8,thickdiagonal_ss8] = OffDiagonalAverage_vampire2(JPSTC_correct_ss8);
    [t_vector,above_furthest_ss8_saccade,above_far_ss8_saccade,above_close_ss8_saccade,main_ss8_saccade,below_close_ss8_saccade,below_far_ss8_saccade,below_furthest_ss8_saccade,thickdiagonal_ss8_saccade] = OffDiagonalAverage_vampire2(JPSTC_correct_ss8_saccade);


    [t_vector,above_furthest_homo,above_far_homo,above_close_homo,main_homo,below_close_homo,below_far_homo,below_furthest_homo,thickdiagonal_homo] = OffDiagonalAverage_vampire2(JPSTC_correct_homo);
    [t_vector,above_furthest_homo_saccade,above_far_homo_saccade,above_close_homo_saccade,main_homo_saccade,below_close_homo_saccade,below_far_homo_saccade,below_furthest_homo_saccade,thickdiagonal_homo_saccade] = OffDiagonalAverage_vampire2(JPSTC_correct_homo_saccade);

    [t_vector,above_furthest_hete,above_far_hete,above_close_hete,main_hete,below_close_hete,below_far_hete,below_furthest_hete,thickdiagonal_hete] = OffDiagonalAverage_vampire2(JPSTC_correct_hete);
    [t_vector,above_furthest_hete_saccade,above_far_hete_saccade,above_close_hete_saccade,main_hete_saccade,below_close_hete_saccade,below_far_hete_saccade,below_furthest_hete_saccade,thickdiagonal_hete_saccade] = OffDiagonalAverage_vampire2(JPSTC_correct_hete_saccade);

    %set t_vector for saccades:
    t_vector_saccade = t_vector + -350;
    %======================================================================


    %======================================
    % Save Variables
    if saveFlag == 1
        save(['//scratch/heitzrp/Output/JPSTC_matrices/reg/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_JPSTC_reg.mat'],'SRT','RFs','MFs','BestRF','BestMF','plottime','plottime_saccade','lags','JPSTC_correct','JPSTC_correct_saccade','JPSTC_errors','JPSTC_errors_saccade','shift_predictor','JPSTC_correct_ss2','JPSTC_correct_ss2_saccade','JPSTC_correct_ss4','JPSTC_correct_ss4_saccade','JPSTC_correct_ss8','JPSTC_correct_ss8_saccade','JPSTC_correct_homo','JPSTC_correct_homo_saccade','JPSTC_correct_hete','JPSTC_correct_hete_saccade','cor_correct','cor_correct_saccade','cor_errors','cor_errors_saccade','cor_correct_ss2','cor_correct_ss2_saccade','cor_correct_ss4','cor_correct_ss4_saccade','cor_correct_ss8','cor_correct_ss8_saccade','cor_correct_homo','cor_correct_homo_saccade','cor_correct_hete','cor_correct_hete_saccade','wf_sig1_correct','wf_sig1_correct_saccade','wf_sig1_errors','wf_sig1_errors_saccade','wf_sig1_correct_ss2','wf_sig1_correct_ss2_saccade','wf_sig1_correct_ss4','wf_sig1_correct_ss4_saccade','wf_sig1_correct_ss8','wf_sig1_correct_ss8_saccade','wf_sig1_correct_homo','wf_sig1_correct_homo_saccade','wf_sig1_correct_hete','wf_sig1_correct_hete_saccade','wf_sig2_correct','wf_sig2_correct_saccade','wf_sig2_errors','wf_sig2_errors_saccade','wf_sig2_correct_ss2','wf_sig2_correct_ss2_saccade','wf_sig2_correct_ss4','wf_sig2_correct_ss4_saccade','wf_sig2_correct_ss8','wf_sig2_correct_ss8_saccade','wf_sig2_correct_homo','wf_sig2_correct_homo_saccade','wf_sig2_correct_hete','wf_sig2_correct_hete_saccade','t_vector','above_furthest_correct','above_far_correct','above_close_correct','main_correct','below_close_correct','below_far_correct','below_furthest_correct','thickdiagonal_correct','above_furthest_correct_saccade','above_far_correct_saccade','above_close_correct_saccade','main_correct_saccade','below_close_correct_saccade','below_far_correct_saccade','below_furthest_correct_saccade','thickdiagonal_correct_saccade','above_furthest_errors','above_far_errors','above_close_errors','main_errors','below_close_errors','below_far_errors','below_furthest_errors','thickdiagonal_errors','above_furthest_errors_saccade','above_far_errors_saccade','above_close_errors_saccade','main_errors_saccade','below_close_errors_saccade','below_far_errors_saccade','below_furthest_errors_saccade','thickdiagonal_errors_saccade','above_furthest_ss2','above_far_ss2','above_close_ss2','main_ss2','below_close_ss2','below_far_ss2','below_furthest_ss2','thickdiagonal_ss2','above_furthest_ss2_saccade','above_far_ss2_saccade','above_close_ss2_saccade','main_ss2_saccade','below_close_ss2_saccade','below_far_ss2_saccade','below_furthest_ss2_saccade','thickdiagonal_ss2_saccade','above_furthest_ss4','above_far_ss4','above_close_ss4','main_ss4','below_close_ss4','below_far_ss4','below_furthest_ss4','thickdiagonal_ss4','above_furthest_ss4_saccade','above_far_ss4_saccade','above_close_ss4_saccade','main_ss4_saccade','below_close_ss4_saccade','below_far_ss4_saccade','below_furthest_ss4_saccade','thickdiagonal_ss4_saccade','above_furthest_ss8','above_far_ss8','above_close_ss8','main_ss8','below_close_ss8','below_far_ss8','below_furthest_ss8','thickdiagonal_ss8','above_furthest_ss8_saccade','above_far_ss8_saccade','above_close_ss8_saccade','main_ss8_saccade','below_close_ss8_saccade','below_far_ss8_saccade','below_furthest_ss8_saccade','thickdiagonal_ss8_saccade','above_furthest_homo','above_far_homo','above_close_homo','main_homo','below_close_homo','below_far_homo','below_furthest_homo','thickdiagonal_homo','above_furthest_homo_saccade','above_far_homo_saccade','above_close_homo_saccade','main_homo_saccade','below_close_homo_saccade','below_far_homo_saccade','below_furthest_homo_saccade','thickdiagonal_homo_saccade','above_furthest_hete','above_far_hete','above_close_hete','main_hete','below_close_hete','below_far_hete','below_furthest_hete','thickdiagonal_hete','above_furthest_hete_saccade','above_far_hete_saccade','above_close_hete_saccade','main_hete_saccade','below_close_hete_saccade','below_far_hete_saccade','below_furthest_hete_saccade','thickdiagonal_hete_saccade','-mat')
    end

    %======================================


    if plotFlag == 1

        %============================================
        %Figure 1: Correct trials vs shift-predictor
        figure
        orient landscape
        set(gcf,'renderer','painters')
        set(gcf,'Color','white')

        %Plot JPSTC
        subplot(4,8,[1:4 9:12])
        surface(JPSTC_correct,'edgecolor','none')
        xlim([0 450])
        ylim([0 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-50:100:400)
        set(gca,'YTickLabel',[])
        %set(gca,'YTickLabel',-50:100:400)

        %Plot lines marking target onset time
        line([0 450],[50 50],'color','k','linewidth',2)
        line([50 50],[0 450],'color','k','linewidth',2)

        %Plot boxes around areas to average

        %above, furthest
        line([52 64],[130 118],'color','g')
        line([52 302],[130 380],'color','g')
        line([302 314],[380 368],'color','g')
        line([64 314],[118 368],'color','g')

        %above, far
        line([65 77],[117 105],'color','r')
        line([65 315],[117 367],'color','r')
        line([315 327],[367 355],'color','r')
        line([77 327],[105 355],'color','r')

        %above, close
        line([78 90],[104 92],'color','b')
        line([78 328],[104 354],'color','b')
        line([328 340],[354 342],'color','b')
        line([90 340],[92 342],'color','b')

        %below, close
        line([92 104],[90 78],'color','b','linestyle','--')
        line([92 342],[90 340],'color','b','linestyle','--')
        line([342 354],[340 328],'color','b','linestyle','--')
        line([104 354],[78 328],'color','b','linestyle','--')

        %below, far
        line([105 117],[77 65],'color','r','linestyle','--')
        line([105 355],[77 327],'color','r','linestyle','--')
        line([355 367],[327 315],'color','r','linestyle','--')
        line([117 367],[65 315],'color','r','linestyle','--')

        %below, furthest
        line([118 130],[64 52],'color','g','linestyle','--')
        line([118 368],[64 314],'color','g','linestyle','--')
        line([368 380],[314 302],'color','g','linestyle','--')
        line([130 380],[52 302],'color','g','linestyle','--')

        %thickdiagonal
        line([52 130],[128 49],'color','k','linewidth',2)
        line([52 302],[128 383],'color','k','linewidth',2)
        line([302 383],[381 304],'color','k','linewidth',2)
        line([130 381],[49 304],'color','k','linewidth',2)

        colorbar('East')
        title([cell2mat(chanlist(pairings(pair,1))) ' Correct'],'fontweight','bold')
        ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')

        %Plot Shift-Predictor (shifted Sig1 by 1 trial)
        subplot(4,8,[5:8 13:16])
        surface(shift_predictor,'edgecolor','none')
        xlim([0 450])
        ylim([0 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-50:100:400)
        set(gca,'YTickLabel',[])
        line([0 450],[50 50],'color','k','linewidth',2)
        line([50 50],[0 450],'color','k','linewidth',2)
        colorbar('East')
        title([cell2mat(chanlist(pairings(pair,1))) ' Shift-Predictor'],'fontweight','bold')

        %Plot sig1 vs sig2

        subplot(4,8,17:20)
        plot(plottime,wf_sig1_correct,'linewidth',2)
        ylim([min(wf_sig1_correct) max(wf_sig1_correct)])
        xlim([-50 400])
        set(gca,'ytick',[])
        ylabel('mV','fontweight','bold')
        legend(cell2mat(chanlist(pairings(pair,1))))

        ax1 = gca;
        ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
        hold
        plot(plottime,wf_sig2_correct,'r','linewidth',2)
        ylim([min(wf_sig2_correct) max(wf_sig2_correct)])
        xlim([-50 400])
        set(gca,'ytick',[])
        legend(cell2mat(chanlist(pairings(pair,2))),'location','southeast')
        title('Mean Signals','fontweight','bold')


        %Plot FFTs
        subplot(4,8,25:26)
        plot(freq(5:end),FFT_correct_1(5:end),'b','linewidth',1)
        xlim([10 80])
        ylabel('Power','fontweight','bold')
        xlabel('Time','fontweight','bold')
        set(gca,'ytick',[])
        ax1 = gca;
        ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
        hold;
        plot(freq(5:end),FFT_correct_2(5:end),'r','linewidth',1)
        xlim([10 80])
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        hold off
        title('FFT (All Correct Trials)','fontweight','bold')


        %Plot Correlogram
        subplot(4,8,21:24)
        plot(lags,mean(cor_correct),'linewidth',2)
        xlabel('Lag','fontweight','bold')
        set(gca,'YAxisLocation','right')
        ylabel('Correlation','fontweight','bold')
        title('Correlogram','fontweight','bold')


        %Plot Off-diagonal averages

        %find global min and max so can compare across plots
        minvals(1) = min(above_close_correct);      maxvals(1) = max(above_close_correct);
        minvals(2) = min(above_far_correct);        maxvals(2) = max(above_far_correct);
        minvals(3) = min(above_furthest_correct);   maxvals(3) = max(above_furthest_correct);
        minvals(4) = min(below_close_correct);      maxvals(4) = max(below_close_correct);
        minvals(5) = min(below_far_correct);        maxvals(5) = max(below_far_correct);
        minvals(6) = min(below_furthest_correct);   maxvals(6) = max(below_furthest_correct);
        minvals(7) = min(main_correct);             maxvals(7) = max(main_correct);
        minval = min(minvals);
        maxval = max(maxvals);


        %close
        subplot(4,8,27:28)
        plot(t_vector,above_close_correct,'b',t_vector,below_close_correct,'--b',t_vector,main_correct,'k','linewidth',2)
        %legend('Above','Below','Main','location','southeast')
        ylim([minval maxval])
        xlim([t_vector(1) t_vector(end)])
        title('Close','fontweight','bold')
        %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])

        %far
        subplot(4,8,29:30)
        plot(t_vector,above_far_correct,'r',t_vector,below_far_correct,'--r',t_vector,main_correct,'k','linewidth',2)
        % legend('Above','Below','Main','location','southeast')
        ylim([minval maxval])
        xlim([t_vector(1) t_vector(end)])
        title('Far','fontweight','bold')

        %furthest
        subplot(4,8,31:32)
        plot(t_vector,above_furthest_correct,'g',t_vector,below_furthest_correct,'--g',t_vector,main_correct,'k','linewidth',2)
        legend('Above','Below','Main','location','southeast')
        ylim([minval maxval])
        xlim([t_vector(1) t_vector(end)])
        title('Furthest','fontweight','bold')


        [ax,h2] = suplabel(['nCorrect = ' mat2str(n_correct)],'y');
        set(h2,'FontSize',12,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'FontSize',12,'FontWeight','bold')

        if pdfFlag == 1
            %Print PDF w/ 0% compression
            %eval(['print -dpdf ',q,'//scratch/heitzrp/Output/correct_vs_shift/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_shift_reg.pdf',q])
            %Print JPG
            eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/correct_vs_shift/reg/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_shift_reg.jpg',q])
        end

        close all



        %==================================================================
        %==================================================================
        %Figure 2: Correct Target vs. Saccade Aligned
        figure
        orient landscape
        set(gcf,'renderer','painters')
        set(gcf,'Color','white')

        %Plot JPSTC
        subplot(4,8,[1:4 9:12])
        surface(JPSTC_correct,'edgecolor','none')
        xlim([0 450])
        ylim([0 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-50:100:400)
        set(gca,'YTickLabel',[])
        %set(gca,'YTickLabel',-50:100:400)

        %Plot lines marking target onset time
        line([0 450],[50 50],'color','k','linewidth',2)
        line([50 50],[0 450],'color','k','linewidth',2)

        %Plot boxes around areas to average

        %above, furthest
        line([52 64],[130 118],'color','g')
        line([52 302],[130 380],'color','g')
        line([302 314],[380 368],'color','g')
        line([64 314],[118 368],'color','g')

        %above, far
        line([65 77],[117 105],'color','r')
        line([65 315],[117 367],'color','r')
        line([315 327],[367 355],'color','r')
        line([77 327],[105 355],'color','r')

        %above, close
        line([78 90],[104 92],'color','b')
        line([78 328],[104 354],'color','b')
        line([328 340],[354 342],'color','b')
        line([90 340],[92 342],'color','b')

        %below, close
        line([92 104],[90 78],'color','b','linestyle','--')
        line([92 342],[90 340],'color','b','linestyle','--')
        line([342 354],[340 328],'color','b','linestyle','--')
        line([104 354],[78 328],'color','b','linestyle','--')

        %below, far
        line([105 117],[77 65],'color','r','linestyle','--')
        line([105 355],[77 327],'color','r','linestyle','--')
        line([355 367],[327 315],'color','r','linestyle','--')
        line([117 367],[65 315],'color','r','linestyle','--')

        %below, furthest
        line([118 130],[64 52],'color','g','linestyle','--')
        line([118 368],[64 314],'color','g','linestyle','--')
        line([368 380],[314 302],'color','g','linestyle','--')
        line([130 380],[52 302],'color','g','linestyle','--')

        %thickdiagonal
        line([52 130],[128 49],'color','k','linewidth',2)
        line([52 302],[128 383],'color','k','linewidth',2)
        line([302 383],[381 304],'color','k','linewidth',2)
        line([130 381],[49 304],'color','k','linewidth',2)

        colorbar('East')
        title([cell2mat(chanlist(pairings(pair,1))) ' Target-Aligned'],'fontweight','bold')
        ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')

        %Plot Saccade-aligned JPSTC
        subplot(4,8,[5:8 13:16])
        surface(JPSTC_correct_saccade,'edgecolor','none')
        xlim([0 450])
        ylim([0 450])
        set(gca,'XTick',0:100:450)
        set(gca,'YTick',0:100:450)
        set(gca,'XTickLabel',-400:100:50)
        set(gca,'YTickLabel',[])
        line([400 400],[0 450],'color','k','linewidth',2)
        line([0 450],[400 400],'color','k','linewidth',2)
        colorbar('East')
        title([cell2mat(chanlist(pairings(pair,1))) ' Saccade-Aligned'],'fontweight','bold')

        %Plot sig1 vs sig2
        subplot(4,8,17:20)
        plot(plottime,wf_sig1_correct,'b',plottime,wf_sig2_correct,'r','linewidth',2)
        ylim([min(min(wf_sig1_correct),min(wf_sig2_correct)) max(max(wf_sig1_correct),max(wf_sig2_correct))])
        xlim([-50 400])
        ylabel('mV','fontweight','bold')
        set(gca,'ytick',[])
        legend([cell2mat(chanlist(pairings(pair,1))) ' Targ'],[cell2mat(chanlist(pairings(pair,2))) ' Targ'])

        ax1 = gca;
        ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
        hold
        plot(plottime_saccade,wf_sig1_correct_saccade,'--b',plottime_saccade,wf_sig2_correct_saccade,'--r','linewidth',2)
        ylim([min(min(wf_sig1_correct_saccade),min(wf_sig2_correct_saccade)) max(max(wf_sig1_correct_saccade),max(wf_sig2_correct_saccade))])
        xlim([-400 50])
        set(gca,'ytick',[])
        legend([cell2mat(chanlist(pairings(pair,1))) ' Sacc'],[cell2mat(chanlist(pairings(pair,2))) ' Sacc'],'location','southeast')
        title('Mean Signals','fontweight','bold')

        %Plot FFTs
        %only plot FFTs for target aligned
        subplot(4,8,25:26)
        plot(freq(5:end),FFT_correct_1(5:end),'b','linewidth',1)
        xlim([10 80])
        ylabel('Power','fontweight','bold')
        xlabel('Time','fontweight','bold')
        set(gca,'ytick',[])
        ax1 = gca;
        ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
        hold;
        plot(freq(5:end),FFT_correct_2(5:end),'r','linewidth',1)
        xlim([10 80])
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        hold off
        title('FFT, target-aligned','fontweight','bold')


        %Plot Correlogram
        subplot(4,8,21:24)
        plot(lags,mean(cor_correct),'b',lags,mean(cor_correct_saccade),'r','linewidth',2)
        legend('Targ-Align','Sac-Align')
        xlabel('Lag','fontweight','bold')
        set(gca,'YAxisLocation','right')
        ylabel('Correlation','fontweight','bold')
        title('Correlogram','fontweight','bold')

        %Plot Off-diagonal averages

        %find global min and max so can compare across plots
        minvals(1) = min(above_close_correct_saccade);      maxvals(1) = max(above_close_correct_saccade);
        minvals(2) = min(above_far_correct_saccade);        maxvals(2) = max(above_far_correct_saccade);
        minvals(3) = min(above_furthest_correct_saccade);   maxvals(3) = max(above_furthest_correct_saccade);
        minvals(4) = min(below_close_correct_saccade);      maxvals(4) = max(below_close_correct_saccade);
        minvals(5) = min(below_far_correct_saccade);        maxvals(5) = max(below_far_correct_saccade);
        minvals(6) = min(below_furthest_correct_saccade);   maxvals(6) = max(below_furthest_correct_saccade);
        minvals(7) = min(main_correct_saccade);             maxvals(7) = max(main_correct_saccade);
        minval = min(minvals);
        maxval = max(maxvals);


        %close
        subplot(4,8,27:28)
        plot(t_vector,above_close_correct_saccade,'b',t_vector,below_close_correct_saccade,'--b',t_vector,main_correct_saccade,'k','linewidth',2)
        %legend('Above','Below','Main','location','southeast')
        ylim([minval maxval])
        xlim([t_vector(1) t_vector(end)])
        title('Close','fontweight','bold')
        %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])

        %far
        subplot(4,8,29:30)
        plot(t_vector,above_far_correct_saccade,'r',t_vector,below_far_correct_saccade,'--r',t_vector,main_correct_saccade,'k','linewidth',2)
        %legend('Above','Below','Main','location','southeast')
        ylim([minval maxval])
        xlim([t_vector(1) t_vector(end)])
        title('Far','fontweight','bold')

        %furthest
        subplot(4,8,31:32)
        plot(t_vector,above_furthest_correct_saccade,'g',t_vector,below_furthest_correct_saccade,'--g',t_vector,main_correct_saccade,'k','linewidth',2)
        legend('Above','Below','Main','location','southeast')
        ylim([minval maxval])
        xlim([t_vector(1) t_vector(end)])
        title('Furthest','fontweight','bold')


        [ax,h2] = suplabel(['nCorrect = ' mat2str(n_correct)],'y');
        set(h2,'FontSize',12,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'FontSize',12,'FontWeight','bold')

        if pdfFlag == 1
            %Print PDF
          %  eval(['print -dpdf ',q,'//scratch/heitzrp/Output/target_vs_saccade/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_target_v_sacade_reg.pdf',q])
            %Print JPG w/ 0% compression
            eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/target_vs_saccade/reg/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_target_v_sacade_reg.jpg',q])
        end

        close all



        %==================================================================
        %==================================================================
        %Figure 3: Correct vs errors,target-aligned
        if error_skip ~= 1
            figure
            orient landscape
            %use 'painters' renderer so that lines will show up
            set(gcf,'renderer','painters')
            set(gcf,'Color','white')

            %Plot JPSTC
            subplot(4,8,[1:4 9:12])
            surface(JPSTC_correct,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-50:100:400)
            set(gca,'YTickLabel',[])
            %set(gca,'YTickLabel',-50:100:400)

            %Plot lines marking target onset time
            line([0 450],[50 50],'color','k','linewidth',2)
            line([50 50],[0 450],'color','k','linewidth',2)

            %Plot boxes around areas to average

            %above, furthest
            line([52 64],[130 118],'color','g')
            line([52 302],[130 380],'color','g')
            line([302 314],[380 368],'color','g')
            line([64 314],[118 368],'color','g')

            %above, far
            line([65 77],[117 105],'color','r')
            line([65 315],[117 367],'color','r')
            line([315 327],[367 355],'color','r')
            line([77 327],[105 355],'color','r')

            %above, close
            line([78 90],[104 92],'color','b')
            line([78 328],[104 354],'color','b')
            line([328 340],[354 342],'color','b')
            line([90 340],[92 342],'color','b')

            %below, close
            line([92 104],[90 78],'color','b','linestyle','--')
            line([92 342],[90 340],'color','b','linestyle','--')
            line([342 354],[340 328],'color','b','linestyle','--')
            line([104 354],[78 328],'color','b','linestyle','--')

            %below, far
            line([105 117],[77 65],'color','r','linestyle','--')
            line([105 355],[77 327],'color','r','linestyle','--')
            line([355 367],[327 315],'color','r','linestyle','--')
            line([117 367],[65 315],'color','r','linestyle','--')

            %below, furthest
            line([118 130],[64 52],'color','g','linestyle','--')
            line([118 368],[64 314],'color','g','linestyle','--')
            line([368 380],[314 302],'color','g','linestyle','--')
            line([130 380],[52 302],'color','g','linestyle','--')

            %thickdiagonal
            line([52 130],[128 49],'color','k','linewidth',2)
            line([52 302],[128 383],'color','k','linewidth',2)
            line([302 383],[381 304],'color','k','linewidth',2)
            line([130 381],[49 304],'color','k','linewidth',2)

            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Correct'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')

            %Plot error JPSTC
            subplot(4,8,[5:8 13:16])
            surface(JPSTC_errors,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-50:100:400)
            set(gca,'YTickLabel',[])
            line([0 450],[50 50],'color','k','linewidth',2)
            line([50 50],[0 450],'color','k','linewidth',2)
            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Errors'],'fontweight','bold')

            %Plot sig1 vs sig2
            subplot(4,8,17:20)
            plot(plottime,wf_sig1_correct,'b',plottime,wf_sig1_errors,'--b','linewidth',2)
            ylim([min(min(wf_sig1_correct),min(wf_sig1_errors)) max(max(wf_sig1_correct),max(wf_sig1_errors))])
            xlim([-50 400])
            ylabel('mV','fontweight','bold')
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,1))) ' Correct'],[cell2mat(chanlist(pairings(pair,1))) ' Errors'])

            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold
            plot(plottime,wf_sig2_correct,'r',plottime,wf_sig2_errors,'--r','linewidth',2)
            ylim([min(min(wf_sig2_correct),min(wf_sig2_errors)) max(max(wf_sig2_correct),max(wf_sig2_errors))])
            xlim([-50 400])
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,2))) ' Correct'],[cell2mat(chanlist(pairings(pair,2))) ' Errors'],'location','southeast')
            title('Mean Signals','fontweight','bold')


            %Plot FFTs
            %only plot FFTs for correct trials; likely to be the same, yet
            %attenuated, for error trials
            subplot(4,8,25:26)
            plot(freq(5:end),FFT_correct_1(5:end),'b','linewidth',1)
            xlim([10 80])
            ylabel('Power','fontweight','bold')
            xlabel('Time','fontweight','bold')
            set(gca,'ytick',[])
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold;
            plot(freq(5:end),FFT_correct_2(5:end),'r','linewidth',1)
            xlim([10 80])
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
            title('FFT (All Correct Trials)','fontweight','bold')


            %Plot Correlogram
            subplot(4,8,21:24)
            plot(lags,mean(cor_correct),'b',lags,mean(cor_errors),'r','linewidth',2)
            legend('Correct','Errors')
            xlabel('Lag','fontweight','bold')
            set(gca,'YAxisLocation','right')
            ylabel('Correlation','fontweight','bold')
            title('Correlogram','fontweight','bold')

            %Plot Off-diagonal averages

            %find global min and max so can compare across plots
            minvals(1) = min(above_close_correct);      maxvals(1) = max(above_close_correct);
            minvals(2) = min(above_far_correct);        maxvals(2) = max(above_far_correct);
            minvals(3) = min(above_furthest_correct);   maxvals(3) = max(above_furthest_correct);
            minvals(4) = min(below_close_correct);      maxvals(4) = max(below_close_correct);
            minvals(5) = min(below_far_correct);        maxvals(5) = max(below_far_correct);
            minvals(6) = min(below_furthest_correct);   maxvals(6) = max(below_furthest_correct);
            minvals(7) = min(above_close_errors);       maxvals(7) = max(above_close_errors);
            minvals(8) = min(above_far_errors);         maxvals(8) = max(above_far_errors);
            minvals(9) = min(above_furthest_errors);    maxvals(9) = max(above_furthest_errors);
            minvals(10) = min(below_close_errors);      maxvals(10) = max(below_close_errors);
            minvals(11) = min(below_far_errors);        maxvals(11) = max(below_far_errors);
            minvals(12) = min(below_furthest_errors);   maxvals(12) = max(below_furthest_errors);
            %        minvals(13) = min(main_errors);             maxvals(13) = max(main_errors);

            minval = min(minvals);
            maxval = max(maxvals);


            %close
            subplot(4,8,27:28)
            plot(t_vector,above_close_correct,'b',t_vector,below_close_correct,'r',t_vector,above_close_errors,'--b',t_vector',below_close_errors,'--r','linewidth',2)
            %legend('Abov-corr','Belo-corr','Abov-err','Belo-err','location','southeast')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Close','fontweight','bold')
            %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])

            %far
            subplot(4,8,29:30)
            plot(t_vector,above_far_correct,'b',t_vector,below_far_correct,'r',t_vector,above_far_errors,'--b',t_vector',below_far_errors,'--r','linewidth',2)
            %legend('Abov-corr','Belo-corr','Abov-err','Belo-err','location','southeast')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Far','fontweight','bold')

            %furthest
            subplot(4,8,31:32)
            plot(t_vector,above_furthest_correct,'b',t_vector,below_furthest_correct,'r',t_vector,above_furthest_errors,'--b',t_vector',below_furthest_errors,'--r','linewidth',2)
            legend('Abov-corr','Belo-corr','Abov-err','Belo-err','location','southeast')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Furthest','fontweight','bold')

            [ax,h2] = suplabel(['nCorrect = ' mat2str(n_correct) ' nErrors = ' mat2str(n_errors)],'y');
            set(h2,'FontSize',12,'FontWeight','bold')
            [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
            set(h3,'FontSize',12,'FontWeight','bold')

            if pdfFlag == 1
                %Print PDF
          %      eval(['print -dpdf ',q,'//scratch/heitzrp/Output/correct_vs_errors/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_errors_targ_reg.pdf',q])
                %Print JPG w/ 0% compression
                eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/correct_vs_errors/reg/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_errors_targ_reg.jpg',q])
            end

            close all
        end


        %==================================================================
        %==================================================================
        %Figure 4: Correct vs errors, saccade-aligned
        if error_skip ~= 1
            figure
            orient landscape
            %use 'painters' renderer so that lines will show up
            set(gcf,'renderer','painters')
            set(gcf,'Color','white')

            %Plot JPSTC
            subplot(4,8,[1:4 9:12])
            surface(JPSTC_correct_saccade,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-400:100:50)
            set(gca,'YTickLabel',[])


            %Plot lines marking target onset time
            line([400 400],[0 450],'color','k','linewidth',2)
            line([0 450],[400 400],'color','k','linewidth',2)

            %Plot boxes around areas to average

            %above, furthest
            line([52 64],[130 118],'color','g')
            line([52 302],[130 380],'color','g')
            line([302 314],[380 368],'color','g')
            line([64 314],[118 368],'color','g')

            %above, far
            line([65 77],[117 105],'color','r')
            line([65 315],[117 367],'color','r')
            line([315 327],[367 355],'color','r')
            line([77 327],[105 355],'color','r')

            %above, close
            line([78 90],[104 92],'color','b')
            line([78 328],[104 354],'color','b')
            line([328 340],[354 342],'color','b')
            line([90 340],[92 342],'color','b')

            %below, close
            line([92 104],[90 78],'color','b','linestyle','--')
            line([92 342],[90 340],'color','b','linestyle','--')
            line([342 354],[340 328],'color','b','linestyle','--')
            line([104 354],[78 328],'color','b','linestyle','--')

            %below, far
            line([105 117],[77 65],'color','r','linestyle','--')
            line([105 355],[77 327],'color','r','linestyle','--')
            line([355 367],[327 315],'color','r','linestyle','--')
            line([117 367],[65 315],'color','r','linestyle','--')

            %below, furthest
            line([118 130],[64 52],'color','g','linestyle','--')
            line([118 368],[64 314],'color','g','linestyle','--')
            line([368 380],[314 302],'color','g','linestyle','--')
            line([130 380],[52 302],'color','g','linestyle','--')

            %thickdiagonal
            line([52 130],[128 49],'color','k','linewidth',2)
            line([52 302],[128 383],'color','k','linewidth',2)
            line([302 383],[381 304],'color','k','linewidth',2)
            line([130 381],[49 304],'color','k','linewidth',2)

            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Correct'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')

            %Plot error JPSTC
            subplot(4,8,[5:8 13:16])
            surface(JPSTC_errors_saccade,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-400:100:50)
            set(gca,'YTickLabel',[])
            line([400 400],[0 450],'color','k','linewidth',2)
            line([0 450],[400 400],'color','k','linewidth',2)
            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Errors'],'fontweight','bold')


            %Plot sig1 vs sig2
            subplot(4,8,17:20)
            plot(plottime_saccade,wf_sig1_correct_saccade,'b',plottime_saccade,wf_sig1_errors_saccade,'--b','linewidth',2)
            ylim([min(min(wf_sig1_correct_saccade),min(wf_sig1_errors_saccade)) max(max(wf_sig1_correct_saccade),max(wf_sig1_errors_saccade))])
            xlim([-400 50])
            ylabel('mV','fontweight','bold')
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,1))) ' Correct'],[cell2mat(chanlist(pairings(pair,1))) ' Errors'])

            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold
            plot(plottime_saccade,wf_sig2_correct_saccade,'r',plottime_saccade,wf_sig2_errors_saccade,'--r','linewidth',2)
            ylim([min(min(wf_sig2_correct_saccade),min(wf_sig2_errors_saccade)) max(max(wf_sig2_correct_saccade),max(wf_sig2_errors_saccade))])
            xlim([-400 50])
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,2))) ' Correct'],[cell2mat(chanlist(pairings(pair,2))) ' Errors'],'location','southeast')
            title('Mean Signals','fontweight','bold')


            %Plot FFTs
            %only plot FFTs for correct trials; likely to be the same, yet
            %attenuated, for error trials
            subplot(4,8,25:26)
            plot(freq(5:end),FFT_correct_1_saccade(5:end),'b','linewidth',1)
            xlim([10 80])
            ylabel('Power','fontweight','bold')
            xlabel('Time','fontweight','bold')
            set(gca,'ytick',[])
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold;
            plot(freq(5:end),FFT_correct_2_saccade(5:end),'r','linewidth',1)
            xlim([10 80])
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
            title('FFT (All Correct Trials, saccade-aligned)','fontweight','bold')


            %Plot Correlogram
            subplot(4,8,21:24)
            plot(lags,mean(cor_correct_saccade),'b',lags,mean(cor_errors_saccade),'r','linewidth',2)
            legend('Correct','Errors')
            xlabel('Lag','fontweight','bold')
            set(gca,'YAxisLocation','right')
            ylabel('Correlation','fontweight','bold')
            title('Correlogram','fontweight','bold')

            %Plot Off-diagonal averages

            %find global min and max so can compare across plots
            minvals(1) = min(above_close_correct_saccade);      maxvals(1) = max(above_close_correct_saccade);
            minvals(2) = min(above_far_correct_saccade);        maxvals(2) = max(above_far_correct_saccade);
            minvals(3) = min(above_furthest_correct_saccade);   maxvals(3) = max(above_furthest_correct_saccade);
            minvals(4) = min(below_close_correct_saccade);      maxvals(4) = max(below_close_correct_saccade);
            minvals(5) = min(below_far_correct_saccade);        maxvals(5) = max(below_far_correct_saccade);
            minvals(6) = min(below_furthest_correct_saccade);   maxvals(6) = max(below_furthest_correct_saccade);
            minvals(7) = min(above_close_errors_saccade);       maxvals(7) = max(above_close_errors_saccade);
            minvals(8) = min(above_far_errors_saccade);         maxvals(8) = max(above_far_errors_saccade);
            minvals(9) = min(above_furthest_errors_saccade);    maxvals(9) = max(above_furthest_errors_saccade);
            minvals(10) = min(below_close_errors_saccade);      maxvals(10) = max(below_close_errors_saccade);
            minvals(11) = min(below_far_errors_saccade);        maxvals(11) = max(below_far_errors_saccade);
            minvals(12) = min(below_furthest_errors_saccade);   maxvals(12) = max(below_furthest_errors_saccade);
            minvals(13) = min(main_errors_saccade);             maxvals(13) = max(main_errors_saccade);

            minval = min(minvals);
            maxval = max(maxvals);


            %close
            subplot(4,8,27:28)
            plot(t_vector_saccade,above_close_correct_saccade,'b',t_vector_saccade,below_close_correct_saccade,'r',t_vector_saccade,above_close_errors_saccade,'--b',t_vector_saccade,below_close_errors_saccade,'--r','linewidth',2)
            %legend('Above-corr','Below-corr','Above-err','Below-err','location','southwest')
            ylim([minval maxval])
            xlim([t_vector_saccade(1) t_vector_saccade(end)])
            title('Close','fontweight','bold')
            %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])

            %far
            subplot(4,8,29:30)
            plot(t_vector_saccade,above_far_correct_saccade,'b',t_vector_saccade,below_far_correct_saccade,'r',t_vector_saccade,above_far_errors_saccade,'--b',t_vector_saccade,below_far_errors_saccade,'--r','linewidth',2)
            %legend('Above-corr','Below-corr','Above-err','Below-err','location','southwest')
            ylim([minval maxval])
            xlim([t_vector_saccade(1) t_vector_saccade(end)])
            title('Far','fontweight','bold')

            %furthest
            subplot(4,8,31:32)
            plot(t_vector_saccade,above_furthest_correct_saccade,'b',t_vector_saccade,below_furthest_correct_saccade,'r',t_vector_saccade,above_furthest_errors_saccade,'--b',t_vector_saccade,below_furthest_errors_saccade,'--r','linewidth',2)
            legend('Above-corr','Below-corr','Above-err','Below-err','location','southwest')
            ylim([minval maxval])
            xlim([t_vector_saccade(1) t_vector_saccade(end)])
            title('Furthest','fontweight','bold')

            [ax,h2] = suplabel(['nCorrect = ' mat2str(n_correct) ' nErrors = ' mat2str(n_errors)],'y');
            set(h2,'FontSize',12,'FontWeight','bold')
            [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
            set(h3,'FontSize',12,'FontWeight','bold')

            if pdfFlag == 1
                %Print PDF
          %      eval(['print -dpdf ',q,'//scratch/heitzrp/Output/correct_vs_errors_saccade/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_errors_sacc_reg.pdf',q])
                %Print JPG w/ 0% compression
                eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/correct_vs_errors_saccade/reg/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_correct_v_errors_sacc_reg.jpg',q])
            end

            close all
        end

        %==================================================================
        %==================================================================
        %Figure 5: Set size 2 vs 4 vs 8, target-aligned
        if set_size_skip ~= 1
            figure
            orient landscape
            set(gcf,'renderer','painters')
            set(gcf,'Color','white')

            %JPSTC - set size 2
            subplot(4,8,[1:2 9:10])
            surface(JPSTC_correct_ss2,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-50:100:400)
            set(gca,'YTickLabel',[])

            %Plot lines marking target onset time
            line([0 450],[50 50],'color','k','linewidth',2)
            line([50 50],[0 450],'color','k','linewidth',2)

            %Plot boxes around areas to average

            %above, furthest
            line([52 64],[130 118],'color','g')
            line([52 302],[130 380],'color','g')
            line([302 314],[380 368],'color','g')
            line([64 314],[118 368],'color','g')

            %above, far
            line([65 77],[117 105],'color','r')
            line([65 315],[117 367],'color','r')
            line([315 327],[367 355],'color','r')
            line([77 327],[105 355],'color','r')

            %above, close
            line([78 90],[104 92],'color','b')
            line([78 328],[104 354],'color','b')
            line([328 340],[354 342],'color','b')
            line([90 340],[92 342],'color','b')

            %below, close
            line([92 104],[90 78],'color','b','linestyle','--')
            line([92 342],[90 340],'color','b','linestyle','--')
            line([342 354],[340 328],'color','b','linestyle','--')
            line([104 354],[78 328],'color','b','linestyle','--')

            %below, far
            line([105 117],[77 65],'color','r','linestyle','--')
            line([105 355],[77 327],'color','r','linestyle','--')
            line([355 367],[327 315],'color','r','linestyle','--')
            line([117 367],[65 315],'color','r','linestyle','--')

            %below, furthest
            line([118 130],[64 52],'color','g','linestyle','--')
            line([118 368],[64 314],'color','g','linestyle','--')
            line([368 380],[314 302],'color','g','linestyle','--')
            line([130 380],[52 302],'color','g','linestyle','--')

            %thickdiagonal
            line([52 130],[128 49],'color','k','linewidth',2)
            line([52 302],[128 383],'color','k','linewidth',2)
            line([302 383],[381 304],'color','k','linewidth',2)
            line([130 381],[49 304],'color','k','linewidth',2)

            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Set Size 2'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')


            %JPSTC - set size 4
            subplot(4,8,[4:5 12:13])
            surface(JPSTC_correct_ss4,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-50:100:400)
            set(gca,'YTickLabel',[])

            %Plot lines marking target onset time
            line([0 450],[50 50],'color','k','linewidth',2)
            line([50 50],[0 450],'color','k','linewidth',2)
            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Set Size 4'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')


            %JPSTC - set size 8
            subplot(4,8,[7:8 15:16])
            surface(JPSTC_correct_ss8,'edgecolor','none')
            xlim([0 450])
            ylim([0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-50:100:400)
            set(gca,'YTickLabel',[])

            %Plot lines marking target onset time
            line([0 450],[50 50],'color','k','linewidth',2)
            line([50 50],[0 450],'color','k','linewidth',2)
            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Set Size 8'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')


            %Plot sig1 vs sig2
            subplot(4,8,17:20)
            plot(plottime,wf_sig1_correct_ss2,'b',plottime,wf_sig1_correct_ss4,'r',plottime,wf_sig1_correct_ss8,'g','linewidth',2)
            ylim([min((min(min(wf_sig1_correct_ss2),min(wf_sig1_correct_ss4))),min(wf_sig1_correct_ss8)) max((max(max(wf_sig1_correct_ss2),max(wf_sig1_correct_ss4))),max(wf_sig1_correct_ss8))])
            xlim([-50 400])
            ylabel('mV','fontweight','bold')
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,1))) ' SS2'],[cell2mat(chanlist(pairings(pair,1))) ' SS4'],[cell2mat(chanlist(pairings(pair,1))) ' SS8'])

            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold
            plot(plottime,wf_sig2_correct_ss2,'--b',plottime,wf_sig2_correct_ss4,'--r',plottime,wf_sig2_correct_ss8,'--g','linewidth',2)
            ylim([min((min(min(wf_sig2_correct_ss2),min(wf_sig2_correct_ss4))),min(wf_sig2_correct_ss8)) max((max(max(wf_sig2_correct_ss2),max(wf_sig2_correct_ss4))),max(wf_sig2_correct_ss8))])
            xlim([-50 400])
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,2))) ' SS2'],[cell2mat(chanlist(pairings(pair,2))) ' SS4'],[cell2mat(chanlist(pairings(pair,2))) ' SS8'],'location','southeast')
            title('Mean Signals','fontweight','bold')

            %Plot FFTs
            %only plot FFTs for correct trials; likely to be the same, yet
            %attenuated, for error trials
            subplot(4,8,25:26)
            plot(freq(5:end),FFT_correct_1(5:end),'b','linewidth',1)
            xlim([10 80])
            ylabel('Power','fontweight','bold')
            xlabel('Time','fontweight','bold')
            set(gca,'ytick',[])
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold;
            plot(freq(5:end),FFT_correct_2(5:end),'r','linewidth',1)
            xlim([10 80])
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
            title('FFT (All Correct Trials)','fontweight','bold')


            %Plot Correlogram
            subplot(4,8,21:24)
            plot(lags,mean(cor_correct_ss2),'b',lags,mean(cor_correct_ss4),'r',lags,mean(cor_correct_ss8),'g','linewidth',2)
            legend('SS2','SS4','SS8')
            xlabel('Lag','fontweight','bold')
            set(gca,'YAxisLocation','right')
            ylabel('Correlation','fontweight','bold')
            title('Correlogram','fontweight','bold')


            %Plot Off-diagonal averages
            minvals(1) = min(above_close_ss2);      maxvals(1) = max(above_close_ss2);
            minvals(2) = min(above_far_ss2);        maxvals(2) = max(above_far_ss2);
            minvals(3) = min(above_furthest_ss2);   maxvals(3) = max(above_furthest_ss2);
            minvals(4) = min(below_close_ss2);      maxvals(4) = max(below_close_ss2);
            minvals(5) = min(below_far_ss2);        maxvals(5) = max(below_far_ss2);
            minvals(6) = min(below_furthest_ss2);   maxvals(6) = max(below_furthest_ss2);
            minvals(7) = min(above_close_ss4);      maxvals(7) = max(above_close_ss4);
            minvals(8) = min(above_far_ss4);        maxvals(8) = max(above_far_ss4);
            minvals(9) = min(above_furthest_ss4);   maxvals(9) = max(above_furthest_ss4);
            minvals(10) = min(below_close_ss4);     maxvals(10) = max(below_close_ss4);
            minvals(11) = min(below_far_ss4);       maxvals(11) = max(below_far_ss4);
            minvals(12) = min(below_furthest_ss4);  maxvals(12) = max(below_furthest_ss4);
            minvals(13) = min(above_close_ss8);     maxvals(13) = max(above_close_ss8);
            minvals(14) = min(above_far_ss8);       maxvals(14) = max(above_far_ss8);
            minvals(15) = min(above_furthest_ss8);  maxvals(15) = max(above_furthest_ss8);
            minvals(16) = min(below_close_ss8);     maxvals(16) = max(below_close_ss8);
            minvals(17) = min(below_far_ss8);       maxvals(17) = max(below_far_ss8);
            minvals(18) = min(below_furthest_ss8);  maxvals(18) = max(below_furthest_ss8);

            minval = min(minvals);
            maxval = max(maxvals);


            %close
            subplot(4,8,27:28)
            plot(t_vector,above_close_ss2,'b',t_vector,above_close_ss4,'r',t_vector,above_close_ss8,'g',t_vector,below_close_ss2,'--b',t_vector,below_close_ss4,'--r',t_vector,below_close_ss8,'--g','linewidth',2)
            %legend('Above-ss2','Above-ss4','Above-ss8','Below-ss2','Below-ss4','Below-ss8','location','southeast')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Close','fontweight','bold')
            %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])

            %far
            subplot(4,8,29:30)
            plot(t_vector,above_far_ss2,'b',t_vector,above_far_ss4,'r',t_vector,above_far_ss8,'g',t_vector,below_far_ss2,'--b',t_vector,below_far_ss4,'--r',t_vector,below_far_ss8,'--g','linewidth',2)
            %legend('Above-ss2','Above-ss4','Above-ss8','Below-ss2','Below-ss4','Below-ss8','location','southeast')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Far','fontweight','bold')

            %furthest
            subplot(4,8,31:32)
            plot(t_vector,above_furthest_ss2,'b',t_vector,above_furthest_ss4,'r',t_vector,above_furthest_ss8,'g',t_vector,below_furthest_ss2,'--b',t_vector,below_furthest_ss4,'--r',t_vector,below_furthest_ss8,'--g','linewidth',2)
            legend('Above-ss2','Above-ss4','Above-ss8','Below-ss2','Below-ss4','Below-ss8','location','southeast')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Furthest','fontweight','bold')


            [ax,h2] = suplabel(['nSS2 = ' mat2str(n_ss2) ' nSS4 = ' mat2str(n_ss4) ' nSS8 = ' mat2str(n_ss8)],'y');
            set(h2,'FontSize',12,'FontWeight','bold')
            [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
            set(h3,'FontSize',12,'FontWeight','bold')



            if pdfFlag == 1
                %Print PDF
          %      eval(['print -dpdf ',q,'//scratch/heitzrp/Output/set_size/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_set_size_targ_reg.pdf',q])
                %Print JPG w/ 0% compression
                eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/set_size/reg/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_set_size_targ_reg.jpg',q])
            end

            close all
        end



        %==================================================================
        %==================================================================
        %Figure 6: Set size 2 vs 4 vs 8, saccade-aligned
        if set_size_skip ~= 1
            figure
            orient landscape
            set(gcf,'renderer','painters')
            set(gcf,'Color','white')

            %JPSTC - set size 2
            subplot(4,8,[1:2 9:10])
            surface(JPSTC_correct_ss2_saccade,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-400:100:50)
            set(gca,'YTickLabel',[])

            %Plot lines marking target onset time
            line([400 400],[0 450],'color','k','linewidth',2)
            line([0 450],[400 400],'color','k','linewidth',2)

            %Plot boxes around areas to average

            %above, furthest
            line([52 64],[130 118],'color','g')
            line([52 302],[130 380],'color','g')
            line([302 314],[380 368],'color','g')
            line([64 314],[118 368],'color','g')

            %above, far
            line([65 77],[117 105],'color','r')
            line([65 315],[117 367],'color','r')
            line([315 327],[367 355],'color','r')
            line([77 327],[105 355],'color','r')

            %above, close
            line([78 90],[104 92],'color','b')
            line([78 328],[104 354],'color','b')
            line([328 340],[354 342],'color','b')
            line([90 340],[92 342],'color','b')

            %below, close
            line([92 104],[90 78],'color','b','linestyle','--')
            line([92 342],[90 340],'color','b','linestyle','--')
            line([342 354],[340 328],'color','b','linestyle','--')
            line([104 354],[78 328],'color','b','linestyle','--')

            %below, far
            line([105 117],[77 65],'color','r','linestyle','--')
            line([105 355],[77 327],'color','r','linestyle','--')
            line([355 367],[327 315],'color','r','linestyle','--')
            line([117 367],[65 315],'color','r','linestyle','--')

            %below, furthest
            line([118 130],[64 52],'color','g','linestyle','--')
            line([118 368],[64 314],'color','g','linestyle','--')
            line([368 380],[314 302],'color','g','linestyle','--')
            line([130 380],[52 302],'color','g','linestyle','--')

            %thickdiagonal
            line([52 130],[128 49],'color','k','linewidth',2)
            line([52 302],[128 383],'color','k','linewidth',2)
            line([302 383],[381 304],'color','k','linewidth',2)
            line([130 381],[49 304],'color','k','linewidth',2)

            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Set Size 2'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')


            %JPSTC - set size 4
            subplot(4,8,[4:5 12:13])
            surface(JPSTC_correct_ss4_saccade,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-400:100:50)
            set(gca,'YTickLabel',[])

            %Plot lines marking target onset time
            line([400 400],[0 450],'color','k','linewidth',2)
            line([0 450],[400 400],'color','k','linewidth',2)
            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Set Size 4'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')


            %JPSTC - set size 8
            subplot(4,8,[7:8 15:16])
            surface(JPSTC_correct_ss8_saccade,'edgecolor','none')
            xlim([0 450])
            ylim([0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-400:100:50)
            set(gca,'YTickLabel',[])

            %Plot lines marking target onset time
            line([400 400],[0 450],'color','k','linewidth',2)
            line([0 450],[400 400],'color','k','linewidth',2)
            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' Set Size 8'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')


            %Plot sig1 vs sig2
            subplot(4,8,17:20)
            plot(plottime_saccade,wf_sig1_correct_ss2_saccade,'b',plottime_saccade,wf_sig1_correct_ss4_saccade,'r',plottime_saccade,wf_sig1_correct_ss8_saccade,'g','linewidth',2)
            ylim([min((min(min(wf_sig1_correct_ss2_saccade),min(wf_sig1_correct_ss4_saccade))),min(wf_sig1_correct_ss8_saccade)) max((max(max(wf_sig1_correct_ss2_saccade),max(wf_sig1_correct_ss4_saccade))),max(wf_sig1_correct_ss8_saccade))])
            xlim([-400 50])
            ylabel('mV','fontweight','bold')
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,1))) ' SS2'],[cell2mat(chanlist(pairings(pair,1))) ' SS4'],[cell2mat(chanlist(pairings(pair,1))) ' SS8'])

            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold
            plot(plottime_saccade,wf_sig2_correct_ss2_saccade,'--b',plottime_saccade,wf_sig2_correct_ss4_saccade,'--r',plottime_saccade,wf_sig2_correct_ss8_saccade,'--g','linewidth',2)
            ylim([min((min(min(wf_sig2_correct_ss2_saccade),min(wf_sig2_correct_ss4_saccade))),min(wf_sig2_correct_ss8_saccade)) max((max(max(wf_sig2_correct_ss2_saccade),max(wf_sig2_correct_ss4_saccade))),max(wf_sig2_correct_ss8_saccade))])
            xlim([-400 50])
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,2))) ' SS2'],[cell2mat(chanlist(pairings(pair,2))) ' SS4'],[cell2mat(chanlist(pairings(pair,2))) ' SS8'],'location','southeast')
            title('Mean Signals','fontweight','bold')

            %Plot FFTs
            %only plot FFTs for correct trials; likely to be the same, yet
            %attenuated, for error trials
            subplot(4,8,25:26)
            plot(freq(5:end),FFT_correct_1_saccade(5:end),'b','linewidth',1)
            xlim([10 80])
            ylabel('Power','fontweight','bold')
            xlabel('Time','fontweight','bold')
            set(gca,'ytick',[])
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold;
            plot(freq(5:end),FFT_correct_2_saccade(5:end),'r','linewidth',1)
            xlim([10 80])
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
            title('FFT (All Correct Trials, saccade aligned)','fontweight','bold')


            %Plot Correlogram
            subplot(4,8,21:24)
            plot(lags,mean(cor_correct_ss2_saccade),'b',lags,mean(cor_correct_ss4_saccade),'r',lags,mean(cor_correct_ss8_saccade),'g','linewidth',2)
            legend('SS2','SS4','SS8')
            xlabel('Lag','fontweight','bold')
            set(gca,'YAxisLocation','right')
            ylabel('Correlation','fontweight','bold')
            title('Correlogram','fontweight','bold')


            %Plot Off-diagonal averages
            minvals(1) = min(above_close_ss2_saccade);      maxvals(1) = max(above_close_ss2_saccade);
            minvals(2) = min(above_far_ss2_saccade);        maxvals(2) = max(above_far_ss2_saccade);
            minvals(3) = min(above_furthest_ss2_saccade);   maxvals(3) = max(above_furthest_ss2_saccade);
            minvals(4) = min(below_close_ss2_saccade);      maxvals(4) = max(below_close_ss2_saccade);
            minvals(5) = min(below_far_ss2_saccade);        maxvals(5) = max(below_far_ss2_saccade);
            minvals(6) = min(below_furthest_ss2_saccade);   maxvals(6) = max(below_furthest_ss2_saccade);
            minvals(7) = min(above_close_ss4_saccade);      maxvals(7) = max(above_close_ss4_saccade);
            minvals(8) = min(above_far_ss4_saccade);        maxvals(8) = max(above_far_ss4_saccade);
            minvals(9) = min(above_furthest_ss4_saccade);   maxvals(9) = max(above_furthest_ss4_saccade);
            minvals(10) = min(below_close_ss4_saccade);     maxvals(10) = max(below_close_ss4_saccade);
            minvals(11) = min(below_far_ss4_saccade);       maxvals(11) = max(below_far_ss4_saccade);
            minvals(12) = min(below_furthest_ss4_saccade);  maxvals(12) = max(below_furthest_ss4_saccade);
            minvals(13) = min(above_close_ss8_saccade);     maxvals(13) = max(above_close_ss8_saccade);
            minvals(14) = min(above_far_ss8_saccade);       maxvals(14) = max(above_far_ss8_saccade);
            minvals(15) = min(above_furthest_ss8_saccade);  maxvals(15) = max(above_furthest_ss8_saccade);
            minvals(16) = min(below_close_ss8_saccade);     maxvals(16) = max(below_close_ss8_saccade);
            minvals(17) = min(below_far_ss8_saccade);       maxvals(17) = max(below_far_ss8_saccade);
            minvals(18) = min(below_furthest_ss8_saccade);  maxvals(18) = max(below_furthest_ss8_saccade);
            minval = min(minvals);
            maxval = max(maxvals);


            %close
            subplot(4,8,27:28)
            plot(t_vector_saccade,above_close_ss2_saccade,'b',t_vector_saccade,above_close_ss4_saccade,'r',t_vector_saccade,above_close_ss8_saccade,'g',t_vector_saccade,below_close_ss2_saccade,'--b',t_vector_saccade,below_close_ss4_saccade,'--r',t_vector_saccade,below_close_ss8_saccade,'--g','linewidth',2)
            %legend('Above-ss2','Above-ss4','Above-ss8','Below-ss2','Below-ss4','Below-ss8','location','southeast')
            ylim([minval maxval])
            xlim([t_vector_saccade(1) t_vector_saccade(end)])
            title('Close','fontweight','bold')
            %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])

            %far
            subplot(4,8,29:30)
            plot(t_vector_saccade,above_far_ss2_saccade,'b',t_vector_saccade,above_far_ss4_saccade,'r',t_vector_saccade,above_far_ss8_saccade,'g',t_vector_saccade,below_far_ss2_saccade,'--b',t_vector_saccade,below_far_ss4_saccade,'--r',t_vector_saccade,below_far_ss8_saccade,'--g','linewidth',2)
            %legend('Above-ss2','Above-ss4','Above-ss8','Below-ss2','Below-ss4','Below-ss8','location','southeast')
            ylim([minval maxval])
            xlim([t_vector_saccade(1) t_vector_saccade(end)])
            title('Far','fontweight','bold')

            %furthest
            subplot(4,8,31:32)
            plot(t_vector_saccade,above_furthest_ss2_saccade,'b',t_vector_saccade,above_furthest_ss4_saccade,'r',t_vector_saccade,above_furthest_ss8_saccade,'g',t_vector_saccade,below_furthest_ss2_saccade,'--b',t_vector_saccade,below_furthest_ss4_saccade,'--r',t_vector_saccade,below_furthest_ss8_saccade,'--g','linewidth',2)
            legend('Above-ss2','Above-ss4','Above-ss8','Below-ss2','Below-ss4','Below-ss8','location','southeast')
            ylim([minval maxval])
            xlim([t_vector_saccade(1) t_vector_saccade(end)])
            title('Furthest','fontweight','bold')


            [ax,h2] = suplabel(['nSS2 = ' mat2str(n_ss2) ' nSS4 = ' mat2str(n_ss4) ' nSS8 = ' mat2str(n_ss8)],'y');
            set(h2,'FontSize',12,'FontWeight','bold')
            [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
            set(h3,'FontSize',12,'FontWeight','bold')



            if pdfFlag == 1
                %Print PDF
        %        eval(['print -dpdf ',q,'//scratch/heitzrp/Output/set_size_saccade/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_set_size_sacc_reg.pdf',q])
                %Print JPG w/ 0% compression
                eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/set_size_saccade/reg/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_set_size_sacc_reg.jpg',q])
            end

            close all
        end


        %==================================================================
        %==================================================================
        %Figure 7: Homogeneous vs. non-homogeneous, target-aligned
        if homog_skip ~= 1
            figure
            orient landscape
            %use 'painters' renderer so that lines will show up
            set(gcf,'renderer','painters')
            set(gcf,'Color','white')

            %Plot homogeneous JPSTC
            subplot(4,8,[1:4 9:12])
            surface(JPSTC_correct_homo,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-50:100:400)
            set(gca,'YTickLabel',[])
            %set(gca,'YTickLabel',-50:100:400)

            %Plot lines marking target onset time
            line([0 450],[50 50],'color','k','linewidth',2)
            line([50 50],[0 450],'color','k','linewidth',2)

            %Plot boxes around areas to average

            %above, furthest
            line([52 64],[130 118],'color','g')
            line([52 302],[130 380],'color','g')
            line([302 314],[380 368],'color','g')
            line([64 314],[118 368],'color','g')

            %above, far
            line([65 77],[117 105],'color','r')
            line([65 315],[117 367],'color','r')
            line([315 327],[367 355],'color','r')
            line([77 327],[105 355],'color','r')

            %above, close
            line([78 90],[104 92],'color','b')
            line([78 328],[104 354],'color','b')
            line([328 340],[354 342],'color','b')
            line([90 340],[92 342],'color','b')

            %below, close
            line([92 104],[90 78],'color','b','linestyle','--')
            line([92 342],[90 340],'color','b','linestyle','--')
            line([342 354],[340 328],'color','b','linestyle','--')
            line([104 354],[78 328],'color','b','linestyle','--')

            %below, far
            line([105 117],[77 65],'color','r','linestyle','--')
            line([105 355],[77 327],'color','r','linestyle','--')
            line([355 367],[327 315],'color','r','linestyle','--')
            line([117 367],[65 315],'color','r','linestyle','--')

            %below, furthest
            line([118 130],[64 52],'color','g','linestyle','--')
            line([118 368],[64 314],'color','g','linestyle','--')
            line([368 380],[314 302],'color','g','linestyle','--')
            line([130 380],[52 302],'color','g','linestyle','--')

            %thickdiagonal
            line([52 130],[128 49],'color','k','linewidth',2)
            line([52 302],[128 383],'color','k','linewidth',2)
            line([302 383],[381 304],'color','k','linewidth',2)
            line([130 381],[49 304],'color','k','linewidth',2)

            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' -Homogeneous'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')

            %Plot non-homogeneous JPSTC
            subplot(4,8,[5:8 13:16])
            surface(JPSTC_correct_hete,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-50:100:400)
            set(gca,'YTickLabel',[])
            line([0 450],[50 50],'color','k','linewidth',2)
            line([50 50],[0 450],'color','k','linewidth',2)
            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' -Non-homogeneous'],'fontweight','bold')



            %Plot sig1 vs sig2
            subplot(4,8,17:20)
            plot(plottime,wf_sig1_correct_homo,'b',plottime,wf_sig1_correct_hete,'--b','linewidth',2)
            ylim([min(min(wf_sig1_correct_homo),min(wf_sig1_correct_hete)) max(max(wf_sig1_correct_homo),max(wf_sig1_correct_hete))])
            xlim([-50 400])
            ylabel('mV','fontweight','bold')
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,1))) ' Homo'],[cell2mat(chanlist(pairings(pair,1))) ' Hete'])

            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold
            plot(plottime,wf_sig2_correct_homo,'r',plottime,wf_sig2_correct_hete,'--r','linewidth',2)
            ylim([min(min(wf_sig2_correct_homo),min(wf_sig2_correct_hete)) max(max(wf_sig2_correct_homo),max(wf_sig2_correct_hete))])
            xlim([-50 400])
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,2))) ' Homo'],[cell2mat(chanlist(pairings(pair,2))) ' Hete'],'location','southeast')
            title('Mean Signals','fontweight','bold')


            %Plot FFTs
            %only plot FFTs for correct trials; likely to be the same, yet
            %attenuated, for homogeneous or heterogeneous trials simply because
            %there are fewer of them
            subplot(4,8,25:26)
            plot(freq(5:end),FFT_correct_1(5:end),'b','linewidth',1)
            xlim([10 80])
            ylabel('Power','fontweight','bold')
            xlabel('Time','fontweight','bold')
            set(gca,'ytick',[])
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold;
            plot(freq(5:end),FFT_correct_2(5:end),'r','linewidth',1)
            xlim([10 80])
            xlabel('Time','fontweight','bold')
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
            title('FFT (All Correct Trials)','fontweight','bold')


            %Plot Correlogram
            subplot(4,8,21:24)
            plot(lags,mean(cor_correct_homo),'b',lags,mean(cor_correct_hete),'r','linewidth',2)
            legend('Homo','Hete')
            xlabel('Lag','fontweight','bold')
            set(gca,'YAxisLocation','right')
            ylabel('Correlation','fontweight','bold')
            title('Correlogram','fontweight','bold')

            %Plot Off-diagonal averages

            %find global min and max so can compare across plots
            minvals(1) = min(above_close_homo);      maxvals(1) = max(above_close_homo);
            minvals(2) = min(above_far_homo);        maxvals(2) = max(above_far_homo);
            minvals(3) = min(above_furthest_homo);   maxvals(3) = max(above_furthest_homo);
            minvals(4) = min(below_close_homo);      maxvals(4) = max(below_close_homo);
            minvals(5) = min(below_far_homo);        maxvals(5) = max(below_far_homo);
            minvals(6) = min(below_furthest_homo);   maxvals(6) = max(below_furthest_homo);
            minvals(7) = min(above_close_hete);      maxvals(7) = max(above_close_hete);
            minvals(8) = min(above_far_hete);        maxvals(8) = max(above_far_hete);
            minvals(9) = min(above_furthest_hete);   maxvals(9) = max(above_furthest_hete);
            minvals(10) = min(below_close_hete);      maxvals(10) = max(below_close_hete);
            minvals(11) = min(below_far_hete);        maxvals(11) = max(below_far_hete);
            minvals(12) = min(below_furthest_hete);   maxvals(12) = max(below_furthest_hete);

            minval = min(minvals);
            maxval = max(maxvals);


            %close
            subplot(4,8,27:28)
            plot(t_vector,above_close_homo,'b',t_vector,above_close_hete,'r',t_vector,below_close_homo,'--b',t_vector,below_close_hete,'--r','linewidth',2)
            %legend('Above Homo','Above Hete','Below Homo','Below Hete','location','southeast')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Close','fontweight','bold')
            %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])

            %far
            subplot(4,8,29:30)
            plot(t_vector,above_far_homo,'b',t_vector,above_far_hete,'r',t_vector,below_far_homo,'--b',t_vector,below_far_hete,'--r','linewidth',2)
            %legend('Above Homo','Above Hete','Below Homo','Below Hete','location','southeast')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Far','fontweight','bold')

            %furthest
            subplot(4,8,31:32)
            plot(t_vector,above_furthest_homo,'b',t_vector,above_furthest_hete,'r',t_vector,below_furthest_homo,'--b',t_vector,below_furthest_hete,'--r','linewidth',2)
            legend('Above Homo','Above Hete','Below Homo','Below Hete','location','southeast')
            ylim([minval maxval])
            xlim([t_vector(1) t_vector(end)])
            title('Furthest','fontweight','bold')

            [ax,h2] = suplabel(['nHomo = ' mat2str(n_homo) ' nHete = ' mat2str(n_hete)],'y');
            set(h2,'FontSize',12,'FontWeight','bold')
            [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
            set(h3,'FontSize',12,'FontWeight','bold')

            if pdfFlag == 1
                %Print PDF
         %       eval(['print -dpdf ',q,'//scratch/heitzrp/Output/homog/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_homog_targ_reg.pdf',q])
                %Print JPG w/ 0% compression
                eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/homog/reg/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_homog_targ_reg.jpg',q])
            end

            close all
        end

        %==================================================================
        %==================================================================
        %Figure 8: Homogeneous vs. non-homogeneous, saccade-aligned
        if homog_skip ~= 1
            figure
            orient landscape
            %use 'painters' renderer so that lines will show up
            set(gcf,'renderer','painters')
            set(gcf,'Color','white')

            %Plot homogeneous JPSTC
            subplot(4,8,[1:4 9:12])
            surface(JPSTC_correct_homo_saccade,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-400:100:50)
            set(gca,'YTickLabel',[])
            %set(gca,'YTickLabel',-50:100:400)

            %Plot lines marking target onset time
            line([400 400],[0 450],'color','k','linewidth',2)
            line([0 450],[400 400],'color','k','linewidth',2)

            %Plot boxes around areas to average

            %above, furthest
            line([52 64],[130 118],'color','g')
            line([52 302],[130 380],'color','g')
            line([302 314],[380 368],'color','g')
            line([64 314],[118 368],'color','g')

            %above, far
            line([65 77],[117 105],'color','r')
            line([65 315],[117 367],'color','r')
            line([315 327],[367 355],'color','r')
            line([77 327],[105 355],'color','r')

            %above, close
            line([78 90],[104 92],'color','b')
            line([78 328],[104 354],'color','b')
            line([328 340],[354 342],'color','b')
            line([90 340],[92 342],'color','b')

            %below, close
            line([92 104],[90 78],'color','b','linestyle','--')
            line([92 342],[90 340],'color','b','linestyle','--')
            line([342 354],[340 328],'color','b','linestyle','--')
            line([104 354],[78 328],'color','b','linestyle','--')

            %below, far
            line([105 117],[77 65],'color','r','linestyle','--')
            line([105 355],[77 327],'color','r','linestyle','--')
            line([355 367],[327 315],'color','r','linestyle','--')
            line([117 367],[65 315],'color','r','linestyle','--')

            %below, furthest
            line([118 130],[64 52],'color','g','linestyle','--')
            line([118 368],[64 314],'color','g','linestyle','--')
            line([368 380],[314 302],'color','g','linestyle','--')
            line([130 380],[52 302],'color','g','linestyle','--')

            %thickdiagonal
            line([52 130],[128 49],'color','k','linewidth',2)
            line([52 302],[128 383],'color','k','linewidth',2)
            line([302 383],[381 304],'color','k','linewidth',2)
            line([130 381],[49 304],'color','k','linewidth',2)

            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' -Homogeneous'],'fontweight','bold')
            ylabel(cell2mat(chanlist(pairings(pair,2))),'fontweight','bold')

            %Plot non-homogeneous JPSTC
            subplot(4,8,[5:8 13:16])
            surface(JPSTC_correct_hete_saccade,'edgecolor','none')
            axis([0 450 0 450])
            set(gca,'XTick',0:100:450)
            set(gca,'YTick',0:100:450)
            set(gca,'XTickLabel',-400:100:50)
            set(gca,'YTickLabel',[])
            line([400 400],[0 450],'color','k','linewidth',2)
            line([0 450],[400 400],'color','k','linewidth',2)
            colorbar('East')
            title([cell2mat(chanlist(pairings(pair,1))) ' -Non-homogeneous'],'fontweight','bold')


            %Plot sig1 vs sig2
            subplot(4,8,17:20)
            plot(plottime_saccade,wf_sig1_correct_homo_saccade,'b',plottime_saccade,wf_sig1_correct_hete_saccade,'--b','linewidth',2)
            ylim([min(min(wf_sig1_correct_homo_saccade),min(wf_sig1_correct_hete_saccade)) max(max(wf_sig1_correct_homo_saccade),max(wf_sig1_correct_hete_saccade))])
            xlim([-400 50])
            ylabel('mV','fontweight','bold')
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,1))) ' Homo'],[cell2mat(chanlist(pairings(pair,1))) ' Hete'])

            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold
            plot(plottime_saccade,wf_sig2_correct_homo_saccade,'r',plottime_saccade,wf_sig2_correct_hete_saccade,'--r','linewidth',2)
            ylim([min(min(wf_sig2_correct_homo_saccade),min(wf_sig2_correct_hete_saccade)) max(max(wf_sig2_correct_homo_saccade),max(wf_sig2_correct_hete_saccade))])
            xlim([-400 50])
            set(gca,'ytick',[])
            legend([cell2mat(chanlist(pairings(pair,2))) ' Homo'],[cell2mat(chanlist(pairings(pair,2))) ' Hete'],'location','southeast')
            title('Mean Signals','fontweight','bold')


            %Plot FFTs
            %only plot FFTs for correct trials; likely to be the same, yet
            %attenuated, for homogeneous or heterogeneous trials simply because
            %there are fewer of them
            subplot(4,8,25:26)
            plot(freq(5:end),FFT_correct_1_saccade(5:end),'b','linewidth',1)
            xlim([10 80])
            ylabel('Power','fontweight','bold')
            xlabel('Time','fontweight','bold')
            set(gca,'ytick',[])
            ax1 = gca;
            ax2 = axes('Position',get(ax1,'Position'),'YAxisLocation','right','XAxisLocation','top','Color','none');
            hold;
            plot(freq(5:end),FFT_correct_2_saccade(5:end),'r','linewidth',1)
            xlim([10 80])
            xlabel('Time','fontweight','bold')
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            hold off
            title('FFT (All Correct Trials, Saccade-aligned)','fontweight','bold')


            %Plot Correlogram
            subplot(4,8,21:24)
            plot(lags,mean(cor_correct_homo_saccade),'b',lags,mean(cor_correct_hete_saccade),'r','linewidth',2)
            legend('Homo','Hete')
            xlabel('Lag','fontweight','bold')
            set(gca,'YAxisLocation','right')
            ylabel('Correlation','fontweight','bold')
            title('Correlogram','fontweight','bold')

            %Plot Off-diagonal averages
            %find global min and max so can compare across plots
            minvals(1) = min(above_close_homo_saccade);      maxvals(1) = max(above_close_homo_saccade);
            minvals(2) = min(above_far_homo_saccade);        maxvals(2) = max(above_far_homo_saccade);
            minvals(3) = min(above_furthest_homo_saccade);   maxvals(3) = max(above_furthest_homo_saccade);
            minvals(4) = min(below_close_homo_saccade);      maxvals(4) = max(below_close_homo_saccade);
            minvals(5) = min(below_far_homo_saccade);        maxvals(5) = max(below_far_homo_saccade);
            minvals(6) = min(below_furthest_homo_saccade);   maxvals(6) = max(below_furthest_homo_saccade);
            minvals(7) = min(above_close_hete_saccade);      maxvals(7) = max(above_close_hete_saccade);
            minvals(8) = min(above_far_hete_saccade);        maxvals(8) = max(above_far_hete_saccade);
            minvals(9) = min(above_furthest_hete_saccade);   maxvals(9) = max(above_furthest_hete_saccade);
            minvals(10) = min(below_close_hete_saccade);     maxvals(10) = max(below_close_hete_saccade);
            minvals(11) = min(below_far_hete_saccade);       maxvals(11) = max(below_far_hete_saccade);
            minvals(12) = min(below_furthest_hete_saccade);  maxvals(12) = max(below_furthest_hete_saccade);

            minval = min(minvals);
            maxval = max(maxvals);


            %close
            subplot(4,8,27:28)
            plot(t_vector_saccade,above_close_homo_saccade,'b',t_vector_saccade,above_close_hete_saccade,'r',t_vector_saccade,below_close_homo_saccade,'--b',t_vector_saccade,below_close_hete_saccade,'--r','linewidth',2)
            %legend('Above Homo','Above Hete','Below Homo','Below Hete','location','southeast')
            ylim([minval maxval])
            xlim([t_vector_saccade(1) t_vector_saccade(end)])
            title('Close','fontweight','bold')
            %ylim([min(min(min(above_far_correct),min(above_furthest_correct)),min(min(above_close_correct),min(main_correct))) max(max(max(above_far_correct),max(above_furthest_correct)),max(max(above_close_correct),max(main_correct)))])

            %far
            subplot(4,8,29:30)
            plot(t_vector_saccade,above_far_homo_saccade,'b',t_vector_saccade,above_far_hete_saccade,'r',t_vector_saccade,below_far_homo_saccade,'--b',t_vector_saccade,below_far_hete_saccade,'--r','linewidth',2)
            %legend('Above Homo','Above Hete','Below Homo','Below Hete','location','southeast')
            ylim([minval maxval])
            xlim([t_vector_saccade(1) t_vector_saccade(end)])
            title('Far','fontweight','bold')

            %furthest
            subplot(4,8,31:32)
            plot(t_vector_saccade,above_furthest_homo_saccade,'b',t_vector_saccade,above_furthest_hete_saccade,'r',t_vector_saccade,below_furthest_homo_saccade,'--b',t_vector_saccade,below_furthest_hete_saccade,'--r','linewidth',2)
            legend('Above Homo','Above Hete','Below Homo','Below Hete','location','southeast')
            ylim([minval maxval])
            xlim([t_vector_saccade(1) t_vector_saccade(end)])
            title('Furthest','fontweight','bold')

            [ax,h2] = suplabel(['nHomo = ' mat2str(n_homo) ' nHete = ' mat2str(n_hete)],'y');
            set(h2,'FontSize',12,'FontWeight','bold')
            [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
            set(h3,'FontSize',12,'FontWeight','bold')


            if pdfFlag == 1
                %Print PDF
         %       eval(['print -dpdf ',q,'//scratch/heitzrp/Output/homog_saccade/reg/PDF/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_homog_sacc_reg.pdf',q])
                %Print JPG w/ 0% compression
                eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/homog_saccade/reg/JPG/',file,'_',[cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_homog_sacc_reg.jpg',q])
            end

            close all
        end

    end %for current pair

    %clean up variables that will change between comparisons for safety
    clear JPSTC_correct JPSTC_correct_saccade JPSTC_errors ...
        JPSTC_errors_saccade shift_predictor JPSTC_correct_ss2 ...
        JPSTC_correct_ss2_saccade JPSTC_correct_ss4 JPSTC_correct_ss4_saccade ...
        JPSTC_correct_ss8 JPSTC_correct_ss8_saccade JPSTC_correct_homo ...
        JPSTC_correct_homo_saccade JPSTC_correct_hete JPSTC_correct_hete_saccade ...
        cor_correct cor_correct_saccade cor_errors cor_errors_saccade cor_correct_ss2 ...
        cor_correct_ss2_saccade cor_correct_ss4 cor_correct_ss4_saccade ...
        cor_correct_ss8 cor_correct_ss8_saccade cor_correct_homo ...
        cor_correct_homo_saccade cor_correct_hete cor_correct_hete_saccade ...
        wf_sig1_correct wf_sig1_correct_saccade wf_sig1_errors wf_sig1_errors_saccade ...
        wf_sig1_correct_ss2 wf_sig1_correct_ss2_saccade wf_sig1_correct_ss4 ...
        wf_sig1_correct_ss4_saccade wf_sig1_correct_ss8 wf_sig1_correct_ss8_saccade ...
        wf_sig1_correct_homo wf_sig1_correct_homo_saccade wf_sig1_correct_hete ...
        wf_sig1_correct_hete_saccade wf_sig2_correct wf_sig2_correct_saccade ...
        wf_sig2_errors_saccade wf_sig2_errors_saccade wf_sig2_correct_ss2 ...
        wf_sig2_correct_ss2_saccade wf_sig2_correct_ss4 wf_sig2_correct_ss4_saccade ...
        wf_sig2_correct_ss8 wf_sig2_correct_ss8_saccade wf_sig2_correct_homo ...
        wf_sig2_correct_homo_saccade wf_sig2_correct_hete wf_sig2_correct_hete_saccade ...
        n_correct n_errors n_ss2 n_ss4 n_ss8 n_homo n_hete correct errors ...
        ss2 ss4 ss8 homo hete minvals maxvals minval maxval ...
        freq FFT_correct_1 FFT_correct_2 FFT_errors_1 FFT_errors_2 ...
        FFT_correct_ss2_1 FFT_correct_ss2_2 FFT_correct_ss4_1 FFT_correct_ss4_2 ...
        FFT_correct_ss8_1 FFT_correct_ss8_2 FFT_correct_homo_1 FFT_correct_homo_2 ...
        FFT_correct_hete_1 FFT_correct_hete_2 ...
        FFT_correct_1_saccade FFT_correct_2_saccade FFT_errors_1_saccade FFT_errors_2_saccade ...
        FFT_correct_ss2_1_saccade FFT_correct_ss2_2_saccade FFT_correct_ss4_1_saccade ...
        FFT_correct_ss4_2_saccade FFT_correct_ss8_1_saccade FFT_correct_ss8_2_saccade ...
        FFT_correct_homo_1_saccade FFT_correct_homo_2_saccade FFT_correct_hete_1_saccade ...
        FFT_correct_hete_2_saccade t_vector t_vector_saccade above_furthest_correct ...
        above_far_correct above_close_correct main_correct below_close_correct ...
        below_far_correct below_furthest_correct above_furthest_errors above_far_errors ...
        above_close_errors main_errors below_close_errors below_far_errors ...
        below_furthest_errors above_furthest_ss2 above_far_ss2 above_close_ss2 ...
        main_ss2 below_close_ss2 below_far_ss2 below_furthest_ss2 above_furthest_ss4 ...
        above_far_ss4 above_close_ss4 main_ss4 below_close_ss4 below_far_ss4 ...
        below_furthest_ss4 above_furthest_ss8 above_far_ss8 above_close_ss8 ...
        main_ss8 below_close_ss8 below_far_ss8 below_furthest_ss8 above_furthest_homo ...
        above_far_homo above_close_homo main_homo below_close_homo below_far_homo ...
        below_furthest_homo above_furthest_hete above_far_hete above_close_hete ...
        main_hete below_close_hete below_far_hete below_furthest_hete ...
        above_furthest_correct_saccade ...
        above_far_correct_saccade above_close_correct_saccade main_correct_saccade below_close_correct_saccade ...
        below_far_correct_saccade below_furthest_correct_saccade above_furthest_errors_saccade above_far_errors_saccade ...
        above_close_errors_saccade main_errors_saccade below_close_errors_saccade below_far_errors_saccade ...
        below_furthest_errors_saccade above_furthest_ss2_saccade above_far_ss2_saccade above_close_ss2_saccade ...
        main_ss2_saccade below_close_ss2_saccade below_far_ss2_saccade below_furthest_ss2_saccade above_furthest_ss4_saccade ...
        above_far_ss4_saccade above_close_ss4_saccade main_ss4_saccade below_close_ss4_saccade below_far_ss4_saccade ...
        below_furthest_ss4_saccade above_furthest_ss8_saccade above_far_ss8_saccade above_close_ss8_saccade ...
        main_ss8_saccade below_close_ss8_saccade below_far_ss8_saccade below_furthest_ss8_saccade above_furthest_homo_saccade ...
        above_far_homo_saccade above_close_homo_saccade main_homo_saccade below_close_homo_saccade below_far_homo_saccade ...
        below_furthest_homo_saccade above_furthest_hete_saccade above_far_hete_saccade above_close_hete_saccade ...
        main_hete_saccade below_close_hete_saccade below_far_hete_saccade below_furthest_hete_saccade ...
        thickdiagonal_correct thickdiagonal_errors thickdiagonal_ss2 thickdiagonal_ss4 ...
        thickdiagonal_ss8 thickdiagonal_homo thickdiagonal_hete thickdiagonal_correct_saccade ...
        thickdiagonal_errors_saccade thickdiagonal_ss2_saccade thickdiagonal_ss4_saccade ...
        thickdiagonal_ss8_saccade thickdiagonal_homo_saccade thickdiagonal_hete_saccade error_skip set_size_skip homog_skip


end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes