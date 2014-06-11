% Joint Peri-stimulus time correlogram
% time-based correlation analysis for EEG-EEG, LFP-FLP, and LFP-EEG
% comparisons.

% (c) Richard P. Heitz, Vanderbilt 2008
% All rights reserved.

function [] = COHERENCE_vampire_reg_UBER(file)
tic
% path(path,'/home/heitzrp/Mat_Code/Common')
% path(path,'/home/heitzrp/Mat_Code/JPSTC')
% path(path,'/home/heitzrp/Data')
path(path,'//scratch/heitzrp/')
path(path,'//scratch/heitzrp/Data/')

plotFlag = 0;
pdfFlag = 0;
saveFlag = 1;
q = '''';
c = ',';
qcq = [q c q];


%find relevant channels in file
varlist = who('-file',file);
ADlist = cell2mat(varlist(strmatch('AD',varlist)));
%DSPlist = cell2mat(varlist(strmatch('DSP',varlist)));
clear varlist


ChanStruct = loadChan(file,'ALL');
chanlist = fieldnames(ChanStruct);
decodeChanStruct

%load Target_ & Correct_ variable
eval(['load(' q file qcq 'Hemi' qcq 'RFs' qcq 'newfile' qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq 'TrialStart_' qcq '-mat' q ')']);

%rename LFP channels for consistency

%Find all possible pairings of LFP channels
pairings = nchoosek(1:length(chanlist),2);


%Compute comparisons backwards so we get LFP correlations out first
for pair = size(pairings,1):-1:1
    disp(['Comparing... ' cell2mat(chanlist(pairings(pair,1))) ' vs ' cell2mat(chanlist(pairings(pair,2))) ' ... ' mat2str(length(pairings) - pair + 1) ' of ' mat2str(size(pairings,1))])
    
    
    
    fixErrors
    
    %====================================================
    % SET UP DATA
    %find relevant trials, exclude catch trials (255)
    
    %analyze: spectra and coherence for:
    % -all correct
    % -all errors
    % -fast and slow correct
    % -fast and slow errors
    % -correct set size 2 vs 4 vs 8
    % everything target aligned and response aligned
    
    %IMPORTANT NOTE:
    %if channels are not in the same hemisphere, use all screen locations
    %if in same hemisphere & are both AD, compare contra vs. ipsi
    %if in same hemisphere & one or both are DSP, compare T_in vs D_in
    
    %=====================================================================
    %=====================================================================
    % SET UP TRIALS
    
    % if both signals are AD channels...
    if strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('AD',chanlist(pairings(pair,2))) == 1
        varlist = who;
        all_chan = varlist(strmatch('AD',varlist));
        %if they are in the same hemisphere...
        if Hemi.(chanlist{pairings(pair,1)}) == Hemi.(chanlist{pairings(pair,2)});
            %check to see which hemisphere they both are in
            if Hemi.(chanlist{pairings(pair,1)}) == 'R'
                chan1_hemi = {'R'};
                chan2_hemi = {'R'};
                %for computing median, use all screen positions; do not limit
                %as we do in the below
                cMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
                
                correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[3 4 5]) == 1);
                %keep non-subsampled copy of 'correct' variable
                correct_nosub = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
                
                correct_contra = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[3 4 5]) == 1);
                correct_ipsi = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[7 0 1]) == 1);
                
                correct_fast = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < cMed & SRT(:,1) > 50 & ismember(Target_(:,2),[3 4 5]) == 1);
                correct_slow = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) <= 2000 & ismember(Target_(:,2),[3 4 5]) == 1);
                correct_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[3 4 5]) == 1);
                correct_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[3 4 5]) == 1);
                correct_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[3 4 5]) == 1);
                
                %for median, use all screen locations
                eMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
                
                errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[3 4 5]) == 1);
                errors_fast = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < eMed & SRT(:,1) > 50 & ismember(Target_(:,2),[3 4 5]) == 1);
                errors_slow = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) >= eMed & SRT(:,1) <= 2000 & ismember(Target_(:,2),[3 4 5]) == 1);
                
                %equate trial numbers
                %%%%%%%%%%%%%%%%%%%%%%%
                minTrials = min(length(correct),length(errors));
                correct = correct(randperm(minTrials));
                errors = errors(randperm(minTrials));
                
                minTrials = min(length(correct_contra),length(correct_ipsi));
                correct_contra = correct_contra(randperm(minTrials));
                correct_ipsi = correct_ipsi(randperm(minTrials));
                
                minTrials = min(length(correct_fast),length(correct_slow));
                correct_fast = correct_fast(randperm(minTrials));
                correct_slow = correct_slow(randperm(minTrials));
                
                minTrials = min(min(length(correct_ss2),length(correct_ss4)),length(correct_ss8));
                correct_ss2 = correct_ss2(randperm(minTrials));
                correct_ss4 = correct_ss4(randperm(minTrials));
                correct_ss8 = correct_ss8(randperm(minTrials));
                
                minTrials = min(length(errors_fast),length(errors_slow));
                errors_fast = errors_fast(randperm(minTrials));
                errors_slow = errors_slow(randperm(minTrials));
                %%%%%%%%%%%%%%%%%%%%%%%
                
            elseif Hemi.(chanlist{pairings(pair,1)}) == 'L'
                chan1_hemi = {'L'};
                chan2_hemi = {'L'};
                
                %for computing median, use all screen positions; do not limit
                %as we do in the below
                cMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
                
                correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[7 0 1]) == 1);
                %keep non-subsampled copy of 'correct' variable
                correct_nosub = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
                
                correct_contra = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[7 0 1]) == 1);
                correct_ipsi = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[3 4 5]) == 1);
                
                correct_fast = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < cMed & SRT(:,1) > 50 & ismember(Target_(:,2),[7 0 1]) == 1);
                correct_slow = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) <= 2000 & ismember(Target_(:,2),[7 0 1]) == 1);
                correct_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[7 0 1]) == 1);
                correct_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[7 0 1]) == 1);
                correct_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[7 0 1]) == 1);
                
                %for median, use all screen locations
                eMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
                
                errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),[7 0 1]) == 1);
                errors_fast = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < eMed & SRT(:,1) > 50 & ismember(Target_(:,2),[7 0 1]) == 1);
                errors_slow = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) >= eMed & SRT(:,1) <= 2000 & ismember(Target_(:,2),[7 0 1]) == 1);
                
                %equate trial numbers
                %%%%%%%%%%%%%%%%%%%%%%%
                minTrials = min(length(correct),length(errors));
                correct = correct(randperm(minTrials));
                errors = errors(randperm(minTrials));
                
                minTrials = min(length(correct_contra),length(correct_ipsi));
                correct_contra = correct_contra(randperm(minTrials));
                correct_ipsi = correct_ipsi(randperm(minTrials));
                
                minTrials = min(length(correct_fast),length(correct_slow));
                correct_fast = correct_fast(randperm(minTrials));
                correct_slow = correct_slow(randperm(minTrials));
                
                minTrials = min(min(length(correct_ss2),length(correct_ss4)),length(correct_ss8));
                correct_ss2 = correct_ss2(randperm(minTrials));
                correct_ss4 = correct_ss4(randperm(minTrials));
                correct_ss8 = correct_ss8(randperm(minTrials));
                
                minTrials = min(length(errors_fast),length(errors_slow));
                errors_fast = errors_fast(randperm(minTrials));
                errors_slow = errors_slow(randperm(minTrials));
                %%%%%%%%%%%%%%%%%%%%%%%
            end
            
        else %if both are AD channels but Hemisphere is not equal, use all target positions
            
            if Hemi.(chanlist{pairings(pair,1)}) == 'L'
                chan1_hemi = {'L'};
            elseif Hemi.(chanlist{pairings(pair,1)}) == 'R'
                chan1_hemi = {'R'};
            elseif Hemi.(chanlist{pairings(pair,1)}) == 'M'
                chan1_hemi = {'M'};
            end
            
            if Hemi.(chanlist{pairings(pair,1)}) == 'L'
                chan2_hemi = {'L'};
            elseif Hemi.(chanlist{pairings(pair,1)}) == 'R'
                chan2_hemi = {'R'};
            elseif Hemi.(chanlist{pairings(pair,1)}) == 'M'
                chan2_hemi = {'M'};
            end
            
            
            
            correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
            %keep non-subsampled 'correct' variable
            correct_nosub = correct;
            cMed = nanmedian(SRT(correct,1));
            correct_fast = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < cMed & SRT(:,1) > 50);
            correct_slow = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) <= 2000);
            correct_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
            correct_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
            correct_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
            
            errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
            eMed = nanmedian(SRT(errors,1));
            errors_fast = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < eMed & SRT(:,1) > 50);
            errors_slow = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) >= eMed & SRT(:,1) <= 2000);
            
            %equate trial numbers
            %%%%%%%%%%%%%%%%%%%%%%%
            minTrials = min(length(correct),length(errors));
            correct = correct(randperm(minTrials));
            errors = errors(randperm(minTrials));
            
            minTrials = min(length(correct_fast),length(correct_slow));
            correct_fast = correct_fast(randperm(minTrials));
            correct_slow = correct_slow(randperm(minTrials));
            
            minTrials = min(min(length(correct_ss2),length(correct_ss4)),length(correct_ss8));
            correct_ss2 = correct_ss2(randperm(minTrials));
            correct_ss4 = correct_ss4(randperm(minTrials));
            correct_ss8 = correct_ss8(randperm(minTrials));
            
            minTrials = min(length(errors_fast),length(errors_slow));
            errors_fast = errors_fast(randperm(minTrials));
            errors_slow = errors_slow(randperm(minTrials));
            
        end
        
        %if one channel is DSP and other is AD, do T_in vs D_in comparison.
        %if DSP channel does not have an RF, do not compute any
        %comparison (cell was unclassified because poor response, etc.)
    elseif strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        
        
        %%%%%%%%%%&&&&&&&&
        % Find Hemispheres
        varlist = who;
        all_chan = varlist(strmatch('AD',varlist));
        
        %when AD & DSP, chan 1 will always be the AD channel
        chan1_hemi = Hemi.(chanlist{pairings(pair,1)});
        chan2_hemi = Hemi.(chanlist{pairings(pair,2)});
        
        
        RF = RFs.(chanlist{pairings(pair,1)});
        
        if ~isempty(RF)
            AntiRF = getAntiRF(RF);
        end
        
        if isempty(RF)
            disp('1 or more empty RFs. Skipping...')
            continue
        else
            %are the hemispheres the same?
            if cell2mat(chan1_hemi) == cell2mat(chan2_hemi)
                
                %for computing median, use all screen positions; do not limit
                %as we do in the below
                cMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
                
                correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
                %keep non-subsampled copy of 'correct' variable
                correct_nosub = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
                
                correct_Tin = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
                correct_Din = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),AntiRF) == 1);
                
                correct_fast = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < cMed & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
                correct_slow = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) <= 2000 & ismember(Target_(:,2),RF) == 1);
                correct_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
                correct_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
                correct_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
                
                %for median, use all screen locations
                eMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
                
                errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
                errors_fast = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < eMed & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
                errors_slow = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) >= eMed & SRT(:,1) <= 2000 & ismember(Target_(:,2),RF) == 1);
                
                %equate trial numbers
                %%%%%%%%%%%%%%%%%%%%%%%
                minTrials = min(length(correct),length(errors));
                correct = correct(randperm(minTrials));
                errors = errors(randperm(minTrials));
                
                minTrials = min(length(correct_Tin),length(correct_Din));
                correct_Tin = correct_Tin(randperm(minTrials));
                correct_Din = correct_Din(randperm(minTrials));
                
                minTrials = min(length(correct_fast),length(correct_slow));
                correct_fast = correct_fast(randperm(minTrials));
                correct_slow = correct_slow(randperm(minTrials));
                
                minTrials = min(min(length(correct_ss2),length(correct_ss4)),length(correct_ss8));
                correct_ss2 = correct_ss2(randperm(minTrials));
                correct_ss4 = correct_ss4(randperm(minTrials));
                correct_ss8 = correct_ss8(randperm(minTrials));
                
                minTrials = min(length(errors_fast),length(errors_slow));
                errors_fast = errors_fast(randperm(minTrials));
                errors_slow = errors_slow(randperm(minTrials));
                
            else %hemispheres not the same; use all trials and do not compute Tin vs Din
                %for computing median, use all screen positions; do not limit
                %as we do in the below
                cMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
                
                correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
                %keep non-subsampled copy of 'correct' variable
                correct_nosub = correct;
                
                correct_fast = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < cMed & SRT(:,1) > 50);
                correct_slow = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) <= 2000);
                
                correct_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000);
                correct_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000);
                correct_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000);
                
                %for median, use all screen locations
                eMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
                
                errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
                errors_fast = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < eMed & SRT(:,1) > 50);
                errors_slow = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) >= eMed & SRT(:,1) <= 2000);
                
                %equate trial numbers
                %%%%%%%%%%%%%%%%%%%%%%%
                minTrials = min(length(correct),length(errors));
                correct = correct(randperm(minTrials));
                errors = errors(randperm(minTrials));
                
                minTrials = min(length(correct_fast),length(correct_slow));
                correct_fast = correct_fast(randperm(minTrials));
                correct_slow = correct_slow(randperm(minTrials));
                
                minTrials = min(min(length(correct_ss2),length(correct_ss4)),length(correct_ss8));
                correct_ss2 = correct_ss2(randperm(minTrials));
                correct_ss4 = correct_ss4(randperm(minTrials));
                correct_ss8 = correct_ss8(randperm(minTrials));
                
                minTrials = min(length(errors_fast),length(errors_slow));
                errors_fast = errors_fast(randperm(minTrials));
                errors_slow = errors_slow(randperm(minTrials));
                
            end
        end
        
        %both channels are Spikes; see if hemispheres are same and if so
        %compute Tin vs Din. Otherwise use all trials
    elseif strmatch('DSP',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        %%%%%%%%%%&&&&&&&&
        % Find Hemispheres
        
        chan1_hemi = Hemi.(chanlist{pairings(pair,1)});
        chan2_hemi = Hemi.(chanlist{pairings(pair,2)});
        
        
        RF_1 = RFs.(chanlist{pairings(pair,1)});
        RF_2 = RFs.(chanlist{pairings(pair,2)});
        
        %check for RF overlap. If overlap, use as new RF
        
        if isempty(RF_1) == 1 | isempty(RF_2) == 1
            %at least one neuron has no RF. Abort comparison
            disp('1 or more empty RFs. Skipping...')
            continue
            %is there an RF overlap?
        elseif ~isempty(intersect(RF_1,RF_2)) %yes there is RF overlap
            RF = intersect(RF_1,RF_2);
            AntiRF = getAntiRF(RF);
            
            %for computing median, use all screen positions; do not limit
            %as we do in the below
            cMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
            
            correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
            %keep non-subsampled copy of 'correct' variable
            correct_nosub = correct;
            
            correct_Tin = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
            correct_Din = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),AntiRF) == 1);
            
            correct_fast = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < cMed & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
            correct_slow = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) <= 2000 & ismember(Target_(:,2),RF) == 1);
            correct_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
            correct_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
            correct_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
            
            %for median, use all screen locations
            eMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
            
            errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
            errors_fast = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < eMed & SRT(:,1) > 50 & ismember(Target_(:,2),RF) == 1);
            errors_slow = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) >= eMed & SRT(:,1) <= 2000 & ismember(Target_(:,2),RF) == 1);
            
            %equate trial numbers
            %%%%%%%%%%%%%%%%%%%%%%%
            minTrials = min(length(correct),length(errors));
            correct = correct(randperm(minTrials));
            errors = errors(randperm(minTrials));
            
            minTrials = min(length(correct_Tin),length(correct_Din));
            correct_Tin = correct_Tin(randperm(minTrials));
            correct_Din = correct_Din(randperm(minTrials));
            
            minTrials = min(length(correct_fast),length(correct_slow));
            correct_fast = correct_fast(randperm(minTrials));
            correct_slow = correct_slow(randperm(minTrials));
            
            minTrials = min(min(length(correct_ss2),length(correct_ss4)),length(correct_ss8));
            correct_ss2 = correct_ss2(randperm(minTrials));
            correct_ss4 = correct_ss4(randperm(minTrials));
            correct_ss8 = correct_ss8(randperm(minTrials));
            
            minTrials = min(length(errors_fast),length(errors_slow));
            errors_fast = errors_fast(randperm(minTrials));
            errors_slow = errors_slow(randperm(minTrials));
            
        elseif isempty(intersect(RF_1,RF_2))
            %no overlap, use all trials, do not compute Tin vs Din
            %for computing median, use all screen positions; do not limit
            %as we do in the below
            cMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
            
            correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50);
            %keep non-subsampled copy of 'correct' variable
            correct_nosub = correct;
            
            correct_fast = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) < cMed & SRT(:,1) > 50);
            correct_slow = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) >= cMed & SRT(:,1) <= 2000);
            
            correct_ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000);
            correct_ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000);
            correct_ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000);
            
            %for median, use all screen locations
            eMed = nanmedian(SRT(find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < 2000 & SRT(:,1) > 50),1));
            
            errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) > 50);
            errors_fast = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) < eMed & SRT(:,1) > 50);
            errors_slow = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) >= eMed & SRT(:,1) <= 2000);
            
            %equate trial numbers
            %%%%%%%%%%%%%%%%%%%%%%%
            minTrials = min(length(correct),length(errors));
            correct = correct(randperm(minTrials));
            errors = errors(randperm(minTrials));
            
            minTrials = min(length(correct_fast),length(correct_slow));
            correct_fast = correct_fast(randperm(minTrials));
            correct_slow = correct_slow(randperm(minTrials));
            
            minTrials = min(min(length(correct_ss2),length(correct_ss4)),length(correct_ss8));
            correct_ss2 = correct_ss2(randperm(minTrials));
            correct_ss4 = correct_ss4(randperm(minTrials));
            correct_ss8 = correct_ss8(randperm(minTrials));
            
            minTrials = min(length(errors_fast),length(errors_slow));
            errors_fast = errors_fast(randperm(minTrials));
            errors_slow = errors_slow(randperm(minTrials));
        end
    end
    %======================================================================
    %======================================================================
    
    %===========================================
    % SAVE RTS FOR EACH CONDITION
    RTs.correct_nosub = SRT(correct_nosub,1);
    RTs.correct = SRT(correct,1);
    RTs.errors = SRT(errors,1);
    RTs.correct_fast = SRT(correct_fast,1);
    RTs.correct_slow = SRT(correct_slow,1);
    RTs.errors_fast = SRT(errors_fast,1);
    RTs.errors_slow = SRT(errors_slow,1);
    RTs.correct_ss2 = SRT(correct_ss2,1);
    RTs.correct_ss4 = SRT(correct_ss4,1);
    RTs.correct_ss8 = SRT(correct_ss8,1);
    %===========================================
    
    
    
    %==========================================================
    % GENERATE STARTING MATRICES FOR SIGNALS
    
    sig1_targ = eval(cell2mat(chanlist(pairings(pair,1))));
    sig2_targ = eval(cell2mat(chanlist(pairings(pair,2))));
    
    %Time-correction for spikes
    %if is an AD channel, can use response_align script.
    %otherwise, is a DSP channel and must response align using SRT.
    if strmatch('AD',chanlist(pairings(pair,1))) == 1
        sig1_resp = response_align(sig1_targ,SRT,[-600 300]);
    else
        sig1_targ(find(sig1_targ == 0)) = NaN;
        
        %create correction factors. For target aligned, subtract matrix of
        %500's.  For response align, subtract matrix of SRT + 500.
        targ_correction = repmat(500,size(sig1_targ,1),size(sig1_targ,2));
        resp_correction = repmat(SRT(:,1),1,size(sig1_targ,2)) + 500;
        
        sig1_resp = sig1_targ - resp_correction;
        %below correction MUST be done 2nd
        sig1_targ = sig1_targ - targ_correction;
        
        clear targ_correction resp_correction
    end
    
    if strmatch('AD',chanlist(pairings(pair,2))) == 1
        sig2_resp = response_align(sig2_targ,SRT,[-600 300]);
    else
        sig2_targ(find(sig2_targ == 0)) = NaN;
        
        targ_correction = repmat(500,size(sig2_targ,1),size(sig2_targ,2));
        resp_correction = repmat(SRT(:,1),1,size(sig2_targ,2)) + 500;
        
        sig2_resp = sig2_targ - resp_correction;
        %below correction MUST be done 2nd
        sig2_targ = sig2_targ - targ_correction;
        
        clear targ_correction resp_correction
    end
    %===========================================================
    
    
    
    
    %=======================================================
    % SET UP NONDEPENDENT SIGNALS
    % Sig 1, target-aligned
    sig1_correct_targ_nosub = sig1_targ(correct_nosub,:);
    sig1_correct_targ = sig1_targ(correct,:);
    sig1_correct_targ_fast = sig1_targ(correct_fast,:);
    sig1_correct_targ_slow = sig1_targ(correct_slow,:);
    sig1_correct_targ_ss2 = sig1_targ(correct_ss2,:);
    sig1_correct_targ_ss4 = sig1_targ(correct_ss4,:);
    sig1_correct_targ_ss8 = sig1_targ(correct_ss8,:);
    sig1_errors_targ = sig1_targ(errors,:);
    sig1_errors_targ_fast = sig1_targ(errors_fast,:);
    sig1_errors_targ_slow = sig1_targ(errors_slow,:);
    
    % Sig 1, response-aligned
    sig1_correct_resp_nosub = sig1_resp(correct_nosub,:);
    sig1_correct_resp = sig1_resp(correct,:);
    sig1_correct_resp_fast = sig1_resp(correct_fast,:);
    sig1_correct_resp_slow = sig1_resp(correct_slow,:);
    sig1_correct_resp_ss2 = sig1_resp(correct_ss2,:);
    sig1_correct_resp_ss4 = sig1_resp(correct_ss4,:);
    sig1_correct_resp_ss8 = sig1_resp(correct_ss8,:);
    sig1_errors_resp = sig1_resp(errors,:);
    sig1_errors_resp_fast = sig1_resp(errors_fast,:);
    sig1_errors_resp_slow = sig1_resp(errors_slow,:);
    
    % Sig 2, target-aligned
    sig2_correct_targ_nosub = sig2_targ(correct_nosub,:);
    sig2_correct_targ = sig2_targ(correct,:);
    sig2_correct_targ_fast = sig2_targ(correct_fast,:);
    sig2_correct_targ_slow = sig2_targ(correct_slow,:);
    sig2_correct_targ_ss2 = sig2_targ(correct_ss2,:);
    sig2_correct_targ_ss4 = sig2_targ(correct_ss4,:);
    sig2_correct_targ_ss8 = sig2_targ(correct_ss8,:);
    sig2_errors_targ = sig2_targ(errors,:);
    sig2_errors_targ_fast = sig2_targ(errors_fast,:);
    sig2_errors_targ_slow = sig2_targ(errors_slow,:);
    
    % Sig 2, response-aligned
    sig2_correct_resp_nosub = sig2_resp(correct_nosub,:);
    sig2_correct_resp = sig2_resp(correct,:);
    sig2_correct_resp_fast = sig2_resp(correct_fast,:);
    sig2_correct_resp_slow = sig2_resp(correct_slow,:);
    sig2_correct_resp_ss2 = sig2_resp(correct_ss2,:);
    sig2_correct_resp_ss4 = sig2_resp(correct_ss4,:);
    sig2_correct_resp_ss8 = sig2_resp(correct_ss8,:);
    sig2_errors_resp = sig2_resp(errors,:);
    sig2_errors_resp_fast = sig2_resp(errors_fast,:);
    sig2_errors_resp_slow = sig2_resp(errors_slow,:);
    
    
    
    % SET UP DEPENDENT SIGNALS
    %========================================================
    if exist('correct_Tin') == 1
        sig1_correct_targ_Tin = sig1_targ(correct_Tin,:);
        sig1_correct_resp_Tin = sig1_resp(correct_Tin,:);
        sig2_correct_targ_Tin = sig2_targ(correct_Tin,:);
        sig2_correct_resp_Tin = sig2_resp(correct_Tin,:);
        
        sig1_correct_targ_Din = sig1_targ(correct_Din,:);
        sig1_correct_resp_Din = sig1_resp(correct_Din,:);
        sig2_correct_targ_Din = sig2_targ(correct_Din,:);
        sig2_correct_resp_Din = sig2_resp(correct_Din,:);
    end
    
    if exist('correct_contra') == 1
        sig1_correct_targ_contra = sig1_targ(correct_contra,:);
        sig1_correct_resp_contra = sig1_resp(correct_contra,:);
        sig2_correct_targ_contra = sig2_targ(correct_contra,:);
        sig2_correct_resp_contra = sig2_resp(correct_contra,:);
        
        sig1_correct_targ_ipsi = sig1_targ(correct_ipsi,:);
        sig1_correct_resp_ipsi = sig1_resp(correct_ipsi,:);
        sig2_correct_targ_ipsi = sig2_targ(correct_ipsi,:);
        sig2_correct_resp_ipsi = sig2_resp(correct_ipsi,:);
    end
    %========================================================
    
    
    
    %========================================================
    % Spectra and coherence can't handle NaNs so need to remove from
    % response-aligned signals.
    % Only need to do it for AD channels (spike channels will not have NaNs
    % but instead 0's
    % BUT Because both signals must have same trials, have to eliminate
    % them from both.  Run it on Sig2 first (using sig1 to find the NaNs)
    % because when computing AD-Spike coherence, need to make sure Spikes
    % have same trials removed.  Have to use sig1 in this case because sig2
    % won't have any NaNs.
    
    if strmatch('AD',chanlist(pairings(pair,1))) == 1
        %for cases shen the Spike channel is 2nd, this will eliminate same
        %trials. Note that are indexing sig1 but holding it in sig2
        
        %Need to run this in reverse order because otherwise, signal would
        %already be changed and not contain any NaNs
        sig2_correct_resp_nosub(any(isnan(sig1_correct_resp_nosub)'),:) = [];
        sig2_correct_resp(any(isnan(sig1_correct_resp)'),:) = [];
        sig2_correct_resp_fast(any(isnan(sig1_correct_resp_fast)'),:) = [];
        sig2_correct_resp_slow(any(isnan(sig1_correct_resp_slow)'),:) = [];
        sig2_correct_resp_ss2(any(isnan(sig1_correct_resp_ss2)'),:) = [];
        sig2_correct_resp_ss4(any(isnan(sig1_correct_resp_ss4)'),:) = [];
        sig2_correct_resp_ss8(any(isnan(sig1_correct_resp_ss8)'),:) = [];
        sig2_errors_resp(any(isnan(sig1_errors_resp)'),:) = [];
        sig2_errors_resp_fast(any(isnan(sig1_errors_resp_fast)'),:) = [];
        sig2_errors_resp_slow(any(isnan(sig1_errors_resp_slow)'),:) = [];
        
        sig1_correct_resp_nosub(any(isnan(sig1_correct_resp_nosub)'),:) = [];
        sig1_correct_resp(any(isnan(sig1_correct_resp)'),:) = [];
        sig1_correct_resp_fast(any(isnan(sig1_correct_resp_fast)'),:) = [];
        sig1_correct_resp_slow(any(isnan(sig1_correct_resp_slow)'),:) = [];
        sig1_correct_resp_ss2(any(isnan(sig1_correct_resp_ss2)'),:) = [];
        sig1_correct_resp_ss4(any(isnan(sig1_correct_resp_ss4)'),:) = [];
        sig1_correct_resp_ss8(any(isnan(sig1_correct_resp_ss8)'),:) = [];
        sig1_errors_resp(any(isnan(sig1_errors_resp)'),:) = [];
        sig1_errors_resp_fast(any(isnan(sig1_errors_resp_fast)'),:) = [];
        sig1_errors_resp_slow(any(isnan(sig1_errors_resp_slow)'),:) = [];
        
        if exist('correct_Tin') == 1
            sig2_correct_resp_Tin(any(isnan(sig1_correct_resp_Tin)'),:) = [];
            sig2_correct_resp_Din(any(isnan(sig1_correct_resp_Din)'),:) = [];
            sig1_correct_resp_Tin(any(isnan(sig1_correct_resp_Tin)'),:) = [];
            sig1_correct_resp_Din(any(isnan(sig1_correct_resp_Din)'),:) = [];
        end
        
        if exist('correct_contra') == 1
            sig2_correct_resp_contra(any(isnan(sig1_correct_resp_contra)'),:) = [];
            sig2_correct_resp_ipsi(any(isnan(sig1_correct_resp_ipsi)'),:) = [];
            sig1_correct_resp_contra(any(isnan(sig1_correct_resp_contra)'),:) = [];
            sig1_correct_resp_ipsi(any(isnan(sig1_correct_resp_ipsi)'),:) = [];
        end
    end
    
    %===============================================================
    
    
    
    
    
    
    %=========================================================
    % Keep track of average waveforms
    % If AD channel, take mean
    % If Spike channel, get SDF (note: we cannot use the sigx_resp variable
    % because it has been modified.  Use sigx_targ with Align_Time
    
    if strmatch('AD',chanlist(pairings(pair,1))) == 1
        wf_sig1_targ.correct_nosub = nanmean(sig1_correct_targ_nosub,1);
        wf_sig1_targ.correct = nanmean(sig1_correct_targ,1);
        wf_sig1_targ.correct_fast = nanmean(sig1_correct_targ_fast,1);
        wf_sig1_targ.correct_slow = nanmean(sig1_correct_targ_slow,1);
        wf_sig1_targ.correct_ss2 = nanmean(sig1_correct_targ_ss2,1);
        wf_sig1_targ.correct_ss4 = nanmean(sig1_correct_targ_ss4,1);
        wf_sig1_targ.correct_ss8 = nanmean(sig1_correct_targ_ss8,1);
        wf_sig1_targ.errors = nanmean(sig1_errors_targ,1);
        wf_sig1_targ.errors_fast = nanmean(sig1_errors_targ_fast,1);
        wf_sig1_targ.errors_slow = nanmean(sig1_errors_targ_slow,1);
        
        wf_sig1_resp.correct_nosub = nanmean(sig1_correct_resp_nosub,1);
        wf_sig1_resp.correct = nanmean(sig1_correct_resp,1);
        wf_sig1_resp.correct_fast = nanmean(sig1_correct_resp_fast,1);
        wf_sig1_resp.correct_slow = nanmean(sig1_correct_resp_slow,1);
        wf_sig1_resp.correct_ss2 = nanmean(sig1_correct_resp_ss2,1);
        wf_sig1_resp.correct_ss4 = nanmean(sig1_correct_resp_ss4,1);
        wf_sig1_resp.correct_ss8 = nanmean(sig1_correct_resp_ss8,1);
        wf_sig1_resp.errors = nanmean(sig1_errors_resp,1);
        wf_sig1_resp.errors_fast = nanmean(sig1_errors_resp_fast,1);
        wf_sig1_resp.errors_slow = nanmean(sig1_errors_resp_slow,1);
        
        if exist('correct_Tin') == 1
            wf_sig1_targ.correct_Tin = nanmean(sig1_correct_targ_Tin,1);
            wf_sig1_targ.correct_Din = nanmean(sig1_correct_targ_Din,1);
            wf_sig1_resp.correct_Tin = nanmean(sig1_correct_resp_Tin,1);
            wf_sig1_resp.correct_Din = nanmean(sig1_correct_resp_Din,1);
        end
        
        if exist('correct_contra') == 1
            wf_sig1_targ.correct_contra = nanmean(sig1_correct_targ_contra,1);
            wf_sig1_targ.correct_ipsi = nanmean(sig1_correct_targ_ipsi,1);
            wf_sig1_resp.correct_contra = nanmean(sig1_correct_resp_contra,1);
            wf_sig1_resp.correct_ipsi = nanmean(sig1_correct_resp_ipsi,1);
        end
        
        
        
    else
        %already corrected spike times, so should align at 0
        Align_Time = zeros(length(Target_),1);
        Plot_Time = [-500 2500];
        
        wf_sig1_targ.correct_nosub = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_nosub, TrialStart_);
        wf_sig1_targ.correct = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct, TrialStart_);
        wf_sig1_targ.correct_fast = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_fast, TrialStart_);
        wf_sig1_targ.correct_slow = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_slow, TrialStart_);
        wf_sig1_targ.correct_ss2 = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_ss2, TrialStart_);
        wf_sig1_targ.correct_ss4 = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_ss4, TrialStart_);
        wf_sig1_targ.correct_ss8 = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_ss8, TrialStart_);
        wf_sig1_targ.errors = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, errors, TrialStart_);
        wf_sig1_targ.errors_fast = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, errors_fast, TrialStart_);
        wf_sig1_targ.errors_slow = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_slow, TrialStart_);
        
        %Align_Time = SRT(:,1) + 500;
        Plot_Time = [-600 300];
        
        wf_sig1_resp.correct_nosub = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_nosub, TrialStart_);
        wf_sig1_resp.correct = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct, TrialStart_);
        wf_sig1_resp.correct_fast = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_fast, TrialStart_);
        wf_sig1_resp.correct_slow = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_slow, TrialStart_);
        wf_sig1_resp.correct_ss2 = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_ss2, TrialStart_);
        wf_sig1_resp.correct_ss4 = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_ss4, TrialStart_);
        wf_sig1_resp.correct_ss8 = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_ss8, TrialStart_);
        wf_sig1_resp.errors = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, errors, TrialStart_);
        wf_sig1_resp.errors_fast = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, errors_fast, TrialStart_);
        wf_sig1_resp.errors_slow = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_slow, TrialStart_);
        
        if exist('correct_Tin') == 1
            Plot_Time = [-500 2500];
            wf_sig1_targ.correct_Tin = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_Tin, TrialStart_);
            wf_sig1_targ.correct_Din = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_Din, TrialStart_);
            
            Plot_Time = [-600 300];
            wf_sig1_resp.correct_Tin = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_Tin, TrialStart_);
            wf_sig1_resp.correct_Din = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_Din, TrialStart_);
        end
        
        if exist('correct_contra') == 1
            Plot_Time = [-500 2500];
            wf_sig1_targ.correct_contra = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_contra, TrialStart_);
            wf_sig1_targ.correct_ipsi = spikedensityfunct(sig1_targ, Align_Time, Plot_Time, correct_ipsi, TrialStart_);
            
            Plot_Time = [-600 300];
            wf_sig1_resp.correct_contra = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_contra, TrialStart_);
            wf_sig1_resp.correct_ipsi = spikedensityfunct(sig1_resp, Align_Time, Plot_Time, correct_ipsi, TrialStart_);
        end
        
    end
    
    %for signal 2
    if strmatch('AD',chanlist(pairings(pair,2))) == 1
        wf_sig2_targ.correct_nosub = nanmean(sig2_correct_targ_nosub,1);
        wf_sig2_targ.correct = nanmean(sig2_correct_targ,1);
        wf_sig2_targ.correct_fast = nanmean(sig2_correct_targ_fast,1);
        wf_sig2_targ.correct_slow = nanmean(sig2_correct_targ_slow,1);
        wf_sig2_targ.correct_ss2 = nanmean(sig2_correct_targ_ss2,1);
        wf_sig2_targ.correct_ss4 = nanmean(sig2_correct_targ_ss4,1);
        wf_sig2_targ.correct_ss8 = nanmean(sig2_correct_targ_ss8,1);
        wf_sig2_targ.errors = nanmean(sig2_errors_targ,1);
        wf_sig2_targ.errors_fast = nanmean(sig2_errors_targ_fast,1);
        wf_sig2_targ.errors_slow = nanmean(sig2_errors_targ_slow,1);
        
        wf_sig2_resp.correct_nosub = nanmean(sig2_correct_resp_nosub,1);
        wf_sig2_resp.correct = nanmean(sig2_correct_resp,1);
        wf_sig2_resp.correct_fast = nanmean(sig2_correct_resp_fast,1);
        wf_sig2_resp.correct_slow = nanmean(sig2_correct_resp_slow,1);
        wf_sig2_resp.correct_ss2 = nanmean(sig2_correct_resp_ss2,1);
        wf_sig2_resp.correct_ss4 = nanmean(sig2_correct_resp_ss4,1);
        wf_sig2_resp.correct_ss8 = nanmean(sig2_correct_resp_ss8,1);
        wf_sig2_resp.errors = nanmean(sig2_errors_resp,1);
        wf_sig2_resp.errors_fast = nanmean(sig2_errors_resp_fast,1);
        wf_sig2_resp.errors_slow = nanmean(sig2_errors_resp_slow,1);
        
        if exist('correct_Tin') == 1
            wf_sig2_targ.correct_Tin = nanmean(sig2_correct_targ_Tin,1);
            wf_sig2_targ.correct_Din = nanmean(sig2_correct_targ_Din,1);
            wf_sig2_resp.correct_Tin = nanmean(sig2_correct_resp_Tin,1);
            wf_sig2_resp.correct_Din = nanmean(sig2_correct_resp_Din,1);
        end
        
        if exist('correct_contra') == 1
            wf_sig2_targ.correct_contra = nanmean(sig2_correct_targ_contra,1);
            wf_sig2_targ.correct_ipsi = nanmean(sig2_correct_targ_ipsi,1);
            wf_sig2_resp.correct_contra = nanmean(sig2_correct_resp_contra,1);
            wf_sig2_resp.correct_ipsi = nanmean(sig2_correct_resp_ipsi,1);
        end
        
        
    else
        Plot_Time = [-500 2500];
        %already corrected spike times, so should align at 0
        Align_Time = zeros(length(Target_),1);
        
        
        wf_sig2_targ.correct_nosub = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_nosub, TrialStart_);
        wf_sig2_targ.correct = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct, TrialStart_);
        wf_sig2_targ.correct_fast = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_fast, TrialStart_);
        wf_sig2_targ.correct_slow = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_slow, TrialStart_);
        wf_sig2_targ.correct_ss2 = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_ss2, TrialStart_);
        wf_sig2_targ.correct_ss4 = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_ss4, TrialStart_);
        wf_sig2_targ.correct_ss8 = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_ss8, TrialStart_);
        wf_sig2_targ.errors = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, errors, TrialStart_);
        wf_sig2_targ.errors_fast = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, errors_fast, TrialStart_);
        wf_sig2_targ.errors_slow = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_slow, TrialStart_);
        
        Plot_Time = [-600 300];
        
        wf_sig2_resp.correct_nosub = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_nosub, TrialStart_);
        wf_sig2_resp.correct = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct, TrialStart_);
        wf_sig2_resp.correct_fast = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_fast, TrialStart_);
        wf_sig2_resp.correct_slow = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_slow, TrialStart_);
        wf_sig2_resp.correct_ss2 = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_ss2, TrialStart_);
        wf_sig2_resp.correct_ss4 = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_ss4, TrialStart_);
        wf_sig2_resp.correct_ss8 = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_ss8, TrialStart_);
        wf_sig2_resp.errors = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, errors, TrialStart_);
        wf_sig2_resp.errors_fast = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, errors_fast, TrialStart_);
        wf_sig2_resp.errors_slow = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_slow, TrialStart_);
        
        if exist('correct_Tin') == 1
            Plot_Time = [-500 2500];
            wf_sig2_targ.correct_Tin = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_Tin, TrialStart_);
            wf_sig2_targ.correct_Din = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_Din, TrialStart_);
            
            Plot_Time = [-600 300];
            wf_sig2_resp.correct_Tin = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_Tin, TrialStart_);
            wf_sig2_resp.correct_Din = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_Din, TrialStart_);
        end
        
        if exist('correct_contra') == 1
            Plot_Time = [-500 2500];
            wf_sig2_targ.correct_contra = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_contra, TrialStart_);
            wf_sig2_targ.correct_ipsi = spikedensityfunct(sig2_targ, Align_Time, Plot_Time, correct_ipsi, TrialStart_);
            
            Plot_Time = [-600 300];
            wf_sig2_resp.correct_contra = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_contra, TrialStart_);
            wf_sig2_resp.correct_ipsi = spikedensityfunct(sig2_resp, Align_Time, Plot_Time, correct_ipsi, TrialStart_);
        end
        
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % COHERENCE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS
    
    %get spectral analysis of each, print % save
    
    %pre-generate tapers
    tapers = PreGenTapers([.2 5],1000);
    
    %keep track of numbers of trials
    n.correct_nosub = size(sig1_correct_targ_nosub,1);
    n.correct = size(sig1_correct_targ,1);
    n.correct_fast = size(sig1_correct_targ_fast,1);
    n.correct_slow = size(sig1_correct_targ_slow,1);
    n.correct_ss2 = size(sig1_correct_targ_ss2,1);
    n.correct_ss4 = size(sig1_correct_targ_ss4,1);
    n.correct_ss8 = size(sig1_correct_targ_ss8,1);
    n.errors = size(sig1_errors_targ,1);
    n.errors_fast = size(sig1_errors_targ_fast,1);
    n.errors_slow = size(sig1_errors_targ_slow,1);
    
    if exist('correct_Tin') == 1
        n.correct_Tin = size(sig1_correct_targ_Tin,1);
        n.correct_Din = size(sig1_correct_targ_Din,1);
    end
    
    if exist('correct_contra') == 1
        n.correct_contra = size(sig1_correct_targ_contra,1);
        n.correct_ipsi = size(sig1_correct_targ_ipsi,1);
    end
    
    
    %compute coherence and spectra - must structure depending on nature of
    %signals (AD vs Spike)
    
    if strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('AD',chanlist(pairings(pair,2))) == 1
        [coh_targ.correct_nosub,f_targ,tout_targ,spec1_targ.correct_nosub,spec2_targ.correct_nosub] = LFP_LFPCoh(sig1_correct_targ_nosub,sig2_correct_targ_nosub,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.correct,f_targ,tout_targ,spec1_targ.correct,spec2_targ.correct] = LFP_LFPCoh(sig1_correct_targ,sig2_correct_targ,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.correct_fast,f_targ,tout_targ,spec1_targ.correct_fast,spec2_targ.correct_fast] = LFP_LFPCoh(sig1_correct_targ_fast,sig2_correct_targ_fast,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.correct_slow,f_targ,tout_targ,spec1_targ.correct_slow,spec2_targ.correct_slow] = LFP_LFPCoh(sig1_correct_targ_slow,sig2_correct_targ_slow,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.correct_ss2,f_targ,tout_targ,spec1_targ.correct_ss2,spec2_targ.correct_ss2] = LFP_LFPCoh(sig1_correct_targ_ss2,sig2_correct_targ_ss2,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.correct_ss4,f_targ,tout_targ,spec1_targ.correct_ss4,spec2_targ.correct_ss4] = LFP_LFPCoh(sig1_correct_targ_ss4,sig2_correct_targ_ss4,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.correct_ss8,f_targ,tout_targ,spec1_targ.correct_ss8,spec2_targ.correct_ss8] = LFP_LFPCoh(sig1_correct_targ_ss8,sig2_correct_targ_ss8,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.errors,f_targ,tout_targ,spec1_targ.errors,spec2_targ.errors] = LFP_LFPCoh(sig1_errors_targ,sig2_errors_targ,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.errors_fast,f_targ,tout_targ,spec1_targ.errors_fast,spec2_targ.errors_fast] = LFP_LFPCoh(sig1_errors_targ_fast,sig2_errors_targ_fast,tapers,1000,.01,[0,200],0,-500);
        [coh_targ.errors_slow,f_targ,tout_targ,spec1_targ.errors_slow,spec2_targ.errors_slow] = LFP_LFPCoh(sig1_errors_targ_slow,sig2_errors_targ_slow,tapers,1000,.01,[0,200],0,-500);
        
        [coh_resp.correct_nosub,f_resp,tout_resp,spec1_resp.correct_nosub,spec2_resp.correct_nosub] = LFP_LFPCoh(sig1_correct_resp_nosub,sig2_correct_resp_nosub,tapers,1000,.01,[0,200],0,-600);
        [coh_resp.correct,f_resp,tout_resp,spec1_resp.correct,spec2_resp.correct] = LFP_LFPCoh(sig1_correct_resp,sig2_correct_resp,tapers,1000,.01,[0,200],0,-600);
        [coh_resp.correct_fast,f_resp,tout_resp,spec1_resp.correct_fast,spec2_resp.correct_fast] = LFP_LFPCoh(sig1_correct_resp_fast,sig2_correct_resp_fast,tapers,1000,.01,[0,200],0,-600);
        [coh_resp.correct_slow,f_resp,tout_resp,spec1_resp.correct_slow,spec2_resp.correct_slow] = LFP_LFPCoh(sig1_correct_resp_slow,sig2_correct_resp_slow,tapers,1000,.01,[0,200],0,-600);
        [coh_resp.correct_ss2,f_resp,tout_resp,spec1_resp.correct_ss2,spec2_resp.correct_ss2] = LFP_LFPCoh(sig1_correct_resp_ss2,sig2_correct_resp_ss2,tapers,1000,.01,[0,200],0,-600);
        [coh_resp.correct_ss4,f_resp,tout_resp,spec1_resp.correct_ss4,spec2_resp.correct_ss4] = LFP_LFPCoh(sig1_correct_resp_ss4,sig2_correct_resp_ss4,tapers,1000,.01,[0,200],0,-600);
        [coh_resp.correct_ss8,f_resp,tout_resp,spec1_resp.correct_ss8,spec2_resp.correct_ss8] = LFP_LFPCoh(sig1_correct_resp_ss8,sig2_correct_resp_ss8,tapers,1000,.01,[0,200],0,-600);
        [coh_resp.errors,f_resp,tout_resp,spec1_resp.errors,spec2_resp.errors] = LFP_LFPCoh(sig1_errors_resp,sig2_errors_resp,tapers,1000,.01,[0,200],0,-600);
        [coh_resp.errors_fast,f_resp,tout_resp,spec1_resp.errors_fast,spec2_resp.errors_fast] = LFP_LFPCoh(sig1_errors_resp_fast,sig2_errors_resp_fast,tapers,1000,.01,[0,200],0,-600);
        [coh_resp.errors_slow,f_resp,tout_resp,spec1_resp.errors_slow,spec2_resp.errors_slow] = LFP_LFPCoh(sig1_errors_resp_slow,sig2_errors_resp_slow,tapers,1000,.01,[0,200],0,-600);
        
        if exist('correct_Tin') == 1
            [coh_targ.correct_Tin,f_targ,tout_targ,spec1_targ.correct_Tin,spec2_targ.correct_Tin] = LFP_LFPCoh(sig1_correct_targ_Tin,sig2_correct_targ_Tin,tapers,1000,.01,[0,200],0,-500);
            [coh_targ.correct_Din,f_targ,tout_targ,spec1_targ.correct_Din,spec2_targ.correct_Din] = LFP_LFPCoh(sig1_correct_targ_Din,sig2_correct_targ_Din,tapers,1000,.01,[0,200],0,-500);
            
            [coh_resp.correct_Tin,f_resp,tout_resp,spec1_resp.correct_Tin,spec2_resp.correct_Tin] = LFP_LFPCoh(sig1_correct_resp_Tin,sig2_correct_resp_Tin,tapers,1000,.01,[0,200],0,-600);
            [coh_resp.correct_Din,f_resp,tout_resp,spec1_resp.correct_Din,spec2_resp.correct_Din] = LFP_LFPCoh(sig1_correct_resp_Din,sig2_correct_resp_Din,tapers,1000,.01,[0,200],0,-600);
        end
        
        if exist('correct_contra') == 1
            [coh_targ.correct_contra,f_targ,tout_targ,spec1_targ.correct_contra,spec2_targ.correct_contra] = LFP_LFPCoh(sig1_correct_targ_contra,sig2_correct_targ_contra,tapers,1000,.01,[0,200],0,-500);
            [coh_targ.correct_ipsi,f_targ,tout_targ,spec1_targ.correct_ipsi,spec2_targ.correct_ipsi] = LFP_LFPCoh(sig1_correct_targ_ipsi,sig2_correct_targ_ipsi,tapers,1000,.01,[0,200],0,-500);
            
            [coh_resp.correct_contra,f_resp,tout_resp,spec1_resp.correct_contra,spec2_resp.correct_contra] = LFP_LFPCoh(sig1_correct_resp_contra,sig2_correct_resp_contra,tapers,1000,.01,[0,200],0,-600);
            [coh_resp.correct_ipsi,f_resp,tout_resp,spec1_resp.correct_ipsi,spec2_resp.correct_ipsi] = LFP_LFPCoh(sig1_correct_resp_ipsi,sig2_correct_resp_ipsi,tapers,1000,.01,[0,200],0,-600);
        end
        
        
        %for sig1 = AD and sig2 = Spike (must enter differently into Spk_LFPCoh
    elseif strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        [coh_targ.correct_nosub,f_targ,tout_targ,spec2_targ.correct_nosub,spec1_targ.correct_nosub] = Spk_LFPCoh(sig2_correct_targ_nosub,sig1_correct_targ_nosub,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct,f_targ,tout_targ,spec2_targ.correct,spec1_targ.correct] = Spk_LFPCoh(sig2_correct_targ,sig1_correct_targ,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_fast,f_targ,tout_targ,spec2_targ.correct_fast,spec1_targ.correct_fast] = Spk_LFPCoh(sig2_correct_targ_fast,sig1_correct_targ_fast,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_slow,f_targ,tout_targ,spec2_targ.correct_slow,spec1_targ.correct_slow] = Spk_LFPCoh(sig2_correct_targ_slow,sig1_correct_targ_slow,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_ss2,f_targ,tout_targ,spec2_targ.correct_ss2,spec1_targ.correct_ss2] = Spk_LFPCoh(sig2_correct_targ_ss2,sig1_correct_targ_ss2,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_ss4,f_targ,tout_targ,spec2_targ.correct_ss4,spec1_targ.correct_ss4] = Spk_LFPCoh(sig2_correct_targ_ss4,sig1_correct_targ_ss4,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_ss8,f_targ,tout_targ,spec2_targ.correct_ss8,spec1_targ.correct_ss8] = Spk_LFPCoh(sig2_correct_targ_ss8,sig1_correct_targ_ss8,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.errors,f_targ,tout_targ,spec2_targ.errors,spec1_targ.errors] = Spk_LFPCoh(sig2_errors_targ,sig1_errors_targ,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.errors_fast,f_targ,tout_targ,spec2_targ.errors_fast,spec1_targ.errors_fast] = Spk_LFPCoh(sig2_errors_targ_fast,sig1_errors_targ_fast,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.errors_slow,f_targ,tout_targ,spec2_targ.errors_slow,spec1_targ.errors_slow] = Spk_LFPCoh(sig2_errors_targ_slow,sig1_errors_targ_slow,tapers,-500,[-500 2500],1000,.01,[0,200],0);
        
        [coh_resp.correct_nosub,f_resp,tout_resp,spec2_resp.correct_nosub,spec1_resp.correct_nosub] = Spk_LFPCoh(sig2_correct_resp_nosub,sig1_correct_resp_nosub,tapers,-600,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct,f_resp,tout_resp,spec2_resp.correct,spec1_resp.correct] = Spk_LFPCoh(sig2_correct_resp,sig1_correct_resp,tapers,-600,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_fast,f_resp,tout_resp,spec2_resp.correct_fast,spec1_resp.correct_fast] = Spk_LFPCoh(sig2_correct_resp_fast,sig1_correct_resp_fast,tapers,-600,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_slow,f_resp,tout_resp,spec2_resp.correct_slow,spec1_resp.correct_slow] = Spk_LFPCoh(sig2_correct_resp_slow,sig1_correct_resp_slow,tapers,-600,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_ss2,f_resp,tout_resp,spec2_resp.correct_ss2,spec1_resp.correct_ss2] = Spk_LFPCoh(sig2_correct_resp_ss2,sig1_correct_resp_ss2,tapers,-600,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_ss4,f_resp,tout_resp,spec2_resp.correct_ss4,spec1_resp.correct_ss4] = Spk_LFPCoh(sig2_correct_resp_ss4,sig1_correct_resp_ss4,tapers,-600,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_ss8,f_resp,tout_resp,spec2_resp.correct_ss8,spec1_resp.correct_ss8] = Spk_LFPCoh(sig2_correct_resp_ss8,sig1_correct_resp_ss8,tapers,-600,[-600 300],1000,.01,[0,200],0);
        [coh_resp.errors,f_resp,tout_resp,spec2_resp.errors,spec1_resp.errors] = Spk_LFPCoh(sig2_errors_resp,sig1_errors_resp,tapers,-600,[-600 300],1000,.01,[0,200],0);
        [coh_resp.errors_fast,f_resp,tout_resp,spec2_resp.errors_fast,spec1_resp.errors_fast] = Spk_LFPCoh(sig2_errors_resp_fast,sig1_errors_resp_fast,tapers,-600,[-600 300],1000,.01,[0,200],0);
        [coh_resp.errors_slow,f_resp,tout_resp,spec2_resp.errors_slow,spec1_resp.errors_slow] = Spk_LFPCoh(sig2_errors_resp_slow,sig1_errors_resp_slow,tapers,-600,[-600 300],1000,.01,[0,200],0);
        
        if exist('correct_Tin') == 1
            [coh_targ.correct_Tin,f_targ,tout_targ,spec2_targ.correct_Tin,spec1_targ.correct_Tin] = Spk_LFPCoh(sig2_correct_targ_Tin,sig1_correct_targ_Tin,tapers,-500,[-500 2500],1000,.01,[0,200],0);
            [coh_targ.correct_Din,f_targ,tout_targ,spec2_targ.correct_Din,spec1_targ.correct_Din] = Spk_LFPCoh(sig2_correct_targ_Din,sig1_correct_targ_Din,tapers,-500,[-500 2500],1000,.01,[0,200],0);
            
            [coh_resp.correct_Tin,f_resp,tout_resp,spec2_resp.correct_Tin,spec1_resp.correct_Tin] = Spk_LFPCoh(sig2_correct_resp_Tin,sig1_correct_resp_Tin,tapers,-600,[-600 300],1000,.01,[0,200],0);
            [coh_resp.correct_Din,f_resp,tout_resp,spec2_resp.correct_Din,spec1_resp.correct_Din] = Spk_LFPCoh(sig2_correct_resp_Din,sig1_correct_resp_Din,tapers,-600,[-600 300],1000,.01,[0,200],0);
        end
        
        if exist('correct_contra') == 1
            [coh_targ.correct_contra,f_targ,tout_targ,spec2_targ.correct_contra,spec1_targ.correct_contra] = Spk_LFPCoh(sig2_correct_targ_contra,sig1_correct_targ_contra,tapers,-500,[-500 2500],1000,.01,[0,200],0);
            [coh_targ.correct_ipsi,f_targ,tout_targ,spec2_targ.correct_ipsi,spec1_targ.correct_ipsi] = Spk_LFPCoh(sig2_correct_targ_ipsi,sig1_correct_targ_ipsi,tapers,-500,[-500 2500],1000,.01,[0,200],0);
            
            [coh_resp.correct_contra,f_resp,tout_resp,spec2_resp.correct_contra,spec1_resp.correct_contra] = Spk_LFPCoh(sig2_correct_resp_contra,sig1_correct_resp_contra,tapers,-600,[-600 300],1000,.01,[0,200],0);
            [coh_resp.correct_ipsi,f_resp,tout_resp,spec2_resp.correct_ipsi,spec1_resp.correct_ipsi] = Spk_LFPCoh(sig2_correct_resp_ipsi,sig1_correct_resp_ipsi,tapers,-600,[-600 300],1000,.01,[0,200],0);
        end
        
        
        %both signals are spikes
    elseif strmatch('DSP',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        [coh_targ.correct_nosub,f_targ,tout_targ,spec1_targ.correct_nosub,spec2_targ.correct_nosub] = Spk_SpkCoh(sig1_correct_targ_nosub,sig2_correct_targ_nosub,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct,f_targ,tout_targ,spec1_targ.correct,spec2_targ.correct] = Spk_SpkCoh(sig1_correct_targ,sig2_correct_targ,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_fast,f_targ,tout_targ,spec1_targ.correct_fast,spec2_targ.correct_fast] = Spk_SpkCoh(sig1_correct_targ_fast,sig2_correct_targ_fast,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_slow,f_targ,tout_targ,spec1_targ.correct_slow,spec2_targ.correct_slow] = Spk_SpkCoh(sig1_correct_targ_slow,sig2_correct_targ_slow,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_ss2,f_targ,tout_targ,spec1_targ.correct_ss2,spec2_targ.correct_ss2] = Spk_SpkCoh(sig1_correct_targ_ss2,sig2_correct_targ_ss2,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_ss4,f_targ,tout_targ,spec1_targ.correct_ss4,spec2_targ.correct_ss4] = Spk_SpkCoh(sig1_correct_targ_ss4,sig2_correct_targ_ss4,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.correct_ss8,f_targ,tout_targ,spec1_targ.correct_ss8,spec2_targ.correct_ss8] = Spk_SpkCoh(sig1_correct_targ_ss8,sig2_correct_targ_ss8,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.errors,f_targ,tout_targ,spec1_targ.errors,spec2_targ.errors] = Spk_SpkCoh(sig1_errors_targ,sig2_errors_targ,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.errors_fast,f_targ,tout_targ,spec1_targ.errors_fast,spec2_targ.errors_fast] = Spk_SpkCoh(sig1_errors_targ_fast,sig2_errors_targ_fast,tapers,[-500 2500],1000,.01,[0,200],0);
        [coh_targ.errors_slow,f_targ,tout_targ,spec1_targ.errors_slow,spec2_targ.errors_slow] = Spk_SpkCoh(sig1_errors_targ_slow,sig2_errors_targ_slow,tapers,[-500 2500],1000,.01,[0,200],0);
        
        [coh_resp.correct_nosub,f_resp,tout_resp,spec1_resp.correct_nosub,spec2_resp.correct_nosub] = Spk_SpkCoh(sig1_correct_resp_nosub,sig2_correct_resp_nosub,tapers,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct,f_resp,tout_resp,spec1_resp.correct,spec2_resp.correct] = Spk_SpkCoh(sig1_correct_resp,sig2_correct_resp,tapers,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_fast,f_resp,tout_resp,spec1_resp.correct_fast,spec2_resp.correct_fast] = Spk_SpkCoh(sig1_correct_resp_fast,sig2_correct_resp_fast,tapers,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_slow,f_resp,tout_resp,spec1_resp.correct_slow,spec2_resp.correct_slow] = Spk_SpkCoh(sig1_correct_resp_slow,sig2_correct_resp_slow,tapers,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_ss2,f_resp,tout_resp,spec1_resp.correct_ss2,spec2_resp.correct_ss2] = Spk_SpkCoh(sig1_correct_resp_ss2,sig2_correct_resp_ss2,tapers,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_ss4,f_resp,tout_resp,spec1_resp.correct_ss4,spec2_resp.correct_ss4] = Spk_SpkCoh(sig1_correct_resp_ss4,sig2_correct_resp_ss4,tapers,[-600 300],1000,.01,[0,200],0);
        [coh_resp.correct_ss8,f_resp,tout_resp,spec1_resp.correct_ss8,spec2_resp.correct_ss8] = Spk_SpkCoh(sig1_correct_resp_ss8,sig2_correct_resp_ss8,tapers,[-600 300],1000,.01,[0,200],0);
        [coh_resp.errors,f_resp,tout_resp,spec1_resp.errors,spec2_resp.errors] = Spk_SpkCoh(sig1_errors_resp,sig2_errors_resp,tapers,[-600 300],1000,.01,[0,200],0);
        [coh_resp.errors_fast,f_resp,tout_resp,spec1_resp.errors_fast,spec2_resp.errors_fast] = Spk_SpkCoh(sig1_errors_resp_fast,sig2_errors_resp_fast,tapers,[-600 300],1000,.01,[0,200],0);
        [coh_resp.errors_slow,f_resp,tout_resp,spec1_resp.errors_slow,spec2_resp.errors_slow] = Spk_SpkCoh(sig1_errors_resp_slow,sig2_errors_resp_slow,tapers,[-600 300],1000,.01,[0,200],0);
        
        
        if exist('correct_Tin') == 1
            [coh_targ.correct_Tin,f_targ,tout_targ,spec1_targ.correct_Tin,spec2_targ.correct_Tin] = Spk_SpkCoh(sig1_correct_targ_Tin,sig2_correct_targ_Tin,tapers,[-500 2500],1000,.01,[0,200],0);
            [coh_targ.correct_Din,f_targ,tout_targ,spec1_targ.correct_Din,spec2_targ.correct_Din] = Spk_SpkCoh(sig1_correct_targ_Din,sig2_correct_targ_Din,tapers,[-500 2500],1000,.01,[0,200],0);
            
            [coh_resp.correct_Tin,f_resp,tout_resp,spec1_resp.correct_Tin,spec2_resp.correct_Tin] = Spk_SpkCoh(sig1_correct_resp_Tin,sig2_correct_resp_Tin,tapers,[-600 300],1000,.01,[0,200],0);
            [coh_resp.correct_Din,f_resp,tout_resp,spec1_resp.correct_Din,spec2_resp.correct_Din] = Spk_SpkCoh(sig1_correct_resp_Din,sig2_correct_resp_Din,tapers,[-600 300],1000,.01,[0,200],0);
        end
        
        if exist('correct_contra') == 1
            [coh_targ.correct_contra,f_targ,tout_targ,spec1_targ.correct_contra,spec2_targ.correct_contra] = Spk_SpkCoh(sig1_correct_targ_contra,sig2_correct_targ_contra,tapers,[-500 2500],1000,.01,[0,200],0);
            [coh_targ.correct_ipsi,f_targ,tout_targ,spec1_targ.correct_ipsi,spec2_targ.correct_ipsi] = Spk_SpkCoh(sig1_correct_targ_ipsi,sig2_correct_targ_ipsi,tapers,[-500 2500],1000,.01,[0,200],0);
            
            [coh_resp.correct_contra,f_resp,tout_resp,spec1_resp.correct_contra,spec2_resp.correct_contra] = Spk_SpkCoh(sig1_correct_resp_contra,sig2_correct_resp_contra,tapers,[-600 300],1000,.01,[0,200],0);
            [coh_resp.correct_ipsi,f_resp,tout_resp,spec1_resp.correct_ipsi,spec2_resp.correct_ipsi] = Spk_SpkCoh(sig1_correct_resp_ipsi,sig2_correct_resp_ipsi,tapers,[-600 300],1000,.01,[0,200],0);
        end
    end
    
    
    
    
    %==============================================================
    % PLOTTING
    
    %generate Headers for super X label
    if exist('correct_ipsi') == 1 & strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('AD',chanlist(pairings(pair,2))) == 1
        %both are AD and are in same hemisphere
        condition_header = 'AD vs AD in SAME HEMISPHERES. Using only contralateral hemifield positions.';
    end
    
    
    if exist('correct_ipsi') == 0 & strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('AD',chanlist(pairings(pair,2))) == 1
        %both are AD and are in diff hemispheres
        condition_header = 'AD vs AD in DIFFERENT HEMISPHERES.  Collapsing across screen locations';
    end
    
    
    if exist('correct_Tin') == 1 & strmatch('AD',chanlist(pairings(pair,1))) == 1
        %is AD & DSP comparison in same hemisphere. (assume 2nd chan is DSP if
        %correct_Tin exists)
        condition_header = 'AD vs DSP channel in SAME HEMISPHERE. Using only Tin locations of neuron';
    end
    
    
    if exist('correct_Tin') == 0 & strmatch('AD',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        %is AD & DSP comparison between hemispheres
        condition_header = 'AD vs DSP channel in DIFFERENT HEMISPHERES. Collapsing across screen locations';
    end
    
    
    if exist('correct_Tin') == 1 & strmatch('DSP',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        %both are AD and RFs overlap
        condition_header = 'DSP vs DSP channel with OVERLAPPING RFs. Using only RF intersection';
    end
    
    
    if exist('correct_Tin') == 0 & strmatch('DSP',chanlist(pairings(pair,1))) == 1 & strmatch('DSP',chanlist(pairings(pair,2))) == 1
        %both are Spike channels but no RF overlap
        condition_header = 'DSP vs DSP channel with NON-OVERLAPPING RFs. Collapsing across screen locations';
    end
    
    
    %get Monkey name
    getMonk
    
    %Naming Conventions
    if strmatch('AD01',chanlist(pairings(pair,1))) == 1
        name1 = 'Oz';
    elseif strmatch('AD02',chanlist(pairings(pair,1))) == 1 & monkey == 'S'
        name1 = 'OR';
    elseif strmatch('AD02',chanlist(pairings(pair,1))) == 1 & monkey == 'Q'
        name1 = 'T6';
    elseif strmatch('AD03',chanlist(pairings(pair,1))) == 1 & monkey == 'S'
        name1 = 'OL';
    elseif strmatch('AD03',chanlist(pairings(pair,1))) == 1 & monkey == 'Q'
        name1 = 'T5';
    elseif strmatch('AD04',chanlist(pairings(pair,1))) == 1 & monkey == 'S'
        name1 = 'C4';
    elseif strmatch('AD04',chanlist(pairings(pair,1))) == 1 & monkey == 'Q'
        name1 = 'rLFP';
    elseif strmatch('AD05',chanlist(pairings(pair,1))) == 1
        name1 = 'C3';
    elseif strmatch('AD06',chanlist(pairings(pair,1))) == 1
        name1 = 'F4';
    elseif strmatch('AD07',chanlist(pairings(pair,1))) == 1
        name1 = 'F3';
    elseif strmatch('AD',chanlist(pairings(pair,1))) == 1 & cell2mat(chan1_hemi) == 'L'
        name1 = 'lLFP';
    elseif strmatch('AD',chanlist(pairings(pair,1))) == 1 & cell2mat(chan1_hemi) == 'R'
        name1 = 'rLFP';
    elseif strmatch('DSP',chanlist(pairings(pair,1))) == 1 & cell2mat(chan1_hemi) == 'L'
        name1 = 'lNeu';
    elseif strmatch('DSP',chanlist(pairings(pair,1))) == 1 & cell2mat(chan1_hemi) == 'R'
        name1 = 'rNeu';
    end
    
    if strmatch('AD01',chanlist(pairings(pair,2))) == 1
        name2 = 'Oz';
    elseif strmatch('AD02',chanlist(pairings(pair,2))) == 1 & monkey == 'S'
        name2 = 'OR';
    elseif strmatch('AD02',chanlist(pairings(pair,2))) == 1 & monkey == 'Q'
        name2 = 'T6';
    elseif strmatch('AD03',chanlist(pairings(pair,2))) == 1 & monkey == 'S'
        name2 = 'OL';
    elseif strmatch('AD03',chanlist(pairings(pair,2))) == 1 & monkey == 'Q'
        name2 = 'T5';
    elseif strmatch('AD04',chanlist(pairings(pair,2))) == 1 & monkey == 'S'
        name2 = 'C4';
    elseif strmatch('AD04',chanlist(pairings(pair,2))) == 1 & monkey == 'Q'
        name2 = 'rLFP';
    elseif strmatch('AD05',chanlist(pairings(pair,2))) == 1
        name2 = 'C3';
    elseif strmatch('AD06',chanlist(pairings(pair,2))) == 1
        name2 = 'F4';
    elseif strmatch('AD07',chanlist(pairings(pair,2))) == 1
        name2 = 'F3';
    elseif strmatch('AD',chanlist(pairings(pair,2))) == 1 & cell2mat(chan2_hemi) == 'L'
        name2 = 'lLFP';
    elseif strmatch('AD',chanlist(pairings(pair,2))) == 1 & cell2mat(chan2_hemi) == 'R'
        name2 = 'rLFP';
    elseif strmatch('DSP',chanlist(pairings(pair,2))) == 1 & cell2mat(chan2_hemi) == 'L'
        name2 = 'lNeu';
    elseif strmatch('DSP',chanlist(pairings(pair,2))) == 1 & cell2mat(chan2_hemi) == 'R'
        name2 = 'rNeu';
    end
    
    disp(' ... ')
    disp(' ... ')
    disp([cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))])
    disp([name1 name2])
    
    
    
    if plotFlag == 1
        
        % FIGURE 0: Correct, no sub sampling vs Correct, sub-sampled
        % Sub-sampling done so that there is no bias in comparing various
        % conditions that differ in # of trials
        % Also plot mean waveforms
        
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        s1 = subplot(4,4,[1:2,5:6]);
        imagesc(tout_targ,f_targ,abs(coh_targ.correct_nosub'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct No Subsampling'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        s2 = subplot(4,4,[3:4,7:8]);
        imagesc(tout_targ,f_targ,abs(coh_targ.correct'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        %ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct Subsampled'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        %reset CLim to global min and max
        set(s1,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        set(s2,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        
        %plot waveforms
        subplot(4,4,9:10)
        plot(-500:2500,wf_sig1_targ.correct_nosub)
        xlim([-100 500])
        xlabel('Time from Target')
        title(name1)
        
        subplot(4,4,11:12)
        plot(-500:2500,wf_sig2_targ.correct_nosub)
        xlim([-100 500])
        xlabel('Time from Target')
        title(name2)
        
        subplot(4,4,13:14)
        plot(-600:300,wf_sig1_resp.correct_nosub)
        xlabel('Time from Response')
        xlim([-600 300])
        title(name1)
        
        subplot(4,4,15:16)
        plot(-600:300,wf_sig2_resp.correct_nosub)
        xlabel('Time from Response')
        xlim([-600 300])
        title(name2)
        
        
        
        [ax,h1] = suplabel(condition_header);
        [ax,h2] = suplabel(['nCorrect NoSub = ' mat2str(n.correct_nosub) ' nCorrect Subsamp = ' mat2str(n.correct)],'y');
        set(h2,'fontsize',10,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'fontsize',10,'FontWeight','bold')
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/Uber/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_nosub_v_sub.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_nosub_v_sub.jpg',q])
        close(h)
        
        
        
        
        
        
        
        
        
        %======================================================================
        
        % FIGURE 1: Correct vs. Errors Coherence target and response aligned
        
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        subplot(2,2,1)
        imagesc(tout_targ,f_targ,abs(coh_targ.correct'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        subplot(2,2,2)
        imagesc(tout_targ,f_targ,abs(coh_targ.errors'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Errors'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        %reset CLim to global min and max
        subplot(2,2,1)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,2,2)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        subplot(2,2,3)
        imagesc(tout_resp,f_resp,abs(coh_resp.correct'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        
        subplot(2,2,4)
        imagesc(tout_resp,f_resp,abs(coh_resp.errors'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Errors'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        
        %reset CLim to global min and max
        subplot(2,2,3)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,2,4)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        [ax,h1] = suplabel(condition_header);
        [ax,h2] = suplabel(['nCorrect = ' mat2str(n.correct) ' nErrors = ' mat2str(n.errors)],'y');
        set(h2,'fontsize',10,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'fontsize',10,'FontWeight','bold')
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/Uber/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_correct_v_errors.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_correct_v_errors.jpg',q])
        close(h)
        
        
        
        
        
        
        
        
        
        
        
        %=====================================================================
        % FIGURE 2: Correct spectra vs coherence, Target aligned
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        subplot(2,2,1)
        imagesc(tout_targ,f_targ,log10(spec1_targ.correct'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' Spectra Correct'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        subplot(2,2,2)
        imagesc(tout_targ,f_targ,log10(spec2_targ.correct'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name2 ' Spectra Correct'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        %reset CLim
        subplot(2,2,1)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,2,2)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        subplot(2,2,3)
        imagesc(tout_targ,f_targ,abs(coh_targ.correct'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct'],'fontweight','bold','fontsize',10)
        xlim([-100 500])
        
        
        [ax,h1] = suplabel(condition_header);
        [ax,h2] = suplabel(['nCorrect = ' mat2str(n.correct)],'y');
        set(h2,'fontsize',10,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'fontsize',10,'FontWeight','bold')
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/Uber/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_v_spectra_correct.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_v_spectra_correct.jpg',q])
        close(h)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        %===================================================================
        % FIGURE 3: Coherence Fast vs Slow Target and Response Aligned, Correct
        % Trials
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        subplot(2,2,1)
        imagesc(tout_targ,f_targ,abs(coh_targ.correct_fast'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct Fast'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        subplot(2,2,2)
        imagesc(tout_targ,f_targ,abs(coh_targ.correct_slow'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct Slow'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        %reset CLim to global min and max
        subplot(2,2,1)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,2,2)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        subplot(2,2,3)
        imagesc(tout_resp,f_resp,abs(coh_resp.correct_fast'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct Fast'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        
        subplot(2,2,4)
        imagesc(tout_resp,f_resp,abs(coh_resp.correct_slow'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct Slow'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        
        %reset CLim to global min and max
        subplot(2,2,3)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,2,4)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        [ax,h1] = suplabel(condition_header);
        [ax,h2] = suplabel(['nCorrect Fast = ' mat2str(n.correct_fast) ' nCorrect Slow = ' mat2str(n.correct_slow)],'y');
        set(h2,'fontsize',10,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'fontsize',10,'FontWeight','bold')
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/Uber/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_correct_fast_v_slow.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_correct_fast_v_slow.jpg',q])
        close(h)
        
        
        
        
        
        
        
        %===================================================================
        % FIGURE 4: Coherence Fast vs Slow Target and Response Aligned, Errors
        % Trials
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        subplot(2,2,1)
        imagesc(tout_targ,f_targ,abs(coh_targ.errors_fast'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Errors Fast'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        subplot(2,2,2)
        imagesc(tout_targ,f_targ,abs(coh_targ.errors_slow'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Errors Slow'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        %reset CLim to global min and max
        subplot(2,2,1)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,2,2)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        subplot(2,2,3)
        imagesc(tout_resp,f_resp,abs(coh_resp.errors_fast'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Errors Fast'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        
        subplot(2,2,4)
        imagesc(tout_resp,f_resp,abs(coh_resp.errors_slow'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Errors Slow'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        
        %reset CLim to global min and max
        subplot(2,2,3)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,2,4)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        [ax,h1] = suplabel(condition_header);
        [ax,h2] = suplabel(['nErrors Fast = ' mat2str(n.errors_fast) ' nErrors Slow = ' mat2str(n.errors_slow)],'y');
        set(h2,'fontsize',10,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'fontsize',10,'FontWeight','bold')
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/Uber/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_errors_fast_v_slow.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_errors_fast_v_slow.jpg',q])
        close(h)
        
        
        
        
        
        
        
        
        
        
        
        %===================================================================
        % FIGURE 5: Coherence Set Size target and response aligned
        % Trials
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        subplot(2,3,1)
        imagesc(tout_targ,f_targ,abs(coh_targ.correct_ss2'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct SS2'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        subplot(2,3,2)
        imagesc(tout_targ,f_targ,abs(coh_targ.correct_ss4'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct SS4'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        subplot(2,3,3)
        imagesc(tout_targ,f_targ,abs(coh_targ.correct_ss8'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct SS8'],'fontweight','bold','fontsize',10)
        color_limits(3,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        %reset CLim to global min and max
        subplot(2,3,1)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,3,2)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,3,3)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        
        subplot(2,3,4)
        imagesc(tout_resp,f_resp,abs(coh_resp.correct_ss2'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct SS2'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        
        subplot(2,3,5)
        imagesc(tout_resp,f_resp,abs(coh_resp.correct_ss4'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct SS4'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        
        subplot(2,3,6)
        imagesc(tout_resp,f_resp,abs(coh_resp.correct_ss8'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' ' name2 ' Coh Correct SS8'],'fontweight','bold','fontsize',10)
        color_limits(3,1:2) = get(gca,'CLim');
        
        
        %reset CLim to global min and max
        subplot(2,3,4)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,3,5)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,3,6)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        
        [ax,h1] = suplabel(condition_header);
        [ax,h2] = suplabel(['nSS2 = ' mat2str(n.correct_ss2) ' nSS4 = ' mat2str(n.correct_ss4) ' nSS8 = ' mat2str(n.correct_ss8)],'y');
        set(h2,'fontsize',10,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'fontsize',10,'FontWeight','bold')
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/Uber/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_SetSize.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_SetSize.jpg',q])
        close(h)
        
        
        
        
        
        
        %===================================================================
        % FIGURE 6: Spectra by Set Size, Target-aligned
        % Trials
        h = figure;
        set(gcf,'color','white')
        orient landscape
        
        subplot(2,3,1)
        imagesc(tout_targ,f_targ,log10(spec1_targ.correct_ss2'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' Spec1 Correct SS2'],'fontweight','bold','fontsize',10)
        color_limits(1,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        subplot(2,3,2)
        imagesc(tout_targ,f_targ,log10(spec1_targ.correct_ss4'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' Spec1 Correct SS4'],'fontweight','bold','fontsize',10)
        color_limits(2,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        subplot(2,3,3)
        imagesc(tout_targ,f_targ,log10(spec1_targ.correct_ss8'))
        axis xy
        xlabel('Time from Target','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name1 ' Spec1 Correct SS8'],'fontweight','bold','fontsize',10)
        color_limits(3,1:2) = get(gca,'CLim');
        xlim([-100 500])
        
        subplot(2,3,4)
        imagesc(tout_resp,f_resp,log10(spec2_resp.correct_ss2'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name2 ' Spec2 Correct SS2'],'fontweight','bold','fontsize',10)
        color_limits(4,1:2) = get(gca,'CLim');
        
        subplot(2,3,5)
        imagesc(tout_resp,f_resp,log10(spec2_resp.correct_ss4'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name2 ' Spec2 Correct SS4'],'fontweight','bold','fontsize',10)
        color_limits(5,1:2) = get(gca,'CLim');
        
        subplot(2,3,6)
        imagesc(tout_resp,f_resp,log10(spec2_resp.correct_ss8'))
        axis xy
        xlabel('Time from Response','fontweight','bold','fontsize',10)
        ylabel('Frequency','fontweight','bold','fontsize',10)
        colorbar
        title([name2 ' Spec2 Correct SS8'],'fontweight','bold','fontsize',10)
        color_limits(6,1:2) = get(gca,'CLim');
        
        
        %reset CLim to global min and max
        subplot(2,3,1)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,3,2)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,3,3)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,3,4)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,3,5)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        subplot(2,3,6)
        set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
        clear color_limits
        %======================================================================
        
        [ax,h1] = suplabel(condition_header);
        [ax,h2] = suplabel(['nSS2 = ' mat2str(n.correct_ss2) ' nSS4 = ' mat2str(n.correct_ss4) ' nSS8 = ' mat2str(n.correct_ss8)],'y');
        set(h2,'fontsize',10,'FontWeight','bold')
        [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
        set(h3,'fontsize',10,'FontWeight','bold')
        
        eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/Uber/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_spectra_SetSize.jpg',q])
        %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_spectra_SetSize.jpg',q])
        close(h)
        
        
        
        
        %===================================================================
        % FIGURE 7a: Contra vs Ipsi Hemifield, Target & Response-aligned
        
        if exist('correct_contra') == 1
            % Trials
            h = figure;
            set(gcf,'color','white')
            orient landscape
            
            subplot(2,2,1)
            imagesc(tout_targ,f_targ,abs(coh_targ.correct_contra'))
            axis xy
            xlabel('Time from Target','fontweight','bold','fontsize',10)
            ylabel('Frequency','fontweight','bold','fontsize',10)
            colorbar
            title([name1 ' ' name2 ' Coh Correct Contra'],'fontweight','bold','fontsize',10)
            color_limits(1,1:2) = get(gca,'CLim');
            xlim([-100 500])
            
            subplot(2,2,2)
            imagesc(tout_targ,f_targ,abs(coh_targ.correct_ipsi'))
            axis xy
            xlabel('Time from Target','fontweight','bold','fontsize',10)
            ylabel('Frequency','fontweight','bold','fontsize',10)
            colorbar
            title([name1 ' ' name2 ' Coh Correct Ipsi'],'fontweight','bold','fontsize',10)
            color_limits(2,1:2) = get(gca,'CLim');
            xlim([-100 500])
            
            %reset CLim to global min and max
            subplot(2,2,1)
            set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
            subplot(2,2,2)
            set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
            clear color_limits
            
            subplot(2,2,3)
            imagesc(tout_resp,f_resp,abs(coh_resp.correct_contra'))
            axis xy
            xlabel('Time from Response','fontweight','bold','fontsize',10)
            ylabel('Frequency','fontweight','bold','fontsize',10)
            colorbar
            title([name1 ' ' name2 ' Coh Correct Contra'],'fontweight','bold','fontsize',10)
            color_limits(1,1:2) = get(gca,'CLim');
            
            subplot(2,2,4)
            imagesc(tout_resp,f_resp,abs(coh_resp.correct_ipsi'))
            axis xy
            xlabel('Time from Response','fontweight','bold','fontsize',10)
            ylabel('Frequency','fontweight','bold','fontsize',10)
            colorbar
            title([name1 ' ' name2 ' Coh Correct Ipsi'],'fontweight','bold','fontsize',10)
            color_limits(2,1:2) = get(gca,'CLim');
            
            %reset CLim to global min and max
            subplot(2,2,3)
            set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
            subplot(2,2,4)
            set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
            clear color_limits
            
            [ax,h1] = suplabel(condition_header);
            [ax,h2] = suplabel(['nCorrect Contra = ' mat2str(n.correct_contra) ' nCorrect Ipsi = ' mat2str(n.correct_ipsi)],'y');
            set(h2,'fontsize',10,'FontWeight','bold')
            [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
            set(h3,'fontsize',10,'FontWeight','bold')
            
            eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/Uber/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_correct_contra_v_ipsi.jpg',q])
            %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_correct_contra_v_ipsi.jpg',q])
            close(h)
            
        end
        
        
        
        
        %===================================================================
        % FIGURE 7b: Tin vs Din Target and Response-aligned
        
        if exist('correct_Tin') == 1
            % Trials
            h = figure;
            set(gcf,'color','white')
            orient landscape
            
            subplot(2,2,1)
            imagesc(tout_targ,f_targ,abs(coh_targ.correct_Tin'))
            axis xy
            xlabel('Time from Target','fontweight','bold','fontsize',10)
            ylabel('Frequency','fontweight','bold','fontsize',10)
            colorbar
            title([name1 ' ' name2 ' Coh Correct Tin'],'fontweight','bold','fontsize',10)
            color_limits(1,1:2) = get(gca,'CLim');
            xlim([-100 500])
            
            subplot(2,2,2)
            imagesc(tout_targ,f_targ,abs(coh_targ.correct_Din'))
            axis xy
            xlabel('Time from Target','fontweight','bold','fontsize',10)
            ylabel('Frequency','fontweight','bold','fontsize',10)
            colorbar
            title([name1 ' ' name2 ' Coh Correct Din'],'fontweight','bold','fontsize',10)
            color_limits(2,1:2) = get(gca,'CLim');
            xlim([-100 500])
            
            %reset CLim to global min and max
            subplot(2,2,1)
            set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
            subplot(2,2,2)
            set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
            clear color_limits
            
            subplot(2,2,3)
            imagesc(tout_resp,f_resp,abs(coh_resp.correct_Tin'))
            axis xy
            xlabel('Time from Response','fontweight','bold','fontsize',10)
            ylabel('Frequency','fontweight','bold','fontsize',10)
            colorbar
            title([name1 ' ' name2 ' Coh Correct Tin'],'fontweight','bold','fontsize',10)
            color_limits(1,1:2) = get(gca,'CLim');
            
            subplot(2,2,4)
            imagesc(tout_resp,f_resp,abs(coh_resp.correct_Din'))
            axis xy
            xlabel('Time from Response','fontweight','bold','fontsize',10)
            ylabel('Frequency','fontweight','bold','fontsize',10)
            colorbar
            title([name1 ' ' name2 ' Coh Correct Din'],'fontweight','bold','fontsize',10)
            color_limits(2,1:2) = get(gca,'CLim');
            
            %reset CLim to global min and max
            subplot(2,2,3)
            set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
            subplot(2,2,4)
            set(gca,'CLim',[min(color_limits(:,1)) max(color_limits(:,2))]);
            clear color_limits
            
            [ax,h1] = suplabel(condition_header);
            [ax,h2] = suplabel(['nCorrect Tin = ' mat2str(n.correct_Tin) ' nCorrect Din = ' mat2str(n.correct_Din)],'y');
            set(h2,'fontsize',10,'FontWeight','bold')
            [ax,h3] = suplabel(['   File: ',file,'   Generated: ',date],'t');
            set(h3,'fontsize',10,'FontWeight','bold')
            
            eval(['print -djpeg100 ',q,'//scratch/heitzrp/Output/Coherence/Uber/JPG/',file,'_',[name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2)))],'_coherence_correct_Tin_v_Din.jpg',q])
            %eval(['print -djpeg100 ',q,'~/desktop/s/',file,'_',[name1 name2],'_coherence_correct_Tin_v_Din.jpg',q])
            close(h)
            
        end
        
    end %if plotFlag == 1
    
    
    
    %=====================================================================
    if saveFlag == 1
        %    save(['~/desktop/s/' file '_' ...
        save(['//scratch/heitzrp/Output/Coherence/Uber/Matrices/' file '_' ...
            name1 name2 cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) ...
            '_Coherence.mat'],'wf_sig1_targ','wf_sig2_targ','n','RTs', ...
            'wf_sig1_resp','wf_sig2_resp', ...
            'coh_targ','coh_resp','spec1_targ','spec1_resp','spec2_targ', ...
            'spec2_resp','tout_targ','tout_resp','f_targ','f_resp','-mat')
    end
    
    
    
    
    %clean up variables that will change between comparisons for safety
    clear tout_targ tout_resp f_targ f_resp n RTs color_limits ...
        correct cMed correct_fast correct_slow correct_ss2 correct_ss4 correct_ss8 ...
        errors eMed errors_fast errors_slow correct_contra correct_ipsi correct_Tin ...
        correct_Din minTrials RF AntiRF tempname stub newname chan1_hemi chan2_hemi ...
        name1 name2 sig* wf* coh* spec*
    
end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes