x = linspace(.05,1,101);
p.t = .2;
bList = 1:4;
figure(2)
clf
subplot(1,2,1)
y = zeros(length(bList),length(x));
for i=1:length(bList)
    p.b = bList(i);
    y(i,:) = Weibull(p,x);
end
plot(log(x),y')
logx2raw;
legend(num2str(bList'),'Location','NorthWest');
xlabel('Intensity');
ylabel('Proportion Correct');
title(['Varying b with t = ' mat2str(p.t)]);




p.b = 2;
tList = [.1,.2,.4,.8];
subplot(1,2,2)
y = zeros(length(tList),length(x));
for i=1:length(tList)
    p.t = tList(i);
    y(i,:) = Weibull(p,x);
end
plot(log(x),y')

legend(num2str(tList'),'Location','NorthWest');
xlabel('Intensity');
ylabel('Proportion Correct');
set(gca,'XTick',log(tList));
logx2raw
title('Varying t with b=2');






li = prod(y.^results.response .* ((1-y).^(1-results.response)));

y2 = y*.99 + .005;
lli = sum(results.response.* log(y2) + ((1-results.response).* log(1-y2)));