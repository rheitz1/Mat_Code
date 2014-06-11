% Computes & optionally plots Ratcliff-style quantil-probability plots
%
% varargin is sequences of condition variabiles you want to split by in format:
%   [SRT ACC]
%
% ENTER VARIABLES IN ORDER OF DIFFICULTY (E.G., SS2, SS4, THEN SS8)
%
% Along with Ratcliff, quantiles will be: 0.1, 0.3, 0.5, 0.7, 0.9
%
% RPH

function [Response_Probability Quantile_RTs] = quantile_prob(varargin)

plotFlag = 1;

for var = 1:size(varargin,2)
    rt = varargin{var}(:,1);
    acc = varargin{var}(:,2);
    
    macc(var,1) = nanmean(acc);
    RTs.correct = rt(find(acc == 1));
    RTs.error = rt(find(acc == 0));
    
    
    ntiles.correct(var,1:5) = prctile(RTs.correct,[10 30 50 70 90]);
    ntiles.error(var,1:5) = prctile(RTs.error,[10 30 50 70 90]);

    %=======
    % For use in generating Heitz-Schall plot (combines SATF, CAF, and QPP)
    % use the following in place during plotting:
    % z = [1-nAcc' fliplr(nAcc')]
    % plot(z',Quantile_RTs','-o')
%     ntiles.all(var,1:5) = prctile(rt,[10 30 50 70 90]);
%     nc1 = find(acc == 1 & rt <= ntiles.all(var,1));
%     nc2 = find(acc == 1 & rt > ntiles.all(var,1) & rt <= ntiles.all(var,2));
%     nc3 = find(acc == 1 & rt > ntiles.all(var,2) & rt <= ntiles.all(var,3));
%     nc4 = find(acc == 1 & rt > ntiles.all(var,3) & rt <= ntiles.all(var,4));
%     nc5 = find(acc == 1 & rt > ntiles.all(var,4) & rt <= ntiles.all(var,5));
%     
%     ne1 = find(acc == 0 & rt <= ntiles.all(var,1));
%     ne2 = find(acc == 0 & rt > ntiles.all(var,1) & rt <= ntiles.all(var,2));
%     ne3 = find(acc == 0 & rt > ntiles.all(var,2) & rt <= ntiles.all(var,3));
%     ne4 = find(acc == 0 & rt > ntiles.all(var,3) & rt <= ntiles.all(var,4));
%     ne5 = find(acc == 0 & rt > ntiles.all(var,4) & rt <= ntiles.all(var,5)); %exclude last quantile
%     
%     nAcc(var,1:5) = [length(nc1) / (length(nc1) + length(ne1)) ...
%         length(nc2) / (length(nc2) + length(ne2)) ...
%         length(nc3) / (length(nc3) + length(ne3)) ...
%         length(nc4) / (length(nc4) + length(ne4)) ...
%         length(nc5) / (length(nc5) + length(ne5))];



% RTs are split up on each distribution (correct/error) separately.  Accuracy rates for each
% quantile must then also be split up according to those RTs.  If we instead split the entire RTD
% for both correct and error trials (together) and then calculated RT, we are mixing and matching
% accuracy rates that do not correspond to the appropriate RTs
    
% %     nc1 = length(find(acc == 1 & rt <= ntiles.correct(var,1))) / (length(find(acc == 1 & rt <= ntiles.correct(var,1))) + length(find(acc == 0 & rt <= ntiles.correct(var,1))));
% %     nc2 = length(find(acc == 1 & rt > ntiles.correct(var,1) & rt <= ntiles.correct(var,2))) / (length(find(acc == 1 & rt > ntiles.correct(var,1) & rt <= ntiles.correct(var,2))) + length(find(acc == 0 & rt > ntiles.correct(var,1) & rt <= ntiles.correct(var,2))));
% %     nc3 = length(find(acc == 1 & rt > ntiles.correct(var,2) & rt <= ntiles.correct(var,3))) / (length(find(acc == 1 & rt > ntiles.correct(var,2) & rt <= ntiles.correct(var,3))) + length(find(acc == 0 & rt > ntiles.correct(var,2) & rt <= ntiles.correct(var,3))));
% %     nc4 = length(find(acc == 1 & rt > ntiles.correct(var,3) & rt <= ntiles.correct(var,4))) / (length(find(acc == 1 & rt > ntiles.correct(var,3) & rt <= ntiles.correct(var,4))) + length(find(acc == 0 & rt > ntiles.correct(var,3) & rt <= ntiles.correct(var,4))));
% %     nc5 = length(find(acc == 1 & rt > ntiles.correct(var,4) & rt <= ntiles.correct(var,5))) / (length(find(acc == 1 & rt > ntiles.correct(var,4) & rt <= ntiles.correct(var,5))) + length(find(acc == 0 & rt > ntiles.correct(var,4) & rt <= ntiles.correct(var,5))));
% %     
% %     
% %     ne1 = length(find(acc == 1 & rt <= ntiles.error(var,1))) / (length(find(acc == 1 & rt <= ntiles.error(var,1))) + length(find(acc == 0 & rt <= ntiles.error(var,1))));
% %     ne2 = length(find(acc == 1 & rt > ntiles.error(var,1) & rt <= ntiles.error(var,2))) / (length(find(acc == 1 & rt > ntiles.error(var,1) & rt <= ntiles.error(var,2))) + length(find(acc == 0 & rt > ntiles.error(var,1) & rt <= ntiles.error(var,2))));
% %     ne3 = length(find(acc == 1 & rt > ntiles.error(var,2) & rt <= ntiles.error(var,3))) / (length(find(acc == 1 & rt > ntiles.error(var,2) & rt <= ntiles.error(var,3))) + length(find(acc == 0 & rt > ntiles.error(var,2) & rt <= ntiles.error(var,3))));
% %     ne4 = length(find(acc == 1 & rt > ntiles.error(var,3) & rt <= ntiles.error(var,4))) / (length(find(acc == 1 & rt > ntiles.error(var,3) & rt <= ntiles.error(var,4))) + length(find(acc == 0 & rt > ntiles.error(var,3) & rt <= ntiles.error(var,4))));
% %     ne5 = length(find(acc == 1 & rt > ntiles.error(var,4) & rt <= ntiles.error(var,5))) / (length(find(acc == 1 & rt > ntiles.error(var,4) & rt <= ntiles.error(var,5))) + length(find(acc == 0 & rt > ntiles.error(var,4) & rt <= ntiles.error(var,5))));
% %     
% % 
% %     nAcc(var,1:10) = [1-ne1 1-ne2 1-ne3 1-ne4 1-ne5 nc5 nc4 nc3 nc2 nc1];
% %     %=========
% %     
    
    clear rt acc RTs nc* ne*
end


if plotFlag
    figure
    %subplot(121)
    Response_Probability = [1 - macc' fliplr(macc')];
    Quantile_RTs = [ntiles.error' fliplr(ntiles.correct')];
    plot(Response_Probability,Quantile_RTs,'-o')
    box off
    xlabel('Response Probability')
    ylabel('RT (ms)')
    xlim([0 1])
    
    yL = ylim;
    yL(1) = 0;
    ylim(yL)
%     
%     subplot(122)
%     Response_Probability_HS = nAcc;
%     plot(Response_Probability_HS',Quantile_RTs','-o')
%     box off
%     xlabel('Response Probability')
%     ylabel('RT (ms)')
%     xlim([0 1])
%     ylim(yL)
end
    