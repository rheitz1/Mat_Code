%============================================
%
% NON-SAT TASK
%============================================

cd /volumes/Dump/Search_Data_longBase/
[file_list] = dir('Q*SEARCH.mat');


ALLDATA_crt.all = [];
ALLDATA_err.all = [];


for file = 1:length(file_list)
    file_list(file).name
    disp(['Analyzing file #' mat2str(file) ' out of ' mat2str(length(file_list))])
    
    [currDATA_crt currDATA_err] = compileFano_vis_optimality(file_list(file).name);
    
    ALLDATA_crt.all = [ALLDATA_crt.all ; currDATA_crt.all];
    ALLDATA_err.all = [ALLDATA_err.all ; currDATA_err.all];

    
    clear currDATA
end

est_times = -100:100;
[p_crt S_crt] = polyfit(ALLDATA_crt.all(:,1),ALLDATA_crt.all(:,2),2);
[p_err S_err] = polyfit(ALLDATA_err.all(:,1),ALLDATA_err.all(:,2),2);
[Y_crt] = polyval(p_crt,est_times,S_crt);
[Y_err] = polyval(p_err,est_times,S_err);

fig1
scatter(ALLDATA_crt.all(:,1),ALLDATA_crt.all(:,2),'sizedata',1)
hold
plot(est_times,Y_crt,'k','linewidth',2)
xlim([-100 100])

fig2
scatter(ALLDATA_err.all(:,1),ALLDATA_err.all(:,2),'sizedata',1)
hold
plot(est_times,Y_err,'k','linewidth',2)
xlim([-100 100])






%============================================
%
% SAT TASK
%============================================
% % % cd /volumes/Dump/Search_Data_SAT_longBase/
% % % 
% % % [file_list] = dir('*SEARCH.mat');
% % % 
% % % 
% % % ALLDATA_crt.slow = [];
% % % ALLDATA_crt.fast = [];
% % % ALLDATA_err.slow = [];
% % % ALLDATA_err.fast = [];
% % % 
% % % for file = 1:length(file_list)
% % %     file_list(file).name
% % %     disp(['Analyzing file #' mat2str(file) ' out of ' mat2str(length(file_list))])
% % %     
% % %     [currDATA_crt currDATA_err] = compileFano_vis_optimality(file_list(file).name);
% % %     
% % %     ALLDATA_crt.slow = [ALLDATA_crt.slow ; currDATA_crt.slow];
% % %     ALLDATA_crt.fast = [ALLDATA_crt.fast ; currDATA_crt.fast];
% % %     ALLDATA_err.slow = [ALLDATA_err.slow ; currDATA_err.slow];
% % %     ALLDATA_err.fast = [ALLDATA_err.fast ; currDATA_err.fast];
% % %     
% % %     
% % %     clear currDATA_crt currDATA_err
% % % end
% % % 
% % % 
% % % [p_crt.slow S_crt.slow] = polyfit(ALLDATA_crt.slow(:,1),ALLDATA_crt.slow(:,2),2);
% % % [p_crt.fast S_crt.fast] = polyfit(ALLDATA_crt.fast(:,1),ALLDATA_crt.fast(:,2),2);
% % % [p_err.slow S_err.slow] = polyfit(ALLDATA_err.slow(:,1),ALLDATA_err.slow(:,2),2);
% % % [p_err.fast S_err.fast] = polyfit(ALLDATA_err.fast(:,1),ALLDATA_err.fast(:,2),2);
% % % 
% % % est_times = -100:100;
% % % [Y_crt.slow] = polyval(p_crt.slow,est_times,S_crt.slow);
% % % [Y_crt.fast] = polyval(p_crt.fast,est_times,S_crt.fast);
% % % [Y_err.slow] = polyval(p_err.slow,est_times,S_err.slow);
% % % [Y_err.fast] = polyval(p_err.fast,est_times,S_err.fast);
% % % 
% % % fig1
% % % subplot(121)
% % % scatter(ALLDATA_crt.slow(:,1),ALLDATA_crt.slow(:,2),'fillcolor','r','sizedata',1)
% % % hold
% % % plot(est_times,Y_crt.slow,'k','linewidth',2)
% % % xlim([-100 100])
% % % 
% % % subplot(122)
% % % scatter(ALLDATA_crt.fast(:,1),ALLDATA_crt.fast(:,2),'fillcolor','g','sizedata',1)
% % % hold
% % % plot(est_times,Y_crt.fast,'k','linewidth',2)
% % % xlim([-100 100])
% % % 
% % % fig2
% % % subplot(121)
% % % scatter(ALLDATA_err.slow(:,1),ALLDATA_err.slow(:,2),'fillcolor','r','sizedata',1)
% % % hold
% % % plot(est_times,Y_err.slow,'k','linewidth',2)
% % % xlim([-100 100])
% % % 
% % % subplot(122)
% % % scatter(ALLDATA_err.fast(:,1),ALLDATA_err.fast(:,2),'fillcolor','g','sizedata',1)
% % % hold
% % % plot(est_times,Y_err.fast,'k','linewidth',2)
% % % xlim([-100 100])
