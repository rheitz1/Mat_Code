%plots ERN by screen location
%Errors are when errant saccade made into screen location

function [] = ERNSL(AD,Bundle,flag)

if nargin < 3
    flag = 0; %flag == 1 if want to find onset times
end

Plot_Time = [-100 300];
Target_ = Bundle.Target_;
SRT = Bundle.SRT;
Correct_ = Bundle.Correct_;
Errors_ = Bundle.Errors_;
SaccDir_ = Bundle.SaccDir_;

fixErrors
%Median SRT of correct trials
% cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000)),1);
% eMed = nanmedian(SRT(find(Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000)),1);
all_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
all_err = find(Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);

pos_upper_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),[1 2 3]) == 1);
pos_upper_err = find(ismember(SaccDir_(:,1),[1 2 3]) == 1 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);

pos_lower_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),[5 6 7]) == 1);
pos_lower_err = find(ismember(SaccDir_(:,1),[5 6 7]) == 1 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);

%response align, DO truncate at 2nd saccade
AD_resp = response_align(AD,SRT,[Plot_Time(1) Plot_Time(2)],1);

%baseline correct
AD_resp = baseline_correct(AD_resp,[1 100]);

%step through target screen positions and convert to subplot coordinates
fig
for j = 0:8 % j == 8 will be center of graph, which is average across all screen locations
    switch j
        case 0
            trls_corr = pos0_corr;
            trls_err = pos0_err;
            screenloc = 6;
        case 1
            trls_corr = pos1_corr;
            trls_err = pos1_err;
            screenloc = 3;
        case 2
            trls_corr = pos2_corr;
            trls_err = pos2_err;
            screenloc = 2;
        case 3
            trls_corr = pos3_corr;
            trls_err = pos3_err;
            screenloc = 1;
        case 4
            trls_corr = pos4_corr;
            trls_err = pos4_err;
            screenloc = 4;
        case 5
            trls_corr = pos5_corr;
            trls_err = pos5_err;
            screenloc = 7;
        case 6
            trls_corr = pos6_corr;
            trls_err = pos6_err;
            screenloc = 8;
        case 7
            trls_corr = pos7_corr;
            trls_err = pos7_err;
            screenloc = 9;
        case 8
            trls_corr = all_corr;
            trls_err = all_err;
            screenloc = 5;
    end
    
    %equate number of trials
    if length(trls_corr) > length(trls_err)
        trls_corr = trls_corr(randperm(length(trls_err)));
    elseif length(trls_err) > length(trls_corr)
        trls_err = trls_err(randperm(length(trls_corr)));
    end
    
    %get onset times using Wilcoxon rank-sum tests, 10 consecutive
    %significant bins, p < .01
    if flag == 1
        if ~isempty(trls_corr)
            for time = 100:size(AD_resp,2)
                [p(time),h(time)] = ranksum(AD_resp(trls_corr,time),AD_resp(trls_err,time),'alpha',.01);
                %consider only values at time 0 or beyond, not prestimulus
                %interval
                Onset = min(findRuns(h(100:end),10));
            end
        else
            Onset = [];
        end
    else
        Onset = [];
    end
    subplot(3,3,screenloc)
    
    plot(Plot_Time(1):Plot_Time(2),nanmean(AD_resp(trls_corr,:)),'k',Plot_Time(1):Plot_Time(2),nanmean(AD_resp(trls_err,:)),'--k',Plot_Time(1):Plot_Time(2),(nanmean(AD_resp(trls_err,:)) - nanmean(AD_resp(trls_corr,:))),'r')
    axis ij
    title(['nCorr = ' mat2str(length(trls_corr)) ' nErr = ' mat2str(length(trls_err)) ' Onset = ' mat2str(Onset)],'fontsize',12,'fontweight','bold')
    
    xlim([Plot_Time(1) Plot_Time(2)]);
    vline(0,'k')
    
    if ~isempty(Onset)
        vline(Onset,'b')
        clear Onset)
    end
    
    set(gca,'fontsize',12)
end


[ax,h1] = suplabel('Time from Target');
set(h1,'fontsize',14,'fontweight','bold')
[ax,h1] = suplabel('mV','y');
set(h1,'fontsize',14,'fontweight','bold')
end
