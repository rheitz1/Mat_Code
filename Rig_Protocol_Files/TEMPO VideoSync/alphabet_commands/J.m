% When TEMPO sends a single-letter command (e.g., "A;", "B;", "C;"), this
% function searches for all indices in the prepared_stimulus structure that
% have the same letter as the stim_id element.  Then the appropriate
% presentation function is called according to the func_present element
% with the index of the prepared stimulus as input.

function J

global DEBUG
global prepared_stimulus prepared_stim_index
global Window Xmax Ymax
global sync_flash_size_pix sync_flash_on
global stimulus_beep_on beep_sound_vector beep_sampling_rate_Hz
global current_flip_time previous_flip_time

active_prepared_stimulus_func_present = []; % Addition for rflocate.

for i = 1:prepared_stim_index % Current value of prepared_stim_index equals length of prepared_stimulus structure.
    if (prepared_stimulus(i).stim_id == 'J')
        fprintf('%s\n',[prepared_stimulus(i).func_present '(' num2str(i) ');']);
        eval([prepared_stimulus(i).func_present '(' num2str(i) ');']);
        active_prepared_stimulus_func_present = prepared_stimulus(i).func_present; % Addition for rflocate.
    end
end

if (DEBUG == 0 || DEBUG == 2)
    if (strcmp(active_prepared_stimulus_func_present,'rflocate_mac_present'))
        switch stimulus_beep_on
            case 0
                current_flip_time = Screen('Flip',Window,[],1); % Input parameter dontclear of 1 for Screen('Flip') to keep frame buffer unchanged.
            case 1
                current_flip_time = Screen('Flip',Window,[],1); % Input parameter dontclear of 1 for Screen('Flip') to keep frame buffer unchanged.
                sound(beep_sound_vector,beep_sampling_rate_Hz);
                WaitSecs(0.010);
                % Mario Kleiner says wait duration should be at least 0.001 seconds, but may need to be higher.
                % Have to play around with the value. The idea is that the sound command issues the sound playback
                % request to the operating system and returns immediately.  But then your script needs to sleep
                % for a few milliseconds to yield some processor time so that the operating system can run its
                % sound drivers and actually start playback of the sound.
                % For rflocate beep, nothing critical happens immediately after circle and beep presentation,
                % so make wait duration 0.010 seconds to be safe.
        end
        sy0; % Turn sync flash off. (i.e., Make it black.)
        Screen('FillRect',Window,255*sync_flash_on,[0 (Ymax - sync_flash_size_pix) sync_flash_size_pix Ymax]);
        while (GetSecs - current_flip_time < 0.100) % From oscilloscope measurements of VideoSync, sync flash should be  white for 100 ms of each 500 ms period, be it circle or background, then black.
            % Do nothing.
            WaitSecs(0.001);
        end
        Screen('Flip',Window); % Do not activate input parameter dontclear this time.
    else % Any stimulus other than rflocate.
        current_flip_time = Screen(Window,'Flip');
    end
    fprintf('Time since last Screen(''Flip'') %0.3f seconds\n',current_flip_time - previous_flip_time);
    previous_flip_time = current_flip_time;
end
