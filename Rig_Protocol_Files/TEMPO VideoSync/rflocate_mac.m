function rflocate_mac(stim_id, stimulus_color)% Global variables declared in videoTempoNet.global prepared_stimulus prepared_stim_indexglobal beep_sound_vector beep_sampling_rate_Hz% Initialized as zero, so increment before assigning values in prepared_stimulus structure.prepared_stim_index = prepared_stim_index + 1;% Store values for use when presentation command arrives.prepared_stimulus(prepared_stim_index).func_present          = 'rflocate_mac_present';prepared_stimulus(prepared_stim_index).stim_id               = stim_id;prepared_stimulus(prepared_stim_index).stimulus_color        = stimulus_color;beep_tone_frequency_Hz  = 666;beep_duration_msec      = 250;beep_sampling_rate_Hz   = 44100;% Create beep vector at defined sampling rate.[beep_sound_vector,beep_sampling_rate_Hz] = MakeBeep(beep_tone_frequency_Hz,beep_duration_msec/1000,beep_sampling_rate_Hz);sound(0); % Initialization.% Diagnostic.% prepared_stimulus(prepared_stim_index)