%Plots X and Y eye traces trial-by-trial and marks the detected onset time
%of the saccade for visual inspection
%RPH

f = figure;
set(f,'Position',[1000 1100 1400 1100])
orient landscape
set(gcf,'color','white')

plottime = -Target_(1,1):size(EyeX_,2)-Target_(1,1)-1;

[~,~,SRT_end] = getSRT(EyeX_,EyeY_);

for trl = 1:size(Target_)
    plot(plottime,EyeX_(trl,:),'k')
    hold on
    plot(plottime,EyeY_(trl,:),'k','linewidth',2)
    
    title(['Trial: ' mat2str(trl) '  Correct/Error: ' mat2str(Correct_(trl,2)) '  RT = ' mat2str(SRT(trl,1))],'fontsize',18,'fontweight','bold')

    ylim([-5 5])
    xlim([-3500 2500])
    
    if exist('FixOn_')
        v1 = vline(FixOn_(trl),'m');
        set(v1,'linewidth',2)
    end
    
    if exist('FixAcqTime_')
        v2 = vline(FixAcqTime_(trl),'b');
        set(v2,'linewidth',2)
    end
    
    v3 = vline(-FixTime_Jit_(trl),'g');
    set(v3,'linewidth',2)
    
    v4 = vline(SRT(trl,1),'r');
    set(v4,'linewidth',1)
    
    v5 = vline(SRT_end(trl,1),'r');
    set(v5,'linewidth',1)
    
    v6 = vline(JuiceOn_(trl,1),'--k');
    set(v6,'linewidth',2)
    
    text(.1,-.05,'Fixation Point On','color','m','units','normalized','fontsize',18,'fontweight','bold')
    text(.3,-.05,'Fixation Acquired','color','b','units','normalized','fontsize',18,'fontweight','bold')
    text(.5,-.05,'Fixation Hold Time','color','g','units','normalized','fontsize',18,'fontweight','bold')
    text(.7,-.05,'SRT','color','r','units','normalized','fontsize',18,'fontweight','bold')
    text(.9,-.05,'Juice','color','k','units','normalized','fontsize',18,'fontweight','bold')
    
    hold off
    box off
    pause
    cla
end

clear h trl plottime f v1 v2 v3 v4 v5
