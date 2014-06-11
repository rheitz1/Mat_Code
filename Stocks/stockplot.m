function stockplot(symbol,date,open,low,high,close,varargin)
% STOCKPLOT  -- Stock Chart Function
%  M Boldin  10-19-2003, revised 2-16-2007 to improve data table location
%
% Required Inputs:  symbol,date,open,low,high,close
%   optional 6th input:  flag to put table in chart
%      0-- no table, 1 or no seventh argument-- include table
%

tflag=1; %default assumes table is desired; 
if nargin > 6;
  tflag=varargin{1};
end;   

nn=size(close,1);
H=high; L=low; O=open; C=close;
date=datenum(date);
datefmt=1;

figure

hold on;

%Draw main line date-close
hline1=plot(date,close,'b:','LineWidth',2);
if datefmt > 0;
    datetick('x');
end;

%draw lines from Low to High for each date
for i=1:nn
    line([date(i) date(i)],[L(i) H(i)])
end

%Show Open and Close as markers
hline2=plot(date,close,'.','MarkerSize',8);
hline3=plot(date,open,'o','MarkerSize',2);
datetick('x');

last_date=datestr(date(end));
last_open = open(end);
last_close = close(end);
last_low = low(end);
last_high = high(end);

t1 = sprintf('Stock symbol: %s', symbol);
t1h=title(t1,'FontWeight', 'bold');
ylabel('Share Price');

%determine x,y axis width & modify for extra left and right side space;
av=axis;
ax1= av(2) - av(1);  %X-axis width;
ay1= av(4) - av(3);  %Y-axis width;

% x axis left side;
xadj= 0.05;
ddx=  max(date)-min(date);
av1 = floor(date(1) -  xadj*ddx);
av(1)= max(av(1),av1);

% x axis right side;
av2 = floor(date(end) +  xadj*ddx);
av(2)= min(av(2),av2);

if tflag==1;
% Make table with %Make final date open-low-high-close box;
    
    t2 = sprintf('%s \nOpen:%6.2f \nLow: %6.2f  \nHigh: %6.2f \nClose:%6.2f', ...
        last_date,last_open,last_low,last_high,last_close);

    % set x,y plot location for last date numbers;
    xloc= av(2) - .15*(av(2)-av(1));

    %find last price;
    cc= close;
    cc=close(cc > 0);
    yy=cc(end);
   
    %determine best y location;
    %if close above 1/2 way point put below close;
    if yy > (av(4) - ay1/4)      
        yloc= av(3) + ay1/2;       
    elseif yy > (av(4) - ay1/2) 
        yloc= av(3) + ay1/3;       
    else, yloc= av(4) - .20*ay1; % or near upper right corner;
    end;
    text(xloc,yloc,t2,'FontSize',7,'Vertical','middle');

end;

axis(av);

hold off

