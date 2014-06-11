for sess = 1:length(TDT.LFP.stim)
    
    plot(-500:2500,wf.LFP.in.stim(sess,:),'r',-500:2500,wf.LFP.out.stim(sess,:),'--r', ...
        -500:2500,wf.LFP.in.nostim(sess,:),'b',-500:2500,wf.LFP.out.nostim(sess,:),'--b')
    axis ij
    xlim([-50 500])
    vline(TDT.LFP.stim(sess,1),'r')
    vline(TDT.LFP.nostim(sess,1),'b')
    
    keeper.LFP(sess,1) = input('Keep?');
    
end