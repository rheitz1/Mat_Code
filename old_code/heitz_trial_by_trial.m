load('C:\Documents and Settings\Steph\Desktop\fecsze_m.101305c','-mat')
  

goodtrials = find(Saccade_(:,1) > 1);

Plot_Time=[0 8000];
%want to align at trial start.  actual "trial start" variable is a clock
%read, so instead, take time of target onset and subtract it from itself.
%SDF will be aligned at 0.
Align_Time_= (Target_(goodtrials,1) - Target_(goodtrials,1));
Eot_=TrialStart_+500;
triallist_=1:length(goodtrials);

good_RT = Saccade_(goodtrials,1) - Target_(goodtrials,1);
t = [-250 1000];


for trial=1:length(goodtrials)
    subplot(6,1,1)
    time_x = (1:length(EyeX_))*4;
%     plot(time_x,EyeX_(goodtrials(trial),:))
    plot(time_x,EyeX_(goodtrials(trial),:))
    Xlabel('X-axis Eye position');
    line([250 250],[-400 0]);
    set(gcf,'Color','white')
%     set(gca,'XTickLabel',[-250:125:1000])
   
   %xlim([0 3000])
  % time_x=[];
    subplot(6,1,2)
   % time_x = (1:length(EyeY_))*4;
    plot(time_x,EyeY_(goodtrials(trial),:))
    %set(gca,'XTick',Target_(goodtrials(trial),1))
   % set(gca,'XTicklabel','Target')
    Xlabel('Y-axis Eye Position');
%    set(gca,'XTickLabel',[-250:125:1000])
    
   
    
 
    subplot(6,1,3)
%draw target onset
axis([0 8000 -10 10]) 
%draw target onset
line([Target_(goodtrials(trial,1)) Target_(goodtrials(trial,1))], [-10 10]);
 
%draw saccade onset
line([Saccade_(goodtrials(trial,1)) Saccade_(goodtrials(trial,1))], [-10 10],'color','r');
xLabel('Blue: Target Onset    Red: Saccade Onset')

%draw spike train
subplot(6,1,4)
for l = 1:length(DSP01d(goodtrials(trial,1),:))
line([DSP01d(goodtrials(trial),l) DSP01d(goodtrials(trial),l)], [-10 10],'color', 'b');
end
xLabel('Spike Train')
axis([0 8000 -inf inf]) 

%draw SDF
subplot(6,1,5)
    SDF=[];
[SDF] = spikedensityfunct_lgn_old(DSP01a, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);
plot(SDF,'r','LineWidth',2)
 xLabel('Spike Density Function')
axis([0 8000 -inf inf]) 
% set(gca,'XTickLabel',[-250:125:1000])
  % xlim([0 1000])
   
  
%draw raster
%call to CalcSortRT, a function t hat finds all good (not NaN) RTs and sorts
%them...  function [RT_unsort,RT_sort,Sort_index,Sort_index_clean] = CalcSortRT(Target_time,Saccade_time)

[RT_unsort,RT_sort,Sort_index,Sort_index_clean] = CalcSortRT(Target_(:,1),Saccade_(:,1));

subplot(6,1,6)
for i = 1:length(Sort_index_clean)
    for l = 1:length(DSP01a(Sort_index(Sort_index_clean(i,1))))
    line([DSP01a(Sort_index(Sort_index_clean(i,1))) DSP01a(Sort_index(Sort_index_clean(i,1)))], [i-1 i+1])
    end
end
axis([0 1400 0 100])
%xlim([0 1400])

    %subplot(5,1,3)
    %plot(1,Target_(goodtrials(trial)),'MarkerSize',50,'MarkerFaceColor','g')
    
% 
%                 SDF=[];
%                 [SDF] = spikedensityfunct_lgn_old(DSP03a, Align_Time_, Plot_Time, triallist_, TrialStart_, Eot_, 1);
%                 figure
%                 subplot(5,1,1)
%                 t=[-250:1000];
%                 plot(t,SDF,'r','LineWidth',2)
%                 axis tight
%                 axvals = axis;
%                 axis(axvals*1.1);
%                % set(gca,'Xtick',[-250:50:250]);
%                set(gcf,'Color','white')
%               % set(gca,'Color','blue')
               pause
               subplot(6,1,3)
               plot(0)
               subplot(6,1,4)
               plot(0)    
end
