function PostHocCohMagPlot(coh,f,t,TitStr,axh)
%
%
%
    
if nargin<5 || isempty(axh)
    figure;
else
    axis(axh);
end
imagesc(abs(coh')); %[-8 -7.99] add 1e-8 to avoid plotting log of zero, it happens with fake data sometimes
axis xy
colorbar
axhand=gca;

%I don't think a log trans is needed for displaying coh

numYTicks=6;
numXTicks=6;
freqind=round(linspace(1,length(f),numYTicks));
freqvals=round(f(freqind));
freqind(1)=.5;
set(axhand,'YTickLabel',freqvals);
set(axhand,'YTick',freqind);

tind=round(linspace(1,length(t),numXTicks));
tvals=t(tind);
tind(1)=.5;
set(axhand,'XTickLabel',tvals);
set(axhand,'XTick',tind);

ylabel('Frequency (Hz)')
xlabel('Center of Time window (ms)')
if nargin>3 && ~isempty(TitStr)
    title(TitStr);
end
%title(['MT Field/Field coherence mag with ' num2str(Nms) ' ms window sliding ' num2str(dnms) ' at a time.'])