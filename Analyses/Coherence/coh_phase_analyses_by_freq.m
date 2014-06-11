%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: some phases need to be corrected by 180 degrees if the LFP was not
% inverted prior to calculating coherence.  This applies to the original
% 'allTL_shuff' data
%
% RPH
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%this does the phase analysis over sessions and by frequency. It is a
%butchered and hacked version of coh_phase_analysis so it is inelegant and
%brute force
flipsign = 0;

if flipsign == 1; disp('Flipping phase angles....'); end
        startt = find(tout == -200);
        endt = find(tout == 500);
        timevec = startt:endt;

go = 1; %use just for code collapsing purposes.
%do you want to use only significant sessions?

highfreq = [0 10];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms
       
            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs0_10 = angs;
clear angs



highfreq = [11 20];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms
 
            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
         

    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs11_20 = angs;
clear angs



highfreq = [21 30];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms
 
            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
         

    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs21_30 = angs;
clear angs



highfreq = [31 40];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms
 
            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
         

    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs31_40 = angs;
clear angs


highfreq = [41 50];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms
 
            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
         

    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs41_50 = angs;
clear angs



highfreq = [51 60];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms

            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
          

    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs51_60 = angs;
clear angs



highfreq = [61 70];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms

            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
          

    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs61_70 = angs;
clear angs



highfreq = [71 80];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms
  
            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
        

    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs71_80 = angs;
clear angs


highfreq = [81 90];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms

            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
          

    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs81_90 = angs;
clear angs



highfreq = [91 100];
if go == 1
    sigOnly = 0;
    if sigOnly == 1
        for sess = 1:size(Pcoh_all.in.all,3)
            if ~any(any(shuff_all.in_v_out.all.Pos(:,find(f_shuff>=freqwin(1) & f_shuff <= freqwin(2)),sess)))
                Pcoh_all.in.all(:,:,sess) = NaN;
                Pcoh_all.in.all(:,:,sess) = NaN;
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
    
    
    
    %Phases weighted by coherence value
    %==========================================================
    
    for sess = 1:size(Pcoh_all.in.all,3)
        %keep track of mean angles from -100:400 ms

            angs(sess,1) = angle(sum(sum(Pcoh_all.in.all(timevec,find(f >= highfreq(1) & f <= highfreq(2)),sess))));
           

    end
    
    if flipsign == 1
        angs(sess,1) = angs(sess,1) + pi;
    end
end
angs91_100 = angs;
clear angs




mang0_10 = rad2deg(circ_mean(angs0_10(:)));
mang11_20 = rad2deg(circ_mean(angs11_20(:)));
mang21_30 = rad2deg(circ_mean(angs21_30(:)));
mang31_40 = rad2deg(circ_mean(angs31_40(:)));
mang41_50 = rad2deg(circ_mean(angs41_50(:)));
mang51_60 = rad2deg(circ_mean(angs51_60(:)));
mang61_70 = rad2deg(circ_mean(angs61_70(:)));
mang71_80 = rad2deg(circ_mean(angs71_80(:)));
mang81_90 = rad2deg(circ_mean(angs81_90(:)));
mang91_100 = rad2deg(circ_mean(angs91_100(:)));

figure
subplot(1,2,1)

circ_plot(angs0_10(:),'pretty','ro',true,'k')
circ_plot(angs11_20(:),'pretty','ro',true,'b')
circ_plot(angs21_30(:),'pretty','ro',true,'r')
circ_plot(angs31_40(:),'pretty','ro',true,'g')
circ_plot(angs41_50(:),'pretty','ro',true,'m')
circ_plot(angs51_60(:),'pretty','ro',true,'k')
circ_plot(angs61_70(:),'pretty','ro',true,'b')
circ_plot(angs71_80(:),'pretty','ro',true,'r')
circ_plot(angs81_90(:),'pretty','ro',true,'g')
circ_plot(angs91_100(:),'pretty','ro',true,'m')

subplot(1,2,2)
bar(5:10:95,[mang0_10 mang11_20 mang21_30 mang31_40 mang41_50 mang51_60 ...
    mang61_70 mang71_80 mang81_90 mang91_100])

ylim([-120 120])