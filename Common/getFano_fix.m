% Returns and displays Spike statistics
% ALIGNED TO TEMPO CALCULATION OF HOW LONG FIXATION NEEDED TO BE ACHIEVED; NOT ACTUAL FIXATION
% ACQUISITION TIME, BUT SHOULD BE NEARLY IDENTICAL
% binwidth = window size (in ms) to compute Fano factor on
%
% RPH

function [Fano,real_time,CV2] = getFano_fix(Spike,binwidth,stepsz,window,trls,plotFlag)

parallelCheck

%variables we'll need
Target_ = evalin('caller','Target_');
FixTime_Jit_ = evalin('caller','FixTime_Jit_');

if nargin < 6; plotFlag = 0; end
if nargin < 5; trls = 1:size(Target_,1); end
if nargin < 4; window = [-50 4000]; end
if nargin < 3; stepsz = 10; end
if nargin < 2; binwidth = 50; end

if isempty(trls)
    disp('Empty trials...returning NaN')
    Fano = NaN;
    real_time = NaN;
    CV2 = NaN;
    return
end

%Keep track of old Spike variable for plotting
Spike_orig = Spike;

Spike(find(Spike == 0)) = NaN;
%Spike = Spike - Target_(1,1);
Spike = Spike - repmat(  (Target_(1,1) - FixTime_Jit_)  ,1,size(Spike,2));

%compute Fano Factor (computed on spike counts)
if binwidth < 5; error('Fano factor will not be stable with binwidth < 5'); end
if mod(binwidth,2); error('Bin Width must be divisible by 2'); end

%bin_index = 1;

times = window(1) + (binwidth/2):stepsz:window(2) - (binwidth/2);
if useParallel
    parfor t = 1:length(times)
        arrivals = (sum(Spike(trls,:) >= times(t)-binwidth/2+1 & Spike(trls,:) < times(t) + binwidth/2,2));
        varA(t) = nanvar(arrivals);
        meanA(t) = nanmean(arrivals);
        Fano(t) = nanvar(arrivals) / nanmean(arrivals);
        
        %now compute CV and CV2 for ISIs in window
        curSpike = Spike(trls,:);
        curSpike(find(curSpike < times(t)-binwidth/2 + 1)) = NaN;
        curSpike(find(curSpike > times(t)+binwidth/2)) = NaN;
        diff_curSpike = diff(curSpike,[],2); % I don't think you're actually losing any observations by NaN computations...
        ISIs = diff_curSpike(find(~isnan(diff_curSpike)));
        %     hist(ISIs)
        %     pause
        %     cla
        CV(t) = std(ISIs) / mean(ISIs);
        CV2(t) = CV(t)^2;
        
        
        real_time(t) = times(t);
        %bin_index = bin_index + 1;
    end
else
    for t = 1:length(times)
        arrivals = (sum(Spike(trls,:) >= times(t)-binwidth/2+1 & Spike(trls,:) < times(t) + binwidth/2,2));
        Fano(t) = nanvar(arrivals) / nanmean(arrivals);
        %now compute CV and CV2 for ISIs in window
        curSpike = Spike(trls,:);
        curSpike(find(curSpike < times(t)-binwidth/2 + 1)) = NaN;
        curSpike(find(curSpike > times(t)+binwidth/2)) = NaN;
        diff_curSpike = diff(curSpike,[],2); % I don't think you're actually losing any observations by NaN computations...
        ISIs = diff_curSpike(find(~isnan(diff_curSpike)));
        %     hist(ISIs)
        %     pause
        %     cla
        CV(t) = std(ISIs) / mean(ISIs);
        CV2(t) = CV(t)^2;
        
        
        real_time(t) = times(t);
        %bin_index = bin_index + 1;
    end
end


if plotFlag == 1
    %     TrialStart_ = evalin('caller','TrialStart_');
    %     SDF = spikedensityfunct(Spike_orig,Target_(:,1),[window(1) window(2)],trls,TrialStart_);
    %     figure
    %
    %     subplot(2,1,1)
    %     plot(window(1):window(2),SDF)
    %     xlim([window(1) window(2)])
    %     title('SDF')
    
    subplot(2,1,2)
    plot(real_time,Fano,'r')
    xlim([window(1) window(2)])
    title('Fano Factor computed on Spike Counts')
    
    
end
