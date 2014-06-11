function [TrialStart_,Strobe_Times] = EventTranslator_SAT_longBase(file_path,filename,TrialStart_TimeStamps,outfile,target_on_Evt2,fix_on_Evt2,Strobe_Times,Strobe_Values)
%long baseline period version

%Translates Events from .plx format and saves them to an output file

disp(['Retrieving Events from...', [file_path,filename]])

nTrials = length(TrialStart_TimeStamps);

tempfilename=[file_path,'temp'];
multifilename = 0;
maxTrialNo = 100;
multifilenameNo=floor( nTrials / maxTrialNo);
residual= nTrials - (multifilenameNo*maxTrialNo);
if residual == 0
    %refers to how many *extra* files we'll do.  Thus, if n = 100,
    %multifilenameNo == 0.  See below: for loop begins with 0.
    multifilenameNo = multifilenameNo -1;
    residual = maxTrialNo;
end

%=================================================
% B A S E L I N E     I N T E R V A L
BASELINE = 3500;
%=================================================

%Do in chunks of 100 files
for curCHUNK = 0:multifilenameNo

    if curCHUNK == multifilenameNo & residual ~= 0
        TrialStart_(1:residual,1:2)=NaN;
        Errors_(1:residual,1:7) = NaN;
        Correct_(1:residual,1:2) = NaN;
        Decide_(1:residual,1:2) = NaN;
        Target_(1:residual,1:14) = NaN;
        SaccDir_(1:residual,1) = NaN;
        Stimuli_(1:residual,1:7) = NaN;
        MStim_(1:residual,1:3) = NaN;
        Gains_EyeX(1:residual,1) = NaN;
        Gains_EyeY(1:residual,1) = NaN;
        Gains_XYF(1:residual,1) = NaN;
        Gains_YXF(1:residual,1) = NaN;
        SAT_(1:residual,1:12) = NaN;
        FixOn_(1:residual,1) = NaN;
        FixTime_Jit_(1:residual,1) = NaN;
        FixAcqTime_(1:residual,1) = NaN;
        BellOn_(1:residual,1) = NaN;
        JuiceOn_(1:residual,1) = NaN;
        MG_Hold_(1:residual,1) = NaN;
    else
        TrialStart_(1:maxTrialNo,1:2)=NaN;
        Errors_(1:maxTrialNo,1:7) = NaN;
        Correct_(1:maxTrialNo,1:2) = NaN;
        Decide_(1:maxTrialNo,1:2) = NaN;
        Target_(1:maxTrialNo,1:14) = NaN;
        SaccDir_(1:maxTrialNo,1) = NaN;
        Stimuli_(1:maxTrialNo,1:7) = NaN;
        MStim_(1:maxTrialNo,1:3) = NaN;
        Gains_EyeX(1:maxTrialNo,1) = NaN;
        Gains_EyeY(1:maxTrialNo,1) = NaN;
        Gains_XYF(1:maxTrialNo,1) = NaN;
        Gains_YXF(1:maxTrialNo,1) = NaN;
        SAT_(1:maxTrialNo,1:12) = NaN;
        FixOn_(1:maxTrialNo,1) = NaN;
        FixTime_Jit_(1:maxTrialNo,1) = NaN;
        FixAcqTime_(1:maxTrialNo,1) = NaN;
        BellOn_(1:maxTrialNo,1) = NaN;
        JuiceOn_(1:maxTrialNo,1) = NaN;
        MG_Hold_(1:maxTrialNo,1) = NaN;
    end


    if curCHUNK==multifilenameNo & residual ~=0
        NEXTSTEP=residual;
    else
        NEXTSTEP=maxTrialNo;
    end

    nTrials = curCHUNK*maxTrialNo+NEXTSTEP;

    newindex = 1;
    for i = curCHUNK*maxTrialNo+1:nTrials
        %using floor because most of the time, the diode firing will be
        %caught LATE; we can gain a bit more consistency if we round down
        %to the nearest milliseconds
        TrialStart_(newindex,1) = floor(target_on_Evt2(i)*1000) - BASELINE; %THIS CODES BASELINE INTERVAL
       
       
        TrialEvents = [];
        if i < maxTrialNo*multifilenameNo+residual %if not last trial
            TrialEvents = find(Strobe_Times >= TrialStart_TimeStamps(i) & Strobe_Times < TrialStart_TimeStamps(i+1));
        elseif i == maxTrialNo*multifilenameNo+residual %if last trial
            TrialEvents = find(Strobe_Times >= TrialStart_TimeStamps(i));
        end

        
        %============================
        %============================
        % Find Fixation Acquire Time
        %FOR FIXATION ACQUIRE TIME, NEED TO HAVE THE PREVIOUS TRIAL AS
        %WELL. ALSO MAKE SURE THIS DOES NOT FAIL ON THE FIRST TRIAL
        if i == 1;            TrialEvents_AcquireTime = find(Strobe_Times < TrialStart_TimeStamps(i+1));        end
        
        if i > 1 && i < maxTrialNo*multifilenameNo+residual;            TrialEvents_AcquireTime = find(Strobe_Times >= TrialStart_TimeStamps(i-1) & Strobe_Times < TrialStart_TimeStamps(i+1));        end
        
        %if last trial
        if i == maxTrialNo*multifilenameNo+residual;            TrialEvents_AcquireTime = find(Strobe_Times >= TrialStart_TimeStamps(i-1));        end
        
        TrialStrobeTimes_FixAcq = Strobe_Times(TrialEvents_AcquireTime);
        TrialStrobeValues_FixAcq = Strobe_Values(TrialEvents_AcquireTime);
        
        %Find all 'fixation acquired' strobes.  There may be several
        AcquireTimes = TrialStrobeTimes_FixAcq(find(TrialStrobeValues_FixAcq == 31))*1000 - (TrialStart_(newindex,1) + BASELINE);
        
        %The fixation acquired strobe we want to keep in the latest one
        %that occurs before target onset. We already corrected them, so it
        %should be the max negative number
        
        %These are to be interpreted as ACTUAL times.  I.e., if FixAcqTime == -800, then fixation was acquired
        %800 ms before the array appeared.
        if ~isempty(AcquireTimes)
            FixAcqTime_(newindex,1) = floor(max(AcquireTimes(find(AcquireTimes < 0)))); %using floor because Tempo is going to be late in sending code, not early.
        end
        %==============================
        %==============================
        
        
        
        %Store trial-relevenat values and times, respectively, in new variables
        %Clear first for safety
        TrialStrobeValues = [];
        TrialStrobeTimes = [];
        TrialStrobeValues(1:length(TrialEvents)) = Strobe_Values(TrialEvents);
        TrialStrobeTimes(1:length(TrialEvents)) = Strobe_Times(TrialEvents);

        %Fixation Point Appearance Time.  This is calculated from the photodiode input and
        %is referenced to arbitrary start of trial, JUST LIKE FixAcqTime.  Will be a negative value, and should in most cases be
        %very close to FixAcqTime, and always before it.
        FixOn_(newindex,1) = floor(fix_on_Evt2(i)*1000) - (TrialStart_(newindex,1) + BASELINE);
        

        %if there is an abort, limit search space up until the abort code
        if ~isempty(find(TrialStrobeValues == 2621))
            relevant = min(find(TrialStrobeValues == 2621));
        else
            relevant = min(length(TrialStrobeValues));
        end

        if ~isempty(find(TrialStrobeValues(1:relevant) == 3026,1))
            
            %FixTime_Jit_ is the ms value monkey must be holding fixation
            %(with some uniform or exponentially distributed jitter) before
            %the target appears.  Thus if target onset is at 3500, and
            %FixTime_Jit_ = 1000, then we know that monkey should be
            %fixating, at a minimum, Target_(:,1)-FixTime_Jit_. Or, if
            %you've already plotted eye traces in register (e.g.,
            %-3500:2500), then the monkey is likely to have fixated at
            %   -FixTimeJit_ 
            %
            
            %Sometimes this fails when the FixTime code occurs just before
            %an abort code.
            if find(TrialStrobeValues(1:relevant) == 3026,1) == relevant
                FixTime_Jit_(newindex,1) = NaN;
                disp('Missing FixTime')
            else
                FixTime_Jit_(newindex,1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3026,1)+1);
            end
        end
        

        
        %Reward Bell Time (relative to time 0)
        if ~isempty(find(TrialStrobeValues(1:relevant) == 2726,1))
            BellOn_(newindex,1) = round(  ((TrialStrobeTimes(find(TrialStrobeValues(1:relevant) == 2726,1))*1000 - (TrialStart_(newindex,1) + BASELINE)))  );
        end
        
        %Juice (solenoid) onset time (relative to time 0)
        if ~isempty(find(TrialStrobeValues(1:relevant) == 2727,1))
            JuiceOn_(newindex,1) = round(  ((TrialStrobeTimes(find(TrialStrobeValues(1:relevant) == 2727,1))*1000 - (TrialStart_(newindex,1) + BASELINE)))  );
        end
        
        
        
        %=================================================
        % ERROR VARIABLES
        %=================================================
        % Types of Errors
        % Column:
        % 1 = CatchError
        % 2 = HoldError
        % 3 = Latency Error
        % 4 = Target Hold Error
        % 5 = Saccade Direction Error
        % 6 = Correct but too fast in SLOW
        % 7 = Correct but too slow in FAST

        if ~isempty(find(TrialStrobeValues(1:relevant) == 2622,1))
            Errors_(newindex,1) = 1;
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 2623,1))
            Errors_(newindex,2) = 1;
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 2624,1))
            Errors_(newindex,3) = 1;
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 2625,1))
            Errors_(newindex,4) = 1;
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 2626,1))
            Errors_(newindex,5) = 1;
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 2627,1))
            Errors_(newindex,6) = 1;
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 2628,1))
            Errors_(newindex,7) = 1;
        end

        % Code actual MG hold time
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3027,1))
            MG_Hold_(newindex,1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3027,1) + 1);
        end
        %=================================================
        
        
        %=================================================
        % SPEED-ACCURACY TRADEOFF (SAT) VARIABLES
        %=================================================
        % SAT Conditions
        % Column:
        % 1 = SAT blocking condtion (1 = blocked; 0 = random)
        % 2 = SAT condition (1 = slow, 2 = med, 3 = fast)
        % 3 = SAT cutoff time for current block
        % 4 = Percentile (may by unnecessary)
        % 5 = Amount of reward for current block (time in ms solenoid on)
        % 6 = Catch Trial %
        % 7 = Punish Time for Direction Error
        % 8 = Punish Time for missed deadline (noResp)
        % 9 = Duration of SEARCH array (ms)
        % 10 = Flip Conditions automatically every X trials
        % 11 = Was display cleared at deadline in FAST?
        
        if ~isempty(find(TrialStrobeValues(1:relevant) == 5000,1))
            SAT_(newindex,1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 5000,1) + 1);
        end

        if ~isempty(find(TrialStrobeValues(1:relevant) == 5001,1))
            SAT_(newindex,2) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 5001,1) + 1);
        end

        if ~isempty(find(TrialStrobeValues(1:relevant) == 5002,1))
            SAT_(newindex,3) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 5002,1) + 1);
        end

        if ~isempty(find(TrialStrobeValues(1:relevant) == 5003,1))
            SAT_(newindex,4) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 5003,1) + 1);
        end

        if ~isempty(find(TrialStrobeValues(1:relevant) == 5004,1))
            SAT_(newindex,5) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 5004,1) + 1);
        end

        if ~isempty(find(TrialStrobeValues(1:relevant) == 3047,1))
            SAT_(newindex,6) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3047,1) + 1);
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 6019,1))
            SAT_(newindex,7) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 6019,1) + 1);
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 6020,1))
            SAT_(newindex,8) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 6020,1) + 1);
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3046,1))
            SAT_(newindex,9) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3046,1) + 1);
        end
        if ~isempty(find(TrialStrobeValues(1:relevant) == 6021,1))
            SAT_(newindex,10) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 6021,1) + 1);

            %-1 stored as 255.  For this special case, hard-coded change
            if SAT_(newindex,10) == 255; SAT_(newindex,10) = -1; end
        end
        
        %was the display cleared (Fast trials only)?
        if ~isempty(find(TrialStrobeValues(1:relevant) == 6022,1))
            SAT_(newindex,11) = 1;
        else
            SAT_(newindex,11) = 0;
        end

        % What percent of missed deadlines during Fast were displays
        % cleared?
        if ~isempty(find(TrialStrobeValues(1:relevant) == 6023,1))
            SAT_(newindex,12) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 6023,1) + 1);
        end
        %=================================================

        
        %=================================================
        % TRIAL INFOS AND BEHAVIORAL VARIABLES
        %=================================================
        % Correct/Incorrect (1/0)
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3034,1))
            Correct_(newindex,2) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3034,1) + 1);
        end

        % Tempo calculated saccade latency
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3035,1))
            Decide_(newindex,1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3035,1) + 1);
        end

        % Target align time
        Target_(newindex,1) = BASELINE;

       
        %Target location (255 = catch trial)
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3013,1))
            Target_(newindex,2) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3013,1) + 1);
        end
        
        % IF catch trial, code tMaxCatch
        if Target_(newindex,2) == 255
            Target_(newindex,14) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3024,1) + 1);
        else
            Target_(newindex,14) = NaN;
        end
        
        %%%%% TARGET COLOR
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3008,1))
            Target_(newindex,3) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3008,1) + 1);
        end


        %Min Target Color (CLUT value; higher values = BRIGHTER [more white])
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3009,1))
            Target_(newindex,4) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3009,1) + 1);
        end

        %Set Size
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3005,1))
            Target_(newindex,5) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3005,1) + 1);
            if Target_(newindex,5) == 0
                Target_(newindex,5) = 2;
            elseif Target_(newindex,5) == 1
                Target_(newindex,5) = 4;
            elseif Target_(newindex,5) == 2
                Target_(newindex,5) = 8;
            end
        end


        %SET SIZE CONDITION (0 = 2; 1 = 4; 2 = 8; 3 = random
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3004,1))
            Target_(newindex,6) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3004,1) + 1);
        end

        % Easy hard  Target type
        %must index to LAST '3007' to find correct value.  I do not
        %understand this coding scheme...
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3007,1))
            %Target_(newindex,7) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3007,1,'last') - 1);
            %Target_(newindex,8) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3007,1,'last') + 1);
        end

        %Task Type  (0 = fixation; 1 = detection; 2 = search/MG??
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3003,1))
            Target_(newindex,9) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3003,1) + 1);
        end

        %Hold Time (use to determine search or memory guided)
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3021,1))
            Target_(newindex,10) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3021,1) + 1);
        end
        %
        %Homogeneous (0)/Non-homogeneous (1)
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3032,1))
            Target_(newindex,11) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3032,1) + 1);
        end

        %Eccentricity
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3001,1))
            Target_(newindex,12) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3001,1) + 1);
        end
        
        %Trial Hold Time (taking into account jitter - value actually used)
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3027,1))
            Target_(newindex,13) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3027,1) + 1);
        end

        %Actual Saccade Location
        for pos = 0:7
            if ~isempty(find(TrialStrobeValues(1:relevant) == pos + 7000,1))
                SaccDir_(newindex,1) = pos;
            end
        end

        %Actual Stimuli Presented
        for pos = 0:7
            if ~isempty(find(TrialStrobeValues(1:relevant) == pos + 6000,1))
                Stimuli_(newindex,pos + 1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == pos + 6000,1) + 1);
            end
        end

        %         if size(TrialStrobeValues(find(TrialStrobeValues(1:relevant)==3007)+1))==[1,8]
        %             Stimuli_(newindex,:)=TrialStrobeValues(find(TrialStrobeValues(1:relevant)==3007)+1);
        %         end

        %uStim Parameters

        %Stim probability
        if ~isempty(find(TrialStrobeValues(1:relevant) == 7010,1))
            MStim_(newindex,1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 7010,1) + 1);
        end

        %Stim Duration
        try
            if ~isempty(find(TrialStrobeValues(1:relevant) == 7010,1))
                MStim_(newindex,2) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 7010,1) + 2);
            end
        catch
            disp('Catching...')
        end

        %Stim Delay (relative to Target onset)

        %for negative mStimDelay -- subtract 256 to correct value
        if ~isempty(find(TrialStrobeValues(1:relevant) == 7011,1))
            MStim_(newindex,3) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 7011,1) + 1) - 256;
        elseif ~isempty(find(TrialStrobeValues(1:relevant) == 7012,1))
            MStim_(newindex,3) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 7012,1) + 1);
        end

        %EyeX and EyeY gains and manipulation factors
        if ~isempty(find(TrialStrobeValues(1:relevant) == 3036,1))
            if TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3036,1) + 1) > 30000
                Gains_EyeX(newindex,1) = (TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3036,1) + 1) - 30000) * -1;
            else
                Gains_EyeX(newindex,1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3036,1) + 1) - 20000;
            end
        else
            Gains_EyeX(newindex,1) = NaN;
        end

        if ~isempty(find(TrialStrobeValues(1:relevant) == 3037,1))
            if TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3037,1) + 1) > 30000
                Gains_EyeY(newindex,1) = (TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3037,1) + 1) - 30000) * -1;
            else
                Gains_EyeY(newindex,1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3037,1) + 1) - 20000;
            end
        else
            Gains_EyeY(newindex,1) = NaN;
        end


        if ~isempty(find(TrialStrobeValues(1:relevant) == 3038,1))
            if TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3038,1) + 1) > 30000
                Gains_XYF(newindex,1) = (TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3038,1) + 1) - 30000) * -1;
            else
                Gains_XYF(newindex,1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3038,1) + 1) - 20000;
            end
        else
            Gains_XYF(newindex,1) = NaN;
        end


        if ~isempty(find(TrialStrobeValues(1:relevant) == 3039,1))
            if TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3039,1) + 1) > 30000
                Gains_YXF(newindex,1) = (TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3039,1) + 1) - 30000) * -1;
            else
                Gains_YXF(newindex,1) = TrialStrobeValues(find(TrialStrobeValues(1:relevant) == 3039,1) + 1) - 20000;
            end
        else
            Gains_YXF(newindex,1) = NaN;
        end



        newindex = newindex + 1;

    end


    multifilename=multifilename+1;
    file = [ tempfilename , num2str(multifilename) ];

    disp (['SAVING TO...', file])
    save(file,'SAT_','Gains_EyeX','Gains_EyeY','Gains_XYF','Gains_YXF','MStim_','TrialStart_','Target_','Errors_','Correct_','FixOn_','FixTime_Jit_','BellOn_','JuiceOn_','Decide_','SaccDir_','Stimuli_','MG_Hold_','FixAcqTime_','-mat');
    clear Gains_EyeX Gains_EyeY Gains_XYF Gains_YXF MStim_ TrialStart_ Target_ Errors_ Correct_ Decide_ SaccDir_ Stimuli_ FixOn_ BellOn_ JuiceOn_ MG_Hold_ FixAcqTime_
end

%Put chunks back together
%initialize
Target_ = [];
TrialStart_ = [];
Errors_ = [];
Correct_ = [];
Decide_ = [];
SaccDir_ = [];
Stimuli_ = [];
MStim_ = [];
Gains_EyeX = [];
Gains_EyeY = [];
Gains_XYF = [];
Gains_YXF = [];
SAT_ = [];
FixOn_ = [];
FixTime_Jit_= [];
FixAcqTime_ = [];
BellOn_ = [];
JuiceOn_ = [];
MG_Hold_ = [];

for curCHUNK= 0:multifilenameNo
    if curCHUNK==multifilenameNo & residual ~=0
        NEXTSTEP=residual;
    else
        NEXTSTEP=maxTrialNo;
    end

    file = [tempfilename, num2str(curCHUNK+1)];
    disp (['loading from......', file])
    temp = load (file,'SAT_','Gains_EyeX','Gains_EyeY','Gains_XYF','Gains_YXF','MStim_','TrialStart_','Target_','Errors_','Correct_','FixOn_','FixTime_Jit_','BellOn_','JuiceOn_','Decide_','SaccDir_','Stimuli_','MG_Hold_','FixAcqTime_','-mat');
    Target_ = cat(1,Target_,temp.Target_);
    TrialStart_ = cat(1,TrialStart_,temp.TrialStart_);
    Errors_ = cat(1,Errors_,temp.Errors_);
    Correct_ = cat(1,Correct_,temp.Correct_);
    Decide_ = cat(1,Decide_,temp.Decide_);
    SaccDir_ = cat(1,SaccDir_,temp.SaccDir_);
    Stimuli_ = cat(1,Stimuli_,temp.Stimuli_);
    MStim_ = cat(1,MStim_,temp.MStim_);
    Gains_EyeX = cat(1,Gains_EyeX,temp.Gains_EyeX);
    Gains_EyeY = cat(1,Gains_EyeY,temp.Gains_EyeY);
    Gains_XYF = cat(1,Gains_XYF,temp.Gains_XYF);
    Gains_YXF = cat(1,Gains_YXF,temp.Gains_YXF);
    SAT_ = cat(1,SAT_,temp.SAT_);
    FixOn_ = cat(1,FixOn_,temp.FixOn_);
    FixTime_Jit_ = cat(1,FixTime_Jit_,temp.FixTime_Jit_);
    FixAcqTime_ = cat(1,FixAcqTime_,temp.FixAcqTime_);
    BellOn_ = cat(1,BellOn_,temp.BellOn_);
    JuiceOn_ = cat(1,JuiceOn_,temp.JuiceOn_);
    MG_Hold_ = cat(1,MG_Hold_,temp.MG_Hold_);
    temp=[];
    delete(file)
end

%SAVE VARIABLES
disp('Saving...Errors_, Correct_, Target_, TrialStart_, Decide_ SaccDir, Stimuli_, MStim_')
save([file_path,outfile],'SAT_','Gains_EyeX','Gains_EyeY','Gains_XYF','Gains_YXF','MStim_','TrialStart_','Target_','Errors_','Correct_','FixOn_','FixTime_Jit_','BellOn_','JuiceOn_','Decide_','SaccDir_','Stimuli_','MG_Hold_','FixAcqTime_','-mat')



