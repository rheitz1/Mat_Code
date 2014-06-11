%function to calculate amortization table

function [months remain interest_paid] = amort(cur_balance,interest_rate_prct,cur_payment)


pmt = 0;
remain(1) = cur_balance;

while remain > 0
    pmt = pmt + 1;
    interest_paid(pmt,1) = ((interest_rate_prct / 100) / 12) * remain(pmt);
    principal_paid(pmt,1) = cur_payment - interest_paid(pmt);
    remain(pmt+1,1) = remain(pmt) - principal_paid(pmt);
    
    if remain(pmt+1) > remain(pmt)
        disp('Amount owed is increasing; Payments not high enough!')
        pmt = inf;
        break
    end
end

months = pmt;
disp(['Your loan will be paid off in ' mat2str(months) ' months or ' mat2str(months/12) ' years.'])




% payment_change = 25; %dollar amount to increase every 'change_interval'
% change_interval = 12; %number of months between payment increase

% pmt = 0;
% remain(1) = cur_balance;
% 
% while remain > 0
%     pmt = pmt + 1;
%     
%     if mod(pmt,12) == 0
%         cur_payment = cur_payment + payment_change;
%     end
%     
%     interest_paid(pmt,1) = ((interest_rate_prct / 100) / 12) * remain(pmt);
%     principal_paid(pmt,1) = cur_payment - interest_paid(pmt);
%     remain(pmt+1,1) = remain(pmt) - principal_paid(pmt);
%     
%     if remain(pmt+1) > remain(pmt)
%         disp('Amount owed is increasing; Payments not high enough!')
%         pmt = inf;
%         break
%     end
% end
% 
% months = pmt;
% disp(['Your loan will be paid off in ' mat2str(months) ' months or ' mat2str(months/12) ' years.'])





% function [months remain interest_paid] = amort(cur_balance,interest_rate_prct,cur_payment,start_month)
% days_in_month(1) = 31;
% days_in_month(2) = 28;
% days_in_month(3) = 31;
% days_in_month(4) = 30;
% days_in_month(5) = 31;
% days_in_month(6) = 30;
% days_in_month(7) = 31;
% days_in_month(8) = 31;
% days_in_month(9) = 30;
% days_in_month(10) = 31;
% days_in_month(11) = 30;
% days_in_month(12) = 31;
% 
% mth = start_month;
% 
% pmt = 0;
% remain(1) = cur_balance;
% 
% while remain > 0
%     pmt = pmt + 1;
%     interest_paid(pmt,1) = ((remain(pmt) * (interest_rate_prct/100)) / 365.25) * days_in_month(mth);
%     %interest_paid(pmt,1) = ((interest_rate_prct / 100) / 12) * remain(pmt);
%     principal_paid(pmt,1) = cur_payment - interest_paid(pmt);
%     remain(pmt+1,1) = remain(pmt) - principal_paid(pmt);
%     
%     mth = mth + 1;
%     if mth == 13; mth = 1; end
%     
%     if remain(pmt+1) > remain(pmt)
%         disp('Amount owed is increasing; Payments not high enough!')
%         pmt = inf;
%         break
%     end
% end
% 
% months = pmt;
% disp(['Your loan will be paid off in ' mat2str(months) ' months or ' mat2str(months/12) ' years.'])

end

