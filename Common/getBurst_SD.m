% Estimates NL (neural latency) as first burst using method described in
% Lee, Kim, & Lee 2010, J Neurophysiol.
%
% 1) find average firing rate in 200 ms interval before stimulus onset for  each trial
% 2) compile average firing rate across trials and get sd
% 3) criterion for a given trial will be that trial's mean firing rate + global SD
% 4) find peak firing within some window on a given trial
% 5) step backwards until firing rate < trial mean baseline + global sd for at least 5 ms
%
% RPH

function [BurstStartTimes] = getBurst_SD(Spike,plotFlag)

if nargin < 2; plotFlag = 0; end

%window to search for peak firing rate = 50:300 (with 200 ms baseline period)
peakWindow = 200:500;
numSigRuns = 5;


Target_ = evalin('caller','Target_');
TrialStart_ = evalin('caller','TrialStart_');

SDF = sSDF(Spike,Target_(:,1),[-200 800],0);

meanBase = mean(SDF(:,1:200),2);
BaseSD = std(meanBase);

for trl = 1:size(SDF,1)
    if sum(SDF(trl,:)) ~= 0
        [~,ix] = max(SDF(trl,peakWindow));
        
        %find areas of window that are below threshold
        underThresh = find(SDF(trl,peakWindow) < (mean(SDF(trl,1:200))+BaseSD));
        
        %limit to areas that are earlier than the peak firing rate
        runs_before_peak = underThresh(find(underThresh < ix));
        
        %take diff to find regions of consecutive time points meeting criterion
        diff_runs = diff(runs_before_peak);
        
        %find areas below threshold for specified length
        runStarts = runs_before_peak(strfind(diff_runs,ones(1,numSigRuns)));
        
        %find last one and add length we looked for because strfind returns the beginning of the vector.
        
        if ~isempty(runStarts)
            BurstStartTimes(trl,1) = runStarts(find(runStarts,1,'last')) + numSigRuns;
        else
            BurstStartTimes(trl,1) = NaN;
            continue
        end
    else
        BurstStartTimes(trl,1) = NaN;
    end
    
end

if plotFlag
    figure
    plot(-200:800,nanmean(SDF))
    vline(nanmean(BurstStartTimes),'r')
    xlim([-200 800])
end