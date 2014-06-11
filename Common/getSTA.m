function [STA] = getSTA(Spike,AD,win,winSize,decimation,plotFlag)

% Calculates spike triggered average on all spikes in variable 'Spikes'.
% Does not select for any trial type
%
% 'win' specifies what times you want to use (THIS IS NOT CORRECTED FOR BASELINE INTERVAL!)
% 'winSize' specifies length of STA (e.g., for [-100 100], just pass 100)
% Default = 100
%
% Decimation included because typically way too many spikes.  Can use every
% nth trial. Default = 1 (every trial)
%
% RPH

if nargin < 6; plotFlag = 0; end

if nargin < 5; decimation = 1; end

if nargin < 4; winSize = 100; end

if nargin < 3; win = [101 2000];
end

STAcount = 1;

Target_ = evalin('caller','Target_');
%Spike = Spike - Target_(1,1);

%initialize variable
STA(1:decimation:size(AD,1),1:length(-winSize:winSize)) = NaN;

for n = 1:decimation:size(AD,1)
    valid_spikes = Spike(n,find(nonzeros(Spike(n,:)) > win(1) & nonzeros(Spike(n,:)) < win(2)));
    for curr_spike = 1:length(valid_spikes)
        STA(STAcount,1:length(-winSize:winSize)) = AD(n,valid_spikes(curr_spike)-winSize:valid_spikes(curr_spike)+winSize);
        STAcount = STAcount + 1;
    end
    clear valid_spikes
end


%STA = baseline_correct(STA,[1 10]);

if plotFlag
    figure
    plot(-winSize:winSize,nanmean(STA))
    xlim([-winSize winSize])
    axis ij
end