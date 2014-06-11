freqwin = [35 100];
%freqwin = [15 30];
%freqwin = [0 25];
%freqwin = [0 20];
%freqwin = [0 15];
basewin = [-200 -100];

sigOnly = 1; %only use sessions that had some number of significant clusters

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