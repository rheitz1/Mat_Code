function rflocate_mac_present(input_index)

global DEBUG
global prepared_stimulus
global Window Xmax Ymax Xc Yc
global sync_flash_size_pix sync_flash_on
global stimulus_position_x_pix stimulus_position_y_pix stimulus_width_pix
global fixation_color fixation_position

stimulus_color = prepared_stimulus(input_index).stimulus_color;

if (DEBUG == 0 || DEBUG == 2)

    Screen('FillOval',Window,stimulus_color,[floor(stimulus_position_x_pix - stimulus_width_pix/2) floor(stimulus_position_y_pix - stimulus_width_pix/2) floor(stimulus_position_x_pix + stimulus_width_pix/2) floor(stimulus_position_y_pix + stimulus_width_pix/2)]);
    Screen('FillRect',Window,fixation_color,[fixation_position(1) fixation_position(2) (fixation_position(1) + 7) (fixation_position(2) + 7)]);
    Screen('FillRect',Window,255*sync_flash_on,[0 (Ymax - sync_flash_size_pix) sync_flash_size_pix Ymax]);

end
