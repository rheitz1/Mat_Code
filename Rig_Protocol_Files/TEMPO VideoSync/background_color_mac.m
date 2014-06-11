function background_color_mac(background_color_R, background_color_G, background_color_B)

global DEBUG
global Window Xc Yc
global fixation_color

if (DEBUG == 0 || DEBUG == 2)

    % No rectangle input to Screen('FillRect') (i.e., passing "[]") means paint entire screen that color.
    % And for some reason the background color persists for subsequent Screen('Flip') commands.
    % Need to ask Psychtoolbox forum why this is to ensure it does not become an
    % issue later when new stimuli dveloped.
    Screen('FillRect',Window,[background_color_R, background_color_G, background_color_B],[]);
    % Screen('FillRect',Window,fixation_color,[Xc Yc (Xc + 3) (Yc + 3)]);
    Screen('Flip',Window);

end
