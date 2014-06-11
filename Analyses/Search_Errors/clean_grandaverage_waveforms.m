%clean waveforms
disp('Are you running on cleaned (i.e., keeper) files? Dont!')
monkey = 'S';


if monkey == 'Q'
    %QUINCY
    sig = wf_all.OL_correct.contra;
    
    figure
    subplot(1,2,1)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title('Before')
    
    sig(any(sig(:,450:650) < -.01,2),:) = NaN;
    sig(any(sig(:,650:750) < -.006,2),:) = NaN;
    sig(any(sig(:,650:750) > .015,2),:) = NaN;
    subplot(1,2,2)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title(['After...removed ' mat2str(roundoff(length(find(isnan(sig(:,1)))) / size(sig,1),2))])
    
    OL_correct_contra_clean = sig;
    clear sig
    
    
    %==========
    sig = wf_all.OL_correct.ipsi;
    
    
    figure
    subplot(1,2,1)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    
    title('Before')
    sig(any(sig(:,450:650) < -.01,2),:) = NaN;
    sig(any(sig(:,650:750) < -.006,2),:) = NaN;
    sig(any(sig(:,650:750) > .015,2),:) = NaN;
    subplot(1,2,2)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title(['After...removed ' mat2str(roundoff(length(find(isnan(sig(:,1)))) / size(sig,1),2))])
    
    OL_correct_ipsi_clean = sig;
    clear sig
    
    
    
    %===========
    sig = wf_all.OL_errors.contra;
    
    
    figure
    subplot(1,2,1)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    
    title('Before')
    sig(any(sig(:,450:650) < -.01,2),:) = NaN;
    sig(any(sig(:,650:750) < -.006,2),:) = NaN;
    sig(any(sig(:,650:750) > .015,2),:) = NaN;
    subplot(1,2,2)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title(['After...removed ' mat2str(roundoff(length(find(isnan(sig(:,1)))) / size(sig,1),2))])
    
    OL_errors_contra_clean = sig;
    clear sig
    
    
    %============
    sig = wf_all.OL_errors.ipsi;
    
    
    figure
    subplot(1,2,1)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    
    title('Before')
    sig(any(sig(:,450:650) < -.01,2),:) = NaN;
    sig(any(sig(:,650:750) < -.006,2),:) = NaN;
    sig(any(sig(:,650:750) > .015,2),:) = NaN;
    subplot(1,2,2)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title(['After...removed ' mat2str(roundoff(length(find(isnan(sig(:,1)))) / size(sig,1),2))])
    
    OL_errors_ipsi_clean = sig;
    clear sig
    
    
    figure
    plot(-500:2500,nanmean(OL_correct_contra_clean),'b',-500:2500,nanmean(OL_correct_ipsi_clean),'--b',-500:2500,nanmean(OL_errors_contra_clean),'r',-500:2500,nanmean(OL_errors_ipsi_clean),'--r')
    axis ij
    xlim([-50 300])
    fon
    title('Cleaned')
    





elseif monkey == 'S'
    
    
    
    
    
    %SEYMOUR
    sig = wf_all.OL_correct.contra;
    
    figure
    subplot(1,2,1)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title('Before')
    
    %sig(any(sig(:,90) < .001,2),:) = NaN;

    subplot(1,2,2)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title(['After...removed ' mat2str(roundoff(length(find(isnan(sig(:,1)))) / size(sig,1),2))])
    
    OL_correct_contra_clean = sig;
    clear sig
    
    
    %==========
    sig = wf_all.OL_correct.ipsi;
    
    
    figure
    subplot(1,2,1)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    
    title('Before')
    %sig(any(sig(:,90) < .0001,2),:) = NaN;
  
    subplot(1,2,2)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title(['After...removed ' mat2str(roundoff(length(find(isnan(sig(:,1)))) / size(sig,1),2))])
    
    OL_correct_ipsi_clean = sig;
    clear sig
    
    
    
    %===========
    sig = wf_all.OL_errors.contra;
    
    
    figure
    subplot(1,2,1)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    
    title('Before')
    sig(any(sig(:,450:650) > .01,2),:) = NaN;
  
    subplot(1,2,2)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title(['After...removed ' mat2str(roundoff(length(find(isnan(sig(:,1)))) / size(sig,1),2))])
    
    OL_errors_contra_clean = sig;
    clear sig
    
    
    %============
    sig = wf_all.OL_errors.ipsi;
    
    
    figure
    subplot(1,2,1)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    
    title('Before')
    sig(any(sig(:,450:650) > .01,2),:) = NaN;
    subplot(1,2,2)
    plot(-500:2500,sig)
    axis ij
    xlim([-50 300])
    fon
    title(['After...removed ' mat2str(roundoff(length(find(isnan(sig(:,1)))) / size(sig,1),2))])
    
    OL_errors_ipsi_clean = sig;
    clear sig
    
    
    figure
    plot(-500:2500,nanmean(OL_correct_contra_clean),'b',-500:2500,nanmean(OL_correct_ipsi_clean),'--b',-500:2500,nanmean(OL_errors_contra_clean),'r',-500:2500,nanmean(OL_errors_ipsi_clean),'--r')
    axis ij
    xlim([-50 300])
    fon
    title('Cleaned')
    
    
end