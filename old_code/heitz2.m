load('C:\Documents and Settings\Steph\Desktop\fecfef_m.250','-mat')

%find right-hand targets
target_right = find(Target_(:,2) == 1);
target_left = find(Target_(:,2) == 0);
SRT_left = Saccade_(target_left,1) - Target_(target_left,1);
SRT_right = Saccade_(target_right,1) - Target_(target_right,1);

  Plot_Time=[-250 1000];
                Align_Time_= Target_(target_left,1);
                Eot_=TrialStart_+500;
                triallist_=1:length(target_left)

    %            Target_left = find(Target_(:,2)) == 1;
     %           Target_right = find (Target_(:,2)) == 0;
                %Calculate the SDF 
                SDF=[];
                [SDF] = spikedensityfunct_lgn_old(DSP03a, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);

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
          
               
               
                Align_Time_= Target_(target_right,1);
                Eot_=TrialStart_+500;
                triallist_=1:length(target_right)

    %            Target_left = find(Target_(:,2)) == 1;
     %           Target_right = find (Target_(:,2)) == 0;
                %Calculate the SDF 
                SDF=[];
                [SDF] = spikedensityfunct_lgn_old(DSP03b, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);

                        %       hold on
                subplot(1,2,2)
                t=[-250:1000];
                plot(t,SDF,'r','LineWidth',2)
                axis tight
                axvals = axis
                axis(axvals*1.1)
               % set(gca,'Xtick',[-250:50:250]);
               set(gcf,'Color','white')
              % set(gca,'Color','blue')