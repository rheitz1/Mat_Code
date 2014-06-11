cd /volumes/Dump/Search_Data_SAT//
batch_list = dir('Q*_SEARCH.mat');

% Question: How did you correct RTs?  For missed hold time trials, wouldn't this be a negative RT?

for sess = 1:length(batch_list)
    
        
    fi = batch_list(sess).name
    
    bload(fi);
    
    [x,y] = saccade_velocity_SAT(0);
    
    %note time axis is: -199:200
    allX.slow(sess,1:400) = x.slow;
    allX.med(sess,1:400) = x.med;
    allX.fast(sess,1:400) = x.fast;
    
    allY.slow(sess,1:400) = y.slow;
    allY.med(sess,1:400) = y.med;
    allY.fast(sess,1:400) = y.fast;
    
    keep batch_list sess fi allX allY
    
    
end