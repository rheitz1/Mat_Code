% returns single-trial SDFs
% removeFlag determines whether or not you want to remove sets of 10 trials
% in a row without spikes (will not alter SDF shape but will affect
% absolute firing rates

% RPH

function [SDF] = sSDF(Spike,Align_Time,Plot_Time,removeFlag)

parallelCheck

%by default, remove runs of 10 consecutive trials with no spikes.
if nargin < 4; removeFlag = 1; end

%find empty trials before convolution because convolution shortens spike
%trains to Plot_Time.  If we do before, will have equivalent results given
%by spikedensityfunct
if removeFlag == 1
    %if find 10 or more trials in a row with no spikes, remove (set to NaN)
    areNoSpikes = (sum(Spike,2));
    remove = findRuns(areNoSpikes,10,0);
end



%If Align_Time is full matrix of SRTs (because response-align),
%keep only the first column, which is the first saccadic RT.
if size(Align_Time,2) > 1
    Align_Time = Align_Time(:,1);
end

%check to see if response align or target align.
%if target aligned, Align_Time will all be 500. Otherwise, need to correct
%SRT values by 500 ms.

% if ~isempty(nonzeros(sum(Align_Time - 500)))
%     Align_Time = Align_Time + 500;
% end

%preallocate
SDF(1:size(Spike,1),1:length(Plot_Time(1):Plot_Time(2))) = NaN;

%get SDF for each trial



if useParallel
    parfor trl = 1:size(Spike,1)
        %SDF(trl,1:length(Plot_Time(1):Plot_Time(2))) = spikeDensityfunction_singletrial(Spike(trl,:), Align_Time(trl), Plot_Time);
        SDF(trl,:) = spikeDensityfunction_singletrial(Spike(trl,:), Align_Time(trl), Plot_Time);
    end
else
    for trl = 1:size(Spike,1)
        %SDF(trl,1:length(Plot_Time(1):Plot_Time(2))) = spikeDensityfunction_singletrial(Spike(trl,:), Align_Time(trl), Plot_Time);
        SDF(trl,:) = spikeDensityfunction_singletrial(Spike(trl,:), Align_Time(trl), Plot_Time);
    end
end

%remove AFTER convolution because convolution will return 0's with NaN
%input.
if removeFlag == 1
    if ~isempty(remove)
        disp(['Removing ' mat2str(length(remove)) ' (' mat2str( round((length(remove) / size(Spike,1))*100) ) '%) trials with no spikes (10 or more consecutive)'])
        SDF(remove,1:size(SDF,2)) = NaN;
    end
end
