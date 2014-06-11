%Find best model and plot
% Runs on SESSION FITS
%THIS DOES NOT WORK WELL

allLL = structfun(@sum,LL);
G2 = -2 * (allLL - allLL(1));
[minG2,ix] = sort(G2);

Best_Model = ix(2)


%As long as its model 8, plot.



% NOT VINCENTIZED - USE CDF ACROSS THE POPULATION
% % For population, compile all data into one huge dataset
%[filename] = textread('SAT_Beh_NoMed_Q.txt','%s');
% allTarget_ = [];
% allCorrect_ = [];
% allSRT = [];
% allSAT_ = [];
% allErrors_ = [];
% 
% for file = 1:length(filename)
%     load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_')
%     filename{file}
%     
%     allTarget_ = [allTarget_ ; Target_];
%     allCorrect_ = [allCorrect_ ; Correct_];
%     allSRT = [allSRT ; SRT(:,1)];
%     allSAT_ = [allSAT_ ; SAT_];
%     allErrors_ = [allErrors_ ; Errors_];
%     
%     clear Correct_ Target_ SRT SAT_ Errors_
% end
% 
% Target_ = allTarget_;
% Correct_ = allCorrect_;
% SRT = allSRT;
% SAT_ = allSAT_;
% Errors_ = allErrors_;
% 
% clear allTarget_ allCorrect_ allSRT allSAT_ allErrors_
% 
% % Get the defective CDFs back.  Doesn't matter which model we run.
% Model = [2 2 2 2];
% [~,~,~,~,CDF] = fitLBA_SAT(Model,0);

    
%    renvar CDF allCDF
    
%vincentized
if exist('allCDF') %session fits
CDF.slow.correct(:,1) = nanmean(allCDF.slow.correct(:,1),3);
CDF.slow.correct(:,2) = nanmean(allCDF.slow.correct(:,2),3);
CDF.slow.err(:,1) = nanmean(allCDF.slow.err(:,1),3);
CDF.slow.err(:,2) = nanmean(allCDF.slow.err(:,2),3);
CDF.med.correct(:,1) = nanmean(allCDF.med.correct(:,1),3);
CDF.med.correct(:,2) = nanmean(allCDF.med.correct(:,2),3);
CDF.med.err(:,1) = nanmean(allCDF.med.err(:,1),3);
CDF.med.err(:,2) = nanmean(allCDF.med.err(:,2),3);
CDF.fast.correct(:,1) = nanmean(allCDF.fast.correct(:,1),3);
CDF.fast.correct(:,2) = nanmean(allCDF.fast.correct(:,2),3);
CDF.fast.err(:,1) = nanmean(allCDF.fast.err(:,1),3);
CDF.fast.err(:,2) = nanmean(allCDF.fast.err(:,2),3);

else %population fits
    renvar CDF allCDF
    
CDF.slow.correct(:,1) = allCDF.slow.correct(:,1);
CDF.slow.correct(:,2) = allCDF.slow.correct(:,2);
CDF.slow.err(:,1) = allCDF.slow.err(:,1);
CDF.slow.err(:,2) = allCDF.slow.err(:,2);
CDF.med.correct(:,1) = allCDF.med.correct(:,1);
CDF.med.correct(:,2) = allCDF.med.correct(:,2);
CDF.med.err(:,1) = allCDF.med.err(:,1);
CDF.med.err(:,2) = allCDF.med.err(:,2);
CDF.fast.correct(:,1) = allCDF.fast.correct(:,1);
CDF.fast.correct(:,2) = allCDF.fast.correct(:,2);
CDF.fast.err(:,1) = allCDF.fast.err(:,1);
CDF.fast.err(:,2) = allCDF.fast.err(:,2);

end


A(1:3) = mean(solution.fixAvT0(:,1));
b(1) = mean(solution.fixAvT0(:,2));
b(2) = mean(solution.fixAvT0(:,3));
b(3) = mean(solution.fixAvT0(:,4));
v(1:3) = mean(solution.fixAvT0(:,5));
T0(1:3) = mean(solution.fixAvT0(:,6));

%create model
% A(1:2) = mean(solution.fixAT0(:,1));
% b(1) = mean(solution.fixAT0(:,2));
% b(2) = mean(solution.fixAT0(:,3));
% v(1) = mean(solution.fixAT0(:,4));
% v(2) = mean(solution.fixAT0(:,5));
% T0(1:2) = mean(solution.fixAT0(:,6));

t.slow = (1:1000) + T0(1);
t.med = (1:1000) + T0(2);
t.fast = (1:1000) + T0(3);

winner.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),v(1),.1) .* (1 - linearballisticCDF(1:1000,A(1),b(1),1-v(1),.1)));
loser.slow = cumsum(linearballisticPDF(1:1000,A(1),b(1),1-v(1),.1) .* (1 - linearballisticCDF(1:1000,A(1),b(1),v(1),.1)));

winner.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),v(2),.1) .* (1 - linearballisticCDF(1:1000,A(2),b(2),1-v(2),.1)));
loser.med = cumsum(linearballisticPDF(1:1000,A(2),b(2),1-v(2),.1) .* (1 - linearballisticCDF(1:1000,A(2),b(2),v(2),.1)));

winner.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),v(3),.1) .* (1 - linearballisticCDF(1:1000,A(3),b(3),1-v(3),.1)));
loser.fast = cumsum(linearballisticPDF(1:1000,A(3),b(3),1-v(3),.1) .* (1 - linearballisticCDF(1:1000,A(3),b(3),v(3),.1)));

figure
subplot(2,2,1)
plot(CDF.slow.correct(:,1),CDF.slow.correct(:,2),'ok', ...
    CDF.slow.err(:,1),CDF.slow.err(:,2),'or')
hold on
plot(t.slow,winner.slow,'k',t.slow,loser.slow,'r')

title('ACCURATE')

subplot(2,2,2)
plot(CDF.med.correct(:,1),CDF.med.correct(:,2),'ok', ...
    CDF.med.err(:,1),CDF.med.err(:,2),'or')
hold on
plot(t.med,winner.med,'k',t.med,loser.med,'r')

title('MEDIUM')


subplot(2,2,3)
plot(CDF.fast.correct(:,1),CDF.fast.correct(:,2),'ok', ...
    CDF.fast.err(:,1),CDF.fast.err(:,2),'or')
hold on
plot(t.fast,winner.fast,'k',t.fast,loser.fast,'r')

title('FAST')
