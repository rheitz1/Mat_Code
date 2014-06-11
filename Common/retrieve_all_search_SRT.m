%retrieve SRT from all search files

batch_list = dir('/volumes/dump/Search_Data/*_SEARCH.mat');
q='''';c=',';qcq=[q c q];
file_path = '/volumes/dump/Search_Data/';
plotFlag = 0;

for i = 1:length(batch_list)
    eval(['load(',q,file_path,batch_list(i).name,qcq,'SRT',qcq,'Correct_',qcq,'Errors_',qcq,'Target_',qcq,'newfile',q,')'])
    fixErrors
    batch_list(i).name
    
    getBEH
    getMonk
    
    BEH_all(1:3,1:7,i) = BEH;
    BEH_CDF_correct_all(1:30,1:7,1:2,i) = BEH_CDF_correct;
    BEH_CDF_errors_all(1:30,1:7,1:2,i) = BEH_CDF_errors;
    monkeyMat(i,1) = monkey;
    
    keep batch_list q c qcq file_path plotFlag BEH_all BEH_CDF_correct_all BEH_CDF_errors_all monkeyMat
end
%
% %plot CDFs
% [CDF_correct bins_correct] = getCDF(allSRTmeans_correct,30);
% [CDF_errors bins_errors] = getCDF(allSRTmeans_errors,30);
% [CDF_ss2 bins_ss2] = getCDF(allSRTmeans_ss2,30);
% [CDF_ss4 bins_ss4] = getCDF(allSRTmeans_ss4,30);
% [CDF_ss8 bins_ss8] = getCDF(allSRTmeans_ss8,30);
%
% figure
% hold
% plot(bins_correct,CDF_correct,'k',bins_errors,CDF_errors,'--k',bins_ss2,CDF_ss2,'r',bins_ss4,CDF_ss4,'g',bins_ss8,CDF_ss8,'b')
% legend('Correct','Errors','SS2','SS4','SS8')
%
% disp(['Correct: ' mat2str(nanmean(allSRTmeans_correct))])
% disp(['Errors: ' mat2str(nanmean(allSRTmeans_errors))])
% disp(['SS2: ' mat2str(nanmean(allSRTmeans_ss2))])
% disp(['SS4: ' mat2str(nanmean(allSRTmeans_ss4))])
% disp(['SS8: ' mat2str(nanmean(allSRTmeans_ss8))])
if plotFlag == 1
   
    seymour = find(monkeyMat == 'S');
    quincy = find(monkeyMat == 'Q');
    
    QCDF.correct = BEH_CDF_correct_all(:,:,:,quincy);
    QCDF.errors = BEH_CDF_errors_all(:,:,:,quincy);
    SCDF.correct = BEH_CDF_correct_all(:,:,:,seymour);
    SCDF.errors = BEH_CDF_correct_all(:,:,:,quincy);
    
    QACC.ss2 = removeNaN(squeeze(BEH_all(3,3,quincy)));
    QACC.ss4 = removeNaN(squeeze(BEH_all(3,4,quincy)));
    QACC.ss8 = removeNaN(squeeze(BEH_all(3,5,quincy)));
    
    SACC.ss2 = removeNaN(squeeze(BEH_all(3,3,seymour)));
    SACC.ss4 = removeNaN(squeeze(BEH_all(3,4,seymour)));
    SACC.ss8 = removeNaN(squeeze(BEH_all(3,5,seymour)));
    
    q.correct.ss2 = squeeze(BEH_all(1,3,quincy));
    q.correct.ss4 = squeeze(BEH_all(1,4,quincy));
    q.correct.ss8 = squeeze(BEH_all(1,5,quincy));
    s.correct.ss2 = squeeze(BEH_all(1,3,seymour));
    s.correct.ss4 = squeeze(BEH_all(1,4,seymour));
    s.correct.ss8 = squeeze(BEH_all(1,5,seymour));
    q.errors.ss2 = squeeze(BEH_all(2,3,quincy));
    q.errors.ss4 = squeeze(BEH_all(2,4,quincy));
    q.errors.ss8 = squeeze(BEH_all(2,5,quincy));
    s.errors.ss2 = squeeze(BEH_all(2,3,seymour));
    s.errors.ss4 = squeeze(BEH_all(2,4,seymour));
    s.errors.ss8 = squeeze(BEH_all(2,5,seymour));
    
    [qbins.correct.ss2 qcdf.correct.ss2] = getCDF(q.correct.ss2,30);
    [qbins.correct.ss4 qcdf.correct.ss4] = getCDF(q.correct.ss4,30);
    [qbins.correct.ss8 qcdf.correct.ss8] = getCDF(q.correct.ss8,30);
    [qbins.errors.ss2 qcdf.errors.ss2] = getCDF(q.errors.ss2,30);
    [qbins.errors.ss4 qcdf.errors.ss4] = getCDF(q.errors.ss4,30);
    [qbins.errors.ss8 qcdf.errors.ss8] = getCDF(q.errors.ss8,30);
    [sbins.correct.ss2 scdf.correct.ss2] = getCDF(s.correct.ss2,30);
    [sbins.correct.ss4 scdf.correct.ss4] = getCDF(s.correct.ss4,30);
    [sbins.correct.ss8 scdf.correct.ss8] = getCDF(s.correct.ss8,30);
    [sbins.errors.ss2 scdf.errors.ss2] = getCDF(s.errors.ss2,30);
    [sbins.errors.ss4 scdf.errors.ss4] = getCDF(s.errors.ss4,30);
    [sbins.errors.ss8 scdf.errors.ss8] = getCDF(s.errors.ss8,30);
    
    
    figure
    plot(qbins.correct.ss2,qcdf.correct.ss2,'b',qbins.correct.ss4,qcdf.correct.ss4,'r', ...
        qbins.correct.ss8,qcdf.correct.ss8,'g',qbins.errors.ss2,qcdf.errors.ss2,'--b', ...
        qbins.errors.ss4,qcdf.errors.ss4,'--r',qbins.errors.ss8,qcdf.errors.ss8,'--g')
    title('Quincy')
    
    figure
    plot(sbins.correct.ss2,scdf.correct.ss2,'b',sbins.correct.ss4,scdf.correct.ss4,'r', ...
        sbins.correct.ss8,scdf.correct.ss8,'g',sbins.errors.ss2,scdf.errors.ss2,'--b', ...
        sbins.errors.ss4,scdf.errors.ss4,'--r',sbins.errors.ss8,scdf.errors.ss8,'--g')
    title('Seymour')
    
    
    qsem.ss2 = nanstd(QACC.ss2) / sqrt(length(QACC.ss2));
    qsem.ss4 = nanstd(QACC.ss4) / sqrt(length(QACC.ss4));
    qsem.ss8 = nanstd(QACC.ss8) / sqrt(length(QACC.ss8));

    ssem.ss2 = nanstd(SACC.ss2) / sqrt(length(SACC.ss2));
    ssem.ss4 = nanstd(SACC.ss4) / sqrt(length(SACC.ss4));
    ssem.ss8 = nanstd(SACC.ss8) / sqrt(length(SACC.ss8));
    
    figure
    errorbar([1 2 3],[1-nanmean(QACC.ss2) 1-nanmean(QACC.ss4) 1-nanmean(QACC.ss8)],[qsem.ss2 qsem.ss4 qsem.ss8],'+b')
    hold on
    bar([1 2 3],[1-nanmean(QACC.ss2) 1-nanmean(QACC.ss4) 1-nanmean(QACC.ss8)])
    title('Quincy Error Rate')
    ylim([0 1])
    
        figure
    errorbar([1 2 3],[1-nanmean(SACC.ss2) 1-nanmean(SACC.ss4) 1-nanmean(SACC.ss8)],[ssem.ss2 ssem.ss4 ssem.ss8],'+b')
    hold on
    bar([1 2 3],[1-nanmean(SACC.ss2) 1-nanmean(SACC.ss4) 1-nanmean(SACC.ss8)])
    title('Seymour Error Rate')
    ylim([0 1])
    %
    %     qSetSizeRT_corr = BEH_all(1,3:5,quincy);
    %     sSetSizeRT_corr = BEH_all(1,3:5,seymour);
    %
    %     qCDF_corr_all = BEH_all(1,1,quincy);
    %     qCDF_corr_all = qCDF_corr_all(~isnan(qCDF_corr_all));
    %     [qBins_corr_all,qCDF_corr_all,] = getCDF(qCDF_corr_all,30);
    %
    %     qCDF_err_all = BEH_all(1,2,quincy);
    %     qCDF_err_all = qCDF_err_all(~isnan(qCDF_err_all));
    %     [qBins_err_all,qCDF_err_all] = getCDF(qCDF_err_all,30);
    %
    %     sCDF_corr_all = BEH_all(1,1,seymour);
    %     sCDF_corr_all = sCDF_corr_all(~isnan(sCDF_corr_all));
    %     [sBins_corr_all,sCDF_corr_all] = getCDF(sCDF_corr_all,30);
    %
    %     sCDF_err_all = BEH_all(1,2,seymour);
    %     sCDF_err_all = sCDF_err_all(~isnan(sCDF_err_all));
    %     [sBins_err_all,sCDF_err_all] = getCDF(sCDF_err_all,30);
    %
    %
    %     qCDF_corr_ss2 = BEH_all(1,3,quincy);
    %     qCDF_corr_ss2 = qCDF_corr_ss2(~isnan(qCDF_corr_ss2));
    %     [qBins_corr_ss2,qCDF_corr_ss2] = getCDF(qCDF_corr_ss2,30);
    %
    %     qCDF_corr_ss4 = BEH_all(1,4,quincy);
    %     qCDF_corr_ss4 = qCDF_corr_ss4(~isnan(qCDF_corr_ss4));
    %     [qBins_corr_ss4,qCDF_corr_ss4] = getCDF(qCDF_corr_ss4,30);
    %
    %     qCDF_corr_ss8 = BEH_all(1,5,quincy);
    %     qCDF_corr_ss8 = qCDF_corr_ss8(~isnan(qCDF_corr_ss8));
    %     [qBins_corr_ss8,qCDF_corr_ss8] = getCDF(qCDF_corr_ss8,30);
    %
    %     sCDF_corr_ss2 = BEH_all(1,3,seymour);
    %     sCDF_corr_ss2 = sCDF_corr_ss2(~isnan(sCDF_corr_ss2));
    %     [sBins_corr_ss2,sCDF_corr_ss2] = getCDF(sCDF_corr_ss2,30);
    %
    %     sCDF_corr_ss4 = BEH_all(1,4,seymour);
    %     sCDF_corr_ss4 = sCDF_corr_ss4(~isnan(sCDF_corr_ss4));
    %     [sBins_corr_ss4,sCDF_corr_ss4] = getCDF(sCDF_corr_ss4,30);
    %
    %     sCDF_corr_ss8 = BEH_all(1,5,seymour);
    %     sCDF_corr_ss8 = sCDF_corr_ss8(~isnan(sCDF_corr_ss8));
    %     [sBins_corr_ss8,sCDF_corr_ss8] = getCDF(sCDF_corr_ss8,30);
    %
    %
    %
    %     %set size accuracy rates
    %     qACC = nanmean(BEH_all(2,3:5,quincy),3);
    %     sACC = nanmean(BEH_all(2,3:5,seymour),3);
    %     ACC = [qACC;sACC];
    %
    %
    %
    %     subplot(2,2,1)
    %     plot(1:3,nanmean(qSetSizeRT_corr,3),'b',1:3,nanmean(sSetSizeRT_corr,3),'r','linewidth',2)
    %     h = legend('Quincy','Seymour','location','northwest');
    %     set(h,'fontsize',12)
    %     legend('boxoff')
    %     set(gca,'xtick',1:3)
    %     set(gca,'xticklabel',[2 4 8])
    %     xlim([.5 3.5])
    %     xlim([.8 3.2])
    %     ylabel('Mean RT','fontsize',12)
    %     xlabel('Set Size','fontsize',12)
    %
    %     subplot(2,2,2)
    %     plot(qBins_corr_all,qCDF_corr_all,'b',sBins_corr_all,sCDF_corr_all,'r',qBins_err_all,qCDF_err_all,'--b',sBins_err_all,sCDF_err_all,'--r','linewidth',2)
    %     h = legend('Q Correct','S Correct','Q Errors','S Errors','location','southeast');
    %     legend('boxoff')
    %     set(h,'fontsize',12)
    %     xlabel('RT','fontsize',12)
    %     ylabel('Cumulative Probability','fontsize',12)
    %
    %     subplot(2,2,3)
    %     h = bar(ACC');
    %     set(h(1),'facecolor','b')
    %     set(h(2),'facecolor','r')
    %     % h = legend('Quincy','Seymour');
    %     % set(h,'fontsize',12)
    %     % legend('boxoff')
    %     set(gca,'xticklabel',[2 4 8])
    %     xlabel('Set Size','fontsize',12)
    %     ylabel('Percent Correct','fontsize',12)
    %
    %     subplot(2,2,4)
    %     plot(qBins_corr_ss2,qCDF_corr_ss2,'b',qBins_corr_ss4,qCDF_corr_ss4,'--b',qBins_corr_ss8,qCDF_corr_ss8,':b',sBins_corr_ss2,sCDF_corr_ss2,'r',sBins_corr_ss4,sCDF_corr_ss4,'--r',sBins_corr_ss8,sCDF_corr_ss8,':r','linewidth',2)
    %     h = legend('Q SS2','Q SS4','Q SS8','S SS2','S SS4','S SS8','location','southeast');
    %     set(h,'fontsize',12)
    %     legend('boxoff')
    %     xlabel('RT','fontsize',12)
    %     ylabel('Cumulative Probability','fontsize',12)
end

% clear plotFlag seymour quincy qSetSizeRT_corr qCDF_corr_all qBins_corr_all ...
%     qCDF_err_all qBins_err_all sCDF_corr_all sBins_corr_all sCDF_err_all ...
%     sBins_err_all qCDF_corr_ss2 qBins_corr_ss2 qCDF_corr_ss4 qBins_corr_ss4 ...
%     qCDF_corr_ss8 qBins_corr_ss8 sCDF_corr_ss2 sBins_corr_ss2 sCDF_corr_ss4 ...
%     sBins_corr_ss4 sCDF_corr_ss8 sBins_corr_ss8

