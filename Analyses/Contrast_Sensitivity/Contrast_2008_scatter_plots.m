%plot scatterplots
%run associated files:

Contrast_2008_burst_slopes
Contrast_2008_maxFire_slopes


%============
%Quincy
%============


%plot burst onsets
figure
orient landscape
set(gcf,'Color','white')
% 
% meanBurst(:,1) = cat(1,cell2mat(Q_meanBurst(:,1)),cell2mat(S_meanBurst(:,1)));
% meanBurst(:,2) = cat(1,cell2mat(Q_meanBurst(:,2)),cell2mat(S_meanBurst(:,2)));
% meanBurst(:,3) = cat(1,cell2mat(Q_meanBurst(:,3)),cell2mat(S_meanBurst(:,3)));

subplot(2,3,1)
scatter(cell2mat(Q_meanBurst(:,1)),cell2mat(Q_meanBurst(:,2)),'db','fillcolor','b')
hold
scatter(cell2mat(S_meanBurst(:,1)),cell2mat(S_meanBurst(:,2)),'dr','fillcolor','r')
title('Bursts: Low Contrast vs. Med Contrast')
line([0 200],[0 200])

subplot(2,3,2)
scatter(cell2mat(Q_meanBurst(:,2)),cell2mat(Q_meanBurst(:,3)),'db','fillcolor','b')
hold
scatter(cell2mat(S_meanBurst(:,2)),cell2mat(S_meanBurst(:,3)),'dr','fillcolor','r')
title('Bursts: Med Contrast vs. High Contrast')
line([0 200],[0 200])


subplot(2,3,3)
scatter(cell2mat(Q_meanBurst(:,1)),cell2mat(Q_meanBurst(:,3)),'db','fillcolor','b')
hold
scatter(cell2mat(S_meanBurst(:,1)),cell2mat(S_meanBurst(:,3)),'dr','fillcolor','r')
title('Bursts: Low Contrast vs. High Contrast')
line([0 200],[0 200])

subplot(2,3,4)
scatter(cell2mat(Q_maxFire(:,1)),cell2mat(Q_maxFire(:,3)),'db','fillcolor','b')
hold
scatter(cell2mat(S_maxFire(:,1)),cell2mat(S_maxFire(:,3)),'dr','fillcolor','r')
title('Max Firing Rates: Low Contrast vs. High Contrast')
line([0 200],[0 200])

subplot(2,3,5)
scatter(cell2mat(Q_maxFire(:,2)),cell2mat(Q_maxFire(:,3)),'db','fillcolor','b')
hold
scatter(cell2mat(S_maxFire(:,2)),cell2mat(S_maxFire(:,3)),'dr','fillcolor','r')
title('Max Firing Rates: Med Contrast vs. High Contrast')
line([0 200],[0 200])

subplot(2,3,6)
scatter(cell2mat(Q_maxFire(:,1)),cell2mat(Q_maxFire(:,3)),'db','fillcolor','b')
hold
scatter(cell2mat(S_maxFire(:,1)),cell2mat(S_maxFire(:,3)),'dr','fillcolor','r')
title('Max Firing Rates: Low Contrast vs. High Contrast')
line([0 200],[0 200])

% 
% %===========
% %Seymour
% %===========
% %plot burst onsets
% figure
% set(gcf,'Color','white')
% 
% subplot(2,3,1)
% scatter(cell2mat(S_meanBurst(:,1)),cell2mat(S_meanBurst(:,2)))
% title('Bursts: Low Contrast vs. Med Contrast')
% line([0 200],[0 200])
% 
% subplot(2,3,2)
% scatter(cell2mat(S_meanBurst(:,2)),cell2mat(S_meanBurst(:,3)))
% title('Bursts: Med Contrast vs. High Contrast')
% line([0 200],[0 200])
% 
% subplot(2,3,3)
% scatter(cell2mat(S_meanBurst(:,1)),cell2mat(S_meanBurst(:,3)))
% title('Bursts: Low Contrast vs. High Contrast')
% line([0 200],[0 200])
% 
% subplot(2,3,4)
% scatter(cell2mat(S_maxFire(:,1)),cell2mat(S_maxFire(:,2)))
% title('Bursts: Low Contrast vs. Med Contrast')
% line([0 200],[0 200])
% 
% subplot(2,3,5)
% scatter(cell2mat(S_maxFire(:,2)),cell2mat(S_maxFire(:,3)))
% title('Bursts: Med Contrast vs. High Contrast')
% line([0 200],[0 200])
% 
% subplot(2,3,6)
% scatter(cell2mat(S_maxFire(:,1)),cell2mat(S_maxFire(:,3)))
% title('Bursts: Low Contrast vs. High Contrast')
% line([0 200],[0 200])