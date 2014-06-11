
function LL = fitDDM_SAT_calcLL_singlecond(param,srt,trls)
plotFlag = 1;

params = param(1:7);

f_correct = PDFDif(srt(trls.slow_correct_made_dead,1)',1,params)';
f_error = PDFDif(srt(trls.slow_errors_made_dead,1)',0,params)';

% f_correct = CDFDif(srt(trls.slow_correct_made_dead,1)',1,params)';
% f_error = CDFDif(srt(trls.slow_errors_made_dead,1)',0,params)';

% Likelihood = [F_correct ; F_error] .* (1-[f_correct ; f_error]);

Likelihood = [f_correct ; f_error];

%set lower bounds
Likelihood(find(Likelihood < 1e-5)) = 1e-5;

LL = -sum(log(Likelihood));


% % params.med = param(8:14);
% % params.fast = param(15:21);
% 
% slow_correct_made_dead = trls.slow_correct_made_dead;
% slow_errors_made_dead = trls.slow_errors_made_dead;
% % med_correct = trls.med_correct;
% % med_errors = trls.med_errors;
% % fast_correct_made_dead_withCleared = trls.fast_correct_made_dead_withCleared;
% % fast_errors_made_dead_withCleared = trls.fast_errors_made_dead_withCleared;
% 
% 
% all_trls = [slow_correct_made_dead ; slow_errors_made_dead];
% 
% srt_mat(1:length(all_trls),1:10) = NaN;
% 
% srt_mat(1:length(slow_correct_made_dead),1) = srt(slow_correct_made_dead);
% srt_mat(1:length(slow_correct_made_dead),2) = 1;
% srt_mat(1:length(slow_correct_made_dead),3:9) = repmat(params.slow,length(slow_correct_made_dead),1);
% Le = length(slow_correct_made_dead);
% 
% srt_mat(Le+1:Le+length(slow_errors_made_dead),1) = srt(slow_errors_made_dead);
% srt_mat(Le+1:Le+length(slow_errors_made_dead),2) = 0;
% srt_mat(Le+1:Le+length(slow_errors_made_dead),3:9) = repmat(params.slow,length(slow_errors_made_dead),1);
% Le = Le + length(slow_errors_made_dead);
% 
% % srt_mat(Le+1:Le+length(med_correct),1) = srt(med_correct);
% % srt_mat(Le+1:Le+length(med_correct),2) = 1;
% % srt_mat(Le+1:Le+length(med_correct),3:9) = repmat(params.med,length(med_correct),1);
% % Le = Le + length(med_correct);
% % 
% % srt_mat(Le+1:Le+length(med_errors),1) = srt(med_errors);
% % srt_mat(Le+1:Le+length(med_errors),2) = 0;
% % srt_mat(Le+1:Le+length(med_errors),3:9) = repmat(params.med,length(med_errors),1);
% % Le = Le + length(med_errors);
% % 
% % srt_mat(Le+1:Le+length(fast_correct_made_dead_withCleared),1) = srt(fast_correct_made_dead_withCleared);
% % srt_mat(Le+1:Le+length(fast_correct_made_dead_withCleared),2) = 1;
% % srt_mat(Le+1:Le+length(fast_correct_made_dead_withCleared),3:9) = repmat(params.med,length(fast_correct_made_dead_withCleared),1);
% % Le = Le + length(fast_correct_made_dead_withCleared);
% % 
% % srt_mat(Le+1:Le+length(fast_errors_made_dead_withCleared),1) = srt(fast_errors_made_dead_withCleared);
% % srt_mat(Le+1:Le+length(fast_errors_made_dead_withCleared),2) = 0;
% % srt_mat(Le+1:Le+length(fast_errors_made_dead_withCleared),3:9) = repmat(params.med,length(fast_errors_made_dead_withCleared),1);
% 
% 
% % tic
% % for t = 1:size(srt_mat,1)
% %     srt_mat(t,10) = PDFDif(srt_mat(t,1),srt_mat(t,2),srt_mat(t,3:9));
% % end
% % toc
% 
% if matlabpool('size') < 2
%     matlabpool(12)
% end
% 
% tic
% 
% parfor t = 1:size(srt_mat,1)
%     A(t,1) = PDFDif(srt_mat(t,1),srt_mat(t,2),srt_mat(t,3:9));
% end
% toc
% 
% srt_mat(:,10) = A;
% 
% srt_mat(find(srt_mat(:,10) < 1e-5),10) = 1e-5;
% LL = -sum(log(srt_mat(:,10)));
% 
% disp([param(1:7)'])
% %disp(mat2str(param))
% 
% % defective_correct = length(slow_correct_made_dead) / (length(slow_correct_made_dead) + length(slow_errors_made_dead));
% % defective_errors = 1 - defective_correct;
% 
% % plot([ntiles.slow_correct_made_dead ; inf],cumsum(obs_freq.slow_correct_made_dead)./length(slow_correct_made_dead),'ok')
% % hold on
% % plot([ntiles.slow_correct_made_dead ; inf],cumsum(pred_freq.slow_correct_made_dead)./length(slow_correct_made_dead),'k')
% % plot([ntiles.slow_errors_made_dead ; inf],cumsum(obs_freq.slow_errors_made_dead)./length(slow_errors_made_dead),'or')
% % plot([ntiles.slow_errors_made_dead ; inf],cumsum(pred_freq.slow_errors_made_dead)./length(slow_errors_made_dead),'r')
% % xlim([0 1])
% % ylim([0 1])
% % pause(.001)
% % cla
% 
% t = 0:.01:1;
% 
% parfor x = 1:length(t)
%     B(x) = CDFDif(t(x),1,params.slow);
%     C(x) = CDFDif(t(x),0,params.slow);
% %     D(x) = CDFDif(t(x),1,params.med);
% %     E(x) = CDFDif(t(x),0,params.med);
% %     F(x) = CDFDif(t(x),1,params.fast);
% %     G(x) = CDFDif(t(x),0,params.fast);
% end
% 
% winner.slow = B;
% loser.slow = C;
% % winner.med = D;
% % loser.med = E;
% % winner.fast = F;
% % loser.fast = G;
% 
% 
% CDF.slow = getDefectiveCDF(slow_correct_made_dead,slow_errors_made_dead,srt);
% % CDF.med = getDefectiveCDF(med_correct,med_errors,srt);
% % CDF.fast = getDefectiveCDF(fast_correct_made_dead_withCleared,fast_errors_made_dead_withCleared,srt);

t = 0:.01:1;
winner = CDFDif(t,1,params);
loser = CDFDif(t,0,params);

CDF = getDefectiveCDF(trls.slow_correct_made_dead,trls.slow_errors_made_dead,srt);

if plotFlag
    plot(CDF.correct(:,1),CDF.correct(:,2),'ok');
    hold on
    plot(CDF.err(:,1),CDF.err(:,2),'or')
    plot(0:.01:1,winner,'k')
    plot(0:.01:1,loser,'r')
    xlim([0 1])
    ylim([0 1])
    box off
    
    % [ax h] = suplabel(['LL = ' mat2str(LL)],'t');
    % set(h,'fontsize',12,'fontweight','bold')
    
    title(['LL = ' mat2str(LL)])
    pause(.001)
    cla
    
    
end