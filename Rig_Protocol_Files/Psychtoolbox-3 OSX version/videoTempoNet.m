% Daniel Shima 9/20/2007
% For videoTempoNet.m port from Lab 030 OS9 Psychtoolbox-2 to Lab 023 OSX Psychtoolbox-3,
% made cosmetic modifications,
% cleaned up Screen-command style and overall case-sensitivity for current MATLAB and Psychtoolbox-3,
% changed Screen('SetClut') to Screen('LoadNormalizedGammaTable'),
% divided DOTS_CLUT by 255,
% added DEBUG level 2,
% removed useless "stopLoop = 0;", "fooIndex = 1;", "i=1;", "cStream = [];",
% defined quitKey,
% replaced old RVS4a section with new RVS5a section with DEBUG and quitKey code,

try

    global CUR_WINDOW SrcWindow Xmax Ymax Xc Yc
    global DEBUG DOTS_CLUT

    % global variable holding slot number of NI board
    global GLOBAL_NI_DIO_SLOT_NUMBER

    % DEBUG = 0; % DEBUG mode 0 runs with TEMPO Server interface and with visual stimulus.
    DEBUG = 0; % DEBUG mode 2 runs without TEMPO Server interface, but with visual stimulus, and TEMPO dsend commands simulated locally.

    % Check for existing taskHandle addresses which should exist after videoTempoNet
    % is run the first time after MATLAB start, so RVS5a_initialize should have
    % to be called only once.
    if (DEBUG == 0)
        if(exist('rf','var') == 1 && exist('sf','var') == 1 && exist('lb','var') == 1 && exist('hb','var') == 1)
            % If all 4 addresses of taskHandles have already been defined,
            % possibly because previous run was stopped with command-period instead
            % of quit key defined below, then skip RVS5a_initialize.
        else
            [rf,sf,lb,hb] = RVS5a_initialize;
        end
    elseif (DEBUG == 2)
        % Just assign zero values to 4 address of taskHandles since they
        % need to be defined but are not used when DEBUG = 2.
        rf = 0;
        sf = 0;
        lb = 0;
        hb = 0;
    end

    if (DEBUG == 0 || DEBUG == 2)

        initScreen4;
        Screen('Preference','EmulateOldPTB',1);
        [CUR_WINDOW, SCREEN_RECT] = Screen('OpenWindow',0);
        Screen('LoadNormalizedGammaTable',CUR_WINDOW,DOTS_CLUT/255);

        for i = 1:9
            SrcWindow(i) = Screen('OpenOffScreenWindow',CUR_WINDOW);
            Screen('FillRect',SrcWindow(i),0);
        end

        Xmax = SCREEN_RECT(3);
        Ymax = SCREEN_RECT(4);
        Xc = Xmax/2; Yc = Ymax/2;
        HideCursor;

    end

    quitKey = KbName('ESCAPE'); % Define quit key.
    [keyIsDown,secs,keyCode] = KbCheck; % Initialization.

    % Call M-file that sets up TEMPO dsend command simulation instruction for use when DEBUG = 2.
    videoTempoNet_DEBUG_2_dsend_simulation;

    % TempoEx.m
    % Allen W.  5/11/00
    % script demonstrates use of videosync to recieve and execute within Matlab
    % commands sent from Tempo.

    % variable holds partial commands left over from previous parse.
    remainder = '';
    commands = '';

    while(1)

        switch keyCode(quitKey)

            case 0

                if (DEBUG == 0)
                    [numChars,theStream] = RVS5a_protocol(rf,sf,lb,hb);
                elseif (DEBUG == 2)
                    theStream = '';
                    for i = 1:size(tempo_simulation,2) % Walk through list of simulated TEMPO commands and executue them if not executed already.
                        if (GetSecs - start > tempo_simulation(i).start && tempo_simulation(i).flag == 0)
                            theStream = [theStream tempo_simulation(i).command];
                            tempo_simulation(i).flag = 1; % Flag after command has been executed.
                        end
                    end
                end
                [commands,remainder] = TempoParse2([remainder theStream]);
                for i = 1:length(commands);
                    disp(commands{i}); % This disp not necessary, but helpful to see in the command window what was executed by eval.
                    eval(commands{i});
                    sound(sin(1:100)); % Diagnostic sound for each DEBUG 2 simuluated TEMPO command.
                end

            case 1

                fprintf('User pressed [%s] to quit "videoTempoNet.m"\n',KbName(quitKey));
                while (keyCode(quitKey))
                    [keyIsDown,secs,keyCode] = KbCheck;
                    WaitSecs(0.001);
                end
                break;

        end

        [keyIsDown,secs,keyCode] = KbCheck;
        WaitSecs(0.001); % WaitSecs for one millisecond necessary in tight looping to permit OS background processes to execute.

    end

    % Clean up the four handles by stopping and clearing each task.
    if (DEBUG == 0 || DEBUG == 1)
        RVS5a_cleanup(rf,sf,lb,hb);
    elseif (DEBUG == 2)
        % No need to clean up pointer variables rf, sf, lb, and hb since just
        % equal to zero and not used for TEMPO interface in this debug mode.
        % But still need to clear them below if debug mode changes.
    end
    clear rf sf lb hb;

    ShowCursor;
    Screen('CloseAll');

catch

    ShowCursor;
    Screen('CloseAll')
    psychrethrow(psychlasterror);

end
