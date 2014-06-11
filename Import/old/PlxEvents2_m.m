function [TrialStart_, TimeStamps_Strobe_Events] = PlxEvents2_m_search_data (file_path,filename, TrialStart_TimeStamps , outfile );
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

if ~isempty(find(StrobeValues ==1501))
    Header_(1:3) = 'new'; Header_(5:10) = 'gostop'; Header_(15:24) = 'stdexp.eve';
end

N_Trials =length(TrialStart_TimeStamps);
TrialStart_(1:N_Trials,1:2)=NaN;

for i=1:N_Trials

    if i >= 1 & i < N_Trials
        TrialEvents = find(TimeStamps_Strobe_Events < TrialStart_TimeStamps (i+1) & TimeStamps_Strobe_Events >=TrialStart_TimeStamps (i)) ;
    elseif i == N_Trials
        TrialEvents = find(TimeStamps_Strobe_Events<= TimeStamps_Strobe_Events (end) & TimeStamps_Strobe_Events >=TrialStart_TimeStamps (i)) ;
    end

    TrialStrobeValues ( i, 1:length(TrialEvents) ) = StrobeValues(TrialEvents);
    TrialStrobeTimeStamps (i, 1:length(TrialEvents)) = TimeStamps_Strobe_Events (TrialEvents) ;

    TrialStart_(i,1) = ceil(TrialStart_TimeStamps(i)*1000);

end % for i=1:N_Trials


% INITIALIZE THE VARIABLES TO BE STORED IN THE  _M FILE
Abort_(1:N_Trials,1:2) =  NaN;
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
        if (TrialStrobeValues(curTrl,curEvt)==2620)
            Abort_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
            % second column in Abort_: flag, weather a trial must be repeated, 0 = not valid (repeat), 1 = valid (proceed
            % not an issue for Tempo protocol, all ones...
            Abort_(curTrl,2)= 1;
            % second column of Eot_ is 1 if an incorrect trial
            Eot_(curTrl,2)=1;
        end

        % Correct_ = 2600
        if (TrialStrobeValues(curTrl,curEvt) ==2600)
            Correct_(curTrl,1)=ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
            % second column of Eot_ is 0 if a correct trial
            Eot_(curTrl,2) = 0;
        end

        % Decide_ = 2811
        if ( TrialStrobeValues(curTrl,curEvt)  == 2811 )

            Decide_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1) ;

        end

        %%%%%Eot_
        if (TrialStrobeValues(curTrl,curEvt) ==1667)
            Eot_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1) ;
            % Eot_(j,2)= 0 if corect,  1 if incorrect, or 2 if last trial
            if curTrl == N_Trials
                Eot_(curTrl,2) = 2;% this may need to be fixed
            end
        end

        %ExtraJuice_ = 2777
        if (TrialStrobeValues(curTrl,curEvt) == 2777)
            ExtraJuice_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1) ;
            ExtraJuice_(curTrl,2) = TrialStrobeValues( curTrl , curEvt + 1)-1;;
        end;

        % Fixate == == 2660
        if (TrialStrobeValues(curTrl,curEvt)  == 2660)
            Fixate_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1) ;
            Fixate_(curTrl,2) = 0;
        end;

        % Fixation Spot on time ==2301
        if (TrialStrobeValues(curTrl,curEvt) ==2301)
            FixSpotOn_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1) ;
            FixSpotOn_(curTrl,2) = 1;
        end;

        % Fixation Spot Offset = 2300
        if (TrialStrobeValues(curTrl,curEvt) ==2300)
            FixSpotOff_ (curTrl,1) =ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
            FixSpotOff_ (curTrl,2) = 0;
        end;

        %FixWindow == 2700
        if (TrialStrobeValues(curTrl,curEvt) ==2770)
            % subract 3000 from third strobe after 2770
            % 1st column of FixWindow is the time which the Event was sent during the trial
            %  Current trial is nan if monk never fixates
            if ~ isnan (Fixate_(curTrl,1))
                FixWindow_(curTrl,1)=FixSpotOn_(curTrl,1) ;
                FixWindow_(curTrl,2)=0;
                % FIXATION WINDOW COORDINATES
                % VALUE: 1st,3rd,5th, and 7th strobes after 2770 are the absolute values of the coordinates + 3000
                % SIGN: 2nd,4th,6th, and 8th strobes after 2770 are the sign of the coordinate +1
                % conversion from tempo screen units to real voltage
                % y = mx+b m=0.0003052, b= 0.0000916
                % COORDINATE = ( (TrialStrobeValue -3000) * SIGN * m )+ b;
                % Xmin
                FixWindow_(curTrl,3)=( ( TrialStrobeValues(curTrl , curEvt +1 ) - 3000)*(TrialStrobeValues (curTrl, curEvt+2) -1)*0.0003052 + 0.0000916);
                % Ymin
                FixWindow_(curTrl,4)=(( TrialStrobeValues(curTrl , curEvt +3 )-3000)*(TrialStrobeValues (curTrl, curEvt+4) -1)*0.0003052 + 0.0000916);
                % Xmax
                FixWindow_(curTrl,5)=(( TrialStrobeValues(curTrl , curEvt +5 )-3000)*(TrialStrobeValues (curTrl, curEvt+6)-1)*0.0003052 + 0.0000916);
                % Ymax
                FixWindow_(curTrl,6)=(( TrialStrobeValues(curTrl , curEvt +7 )-3000)*(TrialStrobeValues (curTrl, curEvt+8)-1)*0.0003052 + 0.0000916);
            end
        end

        % INFOS
        % col.1 NPOS = value of the strobed event occuring immediately after 2721
        % Number of Possible Target locations for the current Trial
        if (TrialStrobeValues(curTrl,curEvt) == 2721)
            Infos_(curTrl,1) = TrialStrobeValues (curTrl , curEvt + 1);
        end;

        % col.2   Pos = value of the strobed event occuring immediately after 2722
        % See below

        % col.3   Sound = value of the strobed event occuring immediately after 2723
        %SOUND Flag using a accoustic stop signal or not
        if (TrialStrobeValues(curTrl,curEvt)  == 2723)
            Infos_(curTrl,3) = TrialStrobeValues (curTrl , curEvt + 1);
            if Infos_(curTrl,3) == 0
                StopSignal_(curTrl,2) = 0;
            end
        end

        % col.4   ISNOTNOGO = value of the strobed event occuring immediately after 2724
        if (TrialStrobeValues (curTrl , curEvt )==2724)
            Infos_(curTrl,4) = TrialStrobeValues (curTrl , curEvt + 1);
        end

        %col. 5 empty for countermanding

        %col.6   TrigChange	= value of the strobed event occuring immediately after 2726
        if (TrialStrobeValues (curTrl , curEvt ) == 2726)
            Infos_(curTrl,6) = TrialStrobeValues (curTrl , curEvt + 1);
        end

        %%%%%%% col 7. REWARD VOLUME
        if (TrialStrobeValues (curTrl , curEvt ) == 2927)
            Infos_ (curTrl, 7) = TrialStrobeValues (curTrl , curEvt + 1);
        end

        %col.8   RewardRatio = value of the strobed event occuring immediately after 2728
        % RewardPercent is a more accurate description.
        % CAUTION : In the PDP version of the code, RewardRatio was an integer
        if (TrialStrobeValues (curTrl , curEvt ) ==2728)
            Infos_ (curTrl , 8) = TrialStrobeValues (curTrl , curEvt + 1);
        end

        %col.9   NOGO_Ratio  = value of the strobed event occuring immediately after 2729
        % NOGO_Percent is a more accurate description.
        % CAUTION : In the PDP version of the code, this was an integer
        if (TrialStrobeValues (curTrl , curEvt )==2729)
            Infos_ (curTrl, 9) = TrialStrobeValues (curTrl , curEvt + 1);
        end

        %col.10   ISNOGO, IF THE CURRENT TRIAL IS A STOP SIGNAL TRIAL
        if (TrialStrobeValues (curTrl , curEvt ) ==2730)
            Infos_ (curTrl, 10) = TrialStrobeValues (curTrl , curEvt + 1)-1;
        end


        % col.11   STOP ZAP, time relative to marker stimulation is applied

        if (TrialStrobeValues (curTrl , curEvt ) ==2731) & ZAPFLAG == 1
            % the comment in the protocol code says 700 should be subtracted from this value
            Infos_(curTrl,11) = TrialStrobeValues (curTrl , curEvt + 1);
        end

        % col.12   , stimulation duration (ms)
        if (TrialStrobeValues (curTrl , curEvt ) ==2732) & ZAPFLAG == 1
            Infos_(curTrl,12)=TrialStrobeValues ( curTrl , curEvt + 1 );
        end

        % col.13   EXPONENTIAL HOLDTIME
        if (TrialStrobeValues (curTrl , curEvt ) ==2733)
            Infos_(curTrl,13)=TrialStrobeValues ( curTrl , curEvt + 1 );
        end;

        %col.14 HOLDTIME, should be 0 for cmanding
        if (TrialStrobeValues (curTrl , curEvt ) ==2734)
            Infos_(curTrl,14)=TrialStrobeValues ( curTrl , curEvt + 1 );
        end;

        %col.15  HOLD JITTER
        if (TrialStrobeValues (curTrl , curEvt )==2735)
            % should this also be zero for cmanding???
            Infos_(curTrl,15)=TrialStrobeValues ( curTrl , curEvt + 1 );
        end;

        % col. 17 Current SOA
        if  (TrialStrobeValues (curTrl , curEvt ) ==2737) %& Infos_ (curTrl, 10) == 1
            Infos_(curTrl,17) = TrialStrobeValues ( curTrl , curEvt + 1 );
        end

        %% col. 18  MAX_SOA time relative to trial start
        if (TrialStrobeValues (curTrl , curEvt )==2738)
            Infos_(curTrl,18 ) = TrialStrobeValues ( curTrl , curEvt + 1 );
        end;
        %% col. 19   MIN_SOA time relative to trial start
        if (TrialStrobeValues (curTrl , curEvt )==2739)
            Infos_ (curTrl,19 ) = TrialStrobeValues ( curTrl , curEvt + 1 );
        end;
        % col. 20   SOA_STEP time relative to trial start
        if (TrialStrobeValues (curTrl , curEvt )==2740)
            Infos_(curTrl,20) = TrialStrobeValues ( curTrl , curEvt + 1 );
        end;


        % Reward ==2727
        if (TrialStrobeValues (curTrl , curEvt) ==2727)
            Reward_(curTrl,1) = ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1) ;
            Reward_(curTrl,2)=TrialStrobeValues (curTrl , curEvt+ 1);
            Correct_ (curTrl,2) = 1;
        end;

        % Saccade_ == 2810 (Event when the gaze leaves the fixation window)
        if (TrialStrobeValues (curTrl , curEvt) ==2810)
            Saccade_(curTrl , 1) = ceil ( TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
            Saccade_(curTrl , 2)= 0; %% no meaning, as far as i know
        end

        %%%%%%% StopSignal_== 2654
        if (TrialStrobeValues (curTrl , curEvt)==2654)
            StopSignal_(curTrl , 1) = ceil ( TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
            StopSignal_(curTrl,2) = 1; % need to change later on when acoustic stop signal added to task
        end;

        % Target_(1,:)==2650
        % on (photodiode) time relative to trial start
        if  (TrialStrobeValues (curTrl , curEvt) == 2650)
            Target_(curTrl,1)=ceil(TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1) ;
        end;

        % Target Position (0 based ) 0,1,2,3,...
        if ( TrialStrobeValues(curTrl,curEvt) ==2722)
            % Infos_ , col.2   Target Pos = value of the strobed event occuring immediately after 2722 -1
            Infos_(curTrl,2) = TrialStrobeValues( curTrl , curEvt + 1) -1;
            % Target_ , col.2   Target Pos = value of the strobed event  occuring immediately after 2722 -1
            Target_(curTrl,2) = TrialStrobeValues( curTrl , curEvt + 1) -1;
        end

        %TargetWindow == 2771
        if (TrialStrobeValues(curTrl,curEvt) ==2771)
            % subract 3000 from third strobe after 2771
            % 1st column of TargetWindow is the time which the Target_ came on  was sent during the trial
            %  Current trial is nan if monk never fixates
            if ~ isnan (Target_(curTrl,1))
                TargetWindow_(curTrl,1)=Target_(curTrl,1) ;
                TargetWindow_(curTrl,2)=0;
                % FIXATION WINDOW COORDINATES
                % VALUE: 1st,3rd,5th, and 7th strobes after 2770 are the absolute values of the coordinates + 3000
                % SIGN: 2nd,4th,6th, and 8th strobes after 2770 are the sign of the coordinate +1
                % conversion from tempo screen units to real voltage
                % y = mx+b m=0.0003052, b= 0.0000916
                % COORDINATE = ( (TrialStrobeValue -3000) * SIGN * m )+ b;
                %Xmin
                TargetWindow_(curTrl,3)=( ( TrialStrobeValues(curTrl , curEvt +1 ) - 3000)*(TrialStrobeValues (curTrl, curEvt+2) -1)*0.0003052 + 0.0000916);
                %Ymin
                TargetWindow_(curTrl,4)=(( TrialStrobeValues(curTrl , curEvt +3 )-3000)*(TrialStrobeValues (curTrl, curEvt+4) -1)*0.0003052 + 0.0000916);
                %Xmax
                TargetWindow_(curTrl,5)=(( TrialStrobeValues(curTrl , curEvt +5 )-3000)*(TrialStrobeValues (curTrl, curEvt+6)-1)*0.0003052 + 0.0000916);
                %Ymax
                TargetWindow_(curTrl,6)=(( TrialStrobeValues(curTrl , curEvt +7 )-3000)*(TrialStrobeValues (curTrl, curEvt+8)-1)*0.0003052 + 0.0000916);
            end
        end

        % Zap_== 666
        if (TrialStrobeValues (curTrl , curEvt) ==666)
            Zap_(curTrl , 1) = ceil ( TrialStrobeTimeStamps (curTrl , curEvt)*1000) - TrialStart_(curTrl,1);
            ZAPFLAG =1;
        end;
        
        % STIMULUS LOCATIONS = 7000
        if (TrialStrobeValues (curTrl , curEvt) ==7000)
            % ECCENTRICITY: IN TEMPO SCREEN UNITS
            Stim_(curTrl , 1) = TrialStrobeValues(curTrl , curEvt +1);
            % ANGLE TARGET 0 MAKES WITH X AXIS
            Stim_(curTrl , 2) = TrialStrobeValues(curTrl , curEvt +2);
            % ANGLE BETWEEN TARGET 0 AND 1 (IF MORE THAN 2 TARGETS) ELSE 180
            Stim_(curTrl , 3) = TrialStrobeValues(curTrl , curEvt +3);
            % ANGLE BETWEEN TARGET 1 AND 2 
            Stim_(curTrl , 4) = TrialStrobeValues(curTrl , curEvt +4);
        end;
    end %for curEvt = 1:N_Events
    
    % IN THE EVENT THAT THE PHOTODIODE WAS NOT WORKING THE EVENTS (Target_) 2650 AND (StopSignal_)
    % 2654 ARE NOT PRESENT IN THIS CASE THE EVENTS (Target_) 2651 AND (StopSignal_) 2653
    if isempty(find (TrialStrobeValues (curTrl , : ) == 2650)) & ~isempty(find(TrialStrobeValues (curTrl , : ) == 2651))
        if find(TrialStrobeValues (curTrl , : ) == 2651) < find(TrialStrobeValues (curTrl , : ) == 1667)
           Target_ (curTrl,1) = ceil(  TrialStrobeTimeStamps (curTrl, find (TrialStrobeValues (curTrl , : ) == 2651) ) *1000 ) - TrialStart_ (curTrl,1);
           ERRORLOG {1} = 'NO PHOTODIODE EVENT FOR TARGET_';
        end
    end
    
    if isempty(find (TrialStrobeValues (curTrl , : ) == 2654)) & ~isempty(find(TrialStrobeValues (curTrl , : ) == 2653))
        if find(TrialStrobeValues (curTrl , : ) == 2653) < find(TrialStrobeValues (curTrl , : ) == 1667)
           StopSignal_ (curTrl,1) = ceil(  TrialStrobeTimeStamps (curTrl, find (TrialStrobeValues (curTrl , : ) == 2653) ) *1000 ) - TrialStart_ (curTrl,1);
        end
            ERRORLOG {2} = 'NO PHOTODIODE EVENT FOR STOPSIGNAL_';
    end
    
end %for curTrl = 1:N_Trials

% Decide_ 2nd col contains the target window the eyes enter into.
trlsLook = find (~isnan(Decide_(:,1)));
Decide_( trlsLook,2 ) = Target_( trlsLook,2 );

%stim file = gEcenAng
if exist('Stim_')
    [m]=find(Stim_(:,1)==0);
    if ~isempty(m)
        Stim_(m,:)=[];
    end
    %MAKE SURE THE VALUES HAVE NOT BEEN CHANGED OVER THE COURSE OF THE RECORDING
    if std(Stim_(:,1))==0 & std(Stim_(:,2))==0 & std(Stim_(:,3))==0 & std(Stim_(:,4))==0
       % NEW VARIABLE FOR _M FILES: STIMULUS
        Stimulus_ = [ max(Target_(:,2))+1, Stim_(1,:) ];
        % CONVERSION FROM TEMPO SCREEN UNITS TO VISUAL DEGREES
        Stimulus_(1,2) = ceil (0.0425 * (Stimulus_(1,2)) + 0.6161);
        % CREATE STIMFILE FOR HEADER IF 2 TARGETS
        if Stimulus_(:,1)==2   
            eccen = num2str (Stimulus_(1,2));
            ang = num2str (Stimulus_(1,3));
            stimfile = strcat(['g',eccen,ang,'.stm'])
            Header_(27:27+length(stimfile)-1)= stimfile;         
        end
    else
        disp('TARGET POSITIONS HAVE BEEN CHANGED DURING THE COURSE OF THE RECORDING')
    end
end

if ZAPFLAG
    VARS2SAVE = {'Abort_','Correct_','Decide_','EmStart_','Eot_','ExtraJuice_','FixSpotOn_',...
        'FixSpotOff_','FixWindow_','Fixate_', 'Infos_','Target_','Reward_','Saccade_','Stimulus_' , 'StopSignal_','TargetWindow_','TrialStart_',...
        'TrialType_','Unit_','Wrong_','Zap_'};
else
    VARS2SAVE = {'Abort_','Correct_','Decide_','EmStart_','Eot_','ExtraJuice_','FixSpotOn_',...
        'FixSpotOff_','FixWindow_','Fixate_', 'Infos_','Target_','Reward_','Saccade_','Stimulus_','StopSignal_','TargetWindow_','TrialStart_',...
        'TrialType_','Unit_','Wrong_'};
end

save ([file_path, outfile] , 'Header_','-mat')


if isempty(ERRORLOG)            
    save ([file_path, outfile] , 'ERRORLOG','-append')
end

for curVar = 1: size(VARS2SAVE,2)
    disp(['save (',q,[file_path, outfile],qcq, VARS2SAVE{curVar},qcq,'-append',q,')'])
    eval(['save (',q,[file_path, outfile],qcq, VARS2SAVE{curVar},qcq,'-append',q,')'])
end