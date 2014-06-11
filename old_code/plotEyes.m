%create time variable

close all;

CorrectTrials = find(Correct_(:,2));


for trial = 1:size(EyeX_,1)
subplot(2,1,1)

plot(-500:2500,EyeX_(trial,:),'color','r')
title(strcat('RT = ', mat2str(SRT(trial,1))))
hold on
% set(gca,'Xtick',0:100:3000)


%Draw SRT based on p_sacdet_search
%is calculated relative to target onset (I think) so for plotting purposes
%here, we have to add 500 ms to it (TrialStart arbitrarily defined to be
%500 ms before target onset)
% if exist('SaccBegin') == 1
%     line([SaccBegin(trial,1)+500 SaccBegin(trial,1)+500],[EyeX_(trial,500/4)-.1 EyeX_(trial,500/4)+.1],'color','g')
% end
 
 hold off
 %xlim([0 3000])
 subplot(2,1,2)
 plot(-500:2500,EyeY_(trial,:))
%  xlim([0 3000])  

 %Draw Target onset 
line([500 500], [EyeY_(trial,500)-1 EyeY_(trial,500)+1],'Color','k')

%Draw SRT onset based on Tempo (Decide_)
line([SRT(trial,1)+500 SRT(trial,1)+500],[EyeX_(trial,500)-1 EyeX_(trial,500)+1],'color','r')



if exist ('SaccBegin')
       for i = 1:size(SaccBegin,2)
           if(SaccBegin(trial,i)) > 0
              line([SaccBegin(trial,i)+500 SaccBegin(trial,i)+500], [-1 1],'Color','g');
           end
      end
 end
%  
 
 pause

end