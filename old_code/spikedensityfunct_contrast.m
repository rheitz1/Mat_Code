function SDF = spikedensityfunct_lgn(Spike, Align_Time, Plot_Time, triallist, TrialStart_, TruncEvent, directionFlag)
% creates spike-density function from spike times
%
% In:
% (1) the spike times [Spike], (2) the event, on which the histogram
% will be aligned [Align_event], (3) the time before and after the align
% event, that should be plotted [Plot_Time], (4) the list of used trials
% [triallist], (5) beginning of each trial [TrialStart_], (6) the onset of
% the event after/before which spikes are truncated [TruncEvent],
% (7) truncate before/after; -1 = before/ 1 = after [directionFlag]
% 
% Out:
% SDF: the spike density function

% 12/20/02: So far all the Histogram routines (e.g. in Compare ...) contain
% more then the core function of histogram generation. Here I want to strip
% it completely down and generate a module that can be called in all sorts
% of other programs. VS

% 07/23/03: truncation procedure has been expanded, so that no spikes after
% or before arbitrary events can be truncated. VS

%optional graph
optional_graph7=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Initialize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%RPH: Truncate spikes after end of trial, this is why we generally pass "EOT" into
%this variable.  If nothing passed, will not truncate any spikes.
if nargin < 6 %no TruncEvent
    truncateFlag = 0; %normal case: all spikes count
else
    truncateFlag = 1; %truncated case: spikes are removed
    %from the histogram & spike raster
    if nargin < 7
        directionFlag = 1; %default truncate spikes AFTER TruncEvent
    end
end

% 1.1. initialize & set up ...

EmptyTrials=0;%Trials in which there are no spikes in the interval
ListTimes = []; times = []; Kernel=[]; poslist=[]; temp=[]; temp_hist=[]; pl=[];

% 1.2. align time event 
if(isequal(Align_Time,TrialStart_))
    Align_Time(1:length(Align_Time)) = 0;
end

% 1.3. Pre-Time & Post-Time
Pre_Time = Plot_Time(1)-100; Post_Time = Plot_Time(2);
BinCenters = [round(Pre_Time):round(Post_Time)]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Create raw histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2.1. Add up spikes
for pl=1:length(triallist)
    trl = triallist(pl);
    times = nonzeros(Spike(trl,:));
    % Add Spikes
    % of the next trial, in case one wants to see activity BETWEEN trials
    % 01-17-02 Veit Stuphorn
    %edited by RPH to support contrast analysis
    if (trl < length(triallist))
        %spikes on next trial will be offset by the amount of time between
        %the next trial start time and the previous trial start time
        %(because spike times are in reference to its own trial onset)
        
        %RPH: For contrast sensitivity analysis, am
        AddTime = TrialStart_(trl+1,1)-TrialStart_(trl,1);
        %grab spike times from next trial
        addtimes = nonzeros(Spike(trl+1,:));
        %alter spike times so that they reflect next trial times
        addtimes = addtimes + AddTime;
        times = sort([times', addtimes']);
    end
    if(isempty(nonzeros(times)))
        EmptyTrials = EmptyTrials+1; 
    else
        if(truncateFlag==1)
            % removes spikes from a trial:
            Spktimes = times;
            if TruncEvent(trl,1)>0
                if directionFlag == 1
                    ind = find(times >= TruncEvent(trl,1));
                elseif directionFlag == -1
                    ind = find(times <= TruncEvent(trl,1));
                end
                Spktimes(ind) = 0;
            end
            times = Spktimes; Spktimes = [];
        end
        %RPH: It looks like at each iteration we are merging the spike
        %times for trial n and trial n+1.  So long as we know what the end
        %of the trial is, we will pass that into truncate event, and we
        %won't have a problem because in the next line of code, we'll keep
        %only those spikes occuring on trial n.  if we do not pass anything
        %into truncate event, then the SDF will show (at the end) activity
        %between the trials
        
        %Spike times are in reference to Ev2 (target onset).  Translation
        %code altered most time stamps to be -500 (with reference to when
        %1666 came through, which is when the target appeared.  Spike times
        %also appear to be in reference to target onset time.  Hence,
        %subtracting 500 ms (Align_Time) from the spike times ensures that
        %everything is aligned properly.
        times = nonzeros(times)-Align_Time(triallist(pl),1);
        %this affects what segment is plotted
        times = times(times >= Pre_Time & times <= Post_Time);
        ListTimes = [[ListTimes];[times]];
        times = [];
    end
end

% 2.2. divide by vector of number of trials for each milisecond bin
if(~isempty(ListTimes))
    
    temp_hist=hist(ListTimes(:),BinCenters);
    
    if(truncateFlag==1)
        
        % from Adi's code:
        % since trials of different length are combined, one has to divide the
        % consecutive bins by different # of trials:
        % code that creates a trialvector which indexes the number of trials
        % May-15-2000 Veit Stuphorn
        % changed to encompass spikes truncated BEFORE truncation event
        
        dummy=[];trialvector=[];subtrials=[];trialvector=[];ind=[];
        dummy = TruncEvent(triallist,1)-Align_Time(triallist,1);
        trialvector(1:length(BinCenters)) = length(triallist);
        subtrials = cumsum(hist(dummy,BinCenters));
        if directionFlag == -1
            subtrials = -(subtrials-max(subtrials)-1);
        end
        trialvector = trialvector-subtrials;
        trialvector(find(trialvector==0)) = 1;
        
        temp_hist = temp_hist./trialvector;
    else
        %RPH: this turns counts into relative frequencies (proportion of
        %trials falling within a bin).
        temp_hist = temp_hist./(length(triallist));
    end
    
    Hist_raw = temp_hist(:);
    poslist=[];temp=[];temp_hist=[];pl=[];EmptyTrials=0;
    
else
    
    Hist_raw = zeros(length(BinCenters),1);
    poslist=[];temp=[];temp_hist=[];pl=[];
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Convolute with exponential Kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Growth=1; Decay=20;
Half_BW=round(Decay*8);
BinSize=(Half_BW*2)+1;
Kernel=[0:Half_BW];
Half_Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
Half_Kernel=Half_Kernel./sum(Half_Kernel);
Kernel(1:Half_BW)=0;
Kernel(Half_BW+1:BinSize)=Half_Kernel;
Kernel=Kernel.*1000;
Kernel=Kernel';

SDF = convn(Hist_raw,Kernel,'same');
SDF(1:100,:,:)=[];

temp = Hist_raw;
if optional_graph7==1

figure(8)

plot(Plot_Time(1):Plot_Time(2),SDF)

end;