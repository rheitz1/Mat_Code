
function X2 = fitDDM_singleCond_calcX2(param,ntiles,trls,obs_freq)
% params.slow = param(1:7);
% 
% 
% slow_correct_made_dead = trls.slow_correct_made_dead;
% slow_errors_made_dead = trls.slow_errors_made_dead;
% 
% 
% N.slow = length(slow_correct_made_dead) + length(slow_errors_made_dead);
% 
% 
% 
% pred_freq.slow_correct_made_dead(1) = N.slow * CDFDif(ntiles.slow_correct_made_dead(1),1,params.slow);
% pred_freq.slow_correct_made_dead(2) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(2),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(1),1,params.slow));
% pred_freq.slow_correct_made_dead(3) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(3),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(2),1,params.slow));
% pred_freq.slow_correct_made_dead(4) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(4),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(3),1,params.slow));
% pred_freq.slow_correct_made_dead(5) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(5),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(4),1,params.slow));
% 
% %at infinity, equals marginal probability
% pred_freq.slow_correct_made_dead(6) = N.slow * (CDFDif(inf,1,params.slow));
% 
% pred_freq.slow_errors_made_dead(1) = N.slow * CDFDif(ntiles.slow_errors_made_dead(1),0,params.slow);
% pred_freq.slow_errors_made_dead(2) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(2),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(1),0,params.slow));
% pred_freq.slow_errors_made_dead(3) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(3),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(2),0,params.slow));
% pred_freq.slow_errors_made_dead(4) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(4),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(3),0,params.slow));
% pred_freq.slow_errors_made_dead(5) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(5),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(4),0,params.slow));
%  
% %at infinity, equals marginal probability
% pred_freq.slow_errors_made_dead(6) = N.slow * (CDFDif(inf,0,params.slow));
% 
% 
% 
% 
% all_obs = [obs_freq.slow_correct_made_dead' ; obs_freq.slow_errors_made_dead'];
% 
% all_pred = [pred_freq.slow_correct_made_dead' ; pred_freq.slow_errors_made_dead'];
% 
% X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) )
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
% plot([ntiles.slow_correct_made_dead ; inf],cumsum(obs_freq.slow_correct_made_dead)./N.slow,'ok')
% hold on
% plot([ntiles.slow_correct_made_dead ; inf],cumsum(pred_freq.slow_correct_made_dead)./N.slow,'-xk')
% plot([ntiles.slow_errors_made_dead ; inf],cumsum(obs_freq.slow_errors_made_dead)./N.slow,'or')
% plot([ntiles.slow_errors_made_dead ; inf],cumsum(pred_freq.slow_errors_made_dead)./N.slow,'-xr')
% xlim([0 1])
% ylim([0 1])
% 
% pause(.001)
% cla




params = param(1:7);
 
 
N = length(trls.correct) + length(trls.errors);
 
 
 
pred_freq.correct(1) = N * CDFDif(ntiles.correct(1),1,params);
pred_freq.correct(2) = N * (CDFDif(ntiles.correct(2),1,params) - CDFDif(ntiles.correct(1),1,params));
pred_freq.correct(3) = N * (CDFDif(ntiles.correct(3),1,params) - CDFDif(ntiles.correct(2),1,params));
pred_freq.correct(4) = N * (CDFDif(ntiles.correct(4),1,params) - CDFDif(ntiles.correct(3),1,params));
pred_freq.correct(5) = N * (CDFDif(ntiles.correct(5),1,params) - CDFDif(ntiles.correct(4),1,params));
 
%at infinity, equals marginal probability
pred_freq.correct(6) = N * (CDFDif(inf,1,params));
 
pred_freq.errors(1) = N * CDFDif(ntiles.errors(1),0,params);
pred_freq.errors(2) = N * (CDFDif(ntiles.errors(2),0,params) - CDFDif(ntiles.errors(1),0,params));
pred_freq.errors(3) = N * (CDFDif(ntiles.errors(3),0,params) - CDFDif(ntiles.errors(2),0,params));
pred_freq.errors(4) = N * (CDFDif(ntiles.errors(4),0,params) - CDFDif(ntiles.errors(3),0,params));
pred_freq.errors(5) = N * (CDFDif(ntiles.errors(5),0,params) - CDFDif(ntiles.errors(4),0,params));
 
%at infinity, equals marginal probability
pred_freq.errors(6) = N * (CDFDif(inf,0,params));
 
 
 
 
all_obs = [obs_freq.correct' ; obs_freq.errors'];
 
all_pred = [pred_freq.correct' ; pred_freq.errors'];
 
X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );
 
disp([param(1:7)']);
%disp(mat2str(param))
 
% defective_correct = length(trls.correct) / (length(trls.correct) + length(trls.errors));
% defective_errors = 1 - defective_correct;
 
% plot([ntiles.correct ; inf],cumsum(obs_freq.trls.correct)./length(trls.correct),'ok')
% hold on
% plot([ntiles.correct ; inf],cumsum(pred_freq.trls.correct)./length(trls.correct),'k')
% plot([ntiles.errors ; inf],cumsum(obs_freq.trls.errors)./length(trls.errors),'or')
% plot([ntiles.errors ; inf],cumsum(pred_freq.trls.errors)./length(trls.errors),'r')
% xlim([0 1])
% ylim([0 1])
% pause(.001)
% cla
 
plot([ntiles.correct ; inf],cumsum(obs_freq.correct)./N,'ok')
hold on
plot([ntiles.correct ; inf],cumsum(pred_freq.correct)./N,'-xk')
plot([ntiles.errors ; inf],cumsum(obs_freq.errors)./N,'or')
plot([ntiles.errors ; inf],cumsum(pred_freq.errors)./N,'-xr')
xlim([0 1])
ylim([0 1])
title(['X2 = ' mat2str(round(X2*100)/100)]) 

pause(.001)
cla


end