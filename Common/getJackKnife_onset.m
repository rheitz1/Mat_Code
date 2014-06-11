function [onset_time t_obt p_obt ci] = getJackKnife_onset(time_vector,data_1,data_2,method,alpha,plotFlag)

% Jack-knife based test of onset times between two conditions
% time_vector is a vector of time in ms
% data is a trials x time or a sessions x time matrix where columns represent the time vector specified in time_vector
% data1 is condition 1, data2 is condition 2.
%
% Because this amounts to a dependent-samples t-test, the conditions should be matched and have an equal
% number of rows (corresponding to equal number of sessions or trials)
%
% Method = Wilcoxon uses the Wilcoxon Signed-Rank test to measure onset times
% Method = 50minmax uses the 50% max-min difference to measure onset times
%
%
% From Miller, Patterson, & Ulrich (1998)
%
% RPH

parallelCheck

tic
if nargin < 6; plotFlag = 0; end
if nargin < 5; alpha = .01; end %for Wilcoxon test only
if nargin < 4; method = 'Wilcoxon'; end

if length(time_vector) ~= size(data_1,2)
    error('Time vector not the same size as the data vector')
end

if size(data_1) ~= size(data_2)
    error('Data vectors not equal')
end

nRuns2sig = 10; %how many significant values in a row

if method == '50minmax'
    disp('REMEMBER TO RECTIFY NEGATIVE-GOING WAVES')
    %===========
    % Step 1, get the onset time for all the data averaged over sessions
    dat1_av = nanmean(data_1);
    dat2_av = nanmean(data_2);
    
    % Find the value of the max occurring after 100 ms
    startt = find(time_vector == 100);
    [max_dat1_val max_dat1_ix] = max(dat1_av(1:end));
    [max_dat2_val max_dat2_ix] = max(dat2_av(1:end));
    
    % Find minimum occurring before max but not earlier than -100 (because min can sometimes be there)
    %endt = find(time_vector == -100);
    %     [min_dat1_val min_dat1_ix] = min(dat1_av(end:1+max_dat1_ix));
    %     [min_dat2_val min_dat2_ix] = min(dat2_av(end:1+max_dat2_ix));
    [min_dat1_val min_dat1_ix] = min(dat1_av);
    [min_dat2_val min_dat2_ix] = min(dat2_av);
    
    %
    % Find 50% value
    max_min_diff_1 = (max_dat1_val - min_dat1_val) * .5;
    max_min_diff_2 = (max_dat2_val - min_dat2_val) * .5;
    
    % Find that value
    
    onset_ix_1 = find(dat1_av >= max_min_diff_1,1);
    onset_ix_2 = find(dat2_av >= max_min_diff_2,1);
    
    % Use linear interpolation to get a better estimate of onset times
    a = time_vector(onset_ix_1 - 1);
    b = (time_vector(onset_ix_1) - time_vector(onset_ix_1-1));
    c = (dat1_av(onset_ix_1) - dat1_av(onset_ix_1-1)) / (dat1_av(onset_ix_1+1) - dat1_av(onset_ix_1-1));
    
    onset_1 = a + b * c;
    
    a = time_vector(onset_ix_2 - 1);
    b = (time_vector(onset_ix_2) - time_vector(onset_ix_2-1));
    c = (dat2_av(onset_ix_2) - dat2_av(onset_ix_2-1)) / (dat2_av(onset_ix_2+1) - dat2_av(onset_ix_2-1));
    
    onset_2 = a + b * c;
    
    clear a b c
    
    % Keep grand average, linearly interpolated onset times.
    grand_average_onset1 = onset_1;
    grand_average_onset2 = onset_2;
    
    %Save the Grand Mean difference for later testing
    GRAND_DIFF = onset_1 - onset_2;
    
    
    
    %=============
    % Step 2
    % Leave-one-out method.  Re-do above calculation n times, each time leaving one of the n out
    %
    % First make sure there are no NaN's in the matrices
    cleaned_dat_1 = removeNaN(data_1);
    cleaned_dat_2 = removeNaN(data_2);
    
    n_calcs = size(cleaned_dat_1,1);
    
    for calc = 1:n_calcs
        % Re-set to original cleaned data to put back what we previously removed
        cur_dat_1 = cleaned_dat_1;
        cur_dat_2 = cleaned_dat_2;
        
        % Remove a particular data set by setting it to NaN;
        cur_dat_1(calc,:) = NaN;
        cur_dat_2(calc,:) = NaN;
        
        cur_dat_1 = nanmean(cur_dat_1);
        cur_dat_2 = nanmean(cur_dat_2);
        
        % Re-calculate 50% max-min onset time
        startt = find(time_vector == 100);
        [max_dat1_val max_dat1_ix] = max(cur_dat_1(1:end));
        [max_dat2_val max_dat2_ix] = max(cur_dat_2(1:end));
        
        % Find minimum occurring before max but not earlier than -100 (because min can sometimes be there)
        %         endt = find(time_vector == -100);
        %         [min_dat1_val min_dat1_ix] = min(cur_dat_1(end:1+max_dat1_ix));
        %         [min_dat2_val min_dat2_ix] = min(cur_dat_2(end:1+max_dat2_ix));
        [min_dat1_val min_dat1_ix] = min(cur_dat_1);
        [min_dat2_val min_dat2_ix] = min(cur_dat_2);
        
        %
        % Find 50% value
        max_min_diff_1 = (max_dat1_val - min_dat1_val) * .5;
        max_min_diff_2 = (max_dat2_val - min_dat2_val) * .5;
        
        % Find that value
        
        onset_ix_1 = find(dat1_av >= max_min_diff_1,1);
        onset_ix_2 = find(dat2_av >= max_min_diff_2,1);
        
        % Use linear interpolation to get a better estimate of onset times
        a = time_vector(onset_ix_1 - 1);
        b = (time_vector(onset_ix_1) - time_vector(onset_ix_1-1));
        c = (dat1_av(onset_ix_1) - dat1_av(onset_ix_1-1)) / (dat1_av(onset_ix_1+1) - dat1_av(onset_ix_1-1));
        
        onset_1 = a + b * c;
        
        a = time_vector(onset_ix_2 - 1);
        b = (time_vector(onset_ix_2) - time_vector(onset_ix_2-1));
        c = (dat2_av(onset_ix_2) - dat2_av(onset_ix_2-1)) / (dat2_av(onset_ix_2+1) - dat2_av(onset_ix_2-1));
        
        onset_2 = a + b * c;
        
        %keep track of current difference
        JACK_KNIFE_DIFF(calc,1) = onset_1 - onset_2;
        
        df = NaN; %no df for 50minmax method
    end
    
elseif method == 'Wilcoxon' | method == 'wilcoxon'
    %Note: Using sign-rank, not ranksum because this is between-subjects
    
    %===========
    % Step 1, get the onset time for all the data averaged over sessions
    data_1 = removeNaN(data_1);
    data_2 = removeNaN(data_2);
    
    dat1_av = nanmean(data_1);
    dat2_av = nanmean(data_2);
    
    if useParallel
        parfor time = 1:size(data_1,2)
            [wil_p_dat1(time,1) wil_h_dat1(time,1)] = signrank(data_1(:,time),0,'alpha',alpha','method','approximate');
            [wil_p_dat2(time,1) wil_h_dat2(time,1)] = signrank(data_2(:,time),0,'alpha',alpha','method','approximate');
        end
    else
        parfor time = 1:size(data_1,2)
            [wil_p_dat1(time,1) wil_h_dat1(time,1)] = signrank(data_1(:,time),0,'alpha',alpha','method','approximate');
            [wil_p_dat2(time,1) wil_h_dat2(time,1)] = signrank(data_2(:,time),0,'alpha',alpha','method','approximate');
        end
    end
    
    % Find that value
    
    %onset_ix_1 = min(findRuns(wil_h_dat1,10));
    %onset_ix_2 = min(findRuns(wil_h_dat2,10));
    
    onset_ix_1 = min(strfind(wil_h_dat1',ones(1,nRuns2sig)));
    onset_ix_2 = min(strfind(wil_h_dat2',ones(1,nRuns2sig)));
    
    % Use linear interpolation to get a better estimate of onset times
    a = time_vector(onset_ix_1 - 1);
    b = (time_vector(onset_ix_1) - time_vector(onset_ix_1-1));
    c = (dat1_av(onset_ix_1) - dat1_av(onset_ix_1-1)) / (dat1_av(onset_ix_1+1) - dat1_av(onset_ix_1-1));
    
    onset_1 = a + b * c;
    
    a = time_vector(onset_ix_2 - 1);
    b = (time_vector(onset_ix_2) - time_vector(onset_ix_2-1));
    c = (dat2_av(onset_ix_2) - dat2_av(onset_ix_2-1)) / (dat2_av(onset_ix_2+1) - dat2_av(onset_ix_2-1));
    
    onset_2 = a + b * c;
    
    clear a b c
    
    % Keep grand average, linearly interpolated onset times.
    grand_average_onset1 = onset_1;
    grand_average_onset2 = onset_2;
    
    %Save the Grand Mean difference for later testing
    GRAND_DIFF = onset_1 - onset_2;
    
    
    
    %=============
    % Step 2
    % Leave-one-out method.  Redo above calculation n times, each time leaving one of the n out
    %
    
    n_calcs = size(data_1,1);
    
    if useParallel
        parfor calc = 1:n_calcs
            %w = waitbar(calc/n_calcs);
            % Re-set to original cleaned data to put back what we previously removed
            cur_dat_1 = data_1;
            cur_dat_2 = data_2;
            
            % Remove a particular data set by setting it to NaN;
            cur_dat_1(calc,:) = NaN;
            cur_dat_2(calc,:) = NaN;
            
            
            [wil_p_dat1 wil_h_dat1] = helperfun_timeTest(cur_dat_1,cur_dat_2,alpha);
            
            
            onset_ix_1 = min(strfind(wil_h_dat1',ones(1,nRuns2sig)));
            onset_ix_2 = min(strfind(wil_h_dat2',ones(1,nRuns2sig)));
            
            
            %         % Use linear interpolation to get a better estimate of onset times
            a = time_vector(onset_ix_1 - 1);
            b = (time_vector(onset_ix_1) - time_vector(onset_ix_1-1));
            c = (dat1_av(onset_ix_1) - dat1_av(onset_ix_1-1)) / (dat1_av(onset_ix_1+1) - dat1_av(onset_ix_1-1));
            
            onset_1 = a + b * c;
            
            a = time_vector(onset_ix_2 - 1);
            b = (time_vector(onset_ix_2) - time_vector(onset_ix_2-1));
            c = (dat2_av(onset_ix_2) - dat2_av(onset_ix_2-1)) / (dat2_av(onset_ix_2+1) - dat2_av(onset_ix_2-1));
            
            onset_2 = a + b * c;
            
            
            
            %keep track of current difference
            JACK_KNIFE_DIFF(calc,1) = onset_1 - onset_2;
        end
    else
        for calc = 1:n_calcs
            %w = waitbar(calc/n_calcs);
            % Re-set to original cleaned data to put back what we previously removed
            cur_dat_1 = data_1;
            cur_dat_2 = data_2;
            
            % Remove a particular data set by setting it to NaN;
            cur_dat_1(calc,:) = NaN;
            cur_dat_2(calc,:) = NaN;
            
            
            [wil_p_dat1 wil_h_dat1] = helperfun_timeTest(cur_dat_1,cur_dat_2,alpha);
            
            
            onset_ix_1 = min(strfind(wil_h_dat1',ones(1,nRuns2sig)));
            onset_ix_2 = min(strfind(wil_h_dat2',ones(1,nRuns2sig)));
            
            
            %         % Use linear interpolation to get a better estimate of onset times
            a = time_vector(onset_ix_1 - 1);
            b = (time_vector(onset_ix_1) - time_vector(onset_ix_1-1));
            c = (dat1_av(onset_ix_1) - dat1_av(onset_ix_1-1)) / (dat1_av(onset_ix_1+1) - dat1_av(onset_ix_1-1));
            
            onset_1 = a + b * c;
            
            a = time_vector(onset_ix_2 - 1);
            b = (time_vector(onset_ix_2) - time_vector(onset_ix_2-1));
            c = (dat2_av(onset_ix_2) - dat2_av(onset_ix_2-1)) / (dat2_av(onset_ix_2+1) - dat2_av(onset_ix_2-1));
            
            onset_2 = a + b * c;
            
            
            
            %keep track of current difference
            JACK_KNIFE_DIFF(calc,1) = onset_1 - onset_2;
        end
    end
    
end





%=============
% Step 3
% Calculate standard error of the difference.  Be sure to take difference of absolute values, or values
% could sum
J = mean(JACK_KNIFE_DIFF);
sum_squares = sum( (JACK_KNIFE_DIFF - J).^2 );
%sem_d = sqrt( ( (n_calcs-1) / n_calcs ) .* sum_squares );
sem_d = sqrt( (sum_squares ./ (  (n_calcs-1) .* n_calcs )));

t_obt = GRAND_DIFF / sem_d;

% get observed p value using t-distribution CDF at n-1 df
p_obt = 1 - tcdf(abs(t_obt),(n_calcs-1));

% Find the critical t, two-tailed, with a 95% rejection region (so 97.5 on either side)
t_crit = tinv(.975,(n_calcs-1));

df = n_calcs - 1;

% Output Variables
onset_time.dat1 = grand_average_onset1;
onset_time.dat2 = grand_average_onset2;

%NOTE: THESE CI'S DON'T SEEM TO WORK RIGHT.  SOMETIMES P < .05 AND CI OVERLAPS 0!!
ci(1) = GRAND_DIFF - t_crit*sem_d;
ci(2) = GRAND_DIFF + t_crit*sem_d;

%close(w)

toc

    if plotFlag
        figure
        plot(time_vector,dat1_av,'r',time_vector,dat2_av)
        vline(onset_time.dat1,'r')
        vline(onset_time.dat2,'b')
        title(['Onset times = ' mat2str(onset_time.dat1) '   ' mat2str(onset_time.dat2)])
        box off
    end
end

function [wil_p_dat1 wil_h_dat1] = helperfun_timeTest(dat1,dat2,alpha)
    for time = 1:size(dat1,2)
        [wil_p_dat1(time,1) wil_h_dat1(time,1)] = signrank(dat1(:,time),0,'alpha',alpha','method','approximate');
        [wil_p_dat2(time,1) wil_h_dat2(time,1)] = signrank(dat2(:,time),0,'alpha',alpha','method','approximate');
    end
end
