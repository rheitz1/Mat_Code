%PlotModelOutputPublic
%
%

%CDFs
    figure
    set(gca,'position',[.35 .45 .3 .3])
    hold on
    plot(-500:1000,RTpred_cdf.easy,'color',[.6 0 0],'linewidth',2)
    plot(-500:1000,RTpred_cdf.hard,'color',[0 .6 0],'linewidth',2)
    vinc_quantiles.easy=[183.42 189.2 205.73 219.34 233 258.11 273.40];
    vinc_quantiles.hard=[207.60 220.64 252.28 276.81 305.23 370.34 422.07];
    plot(vinc_quantiles.easy(2:6),[.1 .3 .5 .7 .9],'linestyle','none','marker','o','color',[.6 0 0],'markersize',6,'linewidth',2)
    plot(vinc_quantiles.hard(2:6),[.1 .3 .5 .7 .9],'linestyle','none','marker','o','color',[0 .6 0],'markersize',6,'linewidth',2)

    legh=legend('Easy - Pred','Hard - Pred','Easy - Obs','Hard - Obs');
    legend('boxoff')
    set(legh,'position',[.75 .55 .1 .1])
    
    xlim([100 500])
    ylabel('CDF')
    xlabel('Time from array onset (ms)')

%Model input/output
    figure
    x_limits=[-200 500];
    y_limits=[0 theta]; 
    
%mean input
    subplot('position',[.35 .55 .3 .3])
    hold on
    plot(-500:1000,mean(SDF_in_matrix),'color','k','linewidth',3)
    plot(-500:1000,mean(SDF_out_matrix),'color','k','linewidth',1)
    plot([-500 1000],[g g],'r','linestyle',':')
    xlim([x_limits])
    ylim([0 1])
    set(gca,'xticklabel',[])
    ylabel('Normalized Activity')
    title('Average Model Input')
    legh=legend('Target in RF','Distractor in RF','g');
    legend('boxoff')
    set(legh,'position',[.75 .55 .1 .1])
    
%sample trajectory  
    subplot('position',[.35 .15 .3 .3])
    hold on
    n=round(nSims/2);
    plot(-500:1000,mean(traj_matrix_T(n:n+10,:)),'color','k','linewidth',3)
    plot(-500:1000,mean(traj_matrix_D(n:n+10,:)),'color','k','linewidth',1)
    plot([x_limits],[theta theta],'--','color','k','linewidth',2)
    xlim(x_limits)
    ylim(y_limits)
    ylabel('Model Activation')
    xlabel('Time from array onset (ms)')
    title('Sample Model Output')
    
    
    
    
    
   