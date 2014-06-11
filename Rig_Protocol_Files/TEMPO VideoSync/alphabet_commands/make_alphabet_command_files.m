clear all;
alphabet_vector = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

for i = 1:length(alphabet_vector)

    eval(['fid = fopen(''' alphabet_vector(i) '.m'',''w'');']);

    fprintf(fid,'%% When TEMPO sends a single-letter command (e.g., "A;", "B;", "C;"), this\n');
    fprintf(fid,'%% function searches for all indices in the prepared_stimulus structure that\n');
    fprintf(fid,'%% have the same letter as the stim_id element.  Then the appropriate\n');
    fprintf(fid,'%% presentation function is called according to the func_present element\n');
    fprintf(fid,'%% with the index of the prepared stimulus as input.\n');
    fprintf(fid,'\n');
    fprintf(fid,'function %s\n',alphabet_vector(i));
    fprintf(fid,'\n');
    fprintf(fid,'global DEBUG\n');
    fprintf(fid,'global prepared_stimulus prepared_stim_index\n');
    fprintf(fid,'global Window Xmax Ymax\n');
    fprintf(fid,'global sync_flash_size_pix sync_flash_on\n');
    fprintf(fid,'global stimulus_beep_on beep_sound_vector beep_sampling_rate_Hz\n');
    fprintf(fid,'global current_flip_time previous_flip_time\n');
    fprintf(fid,'\n');
    fprintf(fid,'active_prepared_stimulus_func_present = []; %% Addition for rflocate.\n');
    fprintf(fid,'\n');
    fprintf(fid,'for i = 1:prepared_stim_index %% Current value of prepared_stim_index equals length of prepared_stimulus structure.\n');
    fprintf(fid,'    if (prepared_stimulus(i).stim_id == ''%s'')\n',alphabet_vector(i));
    fprintf(fid,'        fprintf(''%%s\\n'',[prepared_stimulus(i).func_present ''('' num2str(i) '');'']);\n');
    fprintf(fid,'        eval([prepared_stimulus(i).func_present ''('' num2str(i) '');'']);\n');
    fprintf(fid,'        active_prepared_stimulus_func_present = prepared_stimulus(i).func_present; %% Addition for rflocate.\n');
    fprintf(fid,'    end\n');
    fprintf(fid,'end\n');
    fprintf(fid,'\n');
    fprintf(fid,'if (DEBUG == 0 || DEBUG == 2)\n');

    fprintf(fid,'    if (strcmp(active_prepared_stimulus_func_present,''rflocate_mac_present''))\n');

    fprintf(fid,'        switch stimulus_beep_on\n');
    fprintf(fid,'            case 0\n');
    fprintf(fid,'                current_flip_time = Screen(''Flip'',Window,[],1); %% Input parameter dontclear of 1 for Screen(''Flip'') to keep frame buffer unchanged.\n');
    fprintf(fid,'            case 1\n');
    fprintf(fid,'                current_flip_time = Screen(''Flip'',Window,[],1); %% Input parameter dontclear of 1 for Screen(''Flip'') to keep frame buffer unchanged.\n');
    fprintf(fid,'                sound(beep_sound_vector,beep_sampling_rate_Hz);\n');
    fprintf(fid,'                WaitSecs(0.010);\n');
    fprintf(fid,'                %% Mario Kleiner says wait duration should be at least 0.001 seconds, but may need to be higher.\n');
    fprintf(fid,'                %% Have to play around with the value. The idea is that the sound command issues the sound playback\n');
    fprintf(fid,'                %% request to the operating system and returns immediately.  But then your script needs to sleep\n');
    fprintf(fid,'                %% for a few milliseconds to yield some processor time so that the operating system can run its\n');
    fprintf(fid,'                %% sound drivers and actually start playback of the sound.\n');
    fprintf(fid,'                %% For rflocate beep, nothing critical happens immediately after circle and beep presentation,\n');
    fprintf(fid,'                %% so make wait duration 0.010 seconds to be safe.\n');
    fprintf(fid,'        end\n');

    fprintf(fid,'        sy0; %% Turn sync flash off. (i.e., Make it black.)\n');
    fprintf(fid,'        Screen(''FillRect'',Window,255*sync_flash_on,[0 (Ymax - sync_flash_size_pix) sync_flash_size_pix Ymax]);\n');
    fprintf(fid,'        while (GetSecs - current_flip_time < 0.100) %% From oscilloscope measurements of VideoSync, sync flash should be  white for 100 ms of each 500 ms period, be it circle or background, then black.\n');
    fprintf(fid,'            %% Do nothing.\n');
    fprintf(fid,'            WaitSecs(0.001);\n');
    fprintf(fid,'        end\n');
    fprintf(fid,'        Screen(''Flip'',Window); %% Do not activate input parameter dontclear this time.\n');
    fprintf(fid,'    else %% Any stimulus other than rflocate.\n');
    fprintf(fid,'        current_flip_time = Screen(Window,''Flip'');\n');
    fprintf(fid,'    end\n');

    fprintf(fid,'    fprintf(''Time since last Screen(''''Flip'''') %%0.3f seconds\\n'',current_flip_time - previous_flip_time);\n');
    fprintf(fid,'    previous_flip_time = current_flip_time;\n');
    fprintf(fid,'end\n');

    st = fclose(fid);

end
