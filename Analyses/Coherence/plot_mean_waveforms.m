keepSigOnly = 0;
normalize = 1; %Normalize set size to set size 2, fast and slow to fast, and errors to correct
removeDuplicates = 1; %remove waveforms for signals that were re-used in different pairings


freqwin = [35 100];
%freqwin = [.01 10];

%make a copy so we don't have to over-write variables
cwf_all = wf_all;
cTDT_all = TDT_all;

if removeDuplicates == 1
    %Note: only need to find them once.  Will be the same trials across all conditions (in/out, ss2, err,
    %etc.).  Use the mean across time for a more accurate method of finding repeats.  Note however that
    %it is possible that two neurons have the same mean while not being actually repeated units.  In
    %practice, we will end up eliminating only a few more than we should, so we are being too
    %conservative.
    [~,LFP_unique,~] = unique(mean(wf_all.sig1.in.all,2));
    [~,SPK_unique,~] = unique(mean(wf_all.sig2.in.all,2));
    
    LFP_remove = setdiff(1:size(wf_all.sig1.in.all,1),LFP_unique);
    SPK_remove = setdiff(1:size(wf_all.sig2.in.all,1),SPK_unique);
    
    
    %Now set those purported repeats to NaN
    
    %For LFP
    cwf_all.sig1.in.all(LFP_remove,:) = NaN;
    cwf_all.sig1.in.ss2(LFP_remove,:) = NaN;
    cwf_all.sig1.in.ss4(LFP_remove,:) = NaN;
    cwf_all.sig1.in.ss8(LFP_remove,:) = NaN;
    cwf_all.sig1.in.err(LFP_remove,:) = NaN;
    cwf_all.sig1.in.fast.all(LFP_remove,:) = NaN;
    cwf_all.sig1.in.fast.ss2(LFP_remove,:) = NaN;
    cwf_all.sig1.in.fast.ss4(LFP_remove,:) = NaN;
    cwf_all.sig1.in.fast.ss8(LFP_remove,:) = NaN;
    cwf_all.sig1.in.slow.all(LFP_remove,:) = NaN;
    cwf_all.sig1.in.slow.ss2(LFP_remove,:) = NaN;
    cwf_all.sig1.in.slow.ss4(LFP_remove,:) = NaN;
    cwf_all.sig1.in.slow.ss8(LFP_remove,:) = NaN;
    
    cwf_all.sig1.out.all(LFP_remove,:) = NaN;
    cwf_all.sig1.out.ss2(LFP_remove,:) = NaN;
    cwf_all.sig1.out.ss4(LFP_remove,:) = NaN;
    cwf_all.sig1.out.ss8(LFP_remove,:) = NaN;
    cwf_all.sig1.out.err(LFP_remove,:) = NaN;
    cwf_all.sig1.out.fast.all(LFP_remove,:) = NaN;
    cwf_all.sig1.out.fast.ss2(LFP_remove,:) = NaN;
    cwf_all.sig1.out.fast.ss4(LFP_remove,:) = NaN;
    cwf_all.sig1.out.fast.ss8(LFP_remove,:) = NaN;
    cwf_all.sig1.out.slow.all(LFP_remove,:) = NaN;
    cwf_all.sig1.out.slow.ss2(LFP_remove,:) = NaN;
    cwf_all.sig1.out.slow.ss4(LFP_remove,:) = NaN;
    cwf_all.sig1.out.slow.ss8(LFP_remove,:) = NaN;
    
    
    %For SPK
    cwf_all.sig2.in.all(SPK_remove,:) = NaN;
    cwf_all.sig2.in.ss2(SPK_remove,:) = NaN;
    cwf_all.sig2.in.ss4(SPK_remove,:) = NaN;
    cwf_all.sig2.in.ss8(SPK_remove,:) = NaN;
    cwf_all.sig2.in.err(SPK_remove,:) = NaN;
    cwf_all.sig2.in.fast.all(SPK_remove,:) = NaN;
    cwf_all.sig2.in.fast.ss2(SPK_remove,:) = NaN;
    cwf_all.sig2.in.fast.ss4(SPK_remove,:) = NaN;
    cwf_all.sig2.in.fast.ss8(SPK_remove,:) = NaN;
    cwf_all.sig2.in.slow.all(SPK_remove,:) = NaN;
    cwf_all.sig2.in.slow.ss2(SPK_remove,:) = NaN;
    cwf_all.sig2.in.slow.ss4(SPK_remove,:) = NaN;
    cwf_all.sig2.in.slow.ss8(SPK_remove,:) = NaN;
    
    cwf_all.sig2.out.all(SPK_remove,:) = NaN;
    cwf_all.sig2.out.ss2(SPK_remove,:) = NaN;
    cwf_all.sig2.out.ss4(SPK_remove,:) = NaN;
    cwf_all.sig2.out.ss8(SPK_remove,:) = NaN;
    cwf_all.sig2.out.err(SPK_remove,:) = NaN;
    cwf_all.sig2.out.fast.all(SPK_remove,:) = NaN;
    cwf_all.sig2.out.fast.ss2(SPK_remove,:) = NaN;
    cwf_all.sig2.out.fast.ss4(SPK_remove,:) = NaN;
    cwf_all.sig2.out.fast.ss8(SPK_remove,:) = NaN;
    cwf_all.sig2.out.slow.all(SPK_remove,:) = NaN;
    cwf_all.sig2.out.slow.ss2(SPK_remove,:) = NaN;
    cwf_all.sig2.out.slow.ss4(SPK_remove,:) = NaN;
    cwf_all.sig2.out.slow.ss8(SPK_remove,:) = NaN;
    
    cTDT_all.sig1.all(LFP_remove,:) = NaN;
    cTDT_all.sig1.ss2(LFP_remove,:) = NaN;
    cTDT_all.sig1.ss4(LFP_remove,:) = NaN;
    cTDT_all.sig1.ss8(LFP_remove,:) = NaN;
    cTDT_all.sig1.err(LFP_remove,:) = NaN;
    cTDT_all.sig1.fast.all(LFP_remove,:) = NaN;
    cTDT_all.sig1.fast.ss2(LFP_remove,:) = NaN;
    cTDT_all.sig1.fast.ss4(LFP_remove,:) = NaN;
    cTDT_all.sig1.fast.ss8(LFP_remove,:) = NaN;
    cTDT_all.sig1.slow.all(LFP_remove,:) = NaN;
    cTDT_all.sig1.slow.ss2(LFP_remove,:) = NaN;
    cTDT_all.sig1.slow.ss4(LFP_remove,:) = NaN;
    cTDT_all.sig1.slow.ss8(LFP_remove,:) = NaN;
    
    cTDT_all.sig1.all(LFP_remove,:) = NaN;
    cTDT_all.sig1.ss2(LFP_remove,:) = NaN;
    cTDT_all.sig1.ss4(LFP_remove,:) = NaN;
    cTDT_all.sig1.ss8(LFP_remove,:) = NaN;
    cTDT_all.sig1.err(LFP_remove,:) = NaN;
    cTDT_all.sig1.fast.all(LFP_remove,:) = NaN;
    cTDT_all.sig1.fast.ss2(LFP_remove,:) = NaN;
    cTDT_all.sig1.fast.ss4(LFP_remove,:) = NaN;
    cTDT_all.sig1.fast.ss8(LFP_remove,:) = NaN;
    cTDT_all.sig1.slow.all(LFP_remove,:) = NaN;
    cTDT_all.sig1.slow.ss2(LFP_remove,:) = NaN;
    cTDT_all.sig1.slow.ss4(LFP_remove,:) = NaN;
    cTDT_all.sig1.slow.ss8(LFP_remove,:) = NaN;
    
    
    %For SPK
    cTDT_all.sig2.all(SPK_remove,:) = NaN;
    cTDT_all.sig2.ss2(SPK_remove,:) = NaN;
    cTDT_all.sig2.ss4(SPK_remove,:) = NaN;
    cTDT_all.sig2.ss8(SPK_remove,:) = NaN;
    cTDT_all.sig2.err(SPK_remove,:) = NaN;
    cTDT_all.sig2.fast.all(SPK_remove,:) = NaN;
    cTDT_all.sig2.fast.ss2(SPK_remove,:) = NaN;
    cTDT_all.sig2.fast.ss4(SPK_remove,:) = NaN;
    cTDT_all.sig2.fast.ss8(SPK_remove,:) = NaN;
    cTDT_all.sig2.slow.all(SPK_remove,:) = NaN;
    cTDT_all.sig2.slow.ss2(SPK_remove,:) = NaN;
    cTDT_all.sig2.slow.ss4(SPK_remove,:) = NaN;
    cTDT_all.sig2.slow.ss8(SPK_remove,:) = NaN;
    
    cTDT_all.sig2.all(SPK_remove,:) = NaN;
    cTDT_all.sig2.ss2(SPK_remove,:) = NaN;
    cTDT_all.sig2.ss4(SPK_remove,:) = NaN;
    cTDT_all.sig2.ss8(SPK_remove,:) = NaN;
    cTDT_all.sig2.err(SPK_remove,:) = NaN;
    cTDT_all.sig2.fast.all(SPK_remove,:) = NaN;
    cTDT_all.sig2.fast.ss2(SPK_remove,:) = NaN;
    cTDT_all.sig2.fast.ss4(SPK_remove,:) = NaN;
    cTDT_all.sig2.fast.ss8(SPK_remove,:) = NaN;
    cTDT_all.sig2.slow.all(SPK_remove,:) = NaN;
    cTDT_all.sig2.slow.ss2(SPK_remove,:) = NaN;
    cTDT_all.sig2.slow.ss4(SPK_remove,:) = NaN;
    cTDT_all.sig2.slow.ss8(SPK_remove,:) = NaN;
    
    
end


if keepSigOnly == 1
    
    if 1 == 1 %use for collapsing this code
        disp('Keeping significant sessions Targ in vs Targ out')
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.out.all(:,:,sess) = NaN;
                nsig.all(sess,1) = 0;
            else
                nsig.all(sess,1) = 1;
            end
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.ss2(:,:,sess) = NaN;
                Pcoh_all.out.ss2(:,:,sess) = NaN;
                nsig.ss2(sess,1) = 0;
            else
                nsig.ss2(sess,1) = 1;
            end
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.ss4(:,:,sess) = NaN;
                Pcoh_all.out.ss4(:,:,sess) = NaN;
                nsig.ss4(sess,1) = 0;
            else
                nsig.ss4(sess,1) = 1;
            end
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.ss8(:,:,sess) = NaN;
                Pcoh_all.out.ss8(:,:,sess) = NaN;
                nsig.ss8(sess,1) = 0;
            else
                nsig.ss8(sess,1) = 1;
            end
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.fast.ss2(:,:,sess) = NaN;
                Pcoh_all.out.fast.ss2(:,:,sess) = NaN;
                nsig.fast.ss2(sess,1) = 0;
            else
                nsig.fast.ss2(sess,1) = 1;
            end
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.fast.ss4(:,:,sess) = NaN;
                Pcoh_all.out.fast.ss4(:,:,sess) = NaN;
                nsig.fast.ss4(sess,1) = 0;
            else
                nsig.fast.ss4(sess,1) = 1;
            end
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.fast.ss8(:,:,sess) = NaN;
                Pcoh_all.out.fast.ss8(:,:,sess) = NaN;
                nsig.fast.ss8(sess,1) = 0;
            else
                nsig.fast.ss8(sess,1) = 1;
            end
            
            
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.slow.ss2(:,:,sess) = NaN;
                Pcoh_all.out.slow.ss2(:,:,sess) = NaN;
                nsig.slow.ss2(sess,1) = 0;
            else
                nsig.slow.ss2(sess,1) = 1;
            end
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.slow.ss4(:,:,sess) = NaN;
                Pcoh_all.out.slow.ss4(:,:,sess) = NaN;
                nsig.slow.ss4(sess,1) = 0;
            else
                nsig.slow.ss4(sess,1) = 1;
            end
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.slow.ss8(:,:,sess) = NaN;
                Pcoh_all.out.slow.ss8(:,:,sess) = NaN;
                nsig.slow.ss8(sess,1) = 0;
            else
                nsig.slow.ss8(sess,1) = 1;
            end
            
            
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.fast.all(:,:,sess) = NaN;
                Pcoh_all.out.fast.all(:,:,sess) = NaN;
                nsig.fast.all(sess,1) = 0;
            else
                nsig.fast.all(sess,1) = 1;
            end
            
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.slow.all(:,:,sess) = NaN;
                Pcoh_all.out.slow.all(:,:,sess) = NaN;
                nsig.slow.all(sess,1) = 0;
            else
                nsig.slow.all(sess,1) = 1;
            end
            
            
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.err(:,:,sess) = NaN;
                Pcoh_all.out.err(:,:,sess) = NaN;
                nsig.err(sess,1) = 0;
            else
                nsig.err(sess,1) = 1;
            end
        end
        
        
        currTDT.LFP.ss2 = nanmean(cTDT_all.sig1.ss2(find(nsig.all == 1)));
        currTDT.LFP.ss4 = nanmean(cTDT_all.sig1.ss4(find(nsig.all == 1)));
        currTDT.LFP.ss8 = nanmean(cTDT_all.sig1.ss8(find(nsig.all == 1)));
        currTDT.LFP.fast.all = nanmean(cTDT_all.sig1.fast.all(find(nsig.all == 1)));
        currTDT.LFP.slow.all = nanmean(cTDT_all.sig1.slow.all(find(nsig.all == 1)));
        
        currTDT.SPK.ss2 = nanmean(cTDT_all.sig2.ss2(find(nsig.all == 1)));
        currTDT.SPK.ss4 = nanmean(cTDT_all.sig2.ss4(find(nsig.all == 1)));
        currTDT.SPK.ss8 = nanmean(cTDT_all.sig2.ss8(find(nsig.all == 1)));
        currTDT.SPK.fast.all = nanmean(cTDT_all.sig2.fast.all(find(nsig.all == 1)));
        currTDT.SPK.slow.all = nanmean(cTDT_all.sig2.slow.all(find(nsig.all == 1)));
    end
    
    if normalize == 1
        %Normalize LFPs by minimum value of grand average FOR CORRECT TRIALS (this will flip it to being a positivity, so negate
        norm.cwf_all.sig1.in.all = -1 .* cwf_all.sig1.in.all(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig1.out.all = -1 .* cwf_all.sig1.out.all(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.all(find(nsig.all == 1),:)));
        
        norm.cwf_all.sig1.in.err = -1 .* cwf_all.sig1.in.err(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig1.out.err = -1 .* cwf_all.sig1.out.err(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.all(find(nsig.all == 1),:)));
        
        %Normalize SPKs by maximum of SDF of grand average FOR CORRECT TRIALS
        
        norm.cwf_all.sig2.in.all = cwf_all.sig2.in.all(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig2.out.all = cwf_all.sig2.out.all(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.all(find(nsig.all == 1),:)));
        
        norm.cwf_all.sig2.in.err = cwf_all.sig2.in.err(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig2.out.err = cwf_all.sig2.out.err(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.all(find(nsig.all == 1),:)));
        
        
        %Normalize by min (LFP) or max (SPK) of grand average for FAST TART-IN CORRECT
        norm.cwf_all.sig1.in.slow.all = -1 .* cwf_all.sig1.in.slow.all(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.fast.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig1.out.slow.all = -1 .* cwf_all.sig1.out.slow.all(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.fast.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig1.in.fast.all = -1 .* cwf_all.sig1.in.fast.all(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.fast.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig1.out.fast.all = -1 .* cwf_all.sig1.out.fast.all(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.fast.all(find(nsig.all == 1),:)));
        
        norm.cwf_all.sig2.in.slow.all = cwf_all.sig2.in.slow.all(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.fast.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig2.out.slow.all = cwf_all.sig2.out.slow.all(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.fast.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig2.in.fast.all = cwf_all.sig2.in.fast.all(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.fast.all(find(nsig.all == 1),:)));
        norm.cwf_all.sig2.out.fast.all = cwf_all.sig2.out.fast.all(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.fast.all(find(nsig.all == 1),:)));
        
        
        
        %Normalize LFPs by minimum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig1.in.ss2 = -1 .* cwf_all.sig1.in.ss2(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.ss2(find(nsig.all == 1),:)));
        norm.cwf_all.sig1.in.ss4 = -1 .* cwf_all.sig1.in.ss4(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.ss2(find(nsig.all == 1),:)));
        norm.cwf_all.sig1.in.ss8 = -1 .* cwf_all.sig1.in.ss8(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.ss2(find(nsig.all == 1),:)));
        
        %Normalize SPKSs by maximum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig2.in.ss2 = cwf_all.sig2.in.ss2(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.ss2(find(nsig.all == 1),:)));
        norm.cwf_all.sig2.in.ss4 = cwf_all.sig2.in.ss4(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.ss2(find(nsig.all == 1),:)));
        norm.cwf_all.sig2.in.ss8 = cwf_all.sig2.in.ss8(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.ss2(find(nsig.all == 1),:)));
        
        norm.cwf_all.sig1.out.ss2 = -1 .* cwf_all.sig1.out.ss2(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.ss2(find(nsig.all == 1),:)));
        norm.cwf_all.sig1.out.ss4 = -1 .* cwf_all.sig1.out.ss4(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.ss2(find(nsig.all == 1),:)));
        norm.cwf_all.sig1.out.ss8 = -1 .* cwf_all.sig1.out.ss8(find(nsig.all == 1),:) ./ min(nanmean(cwf_all.sig1.in.ss2(find(nsig.all == 1),:)));
        
        %Normalize SPKSs by maximum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig2.out.ss2 = cwf_all.sig2.out.ss2(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.ss2(find(nsig.all == 1),:)));
        norm.cwf_all.sig2.out.ss4 = cwf_all.sig2.out.ss4(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.ss2(find(nsig.all == 1),:)));
        norm.cwf_all.sig2.out.ss8 = cwf_all.sig2.out.ss8(find(nsig.all == 1),:) ./ max(nanmean(cwf_all.sig2.in.ss2(find(nsig.all == 1),:)));
        
    else
        %Normalize LFPs by minimum value of grand average FOR CORRECT TRIALS (this will flip it to being a positivity, so negate
        norm.cwf_all.sig1.in.all = -1 .* cwf_all.sig1.in.all(find(nsig.all == 1),:);
        norm.cwf_all.sig1.out.all = -1 .* cwf_all.sig1.out.all(find(nsig.all == 1),:) ;
        
        norm.cwf_all.sig1.in.err = -1 .* cwf_all.sig1.in.err(find(nsig.all == 1),:) ;
        norm.cwf_all.sig1.out.err = -1 .* cwf_all.sig1.out.err(find(nsig.all == 1),:) ;
        
        %Normalize SPKs by maximum of SDF of grand average FOR CORRECT TRIALS
        
        norm.cwf_all.sig2.in.all = cwf_all.sig2.in.all(find(nsig.all == 1),:) ;
        norm.cwf_all.sig2.out.all = cwf_all.sig2.out.all(find(nsig.all == 1),:) ;
        
        norm.cwf_all.sig2.in.err = cwf_all.sig2.in.err(find(nsig.all == 1),:) ;
        norm.cwf_all.sig2.out.err = cwf_all.sig2.out.err(find(nsig.all == 1),:) ;
        
        
        %Normalize by min (LFP) or max (SPK) of grand average for FAST TART-IN CORRECT
        norm.cwf_all.sig1.in.slow.all = -1 .* cwf_all.sig1.in.slow.all(find(nsig.all == 1),:) ;
        norm.cwf_all.sig1.out.slow.all = -1 .* cwf_all.sig1.out.slow.all(find(nsig.all == 1),:) ;
        norm.cwf_all.sig1.in.fast.all = -1 .* cwf_all.sig1.in.fast.all(find(nsig.all == 1),:) ;
        norm.cwf_all.sig1.out.fast.all = -1 .* cwf_all.sig1.out.fast.all(find(nsig.all == 1),:) ;
        
        norm.cwf_all.sig2.in.slow.all = cwf_all.sig2.in.slow.all(find(nsig.all == 1),:) ;
        norm.cwf_all.sig2.out.slow.all = cwf_all.sig2.out.slow.all(find(nsig.all == 1),:) ;
        norm.cwf_all.sig2.in.fast.all = cwf_all.sig2.in.fast.all(find(nsig.all == 1),:) ;
        norm.cwf_all.sig2.out.fast.all = cwf_all.sig2.out.fast.all(find(nsig.all == 1),:) ;
        
        
        
        %Normalize LFPs by minimum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig1.in.ss2 = -1 .* cwf_all.sig1.in.ss2(find(nsig.all == 1),:) ;
        norm.cwf_all.sig1.in.ss4 = -1 .* cwf_all.sig1.in.ss4(find(nsig.all == 1),:) ;
        norm.cwf_all.sig1.in.ss8 = -1 .* cwf_all.sig1.in.ss8(find(nsig.all == 1),:) ;
        
        %Normalize SPKSs by maximum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig2.in.ss2 = cwf_all.sig2.in.ss2(find(nsig.all == 1),:) ;
        norm.cwf_all.sig2.in.ss4 = cwf_all.sig2.in.ss4(find(nsig.all == 1),:) ;
        norm.cwf_all.sig2.in.ss8 = cwf_all.sig2.in.ss8(find(nsig.all == 1),:) ;
        
        norm.cwf_all.sig1.out.ss2 = -1 .* cwf_all.sig1.out.ss2(find(nsig.all == 1),:) ;
        norm.cwf_all.sig1.out.ss4 = -1 .* cwf_all.sig1.out.ss4(find(nsig.all == 1),:) ;
        norm.cwf_all.sig1.out.ss8 = -1 .* cwf_all.sig1.out.ss8(find(nsig.all == 1),:) ;
        
        %Normalize SPKSs by maximum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig2.out.ss2 = cwf_all.sig2.out.ss2(find(nsig.all == 1),:) ;
        norm.cwf_all.sig2.out.ss4 = cwf_all.sig2.out.ss4(find(nsig.all == 1),:) ;
        norm.cwf_all.sig2.out.ss8 = cwf_all.sig2.out.ss8(find(nsig.all == 1),:) ;
        
        
        sem.LFP.in.all = nanstd(norm.cwf_all.sig1.in.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.all),2))));
        sem.LFP.out.all = nanstd(norm.cwf_all.sig1.out.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.all),2))));
        
        sem.SPK.in.all = nanstd(norm.cwf_all.sig2.in.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.all),2))));
        sem.SPK.out.all = nanstd(norm.cwf_all.sig2.out.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.all),2))));
        
        sem.LFP.in.err = nanstd(norm.cwf_all.sig1.in.err,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.err),2))));
        sem.LFP.out.err = nanstd(norm.cwf_all.sig1.out.err,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.err),2))));
        
        sem.SPK.in.err = nanstd(norm.cwf_all.sig2.in.err,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.err),2))));
        sem.SPK.out.err = nanstd(norm.cwf_all.sig2.out.err,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.err),2))));
        
        sem.LFP.in.ss2 = nanstd(norm.cwf_all.sig1.in.ss2,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.ss2),2))));
        sem.LFP.in.ss4 = nanstd(norm.cwf_all.sig1.in.ss4,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.ss4),2))));
        sem.LFP.in.ss8 = nanstd(norm.cwf_all.sig1.in.ss8,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.ss8),2))));
        
        sem.SPK.in.ss2 = nanstd(norm.cwf_all.sig2.in.ss2,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.ss2),2))));
        sem.SPK.in.ss4 = nanstd(norm.cwf_all.sig2.in.ss4,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.ss4),2))));
        sem.SPK.in.ss8 = nanstd(norm.cwf_all.sig2.in.ss8,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.ss8),2))));
        
        sem.LFP.out.ss2 = nanstd(norm.cwf_all.sig1.out.ss2,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.ss2),2))));
        sem.LFP.out.ss4 = nanstd(norm.cwf_all.sig1.out.ss4,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.ss4),2))));
        sem.LFP.out.ss8 = nanstd(norm.cwf_all.sig1.out.ss8,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.ss8),2))));
        
        sem.SPK.out.ss2 = nanstd(norm.cwf_all.sig2.out.ss2,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.ss2),2))));
        sem.SPK.out.ss4 = nanstd(norm.cwf_all.sig2.out.ss4,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.ss4),2))));
        sem.SPK.out.ss8 = nanstd(norm.cwf_all.sig2.out.ss8,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.ss8),2))));
        
        sem.LFP.in.slow.all = nanstd(norm.cwf_all.sig1.in.slow.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.slow.all),2))));
        sem.LFP.out.slow.all = nanstd(norm.cwf_all.sig1.out.slow.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.slow.all),2))));
        sem.LFP.in.fast.all = nanstd(norm.cwf_all.sig1.in.fast.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.fast.all),2))));
        sem.LFP.out.fast.all = nanstd(norm.cwf_all.sig1.out.fast.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.fast.all),2))));
        
        sem.SPK.in.slow.all = nanstd(norm.cwf_all.sig2.in.slow.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.slow.all),2))));
        sem.SPK.out.slow.all = nanstd(norm.cwf_all.sig2.out.slow.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.slow.all),2))));
        sem.SPK.in.fast.all = nanstd(norm.cwf_all.sig2.in.fast.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.fast.all),2))));
        sem.SPK.out.fast.all = nanstd(norm.cwf_all.sig2.out.fast.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.fast.all),2))));
    end
else
    
    currTDT.LFP.ss2 = nanmean(cTDT_all.sig1.ss2);
    currTDT.LFP.ss4 = nanmean(cTDT_all.sig1.ss4);
    currTDT.LFP.ss8 = nanmean(cTDT_all.sig1.ss8);
    currTDT.LFP.fast.all = nanmean(cTDT_all.sig1.fast.all);
    currTDT.LFP.slow.all = nanmean(cTDT_all.sig1.slow.all);
    
    currTDT.SPK.ss2 = nanmean(cTDT_all.sig2.ss2);
    currTDT.SPK.ss4 = nanmean(cTDT_all.sig2.ss4);
    currTDT.SPK.ss8 = nanmean(cTDT_all.sig2.ss8);
    currTDT.SPK.fast.all = nanmean(cTDT_all.sig2.fast.all);
    currTDT.SPK.slow.all = nanmean(cTDT_all.sig2.slow.all);
    
    
    if normalize == 1
        %Normalize LFPs by minimum value of grand average FOR CORRECT TRIALS (this will flip it to being a positivity, so negate
        norm.cwf_all.sig1.in.all = -1 .* cwf_all.sig1.in.all ./ min(nanmean(cwf_all.sig1.in.all));
        norm.cwf_all.sig1.out.all = -1 .* cwf_all.sig1.out.all ./ min(nanmean(cwf_all.sig1.in.all));
        
        norm.cwf_all.sig1.in.err = -1 .* cwf_all.sig1.in.err ./ min(nanmean(cwf_all.sig1.in.all));
        norm.cwf_all.sig1.out.err = -1 .* cwf_all.sig1.out.err ./ min(nanmean(cwf_all.sig1.in.all));
        
        %Normalize SPKs by maximum of SDF of grand average FOR CORRECT TRIALS
        
        norm.cwf_all.sig2.in.all = cwf_all.sig2.in.all ./ max(nanmean(cwf_all.sig2.in.all));
        norm.cwf_all.sig2.out.all = cwf_all.sig2.out.all ./ max(nanmean(cwf_all.sig2.in.all));
        
        norm.cwf_all.sig2.in.err = cwf_all.sig2.in.err ./ max(nanmean(cwf_all.sig2.in.all));
        norm.cwf_all.sig2.out.err = cwf_all.sig2.out.err ./ max(nanmean(cwf_all.sig2.in.all));
        
        %Normalize by min (LFP) or max (SPK) of grand average for FAST TART-IN CORRECT
        norm.cwf_all.sig1.in.slow.all = -1 .* cwf_all.sig1.in.slow.all ./ min(nanmean(cwf_all.sig1.in.fast.all));
        norm.cwf_all.sig1.out.slow.all = -1 .* cwf_all.sig1.out.slow.all ./ min(nanmean(cwf_all.sig1.in.fast.all));
        norm.cwf_all.sig1.in.fast.all = -1 .* cwf_all.sig1.in.fast.all ./ min(nanmean(cwf_all.sig1.in.fast.all));
        norm.cwf_all.sig1.out.fast.all = -1 .* cwf_all.sig1.out.fast.all ./ min(nanmean(cwf_all.sig1.in.fast.all));
        
        norm.cwf_all.sig2.in.slow.all = cwf_all.sig2.in.slow.all ./ max(nanmean(cwf_all.sig2.in.fast.all));
        norm.cwf_all.sig2.out.slow.all = cwf_all.sig2.out.slow.all ./ max(nanmean(cwf_all.sig2.in.fast.all));
        norm.cwf_all.sig2.in.fast.all = cwf_all.sig2.in.fast.all ./ max(nanmean(cwf_all.sig2.in.fast.all));
        norm.cwf_all.sig2.out.fast.all = cwf_all.sig2.out.fast.all ./ max(nanmean(cwf_all.sig2.in.fast.all));
        
        
        
        
        %Normalize LFPs by minimum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig1.in.ss2 = -1 .* cwf_all.sig1.in.ss2 ./ min(nanmean(cwf_all.sig1.in.ss2));
        norm.cwf_all.sig1.in.ss4 = -1 .* cwf_all.sig1.in.ss4 ./ min(nanmean(cwf_all.sig1.in.ss2));
        norm.cwf_all.sig1.in.ss8 = -1 .* cwf_all.sig1.in.ss8 ./ min(nanmean(cwf_all.sig1.in.ss2));
        
        %Normalize SPKSs by maximum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig2.in.ss2 = cwf_all.sig2.in.ss2 ./ max(nanmean(cwf_all.sig2.in.ss2));
        norm.cwf_all.sig2.in.ss4 = cwf_all.sig2.in.ss4 ./ max(nanmean(cwf_all.sig2.in.ss2));
        norm.cwf_all.sig2.in.ss8 = cwf_all.sig2.in.ss8 ./ max(nanmean(cwf_all.sig2.in.ss2));
        
        %Normalize LFPs by minimum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig1.out.ss2 = -1 .* cwf_all.sig1.out.ss2 ./ min(nanmean(cwf_all.sig1.in.ss2));
        norm.cwf_all.sig1.out.ss4 = -1 .* cwf_all.sig1.out.ss4 ./ min(nanmean(cwf_all.sig1.in.ss2));
        norm.cwf_all.sig1.out.ss8 = -1 .* cwf_all.sig1.out.ss8 ./ min(nanmean(cwf_all.sig1.in.ss2));
        
        %Normalize SPKSs by maximum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig2.out.ss2 = cwf_all.sig2.out.ss2 ./ max(nanmean(cwf_all.sig2.in.ss2));
        norm.cwf_all.sig2.out.ss4 = cwf_all.sig2.out.ss4 ./ max(nanmean(cwf_all.sig2.in.ss2));
        norm.cwf_all.sig2.out.ss8 = cwf_all.sig2.out.ss8 ./ max(nanmean(cwf_all.sig2.in.ss2));
        
    else
        %Normalize LFPs by minimum value of grand average FOR CORRECT TRIALS (this will flip it to being a positivity, so negate
        norm.cwf_all.sig1.in.all = -1 .* cwf_all.sig1.in.all ;
        norm.cwf_all.sig1.out.all = -1 .* cwf_all.sig1.out.all ;
        
        norm.cwf_all.sig1.in.err = -1 .* cwf_all.sig1.in.err ;
        norm.cwf_all.sig1.out.err = -1 .* cwf_all.sig1.out.err ;
        
        %Normalize SPKs by maximum of SDF of grand average FOR CORRECT TRIALS
        
        norm.cwf_all.sig2.in.all = cwf_all.sig2.in.all ;
        norm.cwf_all.sig2.out.all = cwf_all.sig2.out.all ;
        
        norm.cwf_all.sig2.in.err = cwf_all.sig2.in.err ;
        norm.cwf_all.sig2.out.err = cwf_all.sig2.out.err ;
        
        %Normalize by min (LFP) or max (SPK) of grand average for FAST TART-IN CORRECT
        norm.cwf_all.sig1.in.slow.all = -1 .* cwf_all.sig1.in.slow.all ;
        norm.cwf_all.sig1.out.slow.all = -1 .* cwf_all.sig1.out.slow.all ;
        norm.cwf_all.sig1.in.fast.all = -1 .* cwf_all.sig1.in.fast.all ;
        norm.cwf_all.sig1.out.fast.all = -1 .* cwf_all.sig1.out.fast.all ;
        
        norm.cwf_all.sig2.in.slow.all = cwf_all.sig2.in.slow.all ;
        norm.cwf_all.sig2.out.slow.all = cwf_all.sig2.out.slow.all ;
        norm.cwf_all.sig2.in.fast.all = cwf_all.sig2.in.fast.all ;
        norm.cwf_all.sig2.out.fast.all = cwf_all.sig2.out.fast.all ;
        
        
        
        
        %Normalize LFPs by minimum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig1.in.ss2 = -1 .* cwf_all.sig1.in.ss2 ;
        norm.cwf_all.sig1.in.ss4 = -1 .* cwf_all.sig1.in.ss4 ;
        norm.cwf_all.sig1.in.ss8 = -1 .* cwf_all.sig1.in.ss8 ;
        
        %Normalize SPKSs by maximum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig2.in.ss2 = cwf_all.sig2.in.ss2 ;
        norm.cwf_all.sig2.in.ss4 = cwf_all.sig2.in.ss4 ;
        norm.cwf_all.sig2.in.ss8 = cwf_all.sig2.in.ss8 ;
        
        %Normalize LFPs by minimum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig1.out.ss2 = -1 .* cwf_all.sig1.out.ss2 ;
        norm.cwf_all.sig1.out.ss4 = -1 .* cwf_all.sig1.out.ss4 ;
        norm.cwf_all.sig1.out.ss8 = -1 .* cwf_all.sig1.out.ss8 ;
        
        %Normalize SPKSs by maximum value of grand average for SET SIZE TWO TARG-IN CORRECT
        norm.cwf_all.sig2.out.ss2 = cwf_all.sig2.out.ss2 ;
        norm.cwf_all.sig2.out.ss4 = cwf_all.sig2.out.ss4 ;
        norm.cwf_all.sig2.out.ss8 = cwf_all.sig2.out.ss8 ;
        
    end
    
    
    sem.LFP.in.all = nanstd(norm.cwf_all.sig1.in.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.all),2))));
    sem.LFP.out.all = nanstd(norm.cwf_all.sig1.out.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.all),2))));
    
    sem.SPK.in.all = nanstd(norm.cwf_all.sig2.in.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.all),2))));
    sem.SPK.out.all = nanstd(norm.cwf_all.sig2.out.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.all),2))));
    
    sem.LFP.in.err = nanstd(norm.cwf_all.sig1.in.err,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.err),2))));
    sem.LFP.out.err = nanstd(norm.cwf_all.sig1.out.err,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.err),2))));
    
    sem.SPK.in.err = nanstd(norm.cwf_all.sig2.in.err,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.err),2))));
    sem.SPK.out.err = nanstd(norm.cwf_all.sig2.out.err,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.err),2))));
    
    sem.LFP.in.ss2 = nanstd(norm.cwf_all.sig1.in.ss2,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.ss2),2))));
    sem.LFP.in.ss4 = nanstd(norm.cwf_all.sig1.in.ss4,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.ss4),2))));
    sem.LFP.in.ss8 = nanstd(norm.cwf_all.sig1.in.ss8,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.ss8),2))));
    
    sem.SPK.in.ss2 = nanstd(norm.cwf_all.sig2.in.ss2,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.ss2),2))));
    sem.SPK.in.ss4 = nanstd(norm.cwf_all.sig2.in.ss4,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.ss4),2))));
    sem.SPK.in.ss8 = nanstd(norm.cwf_all.sig2.in.ss8,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.ss8),2))));
    
    
    sem.LFP.out.ss2 = nanstd(norm.cwf_all.sig1.out.ss2,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.ss2),2))));
    sem.LFP.out.ss4 = nanstd(norm.cwf_all.sig1.out.ss4,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.ss4),2))));
    sem.LFP.out.ss8 = nanstd(norm.cwf_all.sig1.out.ss8,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.ss8),2))));
    
    sem.SPK.out.ss2 = nanstd(norm.cwf_all.sig2.out.ss2,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.ss2),2))));
    sem.SPK.out.ss4 = nanstd(norm.cwf_all.sig2.out.ss4,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.ss4),2))));
    sem.SPK.out.ss8 = nanstd(norm.cwf_all.sig2.out.ss8,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.ss8),2))));
    
    sem.LFP.in.slow.all = nanstd(norm.cwf_all.sig1.in.slow.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.slow.all),2))));
    sem.LFP.out.slow.all = nanstd(norm.cwf_all.sig1.out.slow.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.slow.all),2))));
    sem.LFP.in.fast.all = nanstd(norm.cwf_all.sig1.in.fast.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.in.fast.all),2))));
    sem.LFP.out.fast.all = nanstd(norm.cwf_all.sig1.out.fast.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig1.out.fast.all),2))));
    
    sem.SPK.in.slow.all = nanstd(norm.cwf_all.sig2.in.slow.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.slow.all),2))));
    sem.SPK.out.slow.all = nanstd(norm.cwf_all.sig2.out.slow.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.slow.all),2))));
    sem.SPK.in.fast.all = nanstd(norm.cwf_all.sig2.in.fast.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.in.fast.all),2))));
    sem.SPK.out.fast.all = nanstd(norm.cwf_all.sig2.out.fast.all,[],1) / sqrt(length(find(~any(isnan(norm.cwf_all.sig2.out.fast.all),2))));
end

figure

plot(-500:2500,nanmean(norm.cwf_all.sig1.in.all),'k',-500:2500,nanmean(norm.cwf_all.sig1.in.all)-sem.LFP.in.all,'--k', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.all)+sem.LFP.in.all,'--k', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.err),'r',-500:2500,nanmean(norm.cwf_all.sig1.in.err)-sem.LFP.in.err,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.err)+sem.LFP.in.err,'--r','linewidth',2)
hold on
plot(-500:2500,nanmean(norm.cwf_all.sig1.out.err),'r',-500:2500,nanmean(norm.cwf_all.sig1.out.err)-sem.LFP.out.err,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.err)+sem.LFP.out.err,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.all),'k',-500:2500,nanmean(norm.cwf_all.sig1.out.all)-sem.LFP.out.all,'--k', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.all)+sem.LFP.out.all,'--k')
axis ij
xlim([-100 500])
title('LFP Corr vs Err')
box off

figure
plot(-500:2500,nanmean(norm.cwf_all.sig2.in.all),'k',-500:2500,nanmean(norm.cwf_all.sig2.in.all)-sem.SPK.in.all,'--k', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.all)+sem.SPK.in.all,'--k', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.err),'r',-500:2500,nanmean(norm.cwf_all.sig2.in.err)-sem.SPK.in.err,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.err)+sem.SPK.in.err,'--r','linewidth',2)
hold on
plot(-500:2500,nanmean(norm.cwf_all.sig2.out.err),'r',-500:2500,nanmean(norm.cwf_all.sig2.out.err)-sem.SPK.out.err,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.err)+sem.SPK.out.err,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.all),'k',-500:2500,nanmean(norm.cwf_all.sig2.out.all)-sem.SPK.out.all,'--k', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.all)+sem.SPK.out.all,'--k')
xlim([-100 500])
title('SPK Corr vs Err')
box off


%
% %Target-in SetSize
% figure
% plot(-500:2500,nanmean(norm.cwf_all.sig1.in.ss2),'b',-500:2500,nanmean(norm.cwf_all.sig1.in.ss2)-sem.LFP.in.ss2,'--b', ...
%     -500:2500,nanmean(norm.cwf_all.sig1.in.ss2)+sem.LFP.in.ss2,'--b', ...
%     -500:2500,nanmean(norm.cwf_all.sig1.in.ss4),'r',-500:2500,nanmean(norm.cwf_all.sig1.in.ss4)-sem.LFP.in.ss4,'--r', ...
%     -500:2500,nanmean(norm.cwf_all.sig1.in.ss4)+sem.LFP.in.ss4,'--r', ...
%     -500:2500,nanmean(norm.cwf_all.sig1.in.ss8),'g',-500:2500,nanmean(norm.cwf_all.sig1.in.ss8)-sem.LFP.in.ss8,'--g', ...
%     -500:2500,nanmean(norm.cwf_all.sig1.in.ss8)+sem.LFP.in.ss8,'--g')
% axis ij
% xlim([-100 500])
% title('LFP Targ-in SetSize')
% box off
%
% figure
% plot(-500:2500,nanmean(norm.cwf_all.sig2.in.ss2),'b',-500:2500,nanmean(norm.cwf_all.sig2.in.ss2)-sem.SPK.in.ss2,'--b', ...
%     -500:2500,nanmean(norm.cwf_all.sig2.in.ss2)+sem.SPK.in.ss2,'--b', ...
%     -500:2500,nanmean(norm.cwf_all.sig2.in.ss4),'r',-500:2500,nanmean(norm.cwf_all.sig2.in.ss4)-sem.SPK.in.ss4,'--r', ...
%     -500:2500,nanmean(norm.cwf_all.sig2.in.ss4)+sem.SPK.in.ss4,'--r', ...
%     -500:2500,nanmean(norm.cwf_all.sig2.in.ss8),'g',-500:2500,nanmean(norm.cwf_all.sig2.in.ss8)-sem.SPK.in.ss8,'--g', ...
%     -500:2500,nanmean(norm.cwf_all.sig2.in.ss8)+sem.SPK.in.ss8,'--g')
% xlim([-100 500])
% title('SPK Targ-in SetSize')
% box off




figure
plot(-500:2500,nanmean(norm.cwf_all.sig1.in.slow.all),'b',-500:2500,nanmean(norm.cwf_all.sig1.in.slow.all)-sem.LFP.in.slow.all,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.slow.all)+sem.LFP.in.slow.all,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.fast.all),'r',-500:2500,nanmean(norm.cwf_all.sig1.in.fast.all)-sem.LFP.in.fast.all,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.fast.all)+sem.LFP.in.fast.all,'--r','linewidth',2)
hold on
plot(-500:2500,nanmean(norm.cwf_all.sig1.out.slow.all),'b',-500:2500,nanmean(norm.cwf_all.sig1.out.slow.all)-sem.LFP.out.slow.all,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.slow.all)+sem.LFP.out.slow.all,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.fast.all),'r',-500:2500,nanmean(norm.cwf_all.sig1.out.fast.all)-sem.LFP.out.fast.all,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.fast.all)+sem.LFP.out.fast.all,'--r')
axis ij
xlim([-100 500])
title('LFP Fast vs. Slow')
vline(currTDT.LFP.fast.all,'r')
vline(currTDT.LFP.slow.all,'b')
box off


figure
plot(-500:2500,nanmean(norm.cwf_all.sig2.in.slow.all),'b',-500:2500,nanmean(norm.cwf_all.sig2.in.slow.all)-sem.SPK.in.slow.all,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.slow.all)+sem.SPK.in.slow.all,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.fast.all),'r',-500:2500,nanmean(norm.cwf_all.sig2.in.fast.all)-sem.SPK.in.fast.all,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.fast.all)+sem.SPK.in.fast.all,'--r','linewidth',2)
hold on
plot(-500:2500,nanmean(norm.cwf_all.sig2.out.slow.all),'b',-500:2500,nanmean(norm.cwf_all.sig2.out.slow.all)-sem.SPK.out.slow.all,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.slow.all)+sem.SPK.out.slow.all,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.fast.all),'r',-500:2500,nanmean(norm.cwf_all.sig2.out.fast.all)-sem.SPK.out.fast.all,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.fast.all)+sem.SPK.out.fast.all,'--r')
xlim([-100 500])
title('SPK Fast vs. Slow')
vline(currTDT.SPK.fast.all,'r')
vline(currTDT.SPK.slow.all,'b')
box off


%Target-in & Distractor-in SetSize
figure
plot(-500:2500,nanmean(norm.cwf_all.sig1.in.ss2),'b',-500:2500,nanmean(norm.cwf_all.sig1.in.ss2)-sem.LFP.in.ss2,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.ss2)+sem.LFP.in.ss2,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.ss4),'r',-500:2500,nanmean(norm.cwf_all.sig1.in.ss4)-sem.LFP.in.ss4,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.ss4)+sem.LFP.in.ss4,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.ss8),'g',-500:2500,nanmean(norm.cwf_all.sig1.in.ss8)-sem.LFP.in.ss8,'--g', ...
    -500:2500,nanmean(norm.cwf_all.sig1.in.ss8)+sem.LFP.in.ss8,'--g','linewidth',2)
hold on
plot(-500:2500,nanmean(norm.cwf_all.sig1.out.ss2),'b',-500:2500,nanmean(norm.cwf_all.sig1.out.ss2)-sem.LFP.out.ss2,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.ss2)+sem.LFP.out.ss2,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.ss4),'r',-500:2500,nanmean(norm.cwf_all.sig1.out.ss4)-sem.LFP.out.ss4,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.ss4)+sem.LFP.out.ss4,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.ss8),'g',-500:2500,nanmean(norm.cwf_all.sig1.out.ss8)-sem.LFP.out.ss8,'--g', ...
    -500:2500,nanmean(norm.cwf_all.sig1.out.ss8)+sem.LFP.out.ss8,'--g')

axis ij
xlim([-100 500])
title('LFP Targ-in SetSize')
vline(currTDT.LFP.ss2,'b')
vline(currTDT.LFP.ss4,'r')
vline(currTDT.LFP.ss8,'g')
box off

figure
plot(-500:2500,nanmean(norm.cwf_all.sig2.in.ss2),'b',-500:2500,nanmean(norm.cwf_all.sig2.in.ss2)-sem.LFP.in.ss2,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.ss2)+sem.LFP.in.ss2,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.ss4),'r',-500:2500,nanmean(norm.cwf_all.sig2.in.ss4)-sem.LFP.in.ss4,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.ss4)+sem.LFP.in.ss4,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.ss8),'g',-500:2500,nanmean(norm.cwf_all.sig2.in.ss8)-sem.LFP.in.ss8,'--g', ...
    -500:2500,nanmean(norm.cwf_all.sig2.in.ss8)+sem.LFP.in.ss8,'--g','linewidth',2)
hold on
plot(-500:2500,nanmean(norm.cwf_all.sig2.out.ss2),'b',-500:2500,nanmean(norm.cwf_all.sig2.out.ss2)-sem.LFP.out.ss2,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.ss2)+sem.LFP.out.ss2,'--b', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.ss4),'r',-500:2500,nanmean(norm.cwf_all.sig2.out.ss4)-sem.LFP.out.ss4,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.ss4)+sem.LFP.out.ss4,'--r', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.ss8),'g',-500:2500,nanmean(norm.cwf_all.sig2.out.ss8)-sem.LFP.out.ss8,'--g', ...
    -500:2500,nanmean(norm.cwf_all.sig2.out.ss8)+sem.LFP.out.ss8,'--g')

xlim([-100 500])
title('SPK Targ-in SetSize')
vline(currTDT.LFP.ss2,'b')
vline(currTDT.LFP.ss4,'r')
vline(currTDT.LFP.ss8,'g')
box off


