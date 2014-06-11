s2stdX.correct = squeeze(nanstd(allpos.ss2.correct.degX,0,1))';
s4stdX.correct = squeeze(nanstd(allpos.ss4.correct.degX,0,1))';
s8stdX.correct = squeeze(nanstd(allpos.ss8.correct.degX,0,1))';

s2stdY.correct = squeeze(nanstd(allpos.ss2.correct.degY,0,1))';
s4stdY.correct = squeeze(nanstd(allpos.ss4.correct.degY,0,1))';
s8stdY.correct = squeeze(nanstd(allpos.ss8.correct.degY,0,1))';

s2stdX.errors = squeeze(nanstd(allpos.ss2.errors.degX,0,1))';
s4stdX.errors = squeeze(nanstd(allpos.ss4.errors.degX,0,1))';
s8stdX.errors = squeeze(nanstd(allpos.ss8.errors.degX,0,1))';
 
s2stdY.errors = squeeze(nanstd(allpos.ss2.errors.degY,0,1))';
s4stdY.errors = squeeze(nanstd(allpos.ss4.errors.degY,0,1))';
s8stdY.errors = squeeze(nanstd(allpos.ss8.errors.degY,0,1))';


%Cardinal positions only
ss2_updown.correct.x = [s2stdX.correct(:,3); s2stdX.correct(:,7)];
ss4_updown.correct.x = [s4stdX.correct(:,3); s4stdX.correct(:,7)];
ss8_updown.correct.x = [s8stdX.correct(:,3); s8stdX.correct(:,7)];

ss2_updown.correct.y = [s2stdY.correct(:,3); s2stdY.correct(:,7)];
ss4_updown.correct.y = [s4stdY.correct(:,3); s4stdY.correct(:,7)];
ss8_updown.correct.y = [s8stdY.correct(:,3); s8stdY.correct(:,7)];


ss2_leftright.correct.x = [s2stdX.correct(:,1); s2stdX.correct(:,5)];
ss4_leftright.correct.x = [s4stdX.correct(:,1); s4stdX.correct(:,5)];
ss8_leftright.correct.x = [s8stdX.correct(:,1); s8stdX.correct(:,5)];
 
ss2_leftright.correct.y = [s2stdY.correct(:,1); s2stdY.correct(:,5)];
ss4_leftright.correct.y = [s4stdY.correct(:,1); s4stdY.correct(:,5)];
ss8_leftright.correct.y = [s8stdY.correct(:,1); s8stdY.correct(:,5)];


ss2_updown.errors.x = [s2stdX.errors(:,3); s2stdX.errors(:,7)];
ss4_updown.errors.x = [s4stdX.errors(:,3); s4stdX.errors(:,7)];
ss8_updown.errors.x = [s8stdX.errors(:,3); s8stdX.errors(:,7)];
 
ss2_updown.errors.y = [s2stdY.errors(:,3); s2stdY.errors(:,7)];
ss4_updown.errors.y = [s4stdY.errors(:,3); s4stdY.errors(:,7)];
ss8_updown.errors.y = [s8stdY.errors(:,3); s8stdY.errors(:,7)];
 
 
ss2_leftright.errors.x = [s2stdX.errors(:,1); s2stdX.errors(:,5)];
ss4_leftright.errors.x = [s4stdX.errors(:,1); s4stdX.errors(:,5)];
ss8_leftright.errors.x = [s8stdX.errors(:,1); s8stdX.errors(:,5)];
 
ss2_leftright.errors.y = [s2stdY.errors(:,1); s2stdY.errors(:,5)];
ss4_leftright.errors.y = [s4stdY.errors(:,1); s4stdY.errors(:,5)];
ss8_leftright.errors.y = [s8stdY.errors(:,1); s8stdY.errors(:,5)];


%%%%%%%%%%%%%%%%%%%%
%==================
% CORRECT

%========================
% UP/DOWN DIMENSION

%2 vs 4, X
temp = [ss2_updown.correct.x ss4_updown.correct.x];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))

%2 vs 4, Y
temp = [ss2_updown.correct.y ss4_updown.correct.y];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))


%4 vs 8, X
temp = [ss4_updown.correct.x ss8_updown.correct.x];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))

%4 vs 8, Y
temp = [ss4_updown.correct.y ss8_updown.correct.y];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))


%=========================
% LEFT/RIGHT DIMENSION
%2 vs 4, X
temp = [ss2_leftright.correct.x ss4_leftright.correct.x];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
%2 vs 4, Y
temp = [ss2_leftright.correct.y ss4_leftright.correct.y];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
 
%4 vs 8, X
temp = [ss4_leftright.correct.x ss8_leftright.correct.x];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
%4 vs 8, Y
temp = [ss4_leftright.correct.y ss8_leftright.correct.y];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))





%%%%%%%%%%%%%%%%%%%%
%==================
% ERRORS

%========================
% UP/DOWN DIMENSION
%2 vs 4, X
temp = [ss2_updown.errors.x ss4_updown.errors.x];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
%2 vs 4, Y
temp = [ss2_updown.errors.y ss4_updown.errors.y];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
 
%4 vs 8, X
temp = [ss4_updown.errors.x ss8_updown.errors.x];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
%4 vs 8, Y
temp = [ss4_updown.errors.y ss8_updown.errors.y];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
 
%=========================
% LEFT/RIGHT DIMENSION
%2 vs 4, X
temp = [ss2_leftright.errors.x ss4_leftright.errors.x];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
%2 vs 4, Y
temp = [ss2_leftright.errors.y ss4_leftright.errors.y];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
 
%4 vs 8, X
temp = [ss4_leftright.errors.x ss8_leftright.errors.x];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))
 
%4 vs 8, Y
temp = [ss4_leftright.errors.y ss8_leftright.errors.y];
temp = removeNaN(temp);
[h p ci stats] = ttest(temp(:,1),temp(:,2))






%==========
% FOR PLOTTING
% s2meanX.correct = squeeze(nanmean(allpos.ss2.correct.degX,1))';
% s4meanX.correct = squeeze(nanmean(allpos.ss4.correct.degX,1))';
% s8meanX.correct = squeeze(nanmean(allpos.ss8.correct.degX,1))';
%  
% s2meanY.correct = squeeze(nanmean(allpos.ss2.correct.degY,1))';
% s4meanY.correct = squeeze(nanmean(allpos.ss4.correct.degY,1))';
% s8meanY.correct = squeeze(nanmean(allpos.ss8.correct.degY,1))';
%  
% s2meanX.errors = squeeze(nanmean(allpos.ss2.errors.degX,1))';
% s4meanX.errors = squeeze(nanmean(allpos.ss4.errors.degX,1))';
% s8meanX.errors = squeeze(nanmean(allpos.ss8.errors.degX,1))';
%  
% s2meanY.errors = squeeze(nanmean(allpos.ss2.errors.degY,1))';
% s4meanY.errors = squeeze(nanmean(allpos.ss4.errors.degY,1))';
% s8meanY.errors = squeeze(nanmean(allpos.ss8.errors.degY,1))';
% 
% ss2mean_updown.correct.x = [s2meanX.correct(:,3) ; s2meanX.correct(:,7)];
% ss2mean_updown.correct.y = [s2meanY.correct(:,3) ; s2meanY.correct(:,7)];
sem.ss2.leftright.correct.x = nanstd(ss2_leftright.correct.x) / sqrt(length(find(~isnan(ss2_leftright.correct.x))));
sem.ss4.leftright.correct.x = nanstd(ss4_leftright.correct.x) / sqrt(length(find(~isnan(ss4_leftright.correct.x))));
sem.ss8.leftright.correct.x = nanstd(ss8_leftright.correct.x) / sqrt(length(find(~isnan(ss8_leftright.correct.x))));
sem.ss2.leftright.correct.y = nanstd(ss2_leftright.correct.y) / sqrt(length(find(~isnan(ss2_leftright.correct.y))));
sem.ss4.leftright.correct.y = nanstd(ss4_leftright.correct.y) / sqrt(length(find(~isnan(ss4_leftright.correct.y))));
sem.ss8.leftright.correct.y = nanstd(ss8_leftright.correct.y) / sqrt(length(find(~isnan(ss8_leftright.correct.y))));
sem.ss2.leftright.errors.x = nanstd(ss2_leftright.errors.x) / sqrt(length(find(~isnan(ss2_leftright.errors.x))));
sem.ss4.leftright.errors.x = nanstd(ss4_leftright.errors.x) / sqrt(length(find(~isnan(ss4_leftright.errors.x))));
sem.ss8.leftright.errors.x = nanstd(ss8_leftright.errors.x) / sqrt(length(find(~isnan(ss8_leftright.errors.x))));
sem.ss2.leftright.errors.y = nanstd(ss2_leftright.errors.y) / sqrt(length(find(~isnan(ss2_leftright.errors.y))));
sem.ss4.leftright.errors.y = nanstd(ss4_leftright.errors.y) / sqrt(length(find(~isnan(ss4_leftright.errors.y))));
sem.ss8.leftright.errors.y = nanstd(ss8_leftright.errors.y) / sqrt(length(find(~isnan(ss8_leftright.errors.y))));
sem.ss2.updown.correct.x = nanstd(ss2_updown.correct.x) / sqrt(length(find(~isnan(ss2_updown.correct.x))));
sem.ss4.updown.correct.x = nanstd(ss4_updown.correct.x) / sqrt(length(find(~isnan(ss4_updown.correct.x))));
sem.ss8.updown.correct.x = nanstd(ss8_updown.correct.x) / sqrt(length(find(~isnan(ss8_updown.correct.x))));
sem.ss2.updown.correct.y = nanstd(ss2_updown.correct.y) / sqrt(length(find(~isnan(ss2_updown.correct.y))));
sem.ss4.updown.correct.y = nanstd(ss4_updown.correct.y) / sqrt(length(find(~isnan(ss4_updown.correct.y))));
sem.ss8.updown.correct.y = nanstd(ss8_updown.correct.y) / sqrt(length(find(~isnan(ss8_updown.correct.y))));
sem.ss2.updown.errors.x = nanstd(ss2_updown.errors.x) / sqrt(length(find(~isnan(ss2_updown.errors.x))));
sem.ss4.updown.errors.x = nanstd(ss4_updown.errors.x) / sqrt(length(find(~isnan(ss4_updown.errors.x))));
sem.ss8.updown.errors.x = nanstd(ss8_updown.errors.x) / sqrt(length(find(~isnan(ss8_updown.errors.x))));
sem.ss2.updown.errors.y = nanstd(ss2_updown.errors.y) / sqrt(length(find(~isnan(ss2_updown.errors.y))));
sem.ss4.updown.errors.y = nanstd(ss4_updown.errors.y) / sqrt(length(find(~isnan(ss4_updown.errors.y))));
sem.ss8.updown.errors.y = nanstd(ss8_updown.errors.y) / sqrt(length(find(~isnan(ss8_updown.errors.y))));



figure
errorbar([nanmean(ss2_leftright.correct.x) nanmean(ss4_leftright.correct.x) ...
    nanmean(ss8_leftright.correct.x); nanmean(ss2_leftright.errors.x) ...
    nanmean(ss4_leftright.errors.x) nanmean(ss8_leftright.errors.x)]', ...
    [sem.ss2.leftright.correct.x sem.ss4.leftright.correct.x sem.ss8.leftright.correct.x; ...
    sem.ss2.leftright.errors.x sem.ss4.leftright.errors.x sem.ss8.leftright.errors.x]','xb')
hold
bar(1:3,[nanmean(ss2_leftright.correct.x) nanmean(ss4_leftright.correct.x) ...
    nanmean(ss8_leftright.correct.x); nanmean(ss2_leftright.errors.x) ...
    nanmean(ss4_leftright.errors.x) nanmean(ss8_leftright.errors.x)]')
title('Left-Right X-Dimension')
 
figure
errorbar([nanmean(ss2_leftright.correct.y) nanmean(ss4_leftright.correct.y) ...
    nanmean(ss8_leftright.correct.y); nanmean(ss2_leftright.errors.y) ...
    nanmean(ss4_leftright.errors.y) nanmean(ss8_leftright.errors.y)]', ...
    [sem.ss2.leftright.correct.y sem.ss4.leftright.correct.y sem.ss8.leftright.correct.y; ...
    sem.ss2.leftright.errors.y sem.ss4.leftright.errors.y sem.ss8.leftright.errors.y]','xb')
hold
bar(1:3,[nanmean(ss2_leftright.correct.y) nanmean(ss4_leftright.correct.y) ...
    nanmean(ss8_leftright.correct.y); nanmean(ss2_leftright.errors.y) ...
    nanmean(ss4_leftright.errors.y) nanmean(ss8_leftright.errors.y)]')
title('Left-Right Y-Dimension')

figure
errorbar([nanmean(ss2_updown.correct.x) nanmean(ss4_updown.correct.x) ...
    nanmean(ss8_updown.correct.x); nanmean(ss2_updown.errors.x) ...
    nanmean(ss4_updown.errors.x) nanmean(ss8_updown.errors.x)]', ...
    [sem.ss2.updown.correct.x sem.ss4.updown.correct.x sem.ss8.updown.correct.x; ...
    sem.ss2.updown.errors.x sem.ss4.updown.errors.x sem.ss8.updown.errors.x]','xb')
hold
bar(1:3,[nanmean(ss2_updown.correct.x) nanmean(ss4_updown.correct.x) ...
    nanmean(ss8_updown.correct.x); nanmean(ss2_updown.errors.x) ...
    nanmean(ss4_updown.errors.x) nanmean(ss8_updown.errors.x)]')
title('Up-Down X-Dimension')
 
figure
errorbar([nanmean(ss2_updown.correct.y) nanmean(ss4_updown.correct.y) ...
    nanmean(ss8_updown.correct.y); nanmean(ss2_updown.errors.y) ...
    nanmean(ss4_updown.errors.y) nanmean(ss8_updown.errors.y)]', ...
    [sem.ss2.updown.correct.y sem.ss4.updown.correct.y sem.ss8.updown.correct.y; ...
    sem.ss2.updown.errors.y sem.ss4.updown.errors.y sem.ss8.updown.errors.y]','xb')
hold
bar(1:3,[nanmean(ss2_updown.correct.y) nanmean(ss4_updown.correct.y) ...
    nanmean(ss8_updown.correct.y); nanmean(ss2_updown.errors.y) ...
    nanmean(ss4_updown.errors.y) nanmean(ss8_updown.errors.y)]')
title('Up-Down Y-Dimension')

