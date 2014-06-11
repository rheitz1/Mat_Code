%plot a spike train visually.  Takes vector of spike times (corrected for
%any built-in baseline time or for SRT if want response-aligned.

function [] = plotTrain(Spike,Spike2)

if size(Spike,1) > 1
    error('Function requires vector')
end

if nargin < 2
    
    train = Spike(find(~isnan(Spike)));
    
    fig
    hold
    
    for t = 1:length(train)
        line([train(t) train(t)],[-1 1],'color','k','linewidth',2)
    end
    
else %if more than one spike
    
    
    train1 = Spike(find(~isnan(Spike)));
    train2 = Spike2(find(~isnan(Spike2)));
    
    fig
    hold
    
    for t = 1:length(train1)
        line([train1(t) train1(t)],[-2 -1],'color','r','linewidth',2)
    end
    
    for t = 1:length(train2)
        line([train2(t) train2(t)],[1 2],'color','b','linewidth',2)
    end
end


ylim([-10 10])
set(gca,'yticklabel',[])
