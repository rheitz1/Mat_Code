%Tests Model using G^2 statistic

%get unconstrained model
Model1 = [2 2 2 1];
Model2 = [1 2 2 1];



[filename] = textread('SAT_Beh_NoMed_Q.txt','%s');


for file = 1:2%length(filename)
    
    load(filename{file},'Correct_','Target_','SRT','SAT_','Errors_','Correct_')
    filename{file}
    
    [solution1(file,:) LL1(file,1) BIC1(file,1)] = fitLBA_SAT(Model1,0);
    numfree1 = sum(Model1);
    
    [solution2(file,:) LL2(file,1) BIC2(file,1)] = fitLBA_SAT(Model2,0);
    numfree2 = sum(Model2);
    
    keep filename file Model1 Model2 solution* LL* BIC*
end


% G2 = 2 * (LL1 - LL2);
% 
% p = 1-chi2cdf(G2,(numfree1 - numfree2))

%Model 1 parameters
A.Model1(1:Model1(1)) = NaN;
b.Model1(1:Model1(2)) = NaN;
v.Model1(1:Model1(3)) = NaN;
T0.Model1(1:Model1(4)) = NaN;
s.Model1 = .1; % ALWAYS FIXED;

A.Model1 = solution1(:,1:size(A.Model1,2));
b.Model1 = solution1(:,size(A.Model1,2)+1:size(A.Model1,2)+size(b.Model1,2));
v.Model1 = solution1(:,size(A.Model1,2)+size(b.Model1,2)+1:size(A.Model1,2)+size(b.Model1,2)+size(v.Model1,2));
T0.Model1 = solution1(:,size(A.Model1,2)+size(b.Model1,2)+size(v.Model1,2)+1:size(solution1,2));
s.Model1 = [s.Model1 s.Model1];

if Model1(1) == 1; A.Model1 = repmat(A,1,2); end
if Model1(2) == 1; b.Model1 = repmat(b,1,2); end
if Model1(3) == 1; v.Model1 = repmat(v,1,2); end
if Model1(4) == 1; T0.Model1 = repmat(T0,1,2); end



%Model 2 parameters
A.Model2(1:Model2(1)) = NaN;
b.Model2(1:Model2(2)) = NaN;
v.Model2(1:Model2(3)) = NaN;
T0.Model2(1:Model2(4)) = NaN;
s.Model2 = .1; % ALWAYS FIXED;
 
A.Model2 = solution2(:,1:size(A.Model2,2));
b.Model2 = solution2(:,size(A.Model2,2)+1:size(A.Model2,2)+size(b.Model2,2));
v.Model2 = solution2(:,size(A.Model2,2)+size(b.Model2,2)+1:size(A.Model2,2)+size(b.Model2,2)+size(v.Model2,2));
T0.Model2 = solution2(:,size(A.Model2,2)+size(b.Model2,2)+size(v.Model2,2)+1:size(solution2,2));
s.Model2 = [s.Model2 s.Model2];
 
if Model2(1) == 1; A.Model2 = repmat(A.Model2,1,2); end
if Model2(2) == 1; b.Model2 = repmat(b.Model2,1,2); end
if Model2(3) == 1; v.Model2 = repmat(v.Model2,1,2); end
if Model2(4) == 1; T0.Model2 = repmat(T0.Model2,1,2); end

sem.A.Model1 = nanstd(A.Model1,[],1) ./ sqrt(size(A.Model1,1));
sem.b.Model1 = nanstd(b.Model1,[],1) ./ sqrt(size(b.Model1,1));
sem.v.Model1 = nanstd(v.Model1,[],1) ./ sqrt(size(v.Model1,1));
sem.T0.Model1 = nanstd(T0.Model1,[],1) ./ sqrt(size(T0.Model1,1));

sem.A.Model2 = nanstd(A.Model2,[],1) ./ sqrt(size(A.Model2,1));
sem.b.Model2 = nanstd(b.Model2,[],1) ./ sqrt(size(b.Model2,1));
sem.v.Model2 = nanstd(v.Model2,[],1) ./ sqrt(size(v.Model2,1));
sem.T0.Model2 = nanstd(T0.Model2,[],1) ./ sqrt(size(T0.Model2,1));

figure
subplot(1,4,1)

bar(mean(A.Model1),'k')
hold on
errorbar(mean(A.Model1),sem.A.Model1,'xk')
xlim([.5 2.5])
box off
set(gca,'xticklabel',['SLOW' ; 'FAST'])
title('A')

subplot(1,4,2)

bar(mean(b.Model1),'k')
hold on
errorbar(mean(b.Model1),sem.b.Model1,'xk')
xlim([.5 2.5])
box off
set(gca,'xticklabel',['SLOW' ; 'FAST'])
title('b')

subplot(1,4,3)

bar(mean(v.Model1),'k')
hold on
errorbar(mean(v.Model1),sem.v.Model1,'xk')
xlim([.5 2.5])
box off
set(gca,'xticklabel',['SLOW' ; 'FAST'])
title('v')

subplot(1,4,1)

bar(mean(T0.Model1),'k')
hold on
errorbar(mean(T0.Model1),sem.T0.Model1,'xk')
xlim([.5 2.5])
box off
set(gca,'xticklabel',['SLOW' ; 'FAST'])
title('T0')