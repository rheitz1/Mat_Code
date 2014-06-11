%For Pep EEG-only TL data:
% 1: make difference scores
% 2: normalize traces.  Because voltages go positive and negative, I will
% normalize by the average total voltage.
%
% Run 'grand_average_EEG.m' first.

cd /Volumes/Dump/Search_Data_EEG_Only/Averages/
load P_EEG_grandaverages_TL

keep *20 TDT bins cdf

%=======================================================================
% normalize non-difference scores by taking average power across targ on
% left and targ on right
AD01_max = nanmax(nanmax([AD01_left_all_Trunc20(:,500:900) ; AD01_right_all_Trunc20(:,500:900)]));
AD02_max = nanmax(nanmax([AD02_left_all_Trunc20(:,500:900) ; AD02_right_all_Trunc20(:,500:900)]));
AD03_max = nanmax(nanmax([AD03_left_all_Trunc20(:,500:900) ; AD03_right_all_Trunc20(:,500:900)]));
AD04_max = nanmax(nanmax([AD04_left_all_Trunc20(:,500:900) ; AD04_right_all_Trunc20(:,500:900)]));
AD05_max = nanmax(nanmax([AD05_left_all_Trunc20(:,500:900) ; AD05_right_all_Trunc20(:,500:900)]));
AD06_max = nanmax(nanmax([AD06_left_all_Trunc20(:,500:900) ; AD06_right_all_Trunc20(:,500:900)]));
AD07_max = nanmax(nanmax([AD07_left_all_Trunc20(:,500:900) ; AD07_right_all_Trunc20(:,500:900)]));

AD01_left_all_norm = AD01_left_all_Trunc20 ./ AD01_max;
AD02_left_all_norm = AD02_left_all_Trunc20 ./ AD02_max;
AD03_left_all_norm = AD03_left_all_Trunc20 ./ AD03_max;
AD04_left_all_norm = AD04_left_all_Trunc20 ./ AD04_max;
AD05_left_all_norm = AD05_left_all_Trunc20 ./ AD05_max;
AD06_left_all_norm = AD06_left_all_Trunc20 ./ AD06_max;
AD07_left_all_norm = AD07_left_all_Trunc20 ./ AD07_max;

AD01_right_all_norm = AD01_right_all_Trunc20 ./ AD01_max;
AD02_right_all_norm = AD02_right_all_Trunc20 ./ AD02_max;
AD03_right_all_norm = AD03_right_all_Trunc20 ./ AD03_max;
AD04_right_all_norm = AD04_right_all_Trunc20 ./ AD04_max;
AD05_right_all_norm = AD05_right_all_Trunc20 ./ AD05_max;
AD06_right_all_norm = AD06_right_all_Trunc20 ./ AD06_max;
AD07_right_all_norm = AD07_right_all_Trunc20 ./ AD07_max;


%normalize set size conditions using max value from all trials.
AD01_left_ss2_norm = AD01_left_ss2_Trunc20 ./ AD01_max;
AD02_left_ss2_norm = AD02_left_ss2_Trunc20 ./ AD02_max;
AD03_left_ss2_norm = AD03_left_ss2_Trunc20 ./ AD03_max;
AD04_left_ss2_norm = AD04_left_ss2_Trunc20 ./ AD04_max;
AD05_left_ss2_norm = AD05_left_ss2_Trunc20 ./ AD05_max;
AD06_left_ss2_norm = AD06_left_ss2_Trunc20 ./ AD06_max;
AD07_left_ss2_norm = AD07_left_ss2_Trunc20 ./ AD07_max;
 
AD01_right_ss2_norm = AD01_right_ss2_Trunc20 ./ AD01_max;
AD02_right_ss2_norm = AD02_right_ss2_Trunc20 ./ AD02_max;
AD03_right_ss2_norm = AD03_right_ss2_Trunc20 ./ AD03_max;
AD04_right_ss2_norm = AD04_right_ss2_Trunc20 ./ AD04_max;
AD05_right_ss2_norm = AD05_right_ss2_Trunc20 ./ AD05_max;
AD06_right_ss2_norm = AD06_right_ss2_Trunc20 ./ AD06_max;
AD07_right_ss2_norm = AD07_right_ss2_Trunc20 ./ AD07_max;

AD01_left_ss4_norm = AD01_left_ss4_Trunc20 ./ AD01_max;
AD02_left_ss4_norm = AD02_left_ss4_Trunc20 ./ AD02_max;
AD03_left_ss4_norm = AD03_left_ss4_Trunc20 ./ AD03_max;
AD04_left_ss4_norm = AD04_left_ss4_Trunc20 ./ AD04_max;
AD05_left_ss4_norm = AD05_left_ss4_Trunc20 ./ AD05_max;
AD06_left_ss4_norm = AD06_left_ss4_Trunc20 ./ AD06_max;
AD07_left_ss4_norm = AD07_left_ss4_Trunc20 ./ AD07_max;
 
AD01_right_ss4_norm = AD01_right_ss4_Trunc20 ./ AD01_max;
AD02_right_ss4_norm = AD02_right_ss4_Trunc20 ./ AD02_max;
AD03_right_ss4_norm = AD03_right_ss4_Trunc20 ./ AD03_max;
AD04_right_ss4_norm = AD04_right_ss4_Trunc20 ./ AD04_max;
AD05_right_ss4_norm = AD05_right_ss4_Trunc20 ./ AD05_max;
AD06_right_ss4_norm = AD06_right_ss4_Trunc20 ./ AD06_max;
AD07_right_ss4_norm = AD07_right_ss4_Trunc20 ./ AD07_max;

AD01_left_ss8_norm = AD01_left_ss8_Trunc20 ./ AD01_max;
AD02_left_ss8_norm = AD02_left_ss8_Trunc20 ./ AD02_max;
AD03_left_ss8_norm = AD03_left_ss8_Trunc20 ./ AD03_max;
AD04_left_ss8_norm = AD04_left_ss8_Trunc20 ./ AD04_max;
AD05_left_ss8_norm = AD05_left_ss8_Trunc20 ./ AD05_max;
AD06_left_ss8_norm = AD06_left_ss8_Trunc20 ./ AD06_max;
AD07_left_ss8_norm = AD07_left_ss8_Trunc20 ./ AD07_max;
 
AD01_right_ss8_norm = AD01_right_ss8_Trunc20 ./ AD01_max;
AD02_right_ss8_norm = AD02_right_ss8_Trunc20 ./ AD02_max;
AD03_right_ss8_norm = AD03_right_ss8_Trunc20 ./ AD03_max;
AD04_right_ss8_norm = AD04_right_ss8_Trunc20 ./ AD04_max;
AD05_right_ss8_norm = AD05_right_ss8_Trunc20 ./ AD05_max;
AD06_right_ss8_norm = AD06_right_ss8_Trunc20 ./ AD06_max;
AD07_right_ss8_norm = AD07_right_ss8_Trunc20 ./ AD07_max;

AD01_catch_norm = AD01_catch_Trunc20 ./AD01_max;
AD02_catch_norm = AD02_catch_Trunc20 ./AD02_max;
AD03_catch_norm = AD03_catch_Trunc20 ./AD03_max;
AD04_catch_norm = AD04_catch_Trunc20 ./AD04_max;
AD05_catch_norm = AD05_catch_Trunc20 ./AD05_max;
AD06_catch_norm = AD06_catch_Trunc20 ./AD06_max;
AD07_catch_norm = AD07_catch_Trunc20 ./AD07_max;

%==================================================



% Now make difference scores and normalize those independently
AD01_all_diff = AD01_left_all_Trunc20 - AD01_right_all_Trunc20;
AD02_all_diff = AD02_left_all_Trunc20 - AD02_right_all_Trunc20;
AD03_all_diff = AD03_left_all_Trunc20 - AD03_right_all_Trunc20;
AD04_all_diff = AD04_left_all_Trunc20 - AD04_right_all_Trunc20;
AD05_all_diff = AD05_left_all_Trunc20 - AD05_right_all_Trunc20;
AD06_all_diff = AD06_left_all_Trunc20 - AD06_right_all_Trunc20;
AD07_all_diff = AD07_left_all_Trunc20 - AD07_right_all_Trunc20;

AD01_all_diff_max = nanmax(AD01_all_diff(500:900));
AD02_all_diff_max = nanmax(AD02_all_diff(500:900));
AD03_all_diff_max = nanmax(AD03_all_diff(500:900));
AD04_all_diff_max = nanmax(AD04_all_diff(500:900));
AD05_all_diff_max = nanmax(AD05_all_diff(500:900));
AD06_all_diff_max = nanmax(AD06_all_diff(500:900));
AD07_all_diff_max = nanmax(AD07_all_diff(500:900));


AD01_all_diff_norm = AD01_all_diff ./ AD01_all_diff_max;
AD02_all_diff_norm = AD02_all_diff ./ AD02_all_diff_max;
AD03_all_diff_norm = AD03_all_diff ./ AD03_all_diff_max;
AD04_all_diff_norm = AD04_all_diff ./ AD04_all_diff_max;
AD05_all_diff_norm = AD05_all_diff ./ AD05_all_diff_max;
AD06_all_diff_norm = AD06_all_diff ./ AD06_all_diff_max;
AD07_all_diff_norm = AD07_all_diff ./ AD07_all_diff_max;



% ss2
AD01_ss2_diff = AD01_left_ss2_Trunc20 - AD01_right_ss2_Trunc20;
AD02_ss2_diff = AD02_left_ss2_Trunc20 - AD02_right_ss2_Trunc20;
AD03_ss2_diff = AD03_left_ss2_Trunc20 - AD03_right_ss2_Trunc20;
AD04_ss2_diff = AD04_left_ss2_Trunc20 - AD04_right_ss2_Trunc20;
AD05_ss2_diff = AD05_left_ss2_Trunc20 - AD05_right_ss2_Trunc20;
AD06_ss2_diff = AD06_left_ss2_Trunc20 - AD06_right_ss2_Trunc20;
AD07_ss2_diff = AD07_left_ss2_Trunc20 - AD07_right_ss2_Trunc20;
 
 
AD01_ss2_diff_norm = AD01_ss2_diff ./ AD01_all_diff_max;
AD02_ss2_diff_norm = AD02_ss2_diff ./ AD02_all_diff_max;
AD03_ss2_diff_norm = AD03_ss2_diff ./ AD03_all_diff_max;
AD04_ss2_diff_norm = AD04_ss2_diff ./ AD04_all_diff_max;
AD05_ss2_diff_norm = AD05_ss2_diff ./ AD05_all_diff_max;
AD06_ss2_diff_norm = AD06_ss2_diff ./ AD06_all_diff_max;
AD07_ss2_diff_norm = AD07_ss2_diff ./ AD07_all_diff_max;

AD01_ss4_diff = AD01_left_ss4_Trunc20 - AD01_right_ss4_Trunc20;
AD02_ss4_diff = AD02_left_ss4_Trunc20 - AD02_right_ss4_Trunc20;
AD03_ss4_diff = AD03_left_ss4_Trunc20 - AD03_right_ss4_Trunc20;
AD04_ss4_diff = AD04_left_ss4_Trunc20 - AD04_right_ss4_Trunc20;
AD05_ss4_diff = AD05_left_ss4_Trunc20 - AD05_right_ss4_Trunc20;
AD06_ss4_diff = AD06_left_ss4_Trunc20 - AD06_right_ss4_Trunc20;
AD07_ss4_diff = AD07_left_ss4_Trunc20 - AD07_right_ss4_Trunc20;
 
 
 
AD01_ss4_diff_norm = AD01_ss4_diff ./ AD01_all_diff_max;
AD02_ss4_diff_norm = AD02_ss4_diff ./ AD02_all_diff_max;
AD03_ss4_diff_norm = AD03_ss4_diff ./ AD03_all_diff_max;
AD04_ss4_diff_norm = AD04_ss4_diff ./ AD04_all_diff_max;
AD05_ss4_diff_norm = AD05_ss4_diff ./ AD05_all_diff_max;
AD06_ss4_diff_norm = AD06_ss4_diff ./ AD06_all_diff_max;
AD07_ss4_diff_norm = AD07_ss4_diff ./ AD07_all_diff_max;

AD01_ss8_diff = AD01_left_ss8_Trunc20 - AD01_right_ss8_Trunc20;
AD02_ss8_diff = AD02_left_ss8_Trunc20 - AD02_right_ss8_Trunc20;
AD03_ss8_diff = AD03_left_ss8_Trunc20 - AD03_right_ss8_Trunc20;
AD04_ss8_diff = AD04_left_ss8_Trunc20 - AD04_right_ss8_Trunc20;
AD05_ss8_diff = AD05_left_ss8_Trunc20 - AD05_right_ss8_Trunc20;
AD06_ss8_diff = AD06_left_ss8_Trunc20 - AD06_right_ss8_Trunc20;
AD07_ss8_diff = AD07_left_ss8_Trunc20 - AD07_right_ss8_Trunc20;
 

 
AD01_ss8_diff_norm = AD01_ss8_diff ./ AD01_all_diff_max;
AD02_ss8_diff_norm = AD02_ss8_diff ./ AD02_all_diff_max;
AD03_ss8_diff_norm = AD03_ss8_diff ./ AD03_all_diff_max;
AD04_ss8_diff_norm = AD04_ss8_diff ./ AD04_all_diff_max;
AD05_ss8_diff_norm = AD05_ss8_diff ./ AD05_all_diff_max;
AD06_ss8_diff_norm = AD06_ss8_diff ./ AD06_all_diff_max;
AD07_ss8_diff_norm = AD07_ss8_diff ./ AD07_all_diff_max;




% Now take difference scores Right - catch & left - catch
AD01_right_catch_diff = AD01_right_all_Trunc20 - AD01_catch_Trunc20;
AD02_right_catch_diff = AD02_right_all_Trunc20 - AD02_catch_Trunc20;
AD03_right_catch_diff = AD03_right_all_Trunc20 - AD03_catch_Trunc20;
AD04_right_catch_diff = AD04_right_all_Trunc20 - AD04_catch_Trunc20;
AD05_right_catch_diff = AD05_right_all_Trunc20 - AD05_catch_Trunc20;
AD06_right_catch_diff = AD06_right_all_Trunc20 - AD06_catch_Trunc20;
AD07_right_catch_diff = AD07_right_all_Trunc20 - AD07_catch_Trunc20;

AD01_left_catch_diff = AD01_left_all_Trunc20 - AD01_catch_Trunc20;
AD02_left_catch_diff = AD02_left_all_Trunc20 - AD02_catch_Trunc20;
AD03_left_catch_diff = AD03_left_all_Trunc20 - AD03_catch_Trunc20;
AD04_left_catch_diff = AD04_left_all_Trunc20 - AD04_catch_Trunc20;
AD05_left_catch_diff = AD05_left_all_Trunc20 - AD05_catch_Trunc20;
AD06_left_catch_diff = AD06_left_all_Trunc20 - AD06_catch_Trunc20;
AD07_left_catch_diff = AD07_left_all_Trunc20 - AD07_catch_Trunc20;

%normalize to ALL trials

AD01_right_catch_diff_norm = AD01_right_catch_diff ./ AD01_all_diff_max;
AD02_right_catch_diff_norm = AD02_right_catch_diff ./ AD02_all_diff_max;
AD03_right_catch_diff_norm = AD03_right_catch_diff ./ AD03_all_diff_max;
AD04_right_catch_diff_norm = AD04_right_catch_diff ./ AD04_all_diff_max;
AD05_right_catch_diff_norm = AD05_right_catch_diff ./ AD05_all_diff_max;
AD06_right_catch_diff_norm = AD06_right_catch_diff ./ AD06_all_diff_max;
AD07_right_catch_diff_norm = AD07_right_catch_diff ./ AD07_all_diff_max;

AD01_left_catch_diff_norm = AD01_left_catch_diff ./ AD01_all_diff_max;
AD02_left_catch_diff_norm = AD02_left_catch_diff ./ AD02_all_diff_max;
AD03_left_catch_diff_norm = AD03_left_catch_diff ./ AD03_all_diff_max;
AD04_left_catch_diff_norm = AD04_left_catch_diff ./ AD04_all_diff_max;
AD05_left_catch_diff_norm = AD05_left_catch_diff ./ AD05_all_diff_max;
AD06_left_catch_diff_norm = AD06_left_catch_diff ./ AD06_all_diff_max;
AD07_left_catch_diff_norm = AD07_left_catch_diff ./ AD07_all_diff_max;

%===================================================


figure

subplot(3,3,1)
plot(-500:2500,AD07_all_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD07,'k')
title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])


subplot(3,3,3)
plot(-500:2500,AD06_all_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD06,'k')
title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])

subplot(3,3,4)
plot(-500:2500,AD05_all_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD05,'k')
title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])

subplot(3,3,6)
plot(-500:2500,AD04_all_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD04,'k')
title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])

subplot(3,3,7)
plot(-500:2500,AD03_all_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD03,'k')
title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])

subplot(3,3,8)
plot(-500:2500,AD01_all_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD01,'k')
title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])

subplot(3,3,9)
plot(-500:2500,AD02_all_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD02,'k')
title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])


[ax h] = suplabel('Voltages are LEFT - RIGHT normalized to max Voltage 0:400 ms ALL TRIALS','t');
set(h,'fontsize',12,'fontweight','bold')


%====
% SS2
figure
 
subplot(3,3,1)
plot(-500:2500,AD07_ss2_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD07,'k')
title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
subplot(3,3,3)
plot(-500:2500,AD06_ss2_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD06,'k')
title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,4)
plot(-500:2500,AD05_ss2_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD05,'k')
title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,6)
plot(-500:2500,AD04_ss2_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD04,'k')
title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,7)
plot(-500:2500,AD03_ss2_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD03,'k')
title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,8)
plot(-500:2500,AD01_ss2_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD01,'k')
title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,9)
plot(-500:2500,AD02_ss2_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD02,'k')
title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
[ax h] = suplabel('Voltages are LEFT - RIGHT normalized to max Voltage 0:400 ms ss2 TRIALS','t');
set(h,'fontsize',12,'fontweight','bold')


%=====
% SS4
figure
 
subplot(3,3,1)
plot(-500:2500,AD07_ss4_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD07,'k')
title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
subplot(3,3,3)
plot(-500:2500,AD06_ss4_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD06,'k')
title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,4)
plot(-500:2500,AD05_ss4_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD05,'k')
title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,6)
plot(-500:2500,AD04_ss4_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD04,'k')
title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,7)
plot(-500:2500,AD03_ss4_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD03,'k')
title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,8)
plot(-500:2500,AD01_ss4_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD01,'k')
title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,9)
plot(-500:2500,AD02_ss4_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD02,'k')
title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
[ax h] = suplabel('Voltages are LEFT - RIGHT normalized to max Voltage 0:400 ms ss4 TRIALS','t');
set(h,'fontsize',12,'fontweight','bold')


%=====
% ss8
figure
 
subplot(3,3,1)
plot(-500:2500,AD07_ss8_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD07,'k')
title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
subplot(3,3,3)
plot(-500:2500,AD06_ss8_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD06,'k')
title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,4)
plot(-500:2500,AD05_ss8_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD05,'k')
title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,6)
plot(-500:2500,AD04_ss8_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD04,'k')
title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,7)
plot(-500:2500,AD03_ss8_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD03,'k')
title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,8)
plot(-500:2500,AD01_ss8_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD01,'k')
title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,9)
plot(-500:2500,AD02_ss8_diff_norm)
axis ij
xlim([-50 300])
vline(TDT.AD02,'k')
title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
[ax h] = suplabel('Voltages are LEFT - RIGHT normalized to max Voltage 0:400 ms ss8 TRIALS','t');
set(h,'fontsize',12,'fontweight','bold')





%==========================================
% PLOT NON-DIFFERENCE SCORE, NORMALIZED

figure


 
subplot(3,3,1)
plot(-500:2500,AD07_left_all_norm,'k',-500:2500,AD07_right_all_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD07,'k')
title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
subplot(3,3,3)
plot(-500:2500,AD06_left_all_norm,'k',-500:2500,AD06_right_all_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD06,'k')
title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,4)
plot(-500:2500,AD05_left_all_norm,'k',-500:2500,AD05_right_all_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD05,'k')
title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,6)
plot(-500:2500,AD04_left_all_norm,'k',-500:2500,AD04_right_all_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD04,'k')
title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,7)
plot(-500:2500,AD03_left_all_norm,'k',-500:2500,AD03_right_all_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD03,'k')
title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,8)
plot(-500:2500,AD01_left_all_norm,'k',-500:2500,AD01_right_all_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD01,'k')
title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,9)
plot(-500:2500,AD02_left_all_norm,'k',-500:2500,AD02_right_all_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD02,'k')
title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
[ax h] = suplabel('RED = Target on right normalized to max difference 0:400 ms ALL trials','t');
set(h,'fontsize',12,'fontweight','bold')


%====
% ss2
figure
 
 
 
subplot(3,3,1)
plot(-500:2500,AD07_left_ss2_norm,'k',-500:2500,AD07_right_ss2_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD07,'k')
title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
subplot(3,3,3)
plot(-500:2500,AD06_left_ss2_norm,'k',-500:2500,AD06_right_ss2_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD06,'k')
title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,4)
plot(-500:2500,AD05_left_ss2_norm,'k',-500:2500,AD05_right_ss2_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD05,'k')
title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,6)
plot(-500:2500,AD04_left_ss2_norm,'k',-500:2500,AD04_right_ss2_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD04,'k')
title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,7)
plot(-500:2500,AD03_left_ss2_norm,'k',-500:2500,AD03_right_ss2_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD03,'k')
title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,8)
plot(-500:2500,AD01_left_ss2_norm,'k',-500:2500,AD01_right_ss2_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD01,'k')
title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,9)
plot(-500:2500,AD02_left_ss2_norm,'k',-500:2500,AD02_right_ss2_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD02,'k')
title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
[ax h] = suplabel('RED = Target on right normalized to max difference 0:400 ms ss2 trials','t');
set(h,'fontsize',12,'fontweight','bold')


%====
% ss4 
figure
 
 
 
subplot(3,3,1)
plot(-500:2500,AD07_left_ss4_norm,'k',-500:2500,AD07_right_ss4_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD07,'k')
title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
subplot(3,3,3)
plot(-500:2500,AD06_left_ss4_norm,'k',-500:2500,AD06_right_ss4_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD06,'k')
title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,4)
plot(-500:2500,AD05_left_ss4_norm,'k',-500:2500,AD05_right_ss4_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD05,'k')
title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,6)
plot(-500:2500,AD04_left_ss4_norm,'k',-500:2500,AD04_right_ss4_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD04,'k')
title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,7)
plot(-500:2500,AD03_left_ss4_norm,'k',-500:2500,AD03_right_ss4_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD03,'k')
title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,8)
plot(-500:2500,AD01_left_ss4_norm,'k',-500:2500,AD01_right_ss4_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD01,'k')
title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,9)
plot(-500:2500,AD02_left_ss4_norm,'k',-500:2500,AD02_right_ss4_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD02,'k')
title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
[ax h] = suplabel('RED = Target on right normalized to max difference 0:400 ms ss4 trials','t');
set(h,'fontsize',12,'fontweight','bold')


%===
% ss8
figure
 
 
 
subplot(3,3,1)
plot(-500:2500,AD07_left_ss8_norm,'k',-500:2500,AD07_right_ss8_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD07,'k')
title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
subplot(3,3,3)
plot(-500:2500,AD06_left_ss8_norm,'k',-500:2500,AD06_right_ss8_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD06,'k')
title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,4)
plot(-500:2500,AD05_left_ss8_norm,'k',-500:2500,AD05_right_ss8_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD05,'k')
title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,6)
plot(-500:2500,AD04_left_ss8_norm,'k',-500:2500,AD04_right_ss8_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD04,'k')
title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,7)
plot(-500:2500,AD03_left_ss8_norm,'k',-500:2500,AD03_right_ss8_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD03,'k')
title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,8)
plot(-500:2500,AD01_left_ss8_norm,'k',-500:2500,AD01_right_ss8_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD01,'k')
title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,9)
plot(-500:2500,AD02_left_ss8_norm,'k',-500:2500,AD02_right_ss8_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD02,'k')
title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
[ax h] = suplabel('RED = Target on right normalized to max difference 0:400 ms ss8 trials','t');
set(h,'fontsize',12,'fontweight','bold')




%=======
% Plot catch trial differences
figure
 
 
 
subplot(3,3,1)
plot(-500:2500,AD07_left_catch_diff_norm,'k',-500:2500,AD07_right_catch_diff_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD07,'k')
title(['AD07 / F3 TDT = ' mat2str(TDT.AD07)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
subplot(3,3,3)
plot(-500:2500,AD06_left_catch_diff_norm,'k',-500:2500,AD06_right_catch_diff_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD06,'k')
title(['AD06 / F4 TDT = ' mat2str(TDT.AD06)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,4)
plot(-500:2500,AD05_left_catch_diff_norm,'k',-500:2500,AD05_right_catch_diff_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD05,'k')
title(['AD05 / C3 TDT = ' mat2str(TDT.AD05)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,6)
plot(-500:2500,AD04_left_catch_diff_norm,'k',-500:2500,AD04_right_catch_diff_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD04,'k')
title(['AD04 / C4 TDT = ' mat2str(TDT.AD04)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,7)
plot(-500:2500,AD03_left_catch_diff_norm,'k',-500:2500,AD03_right_catch_diff_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD03,'k')
title(['AD03 / OL TDT = ' mat2str(TDT.AD03)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,8)
plot(-500:2500,AD01_left_catch_diff_norm,'k',-500:2500,AD01_right_catch_diff_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD01,'k')
title(['AD01 / Oz TDT = ' mat2str(TDT.AD01)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
subplot(3,3,9)
plot(-500:2500,AD02_left_catch_diff_norm,'k',-500:2500,AD02_right_catch_diff_norm,'r')
axis ij
xlim([-50 300])
vline(TDT.AD02,'k')
title(['AD02 / OR TDT = ' mat2str(TDT.AD02)])
newax
plot(bins,cdf)
xlim([-50 300])
ylim([0 1])
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
 
 
[ax h] = suplabel('RED = Target on right - catch normalized to max difference 0:400 ms ALL trials','t');
set(h,'fontsize',12,'fontweight','bold')


%=============================

% clear extraneous variables

keep *norm bins cdf TDT 
