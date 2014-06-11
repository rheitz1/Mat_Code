% Returns Target-in vs. Distractor in TDT according to:
% Wilcoxon ranksum-tests beginning 100 ms post Target onset
% minimum of 10 consecutive significant time points with p < .01

% ASSUMES SIGNAL IS ALREADY BASELINE CORRECTED!!
%
% RPH

function [TDT] = getTDT_AD(AD,inTrials,outTrials,plotFlag,alph,numSigRuns)

Target_ = evalin('caller','Target_');

if matlabpool('size') > 1
    useParallel = 1;
else
    useParallel = 0;
end

if nargin < 6; numSigRuns = 10; end
if nargin < 5; alph = .01; end
if nargin < 4; plotFlag = 0; end


if size(AD,2) < 3001
    error('Requires full 3001 ms array')
end

Plot_Time = [-Target_(1,1) 2500];

%remove saturated trials
% AD = fixClipped(AD);

AD_in = AD(inTrials,:);
AD_out = AD(outTrials,:);

if useParallel
    
    parfor time = Target_(1,1)+100:size(AD,2)
        %remove any nan values for current time
        clean_in = AD_in(~isnan(AD_in(:,time)),time);
        clean_out = AD_out(~isnan(AD_out(:,time)),time);
        
        if ~isempty(clean_in) & ~isempty(clean_out)
            %Wilcoxon rank-sum: approximate method is orders of magnitude faster than exact
            %method; small samples will by default use exact.
            [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',alph,'method','approximate');
        else
            p(time) = NaN;
            h(time) = 0;
        end
    end
    
else
    for time = Target_(1,1)+100:size(AD,2)
        %remove any nan values for current time
        clean_in = AD_in(~isnan(AD_in(:,time)),time);
        clean_out = AD_out(~isnan(AD_out(:,time)),time);
        
        if ~isempty(clean_in) & ~isempty(clean_out)
            %Wilcoxon rank-sum: approximate method is orders of magnitude faster than exact
            %method; small samples will by default use exact.
            [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',alph,'method','approximate');
        else
            p(time) = NaN;
            h(time) = 0;
        end
    end
    
end

TDT = min(strfind(h,ones(1,numSigRuns))) - Target_(1,1);
%TDT = min(findRuns(h,numSigRuns)) - Target_(1,1)

if isempty(TDT) | TDT == 0
    TDT = NaN;
end


if plotFlag == 1
    fig
    plot(Plot_Time(1):Plot_Time(2),nanmean(AD_in),'b',Plot_Time(1):Plot_Time(2),nanmean(AD_out),'--b')
    xlim([-100 500])
    legend('inTrials','outTrials')
    axis ij
    xlabel('Time from Target','fontsize',12,'fontweight','bold')
    ylabel('mV','fontsize',12,'fontweight','bold')
    title(['TDT = ' mat2str(TDT)],'fontsize',12,'fontweight','bold')
    vline(TDT,'k')
end