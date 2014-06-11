% cohdir_ni
% load QS_overlap_SameElectrode

sigOnly = 1;

%FREQUENCY FOR SIG-ONLY.  IF ENABLED, WILL ONLY WORK FOR ONE FREQUENCY BAND
%AT A TIME - DO NOT INTERPRET THE OTHER FREQUENCY BAND

freqwin = [35 100];
%freqwin = [.01 10];

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
else
    nsig.all = size(Pcoh_all.in.all,3);
    nsig.ss2 = size(Pcoh_all.in.ss2,3);
    nsig.ss4 = size(Pcoh_all.in.ss4,3);
    nsig.ss8 = size(Pcoh_all.in.ss8,3);
    nsig.fast = size(Pcoh_all.in.fast,3);
    nsig.slow = size(Pcoh_all.in.slow,3);
    nsig.err = size(Pcoh_all.in.err,3);
end

for sess = 1:length(file_list)
    
    sess
    tempname = file_list(sess).name;
    
    
    %window to average difference effect over
    window = [200 300];
    lowf = [.01 10];
    highf = [35 100];
    
    lf = find(f >= lowf(1),1,'first'):find(f <= lowf(2),1,'last');
    hf = find(f >= highf(1),1,'first'):find(f <= highf(2),1,'last');
    win = find(tout == window(1)):find(tout == window(2));
    
%     coh_d = abs(Pcoh_all.in.all(:,:,sess)) - abs(Pcoh_all.out.all(:,:,sess));
%     coh_d_low_mean = nanmean(nanmean(coh_d(win,lf)));
%     coh_d_high_mean = nanmean(nanmean(coh_d(win,hf)));
%     
%     coh_d_low_max = nanmax(nanmax(coh_d(win,lf)));
%     coh_d_high_max = nanmax(nanmax(coh_d(win,hf)));

    coh = abs(Pcoh_all.in.all(:,:,sess));
    coh_low_mean = nanmean(nanmean(coh(win,lf)));
    coh_high_mean = nanmean(nanmean(coh(win,hf)));
    
    coh_low_max = nanmax(nanmax(coh(win,lf)));
    coh_high_max = nanmax(nanmax(coh(win,hf)));

    
    filename = tempname(1:end-15);
    sig1 = tempname(end-13:end-10);
    sig2 = tempname(end-9:end-4);
    
    load(filename,sig1,sig2,'RFs','SRT','Target_','Correct_')
    
    RF1 = LFPtuning(eval(sig1));
    RF2 = RFs.(sig2);
    
    if any(isnan(coh(:)))
        overlap_strength(sess,1:5) = NaN;
    else
        overlap_strength(sess,1) = length(intersect(RF1,RF2));
        overlap_strength(sess,2) = coh_low_mean;
        overlap_strength(sess,3) = coh_high_mean;
        overlap_strength(sess,4) = coh_low_max;
        overlap_strength(sess,5) = coh_high_max;
    end
    
    clear coh* filename sig1 sig2 tempname RF1 RF2 RFs SRT Target_ Correct_ AD* DSP*
    
end