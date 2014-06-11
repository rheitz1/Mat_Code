basewin = [-200 -100];

dif.fast.ss2 = abs(Pcoh.in.fast.ss2) - abs(Pcoh.out.fast.ss2);
dif.fast.ss4 = abs(Pcoh.in.fast.ss4) - abs(Pcoh.out.fast.ss4);
dif.fast.ss8 = abs(Pcoh.in.fast.ss8) - abs(Pcoh.out.fast.ss8);

dif.slow.ss2 = abs(Pcoh.in.slow.ss2) - abs(Pcoh.out.slow.ss2);
dif.slow.ss4 = abs(Pcoh.in.slow.ss4) - abs(Pcoh.out.slow.ss4);
dif.slow.ss8 = abs(Pcoh.in.slow.ss8) - abs(Pcoh.out.slow.ss8);

dif.fast.ss2_bc = baseline_correct(dif.fast.ss2',[find(tout == basewin(1)) find(tout == basewin(2))])';
dif.fast.ss4_bc = baseline_correct(dif.fast.ss4',[find(tout == basewin(1)) find(tout == basewin(2))])';
dif.fast.ss8_bc = baseline_correct(dif.fast.ss8',[find(tout == basewin(1)) find(tout == basewin(2))])';

dif.slow.ss2_bc = baseline_correct(dif.slow.ss2',[find(tout == basewin(1)) find(tout == basewin(2))])';
dif.slow.ss4_bc = baseline_correct(dif.slow.ss4',[find(tout == basewin(1)) find(tout == basewin(2))])';
dif.slow.ss8_bc = baseline_correct(dif.slow.ss8',[find(tout == basewin(1)) find(tout == basewin(2))])';



gamma.fast.ss2 = dif.fast.ss2(:,find(f >= 35));
gamma.fast.ss4 = dif.fast.ss4(:,find(f >= 35));
gamma.fast.ss8 = dif.fast.ss8(:,find(f >= 35));


gamma.slow.ss2 = dif.slow.ss2(:,find(f >= 35));
gamma.slow.ss4 = dif.slow.ss4(:,find(f >= 35));
gamma.slow.ss8 = dif.slow.ss8(:,find(f >= 35));


low.fast.ss2 = dif.fast.ss2(:,find(f >= .01 & f <= 10));
low.fast.ss4 = dif.fast.ss4(:,find(f >= .01 & f <= 10));
low.fast.ss8 = dif.fast.ss8(:,find(f >= .01 & f <= 10));

low.slow.ss2 = dif.slow.ss2(:,find(f >= .01 & f <= 10));
low.slow.ss4 = dif.slow.ss4(:,find(f >= .01 & f <= 10));
low.slow.ss8 = dif.slow.ss8(:,find(f >= .01 & f <= 10));


gamma.fast.ss2_bc = dif.fast.ss2_bc(:,find(f >= 35));
gamma.fast.ss4_bc = dif.fast.ss4_bc(:,find(f >= 35));
gamma.fast.ss8_bc = dif.fast.ss8_bc(:,find(f >= 35));


gamma.slow.ss2_bc = dif.slow.ss2_bc(:,find(f >= 35));
gamma.slow.ss4_bc = dif.slow.ss4_bc(:,find(f >= 35));
gamma.slow.ss8_bc = dif.slow.ss8_bc(:,find(f >= 35));


low.fast.ss2_bc = dif.fast.ss2_bc(:,find(f >= .01 & f <= 10));
low.fast.ss4_bc = dif.fast.ss4_bc(:,find(f >= .01 & f <= 10));
low.fast.ss8_bc = dif.fast.ss8_bc(:,find(f >= .01 & f <= 10));

low.slow.ss2_bc = dif.slow.ss2_bc(:,find(f >= .01 & f <= 10));
low.slow.ss4_bc = dif.slow.ss4_bc(:,find(f >= .01 & f <= 10));
low.slow.ss8_bc = dif.slow.ss8_bc(:,find(f >= .01 & f <= 10));



%===========
% single-session sem using across freq bands as n (this is not really
% correct)

sem.gamma.fast.ss2 = nanstd(gamma.fast.ss2,1,2) / sqrt(size(gamma.fast.ss2,2));
sem.gamma.fast.ss4 = nanstd(gamma.fast.ss4,1,2) / sqrt(size(gamma.fast.ss4,2));
sem.gamma.fast.ss8 = nanstd(gamma.fast.ss8,1,2) / sqrt(size(gamma.fast.ss8,2));

sem.gamma.slow.ss2 = nanstd(gamma.slow.ss2,1,2) / sqrt(size(gamma.slow.ss2,2));
sem.gamma.slow.ss4 = nanstd(gamma.slow.ss4,1,2) / sqrt(size(gamma.slow.ss4,2));
sem.gamma.slow.ss8 = nanstd(gamma.slow.ss8,1,2) / sqrt(size(gamma.slow.ss8,2));

sem.low.fast.ss2 = nanstd(low.fast.ss2,1,2) / sqrt(size(low.fast.ss2,2));
sem.low.fast.ss4 = nanstd(low.fast.ss4,1,2) / sqrt(size(low.fast.ss4,2));
sem.low.fast.ss8 = nanstd(low.fast.ss8,1,2) / sqrt(size(low.fast.ss8,2));
 
sem.low.slow.ss2 = nanstd(low.slow.ss2,1,2) / sqrt(size(low.slow.ss2,2));
sem.low.slow.ss4 = nanstd(low.slow.ss4,1,2) / sqrt(size(low.slow.ss4,2));
sem.low.slow.ss8 = nanstd(low.slow.ss8,1,2) / sqrt(size(low.slow.ss8,2));



sempos.gamma.fast.ss2 = nanmean(gamma.fast.ss2,2) + sem.gamma.fast.ss2;
sempos.gamma.fast.ss4 = nanmean(gamma.fast.ss4,2) + sem.gamma.fast.ss4;
sempos.gamma.fast.ss8 = nanmean(gamma.fast.ss8,2) + sem.gamma.fast.ss8;

 
sempos.gamma.slow.ss2 = nanmean(gamma.slow.ss2,2) + sem.gamma.slow.ss2;
sempos.gamma.slow.ss4 = nanmean(gamma.slow.ss4,2) + sem.gamma.slow.ss4;
sempos.gamma.slow.ss8 = nanmean(gamma.slow.ss8,2) + sem.gamma.slow.ss8;

sempos.low.fast.ss2 = nanmean(low.fast.ss2,2) + sem.low.fast.ss2;
sempos.low.fast.ss4 = nanmean(low.fast.ss4,2) + sem.low.fast.ss4;
sempos.low.fast.ss8 = nanmean(low.fast.ss8,2) + sem.low.fast.ss8;
 
 
sempos.low.slow.ss2 = nanmean(low.slow.ss2,2) + sem.low.slow.ss2;
sempos.low.slow.ss4 = nanmean(low.slow.ss4,2) + sem.low.slow.ss4;
sempos.low.slow.ss8 = nanmean(low.slow.ss8,2) + sem.low.slow.ss8;

semneg.gamma.fast.ss2 = nanmean(gamma.fast.ss2,2) - sem.gamma.fast.ss2;
semneg.gamma.fast.ss4 = nanmean(gamma.fast.ss4,2) - sem.gamma.fast.ss4;
semneg.gamma.fast.ss8 = nanmean(gamma.fast.ss8,2) - sem.gamma.fast.ss8;
 
 
semneg.gamma.slow.ss2 = nanmean(gamma.slow.ss2,2) - sem.gamma.slow.ss2;
semneg.gamma.slow.ss4 = nanmean(gamma.slow.ss4,2) - sem.gamma.slow.ss4;
semneg.gamma.slow.ss8 = nanmean(gamma.slow.ss8,2) - sem.gamma.slow.ss8;
 
semneg.low.fast.ss2 = nanmean(low.fast.ss2,2) - sem.low.fast.ss2;
semneg.low.fast.ss4 = nanmean(low.fast.ss4,2) - sem.low.fast.ss4;
semneg.low.fast.ss8 = nanmean(low.fast.ss8,2) - sem.low.fast.ss8;
 
 
semneg.low.slow.ss2 = nanmean(low.slow.ss2,2) - sem.low.slow.ss2;
semneg.low.slow.ss4 = nanmean(low.slow.ss4,2) - sem.low.slow.ss4;
semneg.low.slow.ss8 = nanmean(low.slow.ss8,2) - sem.low.slow.ss8;



%============
% Figures with SEM
figure
plot(tout,nanmean(gamma.fast.ss2,2),'b',tout,nanmean(gamma.slow.ss2,2),'--b', ...
    tout,nanmean(gamma.fast.ss4,2),'r',tout,nanmean(gamma.slow.ss4,2),'--r', ...
    tout,nanmean(gamma.fast.ss8,2),'g',tout,nanmean(gamma.slow.ss8,2),'--g')
hold on

plot(tout,sempos.gamma.fast.ss2,'b',tout,sempos.gamma.slow.ss2,'--b', ...
    tout,sempos.gamma.fast.ss4,'r',tout,sempos.gamma.slow.ss4,'--r', ...
    tout,sempos.gamma.fast.ss8,'g',tout,sempos.gamma.slow.ss8,'--g')

plot(tout,semneg.gamma.fast.ss2,'b',tout,semneg.gamma.slow.ss2,'--b', ...
    tout,semneg.gamma.fast.ss4,'r',tout,semneg.gamma.slow.ss4,'--r', ...
    tout,semneg.gamma.fast.ss8,'g',tout,semneg.gamma.slow.ss8,'--g')

xlim([-50 500])
hline(0,'k')




figure
plot(tout,nanmean(low.fast.ss2,2),'b',tout,nanmean(low.slow.ss2,2),'--b', ...
    tout,nanmean(low.fast.ss4,2),'r',tout,nanmean(low.slow.ss4,2),'--r', ...
    tout,nanmean(low.fast.ss8,2),'g',tout,nanmean(low.slow.ss8,2),'--g')
hold on
 
plot(tout,sempos.low.fast.ss2,'b',tout,sempos.low.slow.ss2,'--b', ...
    tout,sempos.low.fast.ss4,'r',tout,sempos.low.slow.ss4,'--r', ...
    tout,sempos.low.fast.ss8,'g',tout,sempos.low.slow.ss8,'--g')
 
plot(tout,semneg.low.fast.ss2,'b',tout,semneg.low.slow.ss2,'--b', ...
    tout,semneg.low.fast.ss4,'r',tout,semneg.low.slow.ss4,'--r', ...
    tout,semneg.low.fast.ss8,'g',tout,semneg.low.slow.ss8,'--g')
 
xlim([-50 500])
hline(0,'k')


% 
% 
% %============
% % Figure w/o SEM
% 
% figure
% plot(tout,nanmean(gamma.fast.ss2,2),'b',tout,nanmean(gamma.slow.ss2,2),'--b', ...
%     tout,nanmean(gamma.fast.ss4,2),'r',tout,nanmean(gamma.slow.ss4,2),'--r', ...
%     tout,nanmean(gamma.fast.ss8,2),'g',tout,nanmean(gamma.slow.ss8,2),'--g')
% xlim([-200 500])
% title('No Baseline Correction Gamma')
% 
% % figure
% % plot(tout,nanmean(gamma.fast.ss2_bc,2),'b',tout,nanmean(gamma.slow.ss2_bc,2),'--b', ...
% %     tout,nanmean(gamma.fast.ss4_bc,2),'r',tout,nanmean(gamma.slow.ss4_bc,2),'--r', ...
% %     tout,nanmean(gamma.fast.ss8_bc,2),'g',tout,nanmean(gamma.slow.ss8_bc,2),'--g')
% % xlim([-200 500])
% % title('Baseline Corrected Gamma')
% 
% figure
% plot(tout,nanmean(low.fast.ss2,2),'b',tout,nanmean(low.slow.ss2,2),'--b', ...
%     tout,nanmean(low.fast.ss4,2),'r',tout,nanmean(low.slow.ss4,2),'--r', ...
%     tout,nanmean(low.fast.ss8,2),'g',tout,nanmean(low.slow.ss8,2),'--g')
% xlim([-200 500])
% title('No Baseline Correction low')
%  
% % figure
% % plot(tout,nanmean(low.fast.ss2_bc,2),'b',tout,nanmean(low.slow.ss2_bc,2),'--b', ...
% %     tout,nanmean(low.fast.ss4_bc,2),'r',tout,nanmean(low.slow.ss4_bc,2),'--r', ...
% %     tout,nanmean(low.fast.ss8_bc,2),'g',tout,nanmean(low.slow.ss8_bc,2),'--g')
% % xlim([-200 500])
% % title('Baseline Corrected low')
