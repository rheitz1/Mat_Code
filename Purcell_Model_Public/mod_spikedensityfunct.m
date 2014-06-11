function SDF = mod_spikedensityfunct(Spike, Align_Time, Plot_Time, triallist, TrialStart_, maxSDFactivity_recip,RTvector,drop_post_saccade_activity,Align_on_saccade,normalize,TruncEvent, directionFlag)
% creates spike-density function from spike times
%
% THIS WILL ONLY WORK WITH SPIKE WINDOW OF -500 BEFORE SACCADE
% DONT FORGET!!!! **fix this at some point**
%
% note: AOS only works if drop post saccade activity is on

window_end=0;
time_before_saccade=0-Plot_Time(1);

%Spike = input all
%align = input all
%trialstart = input only selected trials
%max activity = input only selected trials
%rt vector = input all


% In:
% (1) the spike times [Spike], (2) the event, on which the histogram
% will be aligned [Align_event], (3) the time before and after the align
% event, that should be plotted [Plot_Time], (4) the list of used trials
% [triallist], (5) beginning of each trial [TrialStart_], (6) the reciprocal
% of the maximum activity for the cell in each trial - normally will be the
% same for each trial unless different cells are being used, (7) the onset of
% the event after/before which spikes are truncated [TruncEvent],
% (8) truncate before/after; -1 = before/ 1 = after [directionFlag]
%
% Out:
% SDF: the spike density function

%optional graph
optional_graph7=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Initialize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 11 %no TruncEvent
   truncateFlag = 0; %normal case: all spikes count
else
   truncateFlag = 1; %truncated case: spikes are removed
   %from the histogram & spike raster
   if nargin < 13
       directionFlag = 1; %default truncate spikes AFTER TruncEvent
   end
end


% 1.1. initialize & set up ...

EmptyTrials=0;%Trials in which there are no spikes in the interval
ListTimes = []; times = []; Kernel=[]; poslist=[]; temp=[]; pl=[];

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
hist_times_matrix = zeros(length(triallist),length(BinCenters));

% 2.1. Add up spikes
for pl=1:length(triallist)
   trl = triallist(pl);
   times = nonzeros(Spike(trl,:));

   % Add Spikes of the next trial, in case one wants to see activity BETWEEN trials
   % 01-17-02 Veit Stuphorn
%    if (trl < size(TrialStart_,1))
%        AddTime = TrialStart_(trl+1,1)-TrialStart_(trl,1);
%        addtimes = nonzeros(Spike(trl+1,:));
%        addtimes = addtimes + AddTime;
%        times = sort([times', addtimes']);
%    end
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
       times = nonzeros(times)-Align_Time(triallist(pl),1);
       times = times(times >= Pre_Time & times <= Post_Time);
       %ListTimes = [[ListTimes];[times]]
       hist_times = hist(times,BinCenters);
       if normalize==1
            hist_times_matrix(pl,:) = maxSDFactivity_recip(pl)*hist_times;
       elseif normalize==0
            hist_times_matrix(pl,:) = hist_times;
       end
        if drop_post_saccade_activity==1
               if Align_on_saccade==0
                    hist_times_matrix(pl,100+time_before_saccade+window_end+round(RTvector(trl)):end)=0;
               elseif Align_on_saccade==1
                    hist_times_matrix(pl,100+time_before_saccade+window_end:end)=0;

               end
        end
   end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3. Convolute with exponential Kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %get Kernel
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
        
if drop_post_saccade_activity==1
        convn_matrix=zeros(size(hist_times_matrix))';
        for i = 1:length(hist_times_matrix(:,1))
            trial_hist = hist_times_matrix(i,:)';
            convn_matrix(:,i) = convn(trial_hist,Kernel,'same');
        end
        convn_matrix=convn_matrix';
        convn_matrix(:,1:100)=[];
        %apply nans
        if drop_post_saccade_activity==1
            for i = 1:length(convn_matrix(:,1))
                trl = triallist(i);
                if Align_on_saccade==0
                     convn_matrix(i,time_before_saccade+window_end+round(RTvector(trl)):end)=nan;
                elseif Align_on_saccade==1
                     convn_matrix(i,time_before_saccade+window_end:end)=nan;
                end
            end    
        end        

    %avg
    trialcount=zeros(1,length(convn_matrix(1,:)));
    for pl = 1:length(convn_matrix(1,:))
       trialcount(pl)=sum(~isnan(convn_matrix(:,pl)));
    end
    temp_hist = nansum(convn_matrix,1);
    %temp_hist = temp_hist/length(triallist);
    temp_hist = temp_hist./trialcount;
    SDF=temp_hist;

elseif drop_post_saccade_activity==0
    if ~isempty(hist_times_matrix)
        trialcount=zeros(1,length(hist_times_matrix(1,:)));
        for pl = 1:length(hist_times_matrix(1,:))
           trialcount(pl)=sum(~isnan(hist_times_matrix(:,pl)));
        end
        temp_hist = nansum(hist_times_matrix,1);
        %temp_hist = temp_hist/length(triallist);
        temp_hist = temp_hist./trialcount;
        Hist_raw=temp_hist(:);
        SDF=convn(Hist_raw,Kernel,'same');
        SDF(1:100,:,:)=[];
    else
       SDF=nan(length(Plot_Time(1):Plot_Time(2)),1);
    end
end
    
    
   
    
    
    
    
    
    
    
    
end