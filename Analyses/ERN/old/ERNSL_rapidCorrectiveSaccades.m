%plots ERN by screen location
%Errors are when errant saccade made into screen location

function [] = ERNSL_rapidCorrectiveSaccades(AD,Bundle,flag)

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

%calculate SRT of next saccade
nextSacc = SRT(:,2) - SRT(:,1);
%remove nextSacc if it is <= 80 ms (2nd saccade too fast to be real
nextSacc(find(nextSacc <= 80)) = NaN;

%what will be the cutoff for a 'rapid corrective saccade?'
rapidtime = 300;


%Median SRT of correct trials
% cMed = nanmedian(SRT(find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000)),1);
% eMed = nanmedian(SRT(find(Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000)),1);
all_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
all_err = find(Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
all_err_rapid = find(Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc < rapidtime);
all_err_slow = find(Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc >= rapidtime);

pos0_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),0) == 1);
pos0_err = find(SaccDir_(:,1) == 0 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
pos0_err_rapid = find(SaccDir_(:,1) == 0 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc < rapidtime);
pos0_err_slow = find(SaccDir_(:,1) == 0 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc >= rapidtime);

pos1_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),1) == 1);
pos1_err = find(SaccDir_(:,1) == 1 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
pos1_err_rapid = find(SaccDir_(:,1) == 1 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc < rapidtime);
pos1_err_slow = find(SaccDir_(:,1) == 1 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc >= rapidtime);

pos2_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),2) == 1);
pos2_err = find(SaccDir_(:,1) == 2 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
pos2_err_rapid = find(SaccDir_(:,1) == 2 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc < rapidtime);
pos2_err_slow = find(SaccDir_(:,1) == 2 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc >= rapidtime);

pos3_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),3) == 1);
pos3_err = find(SaccDir_(:,1) == 3 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
pos3_err_rapid = find(SaccDir_(:,1) == 3 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc < rapidtime);
pos3_err_slow = find(SaccDir_(:,1) == 3 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc >= rapidtime);

pos4_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),4) == 1);
pos4_err = find(SaccDir_(:,1) == 4 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
pos4_err_rapid = find(SaccDir_(:,1) == 4 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc < rapidtime);
pos4_err_slow = find(SaccDir_(:,1) == 4 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc >= rapidtime);

pos5_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),5) == 1);
pos5_err = find(SaccDir_(:,1) == 5 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
pos5_err_rapid = find(SaccDir_(:,1) == 5 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc < rapidtime);
pos5_err_slow = find(SaccDir_(:,1) == 5 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc >= rapidtime);

pos6_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),6) == 1);
pos6_err = find(SaccDir_(:,1) == 6 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
pos6_err_rapid = find(SaccDir_(:,1) == 6 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc < rapidtime);
pos6_err_slow = find(SaccDir_(:,1) == 6 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc >= rapidtime);

pos7_corr = find(Correct_(:,2) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & ismember(Target_(:,2),7) == 1);
pos7_err = find(SaccDir_(:,1) == 7 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255);
pos7_err_rapid = find(SaccDir_(:,1) == 7 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc < rapidtime);
pos7_err_slow = find(SaccDir_(:,1) == 7 & Errors_(:,5) == 1 & SRT(:,1) > 50 & SRT(:,1) < 2000 & Target_(:,2) ~= 255 & nextSacc >= rapidtime);

%response align, DO truncate at 2nd saccade
AD_resp = response_align(AD,SRT,[Plot_Time(1) Plot_Time(2)],1,rapidtime);

%baseline correct
AD_resp = baseline_correct(AD_resp,[1 100]);

%step through target screen positions and convert to subplot coordinates
fig
for j = 0:8 % j == will be center of graph, which is average across all screen locations
    switch j
        case 0
            trls_corr = pos0_corr;
            trls_err = pos0_err;
            trls_err_rapid = pos0_err_rapid;
            trls_err_slow = pos0_err_slow;
            screenloc = 6;
        case 1
            trls_corr = pos1_corr;
            trls_err = pos1_err;
            trls_err_rapid = pos1_err_rapid;
            trls_err_slow = pos1_err_slow;
            screenloc = 3;
        case 2
            trls_corr = pos2_corr;
            trls_err = pos2_err;
            trls_err_rapid = pos2_err_rapid;
            trls_err_slow = pos2_err_slow;
            screenloc = 2;
        case 3
            trls_corr = pos3_corr;
            trls_err = pos3_err;
            trls_err_rapid = pos3_err_rapid;
            trls_err_slow = pos3_err_slow;
            screenloc = 1;
        case 4
            trls_corr = pos4_corr;
            trls_err = pos4_err;
            trls_err_rapid = pos4_err_rapid;
            trls_err_slow = pos4_err_slow;
            screenloc = 4;
        case 5
            trls_corr = pos5_corr;
            trls_err = pos5_err;
            trls_err_rapid = pos5_err_rapid;
            trls_err_slow = pos5_err_slow;
            screenloc = 7;
        case 6
            trls_corr = pos6_corr;
            trls_err = pos6_err;
            trls_err_rapid = pos6_err_rapid;
            trls_err_slow = pos6_err_slow;
            screenloc = 8;
        case 7
            trls_corr = pos7_corr;
            trls_err = pos7_err;
            trls_err_rapid = pos7_err_rapid;
            trls_err_slow = pos7_err_slow;
            screenloc = 9;
        case 8
            trls_corr = all_corr;
            trls_err = all_err;
            screenloc = 5;
    end
    
    %equate number of trials
%    lowest = min(min(length(trls_corr),length(trls_err_rapid)),length(trls_err_slow));
%    trls_corr = trls_corr(randperm(lowest));
%    trls_err_rapid = trls_err_rapid(randperm(lowest));
%    trls_err_slow = trls_err_slow(randperm(lowest));
    
%     if length(trls_corr) > length(trls_err)
%         trls_corr = trls_corr(randperm(length(trls_err)));
%     elseif length(trls_err) > length(trls_corr)
%         trls_err = trls_err(randperm(length(trls_corr)));
%     end
    
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
    
    plot(Plot_Time(1):Plot_Time(2),nanmean(AD_resp(trls_corr,:)),'b',Plot_Time(1):Plot_Time(2),nanmean(AD_resp(trls_err_rapid,:)),'r',Plot_Time(1):Plot_Time(2),nanmean(AD_resp(trls_err_slow,:)),'--r')
    axis ij
    %title(['nCorr = ' mat2str(length(trls_corr)) ' nErr = ' mat2str(length(trls_err)) ' Onset = ' mat2str(Onset)],'fontsize',12,'fontweight','bold')
    if screenloc == 5
        legend('Correct','Errors Rapid Correction','Errors Slow Correction')
    end
    
    
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
