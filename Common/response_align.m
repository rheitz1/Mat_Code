% Returns a response-aligned AD signal
% If SRT is NaN or if Plot_Time is out of range of available signal, returns
% a NaN;
%
% if flag == 1, then truncate at 2nd saccade: criteria is that 2nd saccade
% must be at least 80 ms after 1st saccade and obviously, fall within the
% Plot_Time window we are interested in.
% 
% RPH
% Edited 2009: vectorized method 100x faster than loop
% Assumes that each trial exactly 3001 ms long

function sig_resp = response_align(sig,allSRT,Plot_Time,truncFlag,TruncTime)

Target_= evalin('caller','Target_');

%if size(sig,2) > 3001; error('Wrong matrix dimensions - expecting 500 ms baseline'); end

if nargin < 5
    %if no truncation time specified, use end of plotting window
    TruncTime = Plot_Time(2);
end

if nargin < 4
    truncFlag = 0;
    %if no truncation time specified, use end of plotting window
    TruncTime = Plot_Time(2);
end

SRT = allSRT(:,1);

%================================================
% OLD METHOD
% for trl = 1:size(sig,1)
%     try
%         sig_resp(trl,1:length(Plot_Time(1):Plot_Time(2))) = sig(trl,ceil(SRT(trl,1) + (Plot_Time(1)+Target_(1,1)):ceil(SRT(trl,1) + (Plot_Time(2) + Target_(1,1)))));
%     catch
%         sig_resp(trl,1:length(Plot_Time(1):Plot_Time(2))) = NaN;
%     end
% end
%================================================


%================================================
% VECTORIZED METHOD

%vectorize AD channel. Must transpose first
sig = sig';
ADvec = sig(:);

%need to replace NaN values in SRT with 0's.  Won't matter because we will 
%then add them to the list of trials to remove later.
%adding them to the OutOfBound variable
remove = find(isnan(SRT(:,1)));
SRT(find(isnan(SRT(:,1)))) = 0;

%%% Special Fix for case when 1st saccade is NaN %%%
% In such cases, likely to fall out-of-bound (removed anyway) but will end
% up with negative index values, causing script to fail.  in this case, set
% SRT to abs(Plot_Time(1)) so it can't fail.  Again, won't matter because
% these trials are set to NaN later.
if SRT(1,1) == 0
    SRT(1,1) = abs(Plot_Time(1));
end


%create vector index based on length of desired time window.
%Because we transposed the matrix, use size of dimension 1, which will
%actually be time.
%E.g.: 1:3001:3001*nTrials will yield a vector of time stamps. Each time
%stamp is the vectorized index of the START of each trial.
indexer = (1:size(sig,1):size(sig,1)*length(SRT))';

%Adding SRT value to vector index yields vectorized index of saccade onset
%time.  Need to correct by -1 because first index is 1 and by +500 because
%T/L vis search data contains 500 ms baseline.
SRT_index = indexer + (ceil(SRT) - 1) + Target_(1,1);

%make sure we do not index out of bounds.
%due to vectorized notation, if we try to index too early a time point, the
%script will not fail. Rather, it will index the END of the previous trial.
%Because we have exactly 3001 ms of data/trial, check to make sure we
%aren't trying to index outside of -500:2500 (3001 ms).
OutOfBound = find(SRT - abs(Plot_Time(1)) < -Target_(1,1) | SRT + abs(Plot_Time(2)) > (size(sig,1) - Target_(1,1)-1));
OutOfBound = [remove;OutOfBound];

%tile SRT_index times
%this is a tiled matrix of each of the SRT onset times in vector format.
tile_SRT_index = repmat(SRT_index,1,length(Plot_Time(1):Plot_Time(2)));

%create subtraction matrix.
%to create correct time window, create a tiled matrix of subtraction
%factor. e.g., if we want -200:200, create vector of -200:200
window = Plot_Time(1):Plot_Time(2);
window = repmat(window,size(sig,2),1);

%new indices
%adding the tiled SRT onset times in vector notation with the desired
%window times yields the vector indices of the actual AD values.
new_index = tile_SRT_index + window;
clear SRT_index tile_SRT_index window

%saccade-aligned matrix
%indexing the vectorized AD matrix with the new indices yields the
%corrected signal
sig_resp = ADvec(new_index);

%remove out-of-bound trials
sig_resp(OutOfBound,:) = NaN;

%truncate at 2nd saccade if option is set
if truncFlag == 1
    % truncate on second saccade
    % criteria: second saccade must be at least 80 ms after 1st saccade for
    % removal
    
    for trl = 1:size(SRT,1)
        try
            SecondSaccRT = allSRT(trl,find(nonzeros(allSRT(trl,:)) > allSRT(trl,1) + 80,1));
        catch
            SecondSaccRT = NaN;
        end
        
        %if criteria met for a second saccade and is in window we are plotting,
        %, set those times to NaN
        if ~isnan(SecondSaccRT) & (SecondSaccRT - allSRT(trl,1)) <= TruncTime
            %set times to NaN.  Time to start cutting off is difference
            %between 2nd saccade and 1st saccade (because are already
            %response-aligned, difference will be onset time of 2nd
            %saccade, shifted forward by Plot_Time(1))
            sig_resp(trl,SecondSaccRT - allSRT(trl,1) + abs(Plot_Time(1)):end) = NaN;
        end
    end
end

%================================================