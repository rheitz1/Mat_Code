

Plot_Time=[-250 1000];
                Align_Time_= Target_(NOGOCorrect(:,1,:))
                Eot_=TrialStart_+500;
                triallist_=1:length(target_left)

    %            Target_left = find(Target_(:,2)) == 1;
     %           Target_right = find (Target_(:,2)) == 0;
                %Calculate the SDF 
                SDF=[];
                [SDF] = spikedensityfunct_lgn_old(DSP03c, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);

                figure
         %       hold on
                subplot(1,2,1)
                t=[-250:1000];
                plot(t,SDF,'r','LineWidth',2)
                axis tight
                axvals = axis
                axis(axvals*1.1)
               % set(gca,'Xtick',[-250:50:250]);
               set(gcf,'Color','white')
              % set(gca,'Color','blue')