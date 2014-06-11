% for trl = 10
%     for t = 1:size(act1.slow,2)
%         
%         subplot(211)
%         plot(act1.slow(trl,1:t),'r')
%         hold on
%         plot(act1.med(trl,1:t),'k')
%         plot(act1.fast(trl,1:t),'g')
%         xlim([0 800])
%         ylim([0 b])
%         
%         subplot(212)
%         plot(start1.slow(trl):rate1.slow(trl):start1.slow(trl)+round(t*rate1.slow(trl)),'r')
%         hold on
%         plot(start1.med(trl):rate1.med(trl):start1.med(trl)+round(t*rate1.med(trl)),'k')
%         plot(start1.fast(trl):rate1.fast(trl):start1.fast(trl)+round(t*rate1.fast(trl)),'g')
%         xlim([0 800])
%         ylim([0 500])
%         
%         pause(.001)
%     end
% end
%        

cd /volumes/Dump/Analyses/SAT/Models/iLBA_X2/
load animate_iLBA_trial_sim_data.mat

    for t = 1:size(act1.slow,2)
        
        subplot(211)
        plot(nanmean(act1.slow(:,1:t)),'r')
        hold on
        plot(nanmean(act1.med(:,1:t)),'k')
        plot(nanmean(act1.fast(:,1:t)),'g')
        xlim([0 800])
        ylim([0 b+1000])
        hline(b,'--k')
        box off
        set(gca,'xtick',[])
        
        subplot(212)
        plot(nanmean(start1.slow):nanmean(rate1.slow):nanmean(start1.slow)+round(t*nanmean(rate1.slow)),'r')
        hold on
        plot(nanmean(start1.med):nanmean(rate1.med):nanmean(start1.med)+round(t*nanmean(rate1.med)),'k')
        plot(nanmean(start1.fast):nanmean(rate1.fast):nanmean(start1.fast)+round(t*nanmean(rate1.fast)),'g')
        xlim([0 800])
        ylim([0 500])
        box off
        set(gca,'xminortick','on')
        pause(.001)
    end

       