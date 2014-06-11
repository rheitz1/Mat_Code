function calibeye_mac_present(input_index)

global DEBUG
global prepared_stimulus
global Window

position_rect    = prepared_stimulus(input_index).position_rect;

if (DEBUG == 0 || DEBUG == 2)

    Screen('FillRect',Window,[255 255 255],position_rect);

end
