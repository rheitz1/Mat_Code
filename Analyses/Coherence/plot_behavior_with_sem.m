

semacc.overall = std(acc.overall) / sqrt(length(acc.overall));
semacc.ss2 = std(acc.ss2) / sqrt(length(acc.ss2));
semacc.ss4 = std(acc.ss4) / sqrt(length(acc.ss4));
semacc.ss8 = std(acc.ss8) / sqrt(length(acc.ss8));
semacc.fast = std(acc.fast) / sqrt(length(acc.fast));
semacc.slow = std(acc.slow) / sqrt(length(acc.slow));

semRTs.correct = std(RTs.correct) / sqrt(length(RTs.correct));
semRTs.err = std(RTs.err) / sqrt(length(RTs.err));
semRTs.ss2 = std(RTs.ss2) / sqrt(length(RTs.ss2));
semRTs.ss4 = std(RTs.ss4) / sqrt(length(RTs.ss4));
semRTs.ss8 = std(RTs.ss8) / sqrt(length(RTs.ss8));
semRTs.fast = std(RTs.fast) / sqrt(length(RTs.fast));
semRTs.slow = std(RTs.slow) / sqrt(length(RTs.slow));


meanacc.overall = 1 - mean(acc.overall);
meanacc.ss2 = 1 - mean(acc.ss2);
meanacc.ss4 = 1 - mean(acc.ss4);
meanacc.ss8 = 1 - mean(acc.ss8);
meanacc.fast = 1 - mean(acc.fast);
meanacc.slow = 1 - mean(acc.slow);



meanRT.correct = mean(RTs.correct);
meanRT.err = mean(RTs.err);
meanRT.ss2 = mean(RTs.ss2);
meanRT.ss4 = mean(RTs.ss4);
meanRT.ss8 = mean(RTs.ss8);
meanRT.fast = mean(RTs.fast);
meanRT.slow = mean(RTs.slow);


subplot(4,1,1:3)
hold on
%errorbar([meanRT.ss2 meanRT.ss4 meanRT.ss8 meanRT.correct],[semRTs.ss2,semRTs.ss4,semRTs.ss8 semRTs.correct],'-ok','markerfacecolor','k','markersize',7)
errorbar([meanRT.ss2 meanRT.ss4 meanRT.ss8 meanRT.correct],[semRTs.ss2,semRTs.ss4,semRTs.ss8 semRTs.correct],'-ok','markersize',7)

subplot(4,1,4)
hold on
%errorbar([meanacc.ss2 meanacc.ss4 meanacc.ss8 meanacc.overall],[semacc.ss2,semacc.ss4,semacc.ss8 semacc.overall],'-sk','markerfacecolor','k','markersize',7)
errorbar([meanacc.ss2 meanacc.ss4 meanacc.ss8 meanacc.overall],[semacc.ss2,semacc.ss4,semacc.ss8 semacc.overall],'-sk','markersize',7)
