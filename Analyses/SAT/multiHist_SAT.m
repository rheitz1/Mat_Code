% displays overlapping SRT histograms
% varargin is a list of trials in each condition.  We assume
% we want a histogram of SRT, so it is hard-coded as such
%
% RPH

function [] = multiHist_SAT(binsize,varargin)

if nargin < 2; binsize = 30; end

SRT = evalin('caller','SRT');

for var = 1:length(varargin)
    [n(1:binsize,var) x(1:binsize,var)] = hist(SRT(varargin{var},1),binsize);
end

figure

%superimposed histogram
hold on

color = {'b','r','g','k','m','y','b','r','g','k','m','y'};
for var = 1:length(varargin)
    bar(x(:,var),n(:,var),color{var})
end

%title('Superimposed Historgram')
xlim([0 1000])

%manually go through and change first histogram to transparent with thicker
%edges
h = findobj(gca,'Type','patch');
set(h(1),'facecolor','none')
set(h(1),'edgecolor','r')
set(h(1),'linewidth',2)

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