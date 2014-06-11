function [CP,Record]=cpRL(Data,Crit)
%
% syntax [CP,Record]=cpRL(Data,Crit)
%
% Finds change points in three kinds of data based on the relative
% likelihood of the no-change and change models of a given segment of the
% data.
%
% Data is a column vector of either interevent intervals, or trial-by-trial
% binary outcomes (0's and 1's), or trial-by-trial counts (of e.g.
% number of responses)
%
% Crit is the odds criterion, the factor by which the data must favor the
% hypothesis that there has been a change, relative to the hypothesis that
% there has been no change. Values between 2 and 100 are suggested,
% but the choice depends strongly on the purposes for which the function is
% being used and the prior odds of a change point. The higher Crit is, the
% greater the odds in favor of the change model must be. When Crit = 20,
% the odds (Bayes Factor) must favor the change hypothesis by 20:1 in order
% for the algorithm to decide that there has been a change in the location
% parameter of the distribution from which the measures have been drawn.
%
% CP is a 4-column array, with the coordinates of the change point in the
% first two columns (time or trial coordinate in the first column,
% cumulative count in the second), the Bayes Factor (Odds) in the third
% column, and the estimate of the mean of the distribution for the segment
% preceding the change point in the 4th col [mean interevent interval,
% probability of success, or lambda (mean count), depending on whether the
% data are exponential, binary, or counts). The first and last rows are for
% the start and the end points of the cumulative record, respectively.
%
% The Bayes Factor is the strength of the evidence for the change
% point at the point (datum in the cumulative record) at which the algorithm
% decided that the there had been a change. The change point itself is
% always at an earlier point in the record, because one cannot in principle
% recognize a change until evidence for it has accumulated. 
%
% Record is a 9-column array giving the results as
% of each iteration. The first column is the row number in the data vector
% to which the algorithm has progressed. When it decreases, it is because a
% change point has been found and the data have been truncated at that
% change point. When that happens, the origin of the data vector (time or 
% trial 0) is the just-identified change point and the first datum is
% now the datum in the row of the data vector following the row at which
% the data have been truncated. The algorithm is working with the truncated
% data vector. The second column is the point that the algorithm has
% reached in the data vector it is now working on. The third column is the
% earlier point at which a change is maximally likely. The fourth column is
% the estimate of the mean (interval, probability or count) on the hypothesis
% (model) that assumes no change. The fifth and sixth columns are the
% estimated means before and after the putative (most likely)
% change point. The seventh and eighth columns are the log likelihoods of
% Model 1 (no change) and Model 2 (a change at the maximally likely change
% point). The ninth column is the Bayes factor, that is, the odds favoring
% Model 2. When it is less than 1, the odds favor Model 1.
%
% The function plots the cumulative record, with the change points
% indicated on it by small circles.

% With exponetial and count data, it plots a second figure with up to 8 panels
% showing observed and the implicitly fitted distribution for up to 8
% segments between change points. These plots enable one to judge how well
%  assumed distributions (exponential or Poisson) conforms to the observed
% distributions. No such plot is made in the case of binary data, because
% the only distribution from which binary data CAN come is the Bernoulli
% distribution. The validity of the likelihood computations depends on the
% validity of the distributional assumptions.


%%

if sum(mod(Data,1))~=0; % if the data are not integers
    
    [CP,Record]=local_exp(Data,Crit); % then the data are assumed to be
    % exponentially distributed interevent intervals
    
elseif sum([Data;Data==0])==length(Data); % if the data are binary
    
    [CP,Record]=local_bino(Data,Crit); % then they are assumed to be
    % drawn from a Bernoulli distribution with probability of success, P,
    % and probability of failure (1-P)
    
else % If the data are integers and not binary, they are assumed to be
    % counts drawn from a Poisson distribution
    [CP,Record]=local_pois(Data,Crit);
    
end
    
%% Exponential case
function [CP,Record]=local_exp(Data,Crit)
%%
FirstData=Data;

FirstCum=cumsum(Data); % elapsed time

%
CP = zeros(1,4); % initializaing CP array

i = 2; % initializing the index of significant change points

R = 1; % initializing the index of the total number of iterations through
% the inner while loop (used for rows of Record)

Record=[]; % Initializing array that contains record of the iterations

LatestTrunc = 0; % initializing

while length(Data)>2 % while the (possibly truncated) data vector has at
    % least three interevent intervals
%  Computing likelihood function
%
    CumExp=cumsum(Data); % elapsed time vector
    
    N = length(Data) % number of events
    
    n=2; % Initializing the current point, the lastest point in the
    % cumulative record to be considered
    
    while n < N % while the current point is not the last point
%
        for r = 1:n % stepping through possible change points prior to the
            % current point
%
            T = CumExp(r); % Elapsed time up to the possible change
            % point

            E1 = T/r; % estimated expected interevent interval up to
            % possible change point
%
            if r < n % haven't reached current point

                E2 = (CumExp(n)-T)/(n-r); % estimated expected
                % interevent interval after the change point

                LL(r) = sum([log(exppdf(Data(1:r),E1));...
                    log(exppdf(Data(r+1:n),E2))]);
                % the log likelihood of the data assuming the change point
                % is at r

            else % have reached end of data

                LL(r) = sum(log(exppdf(Data(1:n),E1))); % log likelihood
                % of the data on the no-change model (possible change point
                % is at current point)

            end % of if-else

        end % of for loop stepping through possible change points
%      Computing odds in favor of a change using Schwartz Criterion

        [MLL,Rmx] = max(LL(1:n-1)); % M = maximum likelihood of a model that
        % puts the change point anywhere but at the end of the data;
        % Rmx = row number of that maximum likelihood

        LogOdds = MLL - LL(n) - log(n);

        BF = exp(LogOdds); % Bayes Factor in favor of change model
        
        Record(R,1:9) = [LatestTrunc+n n Rmx CumExp(n)/n CumExp(Rmx)/Rmx ...
            (CumExp(n)-CumExp(Rmx))/(n-Rmx) MLL LL(n) BF];
        
        R=R+1;
%        
        if BF > Crit % if the odds favor the change model by more than the
            % decision criterion, then a change point has been found

            CP(i,1:3) = [CP(i-1,1)+CumExp(Rmx) CP(i-1,2)+Rmx BF];
            % coordinates of change point and Bayes factor

            CP(i-1,4) = (CP(i,1)-CP(i-1,1))/(CP(i,2)-CP(i-1,2));
            % estimated interevent interval up to change point

            Data=Data(Rmx+1:end); % Truncating data at the latest change
            % point
            
            LatestTrunc=CP(end,2); % updating latest truncation event #

            i=i+1; % incrementing the CP index
            
            break % leave while loop that has been advancing the current
            % point through the current Data vector. This returns control
            % to the encompassing while loop which now operates on the
            % truncated data
            
        end % if odds do  favor a change point
            
        n=n+1; % advance current point to next point in record     

    end % of while n < N
            
    if BF < Crit; break; end % if the program exits the inner while loop
    % without having found a change point, then the end of the final
    % (possibly also only) segment was reached without finding a (further)
    % change point
    
end % of outer while loop (length(Data) > 1)
% return
%
EndTime=FirstCum(end);

EndCount=length(FirstCum);

LastMu=(EndTime-CP(end,1))/(EndCount-CP(end,2));
%    
CP(end+1,1:3) = [EndTime EndCount 0];  

CP(end-1:end,4) = LastMu;
% return
%% First Figure
figure % first figure = cumulative record w change points in top panel;
% estimated intervent intervals in bottom panel

subplot(2,1,1)

stairs([0;FirstCum],[0;(1:length(FirstCum))'],'k') % Cumulative record of
% events. % If the data form a binary vector recording either success (1)
% or failure (0) on a trial, then this command should read:
% stairs([0;(1:length(FirstCum))'],[0;FirstCum],'k')
% and ditto if the data are counts per trial

xlabel('Time')
% xlabel ('Trial')

ylabel('Cumulative Number of Events')
% ylabel('Cumulative Successes')
% or
% ylabel('Cumulative Count')

hold on

plot(CP(:,1),CP(:,2),'ko') % plot change points on cumulative record
    
legend('Cumulative Record','Change Point','Location','NorthWest')

Xlm=xlim;

subplot(2,1,2) % bottom panel of first figure

stairs(CP(:,1),CP(:,4),'k')

xlim(Xlm); % making x-axis limits same as in first plot

xlabel('Time')

ylabel('Estimated Interevent Interval')

%% Second figure
figure % plot empirical cumulative distribution and estimated fit to it
% return

NumCP = size(CP,1)-1;

for r=1:NumCP % stepping through the change points

    if r>8; return;end

    subplot(floor((NumCP-1)/2)+1,2,r)

    SortedData=sort([FirstData(CP(r,2)+1:CP(r+1,2))]);

    % sorting data up to rth change point

    stairs([0;SortedData],(0:length(SortedData))'/(length(SortedData)),'k')

    hold on

    Xlm=xlim;

    Ylm=ylim;

    T=linspace(Xlm(1),Xlm(2),50);

    plot(T,expcdf(T,mean(SortedData(2:end))),'r') % theoretical cumulative distribution

    xlabel('Duration of InterEvent Interval')

    ylabel('Cumulative Frequency')

    if r==1;legend('Observed','Fitted Exponential','Location','SouthEast');legend boxoff;end

    title(['Segment ' num2str(r)])

    text(.05*(Xlm(2)-Xlm(1)),.95*(Ylm(2)-Ylm(1)),['1/lamda=' num2str(CP(r,4))])

end % of for loop

%% Binary Case
function [CP,Record]=local_bino(Data,Crit)
%%
FirstData=Data;

FirstCum=cumsum(Data); % elapsed time

%
CP = zeros(1,4); % initializaing CP array

i = 2; % initializing the index of significant change points

R = 1; % initializing the index of the total number of iterations through
% the inner while loop (used for rows of Record)

Record=[]; % Initializing array that contains record of the iterations

LatestTrunc = 0; % initializing

while length(Data)>6 % while the (possibly truncated) data vector has at
    % least seven trials
%
    CumBino=cumsum(Data); % cumulative successes
    
    N = length(Data) % number of trials
    
    n=6; % Initializing the current point, the lastest point in the
    % cumulative record to be considered
    
    while n < N % while the current point is not the last point
%
        for r = 1:n % stepping through possible change points prior to the
            % current point
%
            T = CumBino(r); % successes up to r

            P1 = T/r; % probability of success before putative cp
%
            if r < n % haven't reached current point

                P2 = (CumBino(n)-T)/(n-r); % probability of success after
                % putative cp

                LL(r) = sum([log(binopdf(Data(1:r),1,P1));...
                    log(binopdf(Data(r+1:n),1,P2))]);
                % the log likelihood of the data assuming the change point
                % is at r

            else % have reached end of data

                LL(r) = sum(log(binopdf(Data(1:n),1,P1))); % log likelihood
                % of the data on the no-change model (possible change point
                % is at current point)

            end % of if-else

        end % of for loop stepping through possible change points
%      Computing odds in favor of a change using Schwartz Criterion

        [MLL,Rmx] = max(LL(1:n-1)); % M = maximum likelihood of a model that
        % puts the change point anywhere but at the end of the data;
        % Rmx = row number of that maximum likelihood

        LogOdds = MLL - LL(n) - log(n);

        BF = exp(LogOdds); % Bayes Factor in favor of change model
        
        Record(R,1:9) = [LatestTrunc+n n Rmx CumBino(n)/n CumBino(Rmx)/Rmx ...
            (CumBino(n)-CumBino(Rmx))/(n-Rmx) MLL LL(n) BF];
        
        R=R+1;
%        
        if BF > Crit % if the odds favor the change model by more than the
            % decision criterion, then a change point has been found

            CP(i,1:3) = [CP(i-1,1)+Rmx CP(i-1,2)+CumBino(Rmx) BF];
            % coordinates of change point and Bayes factor

            CP(i-1,4) = (CP(i,2)-CP(i-1,2))/(CP(i,1)-CP(i-1,1));
            % estimated probability of success up to change point

            Data=Data(Rmx+1:end); % Truncating data at the latest change
            % point
            
            LatestTrunc=CP(end,2); % updating latest truncation event #

            i=i+1; % incrementing the CP index
            
            break % leave while loop that has been advancing the current
            % point through the current Data vector. This returns control
            % to the encompassing while loop which now operates on the
            % truncated data
            
        end % if odds do  favor a change point
            
        n=n+1; % advance current point to next point in record     

    end % of while n < N
            
    if BF < Crit; break; end % if the program exits the inner while loop
    % without having found a change point, then the end of the final
    % (possibly also only) segment was reached without finding a (further)
    % change point
    
end % of outer while loop (length(Data) > 1)
% return
%
EndCount=FirstCum(end);

EndTrials=length(FirstCum);

LastP=(EndCount-CP(end,2))/(EndTrials-CP(end,1));
%    
CP(end+1,1:3) = [EndTrials EndCount 0];  

CP(end-1:end,4) = LastP;
% return
%%
figure % cumulative record w change points in top panel;
% estimated probability of success vs trials in bottom panel

subplot(2,1,1)

stairs((0:length(FirstCum))',[0;FirstCum],'k') % Cumulative record of
% successes

xlabel('Trials')

ylabel('Cumulative Successes')

hold on

plot(CP(:,1),CP(:,2),'ko') % plot change points on cumulative record
    
legend('Cumulative Record','Change Point','Location','NorthWest')

Xlm=xlim;

subplot(2,1,2) % bottom panel of first figure

stairs(CP(:,1),CP(:,4),'k')

xlim(Xlm); % making x-axis limits same as in first plot

xlabel('Trials')

ylabel('Estimated Prob of Success')

%% Poisson Case

function [CP,Record]=local_pois(Data,Crit)
%%
FirstData=Data;

FirstCum=cumsum(Data); % elapsed time

%
CP = zeros(1,4); % initializaing CP array

i = 2; % initializing the index of significant change points

R = 1; % initializing the index of the total number of iterations through
% the inner while loop (used for rows of Record)

Record=[]; % Initializing array that contains record of the iterations

LatestTrunc = 0; % initializing

while length(Data)>3 % while the (possibly truncated) data vector has at
    % least seven trials
%
    CumPois=cumsum(Data); % cumulative successes
    
    N = length(Data) % number of trials
    
    n=2; % Initializing the current point, the lastest point in the
    % cumulative record to be considered
    
    while n < N % while the current point is not the last point
%
        for r = 1:n % stepping through possible change points prior to the
            % current point
%
            T = CumPois(r); % cumulative count up to r

            M1 = T/r; % lambda (mean count) before putative cp
%
            if r < n % haven't reached current point

                M2 = (CumPois(n)-T)/(n-r); % probability of success after
                % putative cp

                LL(r) = sum([log(poisspdf(Data(1:r),M1));...
                    log(poisspdf(Data(r+1:n),M2))]);
                % the log likelihood of the data assuming the change point
                % is at r

            else % have reached end of data

                LL(r) = sum(log(poisspdf(Data(1:n),M1))); % log likelihood
                % of the data on the no-change model (possible change point
                % is at current point)

            end % of if-else

        end % of for loop stepping through possible change points
%      Computing odds in favor of a change using Schwartz Criterion

        [MLL,Rmx] = max(LL(1:n-1)); % M = maximum likelihood of a model that
        % puts the change point anywhere but at the end of the data;
        % Rmx = row number of that maximum likelihood

        LogOdds = MLL - LL(n) - log(n);

        BF = exp(LogOdds); % Bayes Factor in favor of change model
        
        Record(R,1:9) = [LatestTrunc+n n Rmx CumPois(n)/n CumPois(Rmx)/Rmx ...
            (CumPois(n)-CumPois(Rmx))/(n-Rmx) MLL LL(n) BF];
        
        R=R+1;
%        
        if BF > Crit % if the odds favor the change model by more than the
            % decision criterion, then a change point has been found

            CP(i,1:3) = [CP(i-1,1)+Rmx CP(i-1,2)+CumPois(Rmx) BF];
            % coordinates of change point and Bayes factor

            CP(i-1,4) = (CP(i,2)-CP(i-1,2))/(CP(i,1)-CP(i-1,1));
            % estimated probability of success up to change point

            Data=Data(Rmx+1:end); % Truncating data at the latest change
            % point
            
            LatestTrunc=CP(end,2); % updating latest truncation event #

            i=i+1; % incrementing the CP index
            
            break % leave while loop that has been advancing the current
            % point through the current Data vector. This returns control
            % to the encompassing while loop which now operates on the
            % truncated data
            
        end % if odds do  favor a change point
            
        n=n+1; % advance current point to next point in record     

    end % of while n < N
            
    if BF < Crit; break; end % if the program exits the inner while loop
    % without having found a change point, then the end of the final
    % (possibly also only) segment was reached without finding a (further)
    % change point
    
end % of outer while loop (length(Data) > 1)
% return
%
EndCount=FirstCum(end);

EndTrials=length(FirstCum);

LastLambda=(EndCount-CP(end,2))/(EndTrials-CP(end,1));
%    
CP(end+1,1:3) = [EndTrials EndCount 0];  

CP(end-1:end,4) = LastLambda;
% return
%% First figure (cumulativer record and slopes thereof
figure % first figure = cumulative record w change points in top panel;
% estimated intervent intervals in bottom panel

subplot(2,1,1)

stairs((0:length(FirstCum))',[0;FirstCum],'k') % Cumulative record of
% successes

xlabel('Trials')

ylabel('Cumulative Count')

hold on

plot(CP(:,1),CP(:,2),'ko') % plot change points on cumulative record
    
legend('Cumulative Record','Change Point','Location','NorthWest')

Xlm=xlim;

subplot(2,1,2) % bottom panel of first figure

stairs(CP(:,1),CP(:,4),'k')

xlim(Xlm); % making x-axis limits same as in first plot

xlabel('Trials')

ylabel('Estimated Lambda (mean count)')

%% Second figure: fits to cumulative distributions

figure % plot empirical cumulative distribution and estimated fit to it
% return

NumCP = size(CP,1)-1;

for r=1:NumCP % stepping through the change points

    if r>8; return;end

    subplot(floor((NumCP-1)/2)+1,2,r)

    SortedData=sort([FirstData(CP(r,1)+1:CP(r+1,1))]);

    % sorting data up to rth change point

    stairs([0;SortedData],(0:length(SortedData))'/(length(SortedData)),'k')

    hold on

    Xlm=xlim;

    Ylm=ylim;

    T=linspace(Xlm(1),Xlm(2),50);

    plot(T,poisscdf(T,mean(SortedData(2:end))),'r') % cumulative
    % distribution implicitly fitted to data

    xlabel('Count')

    ylabel('Cumulative Relative Frequency')

    if r==1;legend('Observed','Fitted Poisson','Location','SouthEast');legend boxoff;end

    title(['Segment ' num2str(r)])

    text(.05*(Xlm(2)-Xlm(1)),.95*(Ylm(2)-Ylm(1)),['lambda=' num2str(CP(r,4))])

end % of for loop

