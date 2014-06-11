function [TDT t_obt p_obt ci df] = getJackKnife_TDT(time_vector,data_1_in,data_1_out,data_2_in,data_2_out,alpha,plotFlag)

% Jack-knife based test of TDT between two conditions
% time_vector is a vector of time in ms
% data is a sessions x time matrix where columns represent the time vector specified in time_vector
% data1_in is condition 1, Target_in_RF trials
% data1_out is condition 1, Distractor_in_RF trials
% same for data2
%
% Because this amounts to a dependent-samples t-test, the conditions should be matched and have an equal
% number of rows (corresponding to equal number of sessions or trials)
%
% Method = Wilcoxon uses the Wilcoxon Signed-Rank test
%
% This version will also give you the TDT calculated across the population
% entered.  Assuming enough sessions were run and are input, this will give
% a better estimate of grand-average TDT
%
%
% From Miller, Patterson, & Ulrich (1998)
%
% RPH
warning off
parallelCheck
tic

nRuns2sig = 10; %how many significant values in a row


%switch to run on single-sessions (i.e., ranksum, not signrank)
if size(data_1_in,1) ~= size(data_2_in,1)
    disp('Unequal sample sizes detected.  Doing RANKSUM test for between-subjects comparisons')
    single_sess_switch = 1;
else
    disp('Doing SIGNRANK test for within-subjects comparisons')
    single_sess_switch = 0;
end


if length(time_vector) ~= size(data_1_in,2)
    error('Time vector not the same size as the data vector')
end

if size(data_1_in) ~= size(data_2_in)
    error('Data vectors not equal')
end

if nargin < 7; plotFlag = 0; end
if nargin < 6; alpha = .01; end

disp(['Alpha = ' mat2str(alpha)])

%remove trials that are all NaN
remove1 = find(all(isnan(data_1_in),2));
remove2 = find(all(isnan(data_1_out),2));
remove3 = find(all(isnan(data_2_in),2));
remove4 = find(all(isnan(data_2_out),2));
remove = [remove1 ; remove2 ; remove3 ; remove4];
remove = unique(remove);

disp(['Removing ' mat2str(length(remove)) ' trials with NaNs']);

data_1_in(remove,:) = [];
data_1_out(remove,:) = [];
data_2_in(remove,:) = [];
data_2_out(remove,:) = [];

%Note: Using sign-rank, not ranksum because this is within-subjects

%===========
% Step 1, get the onset time for all the data averaged over sessions

data1_in_av = nanmean(data_1_in);
data1_out_av = nanmean(data_1_out);
data2_in_av = nanmean(data_2_in);
data2_out_av = nanmean(data_2_out);

% Find the TDT occuring after 100 ms
startt = find(time_vector == 100);

% Find the last time point for which there are non-NaN values
% endt = min([min(find(all(isnan(data_1_in)))) ...
%     min(find(all(isnan(data_1_out)))) ...
%     min(find(all(isnan(data_2_in)))) ...
%     min(find(all(isnan(data_2_out))))]) - 1;

w = isnan(data_1_in);
x = isnan(data_1_out);

wx = w + x; %if both trials are NaN, will be 2.  If 1 is NaN, will be 1.
% need to find the last set of common trials where both signals have at
% least 2 viable values (column that has two 0's).
wx(find(wx > 0)) = NaN;
wx(find(wx == 0)) = 1;
WX = nansum(wx);
endt1 = find(WX == 2,1,'last');

y = isnan(data_2_in);
z = isnan(data_2_out);
yz = y + z;

yz(find(yz > 0)) = NaN;
yz(find(yz == 0)) = 1;
YZ = nansum(yz);
endt2 = find(YZ == 2,1,'last');

%just to be fair, limit search space for all signals to same time point
endt = min([endt1 endt2]);


if isempty(endt); endt = size(data_1_in,2); end

if useParallel
    if single_sess_switch == 0
        parfor time = startt:endt
            [p_dat1(time,1) h_dat1(time,1)] = signrank(data_1_in(:,time),data_1_out(:,time),'alpha',alpha,'method','approximate');
            [p_dat2(time,1) h_dat2(time,1)] = signrank(data_2_in(:,time),data_2_out(:,time),'alpha',alpha,'method','approximate');
        end
    elseif single_sess_switch == 1
        parfor time = startt:endt
            [p_dat1(time,1) h_dat1(time,1)] = ranksum(data_1_in(:,time),data_1_out(:,time),'alpha',alpha,'method','approximate');
            [p_dat2(time,1) h_dat2(time,1)] = ranksum(data_2_in(:,time),data_2_out(:,time),'alpha',alpha,'method','approximate');
        end
    end
else
    if single_sess_switch == 0
        for time = startt:endt
            [p_dat1(time,1) h_dat1(time,1)] = signrank(data_1_in(:,time),data_1_out(:,time),'alpha',alpha,'method','approximate');
            [p_dat2(time,1) h_dat2(time,1)] = signrank(data_2_in(:,time),data_2_out(:,time),'alpha',alpha,'method','approximate');
        end
    elseif single_sess_switch == 1
        parfor time = startt:endt
            [p_dat1(time,1) h_dat1(time,1)] = ranksum(data_1_in(:,time),data_1_out(:,time),'alpha',alpha,'method','approximate');
            [p_dat2(time,1) h_dat2(time,1)] = ranksum(data_2_in(:,time),data_2_out(:,time),'alpha',alpha,'method','approximate');
        end
    end
end
% Find that value

%TDT_ix_1 = min(findRuns(h_dat1,10));
%TDT_ix_2 = min(findRuns(h_dat2,10));
TDT_ix_1 = min(strfind(h_dat1',ones(1,nRuns2sig)));
TDT_ix_2 = min(strfind(h_dat2',ones(1,nRuns2sig)));

%
% % Use linear interpolation to get a better estimate of onset times
% a = time_vector(onset_ix_1 - 1);
% b = (time_vector(onset_ix_1) - time_vector(onset_ix_1-1));
% c = (data1_av(onset_ix_1) - dat1_av(onset_ix_1-1)) / (dat1_av(onset_ix_1+1) - dat1_av(onset_ix_1-1));
%
% onset_1 = a + b * c;
%
% a = time_vector(onset_ix_2 - 1);
% b = (time_vector(onset_ix_2) - time_vector(onset_ix_2-1));
% c = (dat2_av(onset_ix_2) - dat2_av(onset_ix_2-1)) / (dat2_av(onset_ix_2+1) - dat2_av(onset_ix_2-1));
%
% onset_2 = a + b * c;
%
% clear a b c

% Keep grand average, linearly interpolated onset times.
grand_average_onset1 = time_vector(TDT_ix_1);
grand_average_onset2 = time_vector(TDT_ix_2);

TDT = [grand_average_onset1 grand_average_onset2];

if length(TDT) < 2; error('At least 1 GRAND TDT could not be calculated'); end
%Save the Grand Mean difference for later testing
GRAND_DIFF = TDT(1) - TDT(2);



%=============
% Step 2
% Leave-one-out method.  Redo above calculation n times, each time leaving one of the n out
%

n_calcs = size(data_1_in,1);

if useParallel
    parfor calc = 1:n_calcs
        %  w = waitbar(calc/n_calcs);
        % Re-set to original cleaned data to put back what we previously removed
        cur_dat_in_1 = data_1_in;
        cur_dat_out_1 = data_1_out;
        cur_dat_in_2 = data_2_in;
        cur_dat_out_2 = data_2_out;
        
        % Remove a particular data set by setting it to NaN.  signrank will
        % just disregard those values as if they do not exist
        cur_dat_in_1(calc,:) = NaN;
        cur_dat_out_1(calc,:) = NaN;
        cur_dat_in_2(calc,:) = NaN;
        cur_dat_out_2(calc,:) = NaN;
        
        
        if single_sess_switch == 0
            [p_dat1 h_dat1] = helperfun_timeTest(cur_dat_in_1,cur_dat_out_1,alpha,endt);
            [p_dat2 h_dat2] = helperfun_timeTest(cur_dat_in_2,cur_dat_out_2,alpha,endt);
        elseif single_sess_switch == 1
            [p_dat1 h_dat1] = helperfun_timeTest_singlesess(cur_dat_in_1,cur_dat_out_1,alpha,endt);
            [p_dat2 h_dat2] = helperfun_timeTest_singlesess(cur_dat_in_2,cur_dat_out_2,alpha,endt);
        end
        
        
        TDT_ix_1 = min(strfind(h_dat1',ones(1,nRuns2sig)));
        TDT_ix_2 = min(strfind(h_dat2',ones(1,nRuns2sig)));
        
        
        
        % Use linear interpolation to get a better estimate of onset times
        %     a = time_vector(onset_ix_1 - 1);
        %     b = (time_vector(onset_ix_1) - time_vector(onset_ix_1-1));
        %     c = (dat1_av(onset_ix_1) - dat1_av(onset_ix_1-1)) / (dat1_av(onset_ix_1+1) - dat1_av(onset_ix_1-1));
        %
        %     onset_1 = a + b * c;
        %
        %     a = time_vector(onset_ix_2 - 1);
        %     b = (time_vector(onset_ix_2) - time_vector(onset_ix_2-1));
        %     c = (dat2_av(onset_ix_2) - dat2_av(onset_ix_2-1)) / (dat2_av(onset_ix_2+1) - dat2_av(onset_ix_2-1));
        %
        %     onset_2 = a + b * c;
        %
        %     clear a b c
        
        %keep track of current difference
        if length([TDT_ix_1 TDT_ix_2]) < 2; error('At least 1 SUBSAMPLE TDT could not be calculated'); end
        JACK_KNIFE_DIFF(calc,1) = time_vector(TDT_ix_1) - time_vector(TDT_ix_2);
    end
    
else
    for calc = 1:n_calcs
        %  w = waitbar(calc/n_calcs);
        % Re-set to original cleaned data to put back what we previously removed
        cur_dat_in_1 = data_1_in;
        cur_dat_out_1 = data_1_out;
        cur_dat_in_2 = data_2_in;
        cur_dat_out_2 = data_2_out;
        
        % Remove a particular data set by setting it to NaN.  signrank will
        % just disregard those values as if they do not exist
        cur_dat_in_1(calc,:) = NaN;
        cur_dat_out_1(calc,:) = NaN;
        cur_dat_in_2(calc,:) = NaN;
        cur_dat_out_2(calc,:) = NaN;
        
        
        if single_sess_switch == 0
            [p_dat1 h_dat1] = helperfun_timeTest(cur_dat_in_1,cur_dat_out_1,alpha,endt);
            [p_dat2 h_dat2] = helperfun_timeTest(cur_dat_in_2,cur_dat_out_2,alpha,endt);
        elseif single_sess_switch == 1
            [p_dat1 h_dat1] = helperfun_timeTest_singlesess(cur_dat_in_1,cur_dat_out_1,alpha,endt);
            [p_dat2 h_dat2] = helperfun_timeTest_singlesess(cur_dat_in_2,cur_dat_out_2,alpha,endt);
        end
        
        
        TDT_ix_1 = min(strfind(h_dat1',ones(1,nRuns2sig)));
        TDT_ix_2 = min(strfind(h_dat2',ones(1,nRuns2sig)));
        
        
        
        % Use linear interpolation to get a better estimate of onset times
        %     a = time_vector(onset_ix_1 - 1);
        %     b = (time_vector(onset_ix_1) - time_vector(onset_ix_1-1));
        %     c = (dat1_av(onset_ix_1) - dat1_av(onset_ix_1-1)) / (dat1_av(onset_ix_1+1) - dat1_av(onset_ix_1-1));
        %
        %     onset_1 = a + b * c;
        %
        %     a = time_vector(onset_ix_2 - 1);
        %     b = (time_vector(onset_ix_2) - time_vector(onset_ix_2-1));
        %     c = (dat2_av(onset_ix_2) - dat2_av(onset_ix_2-1)) / (dat2_av(onset_ix_2+1) - dat2_av(onset_ix_2-1));
        %
        %     onset_2 = a + b * c;
        %
        %     clear a b c
        
        %keep track of current difference
        if length([TDT_ix_1 TDT_ix_2]) < 2; error('At least 1 SUBSAMPLE TDT could not be calculated'); end
        JACK_KNIFE_DIFF(calc,1) = time_vector(TDT_ix_1) - time_vector(TDT_ix_2);
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

df = n_calcs-1;
% get observed p value using t-distribution CDF at n-1 df
p_obt = 1 - tcdf(abs(t_obt),df);

% Find the critical t, two-tailed, with a 95% rejection region (so 2.5% on either side)
t_crit = tinv(.975,(n_calcs-1));


%NOTE: THESE CI'S DON'T SEEM TO WORK RIGHT.  SOMETIMES P < .05 AND CI OVERLAPS 0!!
ci(1) = GRAND_DIFF - t_crit*sem_d;
ci(2) = GRAND_DIFF + t_crit*sem_d;



if plotFlag
    figure
    plot(time_vector,nanmean(data_1_in),'b',time_vector,nanmean(data_1_out),'--b', ...
        time_vector,nanmean(data_2_in),'r',time_vector,nanmean(data_2_out),'--r')
    vline(TDT(1),'b')
    vline(TDT(2),'r')
    box off
    xlim([-200 800])
    title(['TDT 1 = ' mat2str(TDT(1)) '  TDT 2 = ' mat2str(TDT(2))])
end

%close(w)
toc
end

function [p_dat1 h_dat1] = helperfun_timeTest_singlesess(dat1,dat2,alpha,endt)
    for time = 1:endt
        [p_dat1(time,1) h_dat1(time,1)] = ranksum(dat1(:,time),dat2(:,time),'alpha',alpha','method','approximate');
    end
end

function [p_dat1 h_dat1] = helperfun_timeTest(dat1,dat2,alpha,endt)
    for time = 1:endt
        [p_dat1(time,1) h_dat1(time,1)] = signrank(dat1(:,time),dat2(:,time),'alpha',alpha','method','approximate');
    end
end