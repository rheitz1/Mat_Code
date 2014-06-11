%function Freq_SDF


clear all
close all
%load('C:\Documents and Settings\Steph\Desktop\fecszz_m.021306z','-mat')
%load('C:\Documents and Settings\Steph\Desktop\fecsze_m.101305c','-mat')
%load('C:\Documents and Settings\Steph\Desktop\fecsze_m.101305c','-mat')
load('C:\Documents and Settings\Steph\Desktop\fecfef_m.250','-mat')
                Plot_Time=[-250 1000];
                Align_Time_=Target_(:,1)
                Eot_=TrialStart_+500;
                triallist_=1:length(Target_);

                
                %Calculate the SDF 
                SDF=[];
                [SDF] = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);

                figure
         %       hold on
                subplot(2,3,1)
                t=[-250:1000];
                plot(t,SDF,'r','LineWidth',2)
                axis tight
                axvals = axis;
                axis(axvals*1.1);
               % set(gca,'Xtick',[-250:50:250]);
               set(gcf,'Color','white')
               set(gca,'Color','white')
               
         RTsubset = find(Saccade_>1);
         curr_mean = mean(RTsubset);
     hold on
         plot(curr_mean,SDF,'MarkerSize',5,'MarkerFaceColor','green')
     hold off
           SDF=[];    
     [SDF] = spikedensityfunct_lgn_old(DSP01b, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);
                
     
     pause(1);
                subplot(2,3,2)
                plot(t,SDF)
                axis tight
                axvals = axis;
                axis(axvals*1.1);
                
                [SDF] = spikedensityfunct_lgn_old(DSP01c, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);
               
                subplot(2,3,3)
                plot(t,SDF)
                axis tight
                axvals = axis;
                axis(axvals*1.1);
                
              [SDF] = spikedensityfunct_lgn_old(DSP02a, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);
               
                subplot(2,3,4)
                plot(t,SDF)
                axis tight
                axvals = axis;
                axis(axvals*1.1);
                
              [SDF] = spikedensityfunct_lgn_old(DSP02b, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);
               
                subplot(2,3,5)
                plot(t,SDF)
                axis tight
                axvals = axis;
                axis(axvals*1.1);
                
                 [SDF] = spikedensityfunct_lgn_old(DSP03a, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);
               
                subplot(2,3,6)
                plot(t,SDF,'linewidth',.05)
                axis tight
                axvals = axis;
                axis(axvals*1.1);
                
                
                
         
                
                