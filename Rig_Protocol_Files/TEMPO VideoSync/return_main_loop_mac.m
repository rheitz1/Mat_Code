function return_main_loop_mac

global in_videoTempoNet_loop

switch in_videoTempoNet_loop
    case 0
        in_videoTempoNet_loop = 1;
        return;
    case 1
        % Value of videoTempoNet_loop already equal to 1.
        % Do not return, already looping in videoTempoNet.
end
