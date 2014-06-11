
function X2 = fitDDM_SAT_calcX2_singlecond(param,ntiles,trls,obs_freq)
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




params.slow = param(1:7);
 
 
slow_correct_made_dead = trls.slow_correct_made_dead;
slow_errors_made_dead = trls.slow_errors_made_dead;
 
 
N.slow = length(slow_correct_made_dead) + length(slow_errors_made_dead);
 
 
 
pred_freq.slow_correct_made_dead(1) = N.slow * CDFDif(ntiles.slow_correct_made_dead(1),1,params.slow);
pred_freq.slow_correct_made_dead(2) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(2),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(1),1,params.slow));
pred_freq.slow_correct_made_dead(3) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(3),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(2),1,params.slow));
pred_freq.slow_correct_made_dead(4) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(4),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(3),1,params.slow));
pred_freq.slow_correct_made_dead(5) = N.slow * (CDFDif(ntiles.slow_correct_made_dead(5),1,params.slow) - CDFDif(ntiles.slow_correct_made_dead(4),1,params.slow));
 
%at infinity, equals marginal probability
pred_freq.slow_correct_made_dead(6) = N.slow * (CDFDif(inf,1,params.slow));
 
pred_freq.slow_errors_made_dead(1) = N.slow * CDFDif(ntiles.slow_errors_made_dead(1),0,params.slow);
pred_freq.slow_errors_made_dead(2) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(2),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(1),0,params.slow));
pred_freq.slow_errors_made_dead(3) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(3),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(2),0,params.slow));
pred_freq.slow_errors_made_dead(4) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(4),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(3),0,params.slow));
pred_freq.slow_errors_made_dead(5) = N.slow * (CDFDif(ntiles.slow_errors_made_dead(5),0,params.slow) - CDFDif(ntiles.slow_errors_made_dead(4),0,params.slow));
 
%at infinity, equals marginal probability
pred_freq.slow_errors_made_dead(6) = N.slow * (CDFDif(inf,0,params.slow));
 
 
 
 
all_obs = [obs_freq.slow_correct_made_dead' ; obs_freq.slow_errors_made_dead'];
 
all_pred = [pred_freq.slow_correct_made_dead' ; pred_freq.slow_errors_made_dead'];
 
X2 = sum( (all_obs - all_pred).^2 ./ (all_pred + .00001) );
 
disp([param(1:7)']);
%disp(mat2str(param))
 
% defective_correct = length(slow_correct_made_dead) / (length(slow_correct_made_dead) + length(slow_errors_made_dead));
% defective_errors = 1 - defective_correct;
 
% plot([ntiles.slow_correct_made_dead ; inf],cumsum(obs_freq.slow_correct_made_dead)./length(slow_correct_made_dead),'ok')
% hold on
% plot([ntiles.slow_correct_made_dead ; inf],cumsum(pred_freq.slow_correct_made_dead)./length(slow_correct_made_dead),'k')
% plot([ntiles.slow_errors_made_dead ; inf],cumsum(obs_freq.slow_errors_made_dead)./length(slow_errors_made_dead),'or')
% plot([ntiles.slow_errors_made_dead ; inf],cumsum(pred_freq.slow_errors_made_dead)./length(slow_errors_made_dead),'r')
% xlim([0 1])
% ylim([0 1])
% pause(.001)
% cla
 
plot([ntiles.slow_correct_made_dead ; inf],cumsum(obs_freq.slow_correct_made_dead)./N.slow,'ok')
hold on
plot([ntiles.slow_correct_made_dead ; inf],cumsum(pred_freq.slow_correct_made_dead)./N.slow,'-xk')
plot([ntiles.slow_errors_made_dead ; inf],cumsum(obs_freq.slow_errors_made_dead)./N.slow,'or')
plot([ntiles.slow_errors_made_dead ; inf],cumsum(pred_freq.slow_errors_made_dead)./N.slow,'-xr')
xlim([0 1])
ylim([0 1])
 
pause(.001)
cla


end