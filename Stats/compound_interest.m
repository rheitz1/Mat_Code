%compound interest
% The number e (2.7183...) is the maximum possible result when compounding 100% growth for one time period.

%that is, 100% growth in the limit is 2.718 per time period

% Explanation of Euler's number and compound interest:
%
% Suppose you start with $100, and you earn 5% interest, 1 time per year'
% newval = 100 * (1 + (.05/1))^1
%   100 * 1+ something is the same as finding out the change and adding it to the starting value
%   (.05/1) because you want to divide the total interest rate over the period by the number of times it
%   is calculated.  Here, you earn 5% per year, compounded once.
%   ^1 to caluclate how many times
%
%   at the end of 1 year, 100 * (1 + (.05/1))^1 = 
%                         100 * 1.05 = 105
%
%   Now suppose you earn 5%, compounded weekly (so 52 times).
%   100 * (1 + (.05/52))^52
%   100 * 1.0512 = 105.1246
%
%   Now suppose you earn 100% (!!) interest, compounded once
%   100 * (1 + (1/1))^1
%   100 * 2 = 200
%
%   Now suppose you earn 100% interest, compounded every day (365)
%   100 * (1 + (1/365))^365
%   100 * 2.7146
%
%   and then once more, compounded per hour (365 * 24) = 8760
%   100 * (1 + (1/8760))^8760
%   100 * 2.7181
%
%   IF YOU CONTINUED COMPOUNDING OVER SHORTER TIME PERIODS, THE LIMIT IS EULERS NUMBER, OR 2.7183


start_money = 10000;
interest_rate = .03;
compound = 52; %number of compounds (52 would be once per week)
over_what_period = 365;

value = start_money * (1+(interest_rate/compound))^compound;
disp(['After ' mat2str(over_what_period) ' days your initial investment of $' ...
    mat2str(start_money) ' at ' mat2str(interest_rate*100) '% will be worth $' ...
    mat2str(value)])