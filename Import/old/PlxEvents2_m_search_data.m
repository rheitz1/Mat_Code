function [TrialStart_, TimeStamps_Strobe_Events] = PlxEvents2_m_search_data (file_path,filename, TrialStart_TimeStamps , outfile,target_on_Evt2 );
% [TrialStart_, TimeStamps_Strobe_Events] = PlxEvents2_m (file_path,filename, TrialStart_TimeStamps , outfile );
% TRANSLATES THE EVENTS OCCURING DURING A COUNTERMANDING .PLX FILE TO AN _M FILE 
% INPUT: 
%   FILE_PATH: FOLDER YOU WOULD LIKE TO COMENCE SEARCHING FOR FILES TO PROCESS AND SAVE 
%                       THE RESULTS TO. MUST BE A STRING  I.E., 'C:\DATA\BASIC\'
%   FILENAME: PLX FILENAME. MUST BE A STRING
%   TRIALSTART_TIMESTAMPS: ARRAY OF TRIALSTART EVENTS TIMES STAMPS IN SECONDS
%    OUTFILE: THE OUTPUT FILE NAME OF THE RESULTING FILE
%
%   OUTPUT:  SAVES VARIABLES BELOW TO [FILE_PATH, FILENAME] 
%           Abort_ , Correct_ , Decide_ , EmStart_ , Eot_ , ExtraJuice_ , FixSpotOn_ ,FixSpotOff_ , FixWindow_ , Fixate_ 
%           Infos_ , Target_ , Reward_ , Saccade_ , StopSignal_ , TargetWindow_ , TrialStart_ ,TrialType_ , Unit_ , Wrong_ , Zap_ 
%
%  IN THE EVENT OF KNOWN TRANSLATION ERRORS THE VARIABLE, ERRORLOG, IS ALSO SAVED TO OUTFILE.
%   
%  CREATED BY: erik.emeric@vanderbilt.edu & 
%                       pierre.pouget@vanderbilt.edu
%                           6-24-2005

disp(['Retrieving Events from....', [file_path,filename]])
q='''';c=',';qcq=[q c q];
ERRORLOG={};
%ZAPFLAG = 1 IF MICROSTIM AND ZAP_ IS SAVED TO M FILE
ZAPFLAG = 0;


%GET STROBED EVENTS FROM PLX FILE
% CALL TO FUNCTION ... plx_event_ts
[TotalStrobe_Events, TimeStamps_Strobe_Events, StrobeValues] = plx_event_ts( [file_path,filename] , 257);

% get global file info
% CALL TO FUNCTION ... plx_information
[OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreThresh, SpikePeakV,... 
    SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information([file_path,filename]);

Header_ ='                                                                                                          ';
Header_(39:57) = DateTime;


N_Trials =length(TrialStart_TimeStamps);
TrialStart_(1:N_Trials,1:2)=NaN;

% for i=1:N_Trials
% 
%     if i >= 1 & i < N_Trials
%         TrialEvents = find(TimeStamps_Strobe_Events < TrialStart_TimeStamps (i+1) & TimeStamps_Strobe_Events >=TrialStart_TimeStamps (i)) ;
%     elseif i == N_Trials
%         TrialEvents = find(TimeStamps_Strobe_Events<= TimeStamps_Strobe_Events (end) & TimeStamps_Strobe_Events >=TrialStart_TimeStamps (i)) ;
%     end
% 
%     TrialStrobeValues ( i, 1:length(TrialEvents) ) = StrobeValues(TrialEvents);
%     TrialStrobeTimeStamps (i, 1:length(TrialEvents)) = TimeStamps_Strobe_Events (TrialEvents) ;
% 
%     TrialStart_(i,1) = ceil(target_on_Evt2(i)*1000)-500;
% 
% end % for i=1:N_Trials
for i=1:N_Trials
    if i < N_Trials
        TrialEvents=find(TimeStamps_Strobe_Events < TrialStart_TimeStamps(i+1) & TimeStamps_Strobe_Events >= TrialStart_TimeStamps(i));
    elseif i == N_Trials
        next_t = [];
        %the below will find the time stamp of the beginning of the next
        %trial.  Will not include data from current trial because 
        next_t = min(find(StrobeValues == 1666 & TimeStamps_Strobe_Events > TrialStart_TimeStamps(i)));
        next_task = [];
        next_task = TimeStamps_Strobe_Events(next_t);
        if ~isempty(next_task)
            TrialEvents = find(TimeStamps_Strobe_Events <= next_task & TimeStamps_Strobe_Events >= TrialStart_TimeStamps(i));
        else
            TrialEvents = find(TimeStamps_Strobe_Events <= TimeStamps_Strobe_Events(end) & TimeStamps_Strobe_Events >= TrialStart_TimeStamps(i));
        end
    end
    TrialStrobeValues(i,1:length(TrialEvents)) = StrobeValues(TrialEvents);
    TrialStrobeTimeStamps(i,1:length(TrialEvents)) = TimeStamps_Strobe_Events(TrialEvents);
    TrialStart_(i,1) = ceil(target_on_Evt2(i)*1000)-500;
end

% INITIALIZE THE VARIABLES TO BE STORED IN THE  _M FILE
%Abort_(1:N_Trials,1:2) =  NaN;
Correct_(1:N_Trials,1:2)=NaN;
Decide_(1:N_Trials,1:2)=NaN;
EmStart_(1:N_Trials,1:2) = [   zeros(size(TrialStart_,1),1)  ,  repmat( 4 , size(TrialStart_,1) , 1)   ]; % 2 columns ( 0 , 1/samplerate*1000) in the event that the investigators change the sample rate
Eot_(1:N_Trials,1:2)=NaN; % StrobeEvent = 1667
ExtraJuice_(1:N_Trials,1:2) = NaN; % StrobeEvent = 2777
Fixate_(1:N_Trials,1:2)=NaN;
FixSpotOff_(1:N_Trials,1:2)=NaN;
FixSpotOn_(1:N_Trials,1:2)=NaN;
FixWindow_(1:N_Trials,1:6)=NaN;
Infos_= zeros (N_Trials,20);
Reward_(1:N_Trials,1:2)=NaN;
Saccade_(1:N_Trials,1:2)=NaN;
Stimulus_(1,5) = NaN ;
StopSignal_(1:N_Trials,1:2)=NaN;
Target_(1:N_Trials,1:2)=NaN;
TargetWindow_(1:N_Trials,1:6)=NaN;
Errors_(1:N_Trials,1:6) = NaN;


%TO DO... FIGURE OUT WHAT TRIALTYPE DOES
TrialType_(1:N_Trials,1:4) = NaN;
% tasklevel = TrialType_(1,3);  % 0=fixation, 1=detection, 2=search
% for countermanding, detection
TrialType_(:,3)=1;
% which timebin the trial start occured in the zeroeth or the 4th (250hz sample rate)
% since the plexon system is sampling at 1KHz we arbitrarily set this to 0 (always in the zeroeth
% timebin) EEE
TrialType_(:,1)=0;
% 2nd col all 5s in old countermanding files. not sure why... EEE 7/1/05
TrialType_(:,2)=5;
% 4th col : looks like the Nth trial of the current block... i have not seen it used in any of the
% subsequent analyses...EEE 7/1/05

Unit_=[   zeros(size(TrialStart_,1),1)  ,  repmat(1 , size(TrialStart_,1) , 1)   ];

%TO DO... FIGURE OUT WHAT Wrong_ : i think it is during search when gaze shifts to the distractor window. never happens
%in Cmanding
Wrong_(1:N_Trials,1:2)=NaN;
Zap_(1:N_Trials,1:4) = NaN;

for curTrl = 1:N_Trials
    N_Events = length(TrialStrobeValues(curTrl,:));
    for curEvt = 1:N_Events
        %Abort_ ==2620
%         if (TrialStrobeValues(curTrl,curEvt)==2620)
%             Abort_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
%             % second column in Abort_: flag, weather a trial must be repeated, 0 = not valid (repeat), 1 = valid (proceed
%             % not an issue for Tempo protocol, all ones...
%             Abort_(curTrl,2)= 1;
%             % second column of Eot_ is 1 if an incorrect trial
%             Eot_(curTrl,2)=1;
%         end

if (TrialStrobeValues(curTrl,curEvt) == 2621)
    Errors_(curTrl,1) = 1;
elseif TrialStrobeValues(curTrl,curEvt) == 2622
    Errors_(curTrl,2) = 1;
elseif TrialStrobeValues(curTrl,curEvt) == 2623
    Errors_(curTrl,3) = 1;
elseif TrialStrobeValues(curTrl,curEvt) == 2624
    Errors_(curTrl,4) = 1;
elseif TrialStrobeValues(curTrl,curEvt) == 2625
    Errors_(curTrl,5) = 1;
elseif TrialStrobeValues(curTrl,curEvt) == 2626
    Errors_(curTrl,6) = 1;
end

        % Correct_ = 3034
        if (TrialStrobeValues(curTrl,curEvt) ==3034)
            Correct_(curTrl,1)=ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
            Correct_(curTrl,2) = TrialStrobeValues(curTrl , curEvt + 1);
            % second column of Eot_ is 0 if a correct trial
            Eot_(curTrl,2) = 0;
        end

        % Fixate Estimate based on Target onset Used only for cutting the
        % Trial start count not used for the timing.. and creatCorrect_ =
        % 3020
        if (TrialStrobeValues(curTrl,curEvt) ==3034)
                    
        Fixate_(curTrl,1) = TrialStrobeValues(curTrl , curEvt + 1);
        
           
        end
     
        
        % Saccade_Latency = 3035
        if ( TrialStrobeValues(curTrl,curEvt)  == 3035 )

           % Decide_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
             Decide_(curTrl,1)=TrialStrobeValues(curTrl , curEvt + 1);
        end

        % Saccade_Latency = 3012 % memory_search distinction
        if ( TrialStrobeValues(curTrl,curEvt)  == 3012 )

           % Decide_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
             Target_(curTrl,15)=TrialStrobeValues(curTrl , curEvt + 1);
        end
        
        %%%%%%RPH: Hold time with jitter
        
%         if (TrialStrobeValues(curTrl,curEvt) == 3027)
%             HoldTime_(curTrl,1) = TrialStrobeValues(curTrl,curEvt + 1);
%         end
        
        %%%%% TARGET_
        if (TrialStrobeValues(curTrl,curEvt) ==3013)
            Target_(curTrl,1) = ceil(target_on_Evt2 (curTrl)*1000)-TrialStart_(curTrl,1);
            Target_(curTrl,2) = TrialStrobeValues(curTrl , curEvt + 1);
        end
        %%%%% TARGET COLOR
        if (TrialStrobeValues(curTrl,curEvt) ==3008)
            
            Target_(curTrl,3) = TrialStrobeValues(curTrl , curEvt + 1);
        end
        %%%%% TARGET COLOR
        if (TrialStrobeValues(curTrl,curEvt) ==3009)
            
            Target_(curTrl,4) = TrialStrobeValues(curTrl , curEvt + 1);
        end
        %%%%% SET SIZE
        if (TrialStrobeValues(curTrl,curEvt) ==3005)
            if(TrialStrobeValues(curTrl,curEvt+1) ==0)
            Target_(curTrl,5) = 2; %set size of 2
            end;
           if(TrialStrobeValues(curTrl,curEvt+1) ==1)
            Target_(curTrl,5) = 4; %set size of 4
           end;
           if(TrialStrobeValues(curTrl,curEvt+1) ==2)
            Target_(curTrl,5) = 8; %set size of 4
           end;
           if(TrialStrobeValues(curTrl,curEvt+1) ==3)
            Target_(curTrl,5) = 3; %set size is random
           end;
        end
        if (TrialStrobeValues(curTrl,curEvt) ==3004)
            Target_(curTrl,6) = TrialStrobeValues(curTrl , curEvt + 1);
        end

%%%%%%%%%%%%%%%%%%%%% Easy hard  Target type        
          if (TrialStrobeValues(curTrl,curEvt) ==3007) & (TrialStrobeValues(curTrl,curEvt+2) ==3008)
           
              Target_(curTrl,7) = TrialStrobeValues(curTrl , curEvt - 1);
              Target_(curTrl,8) = TrialStrobeValues(curTrl , curEvt + 1);
           
                 
          end
          if (TrialStrobeValues(curTrl,curEvt) ==3003) 
           
              Target_(curTrl,9) = TrialStrobeValues(curTrl , curEvt + 1);
               
                 
          end
                    %Hold Time (use to determine search or memory guided
          if (TrialStrobeValues(curTrl,curEvt) == 3021);			   
            Target_(curTrl,16) = TrialStrobeValues(curTrl,curEvt+1);
          end
          
%
        
%
%     if isempty(find (TrialStrobeValues (curTrl , : ) == 2654)) & ~isempty(find(TrialStrobeValues (curTrl , : ) == 2653))
%         if find(TrialStrobeValues (curTrl , : ) == 2653) < find(TrialStrobeValues (curTrl , : ) == 1667)
%            StopSignal_ (curTrl,1) = ceil(  TrialStrobeTimeStamps (curTrl, find (TrialStrobeValues (curTrl , : ) == 2653) ) *1000 ) - TrialStart_ (curTrl,1);
%         end
%             ERRORLOG {2} = 'NO PHOTODIODE EVENT FOR STOPSIGNAL_';
%     end
  
    end
end %for curTrl = 1:N_Trials

% % Decide_ 2nd col contains the target window the eyes enter into.
% trlsLook = find (~isnan(Decide_(:,1)));
% Decide_( trlsLook,2 ) = Target_( trlsLook,2 );
% 
% %stim file = gEcenAng
% if exist('Stim_')
%     [m]=find(Stim_(:,1)==0);
%     if ~isempty(m)
%         Stim_(m,:)=[];
%     end
%     %MAKE SURE THE VALUES HAVE NOT BEEN CHANGED OVER THE COURSE OF THE RECORDING
%     if std(Stim_(:,1))==0 & std(Stim_(:,2))==0 & std(Stim_(:,3))==0 & std(Stim_(:,4))==0
%        % NEW VARIABLE FOR _M FILES: STIMULUS
%         Stimulus_ = [ max(Target_(:,2))+1, Stim_(1,:) ];
%         % CONVERSION FROM TEMPO SCREEN UNITS TO VISUAL DEGREES
%         Stimulus_(1,2) = ceil (0.0425 * (Stimulus_(1,2)) + 0.6161);
%         % CREATE STIMFILE FOR HEADER IF 2 TARGETS
%         if Stimulus_(:,1)==2   
%             eccen = num2str (Stimulus_(1,2));
%             ang = num2str (Stimulus_(1,3));
%             stimfile = strcat(['g',eccen,ang,'.stm'])
%             Header_(27:27+length(stimfile)-1)= stimfile;         
%         end
%     else
%         disp('TARGET POSITIONS HAVE BEEN CHANGED DURING THE COURSE OF THE RECORDING')
%     end
% end
% 
% if ZAPFLAG
%     VARS2SAVE = {'Abort_','Correct_','Decide_','EmStart_','Eot_','ExtraJuice_','FixSpotOn_',...
%         'FixSpotOff_','FixWindow_','Fixate_', 'Infos_','Target_','Reward_','Saccade_','Stimulus_' , 'StopSignal_','TargetWindow_','TrialStart_',...
%         'TrialType_','Unit_','Wrong_','Zap_'};
% else
    VARS2SAVE = {'Errors_','Correct_','Eot_','Target_','TrialStart_', 'Fixate_','Decide_'};
% end
% 
save ([file_path, outfile] , 'Header_','-mat')


if isempty(ERRORLOG)            
    save ([file_path, outfile] , 'ERRORLOG','-append')
end

for curVar = 1: size(VARS2SAVE,2)
    disp(['save (',q,[file_path, outfile],qcq, VARS2SAVE{curVar},qcq,'-append',q,')'])
    eval(['save (',q,[file_path, outfile],qcq, VARS2SAVE{curVar},qcq,'-append',q,')'])
end