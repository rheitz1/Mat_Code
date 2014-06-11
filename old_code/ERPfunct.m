function ERP_ = ERPfunct(AD_CH, Align_Time, Plot_Time, triallist, TrialStart_, SamplePeriod);
deltrls=[];

% to do 
%   make sure the trials remove are output from function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Initialize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
Pre_Time = Plot_Time(1); Post_Time = Plot_Time(2);
BinCenters = [round(Pre_Time):round(Post_Time)]';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2. Create raw histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c=0;




% 2.1. Add up spikes
for pl=1:length(triallist)
    trl = triallist(pl);

    %%%%% converting Align time and pre and post
    %Align_Time % current align time
    Align_time_250hz=ceil(Align_Time/SamplePeriod);
    % current Pretime
    Pre_Time_250hz=ceil(Pre_Time/SamplePeriod);
    % current Posttime
    Post_Time_250hz=ceil(Post_Time/SamplePeriod);


    values = nonzeros(AD_CH(trl,:));
    if trl >= 2
    preValues = nonzeros(AD_CH(trl-1,:));
    end
    % Add Spikes of the next trial, in case one wants to see activity BETWEEN trials
    % 01-17-02 Veit Stuphorn
    if (trl < size(TrialStart_,1))
        Addvalues = TrialStart_(trl+1,1)-TrialStart_(trl,1);
        addvalues = nonzeros(AD_CH(trl+1,:));
%         addvalues = addvalues + Addvalues;
        values = [values;addvalues];
    end
    if(isempty(nonzeros(values)))
        EmptyTrials = EmptyTrials+1;
    else
        %        plot (values,'-.b')
        %        hold on;
        % if there is no align event (an unrewarded trial) continue onto next trial
        if ~isnan(Align_time_250hz(trl,1)) & (Align_time_250hz(trl,1)+Post_Time_250hz) <= length(values) 
           
        
            
            
            if Align_time_250hz(trl,1)+Pre_Time_250hz > 0 % if values needed from previous trial
               
                values = values(Align_time_250hz(trl,1)+Pre_Time_250hz:Align_time_250hz(trl,1)+Post_Time_250hz);
            elseif Align_time_250hz(trl,1)+Pre_Time_250hz <= 0 & trl ~=1
               
                
                preIndex = Align_time_250hz(trl,1)+Pre_Time_250hz;
                values = values(1:Align_time_250hz(trl,1)+Post_Time_250hz);
                preval = preValues (end+preIndex:end);
                values = [preval;values];
 
            elseif Align_time_250hz(trl,1)+Pre_Time_250hz <= 0 & trl ==1
                preIndex = Align_time_250hz(trl,1)+Pre_Time_250hz;
                values = values(1:Align_time_250hz(trl,1)+Post_Time_250hz);
                preval = repmat(values(1),abs(preIndex)+1,1);
                values = [preval;values];
            end

        else
   
            c=c+1;
            values = zeros( length(Pre_Time_250hz:Post_Time_250hz),1);
            deltrls(c) = pl;
        end
        %plot ((Align_time_250hz(trl,1)+Pre_Time_250hz:Align_time_250hz(trl,1)+Post_Time_250hz),values,'r')
         ListTimes = [[ListTimes],[values]];
        values = [];

    end

end

% Remove trials with no Event
if ~isempty(deltrls)
%     for i = 1 :length(deltrls)
        ListTimes(:,deltrls)=[];
%     end
disp( [num2str(length(deltrls)), ' trials with no align event'] )
end
ERP_=ListTimes';
%ERP_=mean(ListTimes,2);
