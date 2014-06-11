%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: some phases need to be corrected by 180 degrees if the LFP was not
% inverted prior to calculating coherence.  This applies to the original
% 'allTL_shuff' data
%
% RPH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


flipsign = 0;

if flipsign == 1; disp('Flipping phase angles....'); end

%do you want to use only significant sessions?
sigOnly = 0;


highfreq = [35 100];
lowfreq = [.01 10];

if sigOnly == 1
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
            Pcoh_all.in.fast(:,:,sess) = NaN;
            Pcoh_all.out.fast(:,:,sess) = NaN;
            nsig.fast(sess,1) = 0;
        else
            nsig.fast(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
            Pcoh_all.in.slow(:,:,sess) = NaN;
            Pcoh_all.out.slow(:,:,sess) = NaN;
            nsig.slow(sess,1) = 0;
        else
            nsig.slow(sess,1) = 1;
        end
        
        if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
            Pcoh_all.in.err(:,:,sess) = NaN;
            Pcoh_all.out.err(:,:,sess) = NaN;
            nsig.err(sess,1) = 0;
        else
            nsig.err(sess,1) = 1;
        end
    end
end


%Phases weighted by coherence value (sum)
%==========================================================

for sess = 1:size(Pcoh_all.in.all,3)
    %keep track of mean angles from -100:400 ms
    startt = find(tout == -200);
    endt = find(tout == 500);
    timevec = startt:endt;
    
    angs.high(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
    angs.low(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find (f >= lowfreq(1) & f <= lowfreq(2)),sess))));
end

if flipsign == 1
    angs.high = angs.high + pi;
    angs.low = angs.low + pi;
end
%==========================================================


figure
rose(angs.high(:))
title('High')

figure
rose(angs.low(:))
title('Low')

