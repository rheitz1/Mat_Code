%function Freq_SDF


clear all
close all
load('C:\Documents and Settings\Steph\Desktop\fecszz_m.021306z','-mat')

                Plot_Time=[-250 250];
                Align_Time_=Target_(:,1);
                Eot_=TrialStart_+500;
                triallist_=1:186;

                %Calculate the SDF 
                SDF=[];
                [SDF] = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);

                figure
                subplot(2,2,1)
                t=[-250:250];
                plot(t,SDF)
                axis tight
                axvals = axis
                axis(axvals*1.1)
               % set(gca,'Xtick',[-250:50:250]);
                
                [SDF] = spikedensityfunct_lgn_old(DSP02a, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);
                
                subplot(2,2,2)
                plot(t,SDF)
                axis tight
                axvals = axis
                axis(axvals*1.1)
               
                
                
                