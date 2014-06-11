function rf_mac

% Define global variables that will be accessed in this program.
global DEBUG
global Window
global global_rf global_sf global_lb global_hb
global fixation_blinking_on fixation_blinking_state fixation_blinking_counter
global quitKey
global viewing_distance_cm pixels_per_cm
global in_videoTempoNet_loop

in_videoTempoNet_loop = 0; % Equals 0 when RVS5a_protocol is looping some sub function (e.g., rf_mac.m) and not in videoTempoNet.

% Make local copies of global variables for 4 addresses of taskHandles.
rf = global_rf;
sf = global_sf;
lb = global_lb;
hb = global_hb;

try

    if (DEBUG == 0 || DEBUG == 2)

        % Output text is on initially.
        text_on = 1;

        % Working with gray levels, 0 is black and 255 is white.
        text_color = 191;

        % Start drawing text 50 pixels right and 50 pixels down from
        % upper-left corner ofr screen.
        text_x_start = 50;
        text_y_start = 50;

        % Define width and height of moving bar and fixation point in pixels.
        bar_width = 1;
        bar_height = 101;
        fixation_width = 6;
        fixation_height = 6;

        % List all bar colors, use RGB values.
        color_list = [...
            255 255 255;...
              0   0   0;...
            127 127 127;...
            255   0   0;...
            0 255   0;...
            0   0 255;...
            255 255   0;...
            255   0 255;...
            0 255 255;...
            ];

        % Variables for stimulus bar control.
        current_bar_color_index = 1; % Defines initial color from list above.
        current_bar_color = color_list(current_bar_color_index,:);
        bar_on = 1;
        bar_blinking_on = 0;
        bar_blinking_state = 1;
        bar_blinking_counter = 1;
        bar_blinking_half_period_frames = 20; % Define number of frames in half a period of bar blinking cycle.

        % Variables for fixation blinking control.
        current_fixation_color_index = 1; % Defines initial color from list above.
        current_fixation_color = color_list(current_fixation_color_index,:);
        fixation_on = 1;
        fixation_blinking_on = 0; % Initially define fixation as not blinking.
        fixation_blinking_state = 1;
        fixation_blinking_counter = 1;
        fixation_blinking_half_period_frames = 10; % Define number of frames in half a period of blinking cycle.

        % Initialize the screen for drawing Psychtoolbox stimuli.
        % Save a rectangle that defines size of screen.
        w_frame_rate = Screen('NominalFrameRate',Window);
        w_rect = Screen('Rect',Window);

        % Set bar and fixation initially in center of screen.
        updated_bar_x_pix = round(w_rect(3)/2);
        updated_bar_y_pix = round(w_rect(4)/2);
        updated_fixation_x_pix = round(w_rect(3)/2);
        updated_fixation_y_pix = round(w_rect(4)/2);

        % Set mouse initially at same location as bar.
        SetMouse(updated_bar_x_pix,updated_bar_y_pix);

        % Define convenient rectangles for placing fixation point and moving bar on screen.
        bar_rect = [ceil(-bar_width/2) ceil(-bar_height/2) ceil(bar_width/2) ceil(bar_height/2)];
        fixation_rect = [ceil(-fixation_width/2) ceil(-fixation_height/2) ceil(fixation_width/2) ceil(fixation_height/2)];


    end

    % Variable holds partial commands left over from previous parse.
    remainder = '';
    commands = '';

    % Call M-file that sets up TEMPO dsend simulation instruction for use when DEBUG = 2.
    rf_mac_DEBUG_2_dsend_simulation;

    while (1)

        [keyIsDown,secs,keyCode] = KbCheck;
        [updated_bar_x_pix,updated_bar_y_pix,buttons] = GetMouse(Window);

        % Copied code section from videoTempoNet.m to collect commands from TEMPO in order to turn fixation blinking on or off.
        switch (keyCode(quitKey))

            case 0

                if (DEBUG == 0 || DEBUG == 1)
                    [numChars,theStream] = RVS5a_protocol(rf,sf,lb,hb);
                elseif (DEBUG == 2)
                    theStream = '';
                    for i = 1:size(tempo_simulation,2) % Walk through list of simulated TEMPO commands and executue then if not executed already.
                        if (GetSecs - start > tempo_simulation(i).start && tempo_simulation(i).flag == 0)
                            theStream = [theStream tempo_simulation(i).command];
                            tempo_simulation(i).flag = 1; % Flag after command has been executed.
                        end
                    end
                end
                [commands,remainder] = TempoParse([remainder theStream]);
                for i = 1:length(commands);
                    disp(commands{i}); % This disp not necessary, but helpful to see in the command window what was executed by eval.
                    eval(commands{i});
                    % sound(sin(1:1000)); % Diagnostic beep.
                end
                if (in_videoTempoNet_loop)
                    return; % Exit rf_mac.m and return to videoTempoNet loop.
                end

            case 1

                % Let user release quit key before break so that it does not quit videoTempoNet as well.
                fprintf('User pressed [%s] once to quit "rf_mac.m"\n',KbName(quitKey));
                while (keyCode(quitKey))
                    [keyIsDown,secs,keyCode] = KbCheck;
                    WaitSecs(0.001);
                end
                break;

        end

        if (DEBUG == 0 || DEBUG == 2)

            % Stimulus bar blinking control.
            if (bar_blinking_on && ~mod(bar_blinking_counter,(bar_blinking_half_period_frames + 1)) && bar_blinking_half_period_frames > 0)
                bar_blinking_state = not(bar_blinking_state);
                bar_blinking_counter = 1;
                % sound(repmat([0.1 -0.1],1,10)) % Diagnostic click.
            end
            bar_blinking_counter = bar_blinking_counter + 1;

            % Fixation spot blinking control.
            if (fixation_blinking_on && ~mod(fixation_blinking_counter,(fixation_blinking_half_period_frames + 1)) && fixation_blinking_half_period_frames > 0)
                fixation_blinking_state = not(fixation_blinking_state);
                fixation_blinking_counter = 1;
                % sound(repmat([0.1 -0.1],1,10)) % Diagnostic click.
            end
            fixation_blinking_counter = fixation_blinking_counter + 1;

            if (text_on)

                Screen('DrawText',Window,['Bar status ' num2str(bar_on)],text_x_start,text_y_start+0*200+20*0,text_color);
                Screen('DrawText',Window,['Bar blinking ' num2str(bar_blinking_on)],text_x_start,text_y_start+0*200+20*1,text_color);
                Screen('DrawText',Window,['Bar color ' num2str(current_bar_color)],text_x_start,text_y_start+0*200+20*2,text_color);
                Screen('DrawText',Window,['Bar blinking period ' num2str(bar_blinking_half_period_frames) ' frames'],text_x_start,text_y_start+0*200+20*3,text_color);
                Screen('DrawText',Window,['Bar width ' num2str(bar_width)],text_x_start,text_y_start+0*200+20*4,text_color);
                Screen('DrawText',Window,['Bar height  ' num2str(bar_height)],text_x_start,text_y_start+0*200+20*5,text_color);
                % Define bar location relative to fixation point.
                % Screen('DrawText',Window,['Bar location pix ( ' num2str(updated_bar_x_pix - w_rect(3)/2) ' , ' num2str((updated_bar_y_pix - w_rect(4)/2)*(-1)) ' )'],text_x_start,text_y_start+0*200+20*6,text_color);
                % updated_bar_x_deg = atan((updated_bar_x_pix - w_rect(3)/2)/pixels_per_cm/viewing_distance_cm)*180/pi;
                % updated_bar_y_deg = atan((updated_bar_y_pix - w_rect(4)/2)/pixels_per_cm/viewing_distance_cm)*180/pi*(-1); % Multiply by negative 1 to flip Y-axis orientation.
                Screen('DrawText',Window,['Bar location pix ( ' num2str(updated_bar_x_pix - updated_fixation_x_pix) ' , ' num2str((updated_bar_y_pix - updated_fixation_y_pix)*(-1)) ' ) *'],text_x_start,text_y_start+0*200+20*6,text_color);
                updated_bar_x_deg = atan((updated_bar_x_pix - updated_fixation_x_pix)/pixels_per_cm/viewing_distance_cm)*180/pi;
                updated_bar_y_deg = atan((updated_bar_y_pix - updated_fixation_y_pix)/pixels_per_cm/viewing_distance_cm)*180/pi*(-1); % Multiply by negative 1 to flip Y-axis orientation.
                Screen('DrawText',Window,['Bar location deg ( ' num2str(updated_bar_x_deg,'%0.2f') ' , ' num2str(updated_bar_y_deg,'%0.2f') ' ) *'],text_x_start,text_y_start+0*200+20*7,text_color);
                Screen('DrawText',Window,'* Bar location relative to fixation location.',text_x_start,text_y_start+0*200+20*8,text_color);

                Screen('DrawText',Window,['Fixation status ' num2str(fixation_on)],text_x_start,text_y_start+1*200+20*0,text_color);
                Screen('DrawText',Window,['Fixation blinking ' num2str(fixation_blinking_on)],text_x_start,text_y_start+1*200+20*1,text_color);
                Screen('DrawText',Window,['Fixation color ' num2str(current_fixation_color)],text_x_start,text_y_start+1*200+20*2,text_color);
                Screen('DrawText',Window,['Fixation blinking period ' num2str(fixation_blinking_half_period_frames) ' frames'],text_x_start,text_y_start+1*200+20*3,text_color);
                Screen('DrawText',Window,['Fixation width ' num2str(fixation_width)],text_x_start,text_y_start+1*200+20*4,text_color);
                Screen('DrawText',Window,['Fixation height  ' num2str(fixation_height)],text_x_start,text_y_start+1*200+20*5,text_color);
                Screen('DrawText',Window,['Fixation location pix ( ' num2str(updated_fixation_x_pix - w_rect(3)/2) ' , ' num2str((updated_fixation_y_pix - w_rect(4)/2)*(-1)) ' ) **'],text_x_start,text_y_start+1*200+20*6,text_color);
                updated_fixation_x_deg = atan((updated_fixation_x_pix - w_rect(3)/2)/pixels_per_cm/viewing_distance_cm)*180/pi;
                updated_fixation_y_deg = atan((updated_fixation_y_pix - w_rect(4)/2)/pixels_per_cm/viewing_distance_cm)*180/pi*(-1); % Multiply by negative 1 to flip Y-axis orientation.
                Screen('DrawText',Window,['Fixation location deg ( ' num2str(updated_fixation_x_deg,'%0.2f') ' , ' num2str(updated_fixation_y_deg,'%0.2f') ' ) **'],text_x_start,text_y_start+1*200+20*7,text_color);
                Screen('DrawText',Window,'** Fixation location relative to center of screen.',text_x_start,text_y_start+1*200+20*8,text_color);

            end

            if (bar_on && bar_blinking_state)
                Screen('FillOval',Window,current_bar_color,bar_rect + [updated_bar_x_pix updated_bar_y_pix updated_bar_x_pix updated_bar_y_pix]);
            end

            if (fixation_on && fixation_blinking_state)
                Screen('FillRect',Window,current_fixation_color,fixation_rect + [updated_fixation_x_pix updated_fixation_y_pix updated_fixation_x_pix updated_fixation_y_pix]);
            end

            Screen('Flip',Window);

            if (keyIsDown)

                if (find(keyCode(KbName('t')))) % Toggle text on and off.
                    while (keyCode(KbName('t')))
                        [keyIsDown,secs,keyCode] = KbCheck;
                        WaitSecs(0.001);
                    end
                    text_on = not(text_on);
                    % sound(sin(1:1000)); % Diagnostic beep.

                elseif (keyCode(KbName('b'))) % Bar key control section.
                    if (find(keyCode(KbName('Return')))) % Extra find step because KbName('Return') results in two values.
                        while (find(keyCode(KbName('Return'))))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        bar_on = not(bar_on);
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('.')))
                        while (keyCode(KbName('.')))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        current_bar_color_index = current_bar_color_index + 1;
                        if (current_bar_color_index > size(color_list,1))
                            current_bar_color_index = 1;
                        end
                        current_bar_color = color_list(current_bar_color_index,:);
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('0')))
                        while (keyCode(KbName('0')))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        bar_blinking_on = not(bar_blinking_on);
                        if (bar_blinking_on)
                            bar_blinking_state = 0;
                            bar_blinking_counter = 1; % Reseting counter only necesary when turning blinking on.
                        else
                            bar_blinking_state = 1;
                        end
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('1')))
                        while (keyCode(KbName('1')))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        bar_blinking_half_period_frames = max([(bar_blinking_half_period_frames - 1) 1]);
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('2')))
                        while (keyCode(KbName('2')))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        bar_blinking_half_period_frames = min([(bar_blinking_half_period_frames + 1) w_frame_rate]);
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('4')))
                        bar_width = max([(bar_width - 1) 1]);
                        bar_rect = [ceil(-bar_width/2) ceil(-bar_height/2) ceil(bar_width/2) ceil(bar_height/2)];
                    elseif (keyCode(KbName('5')))
                        bar_width = min([(bar_width + 1) w_rect(3)/2]);
                        bar_rect = [ceil(-bar_width/2) ceil(-bar_height/2) ceil(bar_width/2) ceil(bar_height/2)];
                    elseif (keyCode(KbName('7')))
                        bar_height = max([(bar_height - 1) 1]);
                        bar_rect = [ceil(-bar_width/2) ceil(-bar_height/2) ceil(bar_width/2) ceil(bar_height/2)];
                    elseif (keyCode(KbName('8')))
                        bar_height = min([(bar_height + 1) w_rect(4)/2]);
                        bar_rect = [ceil(-bar_width/2) ceil(-bar_height/2) ceil(bar_width/2) ceil(bar_height/2)];
                    end

                elseif (keyCode(KbName('f'))) % Fixation key control section.
                    if (find(keyCode(KbName('Return')))) % Extra find step because KbName('Return') results in two values.
                        while (find(keyCode(KbName('Return'))))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        fixation_on = not(fixation_on);
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('.')))
                        while (keyCode(KbName('.')))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        current_fixation_color_index = current_fixation_color_index + 1;
                        if (current_fixation_color_index > size(color_list,1))
                            current_fixation_color_index = 1;
                        end
                        current_fixation_color = color_list(current_fixation_color_index,:);
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('0')))
                        while (keyCode(KbName('0')))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        fixation_blinking_on = not(fixation_blinking_on);
                        if (fixation_blinking_on)
                            fixation_blinking_state = 0;
                            fixation_blinking_counter = 1; % Reseting counter only necesary when turning blinking on.
                        else
                            fixation_blinking_state = 1;
                        end
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('1')))
                        while (keyCode(KbName('1')))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        fixation_blinking_half_period_frames = max([(fixation_blinking_half_period_frames - 1) 1]);
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('2')))
                        while (keyCode(KbName('2')))
                            [keyIsDown,secs,keyCode] = KbCheck;
                            WaitSecs(0.001);
                        end
                        fixation_blinking_half_period_frames = min([(fixation_blinking_half_period_frames + 1) w_frame_rate]);
                        % sound(sin(1:1000)); % Diagnostic beep.
                    elseif (keyCode(KbName('4')))
                        fixation_width = max([(fixation_width - 1) 1]);
                        fixation_rect = [ceil(-fixation_width/2) ceil(-fixation_height/2) ceil(fixation_width/2) ceil(fixation_height/2)];
                    elseif (keyCode(KbName('5')))
                        fixation_width = min([(fixation_width + 1) w_rect(3)/2]);
                        fixation_rect = [ceil(-fixation_width/2) ceil(-fixation_height/2) ceil(fixation_width/2) ceil(fixation_height/2)];
                    elseif (keyCode(KbName('7')))
                        fixation_height = max([(fixation_height - 1) 1]);
                        fixation_rect = [ceil(-fixation_width/2) ceil(-fixation_height/2) ceil(fixation_width/2) ceil(fixation_height/2)];
                    elseif (keyCode(KbName('8')))
                        fixation_height = min([(fixation_height + 1) w_rect(4)/2]);
                        fixation_rect = [ceil(-fixation_width/2) ceil(-fixation_height/2) ceil(fixation_width/2) ceil(fixation_height/2)];
                    elseif (keyCode(KbName('LeftArrow')))
                        if (keyCode(KbName('RightShift')))
                            updated_fixation_x_pix = updated_fixation_x_pix - 10;
                        else
                            updated_fixation_x_pix = updated_fixation_x_pix - 1;
                        end
                    elseif (keyCode(KbName('RightArrow')))
                        if (keyCode(KbName('RightShift')))
                            updated_fixation_x_pix = updated_fixation_x_pix + 10;
                        else
                            updated_fixation_x_pix = updated_fixation_x_pix + 1;
                        end
                    elseif (keyCode(KbName('DownArrow')))
                        if (keyCode(KbName('RightShift')))
                            updated_fixation_y_pix = updated_fixation_y_pix + 10;
                        else
                            updated_fixation_y_pix = updated_fixation_y_pix + 1;
                        end
                    elseif (keyCode(KbName('UpArrow')))
                        if (keyCode(KbName('RightShift')))
                            updated_fixation_y_pix = updated_fixation_y_pix - 10;
                        else
                            updated_fixation_y_pix = updated_fixation_y_pix - 1;
                        end
                    end

                end
            end
        end
    end

    Screen('FillRect',Window,[0 0 0]);
    Screen('DrawText',Window,'Looping in videoTempoNet.',100,100,[255 255 255]);
    Screen('DrawText',Window,'Waiting for TEMPO protocol to start next visual stimulus.',100,150,[255 255 255]);
    Screen('DrawText',Window,['Press [' KbName(quitKey) '] to quit videoTempoNet.'],100,200,[255 255 255]);
    Screen('DrawText',Window,['(User pressed [' KbName(quitKey) '] to quit rf_mac.m)'],100,250,[255 255 255]);
    Screen('Flip',Window);

    % Do not use clean-up commands here because program returning to
    % videoTempoNet where it will continue to run.

catch

    % If any error occurs in the try-section above, remove the local paths,
    % unlock keyboard supression, restore the cursor,
    % close the Psychtoolbox screen, and report the last error in the MATLAB
    % command window.

    % Remove path to alphabet_commands folder slightly different between Mac OSX and Windows.
    if (IsOSX)
        rmpath([pwd '/alphabet_commands']);
        rmpath([pwd '/state_change_functions']);
        rmpath([pwd '/stimulus_parameter_functions']);
        rmpath([pwd '/DEBUG_2_dsend_simulation']);
        % The following line CHECKS the "Allow Nap" check box in the Processor section of System Preferences which was installed as
        % part of CHUD Tools.  It was UNCHECKED at the top of videoTempNet.  It is wise to re-check "Allow Nap" before the program ends because
        % we do not know what penalties there are for not allowing the processor to rest and having it run full steam all the time.
        % (i.e., maybe processor gets hotter, fans come on stonger making new noise, lower life expectancy of computer)  So only uncheck
        % "Allow Nap" when presenting visual stimulus.
        [status,result] = system('hwprefs cpu_nap=true');
    elseif (IsWin)
        rmpath([pwd '\alphabet_commands']);
        rmpath([pwd '\state_change_functions']);
        rmpath([pwd '\stimulus_parameter_functions']);
        rmpath([pwd '\DEBUG_2_dsend_simulation']);
    end
    ShowCursor;
    ListenChar(0);
    Screen('CloseAll');
    rethrow(lasterror);

end
