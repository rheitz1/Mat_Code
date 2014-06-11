%computes all possible noise correlations for units with RFs

%find units we will use (do they have an RF?)
varlist = who;
Unitlist = varlist(strmatch('DSP',varlist));
valid = ~structfun(@isempty,RFs);

%names of valid units
valid_units = Unitlist(find(valid));

%create combination table
pairings = nchoosek(1:length(valid_units),2);


%find fast and slow conditions
if exist('SAT_') == 1
    fast = find(SAT_(:,1) == 3);
    med = find(SAT_(:,1) == 2);
    slow = find(SAT_(:,1) == 1);
end

for pair = 1:size(pairings,1)
    sig1 = eval(valid_units{pairings(pair,1)});
    sig2 = eval(valid_units{pairings(pair,2)});
    
    SDF1 = sSDF(sig1,Target_(:,1),[-500 500]);
    SDF2 = sSDF(sig2,Target_(:,1),[-500 500]);
    
    [~,~,tuning.sig1] = SPIKEtuning(sig1);
    [~,~,tuning.sig2] = SPIKEtuning(sig2);
    
    %calculate difference in preferred direction, correcting for
    %possibility of negative/positive angles
    deltaPD(pair,1) = abs(mod(tuning.sig1 - tuning.sig2 + 180,360)-180);
    
    noise_r.pre.all(pair,1) = noise_correlation(sig1,sig2,-400,0);
    noise_r.stim.all(pair,1) = noise_correlation(sig1,sig2,100,300);
    
    noise_r.zero_to_resp.all(pair,1) = noise_correlation(sig1,sig2,0,SRT(:,1));
    noise_r.entire.all(pair,1) = noise_correlation(sig1,sig2,-400,2000);
    
    if exist('SAT_') == 1
        noise_r.pre.fast(pair,1) = noise_correlation(sig1,sig2,-400,0,fast);
        noise_r.pre.slow(pair,1) = noise_correlation(sig1,sig2,-400,0,slow);
        
        noise_r.stim.fast(pair,1) = noise_correlation(sig1,sig2,100,300,fast);
        noise_r.stim.slow(pair,1) = noise_correlation(sig1,sig2,100,300,slow);
        
        noise_r.zero_to_resp.fast(pair,1) = noise_correlation(sig1,sig2,0,SRT(:,1),fast);
        noise_r.zero_to_resp.slow(pair,1) = noise_correlation(sig1,sig2,0,SRT(:,1),slow);
        
        noise_r.entire.fast(pair,1) = noise_correlation(sig1,sig2,-400,2000,fast);
        noise_r.entire.slow(pair,1) = noise_correlation(sig1,sig2,-400,2000,slow);
        
        %calculate baseline difference (fast - slow) for each unit -400:0. Collapses
        %over correct/error and target-in/distractor-in because stimuli have
        %not appeared yet
        
        %column 1 = sig1  column 2 = sig2
        base_diff(pair,1) = nanmean(nanmean(SDF1(fast,100:400))) - nanmean(nanmean(SDF1(slow,100:400)));
        base_diff(pair,2) = nanmean(nanmean(SDF2(fast,100:400))) - nanmean(nanmean(SDF2(slow,100:400)));
        
    end
    
    
end