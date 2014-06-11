function subsubplot_showlayout(top)
%function subsubplot_showlayout(top)
%
% Preview what a subsubplot structure will look like
%
%---------------------------------------------------------------
% Subversion Revision: 2 (2005-11-03)
%
% This software can be used freely for non-commerical use.
% Visit http://www.kenschutte.com/software for more
%   documentation, copyright info, and updates.
%---------------------------------------------------------------


% simple image to display:
N = 30;
t = linspace(-5,5,N);
C = repmat(t.*t,N,1) + repmat(t'.*t',1,N);

figure;
colormap(jet)
H = subsubplot(top);

for i=1:length(H)
  subplot(H(i));
  imagesc(t,t,C);
  text(0,0,num2str(i),'color','white','verticalalignment','middle','horizontalalignment','center')
  axis off;
end



