% Returns Target-in vs. Distractor in TDT according to:
% Wilcoxon ranksum-tests beginning 100 ms post Target onset
% minimum of "numSigRuns" consecutive significant time points with p < "alph"
%
% Default alph = .01
% Default numSigRuns = 10

% RPH

function [TDT] = getTDT_SP(Spikes,inTrials,outTrials,plotFlag,alph,numSigRuns)

% if matlabpool('size') > 1
%     useParallel = 1; 
% else
%     useParallel = 0;
% end
parallelCheck

if nargin < 6; numSigRuns = 10; end
if nargin < 5; alph = .01; end
if nargin < 4; plotFlag = 0; end

Target_ = evalin('caller','Target_');

Align_Time(1:size(Spikes,1),1) = Target_(1,1);
Plot_Time = [-100 800];

%get single-trial SDFs
SDF = sSDF(Spikes,Align_Time,Plot_Time);

SDF_in = SDF(inTrials,:);
SDF_out = SDF(outTrials,:);


if useParallel
    parfor time = 200:size(SDF_in,2) %200 == 100 ms post stimulus onset
        %remove any nan values for current time
        clean_in = SDF_in(:,time);
        clean_in(find(isnan(clean_in))) = [];
        
        clean_out = SDF_out(:,time);
        clean_out(find(isnan(clean_out))) = [];
        
        if ~isempty(clean_in) & ~isempty(clean_out)
            %Wilcoxon rank-sum: approximate method is orders of magnitude faster than exact
            %method; small samples will by default use exact.
            [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',alph,'method','approximate');
        else
            p(time) = NaN;
            h(time) = 0;
        end
        
        
        %[p(time) h(time)] = ranksum(SDF_in(:,time),SDF_out(:,time),'alpha',.01);
    end
else
    for time = 200:size(SDF_in,2) %200 == 100 ms post stimulus onset
        %remove any nan values for current time
        clean_in = SDF_in(:,time);
        clean_in(find(isnan(clean_in))) = [];
        
        clean_out = SDF_out(:,time);
        clean_out(find(isnan(clean_out))) = [];
        
        if ~isempty(clean_in) & ~isempty(clean_out)
            %Wilcoxon rank-sum: approximate method is orders of magnitude faster than exact
            %method; small samples will by default use exact.
            [p(time) h(time)] = ranksum(clean_in,clean_out,'alpha',alph,'method','approximate');
        else
            p(time) = NaN;
            h(time) = 0;
        end
        
        
        %[p(time) h(time)] = ranksum(SDF_in(:,time),SDF_out(:,time),'alpha',.01);
    end
end


%TDT = min(findRuns(h,numSigRuns)) - abs(Plot_Time(1))
TDT = min(strfind(h,ones(1,numSigRuns))) - abs(Plot_Time(1));

if isempty(TDT)
    TDT = NaN;
end



if plotFlag == 1
    figure
    plot(Plot_Time(1):Plot_Time(2),nanmean(SDF_in),'k',Plot_Time(1):Plot_Time(2),nanmean(SDF_out),'--k','linewidth',2)
    legend('inTrials','outTrials')
    xlabel('Time from Target','fontsize',12,'fontweight','bold')
    ylabel('Spikes/s','fontsize',12,'fontweight','bold')
    title(['TDT = ' mat2str(TDT)],'fontsize',12,'fontweight','bold')
    vline(TDT,'k')
    box off
end