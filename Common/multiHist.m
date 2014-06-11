% displays overlapping SRT histograms
% varargin takes successive vectors of whatever you want to quantify in histogram (e.g., SRTs from different trials).  
%
% RPH

function [] = multiHist(binsize,varargin)

if nargin < 2; binsize = 30; end

for var = 1:length(varargin)
    [n(1:binsize,var) x(1:binsize,var)] = hist(varargin{var},binsize);
    %n_rescaled(1:binsize,var) = (n(:,var)./binsize)./numel(varargin{var});
    
    %edited 1/25/14 RPH: normalize by ALL input observations/conditions
    n_rescaled(1:binsize,var) = (n(:,var)./binsize)./sum(cellfun(@numel,varargin)); 
end


color = {'b','r','g','k','m','y','b','r','g','k','m','y'};

figure
%subplot(5,1,4:5)
subplot(121)
%superimposed histogram
hold on

for var = 1:length(varargin)
    bar(x(:,var),n(:,var),color{var})
end


%manually go through and change first histogram to transparent with thicker
%edges
h = findobj(gca,'Type','patch');
set(h(1),'facecolor','none')
set(h(1),'edgecolor',color{var})
set(h(1),'linewidth',1)
ylabel('N')

subplot(122)
hold on

for var = 1:length(varargin)
    bar(x(:,var),n_rescaled(:,var),color{var})
end


%manually go through and change first histogram to transparent with thicker
%edges
h = findobj(gca,'Type','patch');
set(h(1),'facecolor','none')
set(h(1),'edgecolor',color{var})
set(h(1),'linewidth',1)
ylabel('Proportion')
% 
% %side-by-side histogram
% subplot(2,1,2)
% bar(x,n)
% 
% title('Side-by-side Histogram')
% xlim([0 1500])
% 
% %for final graph, loop through and change color manually
% h = findobj(gca,'Type','patch');
% 
% for xh = 1:length(h)
%     set(h(xh),'FaceColor',color{xh},'EdgeColor',color{xh})
% end