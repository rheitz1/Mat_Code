% Returns a fixation-aligned AD signal for those sessions that include the
% FixTime_Jit_ variable (older) or FixAcqTime variable (newer)
%
% NOTE: if using FixTime_Jit_, need to send in NEGATIVE values
%
% If Plot Time window on a trial is out of range of available signal, returns
% a NaN;
% 
% RPH
% Edited 2012 : vectorized method 100x faster than loop


function sig_fix = fix_align(sig,FixTimes,Plot_Time)

%Make sure we are using the correct values, which is FixAcqTime
if any(FixTimes > 0); error('Check Fixation Acquire Time variable'); end

Target_= evalin('caller','Target_');


% %================================================
% % OLD METHOD
% for trl = 1:size(sig,1)
%     try
%         sig_fix(trl,1:length(Plot_Time(1):Plot_Time(2))) = sig(trl,ceil(Target_(1,1) - FixTimes(trl,1) + Plot_Time(1):ceil(Target_(1,1) - FixTimes(trl,1) + Plot_Time(2))));
%     catch
%         sig_fix(trl,1:length(Plot_Time(1):Plot_Time(2))) = NaN;
%     end
% end
% %================================================
% 


%================================================
% VECTORIZED METHOD

%vectorize AD channel. Must transpose first
sig = sig';
ADvec = sig(:);

%need to replace NaN values in SRT with 0's.  Won't matter because we will 
%then add them to the list of trials to remove later.
%adding them to the OutOfBound variable
remove = find(isnan(FixTimes(:,1)));
FixTimes(find(isnan(FixTimes(:,1)))) = 2000; %Just set to arbitrary value so will not fail; will be removed

%%% Special fix for case when 1st observation is NaN %%%
% In such cases, likely to fall out-of-bound (removed anyway) but will end
% up with negative index values, causing script to fail.  in this case, set
% SRT to abs(Plot_Time(1)) so it can't fail.  Again, won't matter because
% these trials are set to NaN later.
if FixTimes(1,1) == 0
    FixTimes(1,1) = abs(Plot_Time(1));
end


%create vector index based on length of desired time window.
%Because we transposed the matrix, use size of dimension 1, which will
%actually be time.
%E.g.: 1:3001:3001*nTrials will yield a vector of time stamps. Each time
%stamp is the vectorized index of the START of each trial.
indexer = (1:size(sig,1):size(sig,1)*length(FixTimes))';

%Adding FixOn value to vector index yields vectorized index of fixation onset
%times.  Need to correct by -1 because first index is 1.  No need to correct
%by Target_(1,1) here because FixTimes are relative to trial onset w/
%baseline.

%FIX_index = indexer - (ceil(FixTimes) - 1) + Target_(1,1);

%If you are using FixAcqTime, the values are already relative to array onset (i.e., they are negative).
%To mark the moment of fixation acquire, then, take the baseline value + (the negative) number.
FIX_index = indexer + Target_(1,1) + FixTimes;


%make sure we do not index out of bounds.
%due to vectorized notation, if we try to index too early a time point, the
%script will not fail. Rather, it will index the END of the previous trial.
%Because we have exactly 3001 ms of data/trial, check to make sure we
%aren't trying to index outside of -500:2500 (3001 ms).
OutOfBound = find(FixTimes - abs(Plot_Time(1)) < -Target_(1,1) | FixTimes + abs(Plot_Time(2)) > (size(sig,1)));
OutOfBound = [remove;OutOfBound];
if ~isempty(OutOfBound); disp(['Removing ' mat2str(length(OutOfBound)) ' OUT OF BOUND trials']); end
    
%tile SRT_index times
%this is a tiled matrix in vector format.
tile_FIX_index = repmat(FIX_index,1,length(Plot_Time(1):Plot_Time(2)));

%create subtraction matrix.
%to create correct time window, create a tiled matrix of subtraction
%factor. e.g., if we want -200:200, create vector of -200:200
window = Plot_Time(1):Plot_Time(2);
window = repmat(window,size(sig,2),1);

%new indices
%adding the tiled SRT onset times in vector notation with the desired
%window times yields the vector indices of the actual AD values.
new_index = tile_FIX_index + window;
clear FIX_index tile_FIX_index window

%saccade-aligned matrix
%indexing the vectorized AD matrix with the new indices yields the
%corrected signal
sig_fix = ADvec(new_index);

%remove out-of-bound trials
sig_fix(OutOfBound,:) = NaN;


%================================================