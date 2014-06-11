%=========================
% CORRECT VS ERROR


%NEURON CORRECT VS ERROR
%
% figure
% 
% for sess = 1:size(allwf.neuron.in_correct,1)
%     plot(-100:500,allwf.neuron.in_correct(sess,:),'b',-100:500,allwf.neuron.out_correct(sess,:),'--b',-100:500,allwf.neuron.in_errors(sess,:),'r',-100:500,allwf.neuron.out_errors(sess,:),'--r')
%     keeper.reg.neuron(sess) = input('Keep? ');
%     cla
% end
% 
% plot(-100:500,nanmean(allwf.neuron.in_correct(find(keeper.reg.neuron),:)),'b',-100:500,nanmean(allwf.neuron.out_correct(find(keeper.reg.neuron),:)),'--b',-100:500,nanmean(allwf.neuron.in_errors(find(keeper.reg.neuron),:)),'r',-100:500,nanmean(allwf.neuron.out_errors(find(keeper.reg.neuron),:)),'--r')
% 
% 
% 


%LFP, CORRECT VS ERROR
% figure
% 
% for sess = 1:size(allwf.LFP.Hemi.in_correct,1)
%     plot(-500:2500,allwf.LFP.Hemi.in_correct(sess,:),'b',-500:2500,allwf.LFP.Hemi.out_correct(sess,:),'--b',-500:2500,allwf.LFP.Hemi.in_errors(sess,:),'r',-500:2500,allwf.LFP.Hemi.out_errors(sess,:),'--r')
%     axis ij
%     xlim([-100 500])
%     keeper.reg.LFP(sess) = input('Keep? ');
%     cla
% end
% plot(-500:2500,nanmean(allwf.LFP.Hemi.in_correct(find(keeper.reg.LFP),:)),'b',-500:2500,nanmean(allwf.LFP.Hemi.out_correct(find(keeper.reg.LFP),:)),'--b',-500:2500,nanmean(allwf.LFP.Hemi.in_errors(find(keeper.reg.LFP),:)),'r',-500:2500,nanmean(allwf.LFP.Hemi.out_errors(find(keeper.reg.LFP),:)),'--r')
% axis ij
% xlim([-100 500])



%OL CORRECT VS ERROR
% figure
% set(gcf,'color','white')
% for sess = 1:size(allwf.OL.in_correct,1)
%     plot(-500:2500,allwf.OL.in_correct(sess,:),'b',-500:2500,allwf.OL.out_correct(sess,:),'--b',-500:2500,allwf.OL.in_errors(sess,:),'r',-500:2500,allwf.OL.out_errors(sess,:),'--r')
%     axis ij
%     xlim([-100 500])
%     keeper.reg.OL(sess) = input('Keep? ');
%     cla
% end
%
%  plot(-500:2500,nanmean(allwf.OL.in_correct(find(keeper.reg.OL),:)),'b',-500:2500,nanmean(allwf.OL.out_correct(find(keeper.reg.OL),:)),'--b',-500:2500,nanmean(allwf.OL.in_errors(find(keeper.reg.OL),:)),'r',-500:2500,nanmean(allwf.OL.out_errors(find(keeper.reg.OL),:)),'--r')
% axis ij
% xlim([-100 500])


%OR CORRECT VS ERROR
% figure
% set(gcf,'color','white')
% for sess = 1:size(allwf.OR.in_correct,1)
%     plot(-500:2500,allwf.OR.in_correct(sess,:),'b',-500:2500,allwf.OR.out_correct(sess,:),'--b',-500:2500,allwf.OR.in_errors(sess,:),'r',-500:2500,allwf.OR.out_errors(sess,:),'--r')
%     axis ij
%     xlim([-100 500])
%     keeper.reg.OR(sess) = input('Keep? ');
%     cla
% end
% 
%  plot(-500:2500,nanmean(allwf.OR.in_correct(find(keeper.reg.OR),:)),'b',-500:2500,nanmean(allwf.OR.out_correct(find(keeper.reg.OR),:)),'--b',-500:2500,nanmean(allwf.OR.in_errors(find(keeper.reg.OR),:)),'r',-500:2500,nanmean(allwf.OR.out_errors(find(keeper.reg.OR),:)),'--r')
% axis ij
% xlim([-100 500])

%==================================




%========================
%CATCH TRIALS

%CATCH TRIALS NEURON
% figure
% 
% for sess = 1:size(allwf.neuron.catch.correct_nosacc,1)
%     plot(-100:500,allwf.neuron.in_correct(sess,:),'k',-100:500,allwf.neuron.out_correct(sess,:),'--k',-100:500,allwf.neuron.catch.correct_nosacc(sess,:),'b',-100:500,allwf.neuron.catch.errors_in(sess,:),'r',-100:500,allwf.neuron.catch.correct_in(sess,:),'g')
%     keeper.catch.neuron(sess) = input('Keep? ');
%     cla
% end
%plot(-100:500,nanmean(allwf.neuron.in_correct(find(keeper.catch.neuron),:)),'k',-100:500,nanmean(allwf.neuron.out_correct(find(keeper.catch.neuron),:)),'--k',-100:500,nanmean(allwf.neuron.catch.correct_in(find(keeper.catch.neuron),:)),'g',-100:500,nanmean(allwf.neuron.catch.errors_in(find(keeper.catch.neuron),:)),'r',-100:500,nanmean(allwf.neuron.catch.correct_nosacc(find(keeper.catch.neuron),:)),'b')





% CATCH TRIALS, LFP-HEMI (((RUN ON NON-TRUNCATED SIGNALS)))
%
% figure
% 
% for sess = 1:size(allwf.LFP.Hemi.catch.correct_nosacc,1)
%     plot(-500:2500,allwf.LFP.Hemi.in_correct(sess,:),'k',-500:2500,allwf.LFP.Hemi.out_correct(sess,:),'--k',-500:2500,allwf.LFP.Hemi.catch.correct_nosacc(sess,:),'g',-500:2500,allwf.LFP.Hemi.catch.errors_in(sess,:),'r',-500:2500,allwf.LFP.Hemi.catch.correct_in(sess,:),'b')
%     axis ij
%     xlim([-100 500])
%     keeper.catch.LFP(sess) = input('Keep? ');
%     title(mat2str(sess))
%     cla
% end
% 
% plot(-500:2500,nanmean(allwf.LFP.Hemi.in_correct(find(keeper.catch.LFP),:)),'k',-500:2500,nanmean(allwf.LFP.Hemi.out_correct(find(keeper.catch.LFP),:)),'--k',-500:2500,nanmean(allwf.LFP.Hemi.catch.correct_in(find(keeper.catch.LFP),:)),'b',-500:2500,nanmean(allwf.LFP.Hemi.catch.errors_in(find(keeper.catch.LFP),:)),'r',-500:2500,nanmean(allwf.LFP.Hemi.catch.correct_nosacc(find(keeper.catch.LFP),:)),'g')
% axis ij
% xlim([-100 500])





%CATCH TRIALS, OL (((RUN ON TRUNCATED SIGNALS)))
% figure
%
% for sess = 1:size(allwf.OL.catch.correct_nosacc,1)
%     plot(-500:2500,allwf.OL.in_correct(sess,:),'k',-500:2500,allwf.OL.out_correct(sess,:),'--k',-500:2500,allwf.OL.catch.correct_nosacc(sess,:),'g',-500:2500,allwf.OL.catch.errors_in(sess,:),'r',-500:2500,allwf.OL.catch.correct_in(sess,:),'b')
%     axis ij
%     xlim([-100 500])
%     keeper.catch.OL(sess) = input('Keep? ');
%     title(mat2str(sess))
%     cla
% end
%
% plot(-500:2500,nanmean(allwf.OL.in_correct(find(keeper.catch.OL),:)),'k',-500:2500,nanmean(allwf.OL.out_correct(find(keeper.catch.OL),:)),'--k',-500:2500,nanmean(allwf.OL.catch.correct_in(find(keeper.catch.OL),:)),'b',-500:2500,nanmean(allwf.OL.catch.errors_in(find(keeper.catch.OL),:)),'r',-500:2500,nanmean(allwf.OL.catch.correct_nosacc(find(keeper.catch.OL),:)),'g')
% axis ij
% xlim([-100 500])
%





%CATCH TRIALS, OR (((RUN ON TRUNCATED SIGNALS)))
figure

for sess = 1:size(allwf.OR.catch.correct_nosacc,1)
    plot(-500:2500,allwf.OR.in_correct(sess,:),'k',-500:2500,allwf.OR.out_correct(sess,:),'--k',-500:2500,allwf.OR.catch.correct_nosacc(sess,:),'g',-500:2500,allwf.OR.catch.errors_in(sess,:),'r',-500:2500,allwf.OR.catch.correct_in(sess,:),'b')
    axis ij
    xlim([-100 500])
    keeper.catch.OR(sess) = input('Keep? ');
    title(mat2str(sess))
    cla
end

plot(-500:2500,nanmean(allwf.OR.in_correct(find(keeper.catch.OR),:)),'k',-500:2500,nanmean(allwf.OR.out_correct(find(keeper.catch.OR),:)),'--k',-500:2500,nanmean(allwf.OR.catch.correct_in(find(keeper.catch.OR),:)),'b',-500:2500,nanmean(allwf.OR.catch.errors_in(find(keeper.catch.OR),:)),'r',-500:2500,nanmean(allwf.OR.catch.correct_nosacc(find(keeper.catch.OR),:)),'g')
axis ij
xlim([-100 500])

%======================================




%======================================
% TRIAL HISTORY


% NEURON (c_c & e_c)
% figure
% 
% for sess = 1:size(allwf.neuron.in_c_c)
%     plot(-100:500,allwf.neuron.in_c_c(sess,:),'k',-100:500,allwf.neuron.out_c_c(sess,:),'--k',-100:500,allwf.neuron.in_e_c(sess,:),'r',-100:500,allwf.neuron.out_e_c(sess,:),'--r')
%     keeper.history.neuron_c_c(sess) = input('Keep? ');
%     cla
% end
% plot(-100:500,nanmean(allwf.neuron.in_c_c(find(keeper.history.neuron_c_c),:)),'k',-100:500,nanmean(allwf.neuron.out_c_c(find(keeper.history.neuron_c_c),:)),'--k',-100:500,nanmean(allwf.neuron.in_e_c(find(keeper.history.neuron_c_c),:)),'r',-100:500,nanmean(allwf.neuron.out_e_c(find(keeper.history.neuron_c_c),:)),'--r')
% 




%TRIAL HISTORY NEURON (c_e & e_e)
% figure
% 
% for sess = 1:size(allwf.neuron.in_c_e)
%     plot(-100:500,allwf.neuron.in_c_e(sess,:),'k',-100:500,allwf.neuron.out_c_e(sess,:),'--k',-100:500,allwf.neuron.in_e_e(sess,:),'r',-100:500,allwf.neuron.out_e_e(sess,:),'--r')
%     keeper.history.neuron_e_e(sess) = input('Keep? ');
%     cla
% end
% plot(-100:500,nanmean(allwf.neuron.in_c_e(find(keeper.history.neuron_e_e),:)),'k',-100:500,nanmean(allwf.neuron.out_c_e(find(keeper.history.neuron_e_e),:)),'--k',-100:500,nanmean(allwf.neuron.in_e_e(find(keeper.history.neuron_e_e),:)),'r',-100:500,nanmean(allwf.neuron.out_e_e(find(keeper.history.neuron_e_e),:)),'--r')
% 
% 
% % 
% %%% PLOT ALL TRIAL HISTORY TOGETHER %%%
% plot(-100:500,nanmean(allwf.neuron.in_c_c(find(keeper.history.neuron_e_e),:)),'k',-100:500,nanmean(allwf.neuron.out_c_c(find(keeper.history.neuron_e_e),:)),'--k',-100:500,nanmean(allwf.neuron.in_e_c(find(keeper.history.neuron_e_e),:)),'b',-100:500,nanmean(allwf.neuron.out_e_c(find(keeper.history.neuron_e_e),:)),'--b',-100:500,nanmean(allwf.neuron.in_c_e(find(keeper.history.neuron_e_e),:)),'r',-100:500,nanmean(allwf.neuron.out_c_e(find(keeper.history.neuron_e_e),:)),'--r',-100:500,nanmean(allwf.neuron.in_e_e(find(keeper.history.neuron_e_e),:)),'g',-100:500,nanmean(allwf.neuron.out_e_e(find(keeper.history.neuron_e_e),:)),'--g')





% TRIAL HISTORY LFP (c_c & e_c)
% figure
% 
% for sess = 1:size(allwf.LFP.Hemi.in_c_c)
%     plot(-500:2500,allwf.LFP.Hemi.in_c_c(sess,:),'k',-500:2500,allwf.LFP.Hemi.out_c_c(sess,:),'--k',-500:2500,allwf.LFP.Hemi.in_e_c(sess,:),'r',-500:2500,allwf.LFP.Hemi.out_e_c(sess,:),'--r')
%      axis ij
%     xlim([-100 500])
%     keeper.history.LFP_c_c(sess) = input('Keep? ');
%    
%     cla
% end
% plot(-500:2500,nanmean(allwf.LFP.Hemi.in_c_c(find(keeper.history.LFP_c_c),:)),'k',-500:2500,nanmean(allwf.LFP.Hemi.out_c_c(find(keeper.history.LFP_c_c),:)),'--k',-500:2500,nanmean(allwf.LFP.Hemi.in_e_c(find(keeper.history.LFP_c_c),:)),'r',-500:2500,nanmean(allwf.LFP.Hemi.out_e_c(find(keeper.history.LFP_c_c),:)),'--r')
% axis ij
% xlim([-100 500])



%TRIAL HISTORY LFP (c_e & e_e)
% figure
% 
% for sess = 1:size(allwf.LFP.Hemi.in_c_e)
%     plot(-500:2500,allwf.LFP.Hemi.in_c_e(sess,:),'k',-500:2500,allwf.LFP.Hemi.out_c_e(sess,:),'--k',-500:2500,allwf.LFP.Hemi.in_e_e(sess,:),'r',-500:2500,allwf.LFP.Hemi.out_e_e(sess,:),'--r')
%     axis ij
%     xlim([-100 500])
%     keeper.history.LFP_e_e(sess) = input('Keep? ');
%     cla
% end
% 
% % 
% % % 
% % % %% PLOT ALL TRIAL HISTORY TOGETHER %%%
% plot(-500:2500,nanmean(allwf.LFP.Hemi.in_c_c(find(keeper.history.LFP_e_e),:)),'k',-500:2500,nanmean(allwf.LFP.Hemi.out_c_c(find(keeper.history.LFP_e_e),:)),'--k',-500:2500,nanmean(allwf.LFP.Hemi.in_e_c(find(keeper.history.LFP_e_e),:)),'b',-500:2500,nanmean(allwf.LFP.Hemi.out_e_c(find(keeper.history.LFP_e_e),:)),'--b',-500:2500,nanmean(allwf.LFP.Hemi.in_c_e(find(keeper.history.LFP_e_e),:)),'r',-500:2500,nanmean(allwf.LFP.Hemi.out_c_e(find(keeper.history.LFP_e_e),:)),'--r',-500:2500,nanmean(allwf.LFP.Hemi.in_e_e(find(keeper.history.LFP_e_e),:)),'g',-500:2500,nanmean(allwf.LFP.Hemi.out_e_e(find(keeper.history.LFP_e_e),:)),'--g')
% axis ij
% xlim([-100 500])





% TRIAL HISTORY OL (c_c & e_c)
% figure
%  
% for sess = 1:size(allwf.OL.in_c_c)
%     plot(-500:2500,allwf.OL.in_c_c(sess,:),'k',-500:2500,allwf.OL.out_c_c(sess,:),'--k',-500:2500,allwf.OL.in_e_c(sess,:),'r',-500:2500,allwf.OL.out_e_c(sess,:),'--r')
%      axis ij
%     xlim([-100 500])
%     keeper.history.OL_c_c(sess) = input('Keep? ');
%    
%     cla
% end
% plot(-500:2500,nanmean(allwf.OL.in_c_c(find(keeper.history.OL_c_c),:)),'k',-500:2500,nanmean(allwf.OL.out_c_c(find(keeper.history.OL_c_c),:)),'--k',-500:2500,nanmean(allwf.OL.in_e_c(find(keeper.history.OL_c_c),:)),'r',-500:2500,nanmean(allwf.OL.out_e_c(find(keeper.history.OL_c_c),:)),'--r')
% axis ij
% xlim([-100 500])
%  

 
 
 
 
 
%TRIAL HISTORY OL (c_e & e_e)
% figure
% 
% for sess = 1:size(allwf.OL.in_c_e)
%     plot(-500:2500,allwf.OL.in_c_e(sess,:),'k',-500:2500,allwf.OL.out_c_e(sess,:),'--k',-500:2500,allwf.OL.in_e_e(sess,:),'r',-500:2500,allwf.OL.out_e_e(sess,:),'--r')
%     axis ij
%     xlim([-100 500])
%     keeper.history.OL_e_e(sess) = input('Keep? ');
%     cla
% end
% 
% plot(-500:2500,nanmean(allwf.OL.in_c_e(find(keeper.history.OL_e_e),:)),'k',-500:2500,nanmean(allwf.OL.out_c_e(find(keeper.history.OL_e_e),:)),'--k',-500:2500,nanmean(allwf.OL.in_e_e(find(keeper.history.OL_e_e),:)),'r',-500:2500,nanmean(allwf.OL.out_e_e(find(keeper.history.OL_e_e),:)),'--r')
% axis ij
% xlim([-100 500])
%  
%  
% %
% % %%% PLOT ALL TRIAL HISTORY TOGETHER %%%
% plot(-500:2500,nanmean(allwf.OL.in_c_c(find(keeper.history.OL_e_e),:)),'k',-500:2500,nanmean(allwf.OL.out_c_c(find(keeper.history.OL_e_e),:)),'--k',-500:2500,nanmean(allwf.OL.in_e_c(find(keeper.history.OL_e_e),:)),'b',-500:2500,nanmean(allwf.OL.out_e_c(find(keeper.history.OL_e_e),:)),'--b',-500:2500,nanmean(allwf.OL.in_c_e(find(keeper.history.OL_e_e),:)),'r',-500:2500,nanmean(allwf.OL.out_c_e(find(keeper.history.OL_e_e),:)),'--r',-500:2500,nanmean(allwf.OL.in_e_e(find(keeper.history.OL_e_e),:)),'g',-500:2500,nanmean(allwf.OL.out_e_e(find(keeper.history.OL_e_e),:)),'--g')
% axis ij
% xlim([-100 500])
 




 
% TRIAL HISTORY OR (c_c & e_c)
% figure
%  
% for sess = 1:size(allwf.OR.in_c_c)
%     plot(-500:2500,allwf.OR.in_c_c(sess,:),'k',-500:2500,allwf.OR.out_c_c(sess,:),'--k',-500:2500,allwf.OR.in_e_c(sess,:),'r',-500:2500,allwf.OR.out_e_c(sess,:),'--r')
%      axis ij
%     xlim([-100 300])
%     keeper.history.OR_c_c(sess) = input('Keep? ');
%    
%     cla
% end
% plot(-500:2500,nanmean(allwf.OR.in_c_c(find(keeper.history.OR_c_c),:)),'k',-500:2500,nanmean(allwf.OR.out_c_c(find(keeper.history.OR_c_c),:)),'--k',-500:2500,nanmean(allwf.OR.in_e_c(find(keeper.history.OR_c_c),:)),'r',-500:2500,nanmean(allwf.OR.out_e_c(find(keeper.history.OR_c_c),:)),'--r')
% axis ij
% xlim([-100 300])
 
 
 
 
 
 
 
%TRIAL HISTORY OR (c_e & e_e)
% figure
% 
% for sess = 1:size(allwf.OR.in_c_e)
%     plot(-500:2500,allwf.OR.in_c_e(sess,:),'k',-500:2500,allwf.OR.out_c_e(sess,:),'--k',-500:2500,allwf.OR.in_e_e(sess,:),'r',-500:2500,allwf.OR.out_e_e(sess,:),'--r')
%     axis ij
%     xlim([-100 300])
%     keeper.history.OR_e_e(sess) = input('Keep? ');
%     cla
% end
% 
% plot(-500:2500,nanmean(allwf.OR.in_c_e(find(keeper.history.OR_e_e),:)),'k',-500:2500,nanmean(allwf.OR.out_c_e(find(keeper.history.OR_e_e),:)),'--k',-500:2500,nanmean(allwf.OR.in_e_e(find(keeper.history.OR_e_e),:)),'r',-500:2500,nanmean(allwf.OR.out_e_e(find(keeper.history.OR_e_e),:)),'--r')
% axis ij
% xlim([-100 300])
% %  
% %  
% % %
% % % %%% PLOT ALL TRIAL HISTORY TOGETHER %%%
% plot(-500:2500,nanmean(allwf.OR.in_c_c(find(keeper.history.OR_e_e),:)),'k',-500:2500,nanmean(allwf.OR.out_c_c(find(keeper.history.OR_e_e),:)),'--k',-500:2500,nanmean(allwf.OR.in_e_c(find(keeper.history.OR_e_e),:)),'b',-500:2500,nanmean(allwf.OR.out_e_c(find(keeper.history.OR_e_e),:)),'--b',-500:2500,nanmean(allwf.OR.in_c_e(find(keeper.history.OR_e_e),:)),'r',-500:2500,nanmean(allwf.OR.out_c_e(find(keeper.history.OR_e_e),:)),'--r',-500:2500,nanmean(allwf.OR.in_e_e(find(keeper.history.OR_e_e),:)),'g',-500:2500,nanmean(allwf.OR.out_e_e(find(keeper.history.OR_e_e),:)),'--g')
% axis ij
% xlim([-100 300])

%============================


