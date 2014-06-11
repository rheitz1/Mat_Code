function [onset, base, ActLevelAtOnset, MaxActivity, TimePeak] = mov_onset_LB(sdf, t_len, t_win, start_time_window, NeuralArea);
%
% MOV_ONSET
%   mov_onset returns onset time calculated from spearman correlation
%   sdf     : spike density function aligned with saccade onset at 1001
%   t_len   : successive examine interval
%   t_win   : spearman sample interval [-t_win:t_win]
%   onset   : onset time
%   base    : baseline activity of the motor part measured [-200:0] ms
%
% Schall Lab Method RM 030 Tempo/Mac
% Modified by pierre pouget for coverted matlab files
% Modified by L Boucher, Aug 2009

if nargin == 1,
    t_len = 19;
    t_win = 20;
end

if nargin == 3,
    start_time_window = 200;        % DEFAULT = aligned to TARGET at -200
end

if nargin == 4,
    NeuralArea = 'FEF';             % DEFAULT = FEF analysis
end


max_=max(sdf);
peak = find(max_==sdf);
peak = min(peak);
MaxActivity = sdf(peak);

TimePeak = peak-start_time_window;

if start_time_window > 250          % if the time window is greater than this, it may be SACCADE aligned and you don't want to catch the upswing
    base = mean(sdf(1:250));
    baseStd = std(sdf(1:250))*3;
    ThreeSDBase = base + baseStd;
else
    base = mean(sdf(1:start_time_window+50));
    baseStd = std(sdf(1:start_time_window+50))*3;
    ThreeSDBase = base + baseStd;
end

if ThreeSDBase < 5
    ThreeSDBase = 5;
end

% TimeGreaterThanBase = 100;       % SDF must be greater than 3x baseline for 50 ms

onset = NaN;
flag = 0;
pflag = 0;
t = 0;

if peak+t_win < length(sdf)
    start_here = peak;
else
    start_here = peak - ((peak+t_win)-length(sdf));
end

while( isnan(onset) )
    itvl = [t-t_win:t+t_win]+start_here;                        % start at peak level, define window +- t_win
    if min(itvl)>t_len
        flag = spearman(itvl, sdf(itvl), 0.05);                 % flag = 0 if nonsig; flag = 1 if sig

        % met criterion for being ...
        if flag == 0 & pflag == 1 & sdf(start_here+t) < ThreeSDBase,   % if previously sig AND not significant now AND sdf < (3 stdev above baseline)
            nflag = [];
            for i = 1:t_len,
                nflag(i) = spearman(itvl-i, sdf(itvl-i), 0.05); % getting significance for each time point in specified length of time
            end
            if sum(nflag) == 0,
                onset = t + 1;                                  % remained nonsig for specified length of time
            else
                t = t-1;
            end

        else
            t = t - 1;                                          % didn't meet criterion, move 1 step backwards
        end

        if t == -peak + t_win,
            onset = t;
        end

        pflag = flag;
    else
        onset=0;
    end

end


if NeuralArea(1) == 'F'
    ActLevelAtOnset = sdf(peak+onset);            %onset time in array
    onset = onset+peak-start_time_window;         %onset time relative to start time

else   % for SC data

    onset = onset+peak;

    t = 0;
    marchOn = 0;
    while ( marchOn == 0)
        if (onset+t)<length(sdf)
            if sdf(onset+t)> ThreeSDBase
                %                 UnderBase = sum(sdf(onset+t:onset+t+TimeGreaterThanBase-1)> ThreeSDBase);
                %                 if UnderBase==TimeGreaterThanBase
                ActLevelAtOnset = sdf(onset+t);        %onset time in array
                onset = onset+t-start_time_window;       %onset time relative to start time
                marchOn = 1;
                %                 else
                %                     t = t+1;
                %                 end
            else
                t = t+1;
            end
        else
            marchOn = 1;    % didn't find a decent value
            onset=NaN;
            ActLevelAtOnset = NaN;
        end
    end

end
return;


