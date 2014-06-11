cd '/volumes/Dump/Search_Data_SAT/'

batch_list = dir('*SEARCH.mat');

all_deltaPD = [];

all_noise_r.pre.all = [];
all_noise_r.stim.all = [];
all_noise_r.zero_to_resp.all = [];
all_noise_r.entire.all = [];

all_noise_r.pre.fast = [];
all_noise_r.pre.slow = [];

all_noise_r.stim.fast = [];
all_noise_r.stim.slow = [];

all_noise_r.zero_to_resp.fast = [];
all_noise_r.zero_to_resp.slow = [];

all_noise_r.entire.fast = [];
all_noise_r.entire.slow = [];

all_base_diff = [];

for sess = 1:length(batch_list)
    batch_list(sess).name
    
    load(batch_list(sess).name)
    
    if exist('RFs') == 0
        disp('No RFs...')
        keep batch_list sess all*
        continue
    end
    
    valid = ~structfun(@isempty,RFs);
    if sum(valid) < 2
        keep batch_list sess all*
        continue
    end
    
    %run script
    all_noise_correlation
    
    
    %keep track of everything thus far
    all_deltaPD = [all_deltaPD ; deltaPD];
    
    all_noise_r.pre.all = [all_noise_r.pre.all ; noise_r.pre.all];
    all_noise_r.stim.all = [all_noise_r.stim.all ; noise_r.stim.all];
    
    all_noise_r.zero_to_resp.all = [all_noise_r.zero_to_resp.all ; noise_r.zero_to_resp.all];
    all_noise_r.entire.all = [all_noise_r.entire.all ; noise_r.entire.all];
    
    if exist('SAT_') == 1
        all_noise_r.pre.fast = [all_noise_r.pre.fast ; noise_r.pre.fast];
        all_noise_r.pre.slow = [all_noise_r.pre.slow ; noise_r.pre.slow];
        
        all_noise_r.stim.fast = [all_noise_r.stim.fast ; noise_r.stim.fast];
        all_noise_r.stim.slow = [all_noise_r.stim.slow ; noise_r.stim.slow];
        
        all_noise_r.zero_to_resp.fast = [all_noise_r.zero_to_resp.fast ; noise_r.zero_to_resp.fast];
        all_noise_r.zero_to_resp.slow = [all_noise_r.zero_to_resp.slow ; noise_r.zero_to_resp.slow];
        
        all_noise_r.entire.fast = [all_noise_r.entire.fast ; noise_r.entire.fast];
        all_noise_r.entire.slow = [all_noise_r.entire.slow ; noise_r.entire.slow];
        
        %calculate baseline difference (fast - slow) for each unit -400:0. Collapses
        %over correct/error and target-in/distractor-in because stimuli have
        %not appeared yet
        
        %column 1 = sig1  column 2 = sig2
        all_base_diff = [all_base_diff ; base_diff];
        
    end
    
    keep batch_list sess all*
end