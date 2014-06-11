function SDF = spikedensityfunct(Spike, Align_Time, Plot_Time, triallist, TrialStart_, TruncEvent, directionFlag)
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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.5 (added 1/31/08 RPH)
%if cell is lost during session or appears during session,
%remove trials where the cell was not isolated.  Increases firing rates.
%Criterion will be: find at least 10 trials in a row with no spikes, then
%remove all trials with no spikes until a trial is encountered where there
%is a spike.

%Edited 1/16/09 RPH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%find trials with no spikes
%if sum of row == 0, then no spike
isSpike = nansum(abs(Spike),2);

%turn into 0/1
isSpike_bin = isSpike > 0;

%invert (1 == 0; 0 == 1)
isSpike_bin = ~isSpike_bin;

trials_to_delete = findRuns(isSpike_bin,10);

if ~isempty(trials_to_delete)
    disp(['Removing ' mat2str(length(trials_to_delete)) ' (' mat2str( round((length(trials_to_delete) / size(Spike,1))*100) ) '%) trials with no spikes (10 or more consecutive)'])
end
%remove those trials from triallist
triallist = triallist(find(~ismember(triallist,trials_to_delete)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Create raw histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 2.1. Add up spikes
for pl=1:length(triallist)
    trl = triallist(pl);
    times = nonzeros(Spike(trl,:));
    
    
    %check to see if 3 consecutive trials have no spikes.  if so, do not
    %count it.  should elevate firing rates
%     if trl - 1 > 0 & trl + 1 < size(Spike,1)
%         %if isempty(nonzeros(times)) & isempty(nonzeros(Spike(trl + 1,:))) & isempty(nonzeros(Spike(trl - 1,:)))
%         if isempty(nonzeros(times))
%             continue
%         end
%     end
        
    
    % Add Spikes
    % of the next trial, in case one wants to see activity BETWEEN trials
    % 01-17-02 Veit Stuphorn
    
    
    %Remember that the times are referenced via TrialStart_, which already
    %has a 500 ms baseline built into it.  Hence, when we subtract
%     if (trl < size(TrialStart_,1))
%         AddTime = TrialStart_(trl+1,1)-TrialStart_(trl,1);
%         addtimes = nonzeros(Spike(trl+1,:));
%         addtimes = addtimes + AddTime;
%         times = sort([times', addtimes']);
%     end
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
        %of the trial is, we will pass that into trucate event, and we
        %won't have a problem because in the next line of code, we'll keep
        %only those spikes occuring on trial n.  if we do not pass anything
        %into truncate event, then the SDF will show (at the end) activity
        %between the trials
        times = nonzeros(times)-Align_Time(triallist(pl),1);
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
%Decay*8 controls how far out you want the decaying function to go:
%with decay * 8, function continues to 160 ms, where little activation is
%left; if we changed it to 6, the function would continue only until 120,
%which probably wouldn't change all that much.
Half_BW=round(Decay*8);
%Half_BW indicates the duration of the activation function. Because the
%function will have an effect forward in time on the next spike, make bin
%sizes twice the length of the activation function??
BinSize=(Half_BW*2)+1;
%Kernel will be the actual activation function, which will range from 0 ms
%to Half_BW, which is the duration of the activation function
Kernel=[0:Half_BW];
%activation function: left part is activation, right is decay
%left part increases according to exponential growth, second part takes
%changing fraction of that activation (the fraction of which decays
%according to exponential). At time 0, we multiply by 1, so there is no
%decay.  at 1 ms, we take .9512% of activation; note also that this
%activation (left side) increases over time as well, but essentially
%becomes 1 by 10 ms.
Half_Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
%Change activation values from exponential to proportions?  Afterwards,
%sum(Half_Kernel) == 1.  Not sure why we do this.
Half_Kernel=Half_Kernel./sum(Half_Kernel);
Kernel(1:Half_BW)=0;
%set activation function to second half of bin.  I think this has something
%to do with the fact that Pre_Time = Plot_Time(1) - 100.
Kernel(Half_BW+1:BinSize)=Half_Kernel;
%Is 1000 arbitrary?  changes fractions into large numbers.  First value
%with current parameters is 31.7149...DOES NOT MATTER: shape of function
%convolved with histogram
Kernel=Kernel.*1000;
Kernel=Kernel';

SDF = convn(Hist_raw,Kernel,'same');
SDF(1:100,:,:)=[];

%temp = Hist_raw;
if optional_graph7==1

figure(8)

plot(Plot_Time(1):Plot_Time(2),SDF)

end;