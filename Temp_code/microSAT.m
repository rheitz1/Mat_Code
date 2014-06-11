batch_list = dir('/volumes/dump/Search_Data/*_SEARCH.mat');
figure
for i = 1:length(batch_list)
    batch_list(i).name
    %Load supporting variables
    load(batch_list(i).name,'Correct_','Errors_','Target_','SRT','-mat')
    
    fixErrors
    
    
    
    p1 = prctile(SRT(find(Target_(:,5) == 2)),33);
    p2 = prctile(SRT(find(Target_(:,5) == 2)),66);
    
    x(1) = mean(Correct_(find(Target_(:,5) == 2 & SRT < p1),2));
    x(2) = mean(Correct_(find(Target_(:,5) == 2 & SRT >= p1 & SRT < p2),2));
    x(3) = mean(Correct_(find(Target_(:,5) == 2 & SRT >= p2),2));
    
    p1 = prctile(SRT(find(Target_(:,5) == 4)),33);
    p2 = prctile(SRT(find(Target_(:,5) == 4)),66);
    
    y(1) = mean(Correct_(find(Target_(:,5) == 4 & SRT < p1),2));
    y(2) = mean(Correct_(find(Target_(:,5) == 4 & SRT >= p1 & SRT < p2),2));
    y(3) = mean(Correct_(find(Target_(:,5) == 4 & SRT >= p2),2));
    
    p1 = prctile(SRT(find(Target_(:,5) == 8)),33);
    p2 = prctile(SRT(find(Target_(:,5) == 8)),66);
    
    z(1) = mean(Correct_(find(Target_(:,5) == 8 & SRT < p1),2));
    z(2) = mean(Correct_(find(Target_(:,5) == 8 & SRT >= p1 & SRT < p2),2));
    z(3) = mean(Correct_(find(Target_(:,5) == 8 & SRT >= p2),2));
    
    plot(1:3,x,'r',1:3,y,'g',1:3,z,'b')
    ylim([.5 1])
    legend('SS2','SS4','SS8')
    pause
    cla
    
    ss2all(i,1:3) = x;
    ss4all(i,1:3) = y;
    ss8all(i,1:3) = z;
end

