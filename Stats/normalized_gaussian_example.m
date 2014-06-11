%generates normal distribution with correct Y-axis. 

%Note that for a PDF, the Y axis is relative to the class interval size,
%with each value of the continuous distribution being a midpoint.

%Thus, if you generate the numbers -10:10 with a step size of .01, the
%summed area under the curve will be 100 (if each bin is .01, then the COUNTS within that bit
%are normalized by dividing by (1/.01 = 100).  You have to normalize your Y
%scores by dividing them by 100.

%If you had a .1 step, the sum of the area under the curve would be 10.

%to demonstrate:
step = .01;
x = [-10:step:10];
Y = normpdf(x,0,1);

figure
subplot(1,2,1)
fon
plot(x,Y,'linewidth',5)
title(['Sum f(X) = ' mat2str(sum(Y))])
ylabel('Probability Density')
xlabel('Not Normalized to bin width')
ylim([0 .5])

%now, normalize
YY = Y / (1/step);
subplot(1,2,2)
fon
plot(x,YY,'linewidth',5,'color','r')
title(['Sum f(x) = ' mat2str(sum(YY))])
xlabel('Normalized to bin width')
ylim([0 .005])