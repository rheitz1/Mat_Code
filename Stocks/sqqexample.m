%Example program for SQQ and StockQuoteQuery functions
% Michael Boldin  Oct 19 2003

%Query 1, using SQQ and producing simple plot
smbl='MSFT';
date1='1-jan-2003';

%sqq(smbl,'1-jan',365);

[date, close] = sqq(smbl,120);
plot(date,close);
datetick('x');
title([smbl ' Closing Prices (unadjusted)']);

%Query 2, using StockQuoteQuery to extract weekly data for current year 
%  and make two plots
[date, close, open, low, high, volume, closeadj] ... 
      = StockQuoteQuery(smbl,'1-Jan','31-Dec','w',2) ;

figure;
plot(date,[close closeadj]);
datetick('x');
title([smbl ' Closing and Adjusted Closing Prices']);


adj_factor= [ closeadj ./ close ];
openadj= open .* adj_factor; 
p1= low .* adj_factor;
p2= high .* adj_factor;
stockplot(smbl,date,openadj,p1,p2,closeadj);