%% HOW DO I DO THAT IN MATLAB SERIES?
% In this series, I am answering questions that students have asked
% me about MATLAB.  Most of the questions relate to a mathematical 
% procedure.

%% TOPIC
% How do I do polynomial regression?

%% SUMMARY

% Language : Matlab 2008a; 
% Authors : Autar Kaw; 
% Mfile available at
% http://numericalmethods.eng.usf.edu/blog/regression_polynomial.m; 
% Last Revised : August 3, 2009; 
% Abstract: This program shows you how to do polynomial regression?
%           .
clc
clear all
clf

%% INTRODUCTION

disp('ABSTRACT')
disp('   This program shows you how to do polynomial regression')
disp(' ')
disp('AUTHOR')
disp('   Autar K Kaw of http://autarkaw.wordpress.com')
disp(' ')
disp('MFILE SOURCE')
disp('   http://numericalmethods.eng.usf.edu/blog/regression_polynomial.m')
disp(' ')
disp('LAST REVISED')
disp('   August 3, 2009')
disp(' ')

%% INPUTS
% y vs x data to regress
% x data
x=[-340  -280  -200  -120  -40  40  80];
% ydata
y=[2.45  3.33  4.30   5.09  5.72  6.24  6.47];
% Where do you want to find the values at 
xin=[-300 -100 20  125];
%% DISPLAYING INPUTS
disp('  ')
disp('INPUTS')
disp('________________________')
disp('     x         y  ')
disp('________________________')
dataval=[x;y]';
disp(dataval)
disp('________________________')
disp('   ')
disp('The x values where you want to predict the y values')
dataval=[xin]';
disp(dataval)
disp('________________________')
disp('  ')

%% THE CODE
% Using polyfit to conduct polynomial regression to a polynomial of order 1
pp=polyfit(x,y,1);
% Predicting values at given x values
yin=polyval(pp,xin);
% This is only for plotting the regression model
% Find the number of data points
n=length(x);
xplot=x(1):(x(n)-x(1))/10000:x(n);
yplot=polyval(pp,xplot);


%% DISPLAYING OUTPUTS
disp('  ')
disp('OUTPUTS')
disp('________________________')
disp('   xasked   ypredicted  ')
disp('________________________')
dataval=[xin;yin]';
disp(dataval)
disp('________________________')

xlabel('x');
ylabel('y');
title('y vs x ');
plot(x,y,'o','MarkerSize',5,'MarkerEdgeColor','b','MarkerFaceColor','b')
hold on
plot(xin,yin,'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor','r')
hold on
plot(xplot,yplot,'LineWidth',2)
legend('Points given','Points found','Regression Curve','Location','East')
hold off
disp('  ')