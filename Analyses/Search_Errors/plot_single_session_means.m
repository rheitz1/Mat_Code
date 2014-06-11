%plot single-session waveforms to find good single-session examples
f = figure;
hold

%Spike
% for sess = 1:length(keeper.reg.neuron)
%     if keeper.reg.neuron(sess) == 1
%     plot(-100:500,allwf.neuron.in_correct(sess,:),'b',-100:500,allwf.neuron.out_correct(sess,:),'--b',-100:500,allwf.neuron.in_errors(sess,:),'r',-100:500,allwf.neuron.out_errors(sess,:),'--r')
%     xlim([-50 300])
%     fon
%     title(['sess = ' mat2str(info.neuron{sess})])
%     pause
%     cla
%     end
% end
% close(f)

% 
% %LFP
for sess = 1:length(keeper.reg.LFP)
    if keeper.reg.LFP(sess) == 1
    plot(-500:2500,allwf.LFP.Hemi.in_correct(sess,:),'b',-500:2500,allwf.LFP.Hemi.out_correct(sess,:),'--b',-500:2500,allwf.LFP.Hemi.in_errors(sess,:),'r',-500:2500,allwf.LFP.Hemi.out_errors(sess,:),'--r')
    xlim([-50 300])
    axis ij
    fon
    title(['sess = ' mat2str(info.LFP{sess})])
    pause
    cla
    end
end
close(f)
% % 
% 
% 
% %N2PC
% for sess = 1:length(keeper.reg.OR)
%     if keeper.reg.OR(sess) == 1
%     plot(-500:2500,allwf.OR.in_correct(sess,:),'b',-500:2500,allwf.OR.out_correct(sess,:),'--b',-500:2500,allwf.OR.in_errors(sess,:),'r',-500:2500,allwf.OR.out_errors(sess,:),'--r')
%     xlim([-50 300])
%     axis ij
%     fon
%     title(['sess = ' mat2str(info.OR{sess})])
%     pause
%     cla
%     end
% end
% close(f)
