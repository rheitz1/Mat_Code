%Example program for SQQ and StockQuoteQuery functions
% Michael Boldin  Oct 19 2003, new version Feb 2007

smbl='MSFT';
freq='w';

%Using StockQuoteQuery to extract weekly data for current year
% plus the full past year and make plot

%set up date range:  d1 to d2;
d2=today; %end date;
d1v= [ year(today)-1  1  1];  %vector for Jan 1 of prior year;
d1=datenum(d1v);

%run query;
[date, close, open, low, high, volume, closeadj] ... 
      = StockQuoteQuery(smbl,d1,d2,freq) ;
 
%prepare for plot-- can  use split adjustments; 
adj_factor= 1; % =1, no adjustment; 
%  -- in Feb 2007 Yahoo made changes and closeadj column might not be right;      
%  -- if corrected use: adj_factor= [ closeadj ./ close ]; close2=closeadj;
close2= close; 
openadj= open .* adj_factor; 
p1= low .* adj_factor;
p2= high .* adj_factor;

stockplot(smbl,date,openadj,p1,p2,close2);
