A = [100.10];
b = [171.83];
v = [.57];
T0 = [82.93];
s = .10;

t = (1:1000) + T0;


% Winner
%PDF
f_winner = (1./A) .* ...
    (-v .* normcdf( (b-A-(t.*v) ) ./ (t.*s)  ) ...
    + s .* normpdf( (b-A-(t.*v)) ./ (t.*s)  ) ...
    + v .* normcdf( (b-(t.*v)) ./ (t.*s)  ) ...
    - s .* normpdf( (b-(t.*v)) ./ (t.*s)  ));


%CDF
F_winner = 1 ...
    + ( (b-A-(t.*v)) ./ A ) .* (normcdf( (b-A-(t.*v)) ./ (t.*s) )) ...
    - ( (b-(t.*v)) ./ A ) .* (normcdf( (b-(t.*v)) ./ (t.*s) )) ...
    + ( (t.*s) ./ A ) .* (normpdf( (b-A-(t.*v)) ./ (t.*s) )) ...
    - ( (t.*s) ./ A ) .* (normpdf( (b-(t.*v)) ./ (t.*s) ));


% Loser

%PDF
f_loser = (1./A) .* ...
    (-(1-v) .* normcdf( (b-A-(t.*(1-v)) ) ./ (t.*s)  ) ...
    + s .* normpdf( (b-A-(t.*(1-v))) ./ (t.*s)  ) ...
    + (1-v) .* normcdf( (b-(t.*(1-v))) ./ (t.*s)  ) ...
    - s .* normpdf( (b-(t.*(1-v))) ./ (t.*s)  ));


%CDF
F_loser = 1 ...
    + ( (b-A-(t.*(1-v))) ./ A ) .* (normcdf( (b-A-(t.*(1-v))) ./ (t.*s) )) ...
    - ( (b-(t.*(1-v))) ./ A ) .* (normcdf( (b-(t.*(1-v))) ./ (t.*s) )) ...
    + ( (t.*s) ./ A ) .* (normpdf( (b-A-(t.*(1-v))) ./ (t.*s) )) ...
    - ( (t.*s) ./ A ) .* (normpdf( (b-(t.*(1-v))) ./ (t.*s) ));


winner = cumsum(f_winner .* (1-F_loser));
loser = cumsum(f_loser .* (1-F_winner));

%=============================
% EXPLANATION
%
% (1)
% First, look at the finishing distributions for the two accumulators, given this set of parameters:
figure
plot(t,f_winner,'k',t,f_loser,'r','linewidth',2)
set(gca,'fontsize',12,'fontweight','bold')
title('Finishing Time Distributions')
legend('Winner','Loser')


% Note that both sum to 1, indicating that each distribution contains the complete breakdown
sum(f_winner)
sum(f_loser)

% (2)
% Note that the cumsum of the PDF and the CDF are equivalent here:
figure
plot(t,cumsum(f_winner),'k',t,F_winner,'--k',t,cumsum(f_loser),'r',t,F_loser,'--r','linewidth',2)
set(gca,'fontsize',12,'fontweight','bold')
legend('cumsum(f\_winner)','F\_winner','cumsum(f\_loser)','F\_loser')

% (3)
% Now, we can't simply calculate the Log Likelihood on these two PDFs and maximize. Since the Winner and
% Loser PDFs both sum to 1, the model does not take into account the different accuracy rates or numbers
% of observations in each condition. You can, however, use the CDF if you employ Chi-Square, but there
% will have to be a re-normalization.

% It is perhaps more straightforward to compute the predicted defective CDFs from the start.
% To do this, we can compare the finishing time PDF for Accumulator A (or here, 'Winner') versus
% the finishing time CDF for Accumulator B (or here, 'Loser'). More specifically, 1-CDF for Accumulator
% B.  By multiplying the PDF of the winner by 1-CDF of the loser, we answer the question "what is the
% probability of an RT at time t given that the loser has not finished yet.  When 1-CDF(Loser) is high (>
% probability it has NOT finished), the PDF is unaltered.  As p(Loser win) increases, the PDF is
% weighted. So for example, if 1 - CDF(Loser) == .50, and the PDF of the Winner at time t = .3, then we
% know that .3(1.5) won and .3(1.5) lost.
figure;
plot(t,f_winner,'k','linewidth',2)
set(gca,'fontsize',12,'fontweight','bold')
ylabel('PDF Winner')
newax
plot(t,1-F_winner,'r','linewidth',2)
ylim([0 1])
set(gca,'fontsize',12,'fontweight','bold')
ylabel('1 - F\_winner')


% (4)
% By going through this process, you end up with a NEW PDF for each condition
figure
plot(t,f_winner,'k',t,f_winner .* (1-F_loser),'--k',t,f_loser,'r',t,f_loser .* (1-F_winner),'--r','linewidth',2)
set(gca,'fontsize',12,'fontweight','bold')
legend('Original PDF winner','Defective PDF Winner','Original PDF Loser','Defective PDF Loser')

% (5)
% Note that it is these Defective PDFs that we calculate the log likelihood on and maximize.

% (6)
% Finally, we can plot the cumulative sum of these new Defective PDFs to create the Defective CDFs, which
% sould match with our data
figure
plot(t,winner,'k',t,loser,'r','linewidth',2)
set(gca,'fontsize',12,'fontweight','bold')
legend('Defective CDF Winner','Defective CDF Loser')
