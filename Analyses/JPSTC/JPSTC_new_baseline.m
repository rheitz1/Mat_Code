% Joint Peri-stimulus time correlogram
% for this analysis, compute only LFP-LFP, baselineing on the JPSTC of the
% first 451 ms of each trial (baseline period).

function [] = JPSTC_vampire_new_baseline(file)
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


%for this analysis, include only LFP channels (AD >= 09.  Quincy has some
%AD04's that are LFP, but because there was always only 1, those sessions
%will yield no LFP-LFP correlations
u = 1;
for w = 1:length(ADlist)
    if str2num(ADlist(w,end-1:end)) >= 9
        newlist(u,1:4) = char(ADlist(w,:));
        u = u + 1;
    end
end

if exist('newlist') == 0
    disp('No LFP found...exiting')
    return
elseif exist('newlist') == 1 && size(newlist,1) == 1
    disp('Only 1 LFP found...exiting')
    return
end

ADlist = newlist;
clear varlist newlist u w


for chanNum = 1:size(ADlist,1)
    ADchan = ADlist(chanNum,:);
    eval(['load(' q file qcq ADchan qcq '-mat' q ')'])
    disp(['load(' q file qcq ADchan qcq '-mat' q ')'])
    clear ADchan
end

%load Target_ & Correct_ variable
eval(['load(' q file qcq 'Errors_' qcq 'SRT' qcq 'Target_' qcq 'Correct_' qcq '-mat' q ')']);

%rename LFP channels for consistency
clear ADlist
varlist = who;
chanlist = varlist(strmatch('AD',varlist));
clear varlist

plottime = (-50:400);

%Find all possible pairings of LFP channels
pairings = nchoosek(1:length(chanlist),2);


%Compute comparisons backwards so we get LFP correlations out first
for pair = size(pairings,1):-1:1
    disp(['Comparing... ' cell2mat(chanlist(pairings(pair,1))) ' vs ' cell2mat(chanlist(pairings(pair,2))) ' ... ' mat2str(size(pairings,1) - pair + 1) ' of ' mat2str(size(pairings,1))])

    fixErrors
    error_skip = 0;
    set_size_skip = 0;
    homog_skip = 0;

    %====================================================
    % SET UP DATA
    %find relevant trials, exclude catch trials (255)
    correct = find(Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    errors = find(Target_(:,2) ~= 255 & Errors_(:,5) == 1 & SRT(:,1) <= 2000 & SRT(:,1) >= 100);
    ss2 = find(Target_(:,5) == 2 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT >= 100);
    ss4 = find(Target_(:,5) == 4 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT >= 100);
    ss8 = find(Target_(:,5) == 8 & Target_(:,2) ~= 255 & Correct_(:,2) == 1 & SRT(:,1) <= 2000 & SRT >= 100);
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
    sig1_correct = sig1(correct,450:900);
    sig1_correct_baseline = sig1(correct,1:451);

    sig1_errors =  sig1(errors,450:900);
    sig1_errors_baseline = sig1(errors,1:451);

    sig1_correct_ss2 = sig1(ss2,450:900);
    sig1_correct_ss2_baseline = sig1(ss2,1:451);

    sig1_correct_ss4 = sig1(ss4,450:900);
    sig1_correct_ss4_baseline = sig1(ss4,1:451);

    sig1_correct_ss8 = sig1(ss8,450:900);
    sig1_correct_ss8_baseline = sig1(ss8,1:451);

    %homogeneity (note: limit only to set sizes 4 and 8 since set size 2
    %will always have only one distractor
    sig1_correct_homo = sig1(homo,450:900);
    sig1_correct_homo_baseline = sig1(homo,1:451);

    sig1_correct_hete = sig1(hete,450:900);
    sig1_correct_hete_baseline = sig1(hete,1:451);


    sig2 = eval(cell2mat(chanlist(pairings(pair,2))));
    sig2_correct = sig2(correct,450:900);
    sig2_correct_baseline = sig2(correct,1:451);

    sig2_errors =  sig2(errors,450:900);
    sig2_errors_baseline = sig2(errors,1:451);

    sig2_correct_ss2 = sig2(ss2,450:900);
    sig2_correct_ss2_baseline = sig2(ss2,1:451);

    sig2_correct_ss4 = sig2(ss4,450:900);
    sig2_correct_ss4_baseline = sig2(ss4,1:451);

    sig2_correct_ss8 = sig2(ss8,450:900);
    sig2_correct_ss8_baseline = sig2(ss8,1:451);

    %homogeneity (note: limit only to set sizes 4 and 8 since set size 2
    %will always have only one distractor
    sig2_correct_homo = sig2(homo,450:900);
    sig2_correct_homo_baseline = sig2(homo,1:451);

    sig2_correct_hete = sig2(hete,450:900);
    sig2_correct_hete_baseline = sig2(hete,1:451);

    %Get saccade-aligned traces


    %==========================================================================

    clear sig1 sig2 correct errors ss2 ss4 ss8 homo hete


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % JPSTC
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %===================================
    %Pre-allocate space
    JPSTC_correct(1:451,1:451) = NaN;
    JPSTC_errors(1:451,1:451) = NaN;
    JPSTC_correct_ss2(1:451,1:451) = NaN;
    JPSTC_correct_ss4(1:451,1:451) = NaN;
    JPSTC_correct_ss8(1:451,1:451) = NaN;
    JPSTC_correct_homo(1:451,1:451) = NaN;
    JPSTC_correct_hete(1:451,1:451) = NaN;

    JPSTC_correct_baseline(1:451,1:451) = NaN;
    JPSTC_errors_baseline(1:451,1:451) = NaN;
    JPSTC_correct_ss2_saccade(1:451,1:451) = NaN;
    JPSTC_correct_ss4_baseline(1:451,1:451) = NaN;
    JPSTC_correct_ss8_baseline(1:451,1:451) = NaN;
    JPSTC_correct_homo_baseline(1:451,1:451) = NaN;
    JPSTC_correct_hete_baseline(1:451,1:451) = NaN;
    %====================================




    %================================================
    %===================MAIN LOOPS===================
    %================================================
    % 1) CORRECT TRIALS
    %   use times -50 to 400
    disp('Running... [Correct Trials Targ-align & Sacc-align, Shift-Predictor]')
    
    JPSTC_correct = corr(sig1_correct,sig2_correct);
    JPSTC_correct_baseline = corr(sig1_correct_baseline,sig2_correct_baseline);
%     for time1 = 1:size(sig1_correct,2)
%         for time2 = 1:size(sig2_correct,2)
%             JPSTC_correct(time1,time2) = corr(sig1_correct(:,time1),sig2_correct(:,time2));
%             JPSTC_correct_baseline(time1,time2) = corr(sig1_correct_baseline(:,time1),sig2_correct_baseline(:,time2));
%         end
%     end

    n_correct = size(sig1_correct,1);
    clear sig1_correct sig2_correct sig1_correct_baseline sig2_correct_baseline


    % 2) Error TRIALS
    %    use times -50 to 400
    if error_skip ~= 1
        disp('Running... [Error Trials]')
        
        JPSTC_errors = corr(sig1_errors,sig2_errors);
        JPSTC_errors_baseline = corr(sig1_errors_baseline,sig2_errors_baseline);
%         for time1 = 1:size(sig1_errors,2)
%             for time2 = 1:size(sig2_errors,2)
%                 JPSTC_errors(time1,time2) = corr(sig1_errors(:,time1),sig2_errors(:,time2));
%                 JPSTC_errors_baseline(time1,time2) = corr(sig1_errors_baseline(:,time1),sig2_errors_baseline(:,time2));
%             end
%         end

        n_errors = size(sig1_errors,1);
        clear sig1_errors sig2_errors sig1_errors_baseline sig2_errors_baseline
    else
        disp('No Errors found...skipping')
    end

    if set_size_skip ~= 1
        % 3) CORRECT TRIALS, SET SIZE 2
        disp('Running... [Correct Trials, Set Size 2]')
        
        JPSTC_correct_ss2 = corr(sig1_correct_ss2,sig2_correct_ss2);
        JPSTC_correct_ss2_baseline = corr(sig1_correct_ss2_baseline,sig2_correct_ss2_baseline);
%         for time1 = 1:size(sig1_correct_ss2,2)
%             for time2 = 1:size(sig2_correct_ss2,2)
%                 JPSTC_correct_ss2(time1,time2) = corr(sig1_correct_ss2(:,time1),sig2_correct_ss2(:,time2));
%                 JPSTC_correct_ss2_baseline(time1,time2) = corr(sig1_correct_ss2_baseline(:,time1),sig2_correct_ss2_baseline(:,time2));
%             end
%         end

        n_ss2 = size(sig1_correct_ss2,1);
        clear sig1_correct_ss2 sig2_correct_ss2 sig1_correct_ss2_baseline sig2_correct_ss2_baseline

        % 4) CORRECT TRIALS, SET SIZE 4
        disp('Running... [Correct Trials, Set Size 4]')
        
        JPSTC_correct_ss4 = corr(sig1_correct_ss4,sig2_correct_ss4);
        JPSTC_correct_ss4_baseline = corr(sig1_correct_ss4_baseline,sig2_correct_ss4_baseline);
%         for time1 = 1:size(sig1_correct_ss4,2)
%             for time2 = 1:size(sig2_correct_ss4,2)
%                 JPSTC_correct_ss4(time1,time2) = corr(sig1_correct_ss4(:,time1),sig2_correct_ss4(:,time2));
%                 JPSTC_correct_ss4_baseline(time1,time2) = corr(sig1_correct_ss4_baseline(:,time1),sig2_correct_ss4_baseline(:,time2));
%             end
%         end

        n_ss4 = size(sig1_correct_ss4,1);
        clear sig1_correct_ss4 sig2_correct_ss4 sig1_correct_ss4_saccade sig2_correct_ss4_saccade

        % 5) CORRECT TRIALS, SET SIZE 8
        disp('Running... [Correct Trials, Set Size 8]')
        
        JPSTC_correct_ss8 = corr(sig1_correct_ss8,sig2_correct_ss8);
        JPSTC_correct_ss8_baseline = corr(sig1_correct_ss8_baseline,sig2_correct_ss8_baseline);
%         for time1 = 1:size(sig1_correct_ss8,2)
%             for time2 = 1:size(sig2_correct_ss8,2)
%                 JPSTC_correct_ss8(time1,time2) = corr(sig1_correct_ss8(:,time1),sig2_correct_ss8(:,time2));
%                 JPSTC_correct_ss8_baseline(time1,time2) = corr(sig1_correct_ss8_baseline(:,time1),sig2_correct_ss8_baseline(:,time2));
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
        JPSTC_correct_homo_baseline = corr(sig1_correct_homo_baseline,sig2_correct_homo_baseline);
%         for time1 = 1:size(sig1_correct_homo,2)
%             for time2 = 1:size(sig2_correct_homo,2)
%                 JPSTC_correct_homo(time1,time2) = corr(sig1_correct_homo(:,time1),sig2_correct_homo(:,time2));
%                 JPSTC_correct_homo_baseline(time1,time2) = corr(sig1_correct_homo_baseline(:,time1),sig2_correct_homo_baseline(:,time2));
%             end
%         end

        n_homo = size(sig1_correct_homo,1);
        clear sig1_correct_homo sig2_correct_homo sig1_correct_homo_saccade sig2_correct_homo_saccade

        % 7) CORRECT TRIALS, heterogeneous distractors
        disp('Running... [Correct Trials, Heterogeneous]')
        
        JPSTC_correct_hete = corr(sig1_correct_hete,sig2_correct_hete);
        JPSTC_correct_hete_baseline = corr(sig1_correct_hete_baseline,sig2_correct_hete_baseline);
%         for time1 = 1:size(sig1_correct_hete,2)
%             for time2 = 1:size(sig2_correct_hete,2)
%                 JPSTC_correct_hete(time1,time2) = corr(sig1_correct_hete(:,time1),sig2_correct_hete(:,time2));
%                 JPSTC_correct_hete_baseline(time1,time2) = corr(sig1_correct_hete_baseline(:,time1),sig2_correct_hete_baseline(:,time2));
%             end
%         end

        n_hete = size(sig1_correct_hete,1);
        clear sig1_correct_hete sig2_correct_hete sig1_correct_hete_saccade sig2_correct_hete_saccade

    else
        disp('Missing Homogeneous or Heterogeneous trials...skipping')
    end

    %     ======================================================================
    %     =====================End Main Loops===================================




    %======================================
    % Save Variables
    if saveFlag == 1
        save(['//scratch/heitzrp/Output/JPSTC_matrices/baseline500/' file '_' cell2mat(chanlist(pairings(pair,1))) cell2mat(chanlist(pairings(pair,2))) '_JPSTC_reg.mat'],'plottime','JPSTC_correct','JPSTC_correct_baseline','JPSTC_errors','JPSTC_errors_baseline','JPSTC_correct_ss2','JPSTC_correct_ss2_baseline','JPSTC_correct_ss4','JPSTC_correct_ss4_baseline','JPSTC_correct_ss8','JPSTC_correct_ss8_baseline','JPSTC_correct_homo','JPSTC_correct_homo_baseline','JPSTC_correct_hete','JPSTC_correct_hete_baseline','-mat')
    end

    %======================================



    %clean up variables that will change between comparisons for safety
    clear JPSTC_correct JPSTC_correct_baseline JPSTC_errors ...
        JPSTC_errors_baseline JPSTC_correct_ss2 ...
        JPSTC_correct_ss2_baseline JPSTC_correct_ss4 JPSTC_correct_ss4_baseline ...
        JPSTC_correct_ss8 JPSTC_correct_ss8_baseline JPSTC_correct_homo ...
        JPSTC_correct_homo_baseline JPSTC_correct_hete JPSTC_correct_hete_baseline ...


end %for current session

disp('Completed')
disp(['Run Time = ' mat2str(round(toc / 60))  ' Minutes'])%elapsed time in minutes