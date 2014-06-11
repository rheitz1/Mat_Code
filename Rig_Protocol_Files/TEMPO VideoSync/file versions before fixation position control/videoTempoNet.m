% Main script for using VideoSync protocol to receive commands sent from% TEMPO% and execute them within Matlab.% 5/11/00, Allen Ingling wrote it.% 3/22/06, Daniel Shima ported it to OSX.% Avoid calling 'clear all' as it will clear the pointers to the four% taskHandles below and NIDAQmxBase will have to recreate them.  But the% old taskHandles will not actually be cleared from system memory until% MATLAB is restarted.global DEBUGglobal Window Xmax Ymax Xc Ycglobal prepared_stimulus prepared_stim_indexglobal global_rf global_sf global_lb global_hbglobal quitKeyglobal in_videoTempoNet_loop% Put all code within try-catch statement so that program gracefully exits% when Psychtoolbox 3 errors occur in development.try    video_mac; % Load in physical measurements for monitor setup.    colrsdef_mac; % Load in default colors that might be changed by TEMPO.    clear prepared_stimulus; % Clear prepared_stimulus structure at beginning of videoTempoNet just like when erase_all_mac.m is called.    prepared_stim_index = 0; % Initialize as zero, incremented in nprepSearch.    in_videoTempoNet_loop = 1; % Equals 1 when RVS5a_protocol is looping in videoTempoNet and not some sub function (e.g., rf_mac.m)    % Add path to alphabet_commands folder slightly different between Mac OSX and Windows.    if (IsOSX)        addpath([pwd '/alphabet_commands']);        addpath([pwd '/state_change_functions']);        addpath([pwd '/stimulus_parameter_functions']);        addpath([pwd '/DEBUG_2_dsend_simulation']);        % The following line UNCHECKS the "Allow Nap" check box in the Processor section of System Preferences which was installed as part        % of CHUD Tools.  This eliminates the CPU chirpping noise noticeable when Screen('Flip') is called rapidly.  (i.e., called every screen        % refresh like in rf_mac.m)  This is only necessary for early-edition Power PC G5 Macs which had this issue with their power suplies.        % Web research suggested doing this with CHUD tools was the best solution.        % See notes at bottom when "Allow Nap" is CHECKED again before program ends.        [status,result] = system('hwprefs cpu_nap=false');    elseif (IsWin)        addpath([pwd '\alphabet_commands']);        addpath([pwd '\state_change_functions']);        addpath([pwd '\stimulus_parameter_functions']);        addpath([pwd '\DEBUG_2_dsend_simulation']);    end    % Once paths are added above, initialize stimulus beep as off.  (Beep    % is just for rflocate, but need ot define it as off for calibeye and    % rf as well.    bp0;    KbName('UnifyKeyNames');    quitKey = KbName('ESCAPE'); % Define quit key.    [keyIsDown,secs,keyCode] = KbCheck; % Initialization.    DEBUG = 0; % DEBUG mode 1 runs with TEMPO Server interface and with visual stimulus.    % DEBUG = 1; % DEBUG mode 1 runs with TEMPO Server interface but without visual stimulus, so you can see text of DSEND commands arrive.    % DEBUG = 2; % DEBUG mode 2 runs without TEMPO Server interface, but with visual stimulus, and you indicate which visual stimulus to use.    % Check for existing taskHandle addresses, should exist after videoTempoNet    % is run the first time after MATLAB start, so RVS5a_initialize should have    % to be called once.    if (DEBUG == 0 || DEBUG == 1)        if(exist('rf','var') == 1 && exist('sf','var') == 1 && exist('lb','var') == 1 && exist('hb','var') == 1)            % If all 4 addresses of taskHandles have already been defined,            % possibly because previous run was stopped with command-period instead            % of quit key defined below, then skip RVS5a_initialize.        else            [rf,sf,lb,hb] = RVS5a_initialize;        end    elseif (DEBUG == 2)        % Just assign zero values to 4 address of taskHandles since they        % need to be defined but are not used when DEBUG = 2.        rf = 0;        sf = 0;        lb = 0;        hb = 0;    end    % Copy the 4 addresses of taskHandles to global variables in order to pass them to other functions.    % Passing global variables to RVS5a_protocol seems to be a big problem for MATLAB.    global_rf = rf;    global_sf = sf;    global_lb = lb;    global_hb = hb;    if (DEBUG == 0 || DEBUG == 2)        [Window,ScreenRect] = Screen('OpenWindow',0);        HideCursor;        ListenChar(2); % Supress keystrokes while program is running.        Screen('TextSize',Window,18);        Screen('TextFont',Window,'Geneva');        Screen('TextStyle',Window,1);        Screen('FillRect',Window,[0 0 0]);        Screen('DrawText',Window,'Looping in videoTempoNet.',100,100,[255 255 255]);        Screen('DrawText',Window,'Waiting for TEMPO protocol to start next visual stimulus.',100,150,[255 255 255]);        Screen('DrawText',Window,['Press [' KbName(quitKey) '] to quit videoTempoNet.'],100,200,[255 255 255]);        Screen('Flip',Window);        Xmax = ScreenRect(3);        Ymax = ScreenRect(4);        Xc = Xmax/2;        Yc = Ymax/2;    end    % Variable holds partial commands left over from previous parse.    remainder = '';    commands = '';    % Call M-file that sets up TEMPO dsend simulation instruction for use when DEBUG = 2.    videoTempoNet_DEBUG_2_dsend_simulation;    while (1)        switch keyCode(quitKey)            case 0                if (DEBUG == 0 || DEBUG == 1)                    [numChars,theStream] = RVS5a_protocol(rf,sf,lb,hb);                elseif (DEBUG == 2)                    theStream = '';                    for i = 1:size(tempo_simulation,2) % Walk through list of simulated TEMPO commands and executue then if not executed already.                        if (GetSecs - start > tempo_simulation(i).start && tempo_simulation(i).flag == 0)                            theStream = [theStream tempo_simulation(i).command];                            tempo_simulation(i).flag = 1; % Flag after command has been executed.                        end                    end                end                [commands,remainder] = TempoParse([remainder theStream]);                for i = 1:length(commands);                    disp(commands{i}); % This disp not necessary, but helpful to see in the command window what was executed by eval.                    eval(commands{i});                end            case 1                fprintf('User pressed [%s] once to quit "videoTempoNet.m"\n',KbName(quitKey));                while (keyCode(quitKey))                    [keyIsDown,secs,keyCode] = KbCheck;                    WaitSecs(0.001);                end                break;        end        [keyIsDown,secs,keyCode] = KbCheck;        WaitSecs(0.001); % WaitSecs for one millisecond necessary in tight looping to permit OS background processes to execute.    end    % Clean up the four handles by stop and clearing each task.    if (DEBUG == 0 || DEBUG == 1)        RVS5a_cleanup(rf,sf,lb,hb);    elseif (DEBUG == 2)        % No need to clean up pointer variables rf, sf, lb, and hb since just        % equal to zero and not used for TEMPO interface in this debug mode.        % But still need to clear them below if debug mode changes.    end    clear rf sf lb hb;    % Remove path to alphabet_commands folder slightly different between Mac OSX and Windows.    if (IsOSX)        rmpath([pwd '/alphabet_commands']);        rmpath([pwd '/state_change_functions']);        rmpath([pwd '/stimulus_parameter_functions']);        rmpath([pwd '/DEBUG_2_dsend_simulation']);        % The following line CHECKS the "Allow Nap" check box in the Processor section of System Preferences which was installed as        % part of CHUD Tools.  It was UNCHECKED at the top of the code.  It is wise to re-check "Allow Nap" before the program ends because        % we do not know what penalties there are for not allowing the processor to rest and having it run full steam all the time.        % (i.e., maybe processor gets hotter, fans come on stonger making new noise, lower life expectancy of computer)  So only uncheck        % "Allow Nap" when presenting visual stimulus.        [status,result] = system('hwprefs cpu_nap=true');    elseif (IsWin)        rmpath([pwd '\alphabet_commands']);        rmpath([pwd '\state_change_functions']);        rmpath([pwd '\stimulus_parameter_functions']);        rmpath([pwd '\DEBUG_2_dsend_simulation']);    end    ShowCursor;    ListenChar(0);    Screen('CloseAll');catch    % If any error occurs in the try-section above, remove the local paths,    % unlock keyboard supression, restore the cursor,    % close the Psychtoolbox screen, and report the last error in the MATLAB    % command window.    % Remove path to alphabet_commands folder slightly different between Mac OSX and Windows.    if (IsOSX)        rmpath([pwd '/alphabet_commands']);        rmpath([pwd '/state_change_functions']);        rmpath([pwd '/stimulus_parameter_functions']);        rmpath([pwd '/DEBUG_2_dsend_simulation']);        % The following line CHECKS the "Allow Nap" check box in the Processor section of System Preferences which was installed as        % part of CHUD Tools.  It was UNCHECKED at the top of the code.  It is wise to re-check "Allow Nap" before the program ends because        % we do not know what penalties there are for not allowing the processor to rest and having it run full steam all the time.        % (i.e., maybe processor gets hotter, fans come on stonger making new noise, lower life expectancy of computer)  So only uncheck        % "Allow Nap" when presenting visual stimulus.        [status,result] = system('hwprefs cpu_nap=true');    elseif (IsWin)        rmpath([pwd '\alphabet_commands']);        rmpath([pwd '\state_change_functions']);        rmpath([pwd '\stimulus_parameter_functions']);        rmpath([pwd '\DEBUG_2_dsend_simulation']);    end    ShowCursor;    ListenChar(0);    Screen('CloseAll');    rethrow(lasterror);end