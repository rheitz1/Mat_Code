%======================================
% DIRECTION VARIABILITY

s2std_correct = rad2deg(allstd.ss2.correct(:));
s4std_correct = rad2deg(allstd.ss4.correct(:));
s8std_correct = rad2deg(allstd.ss8.correct(:));

s2std_errors = rad2deg(allstd.ss2.errors(:));
s4std_errors = rad2deg(allstd.ss4.errors(:));
s8std_errors = rad2deg(allstd.ss8.errors(:));

sem.s2correct = nanstd(s2std_correct) / sqrt(length(find(~isnan(s2std_correct))));
sem.s4correct = nanstd(s4std_correct) / sqrt(length(find(~isnan(s4std_correct))));
sem.s8correct = nanstd(s8std_correct) / sqrt(length(find(~isnan(s8std_correct))));

sem.s2errors = nanstd(s2std_errors) / sqrt(length(find(~isnan(s2std_errors))));
sem.s4errors = nanstd(s4std_errors) / sqrt(length(find(~isnan(s4std_errors))));
sem.s8errors = nanstd(s8std_errors) / sqrt(length(find(~isnan(s8std_errors))));


figure
errorbar([nanmean(s2std_correct) nanmean(s4std_correct) nanmean(s8std_correct); ...
    nanmean(s2std_errors) nanmean(s4std_errors) nanmean(s8std_errors)]',[sem.s2correct ...
    sem.s4correct sem.s8correct; sem.s2errors sem.s4errors sem.s8errors]','xr');
hold


bar(1:3,[nanmean(s2std_correct) nanmean(s4std_correct) nanmean(s8std_correct); ...
    nanmean(s2std_errors) nanmean(s4std_errors) nanmean(s8std_errors)]','group');


s2_s4.correct = [s2std_correct s4std_correct];
s2_s4.correct = removeNaN(s2_s4.correct);
[h p ci stats] = ttest(s2_s4.correct(:,1),s2_s4.correct(:,2))


s4_s8.correct = [s4std_correct s8std_correct];
s4_s8.correct = removeNaN(s4_s8.correct);
[h p ci stats] = ttest(s4_s8.correct(:,1),s4_s8.correct(:,2))


s2_s8.correct = [s2std_correct s8std_correct];
s2_s8.correct = removeNaN(s2_s8.correct);
[h p ci stats] = ttest(s2_s8.correct(:,1),s2_s8.correct(:,2))


s2_s4.errors = [s2std_correct s4std_correct];
s2_s4.errors = removeNaN(s2_s4.errors);
[h p ci stats] = ttest(s2_s4.errors(:,1),s2_s4.errors(:,2))


s4_s8.errors = [s4std_correct s8std_correct];
s4_s8.errors = removeNaN(s4_s8.errors);
[h p ci stats] = ttest(s4_s8.errors(:,1),s4_s8.errors(:,2))


s2_s8.errors = [s2std_correct s8std_correct];
s2_s8.errors = removeNaN(s2_s8.errors);
[h p ci stats] = ttest(s2_s8.errors(:,1),s2_s8.errors(:,2))




s2c_s2e = [s2std_correct s2std_errors];
s2c_s2e = removeNaN(s2c_s2e);
[h p ci stats] = ttest(s2c_s2e(:,1),s2c_s2e(:,2))

s4c_s4e = [s4std_correct s4std_errors];
s4c_s4e = removeNaN(s4c_s4e);
[h p ci stats] = ttest(s4c_s4e(:,1),s4c_s4e(:,2))

s8c_s8e = [s8std_correct s8std_errors];
s8c_s8e = removeNaN(s8c_s8e);
[h p ci stats] = ttest(s8c_s8e(:,1),s8c_s8e(:,2))








%================================
% ENDPOINT VARIABILITY

%create deviations in x and y dimension, in degrees
subt.ss2.X = nanmean(allpos.ss2.correct.degX,1);
subt.ss2.X = repmat(subt.ss2.X,[size(allpos.ss2.correct.degX,1),1,1]);
dev.ss2.X = allpos.ss2.correct.degX - subt.ss2.X;

dev.ss2.posX = dev.ss2.X;
dev.ss2.X = dev.ss2.X(:);

subt.ss2.Y = nanmean(allpos.ss2.correct.degY,1);
subt.ss2.Y = repmat(subt.ss2.Y,[size(allpos.ss2.correct.degY,1),1,1]);
dev.ss2.Y = allpos.ss2.correct.degY - subt.ss2.Y;
dev.ss2.posY = dev.ss2.Y;
dev.ss2.Y = dev.ss2.Y(:);

scat.ss2 = removeNaN([dev.ss2.X dev.ss2.Y]);

%remove large outliers
scat.ss2(find(abs(scat.ss2) > 4)) = NaN;

scatterhist(scat.ss2(:,1),scat.ss2(:,2));




subt.ss4.X = nanmean(allpos.ss4.correct.degX,1);
subt.ss4.X = repmat(subt.ss4.X,[size(allpos.ss4.correct.degX,1),1,1]);
dev.ss4.X = allpos.ss4.correct.degX - subt.ss4.X;
dev.ss4.posX = dev.ss4.X;
dev.ss4.X = dev.ss4.X(:);

subt.ss4.Y = nanmean(allpos.ss4.correct.degY,1);
subt.ss4.Y = repmat(subt.ss4.Y,[size(allpos.ss4.correct.degY,1),1,1]);
dev.ss4.Y = allpos.ss4.correct.degY - subt.ss4.Y;
dev.ss4.posY = dev.ss4.Y;
dev.ss4.Y = dev.ss4.Y(:);

%remove large outliers
scat.ss4 = removeNaN([dev.ss4.X dev.ss4.Y]);
scat.ss4(find(abs(scat.ss4) > 4)) = NaN;

figure
scatterhist(scat.ss4(:,1),scat.ss4(:,2))



subt.ss8.X = nanmean(allpos.ss8.correct.degX,1);
subt.ss8.X = repmat(subt.ss8.X,[size(allpos.ss8.correct.degX,1),1,1]);
dev.ss8.X = allpos.ss8.correct.degX - subt.ss8.X;
dev.ss8.posX = dev.ss8.X;
dev.ss8.X = dev.ss8.X(:);
 
subt.ss8.Y = nanmean(allpos.ss8.correct.degY,1);
subt.ss8.Y = repmat(subt.ss8.Y,[size(allpos.ss8.correct.degY,1),1,1]);
dev.ss8.Y = allpos.ss8.correct.degY - subt.ss8.Y;
dev.ss8.posY = dev.ss8.Y;
dev.ss8.Y = dev.ss8.Y(:);
 
%remove large outliers
scat.ss8 = removeNaN([dev.ss8.X dev.ss8.Y]);
scat.ss8(find(abs(scat.ss8) > 4)) = NaN;
 
figure
scatterhist(scat.ss8(:,1),scat.ss8(:,2))



%===================================
% SCATTER HISTS by SCREEN POSITION
s2x = nanmean(dev.ss2.posX,3);
s2y = nanmean(dev.ss2.posY,3);
s4x = nanmean(dev.ss4.posX,3);
s4y = nanmean(dev.ss4.posY,3);
s8x = nanmean(dev.ss8.posX,3);
s8y = nanmean(dev.ss8.posY,3);

 
figure
 
[h yoff] = scatterhist(s2x(:,1),s2y(:,1));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s2p0.pdf
 
 
[h yoff] = scatterhist(s2x(:,2),s2y(:,2));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s2p1.pdf
 
[h yoff] = scatterhist(s2x(:,3),s2y(:,3));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s2p2.pdf
 
[h yoff] = scatterhist(s2x(:,4),s2y(:,4));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s2p3.pdf
 
[h yoff] = scatterhist(s2x(:,5),s2y(:,5));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s2p4.pdf
 
[h yoff] = scatterhist(s2x(:,6),s2y(:,6));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s2p5.pdf
 
[h yoff] = scatterhist(s2x(:,7),s2y(:,7));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s2p6.pdf
 
[h yoff] = scatterhist(s2x(:,8),s2y(:,8));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s2p7.pdf
 
 
 
 
 
 
figure
 
[h yoff] = scatterhist(s4x(:,1),s4y(:,1));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s4p0.pdf
 
 
[h yoff] = scatterhist(s4x(:,2),s4y(:,2));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s4p1.pdf
 
[h yoff] = scatterhist(s4x(:,3),s4y(:,3));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s4p2.pdf
 
[h yoff] = scatterhist(s4x(:,4),s4y(:,4));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s4p3.pdf
 
[h yoff] = scatterhist(s4x(:,5),s4y(:,5));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s4p4.pdf
 
[h yoff] = scatterhist(s4x(:,6),s4y(:,6));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s4p5.pdf
 
[h yoff] = scatterhist(s4x(:,7),s4y(:,7));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s4p6.pdf
 
[h yoff] = scatterhist(s4x(:,8),s4y(:,8));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s4p7.pdf
 
 
 
 
 
figure
 
[h yoff] = scatterhist(s8x(:,1),s8y(:,1));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s8p0.pdf
 
 
[h yoff] = scatterhist(s8x(:,2),s8y(:,2));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s8p1.pdf
 
[h yoff] = scatterhist(s8x(:,3),s8y(:,3));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s8p2.pdf
 
[h yoff] = scatterhist(s8x(:,4),s8y(:,4));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s8p3.pdf
 
[h yoff] = scatterhist(s8x(:,5),s8y(:,5));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s8p4.pdf
 
[h yoff] = scatterhist(s8x(:,6),s8y(:,6));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s8p5.pdf
 
[h yoff] = scatterhist(s8x(:,7),s8y(:,7));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s8p6.pdf
 
[h yoff] = scatterhist(s8x(:,8),s8y(:,8));
set(h([1 2]),'xlim',[-1 1])
set(h(1),'ylim',[-1 1])
set(h(3),'ylim',[-1-yoff 1-yoff])
print -dpdf ~/desktop/endpointfigs/scats/S_s8p7.pdf
 

