for x = 1:11
plot(Plot_Time(1):Plot_Time(2),lum_SDF(:,x),'Color',[((length(lumarray)+1)-x)/length(lumarray) ((length(lumarray)+1)-x)/length(lumarray) ((length(lumarray)+1)-x)/length(lumarray)])
end